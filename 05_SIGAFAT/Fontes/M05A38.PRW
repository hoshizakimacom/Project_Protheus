#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��     � M05A38 � Autor � Marcos Eduardo Rocha  � Data � 16/06/23   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para alteracao da Data de Entrega do PV               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especificos Macom                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M05A38()

//�������������������������Ŀ
//� Declaracao de variaveis �
//���������������������������
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())
Local oDlg
Local dDtEnt   := Ctod("  /  /  ")
Local nOpca    := 1
Local nItensTot := 0
Local nItensAlt := 0

If !Empty(SC5->C5_NOTA) .And. SC5->C5_LIBEROK == "E"
	Aviso("Atencao !",OemToAnsi("Pedido de Venda j� Encerrado !!"),{"Ok"})
	Return
EndIf

//���������������������������Ŀ
//� Atualiza Data de Entrega. �
//�����������������������������
//If nTipo == 1 // Altera Data de Entrega
	
	//�����������������������������������������������������Ŀ
	//� Busca a data de Entrega do Primeiro item com Saldo. �
	//�������������������������������������������������������
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+SC5->C5_NUM)
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
		
		If SC6->C6_QTDVEN > SC6->C6_QTDENT
			dDtEnt := SC6->C6_ENTREG
			Exit
		EndIf
		
		dbSkip()
	EndDo
	
	If Empty(dDtEnt)
		Aviso("Atencao !",OemToAnsi("Pedido de Venda j� Encerrado !!"),{"Ok"})
		RestArea(aAreaSC6)
		RestArea(aArea)
		Return
	EndIf
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Altera��o da Data de Entrega do Pedido : "+SC5->C5_NUM) FROM 200,001 TO 400,600 PIXEL //300,450 PIXEL
	
	@ 060,050 SAY OEMTOANSI("Data Entrega : ") SIZE 050,07 OF oDlg PIXEL
	@ 060,090 MSGET dDtEnt WHEN .T.            SIZE 050,10 OF oDlg PIXEL
	
	ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED
	
	//�������������������������������Ŀ
	//� Grava a Nova Data de Entrega. �
	//���������������������������������
	If nOpca == 1

		nItensTot := 0
		nItensAlt := 0

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+SC5->C5_NUM)
		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
			
			nItensTot ++








			If SC6->C6_QTDVEN > SC6->C6_QTDENT
				RecLock("SC6",.F.)
				If SC6->(FieldPos("C6_XENTORI") > 0)				
					If Empty(SC6->C6_XENTORI)
						SC6->C6_XENTORI := SC6->C6_ENTREG
					EndIf
				EndIf
				SC6->C6_ENTREG := dDtEnt
				MsUnlock()

				nItensAlt ++
			EndIf
			
			dbSkip()
		EndDo

		Aviso("Atencao !",OemToAnsi("Alterados Item(s) : "+StrZero(nItensAlt,4)+" de "+StrZero(nItensTot,4)),{"Ok"})
	EndIf

//EndIf

RestArea(aAreaSC6)
RestArea(aArea)

Return .T.                    
