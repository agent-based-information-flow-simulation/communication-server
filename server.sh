#!/bin/bash

function usage() {
    echo "Usage: $0 {start|stop|restart|clean|logs|stats|pgadmin|benchmark}"
    echo "       start: (build and) start the server"
    echo "       stop: stop the server"
    echo "       restart: clean and start"
    echo "       clean: stop the server and remove all docker data"
    echo "       logs [SERVICE]: print logs from SERVICE (if SERVICE is not provided, then print logs from all services)"
    echo "       stats: print stats from all services"
    echo "       pgadmin {start|stop}: start/stop pgadmin"
    echo "       benchmark {start|stop}: start/stop benchmark"
    exit 1
}

function start() {
    docker-compose up --detach db && \
    docker-compose up --detach xmpp-server-0 && \
    docker-compose up --detach xmpp-server-1 && \
    docker-compose up --detach xmpp-server-2 && \
    docker-compose up --detach xmpp-server-3 && \
    docker-compose up --detach load-balancer
}

function stop() {
    docker-compose stop
}

function restart() {
    clean && start
}

function clean() {
    docker-compose down --volumes --remove-orphans --rmi all && \
    docker system prune --all --volumes
}

function logs () {
    docker-compose logs --follow --tail="all" "${@}" 
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
            echo "benchmark is running on http://localhost:8091"
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
        start
        ;;

    stop)
        stop
        ;;

    restart)
        restart
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
        pgadmin
        ;;

    benchmark)
        benchmark "${2}"
        ;;

    *)
        usage
        ;;
esac
