- Kubernetes is a container orchestration system, which functions by running all applications in containers isolated from the host system through multiple layers of protection.
- K8 pods function as separate virtual machines with their own networking i.e., their own IP, hostname etc.,
- Provides load balancing, service discovery, storage orchestration, self-healing

**Nodes**
- Minion nodes execute instructions from the applications in the Control Plane and ensure the desired state is achieved.
- The master node hosts the control plane

**Control Plane**
The Control Plane serves as the management layer. Here are the services and ports in the control plane:

	Service	            TCP Ports
	etcd	                2379, 2380
	API server	            6443
	Scheduler	            10251
	Controller Manager	    10252
	Kubelet API	        10250
	Read-Only Kubelet API	10255

**Minions**
- Minions are where the applications are ran
- Minions are regulated by the Control Plane

