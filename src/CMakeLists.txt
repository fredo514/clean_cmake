add_executable(app main.c)

target_link_libraries(app
    PRIVATE
        bsp::board
        bar
        project_warnings
)

if(ENABLE_LOGGING)
    target_compile_definitions(app PRIVATE ENABLE_LOGGING=1)
    target_compile_definitions(app PRIVATE LOG_BUFFER_SIZE=${LOG_BUFFER_SIZE})
endif()

if(ENABLE_TELEMETRY)
    target_compile_definitions(app PRIVATE ENABLE_TELEMETRY=1)
endif()

add_custom_command(TARGET app POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:app> $<TARGET_FILE_DIR:app>/app.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:app> $<TARGET_FILE_DIR:app>/app.hex
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:app>
    COMMENT "Generated binaries (.bin, .hex) and computed memory footprint"
)
