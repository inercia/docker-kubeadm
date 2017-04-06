# we need tumbleweed for go>=1.7
FROM opensuse:tumbleweed
MAINTAINER Alvaro Saurin <alvaro.saurin@suse.com>

ENV KUBE_VER="v1.6.0"
ENV BUILD_RPMS="make autoconf libtool git mercurial go rsync kernel-devel which"
ENV GOPATH="/build"

## Build kubeadm from the source, so we need build tools, rsync and kernel headers
## Build only specific version of kubeadm from KUBE_VER and place manifests for fully compatibility with original image
## Also it requres iptables for kubeadm proxy and ca certs to work with TLS/SSL
RUN zypper in -y ${BUILD_RPMS} && \
    mkdir -p ${GOPATH}/src && \
	go get -d github.com/kubernetes/kubernetes > /dev/null 2>&1 || true && \
    cd ${GOPATH}/src/github.com/kubernetes/kubernetes && \
    git checkout -q ${KUBE_VER} && \
    make WHAT="--use_go_build cmd/kubeadm" && \
    mv ./_output/local/bin/linux/*/kubeadm /usr/bin/ && \
    zypper remove -y --clean-deps ${BUILD_RPMS} && \
    zypper in -y ca-certificates iptables && \
    zypper clean --all && \
    cd / && \
    rm -rf /var/cache/zypp* /tmp/* ${GOPATH}

ENTRYPOINT ["/usr/bin/kubeadm"]
