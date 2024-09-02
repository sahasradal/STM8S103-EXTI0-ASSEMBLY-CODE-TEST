stm8/
	; works fine, LED on PD4 stays off till a rising edge is applied on PA2,
	#include "mapping.inc"
	#include "stm8s103f.inc"
	
pointerX MACRO first
	ldw X,first
	MEND
pointerY MACRO first
	ldw Y,first
	MEND	
	



	segment byte at 100 'ram1'
buffer1 ds.b
buffer2 ds.b
buffer3 ds.b
buffer4 ds.b
buffer5 ds.b
buffer6 ds.b
buffer7 ds.b
buffer8 ds.b
buffer9 ds.b
buffer10 ds.b
buffer11 ds.b
buffer12 ds.b
buffer13 ds.b	; remainder byte 0 (LSB)
buffer14 ds.b	; remainder byte 1
buffer15 ds.b	; remainder byte 2
buffer16 ds.b	; remainder byte 3 (MSB)
buffer17 ds.b	; loop counter
captureH ds.b
captureL ds.b	
captureHS ds.b
captureLS ds.b
captureHT ds.b
captureLT ds.b
capture_state ds.b	
nibble1  ds.b
data	 ds.b
address  ds.b
signbit  ds.b
state    ds.b
temp1    ds.b
decimal  ds.b
result4  ds.b
result3  ds.b
result2  ds.b
result1  ds.b
counter1 ds.b
counter2 ds.b
num1 	  ds.b     ;divisor top
num2 	  ds.b     ;divisor top
num3	  ds.b     ;divisor top
num4 	  ds.b     ;divisor top
num5 	  ds.b     ;divisor top
num6 	  ds.b     ;divisor top
num7 	  ds.b     ;divisor top
num8 	  ds.b     ;divisor top
buffers  ds.b 23






	segment 'rom'
main.l
	; initialize SP
	ldw X,#stack_end
	ldw SP,X

	#ifdef RAM0	
	; clear RAM0
ram0_start.b EQU $ram0_segment_start
ram0_end.b EQU $ram0_segment_end
	ldw X,#ram0_start
clear_ram0.l
	clr (X)
	incw X
	cpw X,#ram0_end	
	jrule clear_ram0
	#endif

	#ifdef RAM1
	; clear RAM1
ram1_start.w EQU $ram1_segment_start
ram1_end.w EQU $ram1_segment_end	
	ldw X,#ram1_start
clear_ram1.l
	clr (X)
	incw X
	cpw X,#ram1_end	
	jrule clear_ram1
	#endif

	; clear stack
stack_start.w EQU $stack_segment_start
stack_end.w EQU $stack_segment_end
	ldw X,#stack_start
clear_stack.l
	clr (X)
	incw X
	cpw X,#stack_end	
	jrule clear_stack











infinite_loop.l

	mov CLK_CKDIVR,#$00	; cpu clock no divisor = 16mhz
	bset PD_DDR,#4		; set PD3 as output
	bset PD_CR1,#4		; set PD3 as pushpull
	bset PD_ODR,#4		; set PD4 high , LED OFF
	bres PA_DDR,#2		; clear PA2 DDR to set as input 
	bset PA_CR2,#2		; floating interrupt PA2
	mov EXTI_CR1,#1		; rising edge on PA2 will trigger interrupt
	rim					; enable interrupt globally
	wfi					; wait for interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
here
	jp here




	interrupt EXTI0_ISR
EXTI0_ISR
	mov buffer3,#255	; delay loop2 counter
L2	
	ldw X,#65535		; delay loop1 counter
L1
	decw X				; decrease loop1 counter by 1
	jrne L1				; if X not 0 jump to label L1
	bcpl PD_ODR,#4		; if X is 0 , toggle PD4 (LED connected)
	dec buffer3			; decrease buffer3
	jrne L2				; load X with 65535 if buffer3 is not 0
	iret				; return from interrupt if buffer3 is 0





	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	segment 'vectit'
	dc.l {$82000000+main}									; reset
	dc.l {$82000000+NonHandledInterrupt}	; trap
	dc.l {$82000000+NonHandledInterrupt}	; irq0
	dc.l {$82000000+NonHandledInterrupt}	; irq1
	dc.l {$82000000+NonHandledInterrupt}	; irq2
	dc.l {$82000000+EXTI0_ISR} ;				{$82000000+NonHandledInterrupt}	; irq3
	dc.l {$82000000+NonHandledInterrupt}	; irq4
	dc.l {$82000000+NonHandledInterrupt}	; irq5
	dc.l {$82000000+NonHandledInterrupt}	; irq6
	dc.l {$82000000+NonHandledInterrupt}	; irq7
	dc.l {$82000000+NonHandledInterrupt}	; irq8
	dc.l {$82000000+NonHandledInterrupt}	; irq9
	dc.l {$82000000+NonHandledInterrupt}	; irq10
	dc.l {$82000000+NonHandledInterrupt}	; irq11
	dc.l {$82000000+NonHandledInterrupt}	; irq12
	dc.l {$82000000+NonHandledInterrupt}	; irq13
	dc.l {$82000000+NonHandledInterrupt}	; irq14
	dc.l {$82000000+NonHandledInterrupt}	; irq15
	dc.l {$82000000+NonHandledInterrupt}	; irq16
	dc.l {$82000000+NonHandledInterrupt}	; irq17
	dc.l {$82000000+NonHandledInterrupt}	; irq18
	dc.l {$82000000+NonHandledInterrupt}	; irq19
	dc.l {$82000000+NonHandledInterrupt}	; irq20
	dc.l {$82000000+NonHandledInterrupt}	; irq21
	dc.l {$82000000+NonHandledInterrupt}	; irq22
	dc.l {$82000000+NonHandledInterrupt}	; irq23
	dc.l {$82000000+NonHandledInterrupt}	; irq24
	dc.l {$82000000+NonHandledInterrupt}	; irq25
	dc.l {$82000000+NonHandledInterrupt}	; irq26
	dc.l {$82000000+NonHandledInterrupt}	; irq27
	dc.l {$82000000+NonHandledInterrupt}	; irq28
	dc.l {$82000000+NonHandledInterrupt}	; irq29

	end
