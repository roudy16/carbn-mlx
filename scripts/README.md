### Environment Setup
Run the `setup_env.sh` script. It'll set the necessary environment variables to
run everything else.
```bash
. scripts/setup_env.sh -e dev
```

### VM POC Setup
Referencing [Firecracker Docs](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md).

Requires two shell sessions in the cloud VM:

In shell one, run the following commands:
```bash
. scripts/setup_env.sh -e dev
./scripts/start_firecracker.sh
```

Then in shell two:
```bash
. scripts/setup_env.sh -e dev
./scripts/setup_guest_machine.sh
./scripts/start_guest_machine.sh
```

The microvm should start but some setup is still required for networking.
In the microvm shell (started in shell one):
```bash
ip addr add 172.16.0.2/24 dev eth0
ip link set eth0 up
ip route add default via 172.16.0.1 dev eth0

# add public dns server
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

> WARNING!!! The microvm should have internet access now, but that might not be
desirable.

### In progress notes
Getting started on IaC for system, diagram 'proto-sytem' is loose guide.
Considering what to do for admin-api. How to back API? ...
Scheduler cluster and state cluster (consul or etcd or similar?). Scheduler and
state need to be HA. Scheduler can trigger stateless actors to do things like
manage runner-hosts. Scheduler can serve admin-api. I realize k8s covers this
functionality, I'd like to give it a shot to learn something. I'll timebox this
and fallback on bootstrapping my own k8s cluster and then on managed k8s if
bootstrapping k8s feels too painful.
