FROM spark-docker-playground/base

# -- Layer: Image Metadata
ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Spark Docker Playground - JupyterLab image"
LABEL org.label-schema.url="https://github.com/oflasch/spark-docker-playground"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: JupyterLab + Python kernel for PySpark
ARG spark_version
ARG jupyterlab_version

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    pip3 install --upgrade pip && \
    pip3 install pyspark==${spark_version} jupyterlab==${jupyterlab_version}

# -- Layer: Scala kernel for Spark
ARG scala_version

RUN apt-get install -y ca-certificates-java --no-install-recommends && \
    curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier launch --fork almond:0.10.0 --scala ${scala_version} -- --display-name "Scala ${scala_version}" --install && \
    rm -f coursier

# -- Runtime
EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
ADD workspace/ ${SHARED_WORKSPACE}/

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=

