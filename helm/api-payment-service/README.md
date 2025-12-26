# Api payment service
## Configuration
### Ingress
1. Defautl option is **Azure Application gateway for containers**, so Azure directly route traffic to correct service.  
**AGIC** offer very profesionall features to enterprise application, like WAF and a lot of other traffic controller.  
**The main downside** of this solution is high cost of AG.  
**Example: `helm install app ./api-payment-service/`**
2. In other hand we can use `values-nginx-ingress.yaml` to use nginx controller and basic Azure LoadBalancer.  
Probably it cost less and offer good routing controll to our service.  
**Example: `helm install app ./api-payment-service/ -f ./profiles/values-nginx-ingress.yaml`**
3. Last option is `values-basic-load-balancer.yaml`, it don't use any ingress but using **service type LoadBalancer** so Azure will create public Load Balancer.

#### If chosen AGIC ingress
You must deploy infrastructure with Application Gateway.  
AG automatically install AGIC controller on K8s.

#### If chosen nginx ingress
Install nginx ingress
```sh
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.externalTrafficPolicy=Local \
  --namespace ingress-nginx --create-namespace
```
Check Load Balancer Adress:  
`kubectl get services -n ingress-nginx`

## Network policy
### Info
This helm implement network policy, and this work well with Azure network policy. Other option is Calico, howerver it require additional tests.
### Set CIDR of PostgresSQL (they are in the same VNET)
Check your postgress CIDR and fill value:
```yaml
paymentApi:
  networkPolicy:
      postgresDbSubnetCidr: "10.10.30.0/24"
```
You can check this value in output form **terraform**.

## Sealed Secrets for secure password storage
### Install and example
#### Install client-side sealed secrets
Use official repo  
> https://github.com/bitnami-labs/sealed-secrets/releases/tag/v0.34.0  

```sh
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.34.0/kubeseal-0.34.0-linux-amd64.tar.gz"
tar -xvzf kubeseal-0.34.0-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
#### Install cluster-side (Helm chart)
```sh
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update sealed-secrets
helm search repo sealed-secrets
helm install sealed-secrets -n kube-system sealed-secrets/sealed-secrets
```
#### Example usage
```sh
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json
kubeseal --controller-name sealed-secrets --controller-namespace kube-system -f mysecret.json -w mysealedsecret.json
kubectl create -f mysealedsecret.json
kubectl get secret mysecret -o yaml
```
### Setup in project
1. Install cluster-side and client-side
2. Create secret file `payment-api-db-credientals-secret.yaml` with raw values. Example:
```
apiVersion: v1
kind: Secret
metadata:
  name: payment-api-db-credentials
type: Opaque
data:
  PAYMENT_DB_URL: amRiYzpwb3N0Z3Jlc3FsOi8vamF2YXNlcnZpY2VhcHBwc3FsZmxleHNlcnZlci5wb3N0Z3Jlcy5kYXRhYmFzZS5henVyZS5jb206NTQzMi9wYXltZW50cw==
  PAYMENT_DB_URL: SEBTaDFDb1IzIQ==
  PAYMENT_DB_USER: cHNxbGFkbWlu
```
3. Encrypt secrets (--scope cluster-wide allow any namespace, because default it need one namespace all the time, but in helm chart usually we use `namespace: {{ .Release.Namespace }}`):  
```
kubeseal --scope cluster-wide --controller-name sealed-secrets --controller-namespace kube-system -f payment-api-db-credientals-secret.yaml -w payment-api-db-credientals-secret-sealed.yaml
```
4. Copy PAYMENT_DB_URL, PAYMENT_DB_URL, PAYMENT_DB_USER to values.yaml or custom values (and append `-f example-sealed-secret.yaml`)
5. Install helm and Sealed Secrets should decrypt data
