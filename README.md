# Simple Quake Live Server

A dead simple environment variable driven quake server and customisable quake live docker server with minqlx plugins allowing you to stand up a customised server via a single command and installing nothing other than docker. Easy.

## Standing up a basic quake server

1. Ensure docker and docker-compose are installed on your server. 

2. Create a file called `docker-compose.yaml` and add the following contents:

```yaml
---
version: "3.8"

services:
  my-server:
    image: jamesla/quakelive:latest
    stdin_open: true
    tty: true
    ports:
    - "27960:27960/udp"
    environment:
      ACCESS: |
        STEAMID|admin
        STEAMID|ban
      SERVER_CFG: |
        set sv_hostname "my quake server"
        set serverstartup "startrandommap"
      MAP_POOL: |
        overkill|ffa
        campgrounds|tdm
```

2. Run it

```bash
docker-compose up
```

3. That's it your server is running. At this point you probably want to play around with the server config/maps etc which is pretty easy to do as it's all done via your docker-compose file.

## Customising your server

For examples on how to make common customisations to your server see the following examples:

* [Running multiple quake servers](https://github.com/jamesla/ql-docker/tree/master/examples/simple/multiple-servers)
* [Adding custom steam workshop content (maps etc)](https://github.com/jamesla/ql-docker/tree/master/examples/simple/workshop-content)
* [Adding custom factories (game modes)](https://github.com/jamesla/ql-docker/tree/master/examples/advanced/custom-factory)
* [Adding custom minql plugins](https://github.com/jamesla/ql-docker/tree/master/examples/advanced/custom-minql-plugin)

