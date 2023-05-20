#!/bin/bash

registry_id=$(docker ps | grep registry | awk '{print $1}')
docker rm -f "${registry_id}"
docker run -p 5000:5000 --restart=always --name registry -d registry:2
docker ps

app_image=$(docker images | grep app-gateway | awk '{print $3}')
docker rmi -f ${app_image}
docker build -t localhost:5000/app-gateway .
docker push localhost:5000/app-gateway
docker images

pod_id=$(kubectl get pods | grep app-gateway | awk '{print $1}')
kubectl delete pod "${pod_id}"
kubectl get pods

