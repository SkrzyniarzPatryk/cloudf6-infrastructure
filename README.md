## Quick Start
1. Set values in terraform
2. Deploy terraform 
3. login to kubectl
4. set values in helm
5. install helm
6. get ip address 

### Backend bootstrap
> This terraform has backend in azure Blob storage

cd /backend_bootstrap  
terraform init  
terraform apply  

### Login to kubectl
terraform output -raw kube_config > ~/.kube/config  

### Helm commands
helm install java -n javaapp  
helm uninstall java -n javaapp

### kubectl commands
kubectl rollout restart deployment/

### Make debug pod and connect
#### ubuntu
kubectl run debug-sql --rm -it --image=ubuntu -- bash  
apt-get install -y postgresql-client telnet  
psql -h <IP_BAZY> -U <USER> -d <DB_NAME> -W
#### curl
kubectl run test-pod --rm -ti --image=curlimages/curl -- /bin/sh  

### Ingress
C:\Windows\System32\drivers\etc\hosts <- hosts

### PSQL
1. jdbc:postgresql://javaserviceapppsqlflexserver.postgres.database.azure.com:5432/payments
> code to base64 (important -n to avoid extra \n char):   
echo -n jdbc:postgresql://javaserviceapppsqlflexserver.postgres.database.azure.com:5432/payments | base64


## Others
### How to send image to ACR
az acr login --name javaservicescontainerRegistry123
docker tag payment-api:1.0.5 javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
docker push javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
