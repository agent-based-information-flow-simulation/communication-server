#!/bin/bash
docker build ./tsung-benchmark -t madpeh/communication-server-tsung-benchmark && \
docker push madpeh/communication-server-tsung-benchmark
