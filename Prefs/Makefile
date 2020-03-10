include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AirPortPrefs
AirPortPrefs_FILES = Preferences.m CustomAnimController.m Sub.m
AirPortPrefs_INSTALL_PATH = /Library/PreferenceBundles
AirPortPrefs_FRAMEWORKS = UIKit
AirPortPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
AirPortPrefs_LIBRARIES += colorpicker
AirPortPrefs_PRIVATE_FRAMEWORKS = Preferences
AirPortPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p \
	$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences \
	$(THEOS_STAGING_DIR)/Library/AirPortAnims$(ECHO_END)

	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AirPortPrefs.plist$(ECHO_END)
	
	$(ECHO_NOTHING)cp -rn "Resources/AirPod" $(THEOS_STAGING_DIR)/Library/AirPortAnims/$(ECHO_END)
	$(ECHO_NOTHING)cp -rn "Resources/AirPodPro" $(THEOS_STAGING_DIR)/Library/AirPortAnims/$(ECHO_END)
	$(ECHO_NOTHING)cp -rn "Resources/AirPod2" $(THEOS_STAGING_DIR)/Library/AirPortAnims/$(ECHO_END)
	$(ECHO_NOTHING)cp -rn "Resources/Custom" $(THEOS_STAGING_DIR)/Library/AirPortAnims/$(ECHO_END)