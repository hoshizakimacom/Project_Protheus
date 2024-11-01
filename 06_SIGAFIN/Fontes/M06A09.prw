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
	
	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 203,318 PIXEL

	@ 002,002 TO 100, 160 OF _oDlg PIXEL

	@ 020,010 SAY 'Código do Cliente' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodCli SIZE 80, 11 F3 'SA1' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'Loja' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET _cLoja SIZE 80, 11 OF _oDlg Picture '@!' PIXEL

	@ 060,010 SAY 'Pedido' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 060,070 MSGET _cPedido SIZE 80, 11 F3 'SC5' Picture '@!' OF _oDlg PIXEL

	DEFINE SBUTTON FROM 85, 45 TYPE 1 ACTION (_nOpca := 1,(M06EMain(@_cCodCli,@_cLoja,@_cTipo,@_cPedido))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 85, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M06EMain(_cCodCli,_cLoja,_cTipo,_cPedido)

Local _cCliOld := SE1->E1_CLIENTE
Local _cLojOld := SE1->E1_LOJA
Local cLote	   := "008850"
Local cPadrao		:= " "
Local nVlrCtb		:= 0
Local nHdlPrv		:= 0
Local cArquivo
Local cProgram  := "M06A09" 

Private CITEMD  := ""
Private CITEMC  := ""
Private NVALCTB := 0 

	BeginTran()

		If M06EValid(_cCodCli,_cLoja,_cTipo)

			CITEMD  := "1"+_cCodCli+_cLoja
			CITEMC  := "1"+SE1->(E1_CLIENTE+E1_LOJA) 
			NVALCTB := SE1->E1_VALOR 

			RecLock("SE1", .F.)
			SE1->E1_CLIENTE	:= _cCodCli
			SE1->E1_LOJA	:= _cLoja
			SE1->E1_PEDIDO	:= _cPedido
			SE1->E1_NOMCLI  := Posicione("SA1",1,xFilial("SA1")+ _cCodCli + _cLoja,"A1_NREDUZ")

			MsgInfo('Cliente Alterado', 'Atenção')		
			MsUnlock() 

			//Ajuste na contabilidade - item contabil *********** inicio
			_aAreaAtu := GetArea()
			_aAreaCT2 := CT2->(GetArea())
			_aAreaCTD := CTD->(GetArea())

			dbSelectArea("CTD")
			dbSetOrder(1)
			If dbSeek(xFilial("CTD")+"1"+SE1->(E1_CLIENTE+E1_LOJA))

/*/
			MsgStop("teste 3")

			//MsgStop('teste01')

				_cquery := " UPDATE "+RetSQLName("CT2") + " SET CT2_ITEMC ='1"+SE1->(E1_CLIENTE+E1_LOJA)+"'"
				_cquery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' "
				_cquery += " AND CT2_DATA ='"+DTOS(SE1->E1_EMISSAO) + "'"
				_cquery += " AND CT2_DC IN ('1','3') "
				_cquery += " AND CT2_KEY ='"+SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)+"'"
				_cquery += " AND D_E_L_E_T_=''
				_cquery += " AND CT2_ITEMC<>''"

			    MsgStop(_cquery)

				If TCSQLExec(_cquery) < 0 
					MsgStop("Erro na execução da query:"+TcSqlError(), "Atenção")
				Else
					MsgAlert("Atualizacao contabil executada com sucesso. Convem reprocessar o saldo contbail da data de "+DToC(SE1->E1_EMISSAO)+"!")
				EndIf
		
/*/

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa lancamento                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				CTPSALDO	:= '1'
//				nVlrCtb  := 0
//				nHdlPrv		:= HeadProva(cLote,"CTBA500",Substr(cUsuario,7,6),@cArquivo)

				LancCont("004",cProgram,.T.)  // Atualizar LP
			EndIf

			RestArea(_aAreaCTD)
			RestArea(_aAreaCT2)
			RestArea(_aAreaAtu)
			
			//Ajuste na contabilidade - item contabil *********** Final

			M06AtuMov(_cCodCli,_cLoja,_cCliOld,_cLojOld)

		EndIf

	EndTran()
	MsUnlockAll()

Return

Static Function M06EValid(_cCodCli,_cLoja,_cTipo)
	Local _lRet := .T.

	If !(_lRet := !Empty(_cCodCli))
		MsgInfo('É obrigatório informar um novo cliente.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. (_lRet := ALLTRIM(_cTipo) <> "RA")
		MsgInfo('A alteração só é válida para títulos do tipo RA.','Atenção!')
		_lRet := .F.
	EndIf

	If !(_lRet := _cCodCli <> "030000")
		MsgInfo('Não é permitida efetuar a troca de cliente já identificado.','Atenção!')
		_lRet := .F.
	EndIf
	
	
	If _lRet
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())

		If !(_lRet := SA1->(DbSeek( xFilial('SA1') + _cCodCli )))
			MsgInfo('Cliente não encontrado !','Atenção')
			_lRet := .F.
		EndIf
	EndIf
Return _lRet


Static Function M06AtuMov(_cCodCli,_cLoja,_cCliOld,_cLojOld)

Local _aArea := Getarea()

dbSelectArea("SE5")
dbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ                                                                                      

If SE5->(MsSeek(xFilial("SE5")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + _cCliOld + _cLojOld))
	RecLock("SE5",.F.)
	SE5->E5_CLIFOR := _cCodCli
	SE5->E5_LOJA   := _cLoja
	SE5->E5_BENEF  := Posicione("SA1",1,xFilial("SA1")+ _cCodCli + _cLoja,"A1_NREDUZ")
	MsUnlock()	
Endif

RestArea(_aArea)



Return
