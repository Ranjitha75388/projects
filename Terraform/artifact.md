

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
