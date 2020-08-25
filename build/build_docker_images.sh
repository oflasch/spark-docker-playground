#!/bin/bash
#


BUILD_DATE="$(date -u +'%Y-%m-%d')"

SHOULD_BUILD_BASE="true"
SHOULD_BUILD_SPARK="true"
SHOULD_BUILD_JUPYTERLAB="true"

SCALA_VERSION="2.12.11"
SPARK_VERSION="3.0.0"
HADOOP_VERSION="3.2"
JUPYTERLAB_VERSION="2.2.6"


function cleanContainers() {
  echo "* cleaning containers..."
  if [[ "${SHOULD_BUILD_JUPYTERLAB}" == "true" ]]
  then
    container="$(docker ps -a | grep 'spark-docker-playground/jupyterlab' | awk '{print $1}')"
    if [ -n "${container}" ]
    then
      echo "  cleaning ${container}"
      docker stop "${container}"
      docker rm "${container}"
    fi
  fi

  if [[ "${SHOULD_BUILD_SPARK}" == "true" ]]
  then
    container="$(docker ps -a | grep 'spark-docker-playground/spark-worker' -m 1 | awk '{print $1}')"
    if [ -n "${container}" ]
    then
      while [ -n "${container}" ];
      do
        echo "  cleaning ${container}"
        docker stop "${container}"
        docker rm "${container}"
        container="$(docker ps -a | grep 'spark-docker-playground/spark-worker' -m 1 | awk '{print $1}')"
      done
    fi

    container="$(docker ps -a | grep 'spark-docker-playground/spark-master' | awk '{print $1}')"
    if [ -n "${container}" ]
    then
      echo "  cleaning ${container}"
      docker stop "${container}"
      docker rm "${container}"
    fi

    container="$(docker ps -a | grep 'spark-docker-playground/spark-base' | awk '{print $1}')"
    if [ -n "${container}" ]
    then
      echo "  cleaning ${container}"
      docker stop "${container}"
      docker rm "${container}"
    fi
  fi

  if [[ "${SHOULD_BUILD_BASE}" == "true" ]]
  then
    container="$(docker ps -a | grep 'spark-docker-playground/base' | awk '{print $1}')"
    if [ -n "${container}" ]
    then
      echo "  cleaning ${container}"
      docker stop "${container}"
      docker rm "${container}"
    fi
  fi
  echo -e "  DONE cleaning containers\n"
}

function cleanImages() {
  echo "* cleaning images..."
  if [[ "${SHOULD_BUILD_JUPYTERLAB}" == "true" ]]
  then
    docker rmi -f "$(docker images | grep -m 1 'spark-docker-playground/jupyterlab' | awk '{print $3}')"
  fi

  if [[ "${SHOULD_BUILD_SPARK}" == "true" ]]
  then
    docker rmi -f "$(docker images | grep -m 1 'spark-docker-playground/spark-worker' | awk '{print $3}')"
    docker rmi -f "$(docker images | grep -m 1 'spark-docker-playground/spark-master' | awk '{print $3}')"
    docker rmi -f "$(docker images | grep -m 1 'spark-docker-playground/spark-base' | awk '{print $3}')"
  fi

  if [[ "${SHOULD_BUILD_BASE}" == "true" ]]
  then
    docker rmi -f "$(docker images | grep -m 1 'spark-docker-playground/base' | awk '{print $3}')"
  fi
  echo -e "  DONE cleaning images\n"
}

function cleanVolume() {
  echo "* cleaning volume..."
  docker volume rm "hadoop-distributed-file-system"
  echo -e "  DONE cleaning volume\n"
}

function buildImages() {
  echo "* building images..."
  if [[ "${SHOULD_BUILD_BASE}" == "true" ]]
  then
    echo "  *** building base image..."
    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      -f docker/base/Dockerfile \
      -t spark-docker-playground/base:latest .
    echo "  DONE building base image"
  fi

  if [[ "${SHOULD_BUILD_SPARK}" == "true" ]]
  then
    echo "  *** building Spark base image..."
    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg hadoop_version="${HADOOP_VERSION}" \
      -f docker/spark-base/Dockerfile \
      -t spark-docker-playground/spark-base:${SPARK_VERSION}-hadoop-${HADOOP_VERSION} .
    echo "  DONE building Spark base image"

    echo "  *** building Spark master image..."
    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg hadoop_version="${HADOOP_VERSION}" \
      -f docker/spark-master/Dockerfile \
      -t spark-docker-playground/spark-master:${SPARK_VERSION}-hadoop-${HADOOP_VERSION} .
    echo "  DONE building Spark master image"

    echo "  *** building Spark worker image..."
    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg hadoop_version="${HADOOP_VERSION}" \
      -f docker/spark-worker/Dockerfile \
      -t spark-docker-playground/spark-worker:${SPARK_VERSION}-hadoop-${HADOOP_VERSION} .
    echo "  DONE building Spark worker image"

  fi

  if [[ "${SHOULD_BUILD_JUPYTERLAB}" == "true" ]]
  then
    echo "  *** building JupyterLab image..."
    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
      -f docker/jupyterlab/Dockerfile \
      -t spark-docker-playground/jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION} .
    echo "  DONE building JupyterLab image"
  fi
  echo -e "  DONE building images\n"
}


cleanContainers;
cleanImages;
cleanVolume;
buildImages;

echo -e "build.sh: ALL DONE\n"

