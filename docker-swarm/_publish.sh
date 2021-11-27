#!/bin/bash
docker build ./xmpp-server -t madpeh/xmpp-server-docker-swarm && \
docker push madpeh/xmpp-server-docker-swarm

docker build ./load-balancer -t madpeh/load-balancer-docker-swarm && \
docker push madpeh/load-balancer-docker-swarm

# docker build ./tsung-benchmark -t madpeh/tsung-benchmark-docker-swarm && \
# docker push madpeh/tsung-benchmark-docker-swarm 
