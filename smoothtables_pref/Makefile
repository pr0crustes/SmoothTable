ARCHS = arm64

SDKVERSION = 11.2
SYSROOT = /opt/Theos/sdks/iPhoneOS11.2.sdk

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SmoothTables_pref
SmoothTables_pref_FILES = pr0_smthRootListController.m
SmoothTables_pref_INSTALL_PATH = /Library/PreferenceBundles
SmoothTables_pref_FRAMEWORKS = UIKit
SmoothTables_pref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SmoothTables_pref.plist$(ECHO_END)
