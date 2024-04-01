PUBLIC output_X
EXTRN X:byte   

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG

output_X proc far
    mov ah, 02h    ; Функция 02h - вывод символа на экран
    mov dl, X      ; Загрузка байта из переменной X в dl
    int 21h        ; Вызов прерывания DOS для вывода символа
    retf
output_X endp


CSEG ENDS
END