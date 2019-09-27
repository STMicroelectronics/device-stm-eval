
ifeq ($(strip $(USE_CUSTOM_AUDIO_POLICY)),1)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE:= libaudiopolicymanagerstm

LOCAL_SRC_FILES:= \
    AudioPolicyManager.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    liblog \
    libsoundtrigger

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_MODULE:= libaudiopolicymanager

LOCAL_SRC_FILES:= \
    AudioPolicyFactory.cpp

LOCAL_SHARED_LIBRARIES := \
    libaudiopolicymanagerstm

include $(BUILD_SHARED_LIBRARY)

endif
