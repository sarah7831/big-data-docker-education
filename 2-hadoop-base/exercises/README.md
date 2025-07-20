# Hadoop HDFS + YARN Image Exercises

This image extends the base Ubuntu + Java image with Hadoop 3.3.6, including HDFS and YARN components.

## Learning Objectives
- Understand Hadoop ecosystem components
- Practice HDFS file operations
- Run MapReduce jobs on YARN
- Monitor Hadoop services through web UIs

## Prerequisites
- Complete exercises from ubuntu-java image
- Basic understanding of distributed file systems

## Exercise 1: Hadoop Service Verification

1. **Check if Hadoop services are running:**
   ```bash
   cd /home/hadoop/scripts
   ./verify-hadoop.sh
   ```

2. **Verify web interfaces are accessible:**
   - HDFS NameNode UI: http://localhost:9870
   - YARN ResourceManager UI: http://localhost:8088
   - MapReduce Job History Server: http://localhost:19888

3. **Check running processes:**
   ```bash
   jps
   ```
   Expected processes: NameNode, DataNode, ResourceManager, NodeManager, JobHistoryServer

## Exercise 2: HDFS File Operations

1. **Basic HDFS commands:**
   ```bash
   # Check HDFS status
   hdfs dfsadmin -report
   
   # Create directories
   hdfs dfs -mkdir /user
   hdfs dfs -mkdir /user/hadoop
   hdfs dfs -mkdir /user/hadoop/input
   
   # List directories
   hdfs dfs -ls /
   hdfs dfs -ls /user/hadoop
   ```

2. **File upload and download:**
   ```bash
   # Create a local test file
   echo "This is a test file for HDFS" > ~/testfile.txt
   echo "Line 2 of the test file" >> ~/testfile.txt
   
   # Upload to HDFS
   hdfs dfs -put ~/testfile.txt /user/hadoop/input/
   
   # List files in HDFS
   hdfs dfs -ls /user/hadoop/input/
   
   # Read file from HDFS
   hdfs dfs -cat /user/hadoop/input/testfile.txt
   
   # Download from HDFS
   hdfs dfs -get /user/hadoop/input/testfile.txt ~/downloaded.txt
   
   # Compare files
   diff ~/testfile.txt ~/downloaded.txt
   ```

3. **File operations:**
   ```bash
   # Copy within HDFS
   hdfs dfs -cp /user/hadoop/input/testfile.txt /user/hadoop/input/testfile_copy.txt
   
   # Move/rename in HDFS
   hdfs dfs -mv /user/hadoop/input/testfile_copy.txt /user/hadoop/input/renamed.txt
   
   # Check file size and replication
   hdfs dfs -ls /user/hadoop/input/
   
   # Remove files
   hdfs dfs -rm /user/hadoop/input/renamed.txt
   ```

## Exercise 3: MapReduce Jobs

1. **Word Count Example:**
   ```bash
   # Create input data
   cat > ~/words.txt << 'WORDS_EOF'
   hadoop mapreduce yarn hdfs
   big data processing framework
   distributed computing hadoop
   mapreduce job yarn scheduler
   hdfs distributed file system
   WORDS_EOF
   
   # Upload to HDFS
   hdfs dfs -put ~/words.txt /user/hadoop/input/
   
   # Run word count job
   hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /user/hadoop/input /user/hadoop/output
   
   # Check output
   hdfs dfs -ls /user/hadoop/output/
   hdfs dfs -cat /user/hadoop/output/part-r-00000
   
   # Clean up output directory for next run
   hdfs dfs -rm -r /user/hadoop/output
   ```

2. **Pi Calculation Example:**
   ```bash
   # Run pi calculation (Monte Carlo method)
   hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 4 1000
   ```

3. **Grep Example:**
   ```bash
   # Create test data
   cat > ~/sample.txt << 'SAMPLE_EOF'
   This is a sample file for testing
   Hadoop is a big data framework
   MapReduce is part of Hadoop
   YARN is the resource manager
   HDFS is the distributed file system
   SAMPLE_EOF
   
   # Upload to HDFS
   hdfs dfs -put ~/sample.txt /user/hadoop/input/
   
   # Run grep to find lines containing "Hadoop"
   hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep /user/hadoop/input /user/hadoop/grep-output 'Hadoop'
   
   # Check results
   hdfs dfs -cat /user/hadoop/grep-output/part-r-00000
   
   # Clean up
   hdfs dfs -rm -r /user/hadoop/grep-output
   ```

## Exercise 4: YARN Resource Management

1. **Check YARN nodes:**
   ```bash
   yarn node -list
   yarn node -status <node-id>
   ```

2. **Monitor applications:**
   ```bash
   # List running applications
   yarn application -list
   
   # Check application status
   yarn application -status <application-id>
   ```

3. **Resource queues:**
   ```bash
   # List available queues
   yarn queue -status default
   ```

## Exercise 5: Web UI Exploration

1. **HDFS Web UI (http://localhost:9870):**
   - Browse the file system
   - Check DataNode information
   - View block information for files

2. **YARN Web UI (http://localhost:8088):**
   - Monitor running applications
   - Check cluster metrics
   - View node information

3. **Job History Server (http://localhost:19888):**
   - View completed job history
   - Analyze job performance metrics

## Verification Checklist

- [ ] All Hadoop services are running (NameNode, DataNode, ResourceManager, NodeManager)
- [ ] Can perform basic HDFS operations (mkdir, put, get, ls, cat)
- [ ] Successfully ran MapReduce word count example
- [ ] Web UIs are accessible and functional
- [ ] YARN can schedule and execute jobs
- [ ] Job History Server shows completed jobs

## Performance Monitoring

1. **Check HDFS usage:**
   ```bash
   hdfs dfsadmin -report
   hdfs dfs -du -h /user/hadoop
   ```

2. **Monitor system resources:**
   ```bash
   free -h
   df -h
   top
   ```

## Troubleshooting

**Issue: Services not starting**
- Check logs: `tail -f /opt/hadoop/logs/*.log`
- Verify Java processes: `jps`

**Issue: HDFS in safe mode**
- Leave safe mode: `hdfs dfsadmin -safemode leave`

**Issue: Permission denied**
- Check HDFS permissions: `hdfs dfs -ls -la /user/`
- Fix permissions: `hdfs dfs -chmod 755 /user/hadoop`

**Issue: Web UI not accessible**
- Check if services are bound to correct addresses
- Verify port mappings in Docker run command

## Next Steps

Once you've completed these exercises successfully, you're ready to move on to the next image which will add Sqoop and Flume for data ingestion capabilities.
