from kafka import KafkaConsumer
import csv
import os
from datetime import datetime

csv_file = "stock_prices_feed"

# Kafka consumer configuration
conf = {
    'bootstrap.servers': 'localhost:9092',  # Replace with your Kafka broker address
    'group.id': 'my-group',
    'auto.offset.reset': 'earliest'
}

# Create a Kafka consumer instance
try:
    consumer = KafkaConsumer(conf)
except Exception as e:
    print("An error occurred while initializing the Kafka consumer:", e)
    consumer = None

# Subscribe to a Kafka topic
topic = 'price-feeds'
consumer.subscribe([topic])

# Consume messages
while True:
    msg = consumer.poll(1.0)
    
    if msg is None:
        continue
    else:
        print(f'received {msg.value().decode("utf-8")}')
        data_price = [(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), msg.value().decode("utf-8"))]
        if not os.path.exists(csv_file):
            with open(csv_file, mode="w", newline="") as file:
                writer = csv.writer(file)
                writer.writerow(['Adj Close', 'Close', 'High', 'Low', 'Open', 'Volume'])  # Header
                writer.writerows(data_price)
        else:
            # If it exists, open it in append mode and add data
            with open(csv_file, mode="a", newline="") as file:
                writer = csv.writer(file)
                writer.writerows(data_price)