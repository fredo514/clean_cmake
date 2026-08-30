#include "bar.h"
#include "foo.h"
#include "uart.h"

void bar_init(void) {
    foo_init();
    uart_write_str("[bar] initialized\r\n");
}

void bar_run_cycle(uint32_t count) {
    (void)count;
    foo_process();
#if defined(ENABLE_TELEMETRY) && (ENABLE_TELEMETRY == 1)
    uart_write_str("[bar] telemetry active\r\n");
#endif
}
