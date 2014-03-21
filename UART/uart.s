	.file	"uart.c"
	.cpu 430
	.mpy none

	.section	.init9,"ax",@progbits
	.p2align 1,0
.global	main
	.type	main,@function
/***********************
 * Function `main' 
 ***********************/
main:
	mov	r1, r4
	add	#2, r4
	mov	#23168, &__WDTCTL
	mov.b	&__CALBC1_1MHZ, r15
	mov.b	r15, &__BCSCTL1
	mov.b	&__CALDCO_1MHZ, r15
	mov.b	r15, &__DCOCTL
	call	#uartInit
	mov.b	&__P1DIR, r15
	bis.b	#64, r15
	mov.b	r15, &__P1DIR
.L2:
	call	#uartGetChar
	call	#switchCase
	call	#uartPutChar
	jmp	.L2
.LIRD0:
.Lfe1:
	.size	main,.Lfe1-main
;; End of function 

	.text
	.p2align 1,0
.global	uartInit
	.type	uartInit,@function
/***********************
 * Function `uartInit' 
 ***********************/
uartInit:
	push	r4
	mov	r1, r4
	add	#2, r4
	mov.b	&__P1SEL, r15
	bis.b	#6, r15
	mov.b	r15, &__P1SEL
	mov.b	&__P1SEL2, r15
	bis.b	#6, r15
	mov.b	r15, &__P1SEL2
	mov.b	&__P1DIR, r15
	bis.b	#4, r15
	mov.b	r15, &__P1DIR
	mov.b	&__UCA0CTL1, r15
	bis.b	#llo(-128), r15
	mov.b	r15, &__UCA0CTL1
	mov.b	#104, &__UCA0BR0
	mov.b	#0, &__UCA0BR1
	mov.b	#4, &__UCA0MCTL
	mov.b	&__UCA0CTL1, r15
	and.b	#llo(-2), r15
	mov.b	r15, &__UCA0CTL1
	pop	r4
	ret
.Lfe2:
	.size	uartInit,.Lfe2-uartInit
;; End of function 

	.p2align 1,0
.global	uartPutChar
	.type	uartPutChar,@function
/***********************
 * Function `uartPutChar' 
 ***********************/
uartPutChar:
	push	r4
	mov	r1, r4
	add	#2, r4
	sub	#2, r1
	mov.b	r15, -4(r4)
	nop
.L5:
	mov.b	&__IFG2, r15
	mov.b	r15, r15
	and	#2, r15
	cmp	#0, r15
	jeq	.L5
	mov.b	-4(r4), r15
	mov.b	r15, &__UCA0TXBUF
	add	#2, r1
	pop	r4
	ret
.Lfe3:
	.size	uartPutChar,.Lfe3-uartPutChar
;; End of function 

	.p2align 1,0
.global	uartPutString
	.type	uartPutString,@function
/***********************
 * Function `uartPutString' 
 ***********************/
uartPutString:
	push	r4
	mov	r1, r4
	add	#2, r4
	sub	#2, r1
	mov	r15, -4(r4)
	jmp	.L7
.L8:
	mov	-4(r4), r15
	mov.b	@r15, r15
	call	#uartPutChar
	add	#1, -4(r4)
.L7:
	mov	-4(r4), r15
	mov.b	@r15, r15
	cmp.b	#0, r15
	jne	.L8
	add	#2, r1
	pop	r4
	ret
.Lfe4:
	.size	uartPutString,.Lfe4-uartPutString
;; End of function 

	.p2align 1,0
.global	uartGetChar
	.type	uartGetChar,@function
/***********************
 * Function `uartGetChar' 
 ***********************/
uartGetChar:
	push	r4
	mov	r1, r4
	add	#2, r4
	nop
.L10:
	mov.b	&__IFG2, r15
	mov.b	r15, r15
	and	#1, r15
	cmp	#0, r15
	jeq	.L10
	mov.b	&__UCA0RXBUF, r15
	pop	r4
	ret
.Lfe5:
	.size	uartGetChar,.Lfe5-uartGetChar
;; End of function 

	.p2align 1,0
.global	switchCase
	.type	switchCase,@function
/***********************
 * Function `switchCase' 
 ***********************/
switchCase:
	push	r4
	mov	r1, r4
	add	#2, r4
	sub	#2, r1
	mov.b	r15, -4(r4)
	cmp.b	#97, -4(r4)
	jl	.L12
	cmp.b	#123, -4(r4)
	jge	.L12
	mov.b	-4(r4), r15
	add.b	#llo(-32), r15
	jmp	.L13
.L12:
	cmp.b	#65, -4(r4)
	jl	.L14
	cmp.b	#91, -4(r4)
	jge	.L14
	mov.b	-4(r4), r15
	add.b	#32, r15
	jmp	.L15
.L14:
	mov.b	-4(r4), r15
.L15:
.L13:
	add	#2, r1
	pop	r4
	ret
.Lfe6:
	.size	switchCase,.Lfe6-switchCase
;; End of function 

