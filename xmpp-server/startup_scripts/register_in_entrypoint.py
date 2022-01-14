# env variables:
# - ENTRYPOINT_REGISTRATION_MAX_RETRIES
# - ENTRYPOINT_REGISTRATION_USER_NAME
# - ENTRYPOINT_REGISTRATION_USER_PASSWORD

import os
import sys
import time
from pprint import pprint

import requests as r

PROXY_HOSTNAME_WITH_PORT = sys.argv[1]
URL = f"http://{PROXY_HOSTNAME_WITH_PORT}/v2"
GET_VERSION_URL = f"{URL}/services/haproxy/configuration/backends"
ENDPOINT_USER = os.environ['ENTRYPOINT_REGISTRATION_USER_NAME']
ENDPOINT_PASSWORD = os.environ['ENTRYPOINT_REGISTRATION_USER_PASSWORD']
NUM_MAX_RETRIES = int(os.environ['ENTRYPOINT_REGISTRATION_MAX_RETRIES'])
IMAGE_HOSTNAME = sys.argv[2]
BACKEND_NAME = sys.argv[3]
BACKEND_PORT = int(sys.argv[4])


def register(backend_name, port):
    server_name = f"{backend_name}-{IMAGE_HOSTNAME}"
    add_server_url = (
        f"{URL}/services/haproxy/configuration/servers?backend={backend_name}&version="
    )
    version = r.get(GET_VERSION_URL, auth=(ENDPOINT_USER, ENDPOINT_PASSWORD)).json()[
        "_version"
    ]
    retries = 0
    while retries < NUM_MAX_RETRIES:
        response = r.post(
            f"{add_server_url}{version}",
            auth=(ENDPOINT_USER, ENDPOINT_PASSWORD),
            json={
                "name": server_name,
                "address": IMAGE_HOSTNAME,
                "port": port,
                "check": "enabled",
                "init-addr": "last,libc,none",
            },
        )
        if response.status_code == 202:
            print(f"Server {server_name} added to haproxy backend {backend_name}")
            return
        elif (
            f"Server {server_name} already exists in backend"
            in response.json()["message"]
        ):
            print(
                f"Server {server_name} is already registered in haproxy backend {backend_name}"
            )
            return
        else:
            pprint(response.json())
            version += 1
            retries += 1
            time.sleep(1)
    print(f"Could not add server to haproxy backend {backend_name}")
    exit(1)


register(BACKEND_NAME, BACKEND_PORT)