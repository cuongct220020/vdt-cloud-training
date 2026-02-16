```
                        Internet
                            │
                            ▼
                ┌──────────────────────┐
                │     Bastion Host     │
                │  Public SSH Gateway  │
                └──────────┬───────────┘
                           │
                           ▼
                    (Private Network)
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │        Terraform (Provision)         │
        │  Create VMs + Network + Security     │
        └──────────────────┬───────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │      Linux Server Setup + Hardening  │
        │ SSH keys / UFW / Fail2Ban / Updates  │
        └──────────────────┬───────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │           VPN Access Layer           │
        │  Secure internal connectivity only   │
        └──────────────────┬───────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │         Ansible Automation           │
        │  Configure + Deploy services         │
        └──────────────────┬───────────────────┘
                           │
     ┌─────────────────────┼──────────────────────┐
     ▼                     ▼                      ▼

┌──────────────┐   ┌────────────────┐   ┌────────────────┐
│ Application  │   │ Node Exporter  │   │   Promtail     │
│ Nginx / API  │   │ Metrics Agent  │   │ Log Collector  │
└──────┬───────┘   └────────┬───────┘   └────────┬───────┘
       │                    │                    │
       └─────────────┬──────┴────────────┬───────┘
                     ▼                   ▼
              ┌───────────────┐   ┌───────────────┐
              │  Prometheus   │   │     Loki      │
              │ Metrics Store │   │   Log Store   │
              └──────┬────────┘   └──────┬────────┘
                     │                   │
                     └─────────┬─────────┘
                               ▼
                        ┌─────────────┐
                        │   Grafana   │
                        │ Dashboards  │
                        └──────┬──────┘
                               ▼
                        ┌─────────────┐
                        │ Alertmanager│
                        │Notifications│
                        └─────────────┘
```