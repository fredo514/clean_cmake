# Modern Embedded CMake Template

TODO: add
* cppcheck
* ceedling/gtest/cpputest

A minimal, idiomatic, target-centric Modern CMake template for ARM Cortex-M microcontrollers (**STM32F446** and **STM32G0B1**). 

This setup adheres strictly to the guidelines from *Professional CMake: A Practical Guide*, *Mastering CMake*, and *Effective Modern CMake* by Daniel Pfeifer (mbinna).

---

## Key Architectural Principles

- **Target-Centric Design**: No global state (`CMAKE_C_FLAGS`, `include_directories`, `add_definitions`). Everything is modeled as library targets (`STATIC` or `INTERFACE`) propagating their usage requirements (`PUBLIC`, `PRIVATE`, `INTERFACE`).
- **Composable Layers**: MCUs, Boards, Drivers, and Business Logic are separate targets linked through modern CMake dependency graphs.
- **Hardware-Agnostic Business Logic**: Application modules (`foo`, `bar`) link against abstract aliases (e.g. `driver::uart`, `bsp::board`) without knowing register layouts or board pinouts.
- **Two-Tier Warning System**: Strict compiler warnings on your code (`project_warnings`), isolated and relaxed warnings on external code (`third_party_warnings`).
- **Modern Presets & Tooling**: Uses `CMakePresets.json` and a clean `justfile` instead of bash scripts or legacy Makefiles.

---

## Architecture & Dependency Graph

```
                   ┌──────────────┐
                   │  app (ELF)   │
                   └──────┬───────┘
                          │
         ┌────────────────┼────────────────┐
         ▼                ▼                ▼
   ┌───────────┐    ┌───────────┐    ┌──────────────────┐
   │  bar.a    │    │  foo.a    │    │ project_warnings │
   └─────┬─────┘    └─────┬─────┘    └──────────────────┘
         │                │
         └───────┬────────┘
                 ▼
         ┌───────────────┐
         │ driver::uart  │ (Alias -> driver_uart_f4 or driver_uart_g0)
         └───────┬───────┘
                 ▼
         ┌───────────────┐
         │  bsp::board   │ (Alias -> board_nucleo_f446re or board_nucleo_g0b1re)
         └───────┬───────┘
                 ▼
         ┌───────────────┐
         │   bsp::mcu    │ (bsp::mcu::stm32f446 or bsp::mcu::stm32g0b1)
         └───────┬───────┘
                 ▼
         ┌───────────────┐
         │  mcu::common  │ (Optimization & linker garbage collection)
         └───────────────┘
```

---

## Directory Structure

```text
├── CMakeLists.txt                 # Project definition, warnings, options, subdirectories
├── CMakePresets.json              # Standardized build presets (Debug, Release, Features)
├── justfile                       # Task runner recipes
├── README.md
├── cmake/
│   └── toolchain-arm-none-eabi.cmake # Pure toolchain definitions (no flags)
├── bsp/
│   ├── CMakeLists.txt
│   ├── mcu/
│   │   ├── CMakeLists.txt
│   │   ├── common/                # Common MCU compile/link flags (GC sections, specs)
│   │   │   └── CMakeLists.txt
│   │   ├── stm32f446/             # Target: bsp::mcu::stm32f446
│   │   │   ├── CMakeLists.txt
│   │   │   ├── startup_stm32f446xx.c
│   │   │   └── stm32f446re.ld
│   │   └── stm32g0b1/             # Target: bsp::mcu::stm32g0b1
│   │       ├── CMakeLists.txt
│   │       ├── startup_stm32g0b1xx.c
│   │       └── stm32g0b1re.ld
│   └── boards/
│       ├── CMakeLists.txt         # Resolves bsp::board alias
│       ├── nucleo_f446re/         # Target: board_nucleo_f446re
│       │   ├── CMakeLists.txt
│       │   ├── board.h
│       │   └── board.c
│       └── nucleo_g0b1re/         # Target: board_nucleo_g0b1re
│           ├── CMakeLists.txt
│           ├── board.h
│           └── board.c
├── drivers/
│   ├── CMakeLists.txt
│   └── uart/
│       ├── CMakeLists.txt         # Resolves driver::uart alias based on MCU
│       ├── include/
│       │   └── uart.h             # Common UART interface header
│       ├── f4/                    # Target: driver_uart_f4
│       │   ├── CMakeLists.txt
│       │   └── uart_f4.c
│       └── g0/                    # Target: driver_uart_g0
│           ├── CMakeLists.txt
│           └── uart_g0.c
├── modules/
│   ├── CMakeLists.txt
│   ├── foo/                       # Target: foo
│   │   ├── CMakeLists.txt
│   │   ├── foo.h
│   │   └── foo.c
│   └── bar/                       # Target: bar
│       ├── CMakeLists.txt
│       ├── bar.h
│       └── bar.c
└── src/
    ├── CMakeLists.txt             # Target: app (ELF, .bin, .hex generation)
    └── main.c
```

---

## Prerequisites

- **CMake** >= 3.25
- **Ninja**
- **ARM GNU Toolchain** (`arm-none-eabi-gcc`, `arm-none-eabi-objcopy`, `arm-none-eabi-size`)
- **just** command runner

---

## Quick Start & Usage

### Using `just`

```bash
# List available recipes
just

# Build STM32F446 Nucleo in Debug mode
just build f446-debug

# Build STM32G0B1 Nucleo in Release mode
just build g0b1-release

# Build all configured presets
just build-all

# Inspect memory footprint
just size f446-debug

# Clean build directory
just clean
```

### Using native CMake Presets

```bash
# Configure and build
cmake --preset f446-debug
cmake --build --preset f446-debug

# The resulting artifacts will be in build/f446-debug/src/
#   - app      (ELF binary)
#   - app.bin  (Raw binary for flashing)
#   - app.hex  (Intel HEX format)
```

---

## Developer Workflows

### 1. Adding a New Board (e.g. `iot_sensor_f446`)

1. Create a new directory under `bsp/boards/iot_sensor_f446/` containing `board.h` and `board.c`.
2. Create `bsp/boards/iot_sensor_f446/CMakeLists.txt`:
   ```cmake
   add_library(board_iot_sensor_f446 STATIC board.c)
   target_include_directories(board_iot_sensor_f446 PUBLIC .)
   target_link_libraries(board_iot_sensor_f446 
       PUBLIC  bsp::mcu::stm32f446
       PRIVATE project_warnings
   )
   target_compile_definitions(board_iot_sensor_f446 PUBLIC BOARD_IOT_SENSOR_F446)
   ```
3. Register the subdirectory in `bsp/boards/CMakeLists.txt`:
   ```cmake
   add_subdirectory(iot_sensor_f446)
   ```
4. Add a preset in `CMakePresets.json`:
   ```json
   {
     "name": "sensor-f446-debug",
     "inherits": "base",
     "cacheVariables": {
       "CMAKE_BUILD_TYPE": "Debug",
       "TARGET_BOARD": "iot_sensor_f446",
       "TARGET_MCU": "stm32f446"
     }
   }
   ```

---

### 2. Adding a New MCU Family (e.g. `stm32h743`)

1. Create `bsp/mcu/stm32h743/` with linker script `stm32h743.ld`, startup code, and `CMakeLists.txt`:
   ```cmake
   add_library(mcu_stm32h743 STATIC startup_stm32h743xx.c)
   add_library(bsp::mcu::stm32h743 ALIAS mcu_stm32h743)

   target_link_libraries(mcu_stm32h743 PUBLIC bsp::mcu::common)
   target_compile_options(mcu_stm32h743 PUBLIC
       -mcpu=cortex-m7
       -mthumb
       -mfpu=fpv5-d16
       -mfloat-abi=hard
   )
   target_link_options(mcu_stm32h743 PUBLIC
       -mcpu=cortex-m7
       -mthumb
       -mfpu=fpv5-d16
       -mfloat-abi=hard
       -T "${CMAKE_CURRENT_SOURCE_DIR}/stm32h743.ld"
   )
   target_compile_definitions(mcu_stm32h743 PUBLIC STM32H743xx)
   ```
2. Include it in `bsp/mcu/CMakeLists.txt`:
   ```cmake
   add_subdirectory(stm32h743)
   ```

---

### 3. Adding a New Driver Variant (e.g. `mock` or `spi_dma`)

1. Create implementation in `drivers/uart/mock/` with `CMakeLists.txt`:
   ```cmake
   add_library(driver_uart_mock STATIC uart_mock.c)
   target_include_directories(driver_uart_mock PUBLIC ../include)
   target_link_libraries(driver_uart_mock PRIVATE project_warnings)
   ```
2. Update the alias selection in `drivers/uart/CMakeLists.txt`:
   ```cmake
   add_subdirectory(mock)

   if(USE_MOCK_DRIVERS)
       add_library(driver::uart ALIAS driver_uart_mock)
   elseif(TARGET_MCU STREQUAL "stm32f446")
       add_library(driver::uart ALIAS driver_uart_f4)
   elseif(TARGET_MCU STREQUAL "stm32g0b1")
       add_library(driver::uart ALIAS driver_uart_g0)
   endif()
   ```

---

### 4. Adding Feature Flags & Macro Injections

In root `CMakeLists.txt`:
```cmake
option(ENABLE_TELEMETRY "Enable telemetry streaming" OFF)
set(TELEMETRY_INTERVAL_MS 100 CACHE STRING "Interval in milliseconds")
```

In `src/CMakeLists.txt` or module `CMakeLists.txt`:
```cmake
if(ENABLE_TELEMETRY)
    target_compile_definitions(app PRIVATE
        ENABLE_TELEMETRY=1
        TELEMETRY_INTERVAL_MS=${TELEMETRY_INTERVAL_MS}
    )
endif()
```

---

### 5. Managing Third-Party Libraries (FreeRTOS, CMSIS, etc.)

When integrating external 3rd-party code:
1. Mark include directories as `SYSTEM` so GCC/Clang suppress external compiler warnings:
   ```cmake
   target_include_directories(third_party_lib SYSTEM PUBLIC include/)
   ```
2. Or link with `third_party_warnings`:
   ```cmake
   target_link_libraries(third_party_lib PRIVATE third_party_warnings)
   ```
This ensures your project code stays on `-Wall -Wextra -Wpedantic -Werror` without breaking on third-party header quirks.
