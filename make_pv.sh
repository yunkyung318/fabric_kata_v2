sudo rm -rf /data/pv*

sudo mkdir /data/pv

kubectl apply -f pv.yaml

kubectl get pv

