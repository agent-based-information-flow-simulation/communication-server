#!/bin/bash
linkerd check --pre && \
linkerd install | kubectl apply -f - && \
linkerd check && \
kubectl get -n default statefulsets -o yaml | linkerd inject - | kubectl apply -f - && \
linkerd -n default check --proxy && \
linkerd viz install | kubectl apply -f - && \
linkerd check
