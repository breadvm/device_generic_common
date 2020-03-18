LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= masssf.c
LOCAL_CFLAGS:=-O2 -g
LOCAL_MODULE:=mountsf
LOCAL_MODULE_TAGS := optional

include $(BUILD_EXECUTABLE)
