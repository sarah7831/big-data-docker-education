FROM hadoop-base:latest

# Maintainer information
LABEL maintainer="Big Data Professor <professor@university.edu>"
LABEL description="Hadoop with Sqoop and Flume for data ingestion"

# Set environment variables
ENV SQOOP_VERSION=1.4.7
ENV FLUME_VERSION=1.11.0
ENV SQOOP_HOME=/opt/sqoop
ENV FLUME_HOME=/opt/flume

# Switch to root for installations
USER root

# Install database clients
RUN apt-get update && apt-get install -y \
    mysql-client \
    postgresql-client \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Sqoop
RUN cd /tmp && \
    wget https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
    tar -xzf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
    mv sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME && \
    rm sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz

# Download and install Flume
RUN cd /tmp && \
    wget https://archive.apache.org/dist/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz && \
    tar -xzf apache-flume-1.11.0-bin.tar.gz && \
    mv apache-flume-1.11.0-bin $FLUME_HOME && \
    rm apache-flume-1.11.0-bin.tar.gz

# Download database connectors with updated URLs
RUN cd $SQOOP_HOME/lib && \
    wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.2.0/mysql-connector-j-8.2.0.jar && \
    wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.1/postgresql-42.7.1.jar

# Set ownership and permissions
RUN chown -R hadoop:hadoop $SQOOP_HOME $FLUME_HOME && \
    chmod +x $SQOOP_HOME/bin/* && \
    chmod +x $FLUME_HOME/bin/*

# Copy configuration files
COPY config/sqoop-env.sh $SQOOP_HOME/conf/
COPY config/flume-env.sh $FLUME_HOME/conf/
COPY config/flume.conf $FLUME_HOME/conf/

# Copy scripts with correct ownership
COPY --chown=hadoop:hadoop scripts/ /home/hadoop/scripts/

# Switch back to hadoop user
USER hadoop

# Update PATH environment variable
ENV PATH=$PATH:$SQOOP_HOME/bin:$FLUME_HOME/bin

# Set working directory
WORKDIR /home/hadoop

# Default command
CMD ["/home/hadoop/scripts/start-ingestion.sh"]
