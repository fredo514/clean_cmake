# Justfile for Modern CMake Embedded Project

# List available recipes
default:
    @just --list

# Configure and build a specific preset (default: f446-debug)
build preset="f446-debug":
    cmake --preset {{preset}}
    cmake --build --preset {{preset}}

# Build all presets to verify compilation across targets
build-all:
    cmake --preset f446-debug && cmake --build --preset f446-debug
    cmake --preset f446-release && cmake --build --preset f446-release
    cmake --preset g0b1-debug && cmake --build --preset g0b1-debug
    cmake --preset g0b1-release && cmake --build --preset g0b1-release
    cmake --preset f446-telemetry && cmake --build --preset f446-telemetry

# Inspect memory size of a built preset
size preset="f446-debug":
    arm-none-eabi-size build/{{preset}}/src/app

# Clean all build artifacts
clean:
    rm -rf build/
