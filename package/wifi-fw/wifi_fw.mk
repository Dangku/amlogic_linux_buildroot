################################################################################
#
# wifi-fw
#
################################################################################

WIFI_FW_VERSION = $(call qstrip,$(BR2_PACKAGE_WIFI_CUSTOM_GIT_VERSION))
WIFI_FW_SITE = $(call qstrip,$(BR2_PACKAGE_WIFI_FW_CUSTOM_GIT_REPO_URL))
WIFI_MODULE = $(call qstrip,$(BR2_PACKAGE_WIFI_FW_WIFI_MODULE))

# AP6242 AP6269 AP62x8 not set
BCM_MODULES := bcm40181 bcm40183 bcm43458 bcm4354 bcm4356 bcm4358 AP6212 \
	AP6234 AP6255 AP62x2 AP6335 AP6441 AP6181 AP6210 AP6330 AP6476 AP6493

ifeq ($(BR2_PACKAGE_WIFI_FW_LOCAL),y)
WIFI_FW_SITE_METHOD = local
WIFI_FW_SITE = $(call qstrip,$(BR2_PACKAGE_WIFI_FW_CUSTOM_LOCAL_PATH))
endif

ifeq ($(BR2_PACKAGE_WIFI_CUSTOM_GIT_VERSION),"jb-mr1-amlogic")

ifeq ($(WIFI_MODULE),AP6181)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6181/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6181/Wi-Fi/nvram_ap6181.txt $(TARGET_DIR)/etc/wifi/nvram.txt
endef
endif

ifeq ($(WIFI_MODULE),AP6210)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6210/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6210/Wi-Fi/nvram_ap6210.txt $(TARGET_DIR)/etc/wifi/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6210/BT/*.hcd $(TARGET_DIR)/etc/wifi/
endef
endif

ifeq ($(WIFI_MODULE),AP6476)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6476/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6476/Wi-Fi/nvram_ap6476.txt $(TARGET_DIR)/etc/wifi/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6476/GPS/*.hcd $(TARGET_DIR)/etc/wifi/
endef
endif

ifeq ($(WIFI_MODULE),AP6493)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6493/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6493/Wi-Fi/nvram_ap6493.txt $(TARGET_DIR)/etc/wifi/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6493/BT/*.hcd $(TARGET_DIR)/etc/wifi/
endef
endif

ifeq ($(WIFI_MODULE),AP6330)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6330/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6330/Wi-Fi/nvram_ap6330.txt $(TARGET_DIR)/etc/wifi/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/AP6xxx/AP6330/BT/*.hcd $(TARGET_DIR)/etc/wifi/
endef
endif

else #BR2_PACKAGE_WIFI_CUSTOM_GIT_VERSION


ifeq ($(BR2_LINUX_KERNEL_VERSION),"amlogic-3.10-dev")
ifneq ($(filter $(WIFI_MODULE),$(BCM_MODULES)),)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/40181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/*.bin $(TARGET_DIR)/etc/wifi/40181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/nvram.txt $(TARGET_DIR)/etc/wifi/40181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/40183
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/*.bin $(TARGET_DIR)/etc/wifi/40183/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/nvram.txt $(TARGET_DIR)/etc/wifi/40183/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/43458
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.bin $(TARGET_DIR)/etc/wifi/43458/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/nvram*.txt $(TARGET_DIR)/etc/wifi/43458/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.hcd $(TARGET_DIR)/etc/wifi/43458/

	mkdir -p $(TARGET_DIR)/etc/wifi/4354
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.bin $(TARGET_DIR)/etc/wifi/4354/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/nvram*.txt $(TARGET_DIR)/etc/wifi/4354/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.hcd $(TARGET_DIR)/etc/wifi/4354/

	mkdir -p $(TARGET_DIR)/etc/wifi/4356
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.bin $(TARGET_DIR)/etc/wifi/4356/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/nvram*.txt $(TARGET_DIR)/etc/wifi/4356/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.hcd $(TARGET_DIR)/etc/wifi/4356/

	mkdir -p $(TARGET_DIR)/etc/wifi/6212
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/*.bin $(TARGET_DIR)/etc/wifi/6212/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/nvram.txt $(TARGET_DIR)/etc/wifi/6212/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/BT/*.hcd $(TARGET_DIR)/etc/wifi/6212/

	mkdir -p $(TARGET_DIR)/etc/wifi/6234
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/*.bin $(TARGET_DIR)/etc/wifi/6234/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/nvram.txt $(TARGET_DIR)/etc/wifi/6234/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/BT/*.hcd $(TARGET_DIR)/etc/wifi/6234/

	mkdir -p $(TARGET_DIR)/etc/wifi/62x2
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/*.bin $(TARGET_DIR)/etc/wifi/62x2/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/nvram.txt $(TARGET_DIR)/etc/wifi/62x2/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/BT/*.hcd $(TARGET_DIR)/etc/wifi/62x2/

	mkdir -p $(TARGET_DIR)/etc/wifi/6335
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/*.bin $(TARGET_DIR)/etc/wifi/6335/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/nvram_ap6335e.txt $(TARGET_DIR)/etc/wifi/6335/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/BT/*.hcd $(TARGET_DIR)/etc/wifi/6335/

	mkdir -p $(TARGET_DIR)/etc/wifi/6441
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/*.bin $(TARGET_DIR)/etc/wifi/6441/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/nvram.txt $(TARGET_DIR)/etc/wifi/6441/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/BT/*.hcd $(TARGET_DIR)/etc/wifi/6441/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/nvram_ap6181.txt $(TARGET_DIR)/etc/wifi/AP6181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6210
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6210/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/nvram_ap6210.txt $(TARGET_DIR)/etc/wifi/AP6210/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6210/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6330
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6330/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/nvram_ap6330.txt $(TARGET_DIR)/etc/wifi/AP6330/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6330/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6476
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6476/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/nvram_ap6476.txt $(TARGET_DIR)/etc/wifi/AP6476/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/GPS/*.hcd $(TARGET_DIR)/etc/wifi/AP6476/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6493
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6493/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/nvram_ap6493.txt $(TARGET_DIR)/etc/wifi/AP6493/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6493/


endef
endif
endif



ifeq ($(BR2_LINUX_KERNEL_VERSION),"amlogic-3.14-dev")
ifneq ($(filter $(WIFI_MODULE),$(BCM_MODULES)),)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/40181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/*.bin $(TARGET_DIR)/etc/wifi/40181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/nvram.txt $(TARGET_DIR)/etc/wifi/40181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/40183
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/*.bin $(TARGET_DIR)/etc/wifi/40183/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/nvram.txt $(TARGET_DIR)/etc/wifi/40183/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/43458
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.bin $(TARGET_DIR)/etc/wifi/43458/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/nvram*.txt $(TARGET_DIR)/etc/wifi/43458/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.hcd $(TARGET_DIR)/etc/wifi/43458/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/config.txt $(TARGET_DIR)/etc/wifi/43458/

	mkdir -p $(TARGET_DIR)/etc/wifi/4354
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.bin $(TARGET_DIR)/etc/wifi/4354/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/nvram*.txt $(TARGET_DIR)/etc/wifi/4354/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.hcd $(TARGET_DIR)/etc/wifi/4354/

	mkdir -p $(TARGET_DIR)/etc/wifi/4356
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.bin $(TARGET_DIR)/etc/wifi/4356/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/nvram*.txt $(TARGET_DIR)/etc/wifi/4356/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/config.txt $(TARGET_DIR)/etc/wifi/4356/config.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.hcd $(TARGET_DIR)/etc/wifi/4356/

	mkdir -p $(TARGET_DIR)/etc/wifi/4358
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/*.bin $(TARGET_DIR)/etc/wifi/4358/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/nvram*.txt $(TARGET_DIR)/etc/wifi/4358/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/config.txt $(TARGET_DIR)/etc/wifi/4358/config.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/BT/*.hcd $(TARGET_DIR)/etc/wifi/4358/

	mkdir -p $(TARGET_DIR)/etc/wifi/6212
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/*.bin $(TARGET_DIR)/etc/wifi/6212/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/nvram.txt $(TARGET_DIR)/etc/wifi/6212/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/BT/*.hcd $(TARGET_DIR)/etc/wifi/6212/

	mkdir -p $(TARGET_DIR)/etc/wifi/6234
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/*.bin $(TARGET_DIR)/etc/wifi/6234/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/nvram.txt $(TARGET_DIR)/etc/wifi/6234/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/BT/*.hcd $(TARGET_DIR)/etc/wifi/6234/

	mkdir -p $(TARGET_DIR)/etc/wifi/6255
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/*.bin $(TARGET_DIR)/etc/wifi/6255/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/nvram.txt $(TARGET_DIR)/etc/wifi/6255/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/BT/*.hcd $(TARGET_DIR)/etc/wifi/6255/

	mkdir -p $(TARGET_DIR)/etc/wifi/62x2
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/*.bin $(TARGET_DIR)/etc/wifi/62x2/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/nvram.txt $(TARGET_DIR)/etc/wifi/62x2/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/BT/*.hcd $(TARGET_DIR)/etc/wifi/62x2/

	mkdir -p $(TARGET_DIR)/etc/wifi/6335
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/*.bin $(TARGET_DIR)/etc/wifi/6335/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/nvram.txt $(TARGET_DIR)/etc/wifi/6335/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/BT/*.hcd $(TARGET_DIR)/etc/wifi/6335/

	mkdir -p $(TARGET_DIR)/etc/wifi/6441
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/*.bin $(TARGET_DIR)/etc/wifi/6441/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/nvram.txt $(TARGET_DIR)/etc/wifi/6441/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/BT/*.hcd $(TARGET_DIR)/etc/wifi/6441/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/nvram_ap6181.txt $(TARGET_DIR)/etc/wifi/AP6181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6210
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6210/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/nvram_ap6210.txt $(TARGET_DIR)/etc/wifi/AP6210/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6210/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6330
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6330/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/nvram_ap6330.txt $(TARGET_DIR)/etc/wifi/AP6330/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6330/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6476
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6476/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/nvram_ap6476.txt $(TARGET_DIR)/etc/wifi/AP6476/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/GPS/*.hcd $(TARGET_DIR)/etc/wifi/AP6476/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6493
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6493/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/nvram_ap6493.txt $(TARGET_DIR)/etc/wifi/AP6493/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6493/

endef
endif
endif


ifeq ($(BR2_LINUX_KERNEL_VERSION),"amlogic-4.9-dev")
ifneq ($(filter $(WIFI_MODULE),$(BCM_MODULES)),)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/wifi/40181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/*.bin $(TARGET_DIR)/etc/wifi/40181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40181/nvram.txt $(TARGET_DIR)/etc/wifi/40181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/40183
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/*.bin $(TARGET_DIR)/etc/wifi/40183/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/40183/nvram.txt $(TARGET_DIR)/etc/wifi/40183/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/43458
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.bin $(TARGET_DIR)/etc/wifi/43458/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/nvram*.txt $(TARGET_DIR)/etc/wifi/43458/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/*.hcd $(TARGET_DIR)/etc/wifi/43458/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/43458/config.txt $(TARGET_DIR)/etc/wifi/43458/

	mkdir -p $(TARGET_DIR)/etc/wifi/4354
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.bin $(TARGET_DIR)/etc/wifi/4354/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/nvram*.txt $(TARGET_DIR)/etc/wifi/4354/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4354/*.hcd $(TARGET_DIR)/etc/wifi/4354/

	mkdir -p $(TARGET_DIR)/etc/wifi/4356
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.bin $(TARGET_DIR)/etc/wifi/4356/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/nvram*.txt $(TARGET_DIR)/etc/wifi/4356/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/config.txt $(TARGET_DIR)/etc/wifi/4356/config.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4356/*.hcd $(TARGET_DIR)/etc/wifi/4356/

	mkdir -p $(TARGET_DIR)/etc/wifi/4358
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/*.bin $(TARGET_DIR)/etc/wifi/4358/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/nvram*.txt $(TARGET_DIR)/etc/wifi/4358/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/config.txt $(TARGET_DIR)/etc/wifi/4358/config.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/4358/BT/*.hcd $(TARGET_DIR)/etc/wifi/4358/

	mkdir -p $(TARGET_DIR)/etc/wifi/6212
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/*.bin $(TARGET_DIR)/etc/wifi/6212/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/nvram.txt $(TARGET_DIR)/etc/wifi/6212/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6212/BT/*.hcd $(TARGET_DIR)/etc/wifi/6212/

	mkdir -p $(TARGET_DIR)/etc/wifi/6234
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/*.bin $(TARGET_DIR)/etc/wifi/6234/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/nvram.txt $(TARGET_DIR)/etc/wifi/6234/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6234/BT/*.hcd $(TARGET_DIR)/etc/wifi/6234/

	mkdir -p $(TARGET_DIR)/etc/wifi/6255
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/*.bin $(TARGET_DIR)/etc/wifi/6255/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/nvram.txt $(TARGET_DIR)/etc/wifi/6255/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6255/BT/*.hcd $(TARGET_DIR)/etc/wifi/6255/

	mkdir -p $(TARGET_DIR)/etc/wifi/62x2
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/*.bin $(TARGET_DIR)/etc/wifi/62x2/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/nvram.txt $(TARGET_DIR)/etc/wifi/62x2/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/62x2/BT/*.hcd $(TARGET_DIR)/etc/wifi/62x2/

	mkdir -p $(TARGET_DIR)/etc/wifi/6335
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/*.bin $(TARGET_DIR)/etc/wifi/6335/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/nvram.txt $(TARGET_DIR)/etc/wifi/6335/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6335/BT/*.hcd $(TARGET_DIR)/etc/wifi/6335/

	mkdir -p $(TARGET_DIR)/etc/wifi/6441
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/*.bin $(TARGET_DIR)/etc/wifi/6441/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/nvram.txt $(TARGET_DIR)/etc/wifi/6441/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/6441/BT/*.hcd $(TARGET_DIR)/etc/wifi/6441/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6181
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6181/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6181/Wi-Fi/nvram_ap6181.txt $(TARGET_DIR)/etc/wifi/AP6181/nvram.txt

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6210
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6210/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/Wi-Fi/nvram_ap6210.txt $(TARGET_DIR)/etc/wifi/AP6210/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6210/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6210/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6330
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6330/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/Wi-Fi/nvram_ap6330.txt $(TARGET_DIR)/etc/wifi/AP6330/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6330/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6330/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6476
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6476/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/Wi-Fi/nvram_ap6476.txt $(TARGET_DIR)/etc/wifi/AP6476/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6476/GPS/*.hcd $(TARGET_DIR)/etc/wifi/AP6476/

	mkdir -p $(TARGET_DIR)/etc/wifi/AP6493
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/*.bin $(TARGET_DIR)/etc/wifi/AP6493/
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/Wi-Fi/nvram_ap6493.txt $(TARGET_DIR)/etc/wifi/AP6493/nvram.txt
	$(INSTALL) -D -m 0644 $(@D)/bcm_ampak/config/AP6493/BT/*.hcd $(TARGET_DIR)/etc/wifi/AP6493/

endef
endif
endif



ifeq ($(WIFI_MODULE),ath10k)
define WIFI_FW_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/ath10k/
	mkdir -p $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/
	mkdir -p $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/hw3.0/
	mkdir -p $(TARGET_DIR)/lib/firmware/ath10k/QCA9888/
	mkdir -p $(TARGET_DIR)/lib/firmware/ath10k/QCA9888/hw2.0/
	$(INSTALL) -D -m 0644 $(@D)/qcom/config/ath10k/QCA6174/hw3.0/*.bin $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/hw3.0/
	$(INSTALL) -D -m 0644 $(@D)/qcom/config/ath10k/QCA9888/hw2.0/*.bin $(TARGET_DIR)/lib/firmware/ath10k/QCA9888/hw2.0/
endef
endif

endif #BR2_PACKAGE_WIFI_CUSTOM_GIT_VERSION

$(eval $(generic-package))
