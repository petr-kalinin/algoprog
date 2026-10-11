# Selectel deployment

These manifests target the Selectel `kz-1` Kubernetes cluster. Apply files
individually: this directory contains both a temporary MongoDB restore
deployment (`db-bootstrap.yaml`) and its authenticated production replacement
(`db-deployment.yaml`) with the same name.

`data-pvc.yaml` provisions a 40 GiB persistent volume. The bootstrap MongoDB
listens only inside its container while a backup is restored. After verifying
the complete backup, apply the ignored local `../mongo-secret.yaml`, then
`db-deployment.yaml` and `../db-service.yaml`. The restored database already
contains its users; the Secret supplies the same credentials to MongoDB and
the app. Never commit either local Secret file.

For the web app, apply the ignored `../ghcr-secret.yaml`, then
`nodejs-deployment.yaml` and `nodejs-service.yaml`. The Selectel app deployment
uses `Recreate` so a rollout does not run two copies of the background jobs on
the small worker. Do not use `../nodejs-service.yaml`: it contains an address
and NodePort from the previous provider.

Traefik provides HTTP, HTTPS, and incoming SMTP. Cert-manager manages the web
certificates through the `letsencrypt-prod.yaml` Issuer. Apply `smtp-route.yaml`
and `ingress.yaml` only after the app is healthy. The main Ingress retains the
Notes routes to the future `progtexts2` Service. The FVE routes use a separate
Ingress and TLS secret so their DNS cannot delay the main site's certificates.
Set `FVE_DOMAIN` locally and render `fve-ingress.yaml.tmpl` with `envsubst`
before applying the rendered manifest. Keep the actual domain and rendered file
outside the repository.

Once the main HTTP route works, point the A record for `algoprog.ru` to the
Selectel load balancer. The main `www` and `.org` names are CNAMEs; cert-manager
can obtain their certificates after DNS reaches Traefik. Both Notes names are
also CNAMEs to `algoprog.ru`, so they will reach Selectel at the main cutover
and return 503 until `progtexts2` is
deployed. To keep Notes at the previous address temporarily, replace those
CNAMEs with A records for that address before changing the main A record.
FVE has its own A record and can be moved separately.

GitHub Actions deploys algoprog and Notes after publishing their images.
See `github-actions.md` for credentials and setup.
