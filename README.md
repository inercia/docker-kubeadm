# A docker image for kubeadm

A minimal Docker image that contains kubeadm.
It is based on openSUSE:tumbleweed.

## Status

This is not ready yet !!!

## Usage

1. Start the `kubelet` with something like
```
systemctl start kubelet
```
2. Start `kubeadm` in the master with:
```
docker run --rm -ti \
        --privileged --net=host \
	-v /etc/kubernetes:/etc/kubernetes \
	inercia/kubeadm init --skip-preflight-checks
```
`kubeadm` will create some manifests in `/etc/kubernetes/manifests` and
the `kubelet` will automatically start those pods.
