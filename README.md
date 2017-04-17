# Merritt

[![Slack](https://merritt-slack.herokuapp.com/badge.svg)](https://merritt-slack.herokuapp.com/) [![Build Status](https://travis-ci.org/merritt/merritt.svg?branch=master)](https://travis-ci.org/merritt/merritt)

## Contributing

### Quickstart

The fastest way to get started is to use our `docker-compose.dev.yml` file.  This
will build the backend, frontend and then provide a live view for any changes made
to the UI.

Clone the repo and run:

```shell
./script/dev.sh
```

That will take a while the first time this is run as it will download all the
dependencies and build the backend and frontend applications.

After that finishes, you should be able to visit
[http://localhost:3000](http://localhost:3000) to see the app.

### Building and running merritt as a binary

To build `merritt`, clone the repo and run:

```shell
./script/make.sh
```

`merritt` can then be run using:

```shell
cd build
./merritt
```

### Building and running merritt as a Docker image

To build `merritt/merritt`, clone the repo and run:

```shell
./script/make.sh image
```

`merritt/merritt` can then be run using:

#### Using Compose

```shell
docker-compose up
```

#### Using Docker CLI

```shell
docker run -it \
    -p 8080:8080 \
    merritt/merritt run
```