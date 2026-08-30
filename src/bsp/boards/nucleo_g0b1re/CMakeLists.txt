add_library(board_nucleo_g0b1re STATIC
    board.c
)

target_include_directories(board_nucleo_g0b1re PUBLIC .)
target_link_libraries(board_nucleo_g0b1re
    PUBLIC  bsp::mcu::stm32g0b1
    PRIVATE project_warnings
)
target_compile_definitions(board_nucleo_g0b1re PUBLIC BOARD_NUCLEO_G0B1RE)
