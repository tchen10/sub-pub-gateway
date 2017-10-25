require 'sneakers'

Sneakers.configure(:amqp => ENV['MESSAGE_QUEUE_URL'])