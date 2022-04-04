.arch armv8-a
.data
        .align  2
res:
	.skip 4
a:
	.4byte 2
b:
	.byte 2
c:
	.2byte 3
d:
	.4byte 12
e:
	.4byte 9
	
.text
        .align  2
        .global _start
        .type   _start, %function
_start:

    /* a --> x1
       b --> x3
       c --> x4
       d --> x2
       e --> x5
		
	   Expression: d*a/(a+b*c) + (d+b)/(e-a)
    */
      	  
	adr     x0, a
    ldr		w1, [x0]

	adr		x0, d
	ldr		w2, [x0]

	adr		x0, b
	ldrb	w3, [x0]
	
	adr		x0, c
	ldrh	w4, [x0]

    adr		x0, e
	ldr		w5, [x0]

/*-----First term calculating-----*/

	mul		w6, w2, w1

    mul		w7, w3, w4
	adds	w8, w7, w1
	b.cs	exit
	b.eq	exit //If a = 0 && b*c = 0	

	udiv	w8, w6, w7

/*-------------------------------*/

/*----Second term calculating----*/ 

	adds	w6, w2, w3
	b.cs	exit

	subs	w7, w5, w1 
	b.cc	exit
	b.eq	exit //If e = a

	udiv	w9, w6, w7

/*------------------------------*/

	adds	w10, w9, w8 /* RESULT IN W10 */
	b.cs	exit

	adr		x0, res
	str		w10, [x0]

	b		exit /* EXIT FROM PROGRAM */

exit:
	mov		x0, #0
	mov		x8, #93
	svc		#0
    .size	_start, .-_start
