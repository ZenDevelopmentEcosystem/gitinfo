Development
===========

Application Scripting
---------------------

For local development of GitInfo, a bash shell prepared for development can be started
by running ():

```shell
make dev-shell
```

It sources the two main entry-points `gitinfo-init.sh` and `gitinfo-update.sh`.
It also creates two utility functions `gitinfo-devenv-setup` and `gitinfo-devenv-source`.
When the shell is exited `gitinfo-devenv-clean` is run.

Docker Compose
--------------

For convenience, the make system can bring up a container using docker compose
with the command:

```shell
make up
```

If local test environment specific details need to be added, a file named
`local-docker-compose.yml` can be added to the directory root.
This extra file is not included when running static check on the included docker-compose.yml file.
