#!/usr/bin/env bash
# Build LegionCore 7.3.5 (Build 26972) on Linux or macOS.
#
# Usage:
#   ./scripts/build.sh [options]
#
# Options (via environment variables):
#   CORE_DIR      - path to the LegionCore source checkout (default: ./LegionCore-7.3.5)
#   CORE_REPO     - git repo to clone if CORE_DIR is missing
#   INSTALL_DIR   - install prefix (default: $HOME/legionserver)
#   BUILD_TYPE    - CMake build type (default: Release)
#   JOBS          - parallel build jobs (default: number of CPU cores)
#   TOOLS         - build map/vmap/mmap extractors (default: 1)
set -euo pipefail

CORE_REPO="${CORE_REPO:-https://github.com/The-Legion-Preservation-Project/LegionCore-7.3.5.git}"
CORE_DIR="${CORE_DIR:-$(pwd)/LegionCore-7.3.5}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/legionserver}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
TOOLS="${TOOLS:-1}"

OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    JOBS="${JOBS:-$(sysctl -n hw.ncpu)}"
else
    JOBS="${JOBS:-$(nproc)}"
fi

echo "==> OS:          $OS"
echo "==> Core dir:    $CORE_DIR"
echo "==> Install dir: $INSTALL_DIR"
echo "==> Build type:  $BUILD_TYPE"
echo "==> Jobs:        $JOBS"

# 1. Fetch the core sources if not present
if [[ ! -d "$CORE_DIR" ]]; then
    echo "==> Cloning LegionCore from $CORE_REPO"
    git clone --depth 1 "$CORE_REPO" "$CORE_DIR"
fi

# 2. Configure
CMAKE_ARGS=(
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
    -DTOOLS="$TOOLS"
    -DWITH_WARNINGS=0
)

if [[ "$OS" == "Darwin" ]]; then
    # Homebrew-installed OpenSSL and MySQL client are not in default search paths
    if command -v brew >/dev/null 2>&1; then
        OPENSSL_ROOT="$(brew --prefix openssl@3 2>/dev/null || true)"
        MYSQL_ROOT="$(brew --prefix mysql-client 2>/dev/null || true)"
        [[ -n "$OPENSSL_ROOT" ]] && CMAKE_ARGS+=(-DOPENSSL_ROOT_DIR="$OPENSSL_ROOT")
        [[ -n "$MYSQL_ROOT" ]] && CMAKE_ARGS+=(-DMYSQL_ADD_INCLUDE_PATH="$MYSQL_ROOT/include" -DMYSQL_LIBRARY="$MYSQL_ROOT/lib/libmysqlclient.dylib")
    fi
fi

BUILD_DIR="$CORE_DIR/build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
cmake .. "${CMAKE_ARGS[@]}"

# 3. Build and install
make -j"$JOBS"
make install

echo ""
echo "==> Build complete. Binaries installed to: $INSTALL_DIR/bin"
echo "==> Next steps:"
echo "    1. Copy and edit the configs in $INSTALL_DIR/etc (worldserver.conf, bnetserver.conf)"
echo "    2. Create the databases (see scripts/setup-db.sh)"
echo "    3. Extract client data with the tools (mapextractor, vmap4extractor, vmap4assembler, mmaps_generator)"
