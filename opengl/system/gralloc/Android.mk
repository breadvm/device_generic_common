LOCAL_PATH := $(call my-dir)

$(call emugl-begin-shared-library,gralloc.xxbos)
$(call emugl-import,libGLESv1_enc lib_renderControl_enc libOpenglSystemCommon)
$(call emugl-set-shared-library-subpath,hw)

LOCAL_CFLAGS += -DLOG_TAG=\"gralloc_xxbos\"
LOCAL_CFLAGS += -Wno-missing-field-initializers

LOCAL_SRC_FILES := gralloc.cpp

# Need to access the special OPENGL TLS Slot
LOCAL_C_INCLUDES += bionic/libc/private
LOCAL_SHARED_LIBRARIES += libdl

$(call emugl-end-module)
