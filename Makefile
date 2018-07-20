# For deploy
# TARGET = iphone:clang
# end deploy

# For simulator
TARGET = simulator:clang::7.0
ARCHS = x86_64
# end simulator

THEOS_DEVICE_IP = 192.168.1.7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmoothTables
SmoothTables_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

# Subprojects
# SUBPROJECTS += smoothtables_pref
# include $(THEOS_MAKE_PATH)/aggregate.mk
# end subprojects

test::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
