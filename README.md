# Intro
A docker image for running spark on hadoop cluster with yarn cluster manager 
and HDFS.

# Run container command
The docker-compose.yml brings up one master and two slaves containers.<br />
To bring it up, simply use command `docker-compose up`

# To build an image only without bringing up containers
Use command "build.sh"

# Run MNIST sample training
Steps<br />
1. In host machine, run `cd sample && download.sh`
2. Connect to master docker node
3. `cd /sample`
4. `./mnist_data_convert.sh`
5. `./mnist_train.sh`
6. `./mnist_test.sh`

After the test, you could find the result in hdfs under /user/root/predictions.<br />
When the task is running, can connect to http://localhost:8088 to check the log