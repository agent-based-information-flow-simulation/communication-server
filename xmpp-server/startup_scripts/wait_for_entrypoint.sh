#!/bin/bash
while ! nc -z entrypoint 5555; do sleep 1; done;
echo "Entrypoint is up"
