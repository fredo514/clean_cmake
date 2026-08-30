add_library(bar STATIC
    bar.c
)

target_include_directories(bar PUBLIC .)
target_link_libraries(bar
    PUBLIC  foo
    PRIVATE project_warnings
)
