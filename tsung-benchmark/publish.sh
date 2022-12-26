#!/bin/bash
docker build ./tsung-benchmark -t aasm/cs-tsung-benchmark && \
docker push aasm/cs-tsung-benchmark
