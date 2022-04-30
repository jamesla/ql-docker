FROM cm2network/steamcmd as qlds-builder

RUN printenv

RUN ./steamcmd.sh \
  +force_install_dir ./qlds/ \
  +login anonymous \
  +app_update 349090 \
  +quit


FROM ubuntu:20.04 as minqlx-builder

RUN apt-get update && apt-get install -y --reinstall \
  build-essential \
  python3 \
  python3-dev \
  python3-pip

ARG MINQL_VERSION=v0.5.3
ARG MINQL_PLUGINS_VERSION=v0.3.7

# get minqlx
RUN printenv
ADD https://github.com/MinoMino/minqlx/archive/refs/tags/$MINQL_VERSION.tar.gz .
RUN mkdir /minqlx \
  && tar -xvf $MINQL_VERSION.tar.gz -C /minqlx --strip-components 1 \
  && make -C /minqlx

# get minqlx plugins
ADD https://github.com/MinoMino/minqlx-plugins/archive/refs/tags/$MINQL_PLUGINS_VERSION.tar.gz .
RUN mkdir /minqlx-plugins \
  && tar -xvf $MINQL_PLUGINS_VERSION.tar.gz -C /minqlx-plugins --strip-components 1 \
  && pip3 install -r /minqlx-plugins/requirements.txt


FROM ubuntu:20.04

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --reinstall \
  zlib1g:i386 \
  lib32stdc++6 \
  ca-certificates \
  python3 \
  python3-dev

COPY --from=qlds-builder /home/steam/steamcmd/qlds /qlds
COPY --from=minqlx-builder /minqlx/bin/* /qlds/
COPY --from=minqlx-builder /minqlx-plugins/ /qlds/minqlx-plugins

WORKDIR /qlds

ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

CMD ./run_server_x86_minqlx.sh\
  +set sv_mappoolfile "mappool.txt" \
  +set g_accessfile "access.txt" \
  +set logfile "0"

