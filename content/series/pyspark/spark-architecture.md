title: "Spark Architecture"
date: 2026-02-24T13:00:00+00:00
weight: 100
draft: false
toc: true
Spark is built for large-scale data. Hadoop MapReduce used to handle such workloads, but it required writing a lot of low-level code and was often slow. Spark changed the game with:

- **Speed** — in-memory computation and optimized execution (up to 100× faster than MapReduce for some workloads).
- **Simplicity** — high-level APIs (map, filter, reduce and richer DataFrame/SQL APIs) that feel like normal programming while running distributed.
- **Flexibility** — supports batch jobs, streaming, ML, SQL and graph processing in one framework.
- **Compatibility** — reads/writes many formats (S3, HDFS, JDBC, JSON, Parquet, Avro, etc.).

When data is too large to fit on a single machine (for example, terabytes), don’t move the data to the code—move the small piece of code to the data. This is data-parallel processing, and Spark achieves this via RDDs, DataFrames and Spark SQL. Spark 3 adds features like Adaptive Query Execution (AQE) and Dynamic Partition Pruning to make queries smarter and faster.

## Spark Architecture

Key players in Spark orchestration:

- Driver program
- Cluster manager
- Executors (workers)
- `SparkSession`
- `SparkContext`

**Rule of thumb:**

- Use `SparkSession` for DataFrames and SQL.
- Use `SparkContext` for low-level RDD operations.

### Driver program

The driver builds the logical DAG of transformations. The DAG scheduler splits the DAG into stages (based on shuffle boundaries) and into tasks (one per partition). A stage is a set of tasks that can run in parallel.

The driver also interacts with data sources to enumerate input splits. Examples:

- **RDD API** — `sc.textFile(path, minPartitions)`
  - The driver creates a `HadoopRDD` and calls `FileInputFormat.getSplits(...)`. Splits are computed from file sizes, filesystem block sizes and related configs such as `mapreduce.input.fileinputformat.split.minsize` and `mapreduce.input.fileinputformat.split.maxsize`.

- **DataFrame API** — CSV/JSON/Parquet/ORC
  - The driver lists files and groups bytes into file partitions using knobs like `spark.sql.files.maxPartitionBytes` (default ~128 MB) and `spark.sql.files.openCostInBytes`. Parquet may align partitions on row groups when possible.

- **JDBC**
  - The driver computes numeric ranges from `partitionColumn`, `lowerBound`, `upperBound`, `numPartitions`. If you don’t set these, you typically get a single split.

- **Kafka**
  - Splits are Kafka partitions + offset ranges; the driver maps them to tasks.

- **Local collections** — `sc.parallelize(data, numSlices)` slices a local collection into `numSlices` partitions.

The number and type of partitions determine how many tasks are created. The driver’s task scheduler sends serialized tasks to executors; the cluster manager allocates resources (CPU/memory) and provides executors.

> All of this work happens only when the first *action* is invoked.

### What is an action?

An *action* is any API call that forces Spark to execute the plan and produce results. Until an action runs, transformations only build the logical plan (lazy evaluation).

Common actions: `collect()`, `count()`, `saveAsTextFile()`, `show()`.

### What an action does

When an action runs, Spark will:

- analyze and optimize the logical plan,
- enumerate input splits,
- create stages and tasks,
- schedule tasks on executors,
- move/shuffle data as required,
- return results or write output.

### Cluster manager

The cluster manager decides where and how many resources (CPU, memory) to give your job. Spark supports several managers:

- Standalone (Spark’s built-in manager)
- YARN (Hadoop resource manager)
- Mesos
- Kubernetes (popular for cloud-native deployments)

The cluster manager does not compute— it allocates compute slots and manages resources.

### Executor

Executors are JVM processes launched on worker nodes. Each executor:

- runs multiple tasks,
- holds cache/memory (RDDs/DataFrames cached in executor memory),
- reports results and status back to the driver.

Executors are ephemeral—when the job ends they are torn down and a new run will create new executors.

### SparkSession vs SparkContext

`SparkSession` (introduced in Spark 2.x) is the unified entry point for DataFrame and SQL APIs, configuration and catalogs. Access the lower-level `SparkContext` via `spark.sparkContext` when you need RDD operations.

## FAQs

1. **Why is “move code to data” faster than “move data to code”?**

	Data is large and costly to transfer; code is small. Shipping a small function to nodes that already hold the data avoids expensive network and disk I/O. This is the core idea behind data-parallel frameworks like Spark.

2. **Name the three stages of MapReduce and which one causes the big network shuffle.**

	- **Map** — processes input and emits key-value pairs.
	- **Shuffle** — groups values by key across the cluster; this is where the heavy network transfer happens.
	- **Reduce** — aggregates values per key (e.g., sum).

	The shuffle is the performance killer; techniques that reduce shuffle volume (e.g., pre-aggregation) help performance.

3. **What makes RDDs “resilient”? (Hint: lineage.)**

	RDDs record the transformations that produced them (lineage). If a partition is lost, Spark can recompute it from earlier data using the lineage DAG rather than storing every intermediate result.

4. **Transformation vs Action — which triggers execution?**

	- **Transformation** builds a logical (lazy) plan (e.g., `map()`, `filter()`, `groupBy()`).
	- **Action** triggers execution of the plan (e.g., `collect()`, `count()`, `saveAsTextFile()`).

	Only actions trigger execution.

5. **One practical benefit of AQE (Adaptive Query Execution)**

	AQE lets Spark optimize queries at runtime. For example, if Spark discovers a table is smaller than expected, it can switch to a broadcast join mid-flight, reducing shuffle and memory pressure. In practice this leads to faster joins, fewer OOM errors, and more robust performance even with outdated table statistics.