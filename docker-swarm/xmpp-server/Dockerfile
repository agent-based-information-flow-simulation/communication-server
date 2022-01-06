FROM openjdk:11.0.13-jre-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9=3.9.2-1 \
    python3-requests=2.25.1+dfsg-2 \
    netcat=1.10-46 \
    wget=1.21* && \
    wget --progress=dot:giga https://github.com/tigase/tigase-server/releases/download/tigase-server-8.1.2/tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    tar -xzf tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    rm tigase-server-8.1.2-b10915-dist-max.tar.gz && \
    mv tigase-server-8.1.2-b10915 tigase && \
    rm -r tigase/docs

COPY . /tigase/

ENTRYPOINT [ "/tigase/scripts/run.sh" ]
