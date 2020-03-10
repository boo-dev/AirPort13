export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest

include $(THEOS)/makefiles/common.mk

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
SUBPROJECTS += Tweak Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"