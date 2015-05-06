################################################################################
#
# mali_utility
#
################################################################################

MALI_EXAMPLES_VERSION = 2.4.4
MALI_EXAMPLES_SITE = $(TOPDIR)/package/mali_examples/src
MALI_EXAMPLES_SITE_METHOD = local
MALI_EXAMPLES_CONF_OPTS = -DTARGET=arm \
			  -DCMAKE_INSTALL_PREFIX=/usr/share/arm \
			  -DTOOLCHAIN_ROOT=$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)-

define MALI_EXAMPLES_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MALI_EXAMPLES_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) install -C $(@D); \
	install -D -m 0755 $(@D)/simple_framework/libsimple_framework2.so $(TARGET_DIR)/usr/lib; \
	install -D -m 0755 $(@D)/simple_framework/libsimple_framework3.so $(TARGET_DIR)/usr/lib
endef

$(eval $(cmake-package))
