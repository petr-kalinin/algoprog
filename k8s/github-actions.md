# GitHub Actions deployment to Selectel

The deployment workflows update only the images of the existing `nodejs` and
`progtexts2` Deployments. They do not reapply the manifests in `k8s/`.
The algoprog workflow runs on pushes to `master`; the Notes workflow runs on
pushes to `master` or `english`.

Apply `k8s/github-deploy-access.yaml` once to create two dedicated service accounts,
their narrowly scoped roles, and token Secrets. Apply `k8s/nodejs-image-cache.yaml`
once so the main site's large image can be pulled before its `Recreate` rollout
stops the serving pod. The cache pod runs only `/bin/sleep`; it does not start
the application or any background jobs. It reserves 8 MiB of memory.

Run `python3 k8s/export-github-kubeconfigs.py` from the algoprog
repository. The script writes two private, base64-encoded kubeconfig files
under `/tmp` and prints their paths, never their contents. Add each file's
contents as a GitHub Actions repository secret named
`SELECTEL_KUBECONFIG_B64`: the `algoprog` file in
`petr-kalinin/algoprog`, and the `notes` file in
`petr-kalinin/progtexts2`. These are **different** credentials. Do not put
the current admin kubeconfig in GitHub or commit either generated file.

The algoprog workflow uses GitHub's built-in `GITHUB_TOKEN` for GHCR; it
needs no personal GitHub token. The Notes workflow also needs its existing
`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets to publish to Docker Hub.
`TELEGRAM_TO` and `TELEGRAM_TOKEN` remain optional notification secrets.
Keep these secrets configured before running the workflows.

The main app still restarts briefly because it has one replica and uses
`Recreate` to prevent overlapping background jobs. Preloading avoids waiting
for a large image download after the old pod has stopped.
