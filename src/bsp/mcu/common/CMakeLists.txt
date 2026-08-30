add_library(mcu_common INTERFACE)
add_library(bsp::mcu::common ALIAS mcu_common)

target_compile_options(mcu_common INTERFACE
    -ffunction-sections
    -fdata-sections
)

target_link_options(mcu_common INTERFACE
    -Wl,--gc-sections
    --specs=nano.specs
    --specs=nosys.specs
)
