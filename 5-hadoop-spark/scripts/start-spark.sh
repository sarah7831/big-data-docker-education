#!/bin/bash

echo "=== Starting Complete Hadoop Ecosystem with Spark ==="

# Start Hadoop, Hive and all previous services
echo "Starting Hadoop, Hive and all services..."
/home/hadoop/scripts/start-hive.sh &

# Wait for all services to be ready
echo "Waiting for all services to start..."
sleep 60

# Create Spark logs directory in HDFS
echo "Creating Spark logs directory..."
hdfs dfs -mkdir -p /spark-logs
hdfs dfs -chmod 777 /spark-logs

# Start Spark History Server
echo "Starting Spark History Server..."
start-history-server.sh &

# Wait for history server to start
sleep 10

echo "=== Complete Hadoop Ecosystem with Spark started successfully! ==="
echo
echo "Available services:"
echo "- Hadoop HDFS: hdfs dfs -ls /"
echo "- Hadoop YARN: yarn application -list"
echo "- Sqoop: sqoop help"
echo "- Flume: flume-ng help"
echo "- Hive CLI: hive"
echo "- Beeline (Hive JDBC): beeline -u jdbc:hive2://localhost:10000"
echo "- Spark Shell: spark-shell"
echo "- Spark SQL: spark-sql"
echo "- PySpark: pyspark"
echo "- Spark Submit: spark-submit"
echo
echo "Web UIs:"
echo "- HDFS NameNode: http://localhost:9870"
echo "- YARN ResourceManager: http://localhost:8088"
echo "- MapReduce Job History: http://localhost:19888"
echo "- HiveServer2 Web UI: http://localhost:10002"
echo "- Spark History Server: http://localhost:18080"
echo "- Spark Application UI: http://localhost:4040 (when running)"
echo
echo "Sample Spark commands:"
echo "- Run Spark examples: run-example SparkPi 10"
echo "- Start Spark shell: spark-shell"
echo "- Start PySpark: pyspark"
echo "- Submit Spark job: spark-submit --class org.apache.spark.examples.SparkPi \$SPARK_HOME/examples/jars/spark-examples*.jar 10"
echo
echo "Sample Spark SQL commands:"
echo "- spark-sql -e 'SHOW DATABASES;'"
echo "- spark-sql -e 'SHOW TABLES;'"
echo

# Keep container running
tail -f /dev/null
