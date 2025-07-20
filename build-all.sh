#!/bin/bash

echo "=== Building Big Data Docker Images ==="

# Build base image (Ubuntu + Java)
echo "Building ubuntu-java image..."
cd 1-ubuntu-java
docker build -t ubuntu-java:latest .
cd ..

# Build Hadoop base image
echo "Building hadoop-base image..."
cd 2-hadoop-base
docker build -t hadoop-base:latest .
cd ..

# Build Hadoop with ingestion tools
echo "Building hadoop-ingestion image..."
cd 3-hadoop-ingestion
docker build -t hadoop-ingestion:latest .
cd ..

# Build Hadoop with Hive
echo "Building hadoop-hive image..."
cd 4-hadoop-hive
docker build -t hadoop-hive:latest .
cd ..

# Build Hadoop with Spark
echo "Building hadoop-spark image..."
cd 5-hadoop-spark
docker build -t hadoop-spark:latest .
cd ..

echo "=== All images built successfully! ==="
echo
echo "Available images:"
docker images | grep -E "(ubuntu-java|hadoop-)"
