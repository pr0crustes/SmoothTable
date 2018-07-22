# For deploy
# TARGET = iphone:clang
TARGET = iphone:11.2:10.0
# end deploy

# For simulator
# TARGET = simulator:clang::7.0
# ARCHS = x86_64
# end simulator

# Needed to 'make package install'
THEOS_DEVICE_IP = 192.168.1.7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmoothTable
SmoothTable_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

# Subprojects (pref)
SUBPROJECTS += smoothtable_prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
# end subprojects

# Just to quick run in simulator
test::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
