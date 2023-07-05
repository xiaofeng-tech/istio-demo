FOLDER=istio-1.18.0
if [ -d "$FOLDER" ]; then
    echo "$FOLDER exists."
else 
    curl -L https://istio.io/downloadIstio | sh -
fi

export PATH=$PWD/bin:$PATH

istioctl x precheck

istioctl install --set profile=demo -y

kubectl label namespace default istio-injection=enabled