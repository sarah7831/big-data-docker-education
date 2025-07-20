#!/bin/bash

echo "=== Starting Hadoop with Sqoop and Flume ==="

# Start Hadoop services first
echo "Starting Hadoop services..."
/home/hadoop/scripts/start-hadoop.sh

# Wait for Hadoop services to be ready
echo "Waiting for Hadoop services to start..."
sleep 30

# Create Flume spooling directory
echo "Creating Flume spooling directory..."
mkdir -p /home/hadoop/flume-spooling

# Create HDFS directories for Flume
echo "Creating HDFS directories for Flume..."
hdfs dfs -mkdir -p /user/hadoop/flume-data

# Set permissions
hdfs dfs -chmod 755 /user/hadoop/flume-data

echo "=== Hadoop with Sqoop and Flume started successfully! ==="
echo
echo "Available tools:"
echo "- Sqoop: sqoop help"
echo "- Flume: flume-ng help"
echo
echo "Web UIs:"
echo "- HDFS NameNode: http://localhost:9870"
echo "- YARN ResourceManager: http://localhost:8088"
echo "- MapReduce Job History: http://localhost:19888"
echo
echo "To start Flume agent:"
echo "flume-ng agent --conf \$FLUME_HOME/conf --conf-file \$FLUME_HOME/conf/flume.conf --name agent -Dflume.root.logger=INFO,console"
echo

# Keep container running
tail -f /dev/null
