.386
.model flat, stdcall
includelib msvcrt.all
extern exit: proc
extern printf: proc
extern scanf: proc
extern sscanf: proc
extern strchr : proc
public start 
.data
expresie db 255 dup(?)
formatsir db "%s", 0
intreg db "%d",13,10, 0
formathexa db "%X",13,10, 0
formatcaracter db "%c",13,10, 0
sirverificare db "/*-+=", 0
formatnrsemn db "%x%c", 0
sirinmultire db "*/", 0
siradunare db "+-",0
lungime dd ?
sirnumere dd 200 dup (?) 
siroperatii db 200 dup(0)
nrnumere dd 0
nroperatii dd 0
suma dw 0
x dq ?
patru dd 4
adresa dd ?
numaraux dd 0
contor dd 0
caracteraux db 0
introducere db "Introduceti o expresie:",13,10,0
eroaremesaj db "Nu ati introdus o expresie buna!",13,10,0
.code
formaresiruri proc
	push ebp
	mov ebp, esp
	mov eax, 0
	mov eax, [lungime]
	push eax
	push offset intreg
	;call printf
	
	mov eax, 0
	mov contor, eax
	mov nroperatii, eax
	add esp, 8
	mov [adresa],eax
	xor edi,edi
	xor esi,esi 
	xor ebx,ebx
	lea eax,expresie
	mov adresa,eax	
	lea ebx,x
		L:
	
			;asa citesc cele 2 (nr,caracter)
			push offset caracteraux
			push offset numaraux;primul e nr citit
			push offset formatnrsemn
			push adresa
			call sscanf
			add esp, 16
			add contor,2 
			xor edx,edx
			mov dl,caracteraux ;in dl tin caracterul * / - +		
			mov eax,numaraux ;asa pun de fiecare data in sir numarul citit
			mov sirnumere[esi],eax
			add esi,4	
			push edx
			push adresa
			call strchr ;;asa caut de fiecare data daca mai avem ceva semn
			add esp,8  
			mov ebx, contor
			cmp ebx, lungime
			jg iesi
			inc nroperatii
			mov adresa,eax
			add adresa,1 ;asa trec peste semn si merg inapoi si citesc de la adresa adresa		
			mov dl,caracteraux
			mov siroperatii[edi],dl ;asa pun in sirul cu semne elementele	
			inc edi
			jmp L
		iesi:
			;push nroperatii
			;push offset intreg
			;call printf
			add esp,8
			xor edx,edx
			mov eax, nroperatii
			mul patru ;asa inmultesc cu cate 4 ca sa pot merge la fiecare gen sa stie acolo la comparatia aia,stii tu,ca esti desteptut
			xor esi,esi
			mov esi,eax
			xor edi,edi	
	afisarenumere:
		mov eax, sirnumere[edi]
		;push eax
		;push offset formathexa
		;call printf
		;add esp, 8
		add edi, 4
		cmp edi, esi
		je caractereafisare
		jmp afisarenumere
	caractereafisare:
		mov ebx, 0
		mov eax, nroperatii
		mov sirnumere[eax*4],ebx
		mov nrnumere, eax
		mov siroperatii[eax], bl
		;push nroperatii
		;push offset intreg
		;call printf
		;add esp, 8
		;push offset siroperatii
		;push offset formatsir
		;call printf
		;add esp,8
	mov eax, nroperatii
	dec eax
	mov nroperatii, eax
	mov eax, nrnumere
	dec eax
	mov nrnumere, eax
	mov esp, ebp
	pop ebp 
	ret 
formaresiruri endp
resetare proc
	push ebp
	mov ebp, esp
	mov esi, 0
	mov edi, 0
	mov eax, 0
	inceput:
		mov siroperatii[edi], al
		mov sirnumere[esi],eax
		inc edi
		add esi, 4
		cmp esi,400
		jl inceput
	mov esp, ebp
	pop ebp
	ret
resetare endp
citiresir proc
	push ebp
	mov ebp, esp
	push offset introducere
	call printf
	add esp , 4
	push offset expresie
	push offset formatsir
	call scanf
	add esp ,  8
	mov esp, ebp
	pop ebp
	ret 
citiresir endp
lungimesir proc
	push ebp
	mov ebp, esp
	mov ecx, 1000
	mov eax, 0
	my_loop:
		cmp expresie[eax], '='
		je afara
		inc eax
	loop my_loop
	afara:
	inc eax 
	mov lungime, eax
	mov esp, ebp
	pop ebp
	ret 
lungimesir endp
citirepanalaexit proc
	push ebp
	mov ebp, esp
	mov ecx, 1000
	mov eax, 0
	my_loop:
		eroare:
		call citiresir
		mov ebx, eax
		mov eax, 0
		cmp expresie[1], 'x'
		je afara
		cmp expresie[1], 'X'
		je afara
		cmp expresie[ebx],'='
		je eroare
		call lungimesir
		call formaresiruri
		call calculareexpresie
		call calculareexpresie1
	loop my_loop
	afara:
	mov esp, ebp
	pop ebp
	ret 
citirepanalaexit endp
adunare proc
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	add eax, ebx
	mov esp, ebp
	pop ebp
	ret
adunare endp
scadere proc
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	sub eax, ebx
	mov esp, ebp
	pop ebp
	ret
scadere endp
inmultire proc
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	mul ebx
	mov esp, ebp
	pop ebp
	ret
inmultire endp
impartire proc
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	div bl
	mov esp, ebp
	pop ebp
	ret
impartire endp
calculareexpresie proc
	push ebp
	mov ebp, esp
	mov esi, -1
	inceput:	
		inc esi
		mov edx, 0
		mov dl, byte ptr siroperatii[esi]
		mov edi, edx
		push edi
		push offset sirinmultire
		call strchr
		add esp, 8
		cmp eax, 0
		je verificarefinala
		cmp edi, '*'
		jne verificareimpartire
		mov eax, sirnumere[esi*4]
		inc esi
		mov ebx, sirnumere[esi*4]
		dec esi
		push ebx
		push eax
		call inmultire
		add esp, 8
		mov sirnumere[esi*4],eax
		
	mov ebx, esi
	mutaresir:
		inc ebx
		push edi
		mov edi, ebx
		inc edi
		mov eax, sirnumere[edi*4]
		mov sirnumere[ebx*4],eax
		dec edi
		mov ecx, 0
		mov cl, siroperatii[edi]
		dec ebx
		mov siroperatii[ebx],cl
		pop edi
		inc ebx
		cmp ebx, nrnumere
	jle mutaresir
	dec esi
	mov ebx, nrnumere
	dec ebx
	mov nrnumere, ebx
	mov nroperatii, ebx
	verificareimpartire:
		cmp edi, '/'
		jne verificarefinala
		mov eax, sirnumere[esi*4]
		inc esi
		mov ebx, sirnumere[esi*4]
		dec esi
		push ebx
		push eax
		call impartire
		add esp, 8
		mov sirnumere[esi*4],eax
	mov ebx, esi
	mutaresir1:
		inc ebx
		push edi
		mov edi, ebx
		inc edi
		mov eax, sirnumere[edi*4]
		mov sirnumere[ebx*4],eax
		dec edi
		mov ecx, 0
		mov cl, siroperatii[edi]
		dec ebx
		mov siroperatii[ebx],cl
		pop edi
		inc ebx
		cmp ebx, nrnumere
	jle mutaresir1
	dec esi
	mov ebx, nrnumere
	dec ebx
	mov nrnumere, ebx
	mov nroperatii, ebx
	cmp ebx, 0
	je afisare1
	jmp inceput
	verificarefinala:
	cmp siroperatii[esi],'='
	jne inceput
	afisare1:
	mov edi, -1
	afisare:
	inc edi
	mov eax, sirnumere[edi*4]

	cmp edi, nrnumere
	jl afisare
	mov esp, ebp
	pop ebp
	ret
calculareexpresie endp
calculareexpresie1 proc
	push ebp
	mov ebp, esp
	mov esi, -1
	inceput:	
		inc esi
		mov edx, 0
		mov dl, byte ptr siroperatii[esi]
		mov edi, edx
		push edi
		push offset siradunare
		call strchr
		add esp, 8
		cmp eax, 0
		je verificarefinala
		cmp edi, '+'
		jne verificarescadere
		mov eax, sirnumere[esi*4]
		inc esi
		mov ebx, sirnumere[esi*4]
		dec esi
		push ebx
		push eax
		call adunare
		add esp, 8
		mov sirnumere[esi*4],eax
		
	mov ebx, esi
	mutaresir:
		inc ebx
		push edi
		mov edi, ebx
		inc edi
		mov eax, sirnumere[edi*4]
		mov sirnumere[ebx*4],eax
		dec edi
		mov ecx, 0
		mov cl, siroperatii[edi]
		dec ebx
		mov siroperatii[ebx],cl
		pop edi
		inc ebx
		cmp ebx, nrnumere
	jle mutaresir
	dec esi
	mov ebx, nrnumere
	dec ebx
	mov nrnumere, ebx
	mov nroperatii, ebx
	verificarescadere:
		cmp edi, '-'
		jne verificarefinala
		mov eax, sirnumere[esi*4]
		inc esi
		mov ebx, sirnumere[esi*4]
		dec esi
		push ebx
		push eax
		call scadere
		add esp, 8
		mov sirnumere[esi*4],eax
	mov ebx, esi
	mutaresir1:
		inc ebx
		push edi
		mov edi, ebx
		inc edi
		mov eax, sirnumere[edi*4]
		mov sirnumere[ebx*4],eax
		dec edi
		mov ecx, 0
		mov cl, siroperatii[edi]
		dec ebx
		mov siroperatii[ebx],cl
		pop edi
		inc ebx
		cmp ebx, nrnumere
	jle mutaresir1
	dec esi
	mov ebx, nrnumere
	dec ebx
	mov nrnumere, ebx
	mov nroperatii, ebx
	cmp ebx, 0
	je afisare1
	jmp inceput
	verificarefinala:
	cmp siroperatii[esi],'='
	jne inceput
	afisare1:
	mov edi, -1
	afisare:
	inc edi
	mov eax, sirnumere[edi*4]
	push eax
	push offset formathexa
	call printf
	add esp, 8
	cmp edi, nrnumere
	jl afisare
	mov esp, ebp
	pop ebp
	ret
calculareexpresie1 endp
start: 
	call citirepanalaexit
	mov eax, 0
	call lungimesir
	mov [lungime],eax
	;push lungime 
	;push offset intreg
	;call printf
	;add esp, 8
	mov eax, 0
	mov ecx, 0
	push 0
	call exit
end start
	
	