################################################################################
#
# gstreamer1
#
################################################################################

GSTREAMER1_VERSION = 1.10.4
GSTREAMER1_SOURCE = gstreamer-$(GSTREAMER1_VERSION).tar.xz
GSTREAMER1_SITE = https://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER1_INSTALL_STAGING = YES
GSTREAMER1_LICENSE_FILES = COPYING
GSTREAMER1_LICENSE = LGPLv2+, LGPLv2.1+

GSTREAMER1_CONF_OPTS = \
	--disable-examples \
	--disable-tests \
	--disable-failing-tests \
	--disable-valgrind \
	--disable-benchmarks \
	--disable-check \
	$(if $(BR2_PACKAGE_GSTREAMER1_TRACE),,--disable-trace) \
	$(if $(BR2_PACKAGE_GSTREAMER1_PARSE),,--disable-parse) \
	$(if $(BR2_PACKAGE_GSTREAMER1_GST_DEBUG),,--disable-gst-debug) \
	$(if $(BR2_PACKAGE_GSTREAMER1_PLUGIN_REGISTRY),,--disable-registry) \
	$(if $(BR2_PACKAGE_GSTREAMER1_INSTALL_TOOLS),,--disable-tools)

GSTREAMER1_DEPENDENCIES = \
	host-bison \
	host-flex \
	host-pkgconf \
	libglib2 \
	$(if $(BR2_PACKAGE_LIBUNWIND),libunwind)

ifeq ($(BR2_aarch64),y)
GSTTREAMER1_SOUNDCARD_CONFIG_ARCH = gst-soundcard-64.conf
else
GSTTREAMER1_SOUNDCARD_CONFIG_ARCH = gst-soundcard-32.conf
endif

define GSTREAMER1_INSTALL_TARGET_CMDS
 ${INSTALL} -D -m 0755  $(TOPDIR)/package/gstreamer1/gstreamer1/$(GSTTREAMER1_SOUNDCARD_CONFIG_ARCH)  ${TARGET_DIR}/etc/gst-soundcard.conf
endef
$(eval $(autotools-package))
