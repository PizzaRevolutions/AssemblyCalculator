TITLE Calcolatrice a tre cifre
;Autore Salvatore Lombardo
.MODEL SMALL
.STACK
.DATA
ins1 DB 10, 13, "Inserisci primo numero: $"
ins2 DB 10, 13, "Inserisci secondo numero: $"
sele0 DB 10, 13, "0. Esci"
sele1 DB 10, 13, "1. Addizione"
sele2 DB 10, 13, "2. Sottrazione"
sele3 DB 10, 13, "3. Moltiplicazione"
sele4 DB 10, 13, "4. Divisione"
sele DB 10, 13, "Seleziona un'operazione: $"
out1 DB 10, 13, "Il risultato e' uguale a $"
out2 DB 10, 13, "Selezione non valida$"
out3 DB " con resto $"
op1 DB ?
op2 DB ?
sel DB ?
.CODE
.STARTUP

; --------------------------------------------------------
; Stampa messaggio x selezione
; --------------------------------------------------------
        inizio:
        mov DX, OFFSET sele0     
        mov AH, 09h  
        int 21h

; --------------------------------------------------------
; Input selezione e verifica 0
; --------------------------------------------------------
        mov AH, 01h
        int 21h         ; Input selezione (sel)
        mov sel, AL
        sub sel, 30h

        cmp sel, 0      ; Se sel = 0 esci
        je stoppp
        cmp sel, 5
        jb output1         ; Se sel < 5 selezione valida

; --------------------------------------------------------
; Selezione non valida
; --------------------------------------------------------
        mov DX, OFFSET out2
        mov AH, 09h     ; Se selezione non valida
        int 21h
        jmp stoppp

; --------------------------------------------------------
; Stampa messaggio x chiedere op1
; --------------------------------------------------------
        output1:
        mov DX, OFFSET ins1
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Imput dati op1
; --------------------------------------------------------
        mov op1, 0      ; Azzeramento op1
        input1:
        mov AH, 01h     ; Input cifra
        int 21h
        cmp AL, 13      ; Se premuto invio esci dal ciclo
        je output2
        sub AL, 30h

        mov BL, AL      ; Metto il numero su BL
        mov AL, op1
        mov DL, 10      
        mul DL          ; Moltiplico per 10 risultato ciclo precedente (x ospitare nuovo numero)
        mov op1, AL
        add op1, BL     ; Sommo il carattere inserito
        jmp input1

; --------------------------------------------------------
; Salto intermedio
; --------------------------------------------------------
        stoppp:
        jmp stopp

; --------------------------------------------------------
; Stampa messaggio x chiedere op2
; --------------------------------------------------------
        output2:
        mov DX, OFFSET ins2
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Imput dati op2
; --------------------------------------------------------
        mov op2, 0      ; Azzeramento op2

        input2:
        mov AH, 01h     ; Input cifra
        int 21h
        cmp AL, 13      ; Se premuto invio esci dal ciclo
        je veri
        sub AL, 30h

        mov BL, AL      ; Metto il numero su BL
        mov AL, op2
        mov DL, 10      
        mul DL          ; Moltiplico per 10 risultato ciclo precedente (x ospitare nuovo numero)
        mov op2, AL
        add op2, BL     ; Sommo il carattere inserito
        jmp input2

; --------------------------------------------------------
; Verifica selezione
; --------------------------------------------------------
        veri:
        cmp sel, 1      ; Se sel = 1 salta
        je addi
        cmp sel, 2      ; Se sel = 2 salta
        je sottra
        cmp sel, 3      ; Se sel = 3 salta
        je molt
        cmp sel, 4      ; Se sel = 4 salta
        je divi


; --------------------------------------------------------
; Addizione
; --------------------------------------------------------
        addi:
        mov BL, op1
        mov BH, op2
        add BL, BH
        jmp risu

; --------------------------------------------------------
; Sottrazione
; --------------------------------------------------------
        sottra:
        mov BL, op1
        mov BH, op2
        sub BL, BH
        jmp risu

; --------------------------------------------------------
; Moltiplicazione
; --------------------------------------------------------
        molt:
        mov AL, op1
        mul op2
        mov BL, AL      ; Metto il risultato su BL
        jmp risu

; --------------------------------------------------------
; Salto intermedio
; --------------------------------------------------------
        inizioo:
        jmp inizio
        stopp:
        jmp stop

; --------------------------------------------------------
; Divisione
; --------------------------------------------------------
        divi:
        mov AH, 0
        mov AL, op1
        div op2
        mov BL, AL      ; Metto il risultato su BL e BH
        mov BH, AH

; --------------------------------------------------------
; Stampa messaggio x il risultato
; --------------------------------------------------------
        risu:
        mov DX, OFFSET out1
        mov AH, 09h
        int 21h

; --------------------------------------------------------
; Output risultato
; --------------------------------------------------------
        mov DH, 100
        mov AL, BL
        mov AH, 0
        div DH          ; Divido per 100 (Terza cifra da destra)
        mov BL, AH      ; Metto il resto su BL
        mov DL, AL
        cmp DL, 0       ; Se 0 non stampare
        je n2
        add DL, 30h
        mov AH, 02h     ; Stampo primo numero
        int 21h

        n2:
        mov DH, 10
        mov AL, BL
        mov AH, 0
        div DH          ; Divido per 10 (Seconda cifra da destra)
        mov BL, AH      ; Metto il resto su BL
        mov DL, AL
        cmp DL, 0       ; Se 0 non stampare
        je n3
        add DL, 30h
        mov AH, 02h     ; Stampo secondo numero
        int 21h

        n3:
        add BL, 30h
        mov DL, BL
        mov AH, 02h     ; Stampo terzo numero
        int 21h
        
        cmp sel, 4
        jne inizioo

; --------------------------------------------------------
; Output resto
; --------------------------------------------------------
        mov DX, OFFSET out3
        mov AH, 09h
        int 21h
        
        mov DH, 100
        mov AL, BH
        mov AH, 0
        div DH          ; Divido per 100 (Terza cifra da destra)
        mov BL, AH      ; Metto il resto su BL
        mov DL, AL
        cmp DL, 0       ; Se 0 non stampare
        je rn2
        add DL, 30h
        mov AH, 02h     ; Stampo primo numero
        int 21h

        rn2:
        mov DH, 10
        mov AL, BL
        mov AH, 0
        div DH          ; Divido per 10 (Seconda cifra da destra)
        mov BL, AH      ; Metto il resto su BL
        mov DL, AL
        cmp DL, 0       ; Se 0 non stampare
        je rn3
        add DL, 30h
        mov AH, 02h     ; Stampo secondo numero
        int 21h

        rn3:
        add BL, 30h
        mov DL, BL
        mov AH, 02h     ; Stampo terzo numero
        int 21h
        jmp inizioo



; --------------------------------------------------------
; Servizio DOS chiusura programma
; --------------------------------------------------------
        stop:
        mov AH, 4Ch
        int 21h
END