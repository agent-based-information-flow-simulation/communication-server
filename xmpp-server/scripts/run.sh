#!/bin/bash
/tigase/scripts/tigase.sh install-schema ./etc/tigase.conf \
    -T postgresql \
    -D tigasedb \
    -H db \
    -U admin \
    -P admin \
    -R postgres \
    -A postgres \
    -J admin@localhost \
    -N admin
/tigase/scripts/tigase.sh run ./etc/tigase.conf
