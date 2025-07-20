#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hive and Hadoop environment

# The java implementation to use.
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Hive Configuration Directory can be controlled by:
export HIVE_CONF_DIR=$HIVE_HOME/conf

# Folder containing extra libraries required for hive compilation/execution can be controlled by:
export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib

# Hadoop home
export HADOOP_HOME=/opt/hadoop

# Hadoop configuration directory
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Derby home for metastore
export DERBY_HOME=/opt/derby

# Add Derby to classpath
export CLASSPATH=$CLASSPATH:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar

# Hive heap size
export HADOOP_HEAPSIZE=1024

# HiveServer2 heap size
export HIVE_SERVER2_HEAPSIZE=1024

# Metastore heap size
export HIVE_METASTORE_HEAPSIZE=1024
