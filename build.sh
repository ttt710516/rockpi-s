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

# 輔助函數
print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 顯示使用說明
show_usage() {
    echo "Usage: $0 [target]"
    echo "Examples:"
    echo "  $0                    # Build core-image-minimal"
    echo "  $0 core-image-base    # Build core-image-base"
    echo "  $0 -h, --help        # Show this help"
}

# 檢查環境
check_env() {
    if [ ! -d "$BUILD_DIR" ]; then
        print_error "Build directory not found. Please run ./configure.sh first"
        exit 1
    fi
}

# 主程序
main() {
    # 處理命令列參數
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
    esac

    check_env

    # 設置編譯目標
    local target=${1:-pck-image-core}
    
    print_info "Initializing build environment..."
    cd "$YOCTO_DIR"
    source poky/oe-init-build-env "$BUILD_DIR"

    print_info "Starting build for target: $target"
    print_info "Build started at: $(date)"
    
    # 記錄開始時間
    local start_time=$(date +%s)
    
    # 執行編譯
    time bitbake "$target"
    local result=$?

    # 記錄結束時間並計算總時間
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    local hours=$((total_time / 3600))
    local minutes=$(( (total_time % 3600) / 60 ))
    local seconds=$((total_time % 60))

    if [ $result -eq 0 ]; then
        print_info "Build completed successfully"
    else
        print_error "Build failed with error code $result"
    fi

    print_info "Build ended at: $(date)"
    print_info "Total build time: ${hours}h ${minutes}m ${seconds}s"
}

main "$@"