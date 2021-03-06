################################################################################
#
# amlogic image packer
#
################################################################################
AML_IMG_PACKER_NEW_VERSION = 201602
AML_IMG_PACKER_NEW_SITE = $(HOST_AML_IMG_PACKER_NEW_PKGDIR)/src
AML_IMG_PACKER_NEW_SITE_METHOD = local

define HOST_AML_IMG_PACKER_NEW_BUILD_CMDS
	$(MAKE) -C $(@D) image_packer
endef

define HOST_AML_IMG_PACKER_NEW_INSTALL_CMDS
        $(INSTALL) -m 0755 $(@D)/res_packer $(HOST_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/aml_image_v2_packer_new $(HOST_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/img2simg $(HOST_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/aml_upgrade_pkg_gen.sh $(HOST_DIR)/usr/bin
endef

$(eval $(host-generic-package))
