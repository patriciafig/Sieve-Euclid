;=======================================================================;
;  CSCI 2525 - Assembly Language 			                                  ;
;  This program computes the prime numbers up to 1000         			    ;
;  and uses the recursive version of 		                                ;
;  Euclid's algorithm to find the greatest common divisor. 		          ; 
;																		                                    ;					
;  Euclid's Algorithm 				                                          ;
;  The recursive version of Euclid's algorithm  is based on the         ;
;  equality of the GCDs of successive remainders and the stopping       ;
;  condition gcd(rN−1, 0) = rN−1.                                       ;
;																		                                    ;
; function gcd(a, b)                                                    ;
;    if b = 0                                                           ;
;       return a;                                                       ;
;    else                                                               ;
;      return gcd(b, a mod b);                                          ;
;=======================================================================;


TITLE PA7.asm
INCLUDE Irvine32.inc  


ExitProcess proto,dwExitCode:dword
WriteString proto 
WriteDec proto
Crlf proto	

.code
 
	main PROC 
	;=================================================================================;
	; Description - runs the program     										  	                      ;
	; Recieves    - user input stored eax 											                      ;
	; Returns     - user input stored eax                                             ;
	;=================================================================================;   
.data 
	InvalidInput byte "Please try again, you made an invalid selection.", 0 
.code 
	mov eax, 0  
    mov ebx, 0
    mov ecx, 0
    mov edx, 0  
    mov esi, 0
	mov edi, 0
	
StartMenu: 
	call MainMenu             	 ;call MainMenu PROC 
	call ReadInt 
	
	cmp eax, 1				   	;EAX = 1 
	je SieveAlg
	cmp eax, 2 
	je EuclidAlg 
	cmp eax, 3 
	jz theEnd 
	jnz Error  
	
SieveAlg:
	call FindPrimes             ;FindPrimes PROC to find all primes from 2-1000 
	call Crlf
	jmp StartMenu

EuclidAlg:
	call TakeGCD
	call FindGCD
	call Crlf
	jmp StartMenu
	
Error:					 	      ;for error checking, user inputs invalid menu option 
	mov edx, OFFSET InvalidInput
	mov eax, lightRed        	  ;set console output to red
    call SetTextColor	
	call WriteString
	call Crlf
	jmp StartMenu

theEnd: 
	call Crlf
	call WaitMsg
	call Crlf
	INVOKE ExitProcess, 0     ; quit program 

exit 



main ENDP 
	
	MainMenu PROC 
	;=================================================================================;
	; Description - displays a menu that promps the user to select from the options	  ;
	; Recieves    - nothing															  ;
	; Returns     - user input stored eax                                             ;
	;=================================================================================;   
	
																										   
.data  
    UserSelect     byte  "    SELECT :  -->							 " , 0							
    MainMenuTitle  byte  " 	     .___  ___.  _______ .__   __.  __    __      		" , 0
                   byte  " 	     |   \/   | |  ____| |  \ |  | |  |  |  |     		" , 0
                   byte  " 	     |  \  /  | |  |__   |   \|  | |  |  |  |     		" , 0
                   byte  " 	     |  |\/|  | |   __|  |  . `  | |  |  |  |     		" , 0
                   byte  " 	     |  |  |  | |  |____ |  |\   | |  `--'  |     		" , 0
                   byte  " 	     |__|  |__| |_______||__| \__|  \______/      		" , 0 
				   byte  " 	======================================================	" , 0
	UserMsg0	   byte  "    Welcome! Please select from the following :           " , 0     
 	UserMsg1	   byte  "    1. Run the Sieve of Eratosthenes Algorithm		    " , 0 
	UserMsg2	   byte  "       2. Run Euclid's Algorithm to find the GCD of two numbers	" , 0                  
	UserMsg3	   byte  "			3. Quit	" , 0 
 .code 					     
	mov ecx, 7
	mov bl, 0
	mov eax, lightGreen
	call SetTextColor 
	call Crlf
printMenu1: 
	 mov edx, OFFSET MainMenuTitle	
	 mov eax, 0
	 mov al, LENGTHOF MainMenuTitle
	 mul bl							   
	
	 add edx, eax						
	 call WriteString
	 call Crlf
	 inc bl
	loop printMenu1
	
	call Crlf
	call Crlf
	
	mov ecx, 4
	mov bl, 0
	mov eax, lightCyan
	call SetTextColor
printMenu2: 
	mov edx, OFFSET UserMsg0	
	mov eax, 0
	mov al, LENGTHOF UserMsg0
	mul bl							
	
	add edx, eax						
	call WriteString
	call Crlf
	inc bl
	loop printMenu2
			
	call Crlf
	call Crlf	
	ret
	
	MainMenu ENDP
	


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Begin the Sieve of Eratosthenes to find all the  prime numbers in between 2 to 1000		
	

	;=================================================================================;	
	; Procedure fills an array with 1's if the position of the number isn't prime. 	  ;	
	; Implements the Sieve of Eratosthenes Algorithm								  ;
	; The remaining of the array is filled with 0 if the number is  prime. 			  ;	
	; Receives - nothing 															  ;		
	; Returns  - EDI and eax are at the start of the  array							  ;		
	; Requires - nothing															  ;		
	;=================================================================================; 		

	

FindPrimes PROC
.data
startNum word 2
currNum word 2
limit = 1000
primes byte limit dup(0) 			; 0 = not prime, 1 = prime

primeNum byte "The prime numbers up to 1000 are:  ", 0


.code
call Crlf
call EratosthenesTitle
call WriteString 

mov edx, OFFSET primeNum
call WriteString

mov eax, 0
mov ecx, 0
mov edx, 0
mov esi, OFFSET primes
L1:
	mov dx, currNum
	cmp dx, WORD PTR limit
	jg Finished
	mov cx, startNum
	L2:
		mov ax, currNum
		mov dx, 0
		div cx
		cmp dx, 0
		je L2Comp
		L2Comp2:
		mov dx, currNum
		cmp dx, startNum
		je makePrime
		mov dx, currNum
		dec dx
		cmp cx, dx
		je makePrime
		inc cx
	jmp L2
	L1End:
	add currNum, 1
	inc esi
jmp L1

L2Comp:
mov dx, currNum
cmp dx, startNum
jne L1End
jmp L2Comp2

makePrime:
mov edx, 1
mov [esi], edx
jmp L1End

Finished:
mov eax, 0
mov ecx, 2
mov esi, OFFSET primes
L3:
	cmp cx, limit
	je Printed
	mov al, BYTE PTR [esi]
	cmp al, 1
	je printPrime
	L3Alt:
	inc ecx
	inc esi
jmp L3

printPrime:
mov eax, ecx
call WriteDec
mov eax, ','
call WriteChar
jmp L3Alt
Printed:
call Crlf
call Crlf
call WaitMsg
ret
FindPrimes ENDP	


	EratosthenesTitle PROC 
	;=================================================================================;
	; displays title, called by FindPrimes PROC 
	;=================================================================================;
			
.data 
	
	SieveTitle  byte " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ " ,0
	            byte "                                _     ___                             _                           " ,0
	            byte "     ()                        | |   / (_)                           | |                          " ,0
	            byte "     /\ o   _        _     __  | |   \__   ,_    __, _|_  __   , _|_ | |     _   _  _    _   ,    " ,0
	            byte "    /  \|  |/  |  |_|/    /  \_|/    /    /  |  /  |  |  /  \_/ \_|  |/ \   |/  / |/ |  |/  / \_  " ,0
	            byte "   /(__/|_/|__/ \/  |__/  \__/ |__/  \___/   |_/\_/|_/|_/\__/  \/ |_/|   |_/|__/  |  |_/|__/ \/   " ,0
	            byte "                               |\                                                                 " ,0
	            byte "                               |/                                                                 " ,0
				byte "==================================================================================================" ,0
	
    .code 
    	call Clrscr
    	mov eax, lightMagenta        ; sets console output to light magenta 
    	call SetTextColor			 ; calls SetTextColor from Irvine library 
    	
    	mov ecx, 9                
    	mov bl , 0
        
    StartMenu:
    	mov edx, OFFSET SieveTitle 
    	mov eax, 0 
    	mov al, LENGTHOF SieveTitle 
    	mul bl 
    	
    	add edx, eax 
    	call WriteString
    	call Crlf 
    	inc bl
    	loop StartMenu 
    	call Crlf
    RET
    EratosthenesTitle ENDP 
	


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Begin Euclid's Algorithm to find the greatest commom divisor 



COMMENT ! 

	int GCD(int x, int y)
	{
	  x = abs(x);            // absolute value
	  y = abs(y);

	  do {
	    int n = x % y;
	    x = y;
	    y = n;
	  } while y > 0;

	  return y;
	} 
!


TakeGCD PROC
;=================================================================================;
;Function: take user input of the two numbers to compute GCD		  			  ;
;=================================================================================;	

.data

	promptOne byte "Please input an integer: ", 0		 	; will be used to prompt user for a integer
	promptTwo byte "Please input another integer: ", 0   	; will be used to prompt user for another integer
	message   byte "The greatest common divisor is: ", 0 	; will be used to prompt user before outputting the gcd
	

.code

	call PrintEuclidTitle
	call WriteString 
	mov eax, 0							; clears eax
	mov ebx, 0							; clears ebx
	mov bl, 0
	
	mov edx, offset promptOne			; used for WriteString
	call WriteString					; prompts user for a value
	call readInt						; takes user input, stores in eax
	mov bl, al							; moves user input to bl (first number)
	
	mov edx, offset promptTwo			; used for WriteString
	call WriteString					; prompts user for another value
	call readInt						; takes user input, stores in eax
	mov bh, al							; moves user input to bh (second number)
	
	
	call FindGCD						 ; takes values stored in bl and bh, returns greatest common divisor 
	mov edx, offset message				 ; used for WriteString
	call WriteString					 ; displays "The greatest common divisor is: " to screen
	call WriteInt						 ; displays greatest common divisor to screen
	call Crlf							 ; outputs new line
	call Crlf							 ; outputs new line
	
exit
TakeGCD ENDP



     PrintEuclidTitle PROC

 .data
 

 	EuclidTitle	 byte " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ " , 0
				 byte "      ___              _           o        ___,   _                         _                	 " , 0
				 byte "     / (_)            | | o     |  /       /   |  | |                 o     | |                   " , 0
				 byte "     \__          __  | |     __|    ,    |    |  | |  __,  __   ,_     _|_ | |     _  _  _       " , 0
				 byte "     /    |   |  /    |/  |  /  |   / \_  |    |  |/  /  | /  \_/  |  |  |  |/ \   / |/ |/ |      " , 0
				 byte "     \___/ \_/|_/\___/|__/|_/\_/|_/  \/    \__/\_/|__/\_/|/\__/    |_/|_/|_/|   |_/  |  |  |_/    " , 0
				 byte "                                                        /|                                        " , 0
				 byte "                                                        \|                                        " , 0
				 byte " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ " , 0                       

		                         
.code 
	call Clrscr
	mov eax, yellow        		; sets console output to yellow
	call SetTextColor			; calls SetTextColor from Irvine library 
	
	mov ecx, 10                
	mov bl , 0
    
EuclidMenu:
	mov edx, OFFSET EuclidTitle 
	mov eax, 0 
	mov al , LENGTHOF EuclidTitle 
	mul bl 
	
	add edx, eax 
	call WriteString
	call Crlf 
	inc bl
	loop EuclidMenu  

call Crlf
call Crlf 

RET
 PrintEuclidTitle ENDP 



	FindGCD PROC
	;-----------------------------------------------------------------------
	; Recieves: bl and bh store two integers
	; Returns: Greatest common divisor of bl and bh are stored in al
	;-----------------------------------------------------------------------

	mov eax, 0	       ; clears eax
	cmp bl,  0         ; compares first input to zero
	jl L2		       ; jumps to L2 if value is negative
                     
L1:                  
	cmp bh, 0          ; compares second input to zero
	jl L3		       ; jumps to L3 if value is negative
	jmp L4             ; jump to L4 if both values are positive
                     
L2:				       ; label if bl is negative
	neg bl		       ; makes bl positive (for absolute value)
	jmp L1		       ; jump back to L1
				       
L3:				       ; label if bh is negative
	neg bh		       ; makes bh positive (for absolute value)
                     
L4:                  
	                 
	mov al, bl	     	; bl will be dividend in DIV
	DIV bh		     	; divides bl by bh.
	mov bl, bh	     	; stores bh into bl
	mov bh, ah	     	; stores remainder from divison into bh
	mov ax, 0	     	; clears ax
                     
	cmp bh, 0	     	; compares bh (remainder from div) to zero
	jg L4		     	; jumps back to L4 until remainder from div <= zero
                     
                     
                     
	mov al , bl         ; stores gcd into al 
                     
ret			            ;return
FindGCD ENDP         



	END main	
	
	
