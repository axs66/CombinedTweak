#!/bin/bash

# CombinedTweak Build Script
# This script handles the libGCUniversal dependency issue

echo "Building CombinedTweak..."

# Check if we're in the right directory
if [ ! -f "Makefile" ]; then
    echo "Error: Please run this script from the CombinedTweak directory"
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
make clean

# Try to build
echo "Building CombinedTweak..."
make package

if [ $? -eq 0 ]; then
    echo "Build successful!"
    ls -la *.deb
else
    echo "Build failed. This might be due to missing libGCUniversal dependency."
    echo "Please ensure libGCUniversal is installed on your system."
    echo "You can install it from: https://github.com/MrGcGamer/LibGcUniversal"
    exit 1
fi
