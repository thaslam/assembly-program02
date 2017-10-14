TITLE Math Assistant     (haslamth.asm)            
;EC: Program verifies second number less than first.

; Author: Tom Haslam
; CS271 / Project #1                 Date: 10/1/2017
; Description: Project instruction user to enter two numbers and displays sum, diff, product, and quotient with remainder

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
    intro               BYTE    "FIBONACCI GENERATOR", 10, \
                                "Tom Haslam", 10, 0                ;store author and title
    terminate_1         BYTE    "Good Bye!, press any key to exit.", 0          ;store exit message
    username_instructs  BYTE    "Enter your username: ", 0                      ;instructions to enter username
    username            BYTE 64 DUP(0)                                          ;username input buffer
    greeting_prefix     BYTE    "Hello ", 0                                     ;greeting prefix
    greeting_suffix     BYTE    "!" ,0                                          ;greeting suffix
.code
main PROC

; display title and programmers name
mov     edx, OFFSET intro
call    WriteString
call    CrLf

; get users name
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

; exit program but wait for user to press any key
ExitProgram:
    call    CrLf
    mov     edx, OFFSET terminate_1
    call    WriteString
    call	ReadChar
	exit	; exit to operating system

main ENDP

END main
