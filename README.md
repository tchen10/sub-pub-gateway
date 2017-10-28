# README

A simple rails service to demonstrate consuming and publishing from a message queue.

# Stack Overview

- Ruby 2.4
- Rails 5.1.4
- Docker & Docker Compose

# Set up
  
- Follow the instructions to install [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). 
- Once docker is installed, run 
```
docker-compose up --build
```

- To stop the application, go to your terminal where you are running the docker containers and press `CTRL+C`.
- To stop the services, run `docker-compose stop`.
- To stop the containers, run `docker-compose down`.

## Local development

Once you have created your images, you can use `docker-compose up` to start the containers. Some helpful commands:

- `docker-compose ps` : List containers
- `docker-compose start` : Start services
- `docker-compose stop` : Stop services
- `docker-compose exec` : Execute a command on a container
- `docker-compose run` : Execute a one-off command on a container

Please refer to `docker-compose help` for all commands.

Developing a Rails application on a docker container is not so different from development in a local environment.  You should be able to run all commands as you normally would, but you must prefix them with `docker-compose exec ${name of container}`. The containers are named as so:
- `gateway` - Sneakers

For example, running bundle install on the Rails service looks like:
```
docker-compose exec gateway bundle install
```

See the `docker-compose.yml` in the root of the project for configuration.

# Consuming and Publishing Messages

This service publishes messages to an AMQP server using [RabbitMq](https://www.rabbitmq.com/).  You can start this server following the direections in the `message-queue` repository. 

This service uses [Sneakers](https://github.com/jondot/sneakers/wiki) to process background jobs, like listening to the queues.  Starting the docker container will also start sneakers.
To start it manually, you can use `docker-compose exec gateway rake sneakers:run`

# Testing

## Unit tests

```
docker-compose exec gateway rspec
```

