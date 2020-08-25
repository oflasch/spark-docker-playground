# spark-docker-playground
A minimal standalone Spark cluster with JupyterLab UI, running in Docker, suitable for learning and experimenting.

This is based on the excellent work of Andre Marcos Perez ( see https://towardsdatascience.com/apache-spark-cluster-on-docker-ft-a-juyterlab-interface-418383c95445 ).


## Installation

1. Clone the repository.
1. Run `build/build_docker_images.sh` to build the required docker images.

If all images were built successfully, `docker image ls` should include the following new images:

```bash
REPOSITORY                             TAG                 IMAGE ID            CREATED              SIZE
spark-docker-playground/jupyterlab     2.2.6-spark-3.0.0   c20aa4526225        About a minute ago   2GB
spark-docker-playground/spark-worker   3.0.0-hadoop-3.2    60593382d6ca        6 minutes ago        1.25GB
spark-docker-playground/spark-master   3.0.0-hadoop-3.2    aa97397da72e        6 minutes ago        1.25GB
spark-docker-playground/spark-base     3.0.0-hadoop-3.2    a0be2864807f        6 minutes ago        1.25GB
spark-docker-playground/base           latest              2657f93878b7        9 minutes ago        1GB
openjdk                                11-jre-slim         2be0fcbbbb6e        2 weeks ago          204MB
```


## Starting the Cluster

1. Run `run_spark_cluster.sh`.

After the cluster components start up, you can connect to the following services:

* **JupyterLab** at http://localhost:8888
* **Spark master web UI** at http://localhost:8080
* **Spark worker #1 web UI** at http://localhost:8081
* **Spark worker #2 web UI** at http://localhost:8082

Press `ctrl+c` to shutdown.

