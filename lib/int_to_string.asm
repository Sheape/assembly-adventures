; Globals
global int_to_str

section .bss
    output_string resb 12

; Main
section .text

; char* int_to_str(int input)
;
; Parameters:
; int input - [esp + 4]
;
; Returns:
; memory address to output string - eax
int_to_str:
    mov ebx, [esp + 4]     ; load input to ebx
    mov esi, output_string + 11
    cmp ebx, 0
    jg _divide

_negative:
    mov byte [output_string], '-'

_divide:
    mov eax, ebx
    cmp eax, 0
    je _end
    xor edx, edx
    mov ecx, 10
    div ecx
    mov ebx, eax

_cast:
    add dl, '0'
    dec esi
    mov [esi], dl
    jmp _divide

_end:
    mov eax, output_string
    ret
