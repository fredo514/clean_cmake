# ---------------------------------------------------------------------------
# Provides: firmware_post_build(<elf_target>)
#
# Adds post-build steps that:
#   • Print section sizes  (arm-none-eabi-size)
#   • Generate .hex file   (objcopy -O ihex)
#   • Generate .bin file   (objcopy -O binary)
#   • Generate .map file   (passed via linker flag)
# ---------------------------------------------------------------------------

function(firmware_post_build target)
    # .map file (linker flag – target-scoped, not global)
    target_link_options(${target} PRIVATE
        -Wl,-Map=$<TARGET_FILE_DIR:${target}>/${target}.map,--cref
        -Wl,--print-memory-usage
    )

    # Print sizes after every build
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_SIZE} --format=berkeley $<TARGET_FILE:${target}>
        COMMENT "=== Section sizes for ${target} ==="
    )

    # .hex
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ihex
                $<TARGET_FILE:${target}>
                $<TARGET_FILE_DIR:${target}>/${target}.hex
        COMMENT "Generating ${target}.hex"
    )

    # .bin
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary -S
                $<TARGET_FILE:${target}>
                $<TARGET_FILE_DIR:${target}>/${target}.bin
        COMMENT "Generating ${target}.bin"
    )
endfunction()