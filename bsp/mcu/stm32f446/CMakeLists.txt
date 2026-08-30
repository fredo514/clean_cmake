add_library(mcu_stm32f446 STATIC
    startup_stm32f446xx.c
)
add_library(bsp::mcu::stm32f446 ALIAS mcu_stm32f446)

target_link_libraries(mcu_stm32f446 PUBLIC bsp::mcu::common)

target_compile_options(mcu_stm32f446 PUBLIC
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
)

target_link_options(mcu_stm32f446 PUBLIC
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    -T "${CMAKE_CURRENT_SOURCE_DIR}/stm32f446re.ld"
)

target_compile_definitions(mcu_stm32f446 PUBLIC STM32F446xx)
