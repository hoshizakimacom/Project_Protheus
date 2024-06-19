#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M04E05()
	Local _oDlg		:= Nil
	Local _nOpca	:= 0
	Local _cTitulo	:= 'Etiqueta Estoque'
 
	Local _nQtd		:= 1
	Local _nQtdImp	:= 1
	Local _cCodProd	:= Space(TamSX3('B1_COD')[1])
	Local _cNota	:= Space(TamSX3('B1_COD')[1])
	Local _cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])

	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

	@ 002,002 TO 148, 157 OF _oDlg PIXEL

	@ 020,010 SAY 'Código Produto' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodProd SIZE 80, 11 F3 'SB1' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'Quantidade' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET _nQtd SIZE 80, 11 OF _oDlg Picture '@E 99999.99' PIXEL
	
	@ 060,010 SAY 'Num. de Série' SIZE 55, 07 OF _oDlg PIXEL
	@ 060,070 MSGET _cNumSer SIZE 80, 11 OF _oDlg Picture '@!' PIXEL
	
	@ 080,010 SAY 'Quantidade Etiquetas' SIZE 55, 07 OF _oDlg PIXEL
	@ 080,070 MSGET _nQtdImp SIZE 80, 11 OF _oDlg Picture '@E 99999' PIXEL

	DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION (_nOpca := 1,(M04EMain(@_cCodProd,@_nQtd,@_cNota,@_nQtdImp, @_cNumSer))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BeginTran()

		If M04EValid(_cCodProd,_nQtd,_cNota,_nQtdImp)

			M04EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

			_cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])
			_nQtd		:= 1		

		EndIf

	EndTran()
	MsUnlockAll()

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EValid(_cCodProd,_nQtd,_cNota,_nQtdImp)
	Local _lRet := .T.

	If !(_lRet := !Empty(_cCodProd))
		MsgInfo('É obrigatório informar o código do produto.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. !(_lRet := _nQtd > 0)
		MsgInfo('Quantidade deve ser maior que zero.','Atenção!')
		_lRet := .F.
	EndIf
	
	If _lRet .And. !(_lRet := _nQtdImp > 0)
		MsgInfo('Quantidade de etiquetas a imprimir deve ser maior que zero.','Atenção!')
	EndIf

	If _lRet
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())

		If !(_lRet := SB1->(DbSeek( xFilial('SB1') + _cCodProd )))
			MsgInfo('Produto não localizado !','Atenção')
		ElseIf SB1->B1_LOCPAD == "50"
			MsgInfo('Impressão não permitida para o armazém 50 !','Atenção')
		_lRet := .F.
		EndIf
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 1

	Private _oFontP 		:= TFont():New('Arial',,12)
	Private _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Private _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	Private _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Private _oFontGG		:= TFont():New('Arial',,45,.T.,.T.)

	Private _nCol01		:= 020
	Private _nCol02		:= _nColPrivate01 + 700
	Private _nCol03		:= _nCol01 + 2000
	Private _nNextLin		:= 50
	Private _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM") 
	Private _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Private _cDescPro1	:= ""
	Private _cDescPro2	:= ""
	Private _cDescPro3	:= ""

	_oPrinter := FWMSPrinter():New('M04E05' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)

	_oPrinter:SetResolution(78)
	_oPrinter:SetLandscape()
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:SayBitMap( _nRow + 110 , 100 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)
	_oPrinter:SayBitMap( _nRow + 110 , 1500 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)

	_nRow += _nNextLin * 2.6

	_nRow += _nNextLin * 0.9
	
	_oPrinter:Say(_nRow + 85 ,_nCol01 + 150 , "Grupo HOSHIZAKI",_oFontMI)
	_oPrinter:Say(_nRow + 85 ,_nCol01 + 1550 , "Grupo HOSHIZAKI",_oFontMI)
	
	_oPrinter:Say(_nRow ,_nCol02 , "Aços Macom Ind. e Com. Ltda",_oFontM)
	_oPrinter:Say(_nRow ,_nCol03 + 95 , "Aços Macom Ind. e Com. Ltda",_oFontM)
	
	_oPrinter:Say(_nRow + _nNextLin ,_nCol02 , "CNPJ: 43.553.668/0001-79",_oFontM)
	_oPrinter:Say(_nRow + _nNextLin ,_nCol03 + 95 , "CNPJ: 43.553.668/0001-79",_oFontM)
	
	_oPrinter:Say(_nRow + _nNextLin + 50 ,_nCol02 , "Tel.: (11) 2085-7000",_oFontM)
	_oPrinter:Say(_nRow + _nNextLin + 50 ,_nCol03 + 95 , "Tel.: (11) 2085-7000",_oFontM)

	If Len(_cDescPro) > 45
		_cDescPro1 := Substr(_cDescPro,1,44)
		_cDescPro2 := Alltrim(Substr(_cDescPro,45,54))
		_cDescPro3 := AllTrim(Substr(_cDescPro,99,54))
		_oPrinter:Say(_nRow + _nNextLin + 150,_nCol01 + 100 ,"Desc.: " + _cDescPro1,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 150,_nCol01 + 1500 ,"Desc.: " + _cDescPro1,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 200,_nCol01 + 100 ,_cDescPro2,_oFontM)		
		_oPrinter:Say(_nRow + _nNextLin + 200,_nCol01 + 1500 ,_cDescPro2,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 250,_nCol01 + 100 ,_cDescPro3,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 250,_nCol01 + 1500 ,_cDescPro3,_oFontM)
	Else
		_oPrinter:Say(_nRow + _nNextLin + 150 ,_nCol01 + 100 , "Desc.: " + _cDescPro,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 150 ,_nCol01 + 1500 , "Desc.: " + _cDescPro,_oFontM)
	Endif	
	
	_oPrinter:Say(_nRow + _nNextLin + 400 ,_nCol01 + 100 , AllTrim(_cCodProd),_oFontGG)
	_oPrinter:Say(_nRow + _nNextLin + 400 ,_nCol01 + 1500 , AllTrim(_cCodProd),_oFontGG)

	_oPrinter:FWMSBAR('CODE128',15.0/*nRow*/,13/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	_oPrinter:FWMSBAR('CODE128',15.0/*nRow*/,45/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	
	_oPrinter:Say(_nRow + _nNextLin + 755 ,_nCol01 + 75 , "Serial: " + _cNumSer,_oFontM)
	_oPrinter:Say(_nRow + _nNextLin + 755 ,_nCol01 + 1520 , "Serial: " + _cNumSer,_oFontM)
	
	_oPrinter:FWMSBAR('CODE128',22.0/*nRow*/,2.0/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	_oPrinter:FWMSBAR('CODE128',22.0/*nRow*/,36/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	
			
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 		:= 'ZEBRA_S4M'

	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
Return
