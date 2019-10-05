#!/bin/bash

/etc/init.d/ssh start
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
tail -f /dev/null