################################################################################
#
# qualcomm wifi/bt
#
################################################################################

QUALCOMM_WIFI_VERSION = 4.9
QUALCOMM_WIFI_SITE = $(call qstrip,$(BR2_PACKAGE_QUALCOMM_WIFI_LOCAL_PATH))
QUALCOMM_WIFI_SITE_METHOD = local

QUALCOMM_MODULE_DIR = kernel/qualcomm/wifi
QUALCOMM_MODULE_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(QUALCOMM_MODULE_DIR)

QUALCOMM_WIFI_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_QUALCOMM_QCA9377),y)
define QUALCOMM_QCA9377_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE)  -C $(@D)/qca9377/AIO/build ARCH=$(KERNEL_ARCH) \
		KERNELPATH=$(LINUX_DIR)	CROSS_COMPILE=$(TARGET_KERNEL_CROSS) CONFIG_BUILDROOT=y
endef

define QUALCOMM_QCA9377_INSTALL_CMDS
	mkdir -p $(QUALCOMM_MODULE_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/qca9377/AIO/rootfs-x86-android.build/lib/modules/wlan.ko $(QUALCOMM_MODULE_INSTALL_DIR)
    echo $(QUALCOMM_MODULE_DIR)/wlan.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
endif

define QUALCOMM_WIFI_BUILD_CMDS
	$(QUALCOMM_QCA9377_BUILD_CMDS)
endef

define QUALCOMM_WIFI_INSTALL_TARGET_CMDS
	$(QUALCOMM_QCA9377_INSTALL_CMDS)
endef


$(eval $(generic-package))
