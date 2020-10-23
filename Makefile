USER := beeceej
IMAGE := lgtm
VERSION ?= $$(git tag  | grep -E '^v[0-9]' | sort -V | tail -1)
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
	echo "$$DOCKERHUB_PASSWORD" | docker login --username beeceej --password-stdin

deploy: docker-login build tag push

git-tag:
	git tag -a "$(VERSION)" -m "release $(VERSION)"
	git push --tags

.PHONY: build test tag push docker-login deploy git-tag
