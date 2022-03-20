FROM nginx:latest
LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        gnuplot \
        gitinspector \
        jq \
        make \
        python2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#hadolint ignore=DL3059
RUN git clone https://github.com/hoxu/gitstats.git /tmp/gitstats \
    && make -C /tmp/gitstats install \
    && rm -rf /tmp/gitstats

COPY --chmod=555 --chown=root:root app/gitinfo /usr/share/gitinfo
COPY --chmod=555 --chown=root:root app/gitinfo.conf.template /etc/nginx/templates/gitinfo.conf.template
COPY --chmod=555 --chown=root:root app/gitinfo-setup.sh /docker-entrypoint.d/00-gitinfo-setup.sh

RUN rm -rf /usr/share/nginx/html
COPY --chmod=555 --chown=root:root app/html /usr/share/nginx/html

RUN git config --system credential.helper /usr/share/gitinfo/gitinfo-credentials.sh \
    && git config --system pull.ff only
