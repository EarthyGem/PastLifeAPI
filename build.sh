#!/bin/bash

# Ensure Swift is installed
if ! command -v swift &> /dev/null
then
    echo "Swift could not be found, installing..."
    curl -s https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz | tar xz
    export PATH=swift-5.4.2-RELEASE-ubuntu20.04/usr/bin:"${PATH}"
fi

# Build the project
swift build -c release

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
