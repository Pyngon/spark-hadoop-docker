${SPARK_HOME}/bin/spark-submit \
--master yarn \
--deploy-mode cluster \
--queue default \
--num-executors 2 \
--executor-memory 2G \
--py-files $TFoS_HOME/tfspark.zip,$TFoS_HOME/examples/mnist/spark/mnist_dist.py \
--conf spark.dynamicAllocation.enabled=false \
--conf spark.yarn.maxAppAttempts=1 \
--conf spark.executorEnv.LD_LIBRARY_PATH=$LIB_JVM:$LIB_HDFS \
--conf spark.executorEnv.CLASSPATH=$(hadoop classpath --glob) \
$TFoS_HOME/examples/mnist/spark/mnist_spark.py \
--images mnist/csv/test/images \
--labels mnist/csv/test/labels \
--mode inference \
--model mnist_model \
--output predictions