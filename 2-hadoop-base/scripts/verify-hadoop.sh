#!/bin/bash

echo "=== Hadoop Installation Verification ==="
echo

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

echo "1. Checking Hadoop version:"
hadoop version
echo

echo "2. Checking HDFS version:"
hdfs version
echo

echo "3. Checking running Java processes:"
jps
echo

echo "4. Checking HDFS status:"
hdfs dfsadmin -report
echo

echo "5. Testing HDFS operations:"
echo "Creating test directory in HDFS..."
hdfs dfs -mkdir -p /user/hadoop/test

echo "Creating a test file..."
echo "Hello Hadoop HDFS!" > /tmp/test.txt
hdfs dfs -put /tmp/test.txt /user/hadoop/test/

echo "Listing HDFS contents:"
hdfs dfs -ls /user/hadoop/test/

echo "Reading file from HDFS:"
hdfs dfs -cat /user/hadoop/test/test.txt

echo "Cleaning up..."
rm /tmp/test.txt
echo

echo "6. Testing YARN:"
yarn node -list
echo

echo "7. Running sample MapReduce job:"
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 2 10
echo

echo "=== Hadoop verification completed! ==="
