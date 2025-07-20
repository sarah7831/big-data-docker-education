#!/bin/bash

echo "=== Starting Hadoop with Hive Data Warehouse ==="

# Start Hadoop and ingestion services first
echo "Starting Hadoop and ingestion services..."
/home/hadoop/scripts/start-ingestion.sh &

# Wait for Hadoop services to be ready
echo "Waiting for Hadoop services to start..."
sleep 45

# Initialize Hive schema (only if not already initialized)
echo "Initializing Hive schema..."
if [ ! -d "/home/hadoop/metastore_db" ]; then
    echo "Creating Hive metastore schema..."
    schematool -dbType derby -initSchema
else
    echo "Hive metastore already exists, skipping schema initialization"
fi

# Create Hive warehouse directory in HDFS
echo "Creating Hive warehouse directory..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod 777 /user/hive/warehouse

# Start Hive Metastore service
echo "Starting Hive Metastore service..."
hive --service metastore &

# Wait for metastore to start
sleep 15

# Start HiveServer2
echo "Starting HiveServer2..."
hive --service hiveserver2 &

# Wait for HiveServer2 to start
sleep 20

echo "=== Hadoop with Hive started successfully! ==="
echo
echo "Available services:"
echo "- Hadoop HDFS: hdfs dfs -ls /"
echo "- Hadoop YARN: yarn application -list"
echo "- Sqoop: sqoop help"
echo "- Flume: flume-ng help"
echo "- Hive CLI: hive"
echo "- Beeline (Hive JDBC): beeline -u jdbc:hive2://localhost:10000"
echo
echo "Web UIs:"
echo "- HDFS NameNode: http://localhost:9870"
echo "- YARN ResourceManager: http://localhost:8088"
echo "- MapReduce Job History: http://localhost:19888"
echo "- HiveServer2 Web UI: http://localhost:10002"
echo
echo "Sample Hive commands:"
echo "- Show databases: SHOW DATABASES;"
echo "- Create database: CREATE DATABASE test_db;"
echo "- Show tables: SHOW TABLES;"
echo

# Keep container running
tail -f /dev/null
