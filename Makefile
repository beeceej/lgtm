USER := beeceej
IMAGE := lgtm
VERSION ?= latest
REPOSITORY := $(USER)/$(IMAGE):$(VERSION)
DOCKER_BUILD_ARGS ?=


build:
	docker build --rm $(DOCKER_BUILD_ARGS) -t $(REPOSITORY) -f Dockerfile.release .

test: build
	docker run --rm $(REPOSITORY) dune runtest

tag:
	docker tag $(REPOSITORY) $(REPOSITORY)

push:
	docker push $(REPOSITORY)

docker-login:
	$$echo "${DOCKER_HUB_PASSWORD}" | docker login --username beeceej --password-std

deploy: docker-login build tag push

git-tag:
	git tag -a "$(VERSION)" -m "release $(VERSION)"
	git push --tags

.PHONY: build test tag push docker-login deploy git-tag
