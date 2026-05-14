#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10E04()
	Private _oDlg		:= Nil
	Private _nOpca	:= 0
	Private _cTitulo	:= 'Etiqueta Check List' 

	Private _nQtd		:= 1
	Private _nQtdImp	:= 1
	Private _cCodProd	:= Space(TamSX3('B1_COD')[1])
	Private _cNota	:= Space(TamSX3('B1_COD')[1])
	Private _cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])
	
	/*DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

	@ 002,002 TO 150, 160 OF _oDlg PIXEL

	@ 020,010 SAY 'Código Produto' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodProd SIZE 80, 11 F3 'SB1' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'Quantidade' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET _nQtd SIZE 80, 11 OF _oDlg Picture '@E 99999.99' PIXEL
	
	@ 060,010 SAY 'Num. de Série' SIZE 55, 07 OF _oDlg PIXEL
	@ 060,070 MSGET _cNumSer SIZE 80, 11 OF _oDlg Picture '@!' PIXEL
	
	@ 080,010 SAY 'Nota Fiscal' SIZE 55, 07 OF _oDlg PIXEL
	@ 080,070 MSGET _cNota SIZE 80, 11 OF _oDlg Picture '@!' PIXEL
	
	@ 100,010 SAY 'Quantidade Etiquetas' SIZE 55, 07 OF _oDlg PIXEL
	@ 100,070 MSGET _nQtdImp SIZE 80, 11 OF _oDlg Picture '@E 99999' PIXEL

	DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION (_nOpca := 1,(M02EMain(@_cCodProd,@_nQtd,@_cNota,@_nQtdImp, @_cNumSer))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED */
	
	
	//If ZAB->ZAB_ETQCKL > 0
	//MsgAlert("Etiqueta já impressa!","Atenção")
	//Else
	M02EMain(ZAB->ZAB_CODPROD,1,"", 1, ZAB->ZAB_NUMSER)
	//EndIf
	
	
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BEGIN TRANSACTION //BeginTran()

	U_M10EPri1(_cCodProd, _nQtd, _cNumSer, .T. /*lCtrlImp*/, _nQtdImp ) //MA650TOK.PRW
	
	END TRANSACTION //EndTran()
	MsUnlockAll()

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EValid(_cCodProd,_nQtd,_cNota,_nQtdImp)
	Local _lRet := .T.

	If !(_lRet := !Empty(_cCodProd))
		MsgInfo('É obrigatório informar o código do produto.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. !(_lRet := _nQtd > 0)
		MsgInfo('Quantidade deve ser maior que zero.','Atenção!')
		_lRet := .F.
	EndIf
	
	If _lRet .And. !(_lRet := !Empty(_cNota))
		MsgInfo('É obrigatório informar o numero da nota fiscal.','Atenção!')
	EndIf	

	If _lRet .And. !(_lRet := _nQtdImp > 0)
		MsgInfo('Quantidade de etiquetas a imprimir deve ser maior que zero.','Atenção!')
	EndIf

	If _lRet
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())

		If !(_lRet := SB1->(DbSeek( xFilial('SB1') + _cCodProd )))
			MsgInfo('Produto não localizado !','Atenção')
		EndIf
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
