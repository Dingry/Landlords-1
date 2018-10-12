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

;	Discard PROTO,my_player:PTR Player;����
;	Passcard PROTO,my_player:PTR Player;����

;-----------------------------------------------------
Discard PROC,
	my_player:PTR Player	;�������ã���ҵ�ַ
; ��������:���ƣ�û��UI֮ǰ��ʹ�����������룬'#'Ϊ���ƣ�'p'Ϊ���ƣ�
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL input:BYTE
	pushad
	
	mov esi,my_player
	.while 1
		call ReadChar
		.if al == '#'|| al == 'p'
			.break
		.elseif al == '+'
			call ReadDec
			mov input,al
			invoke DelCard,my_player,input
			lea ebx,(Player PTR [esi]).cards_to_show
			invoke AddNumber,ebx,input		
			.continue
		.elseif al == '-'
			call ReadDec
			mov input,al
			invoke AddCard,my_player,input
			lea ebx,(Player PTR [esi]).cards_to_show
			invoke DeleteNumber,ebx,input
			.continue
		.endif
	.endw

	.if al != 'p'
		mov (Player PTR [esi]).to_pass,0
		lea eax,(Player PTR [esi]).cards_to_show
		mov edi,eax
		lea ebx,(Player PTR [esi]).cards_showed
		cardgroup_equal (CardGroup PTR [ebx]),(CardGroup PTR [eax])
		invoke Clear,edi
	.else
		invoke Passcard,my_player
	.endif

	popad
	ret
Discard ENDP

;-----------------------------------------------------
Passcard PROC,
	my_player:PTR Player	;�������ã���ҵ�ַ
; ��������:���ƣ�û��UI֮ǰ��ʹ�����������룩
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad
	
	mov esi,my_player
	lea eax,(Player PTR [esi]).cards_to_show
	lea edi,(CardGroup PTR [eax]).cards
	mov cl,0
	.while cl<54
		mov al,[edi]
		.if al==1
			invoke AddCard,my_player,cl
			lea ebx,(Player PTR [esi]).cards_to_show
			invoke DeleteNumber,ebx,cl	
		.endif
		inc edi
		inc cl
	.endw

	mov (Player PTR [esi]).to_pass,1
	lea edi,(Player PTR [esi]).cards_to_show
	invoke Clear,edi
	lea edi,(Player PTR [esi]).cards_showed
	invoke Clear,edi

	popad
	ret
Passcard ENDP

END