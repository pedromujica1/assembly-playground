; Avaliação 01 – grades recovery section
; arquivo: pedromiottomujica.asm
; Atividade: Ler uma string de caracteres e converter o texto para um inteiro 
; nasm -f pedromiottomujica.asm ; ld pedromiottomujica.o -o pedromiottomujica.x

section .data
    entrada : db "Digite a entrada (somente numeros!): ", 0
    entradaL : equ $ - entrada

    strBye : db "String convertida: "
    strByeL: equ $ - strBye

    strLF  : db 10 ; quebra de linha
    strLFL : equ 1
    erroMsg: db "Erro: número muito grande para converter.", 10
    erroMsgL: equ $ - erroMsg
     
section .bss
    resultado : resq 1 ;8b = 64bits 
    strLida : resb 255 ;define a qtdade max de caracteres (255)
    strLidaL : resd 1 ;4b = 32bits
    tamanhoStr : resd 1 ;4b para tamaho da string
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

    ;leitura da string de entrada
    mov dword [strLidaL], 255 ;tamanho maximo do char no strlidaL
    ;dword pois 32 bits = resd = 4 Bytes

   ; ssize_t read(int fd , const void *buf, size_t count);
   ; rax     read(int rdi, const void *rsi, size_t rdx  );
    mov rax, 0  ; READ
    mov rdi, 0
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax
    ;laço para descobrir tamanho da string
    xor r8,r8 ;reg para salvar len da str
   
laco_tamanho:
    ;verificacao se o caractere da string == nulo
    mov al, byte [strLida + r8] ;faz a leitura de 1B
    cmp al, 10d ; compara com 10decimal pois == '\n' em ascii
    je laco_registradores

    inc r8 ;tamanhoStr++
    cmp r8,255
    jne laco_tamanho
laco_registradores:
    mov [tamanhoStr], r8 ;tamanho da string armazenado

    
    xor rax,rax ;registrador acumulador 64 bits
    xor rbx,rbx ;registrador base 64 bits
    xor rcx,rcx ;int i ou registrador contador 

laco_conversao:
    cmp rcx, [tamanhoStr] ;compara com tamanho da string
    je fim_laco

    movzx rbx, byte [strLida + rcx] ;faz a leitura de 1B para registrador de 64 bits

    sub rbx, 48d ;faz a subtração por 48decimal = '0' em ascii
    ; resultadoTemp = resultadoTemp * 10 + ('chr'-48d)
    imul rax,rax, 10 ;resultadoTemp = resultadoTemp *10 
    jo erro_overflow
    add rax, rbx ;resultadoTemp= + ('caractere'-48d)
    jo erro_overflow
    inc rcx;
    jmp laco_conversao

erro_overflow:
    ;mensagem de erro
    mov rax, 1
    mov rdi, 1
    mov rsi, erroMsg
    mov edx, erroMsgL
    syscall

    ;return 0
    mov rax, 60
    mov rdi, 1   ; código de erro 1
    syscall

fim_laco:
    mov [resultado], rax
    
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

fim:
   ; void _exit(int status);
   ; void _exit(int rdi   );
   mov rax, 60
   mov rdi, 0
   syscall
