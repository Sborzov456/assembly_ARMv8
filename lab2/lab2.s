//;			 MATRIIX
/*;		    ---------
;			 8 7 3 1
;			 5 4 1 1
;			 1 0 7 1
; 			 1 8 1 5
;		    ---------
*/

		.arch armv8-a
        .data
//;------------DATA----------------
size:
		.byte	4 //;SIZE OF MATRIX

matrix:
		.byte   8, 7, 4, 1
		.byte	5, 3, 1, 1
		.byte	1, 0, 8, 1
		.byte	1, 7, 1, 5

//;--------------------------------

//;		W0 - INDEX OFFSET
//;		W1 - SIZE
//;		X2 - BEGIN OF MATRIX
//;		W3 - I
//;		W4 - RIGHT
//;		W5 - LEFT
//;		W6 - CONTROL
//;		W7 - J

//;--------------------------------

        .text
        .align  2
        .global _start
        .type   _start, %function
 _start:

		adr		x1, size
		ldrsb	w1, [x1]//;w1 = size

		sub		w0, w1, #1//;w0 = size - 1

		adr		x2, matrix//;&matrix
		
//;--------------------------------------
		mov		w3, #1 //;int i = 1

		b 		L0
		
L0:		//;~~FIRST LOOP FOR DIAGS~~
		cmp		w3, w0//;i < size - 1
		b.lt	L1//;true -> in loop
		b 		init_L16//;false -> out of loop

L1:		//;~~INITIAL RIGHT LEFT AND CONTROL~~
		mul		w4, w0, w3 //;w4 = i*(n-1)
		add		w4, w4, w3 //;w4 = i*(n-1)+i [RIGHT]
		mov		w5, w3 //;w5 = i [LEFT]
		mov		w6, w3 //;w6 = i [CONTROL]
		b 		L2//; -> initial j
		
L2:		//;~~INITIAL J OF FIRST LOOP FOR SHAKE~~
		mov		w7, w5 //;int j = left
		b 		L3//; -> head
L3:		//;~~FIRST LOOP FOR SHAKE HEAD~~
		cmp		w7, w4 //;j < right
		b.lt	L4//;true -> in loop
		b.ge	L7//;false -> out of loop (right = control)
L4:		//;~~FIRST LOOP FOR SHAKE BODY~~
		ldrsb	w8, [x2, x7]//;matrix[j]
		add		w9, w7, w0 //;w9 = j + size - 1
		ldrsb	w10, [x2, x9]//;matrix[j + size - 1]
		cmp		w8, w10//;matrix[j] > matrix[j + size - 1]
		b.gt    L5//;true -> swap
		b.le 	L6//;fale -> increment j

L5:		//;~~SWAP TWO CELLS FOR FIRST LOOP~~
		strb	w10, [x2, x7]//;matrix[j] = matrix[j + size - 1]
		strb	w8, [x2, x9]//;matrix[j + size - 1] = matrix[j]
		mov		w6,	w7//;control = j
		b		L6//; -> increment j

L6:		//;~~INCREMENT J FOR FIRST LOOP~~
		add		w7, w7, w0//;j += size - 1
		b 		L3//; -> head

L7:		//;~~RIGHT = CONTROL~~
		mov		w4, w6//;right = control
		b 		L8 	
L8:		//;~~INITIAL J OF SECOND LOOP FOR SHAKE~~
		mov		w7, w4//;j = right
L9:		//;~~SECOND LOOP FOR SHAKE HEAD~~
		cmp		w7, w5//;j > left
		b.gt	L10//;true -> in loop
		b.le    L13//;false -> out of loop (left = control)
L10:	//;~~SECOND LOOP FOR SHAKE BODY~~
		ldrsb	w8, [x2, x7]//;matrix[j]
		sub		w9, w7, w0//;w9 = j - (size - 1)
		ldrsb	w10, [x2, x9]//;matrix[j - (size - 1)]
		cmp		w8, w10//;matrix[j] < matrix[j - (size - 1)]
		b.lt	L11//;true -> swap
		b.ge	L12//;false -> increment j
L11:	//;~~SWAP TWO CELLS FOR SECOND LOOP~~
		strb	w10, [x2, x7]//;matrix[j] = matrix[j - (size - 1)]
		strb	w8, [x2, x9]//;matrix[j - (size - 1)] = matrix[j]
		mov		w6,	w7//;control = j
		b 		L12//; -> decrement j
L12:	//;~~DECREMENT J FOR SECOND LOOP~~
		sub		w7, w7, w0//;j -= size - 1
		b 		L9//; -> head
L13:	//;~~LEFT = CONTROL~~
		mov		w5, w6//;left = control
		b 		L15//;out to external loop {WAS b L14}
L14:	//;~~INCREMENT I OF EXTERNAL LOOP~~
		add		w3, w3, #1//;i++
		b 		L0//; -> HEAD OF EXTERNAL DIAG LOOP {WAS L15}
L15:
		cmp		w5, w4//;left < right
		b.lt	L2//; true -> initial j of first shake loop
		b.ge 	L14//; false -> increment i -> HEAD OF EXTERNAL EXTERNAL DIAG LOOP {WAS L0}

//;			-----------------------------
//;  			~~UNDER DIAGONALS~~
//;			-----------------------------

init_L16:	//;~~INITIALS FOR SECOND DIAG LOOP~~
		mov		w3, #1//;i = 1

L16:		//;~~SECOND LOOP FOR DIAGS~~
		cmp		w3, w0//;i < size - 1
		b.lt	L17//;true -> in loop
		b 		EXIT//;false -> EXIT

L17:		//;~~INITIAL RIGHT LEFT AND CONTROL~~
		mul		w4, w1, w1//;w4 = size*size
		sub		w4, w4, w3//;w4 = size*size - i
		sub		w4, w4, #1//;w4 = size*size - i - 1 [RIGHT]
		

		mul		w5, w1, w1//;w5 = size*size
		mul		w19, w0, w3 //;w19[BUF] = i*(n-1)
		add		w19, w19, w3 //;w19 = i*(n-1)+i
		sub		w5, w5, w19 //;w5 = size*size - i*(n-1) - i
		sub		w5, w5, #1//;w5 = size*size - i*(n-1) - i - 1 [LEFT]

		mov		w6, w5//;w6 = size*size - i*(n-1) - i [CONTROL]
		
		b 		L18//; -> initial j
		
L18:		//;~~INITIAL J OF FIRST LOOP FOR SHAKE~~
		mov		w7, w5 //;int j = left
		b 		L19//; -> head
L19:		//;~~FIRST LOOP FOR SHAKE HEAD~~
		cmp		w7, w4 //;j < right
		b.lt	L20//;true -> in loop
		b.ge	L23//;false -> out of loop (right = control)
L20:		//;~~FIRST LOOP FOR SHAKE BODY~~
		ldrsb	w8, [x2, x7]//;matrix[j]
		add		w9, w7, w0 //;w9 = j + size - 1
		ldrsb	w10, [x2, x9]//;matrix[j + size - 1]
		cmp		w8, w10//;matrix[j] > matrix[j + size - 1]
		b.gt    L21//;true -> swap
		b.le 	L22//;fale -> increment j

L21:		//;~~SWAP TWO CELLS FOR FIRST LOOP~~
		strb	w10, [x2, x7]//;matrix[j] = matrix[j + size - 1]
		strb	w8, [x2, x9]//;matrix[j + size - 1] = matrix[j]
		mov		w6,	w7//;control = j
		b		L6//; -> increment j

L22:		//;~~INCREMENT J FOR FIRST LOOP~~
		add		w7, w7, w0//;j += size - 1
		b 		L19//; -> head

L23:		//;~~RIGHT = CONTROL~~
		mov		w4, w6//;right = control
		b 		L24 	
L24:		//;~~INITIAL J OF SECOND LOOP FOR SHAKE~~
		mov		w7, w4//;j = right
L25:		//;~~SECOND LOOP FOR SHAKE HEAD~~
		cmp		w7, w5//;j > left
		b.gt	L26//;true -> in loop
		b.le    L29//;false -> out of loop (left = control)
L26:	//;~~SECOND LOOP FOR SHAKE BODY~~
		ldrsb	w8, [x2, x7]//;matrix[j]
		sub		w9, w7, w0//;w9 = j - (size - 1)
		ldrsb	w10, [x2, x9]//;matrix[j - (size - 1)]
		cmp		w8, w10//;matrix[j] < matrix[j - (size - 1)]
		b.lt	L27//;true -> swap
		b.ge	L28//;false -> decrement j
L27:	//;~~SWAP TWO CELLS FOR SECOND LOOP~~
		strb	w10, [x2, x7]//;matrix[j] = matrix[j - (size - 1)]
		strb	w8, [x2, x9]//;matrix[j - (size - 1)] = matrix[j]
		mov		w6,	w7//;control = j
		b 		L28//; -> decrement j
L28:	//;~~DECREMENT J FOR SECOND LOOP~~
		sub		w7, w7, w0//;j -= size - 1
		b 		L25//; -> head
L29:	//;~~LEFT = CONTROL~~
		mov		w5, w6//;left = control
		b 		L31//;out to external loop
L30:	//;~~INCREMENT I OF EXTERNAL LOOP~~
		add		w3, w3, #1//;i++
		b 		L16//; -> HEAD OF EXTERNAL WHILE LOOP
L31:
		cmp		w5, w4//;left > right
		b.gt	L18//; true -> initial j of first shake loop
		b.le 	L30//; false -> HEAD OF EXTERNAL EXTERNAL DIAG LOOP


EXIT:
 		mov     x0, #0
 		mov     x8, #93
 		svc     #0
