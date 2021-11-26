#!/bin/bash
FILE_PATH=$1

CLUSTER_NODES="'cluster-nodes' = ["
for ((i=0;i<MAX_CLUSTER_NODES;i++)); do
    CLUSTER_NODES="${CLUSTER_NODES} '${SERVER_URL}-${i}:5277',"
done;
CLUSTER_NODES=${CLUSTER_NODES::-1}
CLUSTER_NODES="${CLUSTER_NODES} ]"

echo "Adding the following cluster nodes to config: ${CLUSTER_NODES}"

sed -i "s/'cluster-nodes' = \[ \]/$CLUSTER_NODES/g" "${FILE_PATH}"
