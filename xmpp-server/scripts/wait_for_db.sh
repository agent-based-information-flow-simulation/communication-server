#!/bin/bash
while ! nc -z db 5432; do sleep 1; done;
echo "Database is up"
