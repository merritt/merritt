This is a strawman proposal for the design of Merritt.

# Goal
The goal of `merritt/merritt` is to create an open source container management application.  This will be assembled from a variety of "extensions" that are implemented in containers.  Each service will provide a standard interface for implementation and a GRPC API for other services to use.

# Components
To facilitate the extension model, the following "core" services will be implemented:

## merritt/merritt
This will be the assembly point and the repo that will generate the output for the application.

## merritt/axiom
Axiom is a container metadata service.  This communicates with the lower level container service and exposes an API that can be consumed to view and manage the lower level executor.  This will work across multiple hosts to give entire cluster management.

## merritt/datastore
The datastore component is a super simple datastore service that is used to store very simple data such as configuration.  This would be used for built in account management as well as basic metadata and configuration.  This is not intended to be a large clunky hard to scale service.  This is meant to be a very lightweight data storage service.

## merritt/auth
The auth service is a simple authentication service.  Initially this would be the backend for the simple builtin auth service but could be expanded to support something like `google/oauth2`.  The auth service depends on a datastore compatible service.

## merritt/controller
The controller is the core backend service.  It is what contains the logic for the application as well as the integration and "glue" point between the components.  The controller depends on the core services: axiom, auth and datastore.  The controller defines the API for consumption by the ui and cli.

## merritt/ui
The ui is the user interface is a web based application providing management.  It supports the Merrit API provided by the controller.

## merritt/cli
This is a standalone component that uses the Merritt API provided by the controller.
