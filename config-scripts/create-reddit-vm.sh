#! /bin/bash

gcloud compute instances create reddit-app-full\
  --boot-disk-size=10GB \
  --image=reddit-full-1584813002 \
  --machine-type=g1-small \
  --tags puma-server \
  --zone=europe-west3-c	\
  --restart-on-failure
