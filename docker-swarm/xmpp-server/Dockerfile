FROM openjdk:11.0.13-jre-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9=3.9.2-1 \
    python3-requests=2.25.1+dfsg-2 \
    wget=1.21-1+b1 && \
    wget --progress=dot:giga https://github.com/tigase/tigase-server/releases/download/tigase-server-8.1.2/tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    tar -xzf tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    rm tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    mv tigase-server-8.1.2-b10915 tigase && \
    rm -r tigase/docs && \
    ulimit -n 100000

COPY . /tigase/
# COPY server-config/scripts /tigase/scripts

ENTRYPOINT [ "/tigase/scripts/run.sh" ]
# WORKDIR /tigase
# ENTRYPOINT ["/bin/bash"]
