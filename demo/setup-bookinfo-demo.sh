./setup-istio.sh

cd istio-1.18.0

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

sleep 30

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

istioctl analyze

kubectl patch svc istio-ingressgateway -n istio-system --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=127.0.0.1
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo "$GATEWAY_URL"

echo "http://$GATEWAY_URL/productpage"

# kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml

# kubectl get destinationrules -o yaml

