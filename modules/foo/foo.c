#include "foo.h"
#include "uart.h"

void foo_init(void) {
    uart_write_str("[foo] initialized\r\n");
}

void foo_process(void) {
    uart_write_str("[foo] processing...\r\n");
}
