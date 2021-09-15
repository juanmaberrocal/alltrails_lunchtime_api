# AllTrails - Lunchtime Restaurant Discovery API
The following guide is written with the expectation that everything will be run through `Docker`. If you want to run this project locally, that is also possible following traditional Rails setups.

## Requirements
This project requires that you have Docker running on your machine. If you do not have Docker installed, please follow [this guide](https://docs.docker.com/engine/install/) to get yourself up and running.

## Dev Setup
To get set up for development, clone this repo into your machine:
```
$ git clone https://github.com/juanmaberrocal/alltrails-lunchtime_api.git
```

Once you have the repo locally, you will need to add create a `.env` file manually (secret keys and are not checked into the repo!)
```
$ touch .env
```
Once your `.env` file has been created, use your editor to add the following environment values:
```
RAILS_MASTER_KEY=[REDACTED]
GOOGLE_MAPS_API_KEY=[REDACTED]
```
(Please reach out to get the necessary keys)

Once you have Docker running on your machine and your ENV variables set up, there are 2 simple steps to follow to have the application up and running:
```
$ docker-compose build
$ docker-compose up
```

To "shut down" the application you can `Ctrl + C` to exit out of the Rails web app, and then do:
```
$ docker-compose down
```

**Important**
If this is the first time running the application, you will need to open a new terminal window **while you have your `docker-compose up` project running** to setup the database:
```
$ docker-compose run api rails db:setup
```
(The database setup also includes running the `seeds.db` which will create a test user!)

If any new migrations are added to the codebase, you will need to do the same as above, but run `db:migrate` instead:
```
$ docker-compose run api rails db:migrate
```

For more details on running a Rails project in Docker, you can [read the official Docker sample](https://docs.docker.com/samples/rails/).

### Test Suite
This project uses `RSpec` as a test suite. To run the test suite you will need to have your docker build running:
```
$ docker-compose up
```

And once again, open a new terminal window and run:
```
$ docker-compose run api bundle exec rspec
```

## Features
This is a simple rails API with a 2 enpoints:
```
POST /search
POST /sign_in
```

### Sign In/Sign Out
Authentication for this project is handled with a 3rd party gem called [API Guard](https://github.com/Gokul595/api_guard). We are only using 1 of the endpoints provided by the gem.

The `/sign_in` endpoint takes in 2 parameters:
```
{ email: [STRING], password: [PASSWORD] }
```
(When you set up the database in your development environment, a test user is automatically created. Refer to `seeds.db` to get the user credentials)

A successful response will return an `Access-Token` header which will contain the JWT required to authenticate the request to the `search` endpoint.

### Search
The `/search` endpoint is restricted to authenticated users only and requires that the request is received with the following header:
```
"Authorization": "Bearer [REDACTED]"
```
This endpoint takes 2 parameters that will be used to query the Google Maps API to search for restaurants:
```
{ query: [STRING], page_token (Optional): [STRING] }
```
The `query` string will allow you to filter the restaurant results. The `page_token` is an optional value that is used for pagination of the Google Maps API response. The `page_token` can be discoverd in the headers of a successful response:
```
"X-Next-Page-Token" => [REDACTED]
```

## Postman
This repo also has 2 Postman files for your convenience when running this project locally:
1. `Localhost.postman_collection.json`
2. `Localhost.postman_environment.json`

You can import these into your Postman workspace and use the 2 endpoints to sign in and search for restaurants. The environment variables are already setup by default to point at your localhost on the port defined by `docker-compose`. The `sign_in` endpoint also has a "test" written which will automatically set your `access_token` variable that will be used in the header of the `search` request.
