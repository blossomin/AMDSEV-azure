AZURE_LOCATION ?= eastus
export AZURE_RESOURCE_GROUP ?= coco-$(AZURE_LOCATION)-rg
export AZURE_SUBSCRIPTION_ID ?= null
export GALLERY_NAME ?= cocopreview

resourcegroup:
	az group create -g $(AZURE_RESOURCE_GROUP) -l $(AZURE_LOCATION)

gallery:
	az deployment group create -g $(AZURE_RESOURCE_GROUP) --template-file gallery-template.json --parameters @gallery-params.json --parameters galleries_name=$(GALLERY_NAME)

packer: ubuntu2004-snp-host.json cocopreview.json
	packer build -var-file cocopreview.json $<
