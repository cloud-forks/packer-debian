
#%:
#	$(eval p := $(subst /, , $*))
#	$(eval os := $(shell basename $(CURDIR)))
#	$(eval target := $(word 1, $(p))-$(word 2, $(p)))
#	$(eval builder := $(word 3, $(p)))
#	$(eval outputdir := $(CURDIR)/output/$(os)-$(target))
#	find $(CURDIR)/output/ -maxdepth 1 -name '$(os)-$(target)-*' -type d -print0 | xargs -0 -I {} /bin/rm -r "{}"
#	@echo building $(os)-$(target)
#	@PACKER_LOG="yes" PACKER_CONFIG=$(CURDIR)/.packerconfig PACKER_LOG_PATH=$(CURDIR)/logs/$(builder)-$(target).log packer build -only=$(builder) $(target).json

build:
	$(eval TPL := $(filter-out $@,$(MAKECMDGOALS)))
	$(eval builders := $(shell jq '.builders[] | .type' $(TPL).json | tr -d '"'))
	$(eval outputdir := $(CURDIR)/output/$(TPL))
	find $(CURDIR)/output/ -maxdepth 1 -name '$(TPL)-*' -type d -print0 | xargs -0 -I {} /bin/rm -r "{}"
	@echo building $(TPL)
	$(foreach builder,$(builders), PACKER_LOG="yes" PACKER_CONFIG=$(CURDIR)/.packerconfig PACKER_LOG_PATH=$(CURDIR)/logs/$(TPL).log packer build -only=$(builder) $(TPL).json;)


%:
	@:
