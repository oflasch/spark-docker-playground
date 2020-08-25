ARG openjdk_image_tag=11-jre-slim
FROM openjdk:${openjdk_image_tag}

# -- Layer: Image Metadata
ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Spark Docker Playground - Cluster base image"
LABEL org.label-schema.url="https://github.com/oflasch/spark-docker-playground"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: OS + Python + Scala
ARG scala_version
ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace}/data && \
    mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y curl python3 r-base && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    curl https://downloads.lightbend.com/scala/${scala_version}/scala-${scala_version}.deb -k -o scala.deb && \
    apt install -y ./scala.deb && \
    rm -rf scala.deb /var/lib/apt/lists/*

ENV SCALA_HOME="/usr/bin/scala"
ENV PATH=${PATH}:${SCALA_HOME}/bin
ENV SHARED_WORKSPACE=${shared_workspace}

# -- Runtime
VOLUME ${shared_workspace}
CMD ["bash"]

