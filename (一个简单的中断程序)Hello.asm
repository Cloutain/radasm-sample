data segment
	msg db "hello world"
data ends

code segment
	assume cs:code,ds:data
main proc near
	start:	;��ȡ����ε�ƫ�Ƶ�ַ
	mov ax,data ;�����ݶδ浽ds����
	mov ds,ax

	mov bx,0b800h	;���Դ��ַ�ռ����ʼ��ַ�����������Ӷ���
	mov es,bx

	mov cx,11d
	mov si,0
	mov bx,0
	;---------��������----------
	;|  7   6 5 4   3   2 1 0  |
	;| B L  R G B   I   R G B  |
	;| ��˸ ����ɫ ���� ǰ��ɫ |
	;--------------------------
	mov ah,10100100b ;�̵׺���
	s:mov al,ds:[si] ;�����ַ�
	mov es:[bx],al
	mov es:[bx+1],ah ;�����ַ�����
	inc si
	add bx,2
	loop s

	mov ax,4c00h
	int 21h
	ret
main endp
code ends
	end start




