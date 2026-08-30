add_library(mcu_stm32g0b1 STATIC
    startup_stm32g0b1xx.c
)
add_library(bsp::mcu::stm32g0b1 ALIAS mcu_stm32g0b1)

target_link_libraries(mcu_stm32g0b1 PUBLIC bsp::mcu::common)

target_compile_options(mcu_stm32g0b1 PUBLIC
    -mcpu=cortex-m0plus
    -mthumb
)

target_link_options(mcu_stm32g0b1 PUBLIC
    -mcpu=cortex-m0plus
    -mthumb
    -T "${CMAKE_CURRENT_SOURCE_DIR}/stm32g0b1re.ld"
)

target_compile_definitions(mcu_stm32g0b1 PUBLIC STM32G0B1xx)
