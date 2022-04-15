APP = htp
BINARY = main
# 禁止使用hub.docker.com 必须使用私有仓库
DOCKER_HUB = registry.cn-beijing.aliyuncs.com
NAMESPACE = hyhbackend
VERSION = 0.0.1.1
TAG = $(VERSION)
TAG_CMD = $(VERSION_CMD)
# 必须小写
IMG_NAME = gcar
IMG_FULL_NAME = $(DOCKER_HUB)/$(NAMESPACE)/$(IMG_NAME):$(TAG)
IMG_FULL_NAME_CMD = $(DOCKER_HUB)/$(NAMESPACE)/$(IMG_NAME_CMD):$(TAG_CMD)

all: build

.PHONY : dirs mod clean fmt build img help autoR test


clean:
	#go clean -i $(GO_FLAGS) $(SOURCE_DIR)
	rm -f ./$(BINARY)
	rm -f ./bin/$(BINARY)
	rm -rf ./bin/$(VERSION)
	docker images | grep $(IMG_NAME) | sort | awk '{print $3}' | xargs docker rmi

dirs:
	mkdir -p document/wiki
	mkdir -p document/sql
	mkdir -p document/postman

cleanAll:
	#go clean -i $(GO_FLAGS) $(SOURCE_DIR)
	rm -f ./$(BINARY)
	rm -rf ./bin/*

mod:
	#go clean -i $(GO_FLAGS) $(SOURCE_DIR)
	go mod tidy

fmt:
	goimports -w ...

doc:
	gf pack public,template packed/data.go -y
	gf swagger --pack -y

build:
	make doc
	gf build
	cp ./bin/$(VERSION)/linux_amd64/$(BINARY) ./bin/$(BINARY)
	file ./bin/$(BINARY)

build_cmd:
	cd ./cmd
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o cmd main.go

img:
	make build
	docker build -t $(IMG_FULL_NAME) . -f Dockerfile
	docker push $(IMG_FULL_NAME)

#imgP:
#	gf docker -t $(IMG_FULL_NAME
#	gf docker -p -t $(IMG_FULL_NAME)

imgR:
	docker run --rm -p 8299:8299 -v "`pwd`/manifest/config/config.toml":/apps/config/config.toml $(IMG_FULL_NAME)

imgRW:
	docker run --rm -v "`pwd`/manifest/config/config.toml":/apps/config/config.toml $(IMG_FULL_NAME_CMD)

help:
	@echo "make docker - 编译镜像!"
	@echo "make autoR - tx环境,自动部署!"

ansibleLR:
	cd ~/gitlab/ansible && pwd && source venv/bin/activate && ansible-playbook -i inventories/staging_car playbooks/gcar.yaml --tags=app


autoPR:
	make ansiblePR


test:
	go test -v ./tsts
	#go test -v ./testsdb
	go test -v ./testsdb/lib_file_test.go
	go test -v ./testsdb/redis_test.go
	go test -v ./testsdb/service_gps_test.go
