IMAGES=linux \
       k8s

QCOW=$(addsuffix .qcow2,$(IMAGES))
MD5=$(addsuffix .md5sum,$(QCOW))

IMAGEDIR=ironic/html/images
VPATH=$(IMAGEDIR) ironic/html

all: $(QCOW) $(MD5)

images:
	mkdir -p ironic/html/images

$(MD5): $(subst .md5sum,,$(@))
	md5sum $(IMAGEDIR)/$(subst .md5sum,,$(@)) | cut -f 1 -d " " > $(IMAGEDIR)/$@

linux.qcow2: | $(IMAGEDIR)
	DIB_DEV_USER_USERNAME=hoge \
	DIB_DEV_USER_PWDLESS_SUDO=true \
	DIB_DEV_USER_AUTHORIZED_KEYS=~/.ssh/id_rsa.pub \
	disk-image-create \
		bootloader \
		centos7 \
		cloud-init-nocloud \
		devuser \
		dhcp-all-interfaces \
		epel \
		vm \
		yum \
		-o $(IMAGEDIR)/linux.qcow2 \
		-p vim

k8s.qcow2: | $(IMAGEDIR)
	DEV_USER_USERNAME=hoge \
	DEV_USER_PWDLESS_SUDO=true \
	DEV_USER_AUTHORIZED_KEYS=~/.ssh/id_rsa.pub \
	ELEMENTS_PATH=$(CURDIR)/elements \
	disk-image-create \
		bootloader \
		centos7 \
		cloud-init-nocloud \
		devuser \
		dhcp-all-interfaces \
		epel \
		kubernetes \
		vm \
		yum \
		-o $(IMAGEDIR)/k8s.qcow2 \
		-p vim

