#!/bin/bash
/tigase/startup_scripts/wait_for_db.sh && \
/tigase/startup_scripts/install_schema.sh # there is no 'and' here because if schema is already installed, it will return non-zero exit code
/tigase/startup_scripts/wait_for_entrypoint.sh && \
/usr/bin/python3.9 -u /tigase/startup_scripts/register_in_entrypoint.py entrypoint:5555 `cat /etc/hostname` xmpp 5222 && \
/usr/bin/python3.9 -u /tigase/startup_scripts/register_in_entrypoint.py entrypoint:5555 `cat /etc/hostname` admin_panel 8080 && \
/tigase/scripts/tigase.sh run ./etc/tigase.conf
