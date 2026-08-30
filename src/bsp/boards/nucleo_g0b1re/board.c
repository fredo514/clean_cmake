#include "board.h"

void board_init(void) {
    // Board-specific clock and GPIO initialization for Nucleo-G0B1RE
}

void board_led_set(bool state) {
    (void)state;
    // Set LD2 (PA5) on Nucleo-G0B1RE
}

const char * board_get_name(void) {
    return "NUCLEO-G0B1RE";
}
