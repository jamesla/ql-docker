FROM cm2network/steamcmd as qlds-builder

RUN ./steamcmd.sh \
  +force_install_dir ./qlds/ \
  +login anonymous \
  +app_update 349090 \
  +quit


FROM ubuntu:20.04 as minqlx-builder

RUN apt-get update && apt-get install -y --reinstall \
  git \
  build-essential \
  python3 \
  python3-dev \
  python3-pip

# get minqlx
RUN git clone https://github.com/MinoMino/minqlx.git /minqlx
WORKDIR /minqlx
RUN git checkout v0.5.3
RUN make

# get minqlx plugins
RUN git clone https://github.com/MinoMino/minqlx-plugins.git /minqlx-plugins
WORKDIR /minqlx-plugins
RUN git checkout v0.3.7
RUN pip3 install -r requirements.txt
RUN pwd


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

CMD ./run_server_x86_minqlx.sh

