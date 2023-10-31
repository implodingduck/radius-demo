#!/bin/bash
cd terraform
terraform init
terraform apply -auto-approve
export CLUSTER_NAME=$(terraform output -raw cluster_name)
export CLUSTER_RG=$(terraform output -raw cluster_rg)
cd ..
az aks get-credentials --resource-group $CLUSTER_RG --name $CLUSTER_NAME --overwrite-existing
./install_radius_cli.sh
rad install kubernetes
rad workspace create kubernetes microservice-app
rad workspace switch microservice-app
rad group create microservice-app
rad group switch microservice-app
rad env create demo-dev --group microservice-app --namespace demo-dev-microservice-app
rad env switch demo-dev
rad recipe register myredis --resource-type Applications.Datastores/redisCaches --template-kind terraform --template-path github.com/implodingduck/radius-demo//recipes/redis
