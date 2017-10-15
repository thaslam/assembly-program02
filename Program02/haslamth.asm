TITLE FIBONACCI GENERATOR     (haslamth.asm)            
;EC: Program displays aligned columns.

; Author: Tom Haslam
; CS271 / Project #1                 Date: 10/1/2017
; Description: Project instruction user to enter two numbers and displays sum, diff, product, and quotient with remainder

INCLUDE Irvine32.inc

; (insert constant definitions here)
    max_terms           EQU         46                                              ;store maximum number of fib terms
    min_terms           EQU         1                                               ;store minimum number of fib terms
    ascii_tab           EQU         9                                               ;store ascii tab character
.data
    intro               BYTE        "FIBONACCI GENERATOR", 10, \
                                    "Tom Haslam", 10, \
                                    "**EC: Program displays output in aligned columns", \
                                    10, 0                                           ; store intro text
                                    ;store author and title
    terminate_1         BYTE        "Good Bye!, press any key to exit.", 0          ;store exit message
    username_instructs  BYTE        "Enter your username: ", 0                      ;instructions to enter username
    username            BYTE 64     DUP(0)                                          ;username input buffer
    greeting_prefix     BYTE        "Hello, ", 0                                    ;greeting prefix
    greeting_suffix     BYTE        "!" ,0                                          ;greeting suffix
    instructions        BYTE        "Enter the number of Fibonacci terms to be ", \
                                    "displayed. ", 10, "Give the number as an ", \
                                    "integer in the range [1..46]. ", 0             ;store instructions for input number
    
    term_count          DWORD       ?                                               ;store number of fibonacci terms
    term_counter        DWORD       0                                               ;store count of terms generated
    terms_per_line      DWORD       5                                               ;store number of terms to display per line
    invalid_term_low    BYTE        "!Term count below acceptable range.", 0        ;store invalid terms count message
    invalid_term_high   BYTE        "!Term count above acceptable range.", 0        ;store invalid terms count message

    last_fib            DWORD       1                                               ;store prior fib number in sequence
    curr_fib            DWORD       0                                               ;store current fib number in sequence

    column_padding      BYTE 12     DUP(" "), 0                                     ;store max padding between output columns
    ptr_padding         DWORD       column_padding                                  ;pointer to column padding array
    ptr_padding_max     DWORD       column_padding + 9                              ;store max padding offset
    column_decimal      DWORD       10                                              ;store decimal place
    column_decimal_mul  WORD        10
    column_position     DWORD       1                                               ;store col position current fib
.code
main PROC

; display title and programmers name
    mov     edx, OFFSET intro
    call    WriteString
    call    CrLf

; get user name and display instructions
    mov     edx, OFFSET username_instructs
    call    WriteString
    mov     edx, OFFSET username
    mov     ecx, SIZEOF username
    call    ReadString
    call    CrLf
    mov     edx, OFFSET greeting_prefix
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    mov     edx, OFFSET greeting_suffix
    call    WriteString

; get integer of fibonacci integers
ReadTermCount:
    call    CrLf
    call    CrLf
    mov     edx, OFFSET instructions
    call    WriteString
    call	ReadInt
    cmp     eax, max_terms
    jg      DisplayInvalidAboveMax
    cmp     eax, min_terms
    jl      DisplayInvalidBelowMin
    mov		term_count, eax
    jmp     Calculate

; display invalid input error messages
DisplayInvalidBelowMin:
    mov     edx, OFFSET invalid_term_low
    call    WriteString
    jmp     ReadTermCount

DisplayInvalidAboveMax:
    mov     edx, OFFSET invalid_term_high
    call    WriteString
    jmp     ReadTermCount

Calculate:
    call    CrLf
    mov     ecx, term_count         ;initialize ecx loop counter with number of terms entered by user
    
NextTerm:
; use a loop counter so we can put a line break in every five terms
    inc     term_counter
        
; calculate newterm
    mov     eax, last_fib
    add     eax, curr_fib
    mov     ebx, curr_fib
    mov     last_fib, ebx
    mov     curr_fib, eax
    call    WriteDec

; put this into a proc because loop jmp was too big and better organized
    call    WritePadding

; check modulo to determine if we need to start a new line
    mov     edx, 0
    mov     eax, term_counter
    div     terms_per_line
    cmp     edx, 0
    jne     Continue
    call    CrLf
Continue:
    loop    NextTerm

; exit program but wait for user to press any key
ExitProgram:
    call    CrLf
    call    CrLf
    mov     edx, OFFSET terminate_1
    call    WriteString
    call	ReadChar
	exit	; exit to operating system

main ENDP

; Procedure to write evenly spaced padding between columns
; I don't like that this procedure relies on so many globals
WritePadding PROC
; NOTE: if column_decimal exceeded a 32bit integer this logic would break
    mov     edx, 0
    mov     eax, curr_fib
    div     column_decimal
    cmp     eax, 1
    jne     PrintPadding

; update decimal positions
     mov     eax, column_decimal
     mov     ebx, 10
     mul     ebx
     mov     column_decimal, eax
     inc     ptr_padding

; write out padding between terms
PrintPadding:
     mov     edx, ptr_padding
     call    WriteString
     ret
WritePadding ENDP

END main
