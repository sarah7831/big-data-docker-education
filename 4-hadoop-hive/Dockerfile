FROM hadoop-ingestion:latest

# Maintainer information
LABEL maintainer="Big Data Professor <professor@university.edu>"
LABEL description="Hadoop with Hive for data warehousing"

# Set environment variables
ENV HIVE_VERSION=3.1.3
ENV HIVE_HOME=/opt/hive
ENV DERBY_HOME=/opt/derby

# Switch to root for installations
USER root

# Download and install Hive
RUN cd /tmp && \
    wget https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz && \
    tar -xzf apache-hive-3.1.3-bin.tar.gz && \
    mv apache-hive-3.1.3-bin $HIVE_HOME && \
    rm apache-hive-3.1.3-bin.tar.gz

# Download and install Derby (embedded database for Hive metastore)
RUN cd /tmp && \
    wget https://archive.apache.org/dist/db/derby/db-derby-10.14.2.0/db-derby-10.14.2.0-bin.tar.gz && \
    tar -xzf db-derby-10.14.2.0-bin.tar.gz && \
    mv db-derby-10.14.2.0-bin $DERBY_HOME && \
    rm db-derby-10.14.2.0-bin.tar.gz

# Set ownership and permissions
RUN chown -R hadoop:hadoop $HIVE_HOME $DERBY_HOME && \
    chmod +x $HIVE_HOME/bin/*

# Switch back to hadoop user
USER hadoop

# Update PATH environment variable
ENV PATH=$PATH:$HIVE_HOME/bin:$DERBY_HOME/bin
ENV CLASSPATH=$CLASSPATH:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar

# Copy configuration files
COPY config/hive-site.xml $HIVE_HOME/conf/
COPY config/hive-env.sh $HIVE_HOME/conf/

# Copy scripts
COPY scripts/ /home/hadoop/scripts/
RUN chmod +x /home/hadoop/scripts/*.sh

# Set working directory
WORKDIR /home/hadoop

# Expose Hive ports
EXPOSE 10000 10002

# Default command
CMD ["/home/hadoop/scripts/start-hive.sh"]
