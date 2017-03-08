################################################################################
#
# toolchain-external-linaro-arm-preinstalled
#
################################################################################

TOOLCHAIN_EXTERNAL_LINARO_ARM_PREINSTALLED_SITE =
TOOLCHAIN_EXTERNAL_LINARO_ARM_PREINSTALLED_SOURCE =

define TOOLCHAIN_OLD_EXTERNAL_LINARO_SYMLINK
       ln -snf . $(TARGET_DIR)/lib/$(TOOLCHAIN_EXTERNAL_PREFIX)
       ln -snf . $(TARGET_DIR)/usr/lib/$(TOOLCHAIN_EXTERNAL_PREFIX)
endef

TOOLCHAIN_EXTERNAL_LINARO_ARM_PREINSTALLED_POST_INSTALL_STAGING_HOOKS += \
	 TOOLCHAIN_OLD_EXTERNAL_LINARO_SYMLINK

$(eval $(toolchain-external-package))
