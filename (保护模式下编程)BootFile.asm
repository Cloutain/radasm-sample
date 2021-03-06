;启动程序在屏幕中央打印一行字符串

org 07c00h	;指明程序开始地址是07c00h,而不是原来 的00000
;int 汇编指令	int 10h
	mov ax,cs
	mov es,ax
	mov bp,msgstr	;es:bp指向的内容就是我们要显示的字符串地址�
	
	mov cx,12	;字符串长度
	mov dh,12	;显示起始行号
	mov dl,36	;显示的列号
	mov bh,0	;显示的页数，在第0页显示
	mov al,1	;串结构
	mov bl,0c	;黑底红字
	
	msgstr: db "hello my os"
	int 10h		;BIOS中断
	times 510-($-$$) db 0 ;重复N次每次填充值为0
	;因为BIOS的第一个扇区是512字节，当最后两字节是55AA时，它就是引导程序�
	dw 55aaH
	jmp $	;为了不让程序结束，设置一个死循环，不断跳转到当前位置�
	
;在Linux操作系统下，用nasm 进行编译，命令：# nasm boot.asm -o boot.bin
;用 ndisasm boot.bin 可以进行反编译
