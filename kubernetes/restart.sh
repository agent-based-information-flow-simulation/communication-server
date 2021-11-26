#!/bin/bash
./minikube/delete.sh
./minikube/start.sh
minikube addons enable ingress
# minikube addons enable ambassador
./apply.sh
# ./minikube/dashboard.sh &
