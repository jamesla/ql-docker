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

To include custom workshops content factories you will need to add the workshop content id's to the docker-compose file:

1. Update `WORKSHOP_IDS` in docker-compose file

```yaml
---
version: "3.8"

services:
  arena1:
    ...
    environment:
      ...
      WORKSHOP_IDS: |
        553088484 
        557591894
```

3. Run it

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

2. Update `MAP_POOL` to use your factory in your docker-compose file:

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

### Advanced example (multiple servers)

1. Update your docker-compose to include multiple servers:

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
        set sv_hostname "my ffa quake server"
        set serverstartup "startrandommap"
      MAP_POOL: |
        overkill|ffa
  ctf:
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
        set sv_hostname "my ctf quake server"
        set serverstartup "startrandommap"
      MAP_POOL: |
        campercrossings|ctf
```

2. Run it

```bash
docker-compose up
```

### Advanced example (custom minql plugin)

To include a custom minql plugin you will need to extend this docker image.


1. Create your own dockerfile using this one as a base image:

```Dockerfile
FROM jamesla/quakelive:latest

ADD my_minqlx_plugin.py minqlx-plugins/my_minqlx_plugin.py
```

2. Update `SERVER_CFG` environment variable in your docker compose file:

```yaml
---
version: "3.8"

services:
  arena1:
    build: ./%PATH_TO_YOUR_DOCKERFILE%
    ...
    environment:
      ...
      SERVER_CFG: |
        ...
        set qlx_plugins "my_minqlx_plugin"
        ...
```
3. Build it

```bash
docker-compose build
```

4. Run it

```bash
docker-compose up
```

