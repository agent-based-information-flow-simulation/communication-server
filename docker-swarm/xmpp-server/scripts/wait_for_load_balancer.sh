#!/bin/bash
while ! nc -z load-balancer 5555; do sleep 1; done;
echo "Load balancer is up"
