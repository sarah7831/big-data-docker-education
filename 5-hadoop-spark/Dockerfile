FROM hadoop-hive:latest

# Maintainer information
LABEL maintainer="Big Data Professor <professor@university.edu>"
LABEL description="Hadoop with Spark for big data processing"

# Set environment variables
ENV SPARK_VERSION=3.5.0
ENV SPARK_HOME=/opt/spark
ENV SCALA_VERSION=2.12

# Switch to root for installations
USER root

# Download and install Spark
RUN cd /tmp && \
    wget https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz && \
    tar -xzf spark-3.5.0-bin-hadoop3.tgz && \
    mv spark-3.5.0-bin-hadoop3 $SPARK_HOME && \
    rm spark-3.5.0-bin-hadoop3.tgz

# Set ownership and permissions
RUN chown -R hadoop:hadoop $SPARK_HOME && \
    chmod +x $SPARK_HOME/bin/* && \
    chmod +x $SPARK_HOME/sbin/*

# Copy configuration files
COPY config/spark-env.sh $SPARK_HOME/conf/
COPY config/spark-defaults.conf $SPARK_HOME/conf/

# Copy scripts with correct ownership
COPY --chown=hadoop:hadoop scripts/ /home/hadoop/scripts/

# Switch back to hadoop user
USER hadoop

# Update PATH environment variable
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Set working directory
WORKDIR /home/hadoop

# Default command
CMD ["/home/hadoop/scripts/start-spark.sh"]
