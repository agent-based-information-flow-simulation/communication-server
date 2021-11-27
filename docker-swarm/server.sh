#!/bin/bash

function usage() {
    echo "Usage: $0 {init|start|scale|stop|restart|clean|stats|benchmark}"
    echo "       init: initialize the swarm cluster"
    echo "       start [N=1]: start the server with N instances of xmpp servers"
    echo "       scale N: scale the server to N instances of xmpp servers"
    echo "       stop: stop the server"
    echo "       restart N: clean and start with N instances of xmpp servers"
    echo "       clean: stop the server and remove all docker data"
    echo "       stats: print stats from all services"
    echo "       benchmark {start|stop}: start/stop benchmark"
    exit 1
}

function init() {
    docker swarm init && \
    echo "ok"
}

function start() {
    docker stack deploy -c ./docker-compose.yml agents-sim
}

function scale() {
    if [ -z "${1}" ]; then usage; fi
    docker service scale agents-sim_xmpp-server="${1}"
}

function stop() {
    docker stack rm agents-sim
}

function restart() {
    if [ -z "${1}" ]; then usage; fi
    clean && start "${1}"
}

function clean() {
    stop
    docker swarm leave --force
    docker system prune --all --volumes
}

function logs () {
    if [ -z "${1}" ];then
        docker ps -q | xargs -L 1 docker logs --follow --tail="all"
    else
        docker logs --follow --tail="all" "${@}"
    fi 
}

function stats() {
    docker stats
}

function benchmark() {
    case "${1}" in
        start)
        # -d \
            docker run \
                --rm \
                -p 3000:8091 \
                --name tsung-benchmark \
                madpeh/tsung-benchmark-docker-swarm && \
            echo "benchmark is running on http://localhost:3000"
            ;;
        stop)
            docker stop tsung-benchmark
            ;;
        *)
            usage
            ;;
    esac
}

case "${1}" in
    init)
        init
        ;;

    start)
        start "${2}"
        ;;

    scale)
        scale "${2}"
        ;;

    stop)
        stop
        ;;

    restart)
        restart "${2}"
        ;;

    clean)
        clean
        ;;

    stats)
        stats
        ;;

    benchmark)
        benchmark "${2}"
        ;;

    *)
        usage
        ;;
esac
