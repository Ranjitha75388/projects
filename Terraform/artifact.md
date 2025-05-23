

The Artifact Registry in Google Cloud Platform (GCP) is a fully managed service that allows you to store, manage, and secure your software artifacts (such as container images, language packages, and other build artifacts) in a central location.

Use Cases:

    Container Image Storage: Replace Docker Hub with a private registry.

    Language Package Management: Host your own Maven, npm, or PyPI repositories.

    Supply Chain Security: Scan artifacts for security issues before deployment.

    Organization-wide Sharing: Share artifacts across teams and projects securely

    Artifact Types
Artifact Type	Example
Docker images	      gcr.io/my-project/my-image
Maven packages	      Java JARs for Java apps
npm packages	      JavaScript libraries
Python packages	      Wheels and source distributions
APT/YUM	              System packages for Debian or CentOS


Typical Workflow:

    Build your artifact (e.g., Docker image or npm package).

    Push it to Artifact Registry.

    Reference it from Cloud Run, GKE, Cloud Functions, etc.

    Pull it in builds or deployments securely.



    Step 1: Enable the Artifact Registry API

    Go to the Google Cloud Console: https://console.cloud.google.com

    Select your project.

    In the Navigation menu, go to APIs & Services > Library.

    Search for "Artifact Registry API".

    Click it, then click Enable.

✅ Step 2: Create an Artifact Registry Repository

    Go to Artifact Registry:
    https://console.cloud.google.com/artifacts

    Click “Create Repository”.

    Fill in the details:
    Field	Example
    Name	my-docker-repo
    Format	Choose: Docker, Maven, npm, Python, etc.
    Mode	Standard
    Location Type	Region or Multi-region
    Region	e.g., us-central1
    Description (optional)	e.g., "Docker images for my app"

    Click Create.

✅ Step 3: Configure Docker (if using Docker)

To push/pull Docker images:

    Open a terminal on your local machine.

    Authenticate Docker with Artifact Registry:

    gcloud auth configure-docker us-central1-docker.pkg.dev

    Replace us-central1 with your chosen region.

✅ Step 4: Push an Artifact (Example: Docker Image)

    Tag your Docker image:

```
docker tag my-image:latest us-central1-docker.pkg.dev/PROJECT_ID/REPO-NAME/IMAGE-NAME:LATEST
```
    ![image](https://github.com/user-attachments/assets/38cb47b5-2c7d-4060-b94a-cb038edcb33d)

Push the image:
```
docker push us-central1-docker.pkg.dev/PROJECT_ID/REPO-NAME/IMAGE-NAME:LATEST
```

Step 5: Use Artifacts in GCP

You can now use your artifacts in:

    Cloud Run

    Google Kubernetes Engine (GKE)

    Cloud Functions

    Cloud Build

By referencing:

us-central1-docker.pkg.dev/PROJECT_ID/my-docker-repo/my-image:latest

✅ Step 6: Manage Permissions

    Go to IAM & Admin > IAM.

    Grant roles like:

        Artifact Registry Reader

        Artifact Registry Writer

        Artifact Registry Administrator

        Storage Admin (for underlying GCS)

To the appropriate users or service accounts.








# GKE


In Google Kubernetes Engine (GKE), a "Standard Cluster" refers to the fully customizable and flexible mode of running Kubernetes clusters. It offers more control over the infrastructure compared to Autopilot clusters, where Google manages the nodes for you.
🔍 What is a GKE Standard Cluster?

A Standard GKE cluster is a mode where you manage the cluster’s nodes (VMs), giving you full control over:
Feature	Description
Node Management	You control VM size, auto-upgrade, auto-repair, and node pool configurations.
Billing	You are billed for both the control plane and node VMs.
Customization	You can customize networking, security, scaling, OS images, and more.
Workload Placement	You decide which workloads go on which nodes using labels, taints, and tolerations.
🔧 Standard vs Autopilot Cluster
Feature	Standard Cluster	Autopilot Cluster
Node Control	Full control over nodes	No access to nodes (managed by Google)
Cost Model	Pay for nodes (VMs + control plane)	Pay per pod (vCPU and memory usage)
Use Case	Customization, performance tuning	Simplicity, quick deployments
Ideal For	Advanced teams, hybrid setups	Devs who want to skip ops
🛠️ Example Use Cases for GKE Standard

    Complex production workloads

    Custom GPU/TPU configurations

    Workload isolation (with custom node pools)

    Legacy systems that require fine-tuned environments

    Integrating with custom networking or logging solutions

🚀 How to Create a Standard Cluster (via Console)

    Go to Google Kubernetes Engine

    Click "Create"

    Choose Standard (not Autopilot)

    Configure:

        Cluster name

        Location (zonal or regional)

        Node pool details (machine type, node count, etc.)

    Click Create




    3. Networking
Field	Description	Recommended Value
Networking mode	Determines how Pods get IPs.	Use VPC-native (recommended)
VPC	The Virtual Private Cloud the cluster will use.	default or a custom VPC
Subnetwork	Subnet under the VPC.	default or custom


4. Advanced Settings

Here are important sections to consider:
➤ Node Pools

    Customize number of nodes, type, and scaling behavior.

        Machine type: e2-medium (for dev) or e2-standard-4 for prod

        Nodes: 1 (nonprod) or 3+ (prod)










        Deployment




        4. Authenticate kubectl with GKE

gcloud container clusters get-credentials your-cluster-name \
--zone your-zone --project your-project-id

Example:

gcloud container clusters get-credentials drip-nonprod \
--zone us-central1-a --project my-gcp-project

✅ 5. Deploy to GKE

Create a Kubernetes deployment file (e.g., deployment.yaml):
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
      - name: react-app
        image: us-central1-docker.pkg.dev/YOUR_PROJECT_ID/YOUR_REPO_NAME/my-react-app:latest
        ports:
        - containerPort: 80
```
Apply it:

kubectl apply -f deployment.yaml

✅ 6. Expose the App with a LoadBalancer

kubectl expose deployment react-app --type=LoadBalancer --port=80 --target-port=80

Then get the external IP:

kubectl get service

Use the external IP to access your app.
