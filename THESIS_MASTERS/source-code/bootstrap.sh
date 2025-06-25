# Start ZooKeeper
bin/zookeeper-server-start.sh config/zookeeper.properties


# Start Kafka Server in a separate terminal window
export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" #-->> (optional)
bin/kafka-server-start.sh config/server.properties


# Create a topic named "price-feeds"
bin/kafka-topics.sh --create --topic price-feeds --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1


# Start a Kafka producer and consumer in separate terminal windows
bin/kafka-console-producer.sh --topic price-feeds --bootstrap-server localhost:9092
bin/kafka-console-consumer.sh --topic price-feeds --bootstrap-server localhost:9092