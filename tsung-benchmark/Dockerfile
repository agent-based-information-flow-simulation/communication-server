FROM debian:10.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    erlang-mochiweb=2.19* \
    gnuplot=5.2* \
    perl=5.28* \
    python3-matplotlib=3.0* \
    tsung=1.7* && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/x86_64-linux-gnu/tsung/bin:${PATH}"

COPY tsung.xml /tsung.xml

ENTRYPOINT ["/bin/bash"]

CMD [ "tsung", "-f", "/tsung.xml", "start" ]
