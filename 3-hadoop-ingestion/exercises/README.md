# Hadoop Ingestion Tools Exercises

This document contains hands-on exercises for learning Sqoop and Flume data ingestion tools with Hadoop.

## Prerequisites

- Completed exercises from hadoop-base image
- Understanding of HDFS and MapReduce concepts
- Basic knowledge of databases and data formats

## Exercise 1: Environment Verification

### Objective
Verify that Sqoop and Flume are properly installed and configured.

### Steps

1. **Start the container and verify installation:**
   ```bash
   docker run -it --name hadoop-ingestion-test \
     -p 9870:9870 -p 8088:8088 -p 19888:19888 \
     hadoop-ingestion:latest
   
   # Inside container, run verification
   cd /home/hadoop/scripts
   ./verify-ingestion.sh
   ```

2. **Check tool versions:**
   ```bash
   sqoop version
   flume-ng version
   hadoop version
   ```

3. **Verify Hadoop services are running:**
   ```bash
   jps
   # Should show: NameNode, DataNode, ResourceManager, NodeManager, JobHistoryServer
   ```

## Exercise 2: Sqoop Basics

### Objective
Learn basic Sqoop commands and understand its capabilities.

### Steps

1. **Explore Sqoop help:**
   ```bash
   sqoop help
   sqoop help import
   sqoop help export
   ```

2. **List available tools:**
   ```bash
   sqoop list-tools
   ```

3. **Check Sqoop configuration:**
   ```bash
   sqoop version
   ls -la $SQOOP_HOME/lib/ | grep -E "(mysql|postgresql)"
   ```

### Expected Results
- Sqoop help commands display available options
- Database connectors (MySQL, PostgreSQL) are present in lib directory
- Sqoop version shows 1.4.7

## Exercise 3: Flume Configuration and Testing

### Objective
Understand Flume configuration and test basic data flow.

### Steps

1. **Examine Flume configuration:**
   ```bash
   cat $FLUME_HOME/conf/flume.conf
   ```

2. **Create test data for Flume:**
   ```bash
   # Create spooling directory
   mkdir -p /home/hadoop/flume-spooling
   
   # Create test data files
   echo "Event 1: User login at $(date)" > /home/hadoop/flume-spooling/events1.txt
   echo "Event 2: User logout at $(date)" > /home/hadoop/flume-spooling/events2.txt
   echo "Event 3: File upload at $(date)" > /home/hadoop/flume-spooling/events3.txt
   ```

3. **Start Flume agent in background:**
   ```bash
   # Create HDFS directory for Flume data
   hdfs dfs -mkdir -p /user/hadoop/flume-data
   
   # Start Flume agent
   flume-ng agent \
     --conf $FLUME_HOME/conf \
     --conf-file $FLUME_HOME/conf/flume.conf \
     --name agent \
     -Dflume.root.logger=INFO,console &
   
   # Wait a few seconds for processing
   sleep 10
   ```

4. **Check results in HDFS:**
   ```bash
   # List Flume data in HDFS
   hdfs dfs -ls -R /user/hadoop/flume-data/
   
   # Read the ingested data
   hdfs dfs -cat /user/hadoop/flume-data/*/*/*/*/events-*
   ```

5. **Check completed files:**
   ```bash
   # Files should be renamed with .COMPLETED suffix
   ls -la /home/hadoop/flume-spooling/
   ```

### Expected Results
- Test files are processed and moved to HDFS
- Files in spooling directory are renamed with .COMPLETED suffix
- Data appears in HDFS with timestamp-based directory structure

## Exercise 4: Advanced Flume Configuration

### Objective
Create custom Flume configurations for different data sources.

### Steps

1. **Create a custom Flume configuration for log monitoring:**
   ```bash
   cat > /tmp/custom-flume.conf << 'FLUME_EOF'
   # Custom agent configuration
   agent.sources = r1
   agent.sinks = k1
   agent.channels = c1
   
   # Spooldir source for log files
   agent.sources.r1.type = spooldir
   agent.sources.r1.spoolDir = /home/hadoop/log-spooling
   agent.sources.r1.channels = c1
   agent.sources.r1.fileSuffix = .PROCESSED
   
   # HDFS sink with custom path
   agent.sinks.k1.type = hdfs
   agent.sinks.k1.hdfs.path = /user/hadoop/logs/%Y/%m/%d
   agent.sinks.k1.hdfs.filePrefix = log-
   agent.sinks.k1.hdfs.fileSuffix = .log
   agent.sinks.k1.hdfs.fileType = DataStream
   agent.sinks.k1.hdfs.writeFormat = Text
   agent.sinks.k1.hdfs.rollInterval = 300
   agent.sinks.k1.hdfs.rollSize = 1048576
   agent.sinks.k1.hdfs.useLocalTimeStamp = true
   
   # Memory channel
   agent.channels.c1.type = memory
   agent.channels.c1.capacity = 10000
   agent.channels.c1.transactionCapacity = 1000
   
   # Bind source and sink to channel
   agent.sources.r1.channels = c1
   agent.sinks.k1.channel = c1
   FLUME_EOF
   ```

2. **Create test log data:**
   ```bash
   mkdir -p /home/hadoop/log-spooling
   
   # Generate sample log entries
   for i in {1..5}; do
     echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [Thread-$i] Application started successfully" >> /home/hadoop/log-spooling/app-$i.log
     echo "$(date '+%Y-%m-%d %H:%M:%S') WARN [Thread-$i] Memory usage is high" >> /home/hadoop/log-spooling/app-$i.log
     echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR [Thread-$i] Connection timeout occurred" >> /home/hadoop/log-spooling/app-$i.log
   done
   ```

3. **Run custom Flume configuration:**
   ```bash
   # Stop previous Flume agent if running
   pkill -f flume-ng
   
   # Start with custom configuration
   flume-ng agent \
     --conf $FLUME_HOME/conf \
     --conf-file /tmp/custom-flume.conf \
     --name agent \
     -Dflume.root.logger=INFO,console &
   
   sleep 15
   ```

4. **Verify results:**
   ```bash
   # Check HDFS for log data
   hdfs dfs -ls -R /user/hadoop/logs/
   hdfs dfs -cat /user/hadoop/logs/*/*/log-*
   ```

## Exercise 5: Sqoop Data Import Simulation

### Objective
Understand Sqoop import concepts using file-based simulation.

### Steps

1. **Create sample data file (simulating database export):**
   ```bash
   cat > /tmp/sample_employees.csv << 'CSV_EOF'
   id,name,department,salary,hire_date
   1,John Doe,Engineering,75000,2020-01-15
   2,Jane Smith,Marketing,65000,2020-03-22
   3,Bob Johnson,Engineering,80000,2019-11-10
   4,Alice Brown,HR,60000,2021-02-28
   5,Charlie Wilson,Engineering,85000,2019-08-05
   CSV_EOF
   ```

2. **Upload to HDFS using Hadoop commands (simulating Sqoop import):**
   ```bash
   # Create directory structure similar to Sqoop output
   hdfs dfs -mkdir -p /user/hadoop/sqoop-import/employees
   
   # Upload the data
   hdfs dfs -put /tmp/sample_employees.csv /user/hadoop/sqoop-import/employees/
   
   # Verify upload
   hdfs dfs -ls /user/hadoop/sqoop-import/employees/
   hdfs dfs -cat /user/hadoop/sqoop-import/employees/sample_employees.csv
   ```

3. **Process data with MapReduce (simulating post-import processing):**
   ```bash
   # Create input directory for MapReduce
   hdfs dfs -mkdir -p /user/hadoop/mr-input
   hdfs dfs -cp /user/hadoop/sqoop-import/employees/sample_employees.csv /user/hadoop/mr-input/
   
   # Run word count on the data to analyze department distribution
   hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
     wordcount /user/hadoop/mr-input /user/hadoop/mr-output
   
   # Check results
   hdfs dfs -cat /user/hadoop/mr-output/part-r-00000 | grep -i "engineering\|marketing\|hr"
   ```

## Exercise 6: Data Pipeline Integration

### Objective
Create an integrated data pipeline using both Flume and simulated Sqoop operations.

### Steps

1. **Set up pipeline directories:**
   ```bash
   # Create directories for different stages
   hdfs dfs -mkdir -p /user/hadoop/pipeline/raw-data
   hdfs dfs -mkdir -p /user/hadoop/pipeline/processed-data
   hdfs dfs -mkdir -p /user/hadoop/pipeline/final-output
   ```

2. **Create streaming data with Flume:**
   ```bash
   # Create configuration for continuous data ingestion
   cat > /tmp/pipeline-flume.conf << 'PIPELINE_EOF'
   agent.sources = r1
   agent.sinks = k1
   agent.channels = c1
   
   agent.sources.r1.type = spooldir
   agent.sources.r1.spoolDir = /home/hadoop/pipeline-input
   agent.sources.r1.channels = c1
   
   agent.sinks.k1.type = hdfs
   agent.sinks.k1.hdfs.path = /user/hadoop/pipeline/raw-data
   agent.sinks.k1.hdfs.filePrefix = raw-
   agent.sinks.k1.hdfs.rollInterval = 60
   agent.sinks.k1.hdfs.rollSize = 0
   agent.sinks.k1.hdfs.rollCount = 5
   
   agent.channels.c1.type = memory
   agent.channels.c1.capacity = 1000
   agent.channels.c1.transactionCapacity = 100
   
   agent.sources.r1.channels = c1
   agent.sinks.k1.channel = c1
   PIPELINE_EOF
   ```

3. **Generate continuous data:**
   ```bash
   mkdir -p /home/hadoop/pipeline-input
   
   # Generate data files periodically
   for i in {1..3}; do
     echo "Transaction $i: User_$(($RANDOM % 100)) purchased item_$(($RANDOM % 50)) for $$(($RANDOM % 1000)) at $(date)" > /home/hadoop/pipeline-input/transaction_$i.txt
     sleep 2
   done
   ```

4. **Start pipeline:**
   ```bash
   flume-ng agent \
     --conf $FLUME_HOME/conf \
     --conf-file /tmp/pipeline-flume.conf \
     --name agent \
     -Dflume.root.logger=INFO,console &
   
   sleep 10
   ```

5. **Process data with MapReduce:**
   ```bash
   # Process raw data
   hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
     wordcount /user/hadoop/pipeline/raw-data /user/hadoop/pipeline/processed-data
   
   # Check results
   hdfs dfs -ls /user/hadoop/pipeline/processed-data/
   hdfs dfs -cat /user/hadoop/pipeline/processed-data/part-r-00000 | head -20
   ```

## Exercise 7: Monitoring and Troubleshooting

### Objective
Learn to monitor and troubleshoot Flume and Sqoop operations.

### Steps

1. **Monitor Flume agent:**
   ```bash
   # Check Flume process
   ps aux | grep flume
   
   # Monitor Flume logs
   tail -f $FLUME_HOME/logs/flume.log
   ```

2. **Check HDFS usage:**
   ```bash
   # Check HDFS space usage
   hdfs dfsadmin -report
   
   # Check specific directory usage
   hdfs dfs -du -h /user/hadoop/
   ```

3. **Troubleshoot common issues:**
   ```bash
   # Check if directories exist
   hdfs dfs -ls /user/hadoop/flume-data/
   
   # Check permissions
   hdfs dfs -ls -la /user/hadoop/
   
   # Fix permissions if needed
   hdfs dfs -chmod -R 755 /user/hadoop/
   ```

## Verification Checklist

After completing all exercises, verify:

- [ ] Sqoop and Flume are properly installed and configured
- [ ] Can create and modify Flume configurations
- [ ] Successfully ingested data using Flume spooling directory source
- [ ] Data appears correctly in HDFS with proper directory structure
- [ ] Can monitor and troubleshoot ingestion processes
- [ ] Understand the data pipeline from ingestion to processing
- [ ] Can integrate Flume with HDFS and MapReduce

## Performance Tips

1. **Flume Optimization:**
   - Adjust channel capacity based on data volume
   - Use appropriate batch sizes for HDFS sink
   - Monitor memory usage and adjust JVM settings

2. **HDFS Considerations:**
   - Use appropriate file sizes (avoid too many small files)
   - Set proper replication factor
   - Monitor disk space usage

3. **Monitoring:**
   - Regularly check Flume agent logs
   - Monitor HDFS space usage
   - Use web UIs for visual monitoring

## Troubleshooting Guide

**Issue: Flume agent not starting**
- Check configuration file syntax
- Verify Java heap settings
- Check log files for error messages

**Issue: Data not appearing in HDFS**
- Verify HDFS directories exist and have proper permissions
- Check Flume configuration for correct sink settings
- Ensure Hadoop services are running

**Issue: Files not being processed from spooling directory**
- Check directory permissions
- Verify spooling directory path in configuration
- Ensure files are not being written to while Flume is reading

## Next Steps

Once you've completed these exercises successfully, you're ready to move on to the Hive image, which will add data warehousing capabilities to your big data environment.
