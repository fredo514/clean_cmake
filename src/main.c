#include "board.h"
#include "bar.h"
#include "uart.h"

int main(void) {
    board_init();
    board_led_set(true);

    uart_init(115200);
    uart_write_str("Starting Application on ");
    uart_write_str(board_get_name());
    uart_write_str("\r\n");

    bar_init();

    for (uint32_t i = 0; i < 5; ++i) {
        bar_run_cycle(i);
    }

    while (1) {
        // Main loop
    }

    return 0;
}
