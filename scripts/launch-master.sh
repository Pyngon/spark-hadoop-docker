#!/bin/bash

/etc/init.d/ssh start
start-dfs.sh
start-yarn.sh
tail -f /dev/null