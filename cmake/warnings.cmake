# Tier 1: Project Warning Level (Strict)
add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE
    -Wall
    -Wextra
    -Wpedantic
    -Wshadow
    -Wconversion
    -Werror=implicit-function-declaration
    -Werror=return-type
)

# Tier 2: Third-Party Warning Level (Relaxed)
add_library(third_party_warnings INTERFACE)
target_compile_options(third_party_warnings INTERFACE -w)