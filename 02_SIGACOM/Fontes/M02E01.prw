#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M02E01()
	Local _oDlg		:= Nil
	Local _nOpca	:= 0
	Local _cTitulo	:= 'Etiqueta Ident. Produto'

	Local _nQtd		:= 1
	Local _nQtdImp	:= 1
	Local _cCodProd	:= Space(TamSX3('B1_COD')[1])
	Local _cNota	:= Space(TamSX3('B1_COD')[1])
	Local _cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])
	
	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

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

	ACTIVATE MSDIALOG _oDlg CENTERED
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BeginTran()

		If M02EValid(_cCodProd,_nQtd,_cNota,_nQtdImp)

			M02EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

			_cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])
			_nQtd		:= 1		

		EndIf

	EndTran()
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
Static Function M02EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 90

	Local _oFontP 		:= TFont():New('Arial',,12)
	Local _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Local _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Local _oFontGG		:= TFont():New('Arial',,42,.T.,.T.)
	
	Local _nNextLin		:= 50
	Local _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM") 
	Local _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Local _cArmazem		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_LOCPAD")
	Local _cDescPro1	:= ""
	Local _cDescPro2	:= ""
	Local _nCol01		:= 020
	Private _nCol02		:= _nCol01 + 430
	Private _nCol03		:= _nCol01 + 700

	_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)

	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:SayBitMap( _nRow -40 , 800 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)

	_oPrinter:FWMSBAR('CODE128',1.0/*nRow*/,2/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

	_nRow += _nNextLin * 2.6

	_oPrinter:Say(_nRow    ,_nCol01 + 70,_cCodProd,_oFontM)
	_oPrinter:Say(_nRow	   ,_nCol01 + 800,"N.F. " + _cNota ,_oFontM)
	
	_nRow += _nNextLin * 0.9
	
	If Len(_cDescPro) > 42
		_cDescPro1 := Substr(_cDescPro,1,42)
		_cDescPro2 := Substr(_cDescPro,43,44)
		_oPrinter:Say(_nRow +  50,_nCol01 + 70 ,_cDescPro1,_oFontG)
		_oPrinter:Say(_nRow + 100,_nCol01 + 70 ,_cDescPro2,_oFontG)		
	Else
		_oPrinter:Say(_nRow + 75,_nCol01 + 70 ,_cDescPro,_oFontG)
	Endif
	
	_nRow += _nNextLin * 0.9
	
	_oPrinter:Say(_nRow + 180,_nCol01 + 100, "[ " + Alltrim(Str(_nQtd) + " ]") ,_oFontGG)
	_oPrinter:Say(_nRow + 180,_nCol03 + 150, "[ " + _cUnid + " ]",_oFontGG)
	_oPrinter:Say(_nRow + 360,_nCol03 + 150, "[ " + _cArmazem + " ]",_oFontGG)
	_oPrinter:Say(_nRow + 430,_nCol03 + 210 , "Armazém ",_oFontM)

	_nRow += _nNextLin * 0.9
	
	If !Empty(_cNumSer)
		_oPrinter:Say(_nRow + 380,_nCol01 + 70 , "Numero de Série : " + _cNumSer ,_oFontM)
		_oPrinter:FWMSBAR('CODE128',13.2/*nRow*/,2/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)		
		//_oPrinter:QRCode(600,500,"www.acosmacom.com.br",050)
	Endif
	
	_oPrinter:Say(_nRow + 430,_nCol01 + 70,  DTOC(dDataBase) ,_oFontM)
	_oPrinter:Say(_nRow + 430,_nCol03 + 56, "Aços Macom Ind. e Com. Ltda",_oFontM)
	_oPrinter:Say(_nRow + 460,_nCol01 + 70,'FGQ-FB-012',_oFontP) // #5006

	//_oPrinter:Say(_nRow + 460,_nCol03 + 415,'FGQ-056',_oFontP)	#5006
	_oPrinter:Say(_nRow + 460,_nCol03 + 415,'REV.:00',_oFontP) // 	#5006
	
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 		:= 'ZEBRA'

	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
Return
