# app-gateware
my app gateware


# deploy
sh k3s.sh --disable-helm-controller --disable=traefik
/usr/local/bin/k3s-uninstall.sh

docker pull registry:2
docker run -p 5000:5000 --restart=always --name registry -d registry:2
docker build . -t localhost:5000/app-gateway
docker push localhost:5000/app-gateway
kubectl create -f deploy.yaml


# debug
kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot


# todo
动态获取域名证书
动态获取负载均衡配置
get service ip by k8s api
ip黑名单和白名单
upstream cache
log to clickhouse


# log collect
$ kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-openshift-security-context-constraints.yaml

