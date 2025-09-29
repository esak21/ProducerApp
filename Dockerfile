FROM python:3.11-bullseye as spark-base

# optional Env Values
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
ENV APACHE_SPARK_VERSION 3.5.6
ENV HADOOP_VERSION 3
ENV APP_HOME=${APP_HOME:-"/app"}
ENV DATA_HOME=${APP_HOME:-"/app/data"}
RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME} && mkdir -p ${APP_HOME} && mkdir -p ${DATA_HOME}


ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y --no-install-recommends  \
      sudo \
      curl \
      vim \
      unzip \
      rsync \
      openjdk-11-jdk \
      build-essential \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR ${SPARK_HOME}

RUN curl -L https://dlcdn.apache.org/spark/spark-$APACHE_SPARK_VERSION/spark-$APACHE_SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -o spark.tgz  \
    && tar -xvzf spark.tgz --directory /opt/spark --strip-components 1  \
    && rm spark.tgz


RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

WORKDIR ${APP_HOME}
COPY requirements.txt .
COPY book_data ./data
RUN pip install -r requirements.txt

COPY src/ ${APP_HOME}
COPY workflow.sh .

CMD ["/app/workflow.sh"]
