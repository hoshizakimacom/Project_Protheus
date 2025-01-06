#Include 'Protheus.ch'

//+----------------------------------------------------------
//| Função para alterar data de entrega do pedido de Compras 
//  Chamado do ponto de entrada MT121BRW
//+---------------------------------------------------------
User Function M02A10()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local nItensTot := 0
Local nItensAlt := 0
Local cPedCompra := SC7->C7_NUM

If Empty(SC7->C7_RESIDUO)
	Aviso("Atencao !",OemToAnsi("Pedido de Compra não está eliminado por resíduo !!"),{"Ok"})
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Data de Entrega. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If nTipo == 1 // Altera Data de Entrega

If MsgYesNo('Confirma Reativação do Pedido ?' + CRLF + 'Deseja Reativar ?',"Atenção")
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+cPedCompra)
	While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
		nItensTot ++
		If !Empty(SC7->C7_RESIDUO)
			RecLock("SC7",.F.)
			SC7->C7_RESIDUO := ""
			MsUnlock()
			nItensAlt ++
		EndIf
		dbSkip()
	EndDo

	Aviso("Atencao !",OemToAnsi("Alterados Item(s) : "+StrZero(nItensAlt,4)+" de "+StrZero(nItensTot,4)),{"Ok"})
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T. 
