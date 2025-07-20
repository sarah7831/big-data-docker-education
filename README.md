# Big Data Docker Images for Education

This project provides a series of progressive Docker images designed for teaching big data technologies, specifically Hadoop and Spark ecosystems. Each image builds upon the previous one, allowing students to learn incrementally.

## Image Architecture

### 1. ubuntu-java (Base Image)
- **Base**: Ubuntu 22.04 LTS
- **Components**: OpenJDK 11, essential Linux tools
- **Purpose**: Foundation for all subsequent images
- **User**: hadoop (with sudo privileges)

### 2. hadoop-base
- **Extends**: ubuntu-java
- **Components**: Hadoop 3.3.6 (HDFS + YARN)
- **Configuration**: Pseudo-distributed mode
- **Web UIs**: HDFS (9870), YARN (8088), Job History (19888)

### 3. hadoop-ingestion
- **Extends**: hadoop-base
- **Components**: Sqoop 1.4.7, Flume 1.11.0
- **Purpose**: Data ingestion and ETL operations

### 4. hadoop-hive
- **Extends**: hadoop-ingestion
- **Components**: Hive 3.1.3
- **Database**: Derby (embedded metastore)
- **Web UI**: HiveServer2 (10000), Hive Web UI (10002)

### 5. hadoop-spark
- **Extends**: hadoop-hive
- **Components**: Spark 3.4.1
- **Integration**: Spark with Hive and HDFS
- **Web UIs**: Spark UI (4040), History Server (18080)

## Quick Start

### Prerequisites
- Docker installed and running
- Docker Compose (optional, for easier management)
- At least 4GB RAM available for containers
- Ports 8088, 9870, 4040, 10000, 19888 available

### Building Images

#### Option 1: Build All Images at Once
```bash
cd big-data-docker
chmod +x build-all.sh
./build-all.sh
```

#### Option 2: Build Individual Images
```bash
# Build base image first
cd 1-ubuntu-java
docker build -t ubuntu-java:latest .

# Build Hadoop base
cd ../2-hadoop-base
docker build -t hadoop-base:latest .

# Continue with other images as needed...
```

#### Option 3: Using Docker Compose
```bash
cd big-data-docker
docker-compose build ubuntu-java
docker-compose build hadoop-base
# Build other services as needed
```

### Running Containers

#### Using Docker Run
```bash
# Run Ubuntu + Java base image
docker run -it --name ubuntu-java-test ubuntu-java:latest

# Run Hadoop base image with port mappings
docker run -it --name hadoop-test \
  -p 9870:9870 -p 8088:8088 -p 19888:19888 \
  hadoop-base:latest

# Run complete Spark image
docker run -it --name spark-test \
  -p 9870:9870 -p 8088:8088 -p 4040:4040 -p 10000:10000 \
  hadoop-spark:latest
```

#### Using Docker Compose
```bash
# Run specific service
docker-compose up hadoop-base

# Run in background
docker-compose up -d hadoop-spark

# Access container shell
docker-compose exec hadoop-spark bash
```

## Learning Path

### Step 1: Ubuntu + Java Basics
1. Start with `ubuntu-java` image
2. Complete exercises in `1-ubuntu-java/exercises/README.md`
3. Verify Java installation and basic Linux commands

### Step 2: Hadoop Fundamentals
1. Move to `hadoop-base` image
2. Complete exercises in `2-hadoop-base/exercises/README.md`
3. Learn HDFS operations and MapReduce jobs

### Step 3: Data Ingestion
1. Use `hadoop-ingestion` image
2. Complete exercises in `3-hadoop-ingestion/exercises/README.md`
3. Practice with Sqoop and Flume

### Step 4: Data Warehousing
1. Use `hadoop-hive` image
2. Complete exercises in `4-hadoop-hive/exercises/README.md`
3. Learn HiveQL and data analysis

### Step 5: Advanced Analytics
1. Use `hadoop-spark` image
2. Complete exercises in `5-hadoop-spark/exercises/README.md`
3. Master Spark DataFrames and MLlib

## Web Interfaces

When containers are running, access these web UIs:

| Service | URL | Purpose |
|---------|-----|---------|
| HDFS NameNode | http://localhost:9870 | HDFS management and monitoring |
| YARN ResourceManager | http://localhost:8088 | Job scheduling and cluster resources |
| MapReduce Job History | http://localhost:19888 | Completed job analysis |
| HiveServer2 | http://localhost:10000 | Hive query interface |
| Hive Web UI | http://localhost:10002 | Hive service monitoring |
| Spark UI | http://localhost:4040 | Active Spark applications |
| Spark History Server | http://localhost:18080 | Spark job history |

## Directory Structure

```
big-data-docker/
├── 1-ubuntu-java/
│   ├── Dockerfile
│   ├── scripts/
│   │   └── verify-java.sh
│   └── exercises/
│       └── README.md
├── 2-hadoop-base/
│   ├── Dockerfile
│   ├── config/
│   │   ├── core-site.xml
│   │   ├── hdfs-site.xml
│   │   ├── yarn-site.xml
│   │   └── mapred-site.xml
│   ├── scripts/
│   │   ├── start-hadoop.sh
│   │   └── verify-hadoop.sh
│   └── exercises/
│       └── README.md
├── 3-hadoop-ingestion/
├── 4-hadoop-hive/
├── 5-hadoop-spark/
├── docker-compose.yml
├── build-all.sh
└── README.md
```

## Data Persistence

The project uses Docker volumes for data persistence:
- `hadoop-data`: HDFS data and Hadoop temporary files
- `hive-data`: Hive warehouse data
- `spark-data`: Spark work directories
- `./shared-data`: Host directory mounted for file sharing

## Common Commands

### Container Management
```bash
# List running containers
docker ps

# Access container shell
docker exec -it <container-name> bash

# View container logs
docker logs <container-name>

# Stop and remove container
docker stop <container-name>
docker rm <container-name>
```

### Service Management (Inside Container)
```bash
# Check Hadoop services
jps

# Start/stop HDFS
start-dfs.sh
stop-dfs.sh

# Start/stop YARN
start-yarn.sh
stop-yarn.sh

# HDFS commands
hdfs dfs -ls /
hdfs dfs -mkdir /user/hadoop
hdfs dfs -put localfile.txt /user/hadoop/

# Run MapReduce job
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount input output
```

## Troubleshooting

### Common Issues

**Container exits immediately**
- Check if ports are already in use
- Ensure sufficient memory is available
- Review container logs: `docker logs <container-name>`

**Web UIs not accessible**
- Verify port mappings in docker run command
- Check if services are running: `docker exec <container> jps`
- Ensure firewall allows connections to mapped ports

**HDFS in safe mode**
```bash
# Inside container
hdfs dfsadmin -safemode leave
```

**Permission denied errors**
```bash
# Fix HDFS permissions
hdfs dfs -chmod 755 /user/hadoop
hdfs dfs -chown hadoop:hadoop /user/hadoop
```

**Out of memory errors**
- Increase Docker memory allocation
- Reduce YARN memory settings in yarn-site.xml
- Monitor resource usage: `free -h`, `df -h`

### Getting Help

1. Check exercise README files for specific guidance
2. Review container logs for error messages
3. Verify all prerequisites are met
4. Ensure Docker has sufficient resources allocated

## Educational Use

### For Instructors
- Each image includes comprehensive exercises with expected outputs
- Progressive complexity allows flexible curriculum design
- Web UIs provide visual feedback for student engagement
- Verification scripts help assess student progress

### For Students
- Start with basic concepts and build complexity gradually
- Hands-on exercises reinforce theoretical knowledge
- Real-world tools and configurations
- Troubleshooting exercises build practical skills

## Contributing

To extend or modify these images:
1. Follow the existing naming conventions
2. Update documentation for any changes
3. Test all exercises thoroughly
4. Maintain backward compatibility where possible

## Version Information

- Ubuntu: 22.04 LTS
- Java: OpenJDK 11
- Hadoop: 3.3.6
- Spark: 3.4.1
- Hive: 3.1.3
- Sqoop: 1.4.7
- Flume: 1.11.0

## License

This project is designed for educational purposes. Please ensure compliance with individual component licenses when using in production environments.
