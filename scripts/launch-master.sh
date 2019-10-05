#!/bin/bash

/etc/init.d/ssh start
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
start-dfs.sh
start-yarn.sh
tail -f /dev/null