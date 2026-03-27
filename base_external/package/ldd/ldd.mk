################################################################################
#
# ldd
#
################################################################################

LDD_VERSION = main
LDD_SITE = git@github.com:cu-ecen-aeld/assignment-7-iniyanr.git
LDD_SITE_METHOD = git

LDD_MODULE_SUBDIRS = misc-modules scull

$(eval $(kernel-module))
$(eval $(generic-package))
