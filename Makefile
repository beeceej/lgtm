USER := beeceej
IMAGE := lgtm
VERSION := v0.0.9
REPOSITORY:= $(USER)/$(IMAGE):$(VERSION)


build:
	docker build -t $(REPOSITORY) -f Dockerfile.release .

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
