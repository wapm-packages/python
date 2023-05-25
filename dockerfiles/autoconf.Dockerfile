FROM debian:bullseye


RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    build-essential \
    autoconf \
  && apt-get purge --autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /src/*.deb 
