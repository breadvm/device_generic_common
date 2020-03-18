#
# Copyright (C) 2011 The Android-x86 Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
PRODUCT_PACKAGES += \
    libGLESv1_CM_xxbos \
    lib_renderControl_enc \
    libEGL_xxbos \
    lib_GLESv2_enc \
    lib_OpenglSystemCommon \
    libGLESv2_xxbos \
    lib_GLESv1_enc \
    gralloc.xxbos \

PRODUCT_PROPERTY_OVERRIDES := \
    ro.opengles.version = 131072 \
    ro.sf.lcd_density = 160 
#    ro.opengles.version = 196608 ro.opengles.version=131072
