#!/bin/bash

function usage() {
    echo "Usage: $0 {init|join|network|start|scale|stop|clean|stats|publish|benchmark}"
    echo "       init: initialize the swarm cluster"
    echo "       join TOKEN IP:PORT: join the swarm cluster"
    echo "       network (REQUIRES SWARM MODE): create shared networks for the swarm mode"
    echo "       start [-n <N=1>: N xmpp servers] [-d: dev mode (REQUIRES SWARM MODE) [-p: publish]]: start the server"
    echo "       scale N: scale the server to N instances of xmpp servers"
    echo "       stop: stop the server"
    echo "       clean: stop the server and remove all docker data"
    echo "       stats: print stats from all services"
    echo "       publish [-d: dev mode (REQUIRES SWARM MODE)]: publish the images to a registry"
    echo "       benchmark {start|stop|publish}: start/stop/publish benchmark"
    exit 1
}

function init() {
    if docker swarm init; then
        echo "swarm mode initialized"
    else
        echo "failed to initialize swarm mode"
    fi
}

function join() {
    if [ -z "$1" ]; then
        echo "missing token"
        usage
    fi
    if [ -z "$2" ]; then
        echo "missing address"
        usage
    fi
    if docker swarm join --token "$1" "$2"; then
        echo "swarm mode joined"
    else
        echo "failed to join swarm mode"
    fi
}

function network() {
    if docker network create --driver overlay --attachable sre-cs; then
        echo "[simulation run environment <-> communication server] created"
    else
        echo "[simulation run environment <-> communication server] failed to create"
    fi
}

function start() {
    DEV=0
    N=1
    PUBLISH=0
    while getopts dn:p opt; do
        case $opt in
            n) N=$OPTARG ;;
            d) DEV=1 ;;
            p) PUBLISH=1 ;;
            *) usage ;;
        esac
    done

    if [ "$DEV" -eq "1" ]; then
        COMPOSE_FILE=docker-compose.dev.swarm.yml
        if [ "$PUBLISH" -eq "1" ]; then publish -d; fi
    else
        COMPOSE_FILE=docker-compose.swarm.yml
    fi

    if docker stack deploy -c ./"$COMPOSE_FILE" cs; then
        if [ ! -z "${1}" ]; then scale "$N"; fi
        echo "XMPP can be accessed on port 5222"
        echo "Admin panel can be accessed on port 8080"
    else
        echo ""
        echo "failed to start the server"
        echo ""
        echo "if you see the following error:"
        echo "failed to create service X: Error response from daemon: network Y not found"
        echo "then restart docker daemon (i.e. sudo systemctl restart docker) and run ./server.sh clean"
        echo ""
        echo "if you see the following error:"
        echo "network XXX is declared as external, but could not be found"
        echo "run the script with the network option to create the required networks"
    fi
}

function scale() {
    if [ -z "${1}" ]; then
        echo "missing number of instances"
        usage
    fi
    docker service scale cs_xmpp-server="${1}"
}

function stop() {
    docker stack rm cs
}

function clean() {
    stop
    docker swarm leave --force
    docker system prune --all --volumes
}

function stats() {
    docker stats
}

function publish() {
    local OPTIND
    DEV=0
    while getopts d opt; do
        case $opt in
            d) DEV=1 ;;
            *) usage ;;
        esac
    done

    if [ "$DEV" -eq "1" ]; then
        echo "creating local registry..." 
        docker service create --name registry --publish published=5000,target=5000 registry:2
        docker-compose -f docker-compose.dev.swarm.yml build --parallel
        docker-compose -f docker-compose.dev.swarm.yml push
    else
        docker-compose -f docker-compose.swarm.yml build --parallel
        docker-compose -f docker-compose.swarm.yml push
    fi
}

function benchmark() {
    case "${1}" in
        start) docker run \
                -d \
                --rm \
                --network host \
                --name tsung-benchmark \
                madpeh/communication-server-tsung-benchmark && \
                echo "benchmark is running on http://localhost:8091"
            ;;

        stop) docker stop tsung-benchmark ;;

        publish) ./tsung-benchmark/publish.sh ;;

        *) usage ;;
    esac
}

case "${1}" in
    init) init ;;

    join) join "${2}" "${3}" ;;

    network) network ;;

    start) start "${@:2}" ;;

    scale) scale "${2}" ;;

    stop) stop ;;

    clean) clean ;;

    stats) stats ;;

    publish) publish "${@:2}" ;;

    benchmark) benchmark "${2}" ;;

    *) usage ;;
esac
