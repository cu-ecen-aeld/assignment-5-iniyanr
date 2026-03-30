LDD_VERSION = main
LDD_SITE = git@github.com:cu-ecen-aeld/assignment-7-iniyanr.git
LDD_SITE_METHOD = git

LDD_MODULE_SUBDIRS = scull misc-modules

define LDD_GENERATE_HEADERS
	# 1. access_ok_version.h
	@echo "#include <linux/version.h>" > $(@D)/access_ok_version.h
	@echo "#include <linux/uaccess.h>" >> $(@D)/access_ok_version.h
	@echo "#define access_ok_wrapper(type,arg,size) access_ok(arg,size)" >> $(@D)/access_ok_version.h
	@echo "#define VERIFY_WRITE 1" >> $(@D)/access_ok_version.h
	@echo "#define VERIFY_READ 0" >> $(@D)/access_ok_version.h
	
	# 2. proc_ops_version.h - Note the '&' in the macro definition
	@echo "#include <linux/version.h>" > $(@D)/proc_ops_version.h
	@echo "#include <linux/proc_fs.h>" >> $(@D)/proc_ops_version.h
	@echo "#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,6,0)" >> $(@D)/proc_ops_version.h
	@echo "  #define proc_ops_wrapper(old,new) (&new)" >> $(@D)/proc_ops_version.h
	@echo "#else" >> $(@D)/proc_ops_version.h
	@echo "  #define proc_ops_wrapper(old,new) (old)" >> $(@D)/proc_ops_version.h
	@echo "#endif" >> $(@D)/proc_ops_version.h
	
	# 3. Dummy struct declarations so 'new' exists
	@echo "static const struct proc_ops ct_file_pops = {};" >> $(@D)/proc_ops_version.h
	@echo "static const struct proc_ops jiq_read_wq_pops = {};" >> $(@D)/proc_ops_version.h
	@echo "static const struct proc_ops jiq_read_wq_delayed_pops = {};" >> $(@D)/proc_ops_version.h
	@echo "static const struct proc_ops jiq_read_run_timer_pops = {};" >> $(@D)/proc_ops_version.h
	@echo "static const struct proc_ops jiq_read_tasklet_pops = {};" >> $(@D)/proc_ops_version.h
endef

LDD_PRE_BUILD_HOOKS += LDD_GENERATE_HEADERS
LDD_MODULE_MAKE_OPTS = EXTRA_CFLAGS="-I$(@D) -Wno-error=incompatible-pointer-types"

define LDD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/scull/scull.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/scull.ko
	$(INSTALL) -m 0755 -D $(@D)/misc-modules/faulty.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/faulty.ko
	$(INSTALL) -m 0755 -D $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/hello.ko
endef

$(eval $(kernel-module))
$(eval $(generic-package))
