#!/bin/bash
latest_tag=$(git tag  | grep -E '^v[0-9]' | sort -V | tail -1)
latest_tag=latest
pwd
cp "$GITHUB_EVENT_PATH" event.json
cat event.json
ls -lah

echo -e "FROM beeceej/lgtm:${latest_tag}\nADD . .\nENTRYPOINT [ \"/bin/lgtm\" ]" | docker build --rm -t runtime  -f - .
docker run --rm -e GH_TOKEN -e GITHUB_EVENT_PATH="./event.json" runtime:latest
