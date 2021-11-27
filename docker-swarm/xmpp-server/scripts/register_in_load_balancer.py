import sys
import time
from pprint import pprint
import requests as r

IMAGE_HOSTNAME = sys.argv[1]
SERVER_NAME = f'xmpp-{IMAGE_HOSTNAME}'
PORT = 5222
URL = 'http://load-balancer:5555/v2'
CLUSTER = 'xmpp_cluster'
GET_VERSION_URL = f'{URL}/services/haproxy/configuration/backends'
ADD_SERVER_URL= f'{URL}/services/haproxy/configuration/servers?backend={CLUSTER}&version='
ENDPOINT_USER = 'admin'
ENDPOINT_PASSWORD = 'admin'
NUM_MAX_RETRIES = 100

version = r.get(GET_VERSION_URL, auth=(ENDPOINT_USER, ENDPOINT_PASSWORD)).json()['_version']
retries = 0
while retries < NUM_MAX_RETRIES:
    response = r.post(f'{ADD_SERVER_URL}{version}', auth=(ENDPOINT_USER, ENDPOINT_PASSWORD), json={
        "name": SERVER_NAME,
        "address": IMAGE_HOSTNAME,
        "port": PORT,
        "check": "enabled",
        "init-addr": "last,libc,none"
    })
    if response.status_code == 202:
        print(f'Server {SERVER_NAME} added to load balancer')
        exit(0)
    elif f'Server {SERVER_NAME} already exists in backend' in response.json()['message']:
        print(f'Server {SERVER_NAME} is already registered in load balancer')
        exit(0)
    else:
        pprint(response.json())
        version += 1
        retries += 1
        time.sleep(1)

print('Could not add server to load balancer')
exit(1)
