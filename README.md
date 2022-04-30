# Simple Quake Live Server

A simple and customisable quake live docker server with minqlx plugins allowing you to stand a customised server up as a single command.

## Getting started

### Prequisites

Ensure the following are installed:

1. Docker
2. Docker-compose

### Simple example (customised vanilla quakelive)

1. Create and customise the following docker compose file:

```yaml
---
version: "3.8"

services:
  arena1:
    image: jamesla/quakelive:latest
    stdin_open: true
    tty: true
    ports:
    - "27960:27960/udp"
    environment:
      ACCESS: |
        XXXXXXXXXXXXXXXXX|admin
      SERVER_CFG: |
        ######################################
        # this will create a simple server
        # put your own config here
        #######################################
        set sv_hostname "my quake server"
        set serverstartup "startrandommap"
      MAP_POOL: |
        overkill|ffa
```

2. Run it

```bash
docker-compose up
```

### Advanced example (custom workshops content)

To include custom workshops and/or factories you will need to extend this docker image.

1. Create your own dockerfile that extends this one:

```Dockerfile
FROM cm2network/steamcmd as workshop-grabber

RUN ./steamcmd.sh \
  +login anonymous \
  +workshop_download_item 282440 553088484 \ 
  +workshop_download_item 282440 557591894 \ 
  +quit


FROM jamesla/quakelive:latest

COPY --from=workshop-grabber /home/steam/Steam/steamapps /qlds
```

2. Update `WORKSHOP_IDS` in docker-compose file

```yaml
---
version: "3.8"

services:
  arena1:
    build: ./%PATH_TO_YOUR_DOCKERFILE%
    ...
    environment:
      ...
      WORKSHOP_IDS: |
        553088484 
        557591894
```

3. Build it

```bash
docker-compose build
```

4. Run it

```bash
docker-compose up
```

### Advanced example (custom factory)

To include custom workshops and/or factories you will need to extend this docker image.

1. Create your own dockerfile using this one as a base image:

```Dockerfile
FROM jamesla/quakelive:latest

ADD my_custom_factory.factories baseq3/scripts/my_custom_factory.factories
```

2. Update `MAP_POOL` and image in docker-compose file

```yaml
---
version: "3.8"

services:
  arena1:
    build: ./%PATH_TO_YOUR_DOCKERFILE%
    ...
    environment:
      ...
      MAP_POOL: |
        overkill|%YOUR_CUSTOM_FACTORY_NAME%
```
3. Build it

```bash
docker-compose build
```

4. Run it

```bash
docker-compose up
```
