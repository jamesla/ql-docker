# ql-docker

A quake live docker server with minqlx plugins

### Getting started

1. Edit config files in config directory.

2. Edit docker-compose file to add or remove arenas configuration or plugins unique to each.

3. Export your admin steam id
```
export ADMIN=%your_steam_id%
```

4. Run it:
```
docker-compose up
```
### Adding maps and other workshop content

1. Add the workshop id to the dockerfile

### Adding plugins

1. Copy plugin to plugins directory and add plugin name to the qlx_plugin key in the docker-compose file.

### Adding more servers

1. Copy paste the "arena1" block in the docker-compose file and customise to taste
