section .data
    hello db 'HTTP/1.1 200 OK', 0x0D, 0x0A
    content_type db 'Content-Type: text/html', 0x0D, 0x0A
    body db '<html><body><h1>Hello, World!</h1></body></html>', 0x0D, 0x0A

section .bss
    sockaddr resb 16

section .text
    global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41                ; sys_socketcall
    mov rdi, 1                 ; SYS_SOCKET
    lea rsi, [rsp+8]           ; pointer to (AF_INET, SOCK_STREAM, 0)
    mov qword [rsp+8], 2       ; AF_INET
    mov qword [rsp+10], 1      ; SOCK_STREAM
    mov qword [rsp+18], 0      ; IPPROTO_IP
    syscall

    ; Save the socket descriptor
    mov rbx, rax               ; socket descriptor

    ; bind(sock, sockaddr, sockaddr_len)
    mov rdi, rbx               ; socket
    lea rsi, [sockaddr]        ; sockaddr pointer
    mov rdx, 16                ; sockaddr_len (16 bytes)
    mov rax, 49                ; sys_socketcall
    mov rdi, 2                 ; SYS_BIND
    syscall

    ; listen(sock, 5)
    mov rdi, rbx               ; socket
    mov rsi, 5                 ; backlog
    mov rax, 49                ; sys_socketcall
    mov rdi, 4                 ; SYS_LISTEN
    syscall

    ; accept(sock, sockaddr, sockaddr_len)
    lea rsi, [sockaddr]        ; sockaddr pointer
    mov rdx, 16                ; sockaddr_len (16 bytes)
    mov rdi, rbx               ; socket
    mov rax, 49                ; sys_socketcall
    mov rdi, 5                 ; SYS_ACCEPT
    syscall

    ; Save the new client socket descriptor
    mov rdx, rax               ; client socket descriptor

    ; Send HTTP response
    ; Write HTTP headers
    mov rdi, rdx               ; client socket
    lea rsi, [hello]           ; pointer to HTTP headers
    mov rdx, 18                ; length of hello
    mov rax, 1                 ; sys_write
    syscall

    mov rdi, rdx               ; client socket
    lea rsi, [content_type]    ; pointer to content_type
    mov rdx, 21                ; length of content_type
    mov rax, 1                 ; sys_write
    syscall

    ; Send HTML body
    mov rdi, rdx               ; client socket
    lea rsi, [body]            ; pointer to body
    mov rdx, 42                ; length of body
    mov rax, 1                 ; sys_write
    syscall

    ; close(socket)
    mov rdi, rdx               ; client socket
    mov rax, 3                 ; sys_close
    syscall

    ; exit(0)
    mov rdi, 0                 ; exit status
    mov rax, 60                ; sys_exit
    syscall
