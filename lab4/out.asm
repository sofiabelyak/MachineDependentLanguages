PUBLIC symb
PUBLIC print
PUBLIC space
PUBLIC swap_rows


PUBLIC n
PUBLIC m
PUBLIC mat

DATA SEGMENT PARA COMMON 'DATA'
    n DB 0             ; Переменная для хранения длины
    m DB 0             ; Переменная для хранения ширины
    mat db 81 dup(?)  ; Массив для хранения матрицы
    i db 0             ; Счетчик строк
    j db 0             ; Счетчик столбцов
    half_n db ?        ; Половина значения переменной n
DATA ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DATA
	
symb proc near
    ; Вывод символа новой строки
    mov ah, 02h 
    mov dl, 0Ah
    int 21h
    ret
symb endp

space proc near
    ; Вывод пробела
    mov dl, ' '     ; Загрузить пробел в DL
    mov ah, 02h     ; Загрузить функцию для вывода символа
    int 21h         ; Вывести символ
    ret
space endp

newline:
    inc i
    mov j, 0
    
    call symb
    jmp goto2

print proc near
    ; Установка сегмента данных
    mov ax, data
    mov ds, ax

    ; Инициализация счетчиков
    mov si, 0
    mov i, 0
    mov j, 0

    ; Вычисление общего количества элементов матрицы
    mov al, n
    mul m
    mov cx, ax   

    ; Вывод матрицы на экран
    call symb
    call print_matrix
    ret
print endp

print_matrix:
    ; Вывод элементов матрицы
    mov dl, mat[si]
    add dl, '0'
    mov ah, 02h         
    int 21h

    ; Вывод пробела после элемента
    call space

    ; Увеличение счетчика столбцов
    inc j

    ; Проверка достижения конца строки
    mov al, j
    cmp al, m
    je newline
    goto2:
    ; Вычисление индекса следующего элемента
    mov al, i
    mov bl, 9
    mul bl
    add al, j
    mov si, ax

    loop print_matrix
    ret


swap_rows proc near
    ; Установка сегмента данных
    mov ax, data
    mov ds, ax

    ; Вычисление половины значения переменной n
    mov al, n
    mov ah, 0h
    mov bl, 2h
    div bl
    mov half_n, al

    ; Инициализация счетчика строк
    mov i, 0

swap_mat_rows_loop:
    ; Получение указателей на строки для обмена
    mov si, offset mat
    mov al, 9
    mul i
    add si, ax

    mov di, offset mat
    mov al, n
    dec al
    sub al, i
    mov dl, 9
    mul dl
    add di, ax

    ; Обмен строк
    mov cl, m
swap_two_rows_loop:
        mov al, [si]
        xchg al, [di]
        mov [si], al
        inc si
        inc di
        loop swap_two_rows_loop

    ; Увеличение счетчика строк
    inc i
    mov al, i
    cmp al, half_n
    jl swap_mat_rows_loop

    ret
swap_rows endp



CSEG ENDS
END
