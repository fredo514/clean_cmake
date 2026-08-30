add_subdirectory(nucleo_f446re)
add_subdirectory(nucleo_g0b1re)

if(TARGET board_${TARGET_BOARD})
    add_library(bsp::board ALIAS board_${TARGET_BOARD})
else()
    message(FATAL_ERROR "Unknown TARGET_BOARD: '${TARGET_BOARD}'. Supported: nucleo_f446re, nucleo_g0b1re")
endif()
