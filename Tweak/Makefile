include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AirPort
AirPort_FILES = Tweak.xm APConfig.m
AirPort_CFLAGS = -fobjc-arc
AirPort_FRAMEWORKS = UIKit Foundation AVFoundation AudioToolbox
AirPort_PRIVATE_FRAMEWORKS = Sharing BatteryCenter SharingUI
AirPort_EXTRA_FRAMEWORKS += Cephei
AirPort_LIBRARIES += colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
