add_library(board_nucleo_f446re STATIC
    board.c
)

target_include_directories(board_nucleo_f446re PUBLIC .)
target_link_libraries(board_nucleo_f446re
    PUBLIC  bsp::mcu::stm32f446
    PRIVATE project_warnings
)
target_compile_definitions(board_nucleo_f446re PUBLIC BOARD_NUCLEO_F446RE)
