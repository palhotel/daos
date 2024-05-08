#include <stdarg.h>
#include <stdio.h>

// 简化的 itoa 函数，只处理10进制整数
void simple_itoa(int value, char *str) {
    char *ptr = str;
    int temp;

    // 负数处理
    if (value < 0) {
        *ptr++ = '-';
        value = -value;
    }

    // 获取数字长度
    temp = value;
    do {
        ptr++;
        temp /= 10;
    } while (temp);

    // 终止字符串
    *ptr = '\0';

    // 从最后一个字符到第一个字符填充数字
    do {
        *--ptr = '0' + (value % 10);
        value /= 10;
    } while (value);
}

int sprintf(char *buf, const char *format, ...) {
    va_list args;
    va_start(args, format);
    const char *p;
    char *s;
    int d;
    char c;
    int chars_written = 0;

    for (p = format; *p != '\0'; p++) {
        if (*p != '%') {
            *buf++ = *p;
            chars_written++;
            continue;
        }

        switch (*++p) {
            case 's':  // String
                s = va_arg(args, char*);
                while (*s) {
                    *buf++ = *s++;
                    chars_written++;
                }
                break;

            case 'd':  // Decimal
                d = va_arg(args, int);
                char numbuf[12];  // 为数字分配足够的空间
                simple_itoa(d, numbuf);
                for (char *numPtr = numbuf; *numPtr != '\0'; numPtr++) {
                    *buf++ = *numPtr;
                    chars_written++;
                }
                break;

            case 'c':  // Character
                c = (char)va_arg(args, int);  // char is promoted to int when passed through '...'
                *buf++ = c;
                chars_written++;
                break;

            default:
                *buf++ = *p;
                chars_written++;
                break;
        }
    }

    *buf = '\0'; // Null-terminate the string
    va_end(args);
    return chars_written;
}
