BUNDLE_NAME = EnekoPreferences
EnekoPreferences_FILES = $(wildcard Controllers/*.m Cells/*.m)
EnekoPreferences_FRAMEWORKS = UIKit
EnekoPreferences_PRIVATE_FRAMEWORKS = Preferences
EnekoPreferences_LIBRARIES = gcuniversal
EnekoPreferences_INSTALL_PATH = /Library/PreferenceBundles
EnekoPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN

# 添加这些行
EnekoPreferences_CFLAGS += -I$(THEOS)/include
EnekoPreferences_CFLAGS += -I./Headers

ifneq ($(THEOS_PACKAGE_SCHEME), rootless)
EnekoPreferences_LDFLAGS += -L$(THEOS)/lib
else
EnekoPreferences_LDFLAGS += -L$(THEOS)/vendor/lib
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
