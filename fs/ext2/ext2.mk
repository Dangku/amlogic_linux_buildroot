################################################################################
#
# Build the ext2 root filesystem image
#
################################################################################

EXT2_OPTS = -G $(BR2_TARGET_ROOTFS_EXT2_GEN) -R $(BR2_TARGET_ROOTFS_EXT2_REV)

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -i $(BR2_TARGET_ROOTFS_EXT2_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),0)
EXT2_OPTS += -r $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)
endif

ROOTFS_EXT2_DEPENDENCIES = host-genext2fs host-e2fsprogs host-aml_image_packer
# qstrip it when checking. Furthermore, we need to further quote it, so
# that the quotes do not get eaten by the echo statement when creating the
# fakeroot script
ifneq ($(call qstrip,$(BR2_TARGET_ROOTFS_EXT2_LABEL)),)
EXT2_OPTS += -l '$(BR2_TARGET_ROOTFS_EXT2_LABEL)'
endif

ROOTFS_EXT2_DEPENDENCIES = host-mke2img

define ROOTFS_EXT2_CMD
	PATH=$(BR_PATH) mke2img -d $(TARGET_DIR) $(EXT2_OPTS) -o $@
endef

rootfs-ext2-symlink:
	ln -sf rootfs.ext2$(ROOTFS_EXT2_COMPRESS_EXT) $(BINARIES_DIR)/rootfs.ext$(BR2_TARGET_ROOTFS_EXT2_GEN)$(ROOTFS_EXT2_COMPRESS_EXT)

.PHONY: rootfs-ext2-symlink

ifneq ($(BR2_TARGET_ROOTFS_EXT2_GEN),2)
ROOTFS_EXT2_POST_TARGETS += rootfs-ext2-symlink
endif

ifeq ($(BR2_TARGET_USBTOOL_AMLOGIC), y)
DEVICE_DIR := $(patsubst "%",%,$(BR2_ROOTFS_OVERLAY))
ifneq (,$(wildcard $(DEVICE_DIR)../platform.conf))
rootfs-usb-image-pack:
	cp -f $(DEVICE_DIR)../platform.conf $(BINARIES_DIR)
	$(HOST_DIR)/usr/bin/aml_image_v2_packer -r $(BINARIES_DIR)/usb_burn_package.conf $(BINARIES_DIR)/ $(BINARIES_DIR)/aml_upgrade_package.img
else
rootfs-usb-image-pack:

endif
ROOTFS_EXT2_POST_TARGETS += rootfs-usb-image-pack
endif

$(eval $(call ROOTFS_TARGET,ext2))
