;1.
;===========================================================
;�ڱ���ģʽ��32λCPU��Ȼ������20λ��ַ��ʵ��32λ��ַ��Ѱַ
;16λCPU: 16λ�μĴ���+16λƫ�Ƶ�ַ (����ַ�ӷ���) -> 20λ�����ڴ��ַ
;32λCPU: 32λ��ַ���ڴ����Ϣ������һ���ڴ���У�ֻ�轫�����������16�Ĵ������м���
;������������ĶμĴ�����Ϊ����ѡ����
;����ÿ����ʾ32λ�ڴ����Ϣ��Ϊ�����������������˶εĵ�ַ�Ͷεĳ��ȣ���	
;���ű��Ϊ������������
;��ѡ����16λ�����и�13λ������ʾ���������е����������3λ�ñ�ʾ������������ָ��Ķ�������������
;


;������������Ļ�����ӡһ���ַ���
[BITS 16]
org 07c00h	;ָ������ʼ��ַ��07c00h,������ԭ�� ��00000
;int ���ָ��	int 10h
jmp main

gdt_table_start:	;���߱���������������ʼ
	;Intel�涨��������ĵ�һ�������������ǿ�������
	gdt_null:
		dd 0h
		dd 0h	;Intel�涨����������ĵ�һ���������Ϊ0
	gdt_data_addr	equ	$-gdt_table_start	;���ݶεĿ�ʼλ��
	gdt_data��	;���ݶ�������
		dw 07ffh ;�ν���
		dw 0h	;�λ���ַ18λ
		db 10010010b	;���������ĵ������ֽ����ԣ����ݶΣ�
		db 1100000b	;���������ĵ��߸��ֽ�����
		db 0	;�������������һ���ֽ�Ҳ���Ƕλ���ַ
	
	gdt_video_addr equ $-gdt_table_start
	gdt_video:	;���������Դ��ַ�ռ�Ķ�������
		dw	0FFH	;�Դ�ν��޾���1M
		dw	8000H
		db	0BH
		db	10010010b
		db	11000000b
		db	0
	
	gdt_code_addr	equ	$-gdt_table_start	;����εĿ�ʼλ��
	gdt_code:
		dw 07ff	;�ν���
		dw 1h	;�λ���ַ0~18λ
		db 80h	;�λ���ַ19~23λ
		db 10011010b	;���������ĵ������ֽڣ�����Σ�
		db 11000000b	;���������ĵ��߸��ֽ�
		db 0			;�λ���ַ�ĵڶ�����
gdt_table_end:
		
		
;ͨ��lgdtָ����԰�GDTR������Ĵ�С����ʼ��ַ����gdtr�Ĵ�����
gdtr_addr:
	dw gdt_table_end-gdt_table_start-1	;����������
	dd gdt_table_start	;�����������ַ
;lgdt [gdtr_addr]	;��CPU��ȡgdtr_addr��ָ���ڴ����ݱ��浽gdtr�Ĵ�������
;A20��ַ�ߣ��л�������ģʽʱ��A20��ַ�߱��뿪������ַ�������ã�����32λCPU��ַ�ߵĸ�12λ���
;�˿ڵĶ�д������
	;in	 accume port	;���˿ڵ����ݶ����Ĵ���AL��AX���У�����accumeֻ����AL��AX��
	;out port accume	;��accume�е�����д���˿��У�����accume�����������Ĵ���
	
;����A20��ַ��
main:
	;�޸����ݶ��������λ���ַ�йص��ֽڣ���ʼ�����ݶ��������Ļ���ַ
	xor eax,eax	;���eax
	add eax,data_32	;��32λ��ַ��Ϣ������eax��
	mov word [gdt_data+2],ax	;��ax�е����ݿ��������������ĵ�3��4�����ֽڵ��У�����word���͵Ŀ����
	shr eax,16	;����16λ
	mov byte [gdt_data+4],al	;����ǰeax�еĵ�5���ֽ��Ƶ�������������
	mov byte [gdt_data+7],ah	;����ǰeax�еĵ�8���ֽ��Ƶ�������������
	
	;�޸Ĵ�����������λ���ַ�йص��ֽڣ���ʼ�����ݶ��������Ļ���ַ
	xor eax,eax
	add eax,code_32
	mov word [gdt_code+2]
	shr eax,16
	mov byte [gdt_code+4],al
	mov byte [gdt_code+7],ah
	
	;��ת�ű���ģʽ֮ǰ������ϳ�ԭ�����ж���������cliָ����Էϳ�ʵģʽ�µ��ж�������
	cli
	lgdt [gdtr_addr]	;��CPU��ȡgdtr_addr��ָ���ڴ����ݱ��浽gdtr�Ĵ�������

	enable_a20:
		in al,92h	;ֻҪ��0x92�Ŷ˿���д����Ϣ�Ϳ��Կ���A20��ַ��
		or al,00000010b	;00000010��ʾ����A20��ַ�ߵ�����
		out 92h,al		;�����úõ�����д��0x92�Ŷ˿ڵ���
	
;ת�뱣��ģʽ,ֻҪ��CR0�Ĵ����ĵ�1λ(PEλ)��Ϊ1����
;80386�ṩ��4��32λ�Ŀ��ƼĴ���CR0~CR3������CR0�е�ĳЩλ��������־�Ƿ�Ҫ���뱣��ģʽ
;CR1�Ĵ�������û�б�ʹ��
;CR2��CR3���ڷ�ҳ����
;CR0��PEλ���Ʒֶι�����ƣ�PE=0,CPU������ʵģʽ��PE=1,CPU�����ڱ���ģʽ
;CR0��PGλ���Ʒֶι����,PG=0����ֹ��ҳ�������;PG=1�����÷�ҳ������ơ�
	mov eax,cr0
	or eax,1	;���ڰ�CR0�Ĵ����ĵ�1��Ϊ1
	mov cr0,eax	;��CR0�Ĵ����ĵ�1��Ϊ1
;��ת������ģʽ��
	jmp gdt_code_addr:0
	
;�ڱ���ģʽ�±��(����Ļ�����ӡhello world)
[BITS 32]
	data_32:
		db	"hello world"
	code_32:
		MOV ax,gdt_data_addr
		mov ds,ax
		mov ax,gdt_video_addr
		mov gs,ax
		mov cx,11
		mov edi,(80*10+12)*2	;����Ļ������ʾ
		mov bx,0
		mov ah,0ch
		s:mov al,[ds:bx]
		mov [gs:edi]
		mov [gs:edi+1],ah
		inc bx
		add edi,2
		loop s
		jmp $	;��ѭ��
		times 510-($-$$)	db 0
		dw 0aa55h
	
	
	
	
;ok !  ^_^  
;1.�������������nasm boot.asm -o boot.bin ����	
;2.�ѳ���д�����̾�����ȥ���ñ���õ�д���ļ�����д��: ./write_image boot.bin boot.img
;3.��boot.img���Ƶ��Լ���Bochs-2.4.6Ŀ¼�½����ļ����£����޸�run.bat
;-----------------------------------------------
;����write_image.c,������rad hat��vi�༭������д���
#include<stdio.h>
#include<fcnt.h>
#include<sys/types.h>
#include<sys/stat.h>

int main(int argc,char *argv[])
{
	int fd_source;
	int fd_dest;
	int read_count=0;
	char buffer[512]={0};
	fd_source=open("boot.bin",O_RDONLY);
	IF(fd_source<0)
	{
		perror("open boot.bin error");
		return 0;
	}
	fd_dest=open("virtual_floppy.vfd",O_WRONLY);
	while ((read_count=read(fd_source,buffer,512))>0)
	{
	write(fd_dest,buffer,read_count);
	memset(buffer,0,512);
	}
	printf("wrinte image OK !");
	return 0;
}
;�����write_image.c��Ȼ����룺gcc write_image.c -o write_image
;�����������������ߣ�����һ���������̣�ȡ��boot.img�����������������������д��boot.img
;  ^_^    ok!
;��������������Ļ���������bocsh������Բ���ϵͳ���е��ԡ�
;===================================================
;bocsh�ĵ��Թ���bocshdbg
;	continue(c) �����������ֱ�������ϵ�Ϊֹ
;	step(s)	��������
;	vbreak(vb)	�������ַ������һ���ϵ�
;	pbreak(b)	�������ַ������һ���ϵ�
;	lbreak(lb)	�����Ե�ַ������һ���ϵ�
;	disassemble	�����ָ��
;================================================================
;================================================================

;2.	һ������Ļ������ʾһ���ַ�����������(ʵģʽ��д)
;������������Ļ�����ӡһ���ַ���

org 07c00h	;ָ������ʼ��ַ��07c00h,������ԭ�� ��00000
;int ���ָ��	int 10h
	mov ax,cs
	mov es,ax
	mov bp,msgstr	;es:bpָ������ݾ�������Ҫ��ʾ���ַ�����ַ?
	
	mov cx,12	;�ַ�������
	mov dh,12	;��ʾ��ʼ�к�
	mov dl,36	;��ʾ���к�
	mov bh,0	;��ʾ��ҳ�����ڵ�0ҳ��ʾ
	mov al,1	;���ṹ
	mov bl,0c	;�ڵ׺���
	
	msgstr: db "hello my os"
	int 10h		;BIOS�ж�
	times 510-($-$$) db 0 ;�ظ�N��ÿ�����ֵΪ0
	;��ΪBIOS�ĵ�һ��������512�ֽڣ���������ֽ���55AAʱ����������������?
	dw 55aaH
	jmp $	;Ϊ�˲��ó������������һ����ѭ����������ת����ǰλ��?
	
;��Linux����ϵͳ�£���nasm ���б��룬���# nasm boot.asm -o boot.bin
;�� ndisasm boot.bin ���Խ��з�����

