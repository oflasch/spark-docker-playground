ARG spark_version
ARG hadoop_version
FROM spark-docker-playground/spark-base:${spark_version}-hadoop-${hadoop_version}

# -- Layer: Image Metadata
ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Spark Docker Playground - Spark master image"
LABEL org.label-schema.url="https://github.com/oflasch/spark-docker-playground"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime
EXPOSE 8080 7077

CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out

