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
    ;��0�ж�
    mov ax,1000h  	;ax����������
    mov bh,1		;bx����
    div bh			;��AX��16λ��bhΪ1���������16λ�����������������
    ;����Ϊ8λʱ���������洢��AX�������AL�洢�������̣�AH�洢����������
    ;����Ϊ16λʱ���������洢��DX+AX�У������AX�洢�̣�DX�洢����
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
