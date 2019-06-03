################################################################################
#
# amlogic broadcom AP6xxx driver
#
################################################################################

BRCMAP6XXX_VERSION = $(call qstrip,$(BR2_PACKAGE_BRCMAP6XXX_GIT_VERSION))
BRCMAP6XXX_SITE = $(call qstrip,$(BR2_PACKAGE_BRCMAP6XXX_GIT_REPO_URL))
BRCMAP6XXX_SDIO_BUILD_VERSION = $(call qstrip, $(BR2_PACKAGE_BRCMAP6XXX_SDIO_VERSION))
BRCMAP6XXX_PCI_BUILD_VERSION = $(call qstrip, $(BR2_PACKAGE_BRCMAP6XXX_PCI_VERSION))
BRCMAP6XXX_USB_BUILD_VERSION = $(call qstrip, $(BR2_PACKAGE_BRCMAP6XXX_USB_VERSION))

BRCMAP6XXX_MODULE_DIR = kernel/broadcom/wifi
BRCMAP6XXX_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(BRCMAP6XXX_MODULE_DIR)

ifeq ($(BR2_PACKAGE_BRCMAP6XXX_LOCAL),y)
BRCMAP6XXX_SITE = $(call qstrip,$(BR2_PACKAGE_BRCMAP6XXX_LOCAL_PATH))
BRCMAP6XXX_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_BRCMAP6XXX_STANDALONE),y)
BRCMAP6XXX_DEPENDENCIES = linux
endif
BRCMAP6XXX_KCONFIGS = KCPPFLAGS='-DCONFIG_BCMDHD_FW_PATH=\"/etc/wifi/fw_bcmdhd.bin\" -DCONFIG_BCMDHD_NVRAM_PATH=\"/etc/wifi/nvram.txt\"'


ifneq ($(BRCMAP6XXX_PCI_BUILD_VERSION),)
define BRCMAP6XXX_PCI_DRIVER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/$(BRCMAP6XXX_PCI_BUILD_VERSION) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) $(BRCMAP6XXX_KCONFIGS) modules CONFIG_BCMDHD_PCIE=y
	cp $(@D)/$(BRCMAP6XXX_PCI_BUILD_VERSION)/dhd.ko $(@D)/$(BRCMAP6XXX_PCI_BUILD_VERSION)/dhd_pci.ko -rf
endef

define BRCMAP6XXX_PCI_DRIVER_INSTALL_CMDS
	$(INSTALL) -m 0666 $(@D)/$(BRCMAP6XXX_PCI_BUILD_VERSION)/dhd_pci.ko $(BRCMAP6XXX_INSTALL_DIR)/dhd_pci.ko
        echo $(BRCMAP6XXX_MODULE_DIR)/dhd_pci.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
endif

ifeq ($(BR2_PACKAGE_BRCMAP6XXX_STANDALONE),y)
define BRCMAP6XXX_BUILD_CMDS
	$(BRCMAP6XXX_PCI_DRIVER_BUILD_CMDS)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/$(BRCMAP6XXX_SDIO_BUILD_VERSION) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) $(BRCMAP6XXX_KCONFIGS) CONFIG_BCMDHD_SDIO=y modules
	#$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/$(BRCMAP6XXX_USB_BUILD_VERSION) ARCH=$(KERNEL_ARCH) \
	#	CROSS_COMPILE=$(TARGET_KERNEL_CROSS) $(BRCMAP6XXX_KCONFIGS) modules
endef
define BRCMAP6XXX_INSTALL_TARGET_CMDS
	mkdir -p $(BRCMAP6XXX_INSTALL_DIR)
	$(BRCMAP6XXX_PCI_DRIVER_INSTALL_CMDS)
	$(INSTALL) -m 0666 $(@D)/$(BRCMAP6XXX_SDIO_BUILD_VERSION)/dhd.ko $(BRCMAP6XXX_INSTALL_DIR)/dhd.ko
	echo $(BRCMAP6XXX_MODULE_DIR)/dhd.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	# $(INSTALL) -m 0666 $(@D)/$(BRCMAP6XXX_USB_BUILD_VERSION)/bcmdhd.ko $(BRCMAP6XXX_INSTALL_DIR)
	# echo $(BRCMAP6XXX_MODULE_DIR)/bcmdhd.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else
define BRCMAP6XXX_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/broadcom/drivers;
	ln -sf $(BRCMAP6XXX_DIR) $(LINUX_DIR)/../hardware/wifi/broadcom/drivers/ap6xxx
endef
endif


$(eval $(generic-package))
