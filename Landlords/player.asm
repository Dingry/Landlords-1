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

include player.inc

.code

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