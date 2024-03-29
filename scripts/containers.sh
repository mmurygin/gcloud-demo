PROJECT_ID=`gcloud config get-value project`

gcloud auth configure-docker

docker build -t gcloud-demo .
docker tag gcloud-demo gcr.io/$PROJECT_ID/gcloud-demo:v2
docker push gcr.io/$PROJECT_ID/gcloud-demo:v2


# spin up another virtual machine
gcloud compute instances create container-demo --machine-type=n1-standard-1 --tags=http-server --image=workstation-with-docker --boot-disk-size=20GB --zone=us-central1-a
gcloud compute ssh container-demo
docker run -d -p 80:5000 gcr.io/$PROJECT_ID/gcloud-demo:v2

gcloud builds submit --tag gcr.io/$PROJECT_ID/gcloud-demo:v3
