#!/usr/bin/env bash
# Sinh ciphertext cho values.yaml bằng kubeseal (scope strict mặc định).
# Dùng: ./scripts/seal.sh <namespace> <secret-name> KEY=VALUE [KEY=VALUE...]
# Ví dụ: ./scripts/seal.sh mention-mate-dev mention-mate-mention-mate-app-dev-secret DB_PASSWORD=s3cr3t API_KEY=abc
set -euo pipefail
NS="${1:?namespace}"; NAME="${2:?secret name}"; shift 2
ARGS=(); for kv in "$@"; do ARGS+=(--from-literal="$kv"); done
kubectl create secret generic "$NAME" -n "$NS" "${ARGS[@]}" --dry-run=client -o yaml \
  | kubeseal --controller-name=sealed-secrets-controller \
             --controller-namespace=kube-system \
             --scope strict -o yaml \
  | yq '.spec.encryptedData'   # copy block này vào values.yaml -> sealedSecret.encryptedData
