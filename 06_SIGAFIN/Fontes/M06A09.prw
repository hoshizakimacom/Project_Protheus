#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de troca de cliente RA (Recebimento Antecipado)
//	Substitui cliente não identificado
//+----------------------------------------------------------------------------------------------------------------
User Function M06A09()

	Local _oDlg		:= Nil
	Local _nOpca	:= 0
	Local _cTitulo	:= 'Troca de Cliente R.A.'

	Local _cCodCli	:= Space(TamSX3('E1_CLIENTE')[1])
	Local _cLoja	:= Space(TamSX3('E1_LOJA')[1])
	Local _cPedido  := Space(TamSX3('E1_PEDIDO')[1])
	Local _cTipo	:= SE1->E1_TIPO

	If  !(_cTipo $ "RA |CRA")
		MsgInfo('A alteração só é válida para títulos do tipo RA/CRA.','Atenção!')
		Return Nil
	EndIf

	If SE1->E1_CLIENTE <> "030000" 
		MsgInfo('Não é permitida efetuar a troca de cliente já identificado.','Atenção!')
		Return Nil
	EndIf

	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 203,318 PIXEL

	@ 002,002 TO 100, 160 OF _oDlg PIXEL

	@ 020,010 SAY 'Código do Cliente' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodCli SIZE 80, 11 F3 'SA1' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'Loja' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET _cLoja SIZE 80, 11 OF _oDlg Picture '@!' PIXEL

	@ 060,010 SAY 'Pedido' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 060,070 MSGET _cPedido SIZE 80, 11 F3 'SC5' Picture '@!' OF _oDlg PIXEL

	DEFINE SBUTTON FROM 85, 45 TYPE 1 ACTION (_nOpca := 1,(IIF(M06EMain(@_cCodCli,@_cLoja,@_cTipo,@_cPedido),_oDlg:End(),))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 85, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M06EMain(_cCodCli,_cLoja,_cTipo,_cPedido)

Local _aAreaATU := GetArea()
Local _aAreaSE1 := SE1->(GetArea())
Local _cCliOld  := SE1->E1_CLIENTE
Local _cLojOld  := SE1->E1_LOJA
Local cProgram  := "M06A09"
Local _lRet     := .F.
Local lGrvSA1   := .T.
Local nRecnoSE1 := 0

Private CITEMD  := ""
Private CITEMC  := ""
Private NVALCTB := 0

If M06EValid(_cCodCli,_cLoja,_cTipo)

	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())

	BEGIN TRANSACTION //BeginTran()

			CITEMD  := "1"+_cCodCli+_cLoja
			CITEMC  := "1"+SE1->(E1_CLIENTE+E1_LOJA) 
			NVALCTB := SE1->E1_VALOR 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a atualizacao dos saldos do cliente no SA1. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA1->(dbSeek( xFilial('SA1') + _cCliOld + _cLojOld ))
			nRecnoSE1 := SE1->(RECNO())
			AtuSalDup("+",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,SE1->E1_TXMOEDA,SE1->E1_EMISSAO,,,lGrvSA1)
			SE1->(dbGoTo(nRecnoSE1))

			RecLock("SE1", .F.)
			SE1->E1_CLIENTE	:= _cCodCli
			SE1->E1_LOJA	:= _cLoja
			SE1->E1_PEDIDO	:= _cPedido
			SE1->E1_NOMCLI  := Posicione("SA1",1,xFilial("SA1")+ _cCodCli + _cLoja,"A1_NREDUZ")
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a atualizacao dos saldos do cliente no SA1. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA1->(dbSeek( xFilial('SA1') + _cCodCli + _cLoja ))
			nRecnoSE1 := SE1->(RECNO())
			AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,SE1->E1_TXMOEDA,SE1->E1_EMISSAO,,,lGrvSA1)
			SE1->(dbGoTo(nRecnoSE1))

			M06AtuMov(_cCodCli,_cLoja,_cCliOld,_cLojOld)

			SE1->(dbSetOrder(1))
			If SE1->(dbSeek(xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+"BOL"+_cCliOld+_cLojOld)))

				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+_cPedido))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a atualizacao dos saldos do cliente no SA1. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SA1->(dbSeek( xFilial('SA1') + _cCliOld + _cLojOld ))
				nRecnoSE1 := SE1->(RECNO())
				AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,SE1->E1_TXMOEDA,SE1->E1_EMISSAO,,,lGrvSA1)
				SE1->(dbGoTo(nRecnoSE1))

				RecLock("SE1", .F.)
				SE1->E1_CLIENTE	:= _cCodCli
				SE1->E1_LOJA	:= _cLoja
				SE1->E1_PEDIDO	:= _cPedido
				SE1->E1_NOMCLI  := Posicione("SA1",1,xFilial("SA1")+ _cCodCli + _cLoja,"A1_NREDUZ")
				SE1->E1_VEND1   := SC5->C5_VEND1
				SE1->E1_COMIS1  := SC5->C5_COMIS1
				SE1->E1_VEND2   := SC5->C5_VEND2
				SE1->E1_COMIS2  := SC5->C5_COMIS2
				SE1->E1_VEND3   := SC5->C5_VEND3
				SE1->E1_COMIS3  := SC5->C5_COMIS3
				SE1->E1_VEND4   := SC5->C5_VEND4
				SE1->E1_COMIS4  := SC5->C5_COMIS4
				SE1->E1_VEND5   := SC5->C5_VEND5
				SE1->E1_COMIS5  := SC5->C5_COMIS5
				MsUnlock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a atualizacao dos saldos do cliente no SA1. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SA1->(dbSeek( xFilial('SA1') + _cCodCli + _cLoja ))
				nRecnoSE1 := SE1->(RECNO())
				AtuSalDup("+",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,SE1->E1_TXMOEDA,SE1->E1_EMISSAO,,,lGrvSA1)
				SE1->(dbGoTo(nRecnoSE1))

				M06AtuMov(_cCodCli,_cLoja,_cCliOld,_cLojOld)
			EndIf
			
			RestArea(_aAreaSE1)
			RestArea(_aAreaAtu)

			//Ajuste na contabilidade - item contabil *********** inicio
			_aAreaCT2 := CT2->(GetArea())
			_aAreaCTD := CTD->(GetArea())

			dbSelectArea("CTD")
			dbSetOrder(1)
			If dbSeek(xFilial("CTD")+"1"+SE1->(E1_CLIENTE+E1_LOJA))
				LancCont("004",cProgram,.T.)  // Atualizar LP
			EndIf

			RestArea(_aAreaCTD)
			RestArea(_aAreaCT2)
			RestArea(_aAreaAtu)
			
			//Ajuste na contabilidade - item contabil *********** Final

	END TRANSACTION //EndTran()
	MsUnlockAll()

	MsgInfo('Cliente Alterado', 'Atenção')

	_lRet := .T.

EndIf

RESTAREA(_aAreaSE1)
RESTAREA(_aAreaATU)

Return _lRet

Static Function M06EValid(_cCodCli,_cLoja,_cTipo)
	Local _lRet := .T.

	If Empty(_cCodCli)
		MsgInfo('É obrigatório informar um novo cliente.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. ( _cCodCli = "030000" .Or. (SE1->E1_CLIENTE <> "030000" .And. SE1->E1_CLIENTE <> _cCodCli) )
		MsgInfo('Não é permitida efetuar a troca de cliente já identificado.','Atenção!')
		Return Nil
	EndIf

	If _lRet
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())

		If !SA1->(DbSeek( xFilial('SA1') + _cCodCli + _cLoja))
			MsgInfo('Cliente não encontrado !','Atenção')
			_lRet := .F.
		EndIf
	EndIf
Return _lRet


Static Function M06AtuMov(_cCodCli,_cLoja,_cCliOld,_cLojOld)

Local _aArea := Getarea()
Local _aAreaSE1 := SE1->(Getarea())
Local aBaixas := {}
Local aAreaSav := {}

dbSelectArea("SE5")
dbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ

If SE5->(MsSeek(xFilial("SE5")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + _cCliOld + _cLojOld))
	RecLock("SE5",.F.)
	SE5->E5_CLIFOR := _cCodCli
	SE5->E5_LOJA   := _cLoja
	SE5->E5_BENEF  := Posicione("SA1",1,xFilial("SA1")+ _cCodCli + _cLoja,"A1_NREDUZ")
	MsUnlock()

	If SE1->E1_TIPO == "BOL"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a atualizacao das comissões do Vendedor     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaSav := GetArea()
		aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
		Fa440CalcB(aBaixas,.F.,.F.,"FINA460","+",,,.T.,SE1->(Recno()) )
		aBaixas		:= {}
		RestArea(aAreaSav)
	EndIf
Endif

RestArea(_aAreaSE1)
RestArea(_aArea)

Return
