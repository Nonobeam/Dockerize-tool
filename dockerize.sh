#!/usr/bin/env bash

echo Running Godzilla Tool...

IMAGE_NAME=godzilla-image
HOST_PORT=8080
CONTAINER_PORT=80
DIR=target
BUILT_FILE=SNAPSHOT.jar
OPTION=build

err() {
    echo $* >&2
}

usage() {
    err "Error with build in option $(basename $0):"
    err "--dir=<path>       : path to the directory containing the built file"
    err "--name=<name>      : name of the image"
    err "--hostport=<port>  : port to host"
    err "--containerport=<port> : port to container"
    err "--option=<option>  : [run]"
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dir=*)
                DIR="${1#*=}"
                ;;
            --name=*)
                IMAGE_NAME="${1#*=}"
                ;;
            --hostport=*)
                HOST_PORT="${1#*=}"
                ;;
            --containerport=*)
                CONTAINER_PORT="${1#*=}"
                ;;
            --option=*)
                OPTION="${1#*=}"
                ;;
            *)
                usage
                exit 1
        esac
        shift
    done
}

clean() {
    IMAGE=$(docker ps -a -q --filter ancestor=${IMAGE_NAME} --format="{{.ID}}")

    if ! test -z "$IMAGE"; then
        echo "Removing container: ${IMAGE}"
        docker rm $(docker stop ${IMAGE})
        docker rmi -f ${IMAGE_NAME}
    fi
}

build_docker() {
    BUILT_FILE=$(basename ${DIR})

    echo "Built file: ${BUILT_FILE}"
    echo "Directory: ${DIR}"
    echo "Image name: ${IMAGE_NAME}"
    echo "Container port: ${HOST_PORT}"

    # Ensure the target directory exists
    mkdir -p build-in/target

    cp ${DIR} build-in/target/${BUILT_FILE}

    docker build -t ${IMAGE_NAME} --build-arg port=${HOST_PORT} --build-arg built_file=${BUILT_FILE} -f build-in/Dockerfile .
}

launch() {
    docker run -p ${HOST_PORT}:${CONTAINER_PORT} -d ${IMAGE_NAME}
}

execute() {
    local task=${OPTION}
    case ${task} in
        build)
            clean
            build_docker
            launch
            ;;
        run)
            clean
            build_docker
            launch
            ;;
        *)
            err "invalid task: ${task}"
            usage
            exit 1
            ;;
    esac
}

main() {
    if [ $# -eq 0 ]; then
        usage
        exit 1
    elif [ $# -eq 1 ]; then
        echo "Running default build"
        parse_args "$@"
    else
        echo "Running custom build"
        parse_args "$@"
    fi

    execute ${OPTION}
}

main "$@"

echo Shutting down....
sleep 5s