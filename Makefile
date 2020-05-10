VERSION := "v0.0.3"
RELEASE_IMAGE := beeceej/lgtm:release

release: clean lgtm
	git tag -a "$(VERSION)" -m "release $(VERSION)"
	git push --tags

lgtm: docker-release
	docker run -it --rm -v "$${PWD}/release:/home/opam/opam-repository/lgtm/tmp" beeceej/lgtm:release mv release/lgtm tmp/lgtm

docker-release:
	docker build -t $(RELEASE_IMAGE) -f Dockerfile.release .

clean:
	rm -rf release

.PHONY: clean docker-release
