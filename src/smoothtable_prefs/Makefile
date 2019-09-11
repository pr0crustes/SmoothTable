include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

BUNDLE_NAME = smoothtable_prefs
smoothtable_prefs_FILES = pr0crustes_smta_RootListController.m
smoothtable_prefs_INSTALL_PATH = /Library/PreferenceBundles
smoothtable_prefs_FRAMEWORKS = UIKit
smoothtable_prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/smoothtable_prefs.plist$(ECHO_END)
