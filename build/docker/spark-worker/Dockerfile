ARG spark_version
ARG hadoop_version
FROM spark-docker-playground/spark-base:${spark_version}-hadoop-${hadoop_version}

# -- Layer: Image Metadata
ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Spark Docker Playground - Spark worker image"
LABEL org.label-schema.url="https://github.com/andre-marcos-perez/spark-cluster-on-docker"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime
EXPOSE 8081

CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out

