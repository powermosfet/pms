LOCAL_INSTALL_PATH := $(shell stack path | grep local-install | sed 's/[^ ]* //' | xargs realpath --relative-to .)
BINARY_PATH_RELATIVE := $(LOCAL_INSTALL_PATH)/bin/pms

all: build docker

build:
	stack build

docker: build
	sudo BINARY_PATH=$(BINARY_PATH_ABSOLUTE) docker build --build-arg BINARY_PATH -t pms .
