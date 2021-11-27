FROM debian:10.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nano \
    build-essential \
    gcc \
    make \
    libexpat1-dev \
    libyaml-dev \
    libssl-dev \
    zlib1g-dev \
    gnuplot-nox \
    erlang-nox \
    erlang-dev && \
    git config --global http.sslverify false && \
    git clone https://github.com/processone/rtb.git && \
    cd rtb && \
    make && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rtb

COPY rtb.yml /rtb/rtb.yml

ENTRYPOINT ["/bin/bash"]

# CMD [ "./rtb.sh" ]
