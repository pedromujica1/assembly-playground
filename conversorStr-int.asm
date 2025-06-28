section .data
    entrada : db "Digite a entrada (somente numeros!): ", 0
    entradaL : equ $ - entrada

    strBye : db "Você digitou: "
    strByeL: equ $ - strBye

    strLF  : db 10 ; quebra de linha
    strLFL : equ 1
    
section .bss
    resultado : resq 1 ; 
    strLida : resb 255 ;define a qtdade max de caracteres (255)
    strLidaL : resd 1

    
section .text
    global _start:
_start:
    ; seu código aqui
    ; ssize_t write(int fd , const void *buf, size_t count);
    ; rax     write(int rdi, const void *rsi, size_t rdx  );
    mov rax, 1  ; WRITE
    mov rdi, 1
    lea rsi, [entrada]
    mov edx, entradaL
    syscall

leitura:
    mov dword [strLidaL], 255 ;tamanho maximo do char

   ; ssize_t read(int fd , const void *buf, size_t count);
   ; rax     read(int rdi, const void *rsi, size_t rdx  );
    mov rax, 0  ; READ
    mov rdi, 1
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax

resposta:
    mov rax, 1  ; WRITE
    mov rdi, 1
    lea rsi, [strBye]
    mov edx, strByeL
    syscall

    mov rax, 1  ; WRITE
    mov rdi, 1
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

quebradeLinha:
    mov rax, 1  ; WRITE
    mov rdi, 1
    lea rsi, [strLF]
    mov edx, strLFL
    syscall

_fim:
    mov rax, 60
    mov rdi, 0
    syscall
