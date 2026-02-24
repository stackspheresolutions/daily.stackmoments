 



1. Why is “move code to data” faster than “move data to code”?
When your data is small, dragging it all to your laptop or a single server to crunch is fine. But once you’re in the terabytes or petabytes range, that plan collapses because:
Memory limits: A single compute node can’t hold all that data.
Network bottlenecks: Shipping TBs across the network is painfully slow and expensive.
Parallelism lost: If you centralize all data on one machine, you kill the whole point of distributed computing.

Instead, Spark ships the code—a small serialized function, often just a few kilobytes—to where the data partitions already live across the cluster nodes. Each worker executes the logic locally, and only the final aggregated results (often much smaller) flow back to the driver.

So the motto is: “Move tiny code to big data, not big data to tiny code.”
That principle is why Spark, Hadoop, and similar systems scale so well.  

2. Name the three stages of MapReduce and identify which one causes the big network shuffle.
MapReduce has three stages:
Map → Each worker processes its local chunk of data and emits key–value pairs.
Shuffle → All values with the same key are moved across the cluster so they can be grouped together. This is where the network traffic explodes, because data has to be redistributed between nodes.
Reduce → The grouped values are aggregated (sum, count, average, etc.) on the receiving node.
The killer stage is Shuffle. Even if you “move code to data” during the map phase, the shuffle stage sometimes forces you to move data to data, which can become the bottleneck. Spark spends a lot of engineering effort (e.g., reduceByKey, map-side combine, AQE) to minimize shuffles because they’re the most expensive step.
3. Explain why reduceByKey() is better than groupByKey()
Both groupByKey() and reduceByKey() aim to group values that share the same key, but they behave very differently during the shuffle stage.
---
title: "PySpark Quick Checks"
date: 2026-02-24T13:00:00+00:00
weight: 130
draft: false
toc: true
---

A compact Q&A checklist for common PySpark concepts and best practices. Use this as a quick refresher when designing jobs or debugging performance.

### 1. Why is “move code to data” faster than “move data to code”?

Moving small code to the data is faster because networks and memory are limited. Shipping terabytes across the network is slow and expensive; sending a small serialized function to each worker and running it locally avoids large I/O transfers and preserves parallelism.

### 2. Three stages of MapReduce — which causes the big shuffle?

- Map: emits key–value pairs from local data.
- Shuffle: redistributes values by key across the cluster (this causes heavy network I/O).
- Reduce: aggregates grouped values.

The shuffle stage is the expensive one; minimizing shuffle volume is critical for performance.

### 3. Why prefer `reduceByKey()` over `groupByKey()`?

- `groupByKey()` shuffles all values for a key and aggregates them on the reducer — high network I/O and memory usage.
- `reduceByKey()` performs local combiners on each mapper/partition, sending only partial aggregates across the network, greatly reducing shuffle.

Rule: use `reduceByKey()` (or `aggregateByKey()`/`combineByKey()`) for aggregations; use `groupByKey()` only if you need all raw values.

### 4. `reduceByKey`, `aggregateByKey`, `combineByKey` — when to use each?

- `reduceByKey()` — `(K, V) -> (K, V)`; use for simple associative/commutative reductions (sum, max).
- `aggregateByKey()` — `(K, V) -> (K, U)`; use when you need richer accumulators with an initial zero value.
- `combineByKey()` — `(K, V) -> (K, C)`; most flexible: different input/output types and custom combine logic.

### 5. What makes RDDs “resilient”?

RDDs record lineage (the transformations used to create them). If a partition is lost, Spark recomputes it from lineage rather than storing every intermediate result, enabling fault recovery without full replication.

### 6. Transformation vs Action

- Transformation: lazy operations (e.g., `map`, `filter`, `groupByKey`) that build the plan.
- Action: triggers execution (e.g., `collect`, `count`, `saveAsTextFile`).

Only actions execute the DAG built by transformations.

### 7. Practical benefit of AQE (Adaptive Query Execution)

AQE adapts the physical plan at runtime (e.g., switching to a broadcast join or handling skewed partitions), reducing shuffle and memory pressure and often preventing OOMs.

### 8. `.withColumn()` vs `.select()`

- `.withColumn(name, expr)` — adds or replaces a column and preserves other columns.
- `.select(...)` — projects a new DataFrame with only the requested columns.

Use `.withColumn()` to add/update, and `.select()` to reshape the column set.

### 9. Replace NULL ages with 0

Example:

```py
df = df.na.fill({"age": 0})
# or
from pyspark.sql.functions import coalesce, lit
df = df.withColumn("age", coalesce(df.age, lit(0)))
```

### 10. Unit of parallelism

The partition is the basic unit of parallelism; each partition is processed by one task on a single executor core. More partitions → more tasks → more parallelism (up to cluster capacity).

### 11. How Spark creates partitions when reading from S3

- Text/CSV/JSON: split by byte ranges if the format is splittable.
- Parquet/ORC: split by row groups.
- Non-splittable formats (gzipped): one file equals one partition.

### 12. `repartition()` vs `coalesce()`

- `repartition(n)` — full shuffle to increase or decrease partitions (expensive).
- `coalesce(n)` — merges partitions without a full shuffle (cheaper, used to reduce partitions).

### 13. Why `partitionBy()` when writing to S3?

It lays out directory-style partitions (e.g., `year=2023/month=01/`) so queries can prune irrelevant folders and avoid scanning the full dataset.

### 14. What does AWS Glue store when you write partitioned data?

Glue stores table metadata (schema, format, location), partition columns, and partition entries that map to S3 prefixes.

### 15. Mixed file formats in a Glue table

Mixing formats (Parquet + CSV) under one table/prefix leads to schema mismatches and query failures; use separate tables or consistent formats.

### 16. How partition pruning improves performance

It scans only relevant partition folders instead of the whole dataset, reducing I/O and cost.

### 17. The small-files problem

Many small files create many tasks and high scheduling/request overhead (especially on S3 where each file is an HTTP request). Prefer larger files (proper batching or compacting).

### 18. 100 executors but 10 partitions

Underutilization: only 10 tasks will run and most executors will be idle. Increase partitions to match cluster resources for better parallelism.

### 19. Useful Spark configs for file partitioning

- `spark.sql.files.maxPartitionBytes` — bytes per input split (default ≈128 MB).
- `spark.sql.shuffle.partitions` — number of output partitions after wide operations (default 200).

### 20. The unifying API for external sources

The DataSource API (`spark.read`, `df.write`) abstracts reads/writes for many formats (CSV, Parquet, JSON, JDBC, Hive, etc.).

### 21. Parquet/ORC vs CSV/JSON

Prefer Parquet/ORC for analytics: columnar storage, compression, schema, and faster scans. Use CSV/JSON for interchange or small datasets.

### 22. `textFile()` vs `read.text()`

- `sc.textFile(...)` → returns an `RDD[String]`.
- `spark.read.text(...)` → returns a `DataFrame` with a `value` string column (better for SQL/DataFrame ops).

### 23. Advantage of `s3a://`

`s3a://` is the modern connector with better performance, support for large files, and integration with IAM and multipart uploads.

### 24. MySQL read/write snippet

```py
jdbcDF = spark.read.format("jdbc") \
	.option("url", "jdbc:mysql://localhost:3306/mydb") \
	.option("dbtable", "users") \
	.option("user", "root") \
	.option("password", "mypassword") \
	.load()

jdbcDF.write.format("jdbc") \
	.option("url", "jdbc:mysql://localhost:3306/mydb") \
	.option("dbtable", "users_cleaned") \
	.option("user", "root") \
	.option("password", "mypassword") \
	.mode("overwrite") \
	.save()
```

### 25. Common write modes

`append`, `overwrite`, `ignore`, `error` (or `errorifexists`).

### 26. Query a temporary view

```py
df.createOrReplaceTempView("mytable")
spark.sql("SELECT * FROM mytable WHERE age > 30")
```

### 27. Reading gzipped CSV

Gzip is not splittable: one executor reads the whole file, which hurts parallelism for large gzipped files.

### 28. Partitioned Parquet vs flat CSV on S3

Partitioned Parquet allows pruning and faster columnar scans; flat CSV leads to larger scans and schema-on-read overhead.

### 29. Avoid reading unnecessary partitions

Use partition pruning—Spark reads partition metadata (from Hive/Glue) and skips irrelevant S3 folders.

---

If you'd like, I can convert this into a short printable checklist or create a collapsible FAQ widget for the series sidebar.
