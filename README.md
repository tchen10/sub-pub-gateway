# README

A simple rails service to demonstrate consuming and publishing from a message queue.

# Stack Overview

- Ruby 2.4
- Rails 5.1.4
- Docker & Docker Compose
- RabbitMq

# Set up
  
- Follow the instructions to install [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). 
- Once docker is installed, run 
```
docker-compose up --build
```
- When you build and start the container, it will automatically start your Sneakers service.

- To stop the application, go to your terminal where you are running the docker containers and press `CTRL+C`.
- To stop the services, run `docker-compose stop`.
- To stop the containers, run `docker-compose down`.

## Local development

Once you have created your images, you can use `docker-compose up` to start the containers.  Please refer to `docker-compose help` for all commands.

Developing a Rails application on a docker container is not so different from development in a local environment.  You should be able to run all commands as you normally would, but you must prefix them with `docker-compose exec ${name of container}`. The containers are named as so:
- `gateway` - runs Sneakers

For example, running bundle install on the Rails service looks like:
```
docker-compose exec gateway bundle install
```

See the `docker-compose.yml` in the root of the project for configuration.

# Consuming and Publishing Messages

This service publishes messages to an AMQP server using [RabbitMq](https://www.rabbitmq.com/).  You can start this server following the directions in the `message-queue` repository. 

This service uses [Sneakers](https://github.com/jondot/sneakers/wiki) to listening to the queues and run background jobs.  Starting the docker container will also start sneakers.
To start it manually, you can use `docker-compose exec gateway rake sneakers:run`

# Testing

## Unit tests

```
docker-compose exec gateway rspec
```

## Mountebank

[Mountebank](http://www.mbtest.org/) allows you to stub out responses from external dependencies.  This service depends on an external service to provide the account key.

To use Mountebank, you'll need to install it:

```
npm install -g mountebank
```

To run Mountebank with the configured stubs:
```
 mb --configfile config/mountebank/imposters.ejs --allowInjection --logfile tmp/mb.log
```

Once Mountebank is running, you can go to `localhost:2525` to view the Mountebank help documentation.
Our stubbed service lives at `localhost:9001/v1/account`.  To point the application to the stub, you can 

There are a few simple stubs in available:

POST /v1/account with body:
```json
{
  "email": "user1@email.com",
  "key": "1_key"
}
```
or

```json
{
  "email": "user2@email.com",
  "account_key": "2_account_key"
}
```

will return account keys.  Any other request to localhost:9001 will return back a 200 and an error message, like the real account service.
