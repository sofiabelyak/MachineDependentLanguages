EXTRN output_X:far
PUBLIC input_X
PUBLIC X       ; Объявление переменной X как общедоступной

STK SEGMENT PARA STACK 'STACK'
    db 200 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    X db ?       ; Используем db для байтовой переменной
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, SS:STK

main:
    mov ax, DSEG
    mov ds, ax

    call input_X   ; Вызов процедуры ввода символа
    call output_X   ; Переход к выводу символа на экран
	
	mov ah, 4Ch    ; Функция 4Ch - завершение программы
    int 21h        ; Вызов прерывания DOS для завершения программы

input_X proc near
    mov ah, 08h        ; Запрос на ввод символа без эха
    int 21h            ; Вызов прерывания DOS для ввода символа
    mov X, al          ; Сохранение введенного символа в переменной X
    ret                ; Возврат из процедуры
input_X endp


CSEG ENDS
END main
