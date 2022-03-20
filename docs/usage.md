Usage
=====

Using environmental variables, the container clones all repositories from gitlab
at `GITINFO_GITLAB_URL` accessible by the user `GITINFO_GITLAB_USER` and access
token `GITINFO_GITLAB_TOKEN`.

```properties
GITINFO_GITLAB_URL=https://<url>
GITINFO_GITLAB_USER=<username>
GITINFO_GITLAB_TOKEN=<private-access-token>
```

If the GitLab instance is self-hosted and has a self-signed HTTPS certificate,
the CA-certificate should be mounted into the container at `ca.pem:/etc/ssl/certs/ca.pem`.

The container uses various tools to produce HTML statistics reports, accessible
via an nginx-server. The tools are invoked when the script
`/usr/share/gitinfo/gitinfo-update.sh` in the container is called. It is recommended
to setup a cron job or similar on the host to regularly invoke the update in
the container. An example script for that purpose is included in the repository
at `scripts/gitinfo-update.sh`.

Backup
------

This service is stateless and does not require backup.

Docker Compose
--------------

The repository contains a docker-compose example, including a template for
the needed environment variables and ca-certificate mounts.
