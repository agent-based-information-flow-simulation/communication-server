#!/bin/bash
kubectl apply -f db/
kubectl apply -f xmpp-server/
kubectl apply -f controller/
