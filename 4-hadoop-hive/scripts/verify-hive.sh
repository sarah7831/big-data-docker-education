#!/bin/bash

echo "=== Verifying Hadoop Hive Installation ==="

# Check Java
echo "1. Checking Java installation..."
java -version
echo

# Check Hadoop
echo "2. Checking Hadoop installation..."
hadoop version
echo

# Check Hive
echo "3. Checking Hive installation..."
hive --version
echo

# Check Derby
echo "4. Checking Derby installation..."
ls -la $DERBY_HOME/lib/derby*.jar
echo

# Check Hadoop services
echo "5. Checking Hadoop services..."
jps
echo

# Check HDFS
echo "6. Testing HDFS operations..."
hdfs dfs -ls /
echo

# Check Hive warehouse directory
echo "7. Checking Hive warehouse directory..."
hdfs dfs -ls /user/hive/
echo

# Check Hive metastore
echo "8. Checking Hive metastore..."
if [ -d "/home/hadoop/metastore_db" ]; then
    echo "Hive metastore database exists"
    ls -la /home/hadoop/metastore_db/
else
    echo "Hive metastore database not found - will be created on first run"
fi
echo

# Test Hive CLI (basic command)
echo "9. Testing Hive CLI..."
echo "SHOW DATABASES;" | hive --silent 2>/dev/null || echo "Hive CLI test - metastore may need initialization"
echo

echo "=== Verification Complete ==="
echo "If all checks passed, the Hadoop Hive environment is ready!"
echo
echo "To initialize Hive metastore (if needed):"
echo "schematool -dbType derby -initSchema"
echo
echo "To start Hive services:"
echo "hive --service metastore &"
echo "hive --service hiveserver2 &"
