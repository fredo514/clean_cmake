add_library(driver_uart_f4 STATIC
    uart_f4.c
)

target_include_directories(driver_uart_f4 PUBLIC ../include)
target_link_libraries(driver_uart_f4
    PUBLIC  bsp::mcu::stm32f446
    PRIVATE project_warnings
)
