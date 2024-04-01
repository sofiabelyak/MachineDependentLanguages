EXTRN symb: near
EXTRN print: near
EXTRN space: near
EXTRN swap_rows: near

EXTRN n:byte
EXTRN m:byte
EXTRN mat:byte

STK SEGMENT PARA STACK 'STACK'
    db 100 dup(0)
STK ENDS

DATA SEGMENT   
    msg1 DB 'Enter the number of rows (<= 9): $'
    msg2 DB 'Enter the number of columns (<= 9): $'
    i DB 0
    j DB 0
DATA ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume cs:CSEG, ds:DATA

main:
    mov ax,data
    mov ds, ax

	call f     ; Вызов функции f для ввода и обработки матрицы
    call swap_rows ; Вызов функции для обмена строк матрицы
    call print  ; Вызов функции для вывода матрицы на экран
    mov ah, 4Ch ; Выход из программы с кодом 0
    int 21h     ; Прерывание для завершения программы

f:
    ; Вывод сообщения о вводе количества строк
    mov ah, 09h         
    mov dx, OFFSET msg1
    int 21h
    ; Ввод количества строк
    call enter_num
    mov n, al
    ; переход на новую строку
    call symb
    ; Вывод сообщения о вводе количества столбцов
    mov ah, 09h
    mov dx, OFFSET msg2
    int 21h
    ; Ввод количества столбцов
    call enter_num
    mov m, al

    mov al, n            ; Загрузка количества строк в AL
    mul m                ; Умножение количества строк на количество столбцов
    mov cx, ax           ; Сохранение результата умножения в CX

    mov si, 0
    mov i, 0
    mov j, 0
	; Вызов функции для перехода на новую строку
    call symb
	; Цикл для ввода элементов матрицы
    read_lbl:
        call enter_num ; Вызов функции для ввода элемента матрицы
        mov bl, al

        call space ; Вызов функции для вывода пробела
        mov dl, bl
		; Вычисление индекса элемента в матрице и сохранение значения
        mov al, i
        mov bl, 9
        mul bl
        add al, j
        mov si, ax
        mov mat[si], dl
        
        inc j
		; Проверка достижения конца строки
        mov al, j
        cmp al, m
        je newline
        goto1:
        loop read_lbl
    ret
    
enter_num:
    mov ah, 01h
    int 21h
    sub al, '0'  ; Преобразование символа в число
    ret

newline:
    inc i
    mov j, 0
    
    call symb           ; Вызов функции для перехода на новую строку
    jmp goto1           ; Переход к следующему элементу матрицы

CSEG ENDS


END main
