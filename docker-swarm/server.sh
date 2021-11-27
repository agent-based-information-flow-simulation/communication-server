#!/bin/bash

function usage() {
    echo "Usage: $0 {start|stop|restart|clean|logs|stats|pgadmin|benchmark}"
    echo "       start N: (build and) start the server with N instances of xmpp servers"
    echo "       stop: stop the server"
    echo "       restart N: clean and start with N instances of xmpp servers"
    echo "       clean: stop the server and remove all docker data"
    echo "       logs [SERVICE]: print logs from SERVICE (if SERVICE is not provided, then print logs from all services)"
    echo "       stats: print stats from all services"
    echo "       pgadmin {start|stop}: start/stop pgadmin"
    echo "       benchmark {start|stop}: start/stop benchmark"
    exit 1
}

function start() {
    docker-compose up --detach load-balancer && \
    docker-compose up --detach db && \
    docker-compose up --detach --scale xmpp-server="${1}" xmpp-server
}

function stop() {
    docker-compose stop
}

function restart() {
    clean && start "${1}"
}

function clean() {
    docker-compose down --volumes --remove-orphans --rmi all && \
    docker system prune --all --volumes
}

function logs () {
    docker-compose logs --tail="all" "${@}" 
}

function stats() {
    docker stats
}

function pgadmin() {
    case "${1}" in
        start)
            docker-compose up --detach pgadmin && \
            echo "pgadmin is running on http://localhost:5433"
            ;;
        stop)
            docker-compose stop pgadmin
            ;;
        *)
            usage
            ;;
    esac
}

function benchmark() {
    case "${1}" in
        start)
            docker-compose build tsung-benchmark && \
            docker-compose up --detach tsung-benchmark && \
            echo "benchmark is running on http://localhost:3000"
            ;;
        stop)
            docker-compose stop tsung-benchmark
            ;;
        *)
            usage
            ;;
    esac
}

case "${1}" in
    start)
        start "${2}"
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

    logs)
        logs "${@:2}"
        ;;

    stats)
        stats
        ;;

    pgadmin)
        pgadmin "${2}"
        ;;

    benchmark)
        benchmark "${2}"
        ;;

    *)
        usage
        ;;
esac
