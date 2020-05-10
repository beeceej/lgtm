FROM debian:buster-slim
RUN apt-get update -y && apt-get install netbase -y
ADD . .
ENTRYPOINT ./bin/entrypoint
