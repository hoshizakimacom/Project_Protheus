#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M02E02()
	Local _oDlg			:= Nil
	Local _nOpca		:= 0
	Local _cTitulo		:= 'Etiqueta Ident. Prateleira'

	Local _nQtd			:= 1
	
	Local _cCodProd1	:= Space(TamSX3('B1_COD')[1])
	Local _cCodProd2	:= Space(TamSX3('B1_COD')[1])
	Private _nQtdImp		:= 1
	Private _cNota		:= Space(TamSX3('B1_COD')[1])
	Private _cNumSer		:= Space(TamSX3('ZA0_SERIE')[1])

	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

	@ 002,002 TO 150, 160 OF _oDlg PIXEL

	@ 020,010 SAY 'Código Produto De:  ' SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodProd1 SIZE 80, 11 F3 'SB1' PICTURE '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'Código Produto Até: ' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET _cCodProd2 SIZE 80, 11 F3 'SB1' PICTURE '@!' OF _oDlg PIXEL

	@ 060,010 SAY 'Quantidade: ' SIZE 55, 07 OF _oDlg PIXEL
	@ 060,070 MSGET _nQtd SIZE 80, 11 OF _oDlg PIXEL
	
	DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION (_nOpca := 1,(M02EMain(@_cCodProd1,@_cCodProd2,@_nQtd))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EMain(_cCodProd1,_cCodProd2,_nQtd)

	Private _nX	:= 0

	BeginTran()

		If M02EValid(_cCodProd1,_cCodProd2,_nQtd)

			M02EPrint(_cCodProd1,_cCodProd2,_nQtd)

			_cCodProd	:= Space(TamSX3('B1_COD')[1])
			_nQtd		:= 1
		EndIf

	EndTran()
	MsUnlockAll()

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EValid(_cCodProd1,_cCodProd2,_nQtd,_cNota,_nQtdImp)
	Local _lRet := .T.

	If !(_lRet := !Empty(_cCodProd1) .And. !Empty(_cCodProd2))
		MsgInfo('É obrigatório informar o código do produto.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. !(_lRet := _nQtd > 0)
		MsgInfo('Quantidade deve ser maior que zero.','Atenção!')
		_lRet := .F.
	EndIf
	
	If _lRet
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())

		If !(_lRet := SB1->(DbSeek( xFilial('SB1') + _cCodProd1 )))
			MsgInfo('Produto inicial não localizado !','Atenção')
		EndIf
		
		If !(_lRet := SB1->(DbSeek( xFilial('SB1') + _cCodProd2 )))
			MsgInfo('Produto final não localizado !','Atenção')
		EndIf
		
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EPrint(_cCodProd1,_cCodProd2,_nQtd,_cNota,_nQtdImp,_cNumSer)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 140

	Local _oFontP 		:= TFont():New('Arial',,10)
	Local _oFontM 		:= TFont():New('Arial',,14,.T.,.T.)	
	Local _oFontG 		:= TFont():New('Arial',,20,.T.,.T.)

	Local _nCol01		:= 030
	Local _nCol02		:= _nCol01 + 400
	Local _nCol03		:= _nCol01 + 700
	Local _cDescPro		:= ""
	Local _cDescPro1	:= ""
	Local _cDescPro2	:= ""
	Local cAliasQry 	:= GetNextAlias()
	Private _nNextLin		:= 50
	Private _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd1,"B1_UM") 
	
	
	BeginSql Alias cAliasQry

		SELECT 
			SB1.B1_COD,SB1.B1_COD
		FROM 
			%Table:SB1% SB1 
		WHERE 
			SB1.B1_COD >= %Exp:_cCodProd1% AND
			SB1.B1_COD <= %Exp:_cCodProd2% AND 
			SB1.%NotDel%
		ORDER BY 
			SB1.B1_COD
	EndSql 
	
	While !(cAliasQry)->(Eof())
	
		_cCodProd	:= (cAliasQry)->B1_COD 
		_cDescPro	:= Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->B1_COD,"B1_DESC")

		_oPrinter := FWMSPrinter():New('M02E02' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtd)

		_oPrinter:SetResolution(78)
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:StartPage()

		_oPrinter:FWMSBAR('CODE128',1.0/*nRow*/,3.0/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

		_oPrinter:Say(_nRow + 11 , _nCol01 + 250,_cCodProd,_oFontG)	

		
		If Len(AllTrim(_cDescPro)) > 39	
			_cDescPro1 := Substr(_cDescPro,1,39)
			_cDescPro2 := Substr(_cDescPro,40,80)
			_oPrinter:Say(_nRow + 50,_nCol01,_cDescPro1,_oFontM)
			_oPrinter:Say(_nRow + 90,_nCol01,_cDescPro2,_oFontM)	
		Else
			_nCol02	:= ( 100 - Len(Alltrim(_cDescPro)))
			_oPrinter:Say(_nRow + 90, _nCol02 ,_cDescPro,_oFontM)
		Endif

		_oPrinter:Say(_nRow + 100,_nCol03,'FGQ-056',_oFontP)
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:cPrinter 		:= 'ZDesigner GC420t (EPL)'

		_oPrinter:EndPage()
		_oPrinter:Print()

		FreeObj(_oPrinter)
		
		(cAliasQry)->(dbSkip())
	End
Return
