; #########################################################################
; �ļ���
;	cards.asm
;
; ���ܣ�
;	ģ��һ���˿��Լ���������
;
; ���ߣ�
;	�̼���
;
; �޸���ʷ��
;	�޸���	�޸�ʱ��	�޸�����
;	-------	-----------	-------------------------------
;	�̼���	2018/10/09	����
;
; #########################################################################

TITLE Cards (cards.asm)


include irvine32.inc
includelib irvine32.lib

include cards.inc


;cards_cards BYTE 54 DUP(0);������
;cards_remain BYTE 54;ʣ������

.code

;-----------------------------------------------------
Cards PROC,
	my_cards:PTR BYTE,	;�������ã������ַ
	my_remain:PTR BYTE	;�������ã�ʣ����������ַ
; ��������:��ʼ������
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad
	
	mov esi,my_cards
	mov al,0
	.while al<54
		mov [esi],al
		inc esi
		inc al
	.endw

	invoke RandCards,my_cards,my_remain

	popad
	ret
Cards ENDP

;-----------------------------------------------------
RandCards PROC,
	my_cards:PTR BYTE,	;�������ã������ַ
	my_remain:PTR BYTE	;�������ã�ʣ����������ַ
; ��������:���ϴ��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad
	
	mov esi,my_cards
	mov ebx,0
	.while ebx<54
		mov edi,my_cards
		mov eax,54
		call RandomRange
		add edi,eax
		
		mov al,[edi]
		xchg al,[esi]
		mov [edi],al

		inc esi
		inc ebx
	.endw

	mov esi,my_remain
	mov al,54
	mov [esi],al

	popad
	ret
RandCards ENDP

;-----------------------------------------------------
GetCard PROC,
	result:PTR BYTE,	;�������ã���������
	my_remain:PTR BYTE,	;�������ã�ʣ����������ַ
	my_cards:PTR BYTE	;�������ã������ַ
; ��������:����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,result
	mov edi,my_remain
	mov bl,[edi]

	.if bl == 0
		ret
	.endif

	dec bl
	mov [edi],bl
	movzx eax,bl
	
	mov edi,my_cards
	add edi,eax
	mov al,[edi]
	mov [esi],al
	
	popad
	ret
GetCard ENDP

END