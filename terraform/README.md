## Prepare to deploy
1. Create `db_access.auto.tfvars` and paste this values
```
postgres_admin_login = 
postgres_admin_password = 
```
2. Fill out your credientals
3. Auto tfvars is loaded automatically so won't use `-var-file=`!

## Deploy
1. Deploy with AG and install AGIC ingress:  
`terraform apply -var-file=enable_agic.tfvars`
2. Deploy without AG:  
`terraform apply`