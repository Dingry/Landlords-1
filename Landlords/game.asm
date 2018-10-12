; #########################################################################
; �ļ���
;	game.asm
;
; ���ܣ�
;	������Ϸ�Ľ��й���
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

TITLE Game (game.asm)

include irvine32.inc
includelib irvine32.lib

include game.inc

;	GamePlaying PROTO,gamePtr PTR Game;��Ϸ������
;	GameOver PROTO,gamePtr PTR Game;��Ϸ����
;
.code

;-----------------------------------------------------
GameStart PROC,
	gamePtr:PTR Game	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ��ʼ��ʼ��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	mov ecx,0
	lea edi,(Game PTR [esi]).all_players
	.while ecx<3
		invoke NewPlayer,edi
		add edi,TYPE Player
		inc ecx
	.endw
	invoke Cards,addr (Game PTR [esi]).all_cards,addr (Game PTR [esi]).all_cards_remain

	lea edi,(Game PTR [esi]).landlord_cards
	mov ecx,0
	.while ecx<3
		mov al,0
		mov [edi],al
		inc edi
		inc ecx
	.endw

	mov esi,gamePtr
	mov (Game PTR [esi]).status,game_GetLandlord

	popad
	ret
GameStart ENDP

;-----------------------------------------------------
SendCard PROC,
	gamePtr:PTR Game	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL num:BYTE
	pushad

	mov esi,gamePtr
	mov al,(Game PTR [esi]).all_cards_remain
	.while al>3
		invoke GetCard,addr num,addr (Game PTR [esi]).all_cards_remain,addr (Game PTR [esi]).all_cards
		lea edi,(Game PTR [esi]).all_players
		invoke AddCard,edi,num

		invoke GetCard,addr num,addr (Game PTR [esi]).all_cards_remain,addr (Game PTR [esi]).all_cards
		add edi,TYPE Player
		invoke AddCard,edi,num

		invoke GetCard,addr num,addr (Game PTR [esi]).all_cards_remain,addr (Game PTR [esi]).all_cards
		add edi,TYPE Player
		invoke AddCard,edi,num

		mov al,(Game PTR [esi]).all_cards_remain
	.endw

	;�������ŵ�����
	lea edi,(Game PTR [esi]).landlord_cards
	mov ecx,0
	.while ecx<3
		invoke GetCard,addr num,addr (Game PTR [esi]).all_cards_remain,addr (Game PTR [esi]).all_cards
		mov al,num
		mov [edi],al
		inc edi
		inc ecx
	.endw

	popad
	ret
SendCard ENDP

;-----------------------------------------------------
SetLandlord PROC,
	gamePtr:PTR Game	;�������ã���Ϸ���ݽṹָ��
; ��������:���õ���
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	lea edi,(Game PTR [esi]).all_players
	mov eax,TYPE Player
	mov bx,3
	mul bx
	add eax,edi
	mov ecx,eax

	.while edi < eax
		mov bl,(Player PTR [edi]).player_position
		.if bl==1
			.break
		.endif
		add edi,TYPE Player
	.endw

	.if edi == eax;û����Ը�⵱���������һ������
		mov eax,3
		call Randomize
		call RandomRange
		mov bx,TYPE Player
		mul bx
		lea edi,(Game PTR [esi]).all_players
		add edi,eax
		mov (Player PTR [edi]).player_position,1
	.else;��һ��Ը��е�������Ϊ����
		lea eax,(Game PTR [esi]).all_players
		mov esi,eax
		.while esi < ecx
			mov (Player PTR [esi]).player_position,0
			add esi,TYPE Player
		.endw
		mov (Player PTR [edi]).player_position,1
	.endif

	mov esi,gamePtr
	mov (Game PTR [esi]).status,game_SendLandlordCard

	popad
	ret
SetLandlord ENDP

;-----------------------------------------------------
SendLandlordCard PROC,
	gamePtr:PTR Game	;�������ã���Ϸ���ݽṹָ��
; ��������:��������
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	lea edi,(Game PTR [esi]).all_players
	mov eax,TYPE Player
	mov bx,3
	mul bx
	add eax,edi

	.while edi < eax
		mov bl,(Player PTR [edi]).player_position
		.if bl==1;�ǵ�������������
			pushad
			mov ecx,0
			mov esi,gamePtr
			lea eax,(Game PTR [esi]).landlord_cards
			mov esi,eax
			.while ecx < 3
				mov al,[esi]
				invoke AddCard,edi,al
				inc ecx
				inc esi
			.endw
			popad
			.break
		.endif
		add edi,TYPE Player
	.endw

	mov esi,gamePtr
	mov (Game PTR [esi]).status,game_Discard

	popad
	ret
SendLandlordCard ENDP

END