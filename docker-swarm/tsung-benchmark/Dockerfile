FROM debian:10.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    tsung=1.7.0-3 \
    erlang-mochiweb=2.19.0-1 \
    perl=5.28.1-6+deb10u1 \
    gnuplot=5.2.6+dfsg1-1+deb10u1 \
    python3-matplotlib=3.0.2-2 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/x86_64-linux-gnu/tsung/bin:${PATH}"

COPY tsung.xml /tsung.xml

ENTRYPOINT ["/bin/bash"]

CMD [ "tsung", "-f", "/tsung.xml", "start" ]
