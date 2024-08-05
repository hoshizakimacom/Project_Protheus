#Include 'Protheus.ch'

//+----------------------------------------------------------
//| Função para alterar Pedido Revenda na Solicitação de Compras //#6894
//  Chamado do ponto de entrada MTA110MNU
//+---------------------------------------------------------

User Function M02A09(nTipo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaSC1 := SC1->(GetArea())
Local oDlg
Local cPedVen
Local nOpca    := 1
Local cSolCompra:= SC1->C1_NUM

cPedVen := SC1->C1_XPEDVEN
	
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alteração do Pedido de Venda Revenda : "+cSolCompra) FROM 200,001 TO 350,800 PIXEL //300,450 PIXEL

@ 040,020 SAY OEMTOANSI("Ped.Ven.Rev: ") SIZE 050,07 OF oDlg PIXEL 
@ 040,070 MSGET cPedVen WHEN .T.          SIZE 300,10 OF oDlg PIXEL
	
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Ped.Ven.Rev ³             
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipo == 1 //Alt.Pedido de Venda Revenda SC

    If nOpca == 1
        dbSelectArea("SC1")
    	dbSetOrder(1)
    	dbSeek(xFilial("SC1")+cSolCompra)
		While !Eof() .And. SC1->C1_FILIAL+SC1->C1_NUM == xFilial("SC1")+cSolCompra
            RecLock("SC1", .F.)
            SC1->C1_XPEDVEN := cPedVen
            MsUnlock()

            DbSkip()
        EndDo

        Aviso("Atencao !",OemToAnsi("Pedido de Venda Revenda Alterado!"),{"Ok"})
    EndIf
EndIf //Alt.Pedido de Venda Revenda Item
    
    If nOpca == 1

	RecLock("SC1",.F.)
	SC1->C1_XPEDVEN := cPedVen
	MsUnlock()

	Aviso("Atencao !",OemToAnsi("Pedido de Venda Revenda Alterado!"),{"Ok"})
    EndIf

RestArea(aAreaSC1)
RestArea(aArea)

Return .T.
