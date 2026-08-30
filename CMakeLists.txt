cmake_minimum_required(VERSION 3.25)
project(embedded_app C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Hardware selection (provided via Presets or CLI)
set(TARGET_BOARD "nucleo_f446re" CACHE STRING "Target board")
set(TARGET_MCU   "stm32f446"     CACHE STRING "Target MCU family")

# Project Feature Flags & Options
option(ENABLE_LOGGING "Enable runtime logging" ON)
set(LOG_BUFFER_SIZE 256 CACHE STRING "Log ring buffer size in bytes")
option(ENABLE_TELEMETRY "Enable telemetry transmission over UART" OFF)

# Tier 1: Project Warning Level (Strict)
add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE
    -Wall
    -Wextra
    -Wpedantic
    -Wshadow
    -Wconversion
    -Werror=implicit-function-declaration
    -Werror=return-type
)

# Tier 2: Third-Party Warning Level (Relaxed)
add_library(third_party_warnings INTERFACE)
target_compile_options(third_party_warnings INTERFACE -w)

add_subdirectory(bsp)
add_subdirectory(drivers)
add_subdirectory(modules)
add_subdirectory(src)
