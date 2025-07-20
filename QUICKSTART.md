# Quick Start Guide

This guide will help you quickly test the first two Docker images to ensure they work correctly.

## Prerequisites

1. **Docker installed and running**
   ```bash
   docker --version
   docker info
   ```

2. **Sufficient resources**
   - At least 4GB RAM available for Docker
   - 10GB free disk space

## Test Image 1: Ubuntu + Java

### Build the base image
```bash
cd big-data-docker/1-ubuntu-java
docker build -t ubuntu-java:latest .
```

### Run and test
```bash
# Run the container
docker run -it --name test-ubuntu-java ubuntu-java:latest

# Inside the container, run:
cd /home/hadoop/scripts
./verify-java.sh

# Exit the container
exit

# Clean up
docker rm test-ubuntu-java
```

## Test Image 2: Hadoop Base

### Build the Hadoop image
```bash
cd ../2-hadoop-base
docker build -t hadoop-base:latest .
```

### Run and test
```bash
# Run with port mappings
docker run -it --name test-hadoop \
  -p 9870:9870 -p 8088:8088 -p 19888:19888 \
  hadoop-base:latest
```

### In another terminal, test the services
```bash
# Wait about 2 minutes for services to start, then:

# Check web UIs
curl -s http://localhost:9870 | grep -i "namenode"
curl -s http://localhost:8088 | grep -i "resourcemanager"

# Access container and run verification
docker exec -it test-hadoop bash

# Inside container:
cd /home/hadoop/scripts
./verify-hadoop.sh
```

### Clean up
```bash
# Stop and remove container
docker stop test-hadoop
docker rm test-hadoop
```

## Using Docker Compose (Alternative)

```bash
# Build and run ubuntu-java
docker-compose up --build ubuntu-java

# In another terminal
docker-compose exec ubuntu-java bash
# Run verification scripts...

# Stop
docker-compose down

# Build and run hadoop-base
docker-compose up --build hadoop-base

# Test web UIs at:
# - http://localhost:9870 (HDFS)
# - http://localhost:8088 (YARN)
```

## Expected Results

### Ubuntu + Java Image
- Java 11 should be installed and working
- Verification script should complete without errors
- Simple Java program should compile and run

### Hadoop Base Image
- All Hadoop services should start (NameNode, DataNode, ResourceManager, NodeManager)
- Web UIs should be accessible
- HDFS operations should work
- Sample MapReduce job should complete successfully

## Troubleshooting

**Build fails with network errors:**
- Check internet connection
- Try building again (downloads may have timed out)

**Container exits immediately:**
- Check Docker logs: `docker logs <container-name>`
- Ensure ports aren't already in use

**Web UIs not accessible:**
- Wait 2-3 minutes for services to fully start
- Check if ports are mapped correctly
- Verify services are running: `docker exec <container> jps`

**Out of memory errors:**
- Increase Docker memory allocation in Docker Desktop settings
- Close other applications to free up RAM

## Next Steps

Once both images are working correctly:
1. Proceed to build the remaining images (3-hadoop-ingestion, 4-hadoop-hive, 5-hadoop-spark)
2. Complete the exercises in each image's exercises/README.md
3. Use the images for your big data course curriculum
