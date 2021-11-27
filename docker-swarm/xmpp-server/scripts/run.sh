#!/bin/bash
/tigase/scripts/wait_for_db.sh
/tigase/scripts/install_schema.sh
/tigase/scripts/wait_for_load_balancer.sh
/usr/bin/python3.9 /tigase/scripts/register_in_load_balancer.py `cat /etc/hostname` && \
/tigase/scripts/tigase.sh run ./etc/tigase.conf
