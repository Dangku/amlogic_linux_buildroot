################################################################################
#
# cpio to archive target filesystem
#
################################################################################

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)

define ROOTFS_CPIO_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		ln -sf sbin/init $(TARGET_DIR)/init; \
	fi
endef

else
# devtmpfs does not get automounted when initramfs is used.
# Add a pre-init script to mount it before running init
define ROOTFS_CPIO_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		$(INSTALL) -m 0755 fs/cpio/init $(TARGET_DIR)/init; \
	fi
endef

PACKAGES_PERMISSIONS_TABLE += /dev/console c 622 0 0 5 1 - - -$(sep)

endif # BR2_ROOTFS_DEVICE_CREATION_STATIC

ROOTFS_CPIO_PRE_GEN_HOOKS += ROOTFS_CPIO_ADD_INIT

RECOVERY_OTA_DIR := $(patsubst "%",%,$(BR2_RECOVERY_OTA_DIR))
ifneq ($(BR2_TARGET_ROOTFS_INITRAMFS_LIST),"")
ifeq ($(BR2_PACKAGE_SWUPDATE),y)
define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && cat $(TOPDIR)/$(BR2_TARGET_ROOTFS_INITRAMFS_LIST) | cpio --quiet -o -H newc > $@
	cd -
	rm $(TARGET_DIR)_r -fr
	cp $(TARGET_DIR) $(TARGET_DIR)_r -fr
	cp -rf $(RECOVERY_OTA_DIR)/../ramdisk/* $(TARGET_DIR)_r
	cp $(TOPDIR)/$(BR2_TARGET_ROOTFS_INITRAMFS_LIST) $(HOST_DIR)/usr/bin/ramfslist-recovery
	cat $(RECOVERY_OTA_DIR)/../swu/ramfslist-recovery-need >> $(HOST_DIR)/usr/bin/ramfslist-recovery
	cd $(TARGET_DIR)_r && cat $(HOST_DIR)/usr/bin/ramfslist-recovery | cpio --quiet -o -H newc > $(BINARIES_DIR)/recovery.cpio
endef
else
define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && cat $(TOPDIR)/$(BR2_TARGET_ROOTFS_INITRAMFS_LIST) | cpio --quiet -o -H newc > $@
endef
endif
else
define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $@
endef
endif # BR2_TARGET_ROOTFS_INITRAMFS_LIST

ifeq ($(BR2_TARGET_ROOTFS_CPIO_GZIP),y)
	ROOTFS_CPIO = rootfs.cpio.gz
else
	ROOTFS_CPIO = rootfs.cpio
endif

ifneq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
WORD_NUMBER := $(words $(BR2_LINUX_KERNEL_INTREE_DTS_NAME))
KERNEL_BOOTARGS = $(call qstrip,$(BR2_TARGET_UBOOT_AMLOGIC_BOOTARGS))
ifeq ($(WORD_NUMBER),1)
mkbootimg: $(BINARIES_DIR)/$(LINUX_IMAGE_NAME) $(BINARIES_DIR)/$(ROOTFS_CPIO)
	@$(call MESSAGE,"Generating boot image")
	linux/mkbootimg --kernel $(LINUX_IMAGE_PATH) --base 0x0 --kernel_offset 0x1080000 --cmdline "$(KERNEL_BOOTARGS)" --ramdisk $(BINARIES_DIR)/$(ROOTFS_CPIO) --second $(BINARIES_DIR)/$(KERNEL_DTBS) --output $(BINARIES_DIR)/boot.img
	ln -sf $(BINARIES_DIR)/$(KERNEL_DTBS) $(BINARIES_DIR)/dtb.img
ifeq ($(BR2_PACKAGE_SWUPDATE),y)
	gzip -9 -c $(BINARIES_DIR)/recovery.cpio > $(BINARIES_DIR)/recovery.cpio.gz
	linux/mkbootimg --kernel $(LINUX_IMAGE_PATH) --base 0x0 --kernel_offset 0x1080000 --cmdline "$(KERNEL_BOOTARGS)" --ramdisk  $(BINARIES_DIR)/recovery.cpio.gz --second $(BINARIES_DIR)/dtb.img --output $(BINARIES_DIR)/recovery.img
endif
else
mkbootimg: $(BINARIES_DIR)/$(LINUX_IMAGE_NAME) $(BINARIES_DIR)/$(ROOTFS_CPIO)
	@$(call MESSAGE,"Generating boot image")
	linux/dtbTool -o $(BINARIES_DIR)/dtb.img -p $(LINUX_DIR)/scripts/dtc/ $(BINARIES_DIR)/
	linux/mkbootimg --kernel $(LINUX_IMAGE_PATH) --base 0x0 --kernel_offset 0x1080000 --cmdline "$(KERNEL_BOOTARGS)" --ramdisk  $(BINARIES_DIR)/$(ROOTFS_CPIO) --second $(BINARIES_DIR)/dtb.img --output $(BINARIES_DIR)/boot.img
ifeq ($(BR2_PACKAGE_SWUPDATE),y)
	gzip -9 -c $(BINARIES_DIR)/recovery.cpio > $(BINARIES_DIR)/recovery.cpio.gz
	linux/mkbootimg --kernel $(LINUX_IMAGE_PATH) --base 0x0 --kernel_offset 0x1080000 --cmdline "$(KERNEL_BOOTARGS)" --ramdisk  $(BINARIES_DIR)/recovery.cpio.gz --second $(BINARIES_DIR)/dtb.img --output $(BINARIES_DIR)/recovery.img
endif
endif
else
mkbootimg:
endif

ifeq ($(BR2_LINUX_KERNEL_ANDROID_FORMAT),y)
ROOTFS_CPIO_POST_TARGETS += mkbootimg
endif

$(BINARIES_DIR)/rootfs.cpio.uboot: $(BINARIES_DIR)/rootfs.cpio host-uboot-tools
	$(MKIMAGE) -A $(MKIMAGE_ARCH) -T ramdisk \
		-C none -d $<$(ROOTFS_CPIO_COMPRESS_EXT) $@

ifeq ($(BR2_TARGET_ROOTFS_CPIO_UIMAGE),y)
ROOTFS_CPIO_POST_TARGETS += $(BINARIES_DIR)/rootfs.cpio.uboot
endif

$(TARGET_DIR)/uInitrd: $(BINARIES_DIR)/rootfs.cpio.uboot
	install -m 0644 -D $(BINARIES_DIR)/rootfs.cpio.uboot $(TARGET_DIR)/boot/uInitrd

ifeq ($(BR2_TARGET_ROOTFS_CPIO_UIMAGE_INSTALL),y)
ROOTFS_CPIO_POST_TARGETS += $(TARGET_DIR)/uInitrd
endif

$(TARGET_DIR)/boot.img: mkbootimg
	install -m 0644 -D $(BINARIES_DIR)/boot.img $(TARGET_DIR)/boot.img

ifeq ($(BR2_LINUX_KERNEL_INSTALL_TARGET)$(BR2_LINUX_KERNEL_ANDROID_FORMAT),yy)
ROOTFS_CPIO_POST_TARGETS += $(TARGET_DIR)/boot.img
endif

$(eval $(call ROOTFS_TARGET,cpio))
