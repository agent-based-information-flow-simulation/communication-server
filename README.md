# Communication Server

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

## About <a name = "about"></a>

Communication server.

## Getting Started <a name = "getting_started"></a>

### Prerequisites

```
docker
docker-compose
```

### Installing
Use the `server.sh` utility script.
```
./server.sh help
```

## Usage <a name = "usage"></a>

After starting the `.dev.yml` compose file, the server in accessible on localhost. </br>
Host port mapping: </br>
* port `5222` - xmpp server (via entrypoint)
* port `5432` - db
* port `5433` - db gui
* port `5555` - entrypoint api
* port `8080` - xmpp server admin panel (via entrypoint)
* port `8081` - benchmark
