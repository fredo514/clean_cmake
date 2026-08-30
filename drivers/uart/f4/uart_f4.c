#include "uart.h"

void uart_init(uint32_t baudrate) {
    (void)baudrate;
    // STM32F446 USART2 initialization
}

void uart_write(const uint8_t *data, size_t length) {
    (void)data;
    (void)length;
    // STM32F446 USART2 transmit implementation
}

void uart_write_str(const char *str) {
    (void)str;
    // STM32F446 transmit string
}
