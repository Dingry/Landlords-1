.386
.model  flat, stdcall

; #########################################################################

	;=============
    ; Local structures
    ;=============
	;�ڴ˴����ӽṹ��
	CardGroup STRUCT;72BYTE
		group_type BYTE 0;��������
		value BYTE 0;//Ȩֵ
		count BYTE 0;//�˽ṹԪ������
		cards BYTE 54 DUP(0);0-53�Ƶļ���
		card_group BYTE 15 DUP(0);0-14��Ȩֵ����
	CardGroup ENDS


	;=================
    ; Local prototypes
    ;=================
	;�ڴ˴����Ӻ���
	AddNumber PROTO,_group:PTR CardGroup,num:BYTE;����0-53��ʾ����Ԫ��
	DeleteNumber PROTO,_group:PTR CardGroup,num:BYTE;ȥ��һ����
	Clear PROTO,_group:PTR CardGroup;//���ô˽ṹ
	Translate PROTO,num:BYTE,result:PTR BYTE;��0-53ת����0-14Ȩֵ������A��11����2��12����С����13����������14��


    ;=============
    ; Local macros
    ;=============
	;�ڴ˴����Ӻ궨��
	bequal MACRO val1:REQ,val2:REQ ;��ֵBYTEֵ
		push ax
		mov al,val2
		mov val1,al
		pop ax
	ENDM

	wequal MACRO val1:REQ,val2:REQ ;��ֵWORDֵ
		push ax
		mov ax,val2
		mov val1,ax
		pop ax
	ENDM		

	cardgroup_equal MACRO group1:REQ,group2:REQ ;��ֵ����
		push esi
		bequal group1.group_type,group2.group_type
		bequal group1.value,group2.value
		bequal group1.count,group2.count

		mov esi,0
		.while esi<54
			bequal group1.cards[esi],group2.cards[esi]
			inc esi
		.endw

		mov esi,0
		.while esi<15
			bequal group1.card_group[esi],group2.card_group[esi]
			inc esi
		.endw
		pop esi

	ENDM	

; #########################################################################

    .data
		;�ڴ˴����ӱ���

        ;һ���ƵĿ�������
		cardgroup_Unkown = 0;δ֪
		cardgroup_Single = 1;����
		cardgroup_Double = 2;����
		cardgroup_Three = 3;����
		cardgroup_SingleSeq = 4;��˳
		cardgroup_DoubleSeq = 5;˫˳
		cardgroup_ThreeSeq = 6;��˳
		cardgroup_ThreePlus = 7;����һ��һ�Ż�һ�ԣ�
		cardgroup_Airplane = 8;�ɻ�
		cardgroup_FourSeq = 9;�Ĵ��������Ż����ԣ�
		cardgroup_Bomb = 10;ը������ը
	

; #########################################################################