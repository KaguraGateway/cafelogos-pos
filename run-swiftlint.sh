#!/bin/bash

# Run SwiftLint for LogoREGICore
echo "Running SwiftLint for LogoREGICore..."
cd LogoREGICore && swiftlint

# Run SwiftLint for LogoREGIUI
echo "Running SwiftLint for LogoREGIUI..."
cd ../LogoREGIUI && swiftlint
