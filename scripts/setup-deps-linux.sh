#!/usr/bin/env bash
# Install build dependencies for LegionCore 7.3.5 on Ubuntu/Debian.
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
    git cmake make gcc g++ clang \
    libssl-dev libmysqlclient-dev libboost-all-dev \
    libreadline-dev zlib1g-dev libbz2-dev

echo ""
echo "Dependencies installed."
