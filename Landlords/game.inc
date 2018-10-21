; #########################################################################

	;=================
	; include files
	;=================
	;�ڴ˴����������ļ�
	include player.inc
	include cards.inc

; #########################################################################

	;=============
    ; Local structures
    ;=============
	;�ڴ˴����ӽṹ��
	GamePack STRUCT;714BYTE
		now_player BYTE 0;���ڵ���Ϸ��ұ��
		status BYTE 0;��Ϸ����
		all_cards BYTE 54 DUP(0);������
		all_cards_remain BYTE 54;ʣ������
		landlord_cards BYTE 3 DUP(0);������
		all_players Player 3 DUP(<>);���������Ϣ
	GamePack ENDS

	;=================
    ; Local prototypes
    ;=================
	;�ڴ˴����Ӻ���
    GameStart PROTO,gamePtr:PTR GamePack;��Ϸ��ʼ��ʼ��
	SendCard PROTO,gamePtr:PTR GamePack;����
	SetLandlord PROTO,gamePtr:PTR GamePack;���õ���
	SendLandlordCard PROTO,gamePtr:PTR GamePack;��������
	GamePlaying PROTO,gamePtr:PTR GamePack;��Ϸ������
	GameOver PROTO,gamePtr:PTR GamePack;��Ϸ����

; #########################################################################

    .data
		;�ڴ˴����ӱ���

        ;��Ϸ״̬
		game_NoStart = 0;δ��ʼ
		game_GetLandlord= 1;�е����׶�
		game_SendLandlordCard = 2;�������ƽ׶�
		game_Discard = 3;���ƽ׶�
		game_GameOver = 4;��Ϸ����	

; #########################################################################