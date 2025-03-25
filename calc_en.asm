TITLE Calcolatrice a tre cifre
;Author Salvatore Lombardo
.MODEL SMALL
.STACK
.DATA
inp1 DB 10, 13, "Enter first number: $"
inp2 DB 10, 13, "Enter second number: $"
menu0 DB 10, 13, "0. Exit"
menu1 DB 10, 13, "1. Addition"
menu2 DB 10, 13, "2. Subtraction"
menu3 DB 10, 13, "3. Multiplication"
menu4 DB 10, 13, "4. Division"
menu DB 10, 13, "Select an operation: $"
out1 DB 10, 13, "The result is: $"
out2 DB 10, 13, "Invalid selection$"
out3 DB " with remainder $"
op1 DB ?
op2 DB ?
sel DB ?
.CODE
.STARTUP

; --------------------------------------------------------
; Print message for selection
; --------------------------------------------------------
        start:
        mov DX, OFFSET menu0     
        mov AH, 09h  
        int 21h

; --------------------------------------------------------
; Input selection and check 0
; --------------------------------------------------------
        mov AH, 01h
        int 21h         ; Input selection (sel)
        mov sel, AL
        sub sel, 30h

        cmp sel, 0      ; If sel = 0 exit
        je stoppp
        cmp sel, 5
        jb output1         ; If sel < 5 valid selection

; --------------------------------------------------------
; Invalid selection
; --------------------------------------------------------
        mov DX, OFFSET out2
        mov AH, 09h     ; If selection is invalid
        int 21h
        jmp stoppp

; --------------------------------------------------------
; Print message to ask for op1
; --------------------------------------------------------
        output1:
        mov DX, OFFSET inp1
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Input data op1
; --------------------------------------------------------
        mov op1, 0      ; Reset op1
        input1:
        mov AH, 01h     ; Input digit
        int 21h
        cmp AL, 13      ; If enter is pressed exit the loop
        je output2
        sub AL, 30h

        mov BL, AL      ; Put the number in BL
        mov AL, op1
        mov DL, 10      
        mul DL          ; Multiply by 10 the result of the previous loop (to accommodate the new number)
        mov op1, AL
        add op1, BL     ; Add the entered character
        jmp input1

; --------------------------------------------------------
; Intermediate jump
; --------------------------------------------------------
        stoppp:
        jmp stopp

; --------------------------------------------------------
; Print message to ask for op2
; --------------------------------------------------------
        output2:
        mov DX, OFFSET inp2
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Input data op2
; --------------------------------------------------------
        mov op2, 0      ; Reset op2

        input2:
        mov AH, 01h     ; Input digit
        int 21h
        cmp AL, 13      ; If enter is pressed exit the loop
        je veri
        sub AL, 30h

        mov BL, AL      ; Put the number in BL
        mov AL, op2
        mov DL, 10      
        mul DL          ; Multiply by 10 the result of the previous loop (to accommodate the new number)
        mov op2, AL
        add op2, BL     ; Add the entered character
        jmp input2

; --------------------------------------------------------
; Check selection
; --------------------------------------------------------
        veri:
        cmp sel, 1      ; If sel = 1 jump
        je addi
        cmp sel, 2      ; If sel = 2 jump
        je subtra
        cmp sel, 3      ; If sel = 3 jump
        je multi
        cmp sel, 4      ; If sel = 4 jump
        je divi


; --------------------------------------------------------
; Addition
; --------------------------------------------------------
        addi:
        mov BL, op1
        mov BH, op2
        add BL, BH
        jmp resu

; --------------------------------------------------------
; Subtraction
; --------------------------------------------------------
        subtra:
        mov BL, op1
        mov BH, op2
        sub BL, BH
        jmp resu

; --------------------------------------------------------
; Multiplication
; --------------------------------------------------------
        multi:
        mov AL, op1
        mul op2
        mov BL, AL      ; Put the result in BL
        jmp resu

; --------------------------------------------------------
; Intermediate jump
; --------------------------------------------------------
        startt:
        jmp start
        stopp:
        jmp stop

; --------------------------------------------------------
; Division
; --------------------------------------------------------
        divi:
        mov AH, 0
        mov AL, op1
        div op2
        mov BL, AL      ; Put the result in BL and BH
        mov BH, AH

; --------------------------------------------------------
; Print message for the result
; --------------------------------------------------------
        resu:
        mov DX, OFFSET out1
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Output result
; --------------------------------------------------------
        mov DH, 100
        mov AL, BL
        mov AH, 0
        div DH          ; Divide by 100 (Third digit from the right)
        mov BL, AH      ; Put the remainder in BL
        mov DL, AL
        cmp DL, 0       ; If 0 do not print
        je n2
        add DL, 30h
        mov AH, 02h     ; Print first number
        int 21h

        n2:
        mov DH, 10
        mov AL, BL
        mov AH, 0
        div DH          ; Divide by 10 (Second digit from the right)
        mov BL, AH      ; Put the remainder in BL
        mov DL, AL
        cmp DL, 0       ; If 0 do not print
        je n3
        add DL, 30h
        mov AH, 02h     ; Print second number
        int 21h

        n3:
        add BL, 30h
        mov DL, BL
        mov AH, 02h     ; Print third number
        int 21h
        
        cmp sel, 4
        jne startt

; --------------------------------------------------------
; Output remainder
; --------------------------------------------------------
        mov DX, OFFSET out3
        mov AH, 09h
        int 21h
        
        mov DH, 100
        mov AL, BH
        mov AH, 0
        div DH          ; Divide by 100 (Third digit from the right)
        mov BL, AH      ; Put the remainder in BL
        mov DL, AL
        cmp DL, 0       ; If 0 do not print
        je rn2
        add DL, 30h
        mov AH, 02h     ; Print first number
        int 21h

        rn2:
        mov DH, 10
        mov AL, BL
        mov AH, 0
        div DH          ; Divide by 10 (Second digit from the right)
        mov BL, AH      ; Put the remainder in BL
        mov DL, AL
        cmp DL, 0       ; If 0 do not print
        je rn3
        add DL, 30h
        mov AH, 02h     ; Print second number
        int 21h

        rn3:
        add BL, 30h
        mov DL, BL
        mov AH, 02h     ; Print third number
        int 21h
        jmp startt



; --------------------------------------------------------
; DOS service program termination
; --------------------------------------------------------
        stop:
        mov AH, 4Ch
        int 21h
END
