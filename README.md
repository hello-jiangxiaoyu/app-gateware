# app-gateware
my app gateware


# deploy
docker pull registry:2
docker run -p 5000:5000 --restart=always --name registry -d registry:2
docker build . -t localhost:5000/app-gateway
docker push localhost:5000/app-gateway
kubectl create -f deploy.yaml
