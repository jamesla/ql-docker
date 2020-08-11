# Dockerfile to run a linux quake live server
FROM ubuntu:16.04
MAINTAINER James McCallum <jamesgmccallum@gmail.com>

# dependencies
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libstdc++6:i386 wget software-properties-common
RUN apt-get install -y python3.5 python3.5-dev build-essential libzmq3-dev python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python

# setup user
RUN useradd -ms /bin/bash quake
ENV HOME /home/quake
WORKDIR /home/quake
USER quake

# download and extract steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
  && tar -xvzf steamcmd_linux.tar.gz \
  && ./steamcmd.sh +login anonymous +app_update 349090 +quit \
  && ln -s "Steam/steamapps/common/Quake Live Dedicated Server/" ql

# download the workshop items
RUN ./steamcmd.sh +login anonymous \
  +workshop_download_item 282440 557591894 \
  +workshop_download_item 282440 558200805 \
  +workshop_download_item 282440 561613916 \
  +workshop_download_item 282440 561815150 \
  +workshop_download_item 282440 561459991 \
  +workshop_download_item 282440 553095317 \
  +workshop_download_item 282440 561877295 \
  +workshop_download_item 282440 551367534 \
  +workshop_download_item 282440 551148976 \
  +workshop_download_item 282440 550843679 \
  +workshop_download_item 282440 562987267 \
  +workshop_download_item 282440 563005769 \
  +workshop_download_item 282440 550674410 \
  +workshop_download_item 282440 549447613 \
  +workshop_download_item 282440 550575965 \
  +workshop_download_item 282440 550566693 \
  +workshop_download_item 282440 562042961 \
  +workshop_download_item 282440 550003921 \
  +workshop_download_item 282440 549208258 \
  +workshop_download_item 282440 551229107 \
  +workshop_download_item 282440 551699225 \
  +workshop_download_item 282440 553088484 \
  +quit \
  && mkdir ql/steamapps \
  && mv Steam/steamapps/workshop ql/steamapps/workshop

# download and install latest minqlx
COPY --chown=quake plugins ql/minqlx-plugins
RUN wget -O - https://api.github.com/repos/MinoMino/minqlx/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4 | xargs wget \
  && cd ql \
  && tar xzf ~/minqlx_v*.tar.gz \
  && pip3 install -r minqlx-plugins/requirements.txt
