#!/bin/bash

echo "=== Starting Hadoop Services ==="

# Start SSH service
sudo service ssh start

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Format namenode if not already formatted
if [ ! -d "/tmp/hadoop-hadoop/dfs/name/current" ]; then
    echo "Formatting HDFS namenode..."
    $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# Start HDFS
echo "Starting HDFS..."
$HADOOP_HOME/sbin/start-dfs.sh

# Start YARN
echo "Starting YARN..."
$HADOOP_HOME/sbin/start-yarn.sh

# Start MapReduce Job History Server
echo "Starting MapReduce Job History Server..."
$HADOOP_HOME/bin/mapred --daemon start historyserver

# Wait a bit for services to start
sleep 10

# Show running Java processes
echo "=== Running Java Processes ==="
jps

echo "=== Hadoop Services Started Successfully ==="
echo "HDFS Web UI: http://localhost:9870"
echo "YARN Web UI: http://localhost:8088"
echo "Job History Server: http://localhost:19888"

# Keep container running
tail -f /opt/hadoop/logs/*.log
