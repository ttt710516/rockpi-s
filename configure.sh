#!/bin/bash

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 定義路徑
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YOCTO_DIR="$SCRIPT_PATH/yocto"
BUILD_DIR="$SCRIPT_PATH/build"
TEMPLATE_DIR="$YOCTO_DIR/meta-pck/conf/templates"

# 輔助函數
print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 檢查環境
check_env() {
    if [ ! -d "$YOCTO_DIR/poky" ]; then
        print_error "Poky directory not found in $YOCTO_DIR"
        exit 1
    fi

    if [ ! -d "$TEMPLATE_DIR" ]; then
        print_error "Template directory not found in $TEMPLATE_DIR"
        exit 1
    fi
}

# 主程序
main() {
    # 檢查是否已存在build目錄
    if [ -d "$BUILD_DIR" ]; then
        read -p "Build directory already exists. Reconfigure? [y/N] " answer
        case ${answer:0:1} in
            y|Y )
                print_info "Removing existing build directory..."
                rm -rf "$BUILD_DIR"
                ;;
            * )
                print_info "Using existing build directory"
                return
                ;;
        esac
    fi

    check_env

    print_info "Initializing build environment..."
    cd "$YOCTO_DIR"
    source poky/oe-init-build-env "$BUILD_DIR"

    print_info "Copying configuration files..."
    cp "$TEMPLATE_DIR/bblayers.conf" conf/
    cp "$TEMPLATE_DIR/local.conf" conf/

    # 替換bblayers.conf中的路徑變數
    sed -i "s|##YOCTO_DIR##|$YOCTO_DIR|g" conf/bblayers.conf

    print_info "Configuration completed successfully"
    print_info "You can now run ./build.sh"
}

main