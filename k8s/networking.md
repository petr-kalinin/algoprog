# External downloads

`coredns-user.yaml` configures the Yandex Managed Kubernetes user DNS
overrides for IPify, Informatics, and Codeforces. Apply it separately from
the application deployment:

```sh
kubectl apply -f k8s/coredns-user.yaml
```

CoreDNS automatically reloads the imported configuration after Kubernetes
updates the mounted ConfigMap; allow up to a few minutes. The application
does not need to restart. This affects resolution of the listed domains
throughout the cluster. Kubernetes services and other domains continue to
use the managed CoreDNS configuration. Merge any future user DNS overrides
into this file rather than replacing them with a separate manifest.

## Diagnosis (2026-10-06)

The `nodejs` pod resolved IPify and Informatics to `8.47.69.0` and
`8.6.112.0`, among other answers. HTTPS probes that retained the hostname
and certificate verification succeeded through `8.47.69.0`, but timed out
before TCP connected through `8.6.112.0`. The same failure occurred for
both hosts. Other external sites were reachable, and no NetworkPolicy
restricted this pod's egress.

Both Google DNS-over-TLS servers were reachable from both cluster nodes
and returned `8.47.69.5` and `8.6.112.5`. Both addresses worked from the
original `nodejs` node (`cl1djjohriiq4mveah5f-enug`). Codeforces also
received the problematic addresses from the default resolver, so it uses
the same override. This works around unreachable destination addresses;
it does not establish the cause of the upstream routing failure. Addresses
are resolved dynamically, with TLS verification enabled for both DNS and HTTPS.

Before the change, 5 of 12 HTTP probes to IPify and Informatics failed with
the application's library and seven-second timeout. After the DNS reload,
all 12 succeeded. Both DNS replicas reloaded without restarting, internal
service resolution remained healthy, and the production health endpoint
returned HTTP 200.

### Remaining issue on the other node

`cl1djjohriiq4mveah5f-aqub` (public IP `46.21.246.180`) has broader
upstream egress failures. Repeated TCP probes to Cloudflare and GitHub
addresses failed even in a temporary `hostNetwork` pod, which bypasses
the pod bridge. GitHub registry image pulls also timed out. The checked
VPC security group permits all egress, the subnet has no custom route table,
the host firewall permits these connections, and connection tracking was
well below its limit. The evidence places these failures beyond the pod
bridge and application code; it does not identify which upstream component
drops the traffic.

Google DNS is not sufficient to restore that node's connectivity. A
production-image probe with Node's automatic address fallback also failed,
so that runtime change was not deployed. Before moving `nodejs` onto that
node, its upstream egress needs repair through Yandex Cloud or a verified
alternative egress path. The DNS workaround does not guarantee reachability
after rescheduling to the affected node.

The override uses Yandex Cloud's supported `coredns-user` ConfigMap:
https://yandex.cloud/en/docs/managed-kubernetes/tutorials/custom-dns
DNS-over-TLS forwarding is documented at https://coredns.io/plugins/forward/.
Do not edit the managed `coredns` ConfigMap: its `Reconcile` label allows
the addon manager to restore the provider's configuration.

To check downloads with the application's HTTP library and timeout:

```sh
kubectl exec deployment/nodejs -- node -e '
const request = require("request-promise-native");
Promise.all(["https://api.ipify.org/?format=json", "https://informatics.msk.ru/"].map(async url => {
  try {
    const response = await request({url, gzip: true, timeout: 7000, resolveWithFullResponse: true});
    console.log(new URL(url).hostname, response.statusCode, response.body.length);
  } catch (error) {
    console.error(new URL(url).hostname, error.code || error.message);
    process.exitCode = 1;
  }
}));'
```

To roll back to the original configuration, which contained no active user
overrides:

```sh
kubectl -n kube-system patch configmap coredns-user --type merge \
  --patch '{"data":{"Corefile":""}}'
```

If other overrides have since been added, remove only the server block for
these three domains instead. Telegram proxy status 590 is a separate issue.
