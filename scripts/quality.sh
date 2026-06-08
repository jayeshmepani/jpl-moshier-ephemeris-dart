#!/usr/bin/env bash
set -e

# Format check
echo "Running dart format..."
dart format --output=none --set-exit-if-changed .

# Analyze
echo "Running dart analyze..."
dart analyze --fatal-infos

# Test (when we have them)
# echo "Running tests..."
# flutter test
