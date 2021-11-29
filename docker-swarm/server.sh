#!/bin/bash

function usage() {
    echo "Usage: $0 {init|start|scale|stop|restart|clean|stats|benchmark}"
    echo "       init: initialize the swarm cluster"
    echo "       start [N=1]: start the server with N instances of xmpp servers"
    echo "       scale N: scale the server to N instances of xmpp servers"
    echo "       stop: stop the server"
    echo "       restart [N=1]: clean and start with N instances of xmpp servers"
    echo "       clean: stop the server and remove all docker data"
    echo "       stats: print stats from all services"
    echo "       benchmark {start|stop}: start/stop benchmark"
    exit 1
}

function init() {
    if docker swarm init; then
        echo "ok"
        echo ""
        echo "-------------------------------------------------------------------------------"
        echo "Point the server's domain (agents-sim.xyz) to the IP address of the master node"
        echo "For instance, add the IP address of the master node to /etc/hosts"
        echo "W.X.Y.Z agents-sim.xyz"
        echo "However, this step depends on the deployment method"
        echo "-------------------------------------------------------------------------------"
    fi
}

function start() {
    if docker stack deploy -c ./docker-compose.yml agents-sim; then
        if [ ! -z "${1}" ]; then scale "${1}"; fi
        echo "XMPP can be accessed on port 5222"
        echo "Admin panel can be accessed on port 8080"
    else
        echo "failed to start the server"
        echo "if you see the following error:"
        echo "failed to create service X: Error response from daemon: network Y not found"
        echo "then restart docker daemon (i.e. sudo systemctl restart docker) and run ./server.sh clean"
    fi
}

function scale() {
    if [ -z "${1}" ]; then usage; fi
    docker service scale agents-sim_xmpp-server="${1}"
}

function stop() {
    docker stack rm agents-sim
}

function restart() {
    clean && init && start "${1}"
}

function clean() {
    stop
    docker swarm leave --force
    docker system prune --all --volumes
}

function stats() {
    docker stats
}

function benchmark() {
    case "${1}" in
        start)
            docker run \
                -d \
                --rm \
                --network host \
                --name tsung-benchmark \
                madpeh/tsung-benchmark-docker-swarm && \
            echo "benchmark is running on http://localhost:8091"
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
