## Quick Start
### Backend bootstrap
cd /backend_bootstrap  
terraform init  
terraform apply  

### Login to kubectl
terraform output -raw kube_config >~/.kube/config  

### Helm commands
helm install java -n javaapp
helm uninstall java -n javaapp

### kubectl commands
kubectl rollout restart deployment/


## Others
az acr login --name javaservicescontainerRegistry123
docker tag payment-api:1.0.5 javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
docker push javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
