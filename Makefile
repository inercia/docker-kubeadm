NAME=inercia/kubeadm

all: build

build:
	docker build -t $(NAME) .
