add_executable(app main.c)

add_subdirectory(bsp)
add_subdirectory(drivers)
add_subdirectory(modules)

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

firmware_post_build(app)
