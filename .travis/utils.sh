#!/bin/bash
# Get the current release version
#get_version() {
#    version=$(TRAVIS_BRANCH)
#    echo "$version"
#}

# Build and test docker images
build_docker_image() {
    #version=$( get_version )
    echo "$version"
    docker build -t ab1997/kubeadm-version:manifest-${PLAT}-${version} .
    docker run --rm -i ab1997/kubeadm-version:manifest-${PLAT}-${version}
}

# Function usages: upload docker image/manifest
# Syntax:
# docker_push <version> <arch>
# docker_push <version>
# docker_push
docker_push (){
    version=$1
    plat=$2
    image=""
    flag="manifest"

    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

    if [ ! -z "${plat}" ] && [ ! -z "${version}" ]; then
        image="ab1997/kubeadm-version:manifest-${plat}-${version}"
        flag=""
    elif [ ! -z "${version}" ]; then
        image="ab1997/kubeadm-version:manifest-${version}"
    else
        image="ab1997/kubeadm-version:manifest-latest"
    fi
    echo "docker ${flag} push ${image}"
    docker ${flag} push ${image}
    docker logout
}

# Function usages: create multiarch manifest
# Syntax:
# create_multiarch_manifest <latest>
# create_multiarch_manifest
create_multiarch_manifest(){
    # To enable manifest create feature
    export DOCKER_CLI_EXPERIMENTAL=enabled
    version="$1"
    multiarch_manifest=${2:-$version}
    docker manifest create \
        ab1997/kubeadm-version:manifest-${multiarch_manifest} \
        --amend ab1997/kubeadm-version:manifest-amd64-${version} \
        --amend ab1997/kubeadm-version:manifest-arm64-${version}
}
