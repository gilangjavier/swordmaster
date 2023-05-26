#Install pika first "pip install pika"
import pika

#Change localhost, 5672, user and password with your rabbitmq credential
parameters = pika.ConnectionParameters('localhost', 5672, '/',
                pika.PlainCredentials('user', 'password'))

connection = pika.BlockingConnection(parameters)

if connection.is_open:
    print('Connected to RabbitMQ')
    connection.close()
else:
    print('cannot connect to RabbitMQ')