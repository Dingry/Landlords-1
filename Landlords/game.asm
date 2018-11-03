; #########################################################################
; �ļ���
;	game.asm
;
; ���ܣ�
;	������Ϸ�Ľ��й���
;
; #########################################################################

TITLE Game (game.asm)

include irvine32.inc
includelib irvine32.lib

include game.inc

.code

;-----------------------------------------------------
GameStart PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ��ʼ��ʼ��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	mov ecx,0
	lea edi,(GamePack PTR [esi]).all_players
	.while ecx<3
		invoke NewPlayer,edi
		add edi,TYPE Player
		inc ecx
	.endw
	invoke Cards,addr (GamePack PTR [esi]).all_cards,addr (GamePack PTR [esi]).all_cards_remain

	lea edi,(GamePack PTR [esi]).landlord_cards
	mov ecx,0
	.while ecx<3
		mov al,0
		mov [edi],al
		inc edi
		inc ecx
	.endw

	mov esi,gamePtr
	mov (GamePack PTR [esi]).status,game_SendCard

	popad
	ret
GameStart ENDP

;-----------------------------------------------------
SendCard PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL num:BYTE
	pushad

	mov esi,gamePtr
	mov al,(GamePack PTR [esi]).all_cards_remain
	.while al>3
		invoke GetCard,addr num,addr (GamePack PTR [esi]).all_cards_remain,addr (GamePack PTR [esi]).all_cards
		lea edi,(GamePack PTR [esi]).all_players
		invoke AddCard,edi,num

		invoke GetCard,addr num,addr (GamePack PTR [esi]).all_cards_remain,addr (GamePack PTR [esi]).all_cards
		add edi,TYPE Player
		invoke AddCard,edi,num

		invoke GetCard,addr num,addr (GamePack PTR [esi]).all_cards_remain,addr (GamePack PTR [esi]).all_cards
		add edi,TYPE Player
		invoke AddCard,edi,num

		mov al,(GamePack PTR [esi]).all_cards_remain
	.endw

	;�������ŵ�����
	lea edi,(GamePack PTR [esi]).landlord_cards
	mov ecx,0
	.while ecx<3
		invoke GetCard,addr num,addr (GamePack PTR [esi]).all_cards_remain,addr (GamePack PTR [esi]).all_cards
		mov al,num
		mov [edi],al
		inc edi
		inc ecx
	.endw

	mov (GamePack PTR [esi]).status,game_GetLandlord
	popad
	ret
SendCard ENDP

;-----------------------------------------------------
SetLandlord PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:���õ���
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	lea edi,(GamePack PTR [esi]).all_players
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
		lea edi,(GamePack PTR [esi]).all_players
		add edi,eax
		mov (Player PTR [edi]).player_position,1
	.else;��һ��Ը��е�������Ϊ����
		lea eax,(GamePack PTR [esi]).all_players
		mov esi,eax
		.while esi < ecx
			mov (Player PTR [esi]).player_position,0
			add esi,TYPE Player
		.endw
		mov (Player PTR [edi]).player_position,1
	.endif

	mov esi,gamePtr
	mov (GamePack PTR [esi]).status,game_SendLandlordCard

	popad
	ret
SetLandlord ENDP

;-----------------------------------------------------
SendLandlordCard PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:��������
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	lea edi,(GamePack PTR [esi]).all_players
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
			lea eax,(GamePack PTR [esi]).landlord_cards
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

	popad
	ret
SendLandlordCard ENDP

;-----------------------------------------------------
GamePlaying PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ���п���
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov esi,gamePtr
	lea edi,(GamePack PTR [esi]).all_players
	mov eax,TYPE Player
	mov bx,3
	mul bx
	add eax,edi

	;�ж��Ƿ��������������Ϊ0��
	.while edi < eax
		mov bl,(Player PTR [edi]).cards_num
		.if bl==0;������~
			mov (GamePack PTR [esi]).status,game_GameOver
			.break
		.endif
		add edi,TYPE Player
	.endw

	;û�н���������ҳ���
	mov bl,(GamePack PTR [esi]).status
	.if bl == game_SendLandlordCard
		mov (GamePack PTR [esi]).status,game_Discard
		lea edi,(GamePack PTR [esi]).all_players
		mov cl,0
		.while edi < eax
			mov bh,(Player PTR [edi]).player_position
			.if bh==1;�ǵ���
				mov (GamePack PTR [esi]).now_player,cl
				.break
			.endif
			add edi,TYPE Player
			inc cl
		.endw
	.elseif bl == game_Discard
		mov cl,(GamePack PTR [esi]).now_player
		inc cl
		.if cl==3
			mov cl,0
		.endif
		mov (GamePack PTR [esi]).now_player,cl
	.endif

	popad
	ret
GamePlaying ENDP

;-----------------------------------------------------
GameOver PROC,
	gamePtr:PTR GamePack	;�������ã���Ϸ���ݽṹָ��
; ��������:��Ϸ����
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	;���������"#"������Ϸ����
	mov al,'#'
	call WriteChar

	popad
	ret
GameOver ENDP

END