ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CombinedTweak

CombinedTweak_FILES = Tweak/EnekoTweak.m Tweak/GravitationTweak.m
CombinedTweak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
CombinedTweak_FRAMEWORKS = UIKit Foundation AVFoundation CoreMotion QuartzCore
CombinedTweak_PRIVATE_FRAMEWORKS = Preferences
CombinedTweak_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/tweak.mk

# Preferences Bundle
SUBPROJECTS += preferences

include $(THEOS_MAKE_PATH)/aggregate.mk
