USER := beeceej
IMAGE := lgtm
VERSION ?= v0.0.9
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

Dockerfile:
	bin/generate_dockerfile $(VERSION)

clean:
	rm Dockerfile

git-release:
	git tag -a "$(VERSION)" -m "release $(VERSION)"
	git push --tags

release: clean build push Dockerfile
