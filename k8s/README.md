# Kubernetes deployment

This directory is the source for the running Selectel Kubernetes deployment in
`kz-1` (Almaty). Run the commands below from the repository root, with
`KUBECONFIG` pointing to the intended cluster. Application resources use the
`default` namespace. The manifests cover MongoDB, the
main site, Notes, Traefik, certificates, and inbound SMTP. FVE's application
Deployment and Service are managed separately; this repository has only its
Ingress template. Archive and Redash are not deployed here.

**Apply files individually.** Do not run `kubectl apply -n default -f k8s/`: the directory
contains both `db-bootstrap.yaml` (an unauthenticated, restore-only MongoDB)
and `db-deployment.yaml` (its authenticated replacement). It also contains an
unrendered FVE template. The image tags in the Deployments are a snapshot of
the live cluster on 2026-10-11; GitHub Actions changes the deployed images on
later releases. Check the current image before reapplying a Deployment manifest
so an older snapshot does not replace a newer release.

## Files and prerequisites

| File | Purpose |
| --- | --- |
| `data-pvc.yaml`, `db-bootstrap.yaml`, `db-deployment.yaml`, `db-service.yaml` | 40 GiB MongoDB disk, one-time restore, authenticated database, private Service |
| `nodejs-image-cache.yaml`, `nodejs-deployment.yaml`, `nodejs-service.yaml` | Main app image preloading, Deployment, private HTTP/SMTP Service |
| `notes-deployment.yaml`, `notes-service.yaml` | Static Notes site |
| `traefik-values.yaml`, `smtp-route.yaml`, `ingress.yaml` | Public HTTP/HTTPS/SMTP load balancer and routes |
| `letsencrypt-prod.yaml`, `fve-ingress.yaml.tmpl` | ACME issuer and optional, separately rendered FVE routes |
| `github-deploy-access.yaml`, `export-github-kubeconfigs.py` | Restricted credentials for GitHub deployments |

Install `kubectl`, Helm 3, and `envsubst` locally. Confirm the current context
with `kubectl config current-context` and inspect the worker and storage class
before applying anything. `data-pvc.yaml` requests `fast.kz-1`; change that
class if deploying outside this Selectel region. Creating the PVC and public
load balancer incurs cloud charges.

Two local files are required and intentionally ignored by Git:

- `k8s/mongo-secret.yaml` supplies the `mongo-secret` Secret. Its MongoDB
  username and password must match the users in the restored archive; it also
  holds the app's other private environment values.
- `k8s/ghcr-secret.yaml` supplies the `dockerconfigjson-github-com` image pull
  Secret for the private main app image.

Never commit these files, rendered FVE manifests, kubeconfigs, or credentials.

## Traefik and cert-manager

The cluster uses Traefik Helm chart **41.7.1** and cert-manager **v1.21.2**.
Install them once on a new cluster (or use the same commands to reconcile those
releases after reviewing changes):

```sh
helm repo add traefik https://traefik.github.io/charts
helm repo update traefik
helm upgrade --install traefik traefik/traefik \
  --version 41.7.1 --namespace traefik --create-namespace \
  -f k8s/traefik-values.yaml --wait --timeout 10m

helm upgrade --install cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.21.2 --namespace cert-manager --create-namespace \
  --set crds.enabled=true --wait --timeout 10m
```

The chart exposes Traefik's `web` and `websecure` entry points on ports 80 and
443. `traefik-values.yaml` adds an `smtp` TCP entry point: Traefik listens on
1025 inside its pod and the public LoadBalancer exposes it on port 25. The
chart installs the `traefik` IngressClass and Traefik's `IngressRouteTCP` CRD.
Check the assigned public IP and all three ports with
`kubectl get service traefik -n traefik -o wide`; check the controllers with
`kubectl get pods -n traefik` and `kubectl get pods -n cert-manager`.

The official [Traefik Kubernetes setup](https://doc.traefik.io/traefik/setup/kubernetes/)
and [cert-manager Helm guide](https://cert-manager.io/docs/installation/helm/)
describe these chart installations. Keep the pinned versions and values in sync
with the running cluster when upgrading.

## MongoDB: new cluster or full restore only

The existing cluster already has its restored database. **Do not apply the
bootstrap manifest during normal updates.** It binds MongoDB only to its own
container's loopback address and disables authentication while the archive is
restored. It uses the same `Deployment/db` and PVC as the production manifest.

For a fresh cluster or an intentional complete replacement from a compressed
MongoDB archive:

```sh
kubectl apply -n default -f k8s/data-pvc.yaml
kubectl get pvc data -n default
kubectl apply -n default -f k8s/db-bootstrap.yaml
kubectl rollout status -n default deployment/db --timeout=300s
```

On a separate local terminal, forward only to this computer's loopback port:

```sh
kubectl port-forward -n default --address 127.0.0.1 deployment/db 27018:27017
```

With a matching MongoDB Database Tools `mongorestore` (the successful migration
used version 100.2.1), run this from another local terminal. The archive must
be the **complete** backup; `--drop` replaces collections already present:

```sh
BACKUP_ARCHIVE=/absolute/path/to/backup.archive.gz
mongorestore --host 127.0.0.1 --port 27018 \
  --archive="$BACKUP_ARCHIVE" --gzip --drop --stopOnError
```

The restore may take hours and rebuild indexes. The previous in-pod restore
exceeded the small worker's memory, so run the restore tool locally through the
port-forward. Verify its exit status and restored database contents before
switching to the authenticated Deployment, then stop the port-forward:

```sh
kubectl apply -n default -f k8s/mongo-secret.yaml
kubectl apply -n default -f k8s/db-deployment.yaml
kubectl apply -n default -f k8s/db-service.yaml
kubectl rollout status -n default deployment/db --timeout=300s
```

The production MongoDB listens on its private Service with authentication and
a 0.5 GiB WiredTiger cache. The PVC preserves its data when the Deployment is
replaced. This directory does not configure ongoing backups; arrange and test
those separately.

## Main app and Notes

Deploy the private image pull credential, preload the main image, then start
the app and its private Service:

```sh
kubectl apply -n default -f k8s/ghcr-secret.yaml
kubectl apply -n default -f k8s/nodejs-image-cache.yaml
kubectl rollout status -n default daemonset/nodejs-image-cache --timeout=30m
kubectl apply -n default -f k8s/nodejs-service.yaml
kubectl apply -n default -f k8s/nodejs-deployment.yaml
kubectl rollout status -n default deployment/nodejs --timeout=15m

kubectl apply -n default -f k8s/notes-service.yaml
kubectl apply -n default -f k8s/notes-deployment.yaml
kubectl rollout status -n default deployment/progtexts2 --timeout=10m
```

`nodejs` serves HTTP on 3000 and receives SMTP on 1025. It has one replica and
uses `Recreate` to avoid two copies of its background jobs. The image-cache
DaemonSet downloads the large app image before a rollout, reducing downtime;
the restart itself still causes a brief interruption. Notes is a separate
static Nginx Deployment with a rolling update. Its source repository's GitHub
Action publishes new images and updates the live Notes Deployment.

## Public routes, DNS, and certificates

After Traefik, cert-manager, and the Services are ready:

```sh
kubectl apply -n default -f k8s/letsencrypt-prod.yaml
kubectl apply -n default -f k8s/smtp-route.yaml
kubectl apply -n default -f k8s/ingress.yaml
kubectl get ingress,issuer,certificate -n default
```

The namespaced `letsencrypt-prod` Issuer uses Let's Encrypt production ACME and
HTTP-01 challenges through the `traefik` IngressClass. `ingress.yaml` routes
`algoprog.ru`, `www.algoprog.ru`, `algoprog.org`, and `www.algoprog.org` to
`nodejs:3000`, and both Notes names to `progtexts2:80`. It requests separate
TLS Secrets for the main `.ru`, main `.org`, and Notes names. Point **every**
listed name at the Traefik LoadBalancer, directly or by CNAME, and ensure port
80 reaches Traefik before expecting certificate issuance. Avoid stale AAAA
records to another server. The Notes names can remain CNAMEs to `algoprog.ru`.

FVE is separate so its DNS and certificate cannot hold up the main site's
certificates. Once an `fve:4000` Service exists and both FVE names resolve to
the LoadBalancer, render its template outside the repository:

```sh
export FVE_DOMAIN='<actual-domain>'
envsubst '${FVE_DOMAIN}' < k8s/fve-ingress.yaml.tmpl > /tmp/algoprog-fve-ingress.yaml
kubectl apply -n default -f /tmp/algoprog-fve-ingress.yaml
```

The FVE certificate covers the bare and `www` names together, so both DNS
records must reach Traefik before that certificate can become Ready. The
literal domain and rendered file must remain outside Git.

`smtp-route.yaml` sends incoming TCP port 25 from Traefik to `nodejs:1025`.
The route does not itself test delivery; check the hosting provider's port 25
policy and end-to-end mail reception separately.

## GitHub deployments and checks

Apply `k8s/github-deploy-access.yaml` and follow
[`k8s/github-actions.md`](github-actions.md) to export two restricted
kubeconfigs and add `SELECTEL_KUBECONFIG_B64` to each repository. The algoprog
workflow preloads and updates the main app image. The Notes workflow updates
its image. **Neither workflow reapplies these manifests**; apply intentional
configuration changes from this directory separately. The algoprog workflow
uses Kubernetes resource names rather than manifest paths, so flattening this
directory requires no workflow path change.

Useful read-only checks:

```sh
kubectl get pods,svc,pvc,ingress,certificate -n default
kubectl get ingressroutetcp -n default
kubectl get service traefik -n traefik -o wide
kubectl get pods -n cert-manager
kubectl get challenge -n default
```

If HTTPS is pending, confirm DNS for every name on the relevant certificate,
then inspect the cert-manager `Challenge` and Traefik Ingress. The backup
bootstrap and local Secrets are never part of a routine redeploy.
