require 'sneakers'
require 'sneakers/handlers/maxretry'

Sneakers.configure(:amqp => ENV['MESSAGE_QUEUE_URL'],
                   :retry_timeout => 60 * 1000,
                   :ack => true,
                   :timeout_job_after => 5,
                   :prefetch => 10,
                   :threads => 10,
                   :durable => true,
                   :handler => Sneakers::Handlers::Maxretry,
                   :retry_max_times => 10
)

Sneakers.logger.level = Logger::INFO