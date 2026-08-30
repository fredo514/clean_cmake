add_library(foo STATIC
    foo.c
)

target_include_directories(foo PUBLIC .)
target_link_libraries(foo
    PUBLIC  driver::uart
    PRIVATE project_warnings
)
