#include "bar.h"
#include "board.h"
#include "uart.h"
#include <stdio.h>

int main(void) {
  board_init();
  board_led_set(true);

  uart_init(115200);
  printf("Starting Application on %s\r\n", board_get_name());

  bar_init();

  for (uint32_t i = 0; i < 5; ++i) {
    bar_run_cycle(i);
  }

  while (1) {
    // Main loop
  }

  return 0;
}

int _write(int fd, const void *buffer, unsigned int count) {
  (void)fd; // Unused parameter
  uart_write_str((const char *)buffer);
  return (int)count;
}
