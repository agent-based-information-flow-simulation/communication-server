#!/bin/bash
docker build ./xmpp-server -t madpeh/xmpp-server && \
docker push madpeh/xmpp-server
