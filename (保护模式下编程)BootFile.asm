;������������Ļ�����ӡһ���ַ���

org 07c00h	;ָ������ʼ��ַ��07c00h,������ԭ�� ��00000
;int ���ָ��	int 10h
	mov ax,cs
	mov es,ax
	mov bp,msgstr	;es:bpָ������ݾ�������Ҫ��ʾ���ַ�����ַ�
	
	mov cx,12	;�ַ�������
	mov dh,12	;��ʾ��ʼ�к�
	mov dl,36	;��ʾ���к�
	mov bh,0	;��ʾ��ҳ�����ڵ�0ҳ��ʾ
	mov al,1	;���ṹ
	mov bl,0c	;�ڵ׺���
	
	msgstr: db "hello my os"
	int 10h		;BIOS�ж�
	times 510-($-$$) db 0 ;�ظ�N��ÿ�����ֵΪ0
	;��ΪBIOS�ĵ�һ��������512�ֽڣ���������ֽ���55AAʱ����������������
	dw 55aaH
	jmp $	;Ϊ�˲��ó������������һ����ѭ����������ת����ǰλ�ã
	
;��Linux����ϵͳ�£���nasm ���б��룬���# nasm boot.asm -o boot.bin
;�� ndisasm boot.bin ���Խ��з�����
