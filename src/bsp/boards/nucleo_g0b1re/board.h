#ifndef BOARD_H
#define BOARD_H

#include <stdint.h>
#include <stdbool.h>

void board_init(void);
void board_led_set(bool state);
const char * board_get_name(void);

#endif // BOARD_H
