#!/bin/sh
set -e

ZEPHYR_WORKSPACE="$HOME/zephyrproject"
VENV_ACTIVATE="$ZEPHYR_WORKSPACE/.venv/bin/activate"

export ZEPHYR_BASE="$ZEPHYR_WORKSPACE/zephyr"
export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"
export ZEPHYR_SDK_INSTALL_DIR="$HOME/zephyr-sdk-1.0.1"

CMD="$1"
[ $# -gt 0 ] && shift
# Rest arguments ($@) will be passed to west

activate() {
    . "$VENV_ACTIVATE"
}

case "$CMD" in
    clean)
        rm -rf build
        ;;
    build-m7)
        activate
        west build -p always -b stm32h745i_disco/stm32h745xx/m7 --build-dir build/m7 app "$@"
        ;;
    build-m4)
        activate
        west build -p always -b stm32h745i_disco/stm32h745xx/m4 --build-dir build/m4 app "$@"
        ;;
    build-all)
        activate
        west build -p always -b stm32h745i_disco/stm32h745xx/m7 --build-dir build/m7 app
        west build -p always -b stm32h745i_disco/stm32h745xx/m4 --build-dir build/m4 app
        ;;
    flash-m7)
        activate
        west flash -d build/m7 --runner openocd "$@"
        ;;
    flash-m4)
        activate
        west flash -d build/m4 --runner openocd "$@"
        ;;
    flash-all)
        activate
        west flash -d build/m7 --runner openocd
        west flash -d build/m4 --runner openocd
        ;;
    term)
        BAUD="115200"
        PORT="/dev/tty.usbmodem2103"
        while [ $# -gt 0 ]; do
            case "$1" in
                -b|--baud|--baudrate)
                    BAUD="$2"
                    shift 2
                    ;;
                -p|--port)
                    PORT="$2"
                    shift 2
                    ;;
                *)
                    echo "Unknown argument for term: $1"
                    exit 1
                    ;;
            esac
        done
        picocom -b "$BAUD" "$PORT"
        ;;
    *)
        echo "Usage: sh cmd.sh {clean | build-m7 | build-m4 | build-all | flash-m7 | flash-m4 | flash-all | term} [extra args...]"
        echo "  term: sh cmd.sh term [-b|--baud|--baudrate <BAUD>] [-p|--port <PORT>]"
        echo "        defaults: baud=115200 port=/dev/tty.usbmodem2103"
        exit 1
        ;;
esac
