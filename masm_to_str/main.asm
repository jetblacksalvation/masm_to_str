includelib kernel32.lib
includelib msvcrt.lib

ExitProcess  proto	

GetStdHandle proto
WriteFile proto	
ReadFile proto	


.data 


hStdIn dq	? 
hStdOut dq	?

msg db "give me a number","...", 10


in_len dq	 0
in_buffer db 100 dup(?);100 * db len


.code	

str_len proc
	;mov	 rdi, rdx	; copy address of rdx ->rdi; i dont want to fuck up the pointer in rdx
	mov rdi, rcx	
	xor rax, rax	

	start:


		cmp qword ptr [rdi], 13; this is how you deref an address :) geez :) 
		jz	_end; jump when null terminator
		cmp qword ptr [rdi], 10
		jz _end
		cmp qword ptr [rdi], 0;cases for other escape seq
		jz _end

		add rdi,1
		inc	rax
	;jump to start if value is zero
	jmp start
	_end:
	ret	
str_len endp	


main proc
	sub rsp, 28h        ; space for 4 arguments + 16byte aligned stack
	;-------getting handles ---
	;----stdin
	mov rcx, -11
	call GetStdHandle
	mov [hStdOut], rax; DWORD hStdOut = GetStdHandle(-11);
	;-----stdout
	mov rcx, -10
	call GetStdHandle
	mov [hStdIn], rax;DWORD hStdIn = GetStdHandle(-10);

	add rsp, 28h
	;-------end getting handles 
	sub rsp, 28h
	;-------end getting handles 


	
	mov rcx, hStdOut
	mov rdx, offset msg
	mov r8, 20
	call WriteFile
	add rsp, 28h
	;end msg
	sub	rsp, 28h
	mov rcx, hStdIn
	mov rdx, offset in_buffer
	mov r8, 100
	call ReadFile 		
	add rsp, 28h	
	; call strlen 
	mov	 rcx, offset in_buffer
	call str_len	
	mov in_len, rax

	call ExitProcess
	ret	
main endp	

end