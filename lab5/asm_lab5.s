    .align  2
    .global PROCESS_ASM
    .type  PROCESS_ASM, %function
PROCESS_ASM:
/*
x0 - unsigned char* data
x1 - int size
x2 - unsigned char* outputData
*/
    mov     x15, 3
    mov     x4, 0
    mul     x1, x1, x15
0:
    cmp     x4, x1
    b.ge    6f
    ldr     x5, [x0]
    add     x0, x0, 1
    ldr     x6, [x0]
    add     x0, x0, 1
    ldr     x7, [x0]
    add     x0, x0, 1

    cmp     x5, x6
    b.ge    1f
    b.lt    3f
1:
    cmp     x5, x7
    b.ge    2f
2:
    strb    w5, [x2]
    add     x2, x2, 1
    add     x4, x4, 3
    b       0b
3:
    cmp     x6, x7
    b.ge    4f
    b.lt    5f
4:
    strb    w6, [x2]
    add     x2, x2, 1
    add     x4, x4, 3
    b       0b
5:
    strb    w7, [x2]
    add     x2, x2, 1
    add     x4, x4, 3
    b       0b
6:
    ret
.size   PROCESS_ASM, .-PROCESS_ASM
