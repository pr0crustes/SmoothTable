TARGET = iphone:11.2:10.0
FINAL_PACKAGE = 1
DEBUG = 0

THEOS_DEVICE_IP = 192.168.1.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmoothTable
SmoothTable_FILES = $(wildcard tweak/*.mm tweak/*.xm)
SmoothTable_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += smoothtable_prefs
include $(THEOS_MAKE_PATH)/aggregate.mk


test::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject


remove::
	@rm -r .theos
	@rm -r obj
	@rm -r packages
