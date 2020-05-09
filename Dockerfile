FROM ocaml/opam2 as build
RUN sudo apt-get update -y && \
	sudo apt-get install \
	pkg-config \
	libgmp-dev \
	m4 \
	netbase	-y
RUN opam install -y dune \
	tls \
	cohttp \
	cohttp-lwt-unix \
	yojson
WORKDIR lgtm
ADD . .
RUN sudo chown -R opam:nogroup .
RUN ./bin/build

FROM debian:buster-slim
COPY --from=build /home/opam/opam-repository/lgtm/_build/default/src/main.exe lgtm
RUN apt-get update -y && apt-get install netbase -y
ADD bin bin
ENTRYPOINT ./bin/entrypoint
