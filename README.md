# shopdashboard-helm
This repository contains the Helm chart for deploying the UI helm chart on Kubernetes.

# ShopDashboard Helm Chart

Helm chart for deploying **ShopDashboard** on Kubernetes using **Blue-Green deployment** via [Argo Rollouts](https://argoproj.github.io/rollouts/).

---

## Chart Info

| Field | Value |
|---|---|
| Chart Name | `shopdashboard` |
| Chart Version | `1.0.0` |
| App Version | `v1` |
| Namespace | `ui` |

---

## Blue-Green Strategy

This chart uses Argo Rollouts with a Blue-Green strategy.

| Service | Purpose |
|---|---|
| `shopdashboard-active` | Serves live production traffic |
| `shopdashboard-preview` | Serves staging/preview traffic |

- **Auto-promotion** is disabled by default — a manual promotion step is required.
- Once promoted, the old (blue) version scales down after **30 seconds**.
- Last **3 revisions** are retained for rollback.

### How it works

1. A new image is deployed → it starts on the **preview** service (`/staging`).
2. You verify the new version at `https://ui.shopdashboard.online/staging`.
3. Manually promote → traffic shifts to the **active** service (`/`).
4. Old version scales down automatically.

---

## Ingress

| Path | Routed To |
|---|---|
| `/` | `shopdashboard-active` (live) |
| `/staging` | `shopdashboard-preview` (new version) |

- Host: `ui.shopdashboard.online`
- Ingress class: `azure-application-gateway`
- TLS enabled via secret: `shopdashboard-tls`

---

## Deploy

```bash
# Install
helm install shopdashboard ./shopdashboard-helm -f dev.values.yaml -n ui

# Upgrade (triggers a blue-green rollout)
helm upgrade shopdashboard ./shopdashboard-helm -f dev.values.yaml -n ui

# Manually promote after verifying preview
kubectl argo rollouts promote shopdashboard -n ui

# Rollback if needed
kubectl argo rollouts undo shopdashboard -n ui
```

---

## Prerequisites

- Kubernetes cluster with **Argo Rollouts** installed
- **Azure Application Gateway Ingress Controller** configured
- ACR image pull secret: `acr-secret`
- TLS secret: `shopdashboard-tls`