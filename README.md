# Useful script for Kubernetes

## Making pods and services IPs reachable from localhost

Original: https://github.com/kubernetes/minikube/issues/38#issuecomment-339015592

This will make your minikube pod and service IPs routable from your host.
If you only want service IPs, you can edit this accordingly.

### Environment

OS: **macOS** ( should work for **linux** as well, but instead of `sudo route -n` you would use sudo ip route in the script)

### Steps

1. Stop the minikube VM in case it's started

```bash
$ minikube stop
```

2. Go to the virtualbox GUI (steps 2. and 3. are needed because of [#1710](https://github.com/kubernetes/minikube/issues/1710))
* Right click on the minikube `VM -> Settings -> Network`
for `Adapter 1` and `Adapter 2` select Advanced and change the adapter type to something other that Intel. For example, `PCne-FAST III (Am79C973)`.
* Open the minikube config file which should be here: `~/.minikube/machines/minikube/config.json` and change the value for the fields: `NatNicType` and `HostOnlyNicType` to match the ones that you set in virtualbox in the previous step. In this case, for example: `Am79C973`.

3. Stop docker on your machine as the ip ranges that you're adding routes for might overlap with the docker ones.

4. Start minikube and wait for it to start

```bash
$ minikube start
```

5. Make the script `setup_minikube_routing.sh` executable:

```bash
$ chmod +x ./scripts/setup_minikube_routing.sh
```

6. Run the script to set up the routes

```bash
$ ./scripts/setup_minikube_routing.sh
```

### Caveats and improvements

* The IP ranges are hardcoded in the script. We should get those dinamically.
* Minikube needs to be running for the script to run successfully.
* Make sure that the routes you're adding don't overlap with some local routing that you have.
* If you have problems with a pod unable to reach itself through a service, you can run:

```bash
$ minikube ssh
$ sudo ip link set docker0 promisc on
```
