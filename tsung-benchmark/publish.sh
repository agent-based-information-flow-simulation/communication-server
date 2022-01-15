#!/bin/bash
docker build ./tsung-benchmark -t madpeh/cs-tsung-benchmark && \
docker push madpeh/cs-tsung-benchmark
