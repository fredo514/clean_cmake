add_library(driver_uart_g0 STATIC
    uart_g0.c
)

target_include_directories(driver_uart_g0 PUBLIC ../include)
target_link_libraries(driver_uart_g0
    PUBLIC  bsp::mcu::stm32g0b1
    PRIVATE project_warnings
)
