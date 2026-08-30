cmake_minimum_required(VERSION 3.25)

project(embedded_app
    VERSION     1.0.0
    DESCRIPTION "Example embedded application demonstrating CMake build system for STM32 microcontrollers"
    LANGUAGES   C ASM
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

include(cmake/warnings.cmake)

# Hardware selection (provided via Presets or CLI)
set(TARGET_BOARD "nucleo_f446re" CACHE STRING "Target board")
set(TARGET_MCU   "stm32f446"     CACHE STRING "Target MCU family")

# Project Feature Flags & Options
option(ENABLE_LOGGING "Enable runtime logging" ON)
set(LOG_BUFFER_SIZE 256 CACHE STRING "Log ring buffer size in bytes")
option(ENABLE_TELEMETRY "Enable telemetry transmission over UART" OFF)

add_subdirectory(src)
