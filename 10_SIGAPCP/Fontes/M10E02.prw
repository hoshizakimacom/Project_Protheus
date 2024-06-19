#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10E02()
	Local _oDlg		:= Nil
	Local _nOpca		:= 0
	Local _cTitulo	:= 'Etiqueta Ident. OP'

	Local _cNumOP		:= Space(TamSX3('C2_NUM')[1] + TamSX3('C2_ITEM')[1] + TamSX3('C2_SEQUEN')[1] + TamSX3('C2_ITEMGRD')[1])
	Local _nQtd		:= 1

	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 185,280 PIXEL

	@ 002,002 TO 70, 140 OF _oDlg PIXEL

	@ 020,010 SAY 'Num. OP' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 020,050 MSGET _cNumOP SIZE 80, 11 F3 'SC2' OF _oDlg PIXEL

	@ 040,010 SAY 'Qtd.' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,050 MSGET _nQtd SIZE 80, 11 OF _oDlg PIXEL

	DEFINE SBUTTON FROM 75, 40 TYPE 1 ACTION (_nOpca := 1,(M10EMain(@_cNumOP,@_nQtd))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 75, 80 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EMain(_cNumOP,_nQtd)

	BeginTran()

		If M10EValid(_cNumOP,_nQtd)

			M10EPrint(_cNumOP,_nQtd)

			_cNumOP	:= Space(TamSX3('C2_NUM')[1] + TamSX3('C2_ITEM')[1] + TamSX3('C2_SEQUEN')[1] + TamSX3('C2_ITEMGRD')[1])
			_nQtd		:= 1
		EndIf

	EndTran()
	MsUnlockAll()

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EValid(_cNumOP,_nQtd)
	Local _lRet := .T.

	If !(_lRet := !Empty(_cNumOP))
		MsgInfo('É obrigatório informar número da OP.')
	EndIf

	If _lRet .And. !(_lRet := _nQtd > 0)
		MsgInfo('Quantidade deve ser maior que 0.')
	EndIf

	If _lRet
		SC2->(DbSetOrder(1))
		SC2->(DbGoTop())

		If !(_lRet := SC2->(DbSeek( xFilial('SC2') + _cNumOP )))
			MsgInfo('OP não localizada.')
		EndIf
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EPrint(_cNumOP,_nQtd)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 90

	Local _oFontG 		:= TFont():New('Arial',,32,.T.,.T.)
	Local _oFontM 		:= TFont():New('Arial',,13,.T.,.T.)
	Local _oFontP 		:= TFont():New('Arial',,12)

	Local _nCol01		:= 020
	Local _nCol02		:= _nCol01 + 430
	Local _nCol03		:= _nCol01 + 700
	Local _nNextLin		:= 50
	Local _cNumOPFor	:= M10GetFor()
	Local _cCliente		:= M10GetCli()
	Private _nX			:= 0

	_oPrinter := FWMSPrinter():New('M10E02' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtd)

	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:Say(_nRow,_nCol01, _cNumOPFor ,_oFontG)

	_oPrinter:FWMSBAR('CODE128',2.7/*nRow*/,3/*nCol*/,AllTrim(_cNumOP),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

	_nRow += _nNextLin * 2.6

	_oPrinter:Say(_nRow,_nCol01,_cCliente,_oFontP)

	_nRow += _nNextLin * 0.9

	_oPrinter:Say(_nRow,_nCol01,AllTrim(SC2->C2_PRODUTO),_oFontM)
	_oPrinter:Say(_nRow,_nCol02,CValToChar(SC2->C2_QUANT),_oFontM)
	_oPrinter:Say(_nRow,_nCol03,DToS(SC2->C2_DATPRF),_oFontM)

	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 		:= 'ZEBRA_P'

	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10GetFor()
	Local _cRet	:= ''

	_cRet	:= SC2->C2_NUM ;
				+ ' ' + SC2->C2_ITEM ;
				+ ' ' + SC2->C2_SEQUEN ;
				+ ' ' + SC2->C2_ITEMGRD
Return AllTrim(_cRet)

//+----------------------------------------------------------------------------------------------------------------
Static Function M10GetCli()
	Local _cRet	:= ''

	// Já está posicionado na OP
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())

	If ! Empty(SC2->C2_PEDIDO)
		If SC5->(DbSeek( xFilial('SC5') + SC2->C2_PEDIDO))
			SA1->(DbSetOrder(1))
			SA1->(DbGoTop())

			If SA1->(DbSeek( xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
				_cRet := AllTrim(SA1->A1_NOME)

				If Len(_cRet) > 50
					_cRet	:= SubStr(SA1->A1_NOME,1,50) + '...'
				EndIf
			EndIf
		EndIf
	EndIf
Return _cRet

//+----------------------------------------------------------------------------------------------------------------
