gsutil mb gs://ml-gcloud-demo

gsutil notification create -f json -t ml-gcloud-demo gs://ml-gcloud-demo
gcloud pubsub subscriptions create --topic ml-gcloud-demo ml-gcloud-demo-sub

python pubsub.py
