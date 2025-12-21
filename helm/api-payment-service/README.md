# Api payment service
## Configuration
### Ingress
1. Defautl option is **Azure Application gateway for containers**, so Azure directly route traffic to correct service.  
**AGIC** offer very profesionall features to enterprise application, like WAF and a lot of other traffic controller.  
**The main downside** of this solution is high cost of AG.
2. In other hand we can use `values-nginx-ingress.yaml` to use nginx controller and basic Azure LoadBalancer.  
Probably it cost less and offer good routing controll to our service.
3. Last option is `values-basic-load-balancer.yaml`, it don't use any ingress but using **service type LoadBalancer** so Azure will create public Load Balancer.