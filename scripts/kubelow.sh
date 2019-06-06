#!/bin/bash

IMAGE_NAME=ames-housing
VERSION=latest
PROJECT_ID=`gcloud config get-value project`

_1 () {
docker build -t gcr.io/$PROJECT_ID/${IMAGE_NAME}:${VERSION} .

#gcloud auth configure-docker
docker push gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VERSION}

kubectl create -f py-volume.yaml
kubectl create -f py-claim.yaml
}

_2() {
kubectl create -f py-job.yaml
}

_3() {

cat > pod.yaml <<EOT
apiVersion: v1
kind: Pod
metadata:
  name: download
spec:
  containers:
  - name: b
    image: busybox
    command: 
    - /bin/sh
    - -c
    - while true; do sleep 3; done;
    volumeMounts:
    - mountPath: "/mnt/xgboost"
      name: datadir
  volumes:
  - name: datadir
    persistentVolumeClaim:
      claimName: claim
EOT
kubectl apply -f pod.yaml
}


_4() {
kubectl cp download:/mnt/xgboost/housing.dat ./seldon_serve/housing.dat
}

_5() {
cd seldon_serve && s2i build . seldonio/seldon-core-s2i-python2:0.4 gcr.io/${PROJECT_ID}/housingserve:latest --loglevel=3
}

_6() {
docker run -d -p 5000:5000 gcr.io/${PROJECT_ID}/housingserve:latest
}

_7() {
curl -H "Content-Type: application/x-www-form-urlencoded" -d 'json={"data":{"tensor":{"shape":[1,37],"values":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]}}}' http://localhost:5000/predict
}

#_1
#_2
#_3
#_4
#_5
