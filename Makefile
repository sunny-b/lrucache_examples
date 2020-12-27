SHELL:=/bin/bash

test: python-test ruby-test node-test go-test
.PHONY: test

ruby-test:
	ruby ruby/lrucache_test.rb
.PHONY: ruby-test

node-test: 
	pushd javascript && npm test && popd
.PHONY: node-test

go-test: 
	pushd go && GO111MODULE=on go mod download && go test *.go && popd
.PHONY: go-test

python-test:
	python python/lrucache_test.py
.PHONY: python-test
