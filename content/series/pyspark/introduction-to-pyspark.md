---
title: "Introduction to PySpark"
date: 2026-02-24T13:00:00+00:00
weight: 120
draft: false
toc: true
---

## Brief introduction to Big Data

Big Data refers to datasets that are large, growing, and complex. It is commonly described by the 4 V's:

- **Volume** — the sheer amount of data. Large datasets require parallel and distributed processing to be processed efficiently.
- **Velocity** — data is generated continuously at high speed (streaming, logs, events).
- **Variety** — data appears in many formats: structured (tables), semi-structured (JSON, CSV), and unstructured (images, video). Different formats require different processing methods.
- **Veracity** — data quality and correctness. Noisy or incorrect data can lead to misleading results, so validation and cleansing are important.

## Hadoop

Hadoop is a distributed platform for storing and processing big data. Two core components are:

- **HDFS** (Hadoop Distributed File System) — stores large files across a cluster, inspired by the Google File System. It follows a write-once, read-many pattern and maintains fault tolerance via replication.
	- **NameNode** — master that holds metadata (file namespace, block locations).
	- **DataNode** — worker nodes that store data blocks.

- **MapReduce** — a programming model and engine for distributed computation. It splits jobs into Map and Reduce phases and scales horizontally.

MapReduce writes intermediate results to HDFS between jobs, which can add significant I/O overhead. Spark addresses this by keeping working data in memory where possible.

## Spark

Apache Spark is a distributed computation framework that accelerates big-data processing by using in-memory computation and a richer set of APIs. Spark supports:

- batch processing,
- streaming,
- machine learning (MLlib),
- graph processing (GraphFrames),
- SQL and DataFrame APIs.

Spark can read and write many formats (CSV, JSON, Parquet, ORC) and integrates with storage systems such as HDFS, S3 and relational databases via JDBC.

### PySpark and PySpark SQL

PySpark is the Python API for Spark. `PySpark SQL` provides a high-level abstraction over the core engine with DataFrame and SQL APIs, making it approachable for users familiar with databases. It supports writing queries in the DataFrame DSL as well as standard SQL/HiveQL.

PySpark is commonly used to:

- read data from various sources,
- perform ETL and transformations,
- run analytics and exploratory queries,
- train ML models at scale.

Supported sources include local files, HDFS, S3, Kafka and relational databases (PostgreSQL, MySQL) via JDBC.

---

If you want, I can also:

- add examples showing how to read CSV/Parquet in PySpark,
- add a sample PySpark job and `spark-submit` command,
- or format this content to match the site’s front-matter conventions for the `series` section.











