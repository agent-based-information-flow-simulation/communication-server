#!/bin/bash
# env variables:
# - ADMIN_JID
# - ADMIN_PASSWORD
# - DB_HOST
# - DB_NAME
# - DB_TYPE
# - DB_USER_NAME
# - DB_USER_PASSWORD
# - DB_ROOT_USER_NAME
# - DB_ROOT_USER_PASSWORD

/tigase/scripts/tigase.sh install-schema ./etc/tigase.conf \
    -J "${ADMIN_JID}" \
    -N "${ADMIN_PASSWORD}" \
    -H "${DB_HOST}" \
    -D "${DB_NAME}" \
    -T "${DB_TYPE}" \
    -U "${DB_USER_NAME}" \
    -P "${DB_USER_PASSWORD}" \
    -R "${DB_ROOT_USER_NAME}" \
    -A "${DB_ROOT_USER_PASSWORD}"
