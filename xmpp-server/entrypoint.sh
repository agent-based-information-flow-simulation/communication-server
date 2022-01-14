#!/bin/bash
# env variables:
# - ENTRYPOINT_REGISTRATION_ADDRESS
# - ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_NAME
# - ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_PORT
# - ENTRYPOINT_REGISTRATION_BACKEND_XMPP_NAME
# - ENTRYPOINT_REGISTRATION_BACKEND_XMPP_PORT
# - ENTRYPOINT_REGISTRATION_MAX_RETRIES
# - ENTRYPOINT_REGISTRATION_USER_NAME
# - ENTRYPOINT_REGISTRATION_USER_PASSWORD

/tigase/startup_scripts/wait_for_db.sh && \
/tigase/startup_scripts/install_schema.sh # there is no 'and' here because if schema is already installed, it will return non-zero exit code
/tigase/startup_scripts/wait_for_entrypoint.sh && \
/usr/bin/python3.9 -u /tigase/startup_scripts/register_in_entrypoint.py \
    "${ENTRYPOINT_REGISTRATION_ADDRESS}" \
    "${ENTRYPOINT_REGISTRATION_USER_NAME}" \
    "${ENTRYPOINT_REGISTRATION_USER_PASSWORD}" \
    "${ENTRYPOINT_REGISTRATION_MAX_RETRIES}" \
    `cat /etc/hostname` \
    "${ENTRYPOINT_REGISTRATION_BACKEND_XMPP_NAME}" \
    "${ENTRYPOINT_REGISTRATION_BACKEND_XMPP_PORT}" && \
/usr/bin/python3.9 -u /tigase/startup_scripts/register_in_entrypoint.py \
    "${ENTRYPOINT_REGISTRATION_ADDRESS}" \
    "${ENTRYPOINT_REGISTRATION_USER_NAME}" \
    "${ENTRYPOINT_REGISTRATION_USER_PASSWORD}" \
    "${ENTRYPOINT_REGISTRATION_MAX_RETRIES}" \
    `cat /etc/hostname` \
    "${ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_NAME}" \
    "${ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_PORT}" && \
/tigase/scripts/tigase.sh run ./etc/tigase.conf
