#!/bin/bash
/tigase/scripts/wait_for_db.sh
/tigase/scripts/install_schema.sh
/tigase/scripts/wait_for_entrypoint.sh
/usr/bin/python3.9 -u /tigase/scripts/register_in_entrypoint.py `cat /etc/hostname` && \
/tigase/scripts/tigase.sh run ./etc/tigase.conf
