#!/usr/bin/env bash
set -e

# access file
echo "ACCESS" > baseq3/access.txt 

# server configuration
echo "$SERVER_CFG" > baseq3/server.cfg 
echo 'set sv_mappoolfile "mappool.txt"' >> baseq3/server.cfg
echo 'set g_accessfile "access.txt"' >> baseq3/server.cfg
echo 'set logfile "0"' >> baseq3/server.cfg

# map pool
echo "$MAP_POOL" > baseq3/mappool.txt 

# included workshop content
echo "$WORKSHOP_IDS" > baseq3/workshop.txt 

exec "$@"
