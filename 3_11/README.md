# Exercise 3.11: Kubernetes Cluster Architecture Diagram

Below is the Kubernetes architecture diagram showing:
- **Your Own Computer** sending deployment instructions via `kubectl` to the Kubernetes Control Plane API Server.
- **Internet User** sending `HTTP Requests` through the LoadBalancer / Ingress **Service** to the applications.
- **Kubernetes Cluster** with **3 Host Machines (Nodes)**:
  - **Node 1 (Control Plane + Worker)**: API Server and Blog Website **Pod** (**Container**).
  - **Node 2 (Worker Node)**: Blog Website **Pod** + Database **Pod** backed by a persistent **Volume**.
  - **Node 3 (Worker Node)**: Video Game Server **Pod** (**Container**) communicating with an external Matchmaking API outside the cluster.

![Kubernetes Diagram](./kubernetes-diagram.svg)

```mermaid
flowchart TB
  Dev["Your Own Computer (Developer)"] -- "kubectl apply -f deployment.yaml" --> APIServer
  Internet["Internet User (Browser / Game Client)"] -- "HTTP / TCP Request" --> IngressSvc

  subgraph Cluster["Kubernetes Cluster"]
    IngressSvc["Service (LoadBalancer / Ingress)"]
    BlogSvc["Service: blog-service (ClusterIP)"]
    GameSvc["Service: game-service (NodePort)"]

    IngressSvc --> BlogSvc
    IngressSvc --> GameSvc

    subgraph Node1["Host Machine 1 (Control Plane & Worker Node)"]
      APIServer["Control Plane (kube-apiserver / Scheduler)"]
      subgraph Pod1["Pod: blog-pod-1"]
        Cont1["Container: Blog Website (Nginx/React)"]
      end
    end

    subgraph Node2["Host Machine 2 (Worker Node)"]
      subgraph Pod2["Pod: blog-pod-2"]
        Cont2["Container: Blog Website (Nginx/React)"]
      end
      subgraph PodDB["Pod: blog-db-pod"]
        ContDB["Container: PostgreSQL"]
        Vol["Volume (PersistentVolumeClaim)"]
        ContDB --- Vol
      end
    end

    subgraph Node3["Host Machine 3 (Worker Node)"]
      subgraph Pod3["Pod: game-server-pod"]
        Cont3["Container: Video Game Server"]
      end
    end

    BlogSvc --> Pod1
    BlogSvc --> Pod2
    Pod1 --> PodDB
    Pod2 --> PodDB
    GameSvc --> Pod3
  end

  Pod3 -- "HTTPS API Call" --> ExternalAPI["External Steam / Matchmaking API (Outside Cluster)"]
```
