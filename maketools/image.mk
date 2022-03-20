IMAGE := perbohlin/gitinfo
TAG := test

image:
	$(Q)docker build . \
		-t $(IMAGE):$(TAG)

tag:
	$(Q)docker tag $(IMAGE):$(TAG) $(IMAGE):latest

publish: tag
	$(Q)docker push $(IMAGE):latest

up:
	$(Q)$(ROOT.dir)/bin/docker-compose.sh up -d

down:
	$(Q)$(ROOT.dir)/bin/docker-compose.sh down
