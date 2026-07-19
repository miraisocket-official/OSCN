#include <stdarg.h>

volatile unsigned short *vga =
    (volatile unsigned short *)0xB8000;

unsigned int cursor = 0;


void putchar(char c)
{
    vga[cursor++] = (unsigned short)c | 0x0F00;
}

void print_string(const char *s)
{
    while (*s)
    {
        putchar(*s++);
    }
}

void printf(const char *fmt)
{
    print_string(fmt);
}

