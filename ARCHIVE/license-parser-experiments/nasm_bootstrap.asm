; docs/wasm/nasm_bootstrap.asm
; Minimal x86 assembly "bootstrap" example (for illustration only)
section .text
global _start

_start:
    ; Write "Palimpsest WASM Bootstrap" to stdout
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, message    ; pointer to message
    mov edx, message_len; message length
    int 0x80            ; invoke kernel

    ; Exit with code 0
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; invoke kernel

section .data
message db 'Palimpsest WASM Bootstrap', 0xA
message_len equ $ - message