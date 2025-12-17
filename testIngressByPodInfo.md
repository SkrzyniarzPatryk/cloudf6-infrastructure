lets test configuration, deploying example app

1. Add repo  
helm repo add stefanprodan https://stefanprodan.github.io/podinfo  
helm repo update  
---
2. Custom values  
- agic-values.yaml
```
replicaCount: 2
ui:
  message: "Test AGIC działa!" 
  
service:
  type: ClusterIP

ingress:
  enabled: true
  # Zostawiamy puste, bo "azure/application-gateway" jest nielegalną nazwą dla tego pola
  className: "" 
  
  # Tu wpisujemy definicję dla Azure
  annotations:
    kubernetes.io/ingress.class: "azure/application-gateway"
    
  hosts:
    - host: "mojatestowa.strona.local"
      paths:
        - path: /
          pathType: ImplementationSpecific
```
---
3. Deploy  
helm install my-podinfo stefanprodan/podinfo -f agic-values.yaml

4. Add own local DNS locally  
> <AG_Frontend_IP_Address>	mojatestowa.strona.local