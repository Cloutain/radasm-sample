DATAS SEGMENT
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;ϵͳĬ�����ڴ�0000:000��0000:03FEר�Ŵ���ж�������
    ;��һ�������ж���������0�ű�������ݽ����޸ģ�
    ;ָ�������Լ�ָ�����жϴ���������ڵ�ַ
    mov ax,0
    mov ds,ax
    ;�ж�������ÿ������ռ�ĸ��ֽڣ����ֽڷ�ƫ�Ƶ�ַ�����ֽڷŶε�ַ
    mov word ptr ds:[0],0200h
    mov word ptr ds:[2],0
    
    ;�����������Լ�д��0���жϴ�����򿽱����ж���������0�ű���
    ;��ָ����ڴ��ַ��0000:0200
    ;���ó����Դ��ַ��Դ��ַ��DS:SI��ɣ�Ŀ�ĵ�ַ��ES:DI��� 
    mov ax,cs
    mov ds,ax
    mov si,offset int0	;�������ڵ�ַ����Դ��ַ��ds:si
    mov ax,0
    mov es,ax			;����Ŀ�ĵ�ַ
    mov di,200h
    mov cx,offset int0end-offset int0
    ;CLDָ���������ݿ��������Ǵӵ��ֽ�����ֽڣ�si,di�Զ�������STD�෴
    cld
    rep movsb
    ;���Ĳ������ô����Զ�����0���жϴ������
    mov ax,100h
    mov bh,1
    div bh	;����Ϊ1������������������жϣ������Լ�д���жϳ���
    
    
    ;�ڶ�������д�Լ����жϴ������ʵ������Ļ������ʾ�ַ����Ĺ���
    int0:jmp short int0start	;���д���ռ�����ֽ� 
    	db "I am student !"
    int0start:mov ax,0b800h
    mov es,ax	;�����Դ��׵�ַ
    ;Ҫ��"I am student !"һ���������Դ��ַ�ռ���
    mov ax,cs	;�Ѵ�����е������͵����ݶε���ȥ
    mov ds,ax	;0�жϳ���û���ִ���κ����ݶ�
    
    mov si,202h	;��jump short int0startռ���ֽ�
    mov di,12*160+36*2	
    ;һ����Ļ�����24�С�80�У�ÿ��80���֣�36������ƫ��һ�� 
    
    mov cx,14	;"I am student !" ��14���ֽ�
    
	;---------��������----------
	;|  7   6 5 4   3   2 1 0  |
	;| B L  R G B   I   R G B  |
	;| ��˸ ����ɫ ���� ǰ��ɫ |
	;---------------------------
  	mov ah,10100100b ;�̵׺���
  s:mov al,byte ptr ds:[si]	;����һ���ַ��浽al��
  	mov es:[di],al	;�����ַ�
  	mov es:[di+1],ah ;�����ַ�����
  	inc si		;Դ��ַָ�����1���ַ�
  	add di,2	;�Դ��ַ��2�ֽ�
  	loop s
       
    MOV AH,4CH
    INT 21H
  int0end:nop  ;nop�ǿղ���ָ�ռһ���ֽ�
  
CODES ENDS
    END START






