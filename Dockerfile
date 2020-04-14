FROM haskell:8.8

RUN git clone https://github.com/facebook/duckling.git

WORKDIR /duckling

RUN git checkout 2f38255cf8a2410713d8f68a5f74f98905a95228

RUN apt-get update && \
    apt-get install -qq -y libpcre3-dev build-essential --fix-missing --no-install-recommends

RUN stack setup

RUN stack build --copy-bins --local-bin-path /usr/local/bin

FROM debian:stretch-slim

RUN apt-get update && apt-get install -y libpcre3 zlib1g libgmp10 tzdata

COPY --from=0 /usr/local/bin/duckling-example-exe /usr/local/bin/duckling

ENV LANG=C.UTF-8

CMD exec duckling

EXPOSE 8000
