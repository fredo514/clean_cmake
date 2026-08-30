#ifndef DRIVER_UART_H
#define DRIVER_UART_H

#include <stdint.h>
#include <stddef.h>

void uart_init(uint32_t baudrate);
void uart_write(const uint8_t *data, size_t length);
void uart_write_str(const char *str);

#endif // DRIVER_UART_H
