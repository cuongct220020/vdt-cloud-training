# gitops-training

Lab GitOps trên ArgoCD: **App-of-Apps + ApplicationSet** nhiều tầng, multi-source, **1 base Helm chart dùng chung**.
Single branch (`main`), directory-based. Tách **2 tier theo cluster**:

- **`root-nonproduction`** → quản lý **dev + staging** (apply lên ArgoCD của cluster nonprod)
- **`root-production`** → quản lý **prod** (apply lên ArgoCD của cluster prod)

> Mỗi cluster có ArgoCD riêng (per-cluster), mọi destination = in-cluster. 2 tier giống hệt nhau,
> chỉ khác **env filter** (nonproduction = dev+staging, production = prod).

## Phân tầng (mỗi tier)

```
root-<tier> (App, recurse:false → chỉ đọc 6 file cấp 1 của bootstrap/<tier>)
├── appprojects    (appset) ──► App/appproject-<proj> ──► AppProject        (wave -2)
├── platform       (appset) ──► sealed-secrets + kgateway-crds (CRDs, có SSA) (wave -1)
├── kgateway       (App)    ──► kgateway controller (v2.4.0-main, KHÔNG SSA)  (wave 0)
├── all-projects   (appset) ──► App/projectset-<proj> ──► appset của project (wave 0)
│                                   └─► workload Application (theo env của tier)
├── shared-gateway (App)    ──► Gateway shared-gw (*.duongot.work, dùng chung) (wave 1)
└── httproutes     (App)    ──► HTTPRoute đứng riêng (vd argocd) ──► shared-gw  (wave 2)
```

> kgateway controller tách khỏi `platform` appset vì cài **KHÔNG ServerSideApply** (còn CRDs **có** SSA) —
> đúng pattern cài kgateway trên ArgoCD; appset (template đồng nhất) không đặt syncOptions per-element được.

> ApplicationSet chỉ sinh được **Application**, nên "appset quản lý AppProject / quản lý appset con"
> đều dùng App-of-Apps gián tiếp: appset → App → (AppProject | ApplicationSet) manifest.

## Cấu trúc thư mục

```
main
├── root-nonproduction.yaml          # apply lên ArgoCD cluster nonprod
├── root-production.yaml             # apply lên ArgoCD cluster prod
├── bootstrap/
│   ├── nonproduction/               # production/ = bản sao, chỉ khác env filter
│   │   ├── appprojects.yaml          (appset)         ┐ 6 file cấp 1
│   │   ├── platform.yaml             (appset)         │ (root đọc, recurse:false)
│   │   ├── kgateway.yaml             (App)            │
│   │   ├── all-projects.yaml         (appset)         │
│   │   ├── shared-gateway.yaml       (App)            │
│   │   ├── httproutes.yaml           (App)            ┘
│   │   ├── appprojects/{platform,birdnet-market,mention-mate}/appproject.yaml
│   │   └── project-appsets/{birdnet-market,mention-mate}/applicationset.yaml
│   └── production/ ...
├── platform/gateway/               # shared-gw DÙNG CHUNG: GatewayParameters + Gateway *.duongot.work
├── platform/httproutes/            # HTTPRoute đứng riêng (argocd...) trỏ shared-gw
├── helm-charts/app/                 # 1 base chart duy nhất
└── apps/<project>/<app>/overlays/<env>/values.yaml
```

## Bootstrap

```bash
# trên ArgoCD của cluster nonprod
kubectl apply -f root-nonproduction.yaml
# trên ArgoCD của cluster prod
kubectl apply -f root-production.yaml
```

| Project | Apps | nonprod (dev+staging) | prod |
|---|---|---|---|
| birdnet-market | frontend, backend | 4 | 2 |
| mention-mate | app (backend+worker) | 2 | 1 |

→ **6 Application** trên cluster nonprod, **3** trên cluster prod. Application = `{project}-{app}-{env}`,
namespace = `{project}-{env}`, AppProject = `{project}`.

## Base chart `app`

1 chart cho mọi app, render theo map `components`:

- mỗi component → 1 **Deployment** (+ **Service** nếu có `port`, + **ConfigMap** nếu có `config`, + **HTTPRoute** nếu `httpRoute.enabled`)
- 1 component = single-deployment; nhiều component = multi-deployment
- **1 SealedSecret** dùng chung cho cả release; HTTPRoute gắn vào **Gateway dùng chung** `shared-gw`

Mỗi workload Application multi-source, **cả hai cùng `main`**: `source[0]` = `helm-charts/app`, `source[1]` = `values.yaml` của env (`$values`).
Cấu trúc `components` đầy đủ: xem `helm-charts/app/values.yaml`.

## Thêm mới

- **Thêm env**: tạo `apps/<project>/<app>/overlays/<env>/values.yaml` + thêm path env vào appset của project ở tier tương ứng.
- **Thêm app**: tạo `apps/<project>/<newapp>/overlays/<env>/...` (appset của project tự quét).
- **Thêm project**: thêm `apps/<newproject>/...`, `bootstrap/<tier>/appprojects/<newproject>/appproject.yaml`, `bootstrap/<tier>/project-appsets/<newproject>/applicationset.yaml` (appset cha tự quét).

## SealedSecret

Repo test đặt `sealedSecret.enabled: false` (image `traefik/whoami`). Khi cần secret thật, bật lại và seal —
scope `strict` gắn theo name+namespace, tên secret = `<release>-secret`:

```bash
./scripts/seal.sh mention-mate-dev mention-mate-app-dev-secret DB_PASSWORD=... API_KEY=...
```

## ArgoCD

Repo **public** → ArgoCD clone không cần creds. Mỗi cluster cần OCI cho kgateway:

```bash
argocd repo add cr.kgateway.dev/kgateway-dev/charts --type helm --enable-oci
```

ArgoCD **≥ 3.1** (native OCI Helm); lab pin **3.3.x**.

### HTTPRoute đứng riêng (App `httproutes`)

`bootstrap/<tier>/httproutes.yaml` GitOps hoá `platform/httproutes/` — các HTTPRoute **không** do chart
`app` sinh, đều trỏ vào gateway **dùng chung** `shared-gw`. Hiện có route ArgoCD UI
(`argocd.duongot.work` → `argocd-server`). Thêm route mới = thêm 1 manifest vào `platform/httproutes/`.

- **`server.insecure` đặt THỦ CÔNG** (không GitOps), vì argocd-server đọc param lúc khởi động và cần restart:
  ```bash
  kubectl -n argocd patch configmap argocd-cmd-params-cm --type merge -p '{"data":{"server.insecure":"true"}}'
  kubectl -n argocd rollout restart deploy argocd-server
  ```
- Vào ArgoCD qua NodePort của `shared-gw`: `kubectl -n kgateway-system get svc -l gateway.networking.k8s.io/gateway-name=shared-gw -o jsonpath='{.items[0].spec.ports[?(@.port==80)].nodePort}'`, rồi map DNS `argocd.duongot.work` → `nodeIP:nodePort`.
