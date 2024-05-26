#!/bin/bash

# Ensure Swift is installed
if ! command -v swift &> /dev/null; then
    echo "Swift could not be found, installing..."
    SWIFT_VERSION=5.4.2-RELEASE
    SWIFT_PLATFORM=ubuntu20.04
    SWIFT_URL=https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz

    curl -fSL $SWIFT_URL -o swift.tar.gz
    if [ $? -ne 0 ]; then
        echo "Failed to download Swift tarball."
        exit 1
    fi

    mkdir swift
    tar -xzf swift.tar.gz -C swift --strip-components=1
    if [ $? -ne 0 ]; then
        echo "Failed to extract Swift tarball."
        exit 1
    fi

    export PATH=$(pwd)/swift/usr/bin:"${PATH}"
    if ! command -v swift &> /dev/null; then
        echo "Swift installation failed."
        exit 1
    fi
fi

# Build the project
swift build -c release
if [ $? -ne 0 ]; then
    echo "Swift build failed."
    exit 1
fi

# Check if the build was successful
if [ ! -f .build/release/Run ]; then
    echo "Build failed, executable not found!"
    exit 1
fi

# Move the executable to the public folder
mkdir -p Public
mv .build/release/Run Public/

# Copy static files to the public directory
cp -r Public /public
