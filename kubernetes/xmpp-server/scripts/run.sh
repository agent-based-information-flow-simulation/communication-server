#!/bin/bash
/tigase/scripts/add_cluster_nodes.sh /tigase/etc/config.tdsl

# TODO: run only as the first pod enters the cluster
/tigase/scripts/tigase.sh install-schema /tigase/etc/tigase.conf \
    -T postgresql \
    -D ${DB_NAME} \
    -H ${DB_HOST} \
    -U ${DB_USER_NAME} \
    -P ${DB_USER_PASSWORD} \
    -R ${DB_ROOT_NAME} \
    -A ${DB_ROOT_PASSWORD} \
    -J ${ADMIN_JID} \
    -N ${ADMIN_PASSWORD}


/tigase/scripts/tigase.sh run /tigase/etc/tigase.conf
