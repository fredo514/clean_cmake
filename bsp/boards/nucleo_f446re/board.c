#include "board.h"

void board_init(void) {
    // Board-specific clock and GPIO initialization for Nucleo-F446RE
}

void board_led_set(bool state) {
    (void)state;
    // Set LD2 (PA5) on Nucleo-F446RE
}

const char * board_get_name(void) {
    return "NUCLEO-F446RE";
}
