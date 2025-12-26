# Api payment service
## Configuration
### Ingress
1. Defautl option is **Azure Application gateway for containers**, so Azure directly route traffic to correct service.  
**AGIC** offer very profesionall features to enterprise application, like WAF and a lot of other traffic controller.  
**The main downside** of this solution is high cost of AG.
2. In other hand we can use `values-nginx-ingress.yaml` to use nginx controller and basic Azure LoadBalancer.  
Probably it cost less and offer good routing controll to our service.  
Example: `helm install app ./api-payment-service/ -f ./profiles/values-nginx-ingress.yaml`
3. Last option is `values-basic-load-balancer.yaml`, it don't use any ingress but using **service type LoadBalancer** so Azure will create public Load Balancer.

#### If chosen nginx ingress
Install nginx ingress
```sh
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.externalTrafficPolicy=Local \
  --namespace ingress-nginx --create-namespace
```

### Network policy
Check your postgress CIDR and fill value:
```yaml
paymentApi:
  networkPolicy:
      postgresDbSubnetCidr: "10.10.30.0/24"
```
You can check this value in output form **terraform**.