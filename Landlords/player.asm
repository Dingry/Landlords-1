; #########################################################################
; �ļ���
;	player.asm
;
; ���ܣ�
;	ģ����Ҳ�������
;
; ���ߣ�
;	�̼���
;
; �޸���ʷ��
;	�޸���	�޸�ʱ��	�޸�����
;	-------	-----------	-------------------------------
;	�̼���	2018/10/10	����
;
; #########################################################################

TITLE Player (player.asm)

include irvine32.inc
includelib irvine32.lib

include player.inc

.code

;-----------------------------------------------------
NewPlayer PROC,
	my_player:PTR Player	;�������ã���ҵ�ַ
; ��������:��ʼ���������
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad
	mov edi,my_player

	mov (Player PTR [edi]).player_position,0
	mov (Player PTR [edi]).cards_num,0
	mov (Player PTR [edi]).to_pass,0

	mov esi,0
	.while esi<54
		mov (Player PTR [edi]).cards[esi],0
		inc esi
	.endw

	mov esi,0
	.while esi<15
		mov (Player PTR [edi]).card_group[esi],0
		inc esi
	.endw

	invoke Clear,addr (Player PTR [edi]).cards_to_show
	invoke Clear,addr (Player PTR [edi]).cards_showed
	popad
	ret
NewPlayer ENDP

;-----------------------------------------------------
AddCard PROC,
	my_player:PTR Player,	;�������ã���ҵ�ַ
	num:BYTE	;�������ã��������
; ��������:����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL result:BYTE
	pushad
	
	mov edi,my_player
	mov esi,0
	movzx eax,num
	add esi,eax
	mov (Player PTR [edi]).cards[esi],1

	invoke Translate,num,ADDR result
	mov esi,0
	movzx eax,result
	add esi,eax
	inc (Player PTR [edi]).card_group[esi]

	inc (Player PTR [edi]).cards_num

	popad
	ret
AddCard ENDP

;-----------------------------------------------------
DelCard PROC,
	my_player:PTR Player,	;�������ã���ҵ�ַ
	num:BYTE	;�������ã�ȥ������
; ��������:����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL result:BYTE
	pushad
	
	mov edi,my_player
	mov esi,0
	movzx eax,num
	add esi,eax

	mov bl,(Player PTR [edi]).cards[esi]
	.if bl==0
		ret
	.endif

	mov (Player PTR [edi]).cards[esi],0

	invoke Translate,num,ADDR result
	mov esi,0
	movzx eax,result
	add esi,eax
	dec (Player PTR [edi]).card_group[esi]

	dec (Player PTR [edi]).cards_num

	popad
	ret
DelCard ENDP

END