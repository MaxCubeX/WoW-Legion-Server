#!/usr/bin/env bash
# Install build dependencies for LegionCore 7.3.5 on macOS (via Homebrew).
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install it first: https://brew.sh"
    exit 1
fi

brew update
# boost@1.85 is pinned: Boost >= 1.90 removed the boost_system CMake component that LegionCore requires
brew install cmake boost@1.85 openssl@3 mysql-client readline zlib bzip2 git

echo ""
echo "Dependencies installed."
echo "OpenSSL prefix: $(brew --prefix openssl@3)"
echo "MySQL client prefix: $(brew --prefix mysql-client)"
echo "Boost prefix: $(brew --prefix boost@1.85)"
