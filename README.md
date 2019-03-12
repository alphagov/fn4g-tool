# FN4G Tool

## Purpose

This tool provides a questionnaire to evaluate an organisation's alignment to security standards, with a view to
help standards adoption.

## Requirements

The application is bundled in a Docker image, only [Docker-Compose](https://docs.docker.com/compose/install/)
is required to run it locally.

## How to install and use

To start up the application locally, execute:

```shell
make serve
```

Other useful Makefile targets are:

- `make build` - builds the docker image without starting the application
- `make bash` - run a shell in the docker composed application
- `make stop` - stop the application
- `make db` - start up the database container
