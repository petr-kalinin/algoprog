#!/usr/bin/env python3
"""Write two restricted GitHub Actions kubeconfigs outside the repository."""

import base64
import json
import os
from pathlib import Path
import subprocess
import tempfile


def kubectl(*args: str) -> str:
    return subprocess.check_output(["kubectl", *args], text=True).strip()


server = kubectl(
    "config", "view", "--minify", "-o", "jsonpath={.clusters[0].cluster.server}"
)
ca_data = kubectl(
    "config", "view", "--raw", "--minify", "-o",
    "jsonpath={.clusters[0].cluster.certificate-authority-data}",
)
if not server or not ca_data:
    raise SystemExit("Current kubectl context must contain a server and CA certificate")

output_dir = Path(tempfile.mkdtemp(prefix="selectel-github-", dir="/tmp"))
for app, secret_name in (
    ("algoprog", "github-algoprog-deployer-token"),
    ("notes", "github-notes-deployer-token"),
):
    token_data = kubectl(
        "get", "secret", secret_name, "-n", "default", "-o", "jsonpath={.data.token}"
    )
    if not token_data:
        raise SystemExit(f"Kubernetes has not populated {secret_name} yet")
    token = base64.b64decode(token_data, validate=True).decode("ascii")
    config = {
        "apiVersion": "v1",
        "kind": "Config",
        "clusters": [{"name": "selectel", "cluster": {
            "server": server,
            "certificate-authority-data": ca_data,
        }}],
        "users": [{"name": app, "user": {"token": token}}],
        "contexts": [{"name": "selectel", "context": {
            "cluster": "selectel", "user": app, "namespace": "default",
        }}],
        "current-context": "selectel",
    }
    encoded = base64.b64encode(json.dumps(config).encode("utf-8"))
    path = output_dir / f"{app}-kubeconfig.b64"
    with os.fdopen(os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "wb") as file:
        file.write(encoded + b"\n")
    print(f"{app}: {path}")

print("Paste each file's contents into SELECTEL_KUBECONFIG_B64 in the matching GitHub repository.")
