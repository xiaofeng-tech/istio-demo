./clean-up-bookinfo-demo.sh
istioctl uninstall -y --purge
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
rm -rf istio-1.18.0