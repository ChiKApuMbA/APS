#include "platform.h"

// Функция для получения данных из UART RX
uint32_t uart_rx_receive() {
    while (rx_ptr->busy);  // Ждем, пока модуль UART RX освободится
    return rx_ptr->data;   // Возвращаем полученные данные
}

// Функция для отправки данных через UART TX
void uart_tx_send(uint32_t data) {
    while (tx_ptr->busy);  // Ждем, пока модуль UART TX освободится
    tx_ptr->data = data;   // Отправляем данные
}

int main() {
    while (1) {
        uint32_t sw_i = uart_rx_receive();  // Получаем данные от UART RX
        
        // Извлечение 4-битных сегментов и сложение их
        uint32_t sum = (sw_i & 0x000F) + ((sw_i >> 4) & 0x000F) + 
                       ((sw_i >> 8) & 0x000F) + ((sw_i >> 12) & 0x000F);
        
        uart_tx_send(sum);  // Отправляем результат через UART TX

        // Задержка для предотвращения повторного срабатывания в цикле
        for (volatile int i = 0; i < 1000000; i++);
    }
    return 0;
}


#define DEADLY_SERIOUS_EVENT 0xDEADDAD1
extern "C" void int_handler()
{
  // Если от коллайдера приходит прерывание, сразу же проверяем регистр статуса
  // и если его код равен DEADLY_SERIOUS_EVENT, экстренно останавливаем коллайдер
  if(DEADLY_SERIOUS_EVENT == collider_ptr->status)
  {
    collider_ptr->emergency_switch = 1;
  }
}