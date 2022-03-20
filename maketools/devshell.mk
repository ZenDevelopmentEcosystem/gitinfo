include ../../maketools/common.mk

.PHONY: dev-shell
dev-shell: export GITINFO_GITLAB_URL := $(GITINFO_GITLAB_URL)
dev-shell: export GITINFO_GITLAB_TOKEN := $(GITINFO_GITLAB_TOKEN)
dev-shell: export GITINFO_GITLAB_USER := $(GITINFO_GITLAB_USER)
dev-shell:
	$(Q)bash --rcfile $(ROOT.dir)/gitinfo-devenv.rc
