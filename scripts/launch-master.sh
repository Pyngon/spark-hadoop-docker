#!/bin/bash

/etc/init.d/ssh start
stop-dfs.sh
start-dfs.sh
start-yarn.sh
tail -f /dev/null