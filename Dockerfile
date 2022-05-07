FROM cm2network/steamcmd as qlds-builder

RUN printenv

RUN ./steamcmd.sh \
  +force_install_dir ./qlds/ \
  +login anonymous \
  +app_update 349090 \
  +quit


FROM ubuntu:20.04 as minqlx-builder

RUN apt-get update && apt-get install -y \
  build-essential \
  python3 \
  python3-dev \
  git

ARG MINQL_VERSION=v0.5.3

# build minqlx
RUN git clone https://github.com/MinoMino/minqlx.git /minqlx \
  && cd minqlx \
  && make


FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --reinstall \
  zlib1g \
  lib32stdc++6 \
  ca-certificates \
  python3 \
  python3-dev \
  python3-pip \
  git

COPY --from=qlds-builder /home/steam/steamcmd/qlds /qlds
COPY --from=minqlx-builder /minqlx/bin/* /qlds/

# minqlx plugins todo: replace with pinned version
RUN git clone https://github.com/MinoMino/minqlx-plugins.git /qlds/minqlx-plugins \
  && cd /qlds/minqlx-plugins \
  && pip3 install -r requirements.txt

WORKDIR /qlds

ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

CMD ./run_server_x64_minqlx.sh\
  +set serverstartup "startrandommap" \
  +set sv_mappoolfile "mappool.txt" \
  +set g_accessfile "access.txt" \
  +set logfile "0"

