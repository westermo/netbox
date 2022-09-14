obj-m += hello.o

ccflags-y += -Werror

all:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules

modules: all

modules_install:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules_install

clean:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' clean

.PHONY: all modules modules_install clean
