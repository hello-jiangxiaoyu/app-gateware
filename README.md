# app-gateware
my app gateware


# deploy
sh k3s.sh --disable-helm-controller --disable=traefik

docker pull registry:2
docker run -p 5000:5000 --restart=always --name registry -d registry:2
docker build . -t localhost:5000/app-gateway
docker push localhost:5000/app-gateway
kubectl create -f deploy.yaml


# debug
kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot
