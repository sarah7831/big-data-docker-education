FROM ubuntu-java:latest

# Set Hadoop environment variables
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HDFS_NAMENODE_USER=hadoop
ENV HDFS_DATANODE_USER=hadoop
ENV HDFS_SECONDARYNAMENODE_USER=hadoop
ENV YARN_RESOURCEMANAGER_USER=hadoop
ENV YARN_NODEMANAGER_USER=hadoop

# Switch to root to install Hadoop
USER root

# Download and install Hadoop
RUN wget -q https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    rm hadoop-${HADOOP_VERSION}.tar.gz && \
    chown -R hadoop:hadoop ${HADOOP_HOME}

# Copy Hadoop configuration files
COPY --chown=hadoop:hadoop config/ ${HADOOP_CONF_DIR}/

# Create necessary directories
RUN mkdir -p /opt/hadoop/logs && \
    mkdir -p /tmp/hadoop-hadoop/dfs/name && \
    mkdir -p /tmp/hadoop-hadoop/dfs/data && \
    chown -R hadoop:hadoop /opt/hadoop/logs && \
    chown -R hadoop:hadoop /tmp/hadoop-hadoop

# Switch back to hadoop user
USER hadoop
WORKDIR /home/hadoop

# Copy scripts and exercises
COPY --chown=hadoop:hadoop scripts/ /home/hadoop/scripts/
COPY --chown=hadoop:hadoop exercises/ /home/hadoop/exercises/

# Make scripts executable
RUN chmod +x /home/hadoop/scripts/*.sh

# Expose Hadoop ports
EXPOSE 9870 8088 9864 8042 19888 10020

# Start script
CMD ["/home/hadoop/scripts/start-hadoop.sh"]
