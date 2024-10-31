# Summary and description of the image
SUMMARY = "A minimal custom image for PCK"
DESCRIPTION = "Minimal custom image with essential packages only"

# Inherit minimal image class instead of core-image
inherit image

# Basic configuration
IMAGE_INSTALL = "packagegroup-core-boot"
IMAGE_LINGUAS = " "

# Add basic features
IMAGE_FEATURES += " \
    debug-tweaks \
"

# Install minimal required packages
IMAGE_INSTALL += " \
    openssh \
    busybox \
"