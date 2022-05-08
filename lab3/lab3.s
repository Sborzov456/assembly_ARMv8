.arch armv8-a
.data

args_err:
    .string "[!]Incorrect number of arguments\n"
    .equ    args_err_len, .-args_err

open_file_err:
    .string "[!]Error opening file\n"
    .equ    open_file_err_len, .-open_file_err
space:
    .ascii " "
end_line:
    .ascii "\n"
shift:
    .8byte   1
.text
    .align 2
    .global _start
    .type _start, %function
_start:
    ldr     x0, [sp]
    cmp     x0, #2
    b.eq    PROCESS //ARGS NUM == 2 [Y -> PROCESS, N -> WRITE ERROR & EXIT]

    adr     x1, args_err
    mov     x2, args_err_len
    b       WRITE_ERR
WRITE_ERR:
    mov     x0, #2
    mov     x8, #64
    svc     #0
    b       EXIT

/*
    X0 - FILE DESCRIPTOR
    X4 - ' '
    X5 - '\n'
*/
PROCESS:
    bl      OPEN_FILE
    cmp     x0, #0
    b.le    0f
    b       1f
0:
    adr     x1, open_file_err
    mov     x2, open_file_err_len
    b       WRITE_ERR
1:
    str     x0, [sp, -24]! // SAVE FILE DESCRIPTOR
2:
    adr     x4, space
    ldrb    w4, [x4]
    adr     x5, end_line
    ldrb    w5, [x5]
    mov     x1, #0

    bl      READ_WORD
    cmp     x0, #0 // IF END OF FILE -> EXIT
    b.eq    EXIT

    bl      CYCLIC_SHIFT

    b       2b
EXIT:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size	_start, .-_start

    .type   OPEN_FILE, %function
OPEN_FILE:
    mov     x0, #-100
    ldr     x1, [sp, #16]
    mov     x2, #0
    mov     x8, #56
    svc     #0
    ret
    .size   OPEN_FILE, .-OPEN_FILE

    .type   READ_WORD, %function
READ_WORD:
0:
    sub     x1, sp, 1 // X1 - ADDRES OF BEGIN OF BUF
1:
    ldr     x0, [sp]
    mov     x2, #1
    mov     x8, #63
    svc     #0
    ldrb    w3, [x1]

    cmp     w3, w4 // SIM == ' ' ?
    b.eq    2f
    cmp     w3, w5 // SIM == '\n' ?
    b.eq    2f
    cmp     x0, #0 // END OF FILE?
    b.eq    2f

    sub     x1, x1, 1
    b       1b
2:
    ret
    .size   READ_WORD, .-READ_WORD

    .type   CYCLIC_SHIFT, %function
    .equ    begin_of_word, 24
    .equ    last_sim, 16
CYCLIC_SHIFT:
0:

    adr     x5, shift
    ldr     x5, [x5] // LOADING SHIFT

    sub     x3, sp, x1 // LEN OF WORD

    sub     x11, x3, #1
    udiv    x10, x5, x11
    mul     x10, x10, x11
    sub     x5, x5, x10

    add     x4, x1, #1 // SAVE END OF WORD
    str     x4, [sp, last_sim]
    sub     x1, sp, #1 // X1 - ADDRES OF FIRST SIM
    str     x1, [sp, begin_of_word]

    mov     x6, #0 // int i = 0

    mov     x1, x4
1:
    cmp     x6, x5 // if i < shift
    b.ge    2f

    mov     x2, #1
    mov     x0, #1
    mov     x8, #64
    svc     #0

    add     x6, x6, #1
    add     x1, x1, #1
    b       1b
2:
    ldr     x1,  [sp, begin_of_word]
    neg     x5, x5
    sub     x5, x5, #1
    add     x5, x5, x3
    mov     x6, #0
3:
    cmp     x6, x5
    b.ge    4f

    mov     x2, #1
    mov     x0, #1
    mov     x8, #64
    svc     #0

    add     x6, x6, #1
    sub     x1, x1, #1
    b       3b
4:
    ldr     x1, [sp, last_sim]
    sub     x1, x1, #1

    mov     x2, #1
    mov     x0, #1
    mov     x8, #64
    svc     #0
5:
    ret
    .size   CYCLIC_SHIFT, .-CYCLIC_SHIFT




