#!/bin/bash

cd /home/hutchic/github.com/gh-org-template/kong-runtime && \
make clean && \
make run-updatecli && \
make build/docker
