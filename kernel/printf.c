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
    while(*s)
    {
        putchar(*s++);
    }
}


void printf(const char *fmt,...)
{
    va_list args;

    va_start(args,fmt);

    while(*fmt)
    {
        if(*fmt == '%')
        {
            fmt++;

            if(*fmt == 's')
            {
                char *s = va_arg(args,char *);
                print_string(s);
            }
            else if(*fmt == 'c')
            {
                char c = va_arg(args,int);
                putchar(c);
            }
        }
        else
        {
            putchar(*fmt);
        }

        fmt++;
    }

    va_end(args);
}