FROM ubuntu

# Install packages
RUN apt-get update \
 && apt-get install -y openjdk-8-jre \
 && apt-get install -y curl \
 && apt-get install -y scala \
 && apt-get install -y openssh-server
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/*

# JAVA
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# HADOOP
ENV HADOOP_VERSION 3.0.0
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/local \
 && mv /usr/local/hadoop-$HADOOP_VERSION $HADOOP_HOME \
 && rm -rf $HADOOP_HOME/share/doc \
 && chown -R root:root $HADOOP_HOME

# Hadoop Config
COPY conf/hadoop/core-site.xml $HADOOP_CONF_DIR/core-site.xml
COPY conf/hadoop/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
COPY conf/hadoop/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
COPY conf/hadoop/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml
COPY conf/hadoop/masters $HADOOP_CONF_DIR/masters
COPY conf/hadoop/workers $HADOOP_CONF_DIR/workers
COPY conf/hadoop/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh

# HDFS & YARN Config
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

# SSH config
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa \
 && cat >> ~/.ssh/authorized_keys < ~/.ssh/id_rsa.pub
RUN /etc/init.d/ssh start

# SPARK
ENV SPARK_VERSION 2.4.4
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop2.7
ENV SPARK_HOME /usr/local/spark
# ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop
# ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "http://apache.cs.utah.edu/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" \
  | gunzip \
  | tar x -C /usr/local \
 && mv /usr/local/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

COPY conf/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh
COPY conf/spark/slaves $SPARK_HOME/conf/slaves

COPY conf/general/hosts /etc/hosts

RUN hdfs namenode -format

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
