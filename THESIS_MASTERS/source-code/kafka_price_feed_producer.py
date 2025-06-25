from kafka import KafkaProducer
from time import sleep
from json import dumps

import pandas as pd
import datetime
import requests
import json
import time

import yfinance as yf

conf = {
    'bootstrap.servers': 'localhost:9092',  # Replace with your Kafka broker address
    'client.id': 'price-feed-producer'
}

# Kafka topic to send stock price data
topic = 'price-feeds'

# Ticker symbol of the stock (e.g., Bank of America (BAC))
TICKER = 'BAC'
start_date = datetime.datetime(1950,1,1)
end_date = datetime.datetime(2024,10,31)

# Create a Kafka producer instance
producer = KafkaProducer(conf,
                             value_serializer=lambda x: dumps(x).encode('utf-8'))

def read_price_feed():
    while True:
        try:
            df_yahoo = yf.download(TICKER, start=start_date, end=end_date)
            df_yahoo.index.name = 'Date'
            df_yahoo.columns = ['Adj Close', 'Close', 'High', 'Low', 'Open', 'Volume']

            data = json.loads(df_yahoo)

            # Produce the stock price to the Kafka topic
            producer.produce(topic, key=TICKER, value=data)
            producer.flush()

        except Exception as e:
            print(f"Error fetching/sending stock price: {e}")

        # Sleep for a specified interval (e.g., 5 seconds) before fetching the next price
        time.sleep(30)

# Start sending stock price data
read_price_feed()

# General information about 'Bank of America(BAC)'
bac_stock_info = yf.Ticker(TICKER)
print("General information about 'Bank of America")
print(bac_stock_info.info)