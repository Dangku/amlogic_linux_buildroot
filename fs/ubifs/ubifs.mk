################################################################################
#
# Build the ubifs root filesystem image
#
################################################################################

UBIFS_OPTS := -e $(BR2_TARGET_ROOTFS_UBIFS_LEBSIZE) -c $(BR2_TARGET_ROOTFS_UBIFS_MAXLEBCNT) -m $(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE) -F

ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_ZLIB),y)
UBIFS_OPTS += -x zlib
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_LZO),y)
UBIFS_OPTS += -x lzo
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_NONE),y)
UBIFS_OPTS += -x none
endif

UBIFS_OPTS += $(call qstrip,$(BR2_TARGET_ROOTFS_UBIFS_OPTS))

ROOTFS_UBIFS_DEPENDENCIES = host-mtd

define ROOTFS_UBIFS_CMD
	$(HOST_DIR)/usr/sbin/mkfs.ubifs -d $(TARGET_DIR) $(UBIFS_OPTS) -o $@
endef

DEVICE_DIR := $(patsubst "%",%,$(BR2_ROOTFS_OVERLAY))
UPGRADE_DIR := $(patsubst "%",%,$(BR2_ROOTFS_UPGRADE_DIR))
UPGRADE_DIR_OVERLAY := $(patsubst "%",%,$(BR2_ROOTFS_UPGRADE_DIR_OVERLAY))
ifeq ($(BR2_TARGET_USBTOOL_AMLOGIC),y)
ifneq ($(UPGRADE_DIR_OVERLAY),)
rootfs-usb-image-pack-ubifs:
	cp -rf $(UPGRADE_DIR)/* $(BINARIES_DIR)
	cp -rf $(UPGRADE_DIR_OVERLAY)/* $(BINARIES_DIR)
	BINARIES_DIR=$(BINARIES_DIR) \
	TOOL_DIR=$(HOST_DIR)/usr/bin \
	$(HOST_DIR)/usr/bin/aml_upgrade_pkg_gen.sh \
	$(BR2_TARGET_UBOOT_PLATFORM) $(BR2_TARGET_UBOOT_ENCRYPTION)
else
rootfs-usb-image-pack-ubifs:
	cp -rf $(UPGRADE_DIR)/* $(BINARIES_DIR)
	BINARIES_DIR=$(BINARIES_DIR) \
	TOOL_DIR=$(HOST_DIR)/usr/bin \
	$(HOST_DIR)/usr/bin/aml_upgrade_pkg_gen.sh \
	$(BR2_TARGET_UBOOT_PLATFORM) $(BR2_TARGET_UBOOT_ENCRYPTION)
endif
ROOTFS_UBIFS_POST_TARGETS += rootfs-usb-image-pack-ubifs
endif #BR2_TARGET_USBTOOL_AMLOGIC

RECOVERY_OTA_DIR := $(patsubst "%",%,$(BR2_RECOVERY_OTA_DIR))
ifneq ($(RECOVERY_OTA_DIR),)
rootfs-ota-swu-pack-ubifs:
	$(INSTALL) -m 0755 $(RECOVERY_OTA_DIR)/../swu/* $(BINARIES_DIR)/
	$(INSTALL) -m 0755 $(RECOVERY_OTA_DIR)/sw-description-nand $(BINARIES_DIR)/sw-description
	$(INSTALL) -m 0755 $(RECOVERY_OTA_DIR)/ota_package_create.sh $(HOST_DIR)/usr/bin
	$(HOST_DIR)/usr/bin/ota_package_create.sh nand
ROOTFS_UBIFS_POST_TARGETS += rootfs-ota-swu-pack-ubifs
endif

ifeq ($(BR2_TARGET_UBOOT_AMLOGIC_2015),y)
SD_BOOT = $(BINARIES_DIR)/u-boot.bin.sd.bin
else
SD_BOOT = $(BINARIES_DIR)/u-boot.bin
endif
$(eval $(call ROOTFS_TARGET,ubifs))
