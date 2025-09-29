from pyspark.sql import SparkSession
import logging

def setup_logging():
    pass

def main():
    logger = logging.getLogger(__name__)
    logger.info("+++++++++++ Starting Application ++++++++")
    spark = SparkSession.builder.appName("erdmApp").master("local[*]").getOrCreate()
    logger.info("+++++++++++ Reading data from csv ++++++++++")
    df = spark.read.format("csv").option("header", "true").option("inferSchema", "true").load("/app/data/sample.csv")
    logger.info(df.count())
    print(df.count())
    print(df.printSchema())
    logger.info("+++++++++++ Ending  Application ++++++++")


if __name__ == "__main__":
    main()
