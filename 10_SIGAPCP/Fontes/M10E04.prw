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

	BeginTran()

	M02EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	//M02EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

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
	
	Private _oPrinter		:= Nil
	Private _nRow 		:= 90
	
	Private _oFontP 		:= TFont():New('Arial',,12)
	Private _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Private _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	Private _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Private _oFontGG		:= TFont():New('Arial',,24,.T.,.T.)

	Private _nCol01		:= 020
	Private _nCol02		:= _nCol01 + 430
	Private _nCol03		:= _nCol01 + 700
	Private _nNextLin		:= 50
	Private _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM") 
	Private _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Private _cDescPro1	:= SubStr(_cDescPro,1,64)
	Private _cDescPro2	:= SubStr(_cDescPro,65,129)
	Private _dDtFab		:= Posicione("SD3",18,xFilial("SD3")+ AllTrim(_cNumSer), "D3_EMISSAO")
	Private _cINMETRO		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XINMETR")
	Private _cFamilia		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XFAMILI")	
	Private _cTpFluido	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFLUIDO")
	Private _cPotencia	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPOTENC")
	Private _cClClima		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCLASCL")
	Private _cTensao		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XTENSAO")
	Private _cCategoria	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCATEGO")
	Private _cTpGas		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGAS")
	Private _cGrProtecao	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGPROT")
	Private _cCorrente	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCORNT")
	Private _lRetusr		:= .T.
	//Private _cUsers		:= "000247|000228|000131|000151|000024|000259|000486"
	Private _cPedido		:= ZAB->ZAB_NUMPV
	Private _cOP			:= ZAB->(ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP)
	//Local _cCliente		: Posicione("SC5",1,xFilial("SC5")+ZAB->ZAB_NUMCLI,"C5_CLIENTE")+Posicione("SC5",1,xFilial("SC5")+ZAB->ZAB_LOJCLI,"C5_LOJACLI")
			
	//If Empty (_dDtFab)
		//MsgStop("Não é possível emitir a etiqueta, apontamento não realizado","Atenção")
	//Else
	
	If ! RetCodUsr() $ GETMV("MV_XPALB08") //_cUsers
		lRetusr	:= .F.
		MsgStop("Não é possível emitir a etiqueta, usuário não autorizado","Atenção")
	Else
		_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)
		_oPrinter:SetResolution(78)
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:StartPage()

		_oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)
		_oPrinter:Say(_nRow + 100 , 70 , "Grupo HOSHIZAKI",_oFontMI)
		_oPrinter:Say(_nRow ,800 , "Aços Macom Ind. e Com. Ltda",_oFontP)
		_oPrinter:Say(_nRow += _nNextLin ,800 , "CNPJ: 43.553.668/0001-79",_oFontP)
		_oPrinter:Say(_nRow + _nNextLin ,800 , "Telefone: (011) 2085-7000",_oFontP)
		_oPrinter:Say(_nRow + 140 ,70, "Modelo: ",_OFontP)
		_oPrinter:Say(_nRow + 140 , 250, Alltrim(_cCodProd),_OFontGG)
		_oPrinter:Say(_nRow + 510 , 70, "OP.: ",_OFontP)
		_oPrinter:Say(_nRow + 510 , 150, AllTrim(_cOP) ,_OFontP)
		_oPrinter:Say(_nRow + 390 , 70, "BCode OP: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',12.9/*nRow*/,1.5/*nCol*/,AllTrim(_cOP),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		//_oPrinter:Say(_nRow + 400 , 600, "Data OF.:" ,_OFontP)
		//_oPrinter:Say(_nRow + 400 , 1000, DTOC(_dDtFab) ,_OFontP)
		_oPrinter:Say(_nRow + 510 , 700, "Pedido.:" ,_OFontP)
		_oPrinter:Say(_nRow + 510 , 880, AllTrim(_cPedido) ,_OFontP)
		//_oPrinter:Say(_nRow + 470 , 800, "Cliente.:" ,_OFontP)
		_oPrinter:Say(_nRow + 180 , 70, "BCode Model: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',7.8/*nRow*/,1.5/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		_oPrinter:Say(_nRow + 180 , 700, "Nº de Série: " ,_OFontP)
		_oPrinter:Say(_nRow + 180 , 880, Alltrim(_cNumSer) ,_OFontGG)
		_oPrinter:Say(_nRow + 278 , 700, "BCode Serial: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',10.2/*nRow*/,15.5/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		//_oPrinter:Say(_nRow + 525 , 270, Alltrim(_cNumSer),_OFontGG)
				
		//If _cINMETRO =="1"
			//_oPrinter:SayBitMap( _nRow + 260, 1000 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 50 * 4.0 , 50 * 4.0)
		//Endif
		
		_oPrinter:Say(_nRow + 560 , 70, "DESCRICAO.: " ,_OFontP)
		_oPrinter:Say(_nRow + 605 , 70, _cDescPro1 ,_OFontP)
		_oPrinter:Say(_nRow + 645 , 70, _cDescPro2 ,_OFontP)
		_oPrinter:Say(_nRow + 685 , 70, "FGQ-FB-008" ,_OFontP) 			//#5006
		//_oPrinter:Say(_nRow + 685 , 1030, "FGQ-008 Rev.01" ,_OFontP)	//#5006
		_oPrinter:Say(_nRow + 685 , 1030, "REV.:00" ,_OFontP)			//#5006
		/*If _cFamilia == "000001"
			_oPrinter:Say(_nRow + 605 , 70, "Fluído Refrigerante: " + IIF(_cTpFluido == "1", "R134a", "R404A")  ,_OFontP)
			_oPrinter:Say(_nRow + 645 , 70, "Carga de Fluído: g", _OFontP)
			_oPrinter:Say(_nRow + 685 , 70, "Potência: " + _cPotencia, _OFontP)
			
			_oPrinter:Say(_nRow + 605 , 550, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
			_oPrinter:Say(_nRow + 645 , 550, "Classe Climática: " + IIF(_cClClima == "1", "4", "6"), _OFontP)
			_oPrinter:Say(_nRow + 685 , 550, "Corrente: " + _cCorrente + " A", _OFontP)
			
			_oPrinter:Say(_nRow + 605 , 950, "Tensão: " + IIF(_cTensao == "1", "220V 60Hz 1~", "220 60Hz 3~"), _OFontP)
		EndIf
		
		If _cFamilia == "000002"
			If _cCategoria == "1"
				
				_oPrinter:Say(_nRow + 645 , 70, "Gás: " + IIF(_cTpGas== "1", "GN", "GLP"), _OFontP)
							
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 950, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)
			Else
				_oPrinter:Say(_nRow + 645 , 70, "Tensão: " + IIF(_cTensao == "1", "220V 60Hz 1~", "220 60Hz 3~"), _OFontP)
				_oPrinter:Say(_nRow + 685 , 70, "Corrente: " + _cCorrente + " A",_OFontP)
				
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 950, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)
			EndIf
		EndIf*/
				
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:cPrinter 	:= 'ZEBRA'

		_oPrinter:EndPage()
		_oPrinter:Print()

		FreeObj(_oPrinter)
		
	RecLock("ZAB", .F.)
	ZAB->ZAB_ETQCKL := (ZAB_ETQCKL + 1)
	MsUnlock()
	//EndIf
	EndIf
Return
