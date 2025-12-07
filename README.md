az acr login --name javaservicescontainerRegistry123
docker tag payment-api:1.0.5 javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
docker push javaservicescontainerregistry123.azurecr.io/javaservices:1.0.5
