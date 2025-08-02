EXIT equ 1

extern printf

section .data
array:
	dw 75
	dw 72
	dw 80
	dw 84

array_len equ ($ - array) / 2

min: db "Min:", 0
max: db "Max:", 0
average: db "Average:", 0
output_fmt: db "%s %d", 10, "%s %d", 10, "%s %d", 10, 0

section .text
global  main

; esi - index (implicit by lodsw)
; ax - current data (use lodsw instruction)
; bx - min
; di - max
; dx - average

main:
	cld ; increment esi while doing lodsw operation
	mov esi, array
    lodsw
	mov bx, ax
	mov di, ax
	mov dx, ax
    xor ecx, ecx ; needs to be clean ecx before modifying cx in loop
    %if array_len == 1
        jmp calc_average
    %endif
    mov cx, array_len - 1

eval:
	lodsw ; loads the next element from array

    cmp bx, ax
	cmovg bx, ax
    cmp di, ax
	cmovl di, ax
	add   dx, ax
	loop eval

calc_average:
    movzx eax, bx ; convert from 16 to 32 bits
	push eax; min
    push min
    movzx eax, di ; convert from 16 to 32 bits
	push eax; max
    push max
	mov  ax, dx
	mov  cx, array_len
    cwd
	div  cx
    movzx eax, ax
	push eax; average
    push average

print:
    push output_fmt
    call printf
    add esp, 28

exit:
	mov eax, EXIT
	mov ebx, 0
	int 0x80
