#!/bin/bash

echo "=== Verifying Hadoop Ingestion Tools Installation ==="

# Check Java
echo "1. Checking Java installation..."
java -version
echo

# Check Hadoop
echo "2. Checking Hadoop installation..."
hadoop version
echo

# Check Sqoop
echo "3. Checking Sqoop installation..."
sqoop version
echo

# Check Flume
echo "4. Checking Flume installation..."
flume-ng version
echo

# Check Hadoop services
echo "5. Checking Hadoop services..."
jps
echo

# Check HDFS
echo "6. Testing HDFS operations..."
hdfs dfs -ls /
echo

# Check if Sqoop can connect to Hadoop
echo "7. Testing Sqoop list-databases (will show error without database connection - this is expected)..."
sqoop list-databases --connect jdbc:mysql://localhost/test --username test --password test 2>/dev/null || echo "Expected error - no database configured"
echo

# Check Flume configuration
echo "8. Checking Flume configuration..."
if [ -f "$FLUME_HOME/conf/flume.conf" ]; then
    echo "Flume configuration file exists"
    echo "Configuration preview:"
    head -10 $FLUME_HOME/conf/flume.conf
else
    echo "ERROR: Flume configuration file not found"
fi
echo

# Check database connectors
echo "9. Checking database connectors..."
ls -la $SQOOP_HOME/lib/*.jar | grep -E "(mysql|postgresql)"
echo

echo "=== Verification Complete ==="
echo "If all checks passed, the Hadoop ingestion environment is ready!"
