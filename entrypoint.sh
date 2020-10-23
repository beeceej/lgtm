#!/bin/bash
latest_tag=$(git tag  | grep -E '^v[0-9]' | sort -V | tail -1)
latest_tag=latest
echo -e "FROM beeceej/lgtm:${latest_tag}\nENTRYPOINT [ \"/bin/lgtm\" ]" | docker build --rm -t runtime -
docker run --rm runtime:latest
