#!/bin/bash
sleep 60
/tigase/scripts/tigase.sh install-schema ./etc/tigase.conf \
    -T postgresql \
    -D tigasedb \
    -H db \
    -U admin \
    -P admin \
    -R postgres \
    -A postgres \
    -J admin@agents-sim.xyz \
    -N admin
/usr/bin/python3.9 /tigase/scripts/register_in_load_balancer.py `cat /etc/hostname`
/tigase/scripts/tigase.sh run ./etc/tigase.conf
