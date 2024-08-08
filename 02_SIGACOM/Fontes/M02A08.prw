#Include 'Protheus.ch'

//+----------------------------------------------------------
//| Função para alterar data de entrega do pedido de Compras 
//  Chamado do ponto de entrada MT121BRW
//+---------------------------------------------------------
User Function M02A08(nTipo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local oDlg
Local dDtEnt   := Ctod("  /  /  ")
Local nOpca    := 1
Local nItensTot := 0
Local nItensAlt := 0
Local cPedCompra := SC7->C7_NUM
Local dEmissao   := SC7->C7_EMISSAO


If !Empty(SC7->C7_RESIDUO) .Or. SC7->C7_QUJE = SC7->C7_QUANT
	Aviso("Atencao !",OemToAnsi("Pedido de Compra já Encerrado !!"),{"Ok"})
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Data de Entrega. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If nTipo == 1 // Altera Data de Entrega
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca a data de Entrega do Primeiro item com Saldo. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo == 1
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+SC7->C7_NUM)
		While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
			
			If SC7->C7_QUANT > SC7->C7_QUJE
				dDtEnt := SC7->C7_DATPRF
				Exit
			EndIf
			
			dbSkip()
		EndDo

	Else
		dDtEnt := SC7->C7_DATPRF
	EndIf
	
	If Empty(dDtEnt)
		Aviso("Atencao !",OemToAnsi("Pedido de Compra já Encerrado !!"),{"Ok"})
		RestArea(aAreaSC7)
		RestArea(aArea)
		Return
	EndIf
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alteração da Data de Entrega do Pedido : "+cPedCompra) FROM 200,001 TO 350,500 PIXEL //300,450 PIXEL
	
	@ 040,030 SAY OEMTOANSI("Data Entrega : ") SIZE 050,07 OF oDlg PIXEL 
	@ 040,080 MSGET dDtEnt WHEN .T.            SIZE 050,10 Valid(dDtEnt>=dEmissao)  OF oDlg PIXEL
	
	ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava a Nova Data de Entrega. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpca == 1

		nItensTot := 0
		nItensAlt := 0

		If nTipo == 1
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+cPedCompra)
			While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
				nItensTot ++
				If SC7->C7_QUANT > SC7->C7_QUJE
					RecLock("SC7",.F.)
					If Empty(SC7->C7_XENTORI)
						SC7->C7_XENTORI := SC7->C7_DATPRF
					EndIf
					SC7->C7_DATPRF := dDtEnt
					MsUnlock()
					nItensAlt ++
				EndIf
				dbSkip()
			EndDo
		Else
			RecLock("SC7",.F.)
			If Empty(SC7->C7_XENTORI)
				SC7->C7_XENTORI := SC7->C7_DATPRF
			EndIf
			SC7->C7_DATPRF := dDtEnt
			MsUnlock()
			nItensAlt ++
			nItensTot ++
		EndIf

		Aviso("Atencao !",OemToAnsi("Alterados Item(s) : "+StrZero(nItensAlt,4)+" de "+StrZero(nItensTot,4)),{"Ok"})
	EndIf

//EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.                    


User Function M02A081

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local oDlg
Local dDtEnv   := Ctod("  /  /  ")
Local nOpca    := 1
Local nItensTot := 0
Local nItensAlt := 0
Local cPedCompra := SC7->C7_NUM
Local dEmissao   := SC7->C7_EMISSAO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Data de Envio. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+SC7->C7_NUM)

dDtEnv := dDataBase
	
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alteração da Data de Envio do Pedido : "+cPedCompra) FROM 200,001 TO 350,500 PIXEL //300,450 PIXEL

@ 040,030 SAY OEMTOANSI("Data Envio : ") SIZE 050,07 OF oDlg PIXEL 
@ 040,080 MSGET dDtEnv WHEN .T.          SIZE 050,10 Valid(dDtEnv>=dEmissao.Or.Empty(dDtEnv))  OF oDlg PIXEL
	
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava a Nova Data de Envio. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1

	nItensTot := 0
	nItensAlt := 0

	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+cPedCompra)
		While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
			nItensTot ++
			RecLock("SC7",.F.)
			SC7->C7_XENVFOR := dDtEnv
			MsUnlock()
			nItensAlt ++
			
			dbSkip()
		EndDo
	
		Aviso("Atencao !",OemToAnsi("Alterados Item(s) : "+StrZero(nItensAlt,4)+" de "+StrZero(nItensTot,4)),{"Ok"})
	EndIf

//EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.


User Function M02A082(nTipo) // ALtera Obs. Interna -> Follow UP  #6854

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local oDlg
Local cObsInt
Local nOpca    := 1
Local cPedCompra := SC7->C7_NUM

cObsInt := SC7->C7_XOBSINT
	
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alteração da Observação Interna do Pedido/Item : "+cPedCompra) FROM 200,001 TO 350,800 PIXEL //300,450 PIXEL

@ 040,020 SAY OEMTOANSI("Obs Interna: ") SIZE 050,07 OF oDlg PIXEL 
@ 040,070 MSGET cObsInt WHEN .T.          SIZE 300,10 OF oDlg PIXEL
	
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava follow up. ³             
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 1 //Alt.Obs.Interna PC 

    If nOpca == 1
        dbSelectArea("SC7")
    	dbSetOrder(1)
    	dbSeek(xFilial("SC7")+cPedCompra)
		While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
            RecLock("SC7", .F.)
            SC7->C7_XOBSINT := cObsInt
            MsUnlock()

            DbSkip()
        EndDo

        Aviso("Atencao !",OemToAnsi("Observação Interna do Item Alterado !"),{"Ok"})
    EndIf
EndIf //Alt.Obs.Interna Item
    If nOpca == 1

	RecLock("SC7",.F.)
	SC7->C7_XOBSINT := cObsInt
	MsUnlock()

	Aviso("Atencao !",OemToAnsi("Observação Interna do Item Alterado !"),{"Ok"})
    EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.
