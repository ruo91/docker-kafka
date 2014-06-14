#
# Dockerfile - Apache Kafka
#
FROM     ubuntu:14.04
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl supervisor

# JDK
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -LO "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
 && tar xzf jdk-7u55-linux-x64.tar.gz && mv jdk1.7.0_55 /usr/local/jdk && rm -f jdk-7u55-linux-x64.tar.gz \
 && echo '' >> /etc/profile \
 && echo '# JDK' >> /etc/profile \
 && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
 && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile \
 && echo '' >> /etc/profile

# Apache Kafka
ENV KAFKA_VER 0.8.1.1
ENV SCALA_VER 2.10
ENV KAFKA_RELEASE kafka_$SCALA_VER-$KAFKA_VER
ENV KAFKA_HOME $SRC_DIR/$KAFKA_RELEASE
ENV PATH $PATH:$KAFKA_HOME/bin

RUN cd $SRC_DIR && curl -LO "http://www.us.apache.org/dist/kafka/$KAFKA_VER/$KAFKA_RELEASE.tgz" \
 && tar xzf $KAFKA_RELEASE.tgz \
 && echo '# Apache Kafka' >> /etc/profile \
 && echo "export KAFKA_HOME=$KAFKA_HOME" >> /etc/profile \
 && echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> /etc/profile \
 && echo '' >> /etc/profile

# Add in the conf directory
ADD conf/kafka/server.properties	$KAFKA_HOME/config/server.properties
ADD conf/kafka/producer.properties	$KAFKA_HOME/config/producer.properties
ADD conf/kafka/consumer.properties	$KAFKA_HOME/config/consumer.properties
ADD conf/kafka/zookeeper.properties	$KAFKA_HOME/config/zookeeper.properties
ADD conf/kafka/log4j.properties		$KAFKA_HOME/config/log4j.properties
ADD conf/kafka/test-log4j.properties	$KAFKA_HOME/config/test-log4j.properties
ADD conf/kafka/tools-log4j.properties	$KAFKA_HOME/config/tools-log4j.properties

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Port
EXPOSE 2181 9092

# Daemon
CMD ["/usr/bin/supervisord"]
