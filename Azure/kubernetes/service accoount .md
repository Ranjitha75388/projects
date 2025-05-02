### 1. Create a Namespace
```
kubectl create namespace sruthi-namespace
```
### 2. Create a Service Account
```
kubectl create serviceaccount sruthi-sa -n sruthi-namespace
```
### 3. Create a Role with Permissions

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: sruthi-namespace
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```
Then apply:
```
kubectl apply -f pod-reader-role.yaml
```
### 4. Bind the Role to the Service Account

Create rolebinding.yaml:
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: sruthi-rb
  namespace: sruthi-namespace
subjects:
- kind: ServiceAccount
  name: sruthi-sa
  namespace: sruthi-namespace
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
Then apply:
```
kubectl apply -f rolebinding.yaml
```
### 5. Get the Service Account’s Token & CA Cert

a. Get the Secret Name
```
SECRET_NAME=$(kubectl get sa sruthi-sa -n sruthi-namespace -o jsonpath='{.secrets[0].name}')
```
b. Get the Token (base64-decoded)
```
kubectl get secret $SECRET_NAME -n sruthi-namespace -o jsonpath='{.data.token}' | base64 --decode
```
c. Get the CA Certificate (base64 as-is)
```
kubectl get secret $SECRET_NAME -n sruthi-namespace -o jsonpath='{.data.ca\.crt}'
```
### 6. Create the Kubeconfig File

Use the values gathered above to create sruthi-kubeconfig.yaml:
```
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: <BASE64_CA>
    server: https://<K8S-API-SERVER>
  name: sruthi-cluster
contexts:
- context:
    cluster: sruthi-cluster
    namespace: sruthi-namespace
    user: sruthi-user
  name: sruthi-context
current-context: sruthi-context
users:
- name: sruthi-user
  user:
    token: <SRUTHI_TOKEN>
```

```
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'
```
### 7.create pod in service account
```
apiVersion: v1
kind: Pod
metadata:
  name: dummy-pod
  namespace: nithya-namespace
spec:
  serviceAccountName: nithya-sa
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
```
kubectl apply -f dummy-pod.yaml
```





to get secret



Step-by-step fix:

1.    Create the token secret manually:
```
# nithya-sa-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: nithya-sa-token
  namespace: nithya-namespace
  annotations:
    kubernetes.io/service-account.name: nithya-sa
type: kubernetes.io/service-account-token
```
Apply it:
```
kubectl apply -f nithya-sa-secret.yaml
```
2. Wait a few seconds, then get the token secret name:
```
SECRET_NAME=nithya-sa-token
```
3. Extract the token (base64 decoded):
```  
kubectl get secret $SECRET_NAME -n nithya-namespace -o jsonpath='{.data.token}' | base64 --decode
```
4. Get the CA certificate (base64 raw):
```
kubectl get secret $SECRET_NAME -n nithya-namespace -o jsonpath='{.data.ca\.crt}'
```
You can now use this token and CA to fill your kubeconfig file.
