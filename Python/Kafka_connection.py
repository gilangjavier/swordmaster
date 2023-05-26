#install confluent_kafka = pip install confluent-kafka
from confluent_kafka import Consumer, KafkaException
import sys

def check_kafka_connection(broker, group, topic):
    # Consumer configuration
    conf = {
        'bootstrap.servers': broker,
        'group.id': group,
        'session.timeout.ms': 6000,
        'default.topic.config': {
            'auto.offset.reset': 'earliest'
        }
    }

    # Create Consumer instance
    c = Consumer(conf)

    # Try to get metadata for topic
    try:
        c.list_topics(topic)
        print(f"Successfully connected to topic {topic} on Kafka broker at {broker}")
    except KafkaException as e:
        print(f"Failed to connect to topic {topic} on Kafka broker at {broker}: {e}")

    # Close down consumer to commit final offsets.
    c.close()

# Ask user for broker, group, and topic
broker = input("Enter the address of the Kafka broker: ")
group = input("Enter the group id: ")
topic = input("Enter the topic: ")

check_kafka_connection(broker, group, topic)