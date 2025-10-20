ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CombinedTweakPreferences

CombinedTweakPreferences_FILES = Controllers/CombinedTweakRootListController.m Cells/CallaLinkCell.m Cells/CallaSingleContactCell.m KRTableCell.m KRLabeledSliderCell.m KRLinkCell.m KRTwitterCell.m GravSourceLinkCell.m GravDonationLinkCell.m PSGravityLinkCell.m
CombinedTweakPreferences_INSTALL_PATH = /Library/PreferenceBundles
CombinedTweakPreferences_FRAMEWORKS = UIKit
CombinedTweakPreferences_PRIVATE_FRAMEWORKS = Preferences
CombinedTweakPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CombinedTweakPreferences.plist$(ECHO_END)
