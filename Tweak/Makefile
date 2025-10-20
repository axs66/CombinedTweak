TWEAK_NAME = Eneko
Eneko_FILES = Eneko.m
Eneko_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
Eneko_FRAMEWORKS = UIKit AVFoundation Photos
Eneko_LIBRARIES = gcuniversal

# 添加这些行来帮助编译器找到头文件
Eneko_CFLAGS += -I$(THEOS)/include
Eneko_CFLAGS += -I./Headers

# 如果使用 rootless，可能需要指定库路径
ifneq ($(THEOS_PACKAGE_SCHEME), rootless)
Eneko_LDFLAGS += -L$(THEOS)/lib
else
Eneko_LDFLAGS += -L$(THEOS)/vendor/lib
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
