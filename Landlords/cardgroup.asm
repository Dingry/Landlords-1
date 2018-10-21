; #########################################################################
; �ļ���
;	cardgroup.asm
;
; ���ܣ�
;	�洢���ϻ����Ƶ�һ���ƣ����������Ƶ����͡����桢�����ȡ�
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

TITLE Cardgroup (cardgroup.asm)

include cardgroup.inc

.code

;-----------------------------------------------------
AddNumber PROC,
	_group:PTR CardGroup, ;��������:����Ƶ�����ṹ
	num:BYTE	 ;��������:��ӵ�������
; ��������:���0-53��ʾ����Ԫ��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL num_translate:BYTE
	pushad
	mov edi,_group
	inc (CardGroup PTR [edi]).count

	lea esi,(CardGroup PTR [edi]).cards
	movzx eax,num
	add esi,eax
	mov al,[esi]
	inc al
	mov [esi],al

	invoke Translate,num,addr num_translate
	lea esi,(CardGroup PTR [edi]).card_group
	movzx eax,num_translate
	add esi,eax
	mov al,[esi]
	inc al
	mov [esi],al

	popad
	ret
AddNumber ENDP

;-----------------------------------------------------
DeleteNumber PROC,
	_group:PTR CardGroup, ;��������:ɾ���Ƶ�����ṹ
	num:BYTE	 ;��������:ɾ����������
; ��������:ɾ��0-53��ʾ����Ԫ��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	LOCAL num_translate:BYTE
	pushad
	mov edi,_group

	lea esi,(CardGroup PTR [edi]).cards
	movzx eax,num
	add esi,eax
	mov al,[esi]
	.if al == 0
		ret
	.else
		mov al,[esi]
		dec al
		mov [esi],al
	.endif

	dec (CardGroup PTR [edi]).count

	invoke Translate,num,addr num_translate
	lea esi,(CardGroup PTR [edi]).card_group
	movzx eax,num_translate
	add esi,eax
	mov al,[esi]
	dec al
	mov [esi],al

	popad
	ret
DeleteNumber ENDP

;-----------------------------------------------------
Clear PROC,
	_group:PTR CardGroup ;��������:��յ�����ṹ
; ��������:���ô˽ṹ
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad

	mov edi,_group
	bequal (CardGroup PTR [edi]).group_type,cardgroup_Unkown
	bequal (CardGroup PTR [edi]).value,0
	bequal (CardGroup PTR [edi]).count,0

	mov esi,0
	.while esi<54
		bequal (CardGroup PTR [edi]).cards[esi],0
		inc esi
	.endw

	mov esi,0
	.while esi<15
		bequal (CardGroup PTR [edi]).card_group[esi],0
		inc esi
	.endw
	popad
	ret
Clear ENDP

;-----------------------------------------------------
Translate PROC,
	num:BYTE, ;��������:������
	result:PTR BYTE	 ;��������:ת�����
; ��������:��0-53ת����0-14Ȩֵ������A��11����2��12����С����13����������14��
; ����ֵ:��
;-----------------------------------------------------
	;����ʵ��
	pushad
	
	mov esi,result
	mov eax,0
	mov bl,4
	.if num<52
		mov al,num
		div bl
		mov [esi],al
	.else
		mov al,num
		sub al,39
		mov [esi],al
	.endif

	popad
	ret
Translate ENDP

END