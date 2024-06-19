#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10E03()
	Private _oDlg		:= Nil
	Private _nOpca	:= 0
	Private _cTitulo	:= 'Etiqueta Ident. Produto' 

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
	
	
	/*If ZAB->ZAB_ETQINT > 0
		MsgAlert("Etiqueta já impressa!","Atenção")
	Else*/
			M02EMain(ZAB->ZAB_CODPROD,1,"", 1, ZAB->ZAB_NUMSER)
	//EndIf
	
	
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BeginTran()

			M02EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	
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
	
	Local _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	
	Local _oFontGG		:= TFont():New('Arial',,24,.T.,.T.)

	Local _cDescCat     := ""
	Local _cTxFluido    := ""
	Local _nCol01		:= 020
	
	Local _nNextLin		:= 50
	
	Local _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Local _cDescPro1	:= SubStr(_cDescPro,1,64)
	Local _cDescPro2	:= SubStr(_cDescPro,65,129)
	Local _dDtFab		:= dDataBase // Retirado pois aparentemente pega a data de emissão Posicione("SD3",18,xFilial("SD3")+ AllTrim(_cNumSer), "D3_EMISSAO")
	Local _cINMETRO		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XINMETR")
	Local _cFamilia		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XFAMILI")	
	Local _cTpFluido	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFLUIDO")
	Local _cVlrFluido	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFLUID")
	Local _cPotencia	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPOTENC")
	Local _cClClima		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCLASCL")
	Local _cTensao		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XTENSAO")
	Local _cCategoria	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCATEGO")
	Local _cTpGas		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGAS")
	Local _cGrProtecao	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGPROT")
	Local _cCorrente	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCORNT")
	Local _cConsumo	    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCONSUM")
	Local _cFreq    	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFREQNT")
	Private _lRetusr		:= .T.
	Private _cUsers		:= "000247|000228|000131|000151|000024|000259|000325|000486"
	Private _cQRCode		:= AllTrim(Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XURL"))
	Private _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM") 		
	Private _nCol02		:= _nCol01 + 430
	Private _nCol03		:= _nCol01 + 700
	Private _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Private _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Private _cPdeGelo		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPDGELO")	//6033

    Do Case 
    	Case _cClClima == "1"
    		 _cClClima := "4"     	
    	Case _cClClima == "2"
    	     _cClClima := "6"
    	Case _cClClima == "3"
    	     _cClClima := "ST"
		Case _cClClima == "4"	//#4410
    	     _cClClima := "5"	//#4410
    EndCase
    
   Do Case 						//6033
    	Case _cPdeGelo == "1"
    		 _cPdeGelo := "150W"   
    	Case _cPdeGelo == "2"	//6386
    		 _cPdeGelo := "400W"    	
    	Case _cPdeGelo == "3"	//6386
    		 _cPdeGelo := "500W" 
		Case _cPdeGelo == "4"	//6633
			 _CPdeGelo := "300W"  	
    EndCase

	
    Do Case
    	Case _cCategoria == "1"
    		 _cDescCat   := "Gas"
    	Case _cCategoria == "2"
    	 	 _cDescCat   := "Eletrico"
    	Case _cCategoria == "3"
    		 _cDescCat   := "Carvao"
    End Case
  
	Do Case 
    	Case _cTensao == "1"
    		 _cTensao := "220V ~ 3"     	
    	Case _cTensao == "2"
    	     _cTensao := "220V ~ 1"
    	Case _cTensao == "3"
    	     _cTensao := "127V ~ 1"
    	Case _cTensao == "4"
    		 _cTensao := "380V ~ 3"
    	Case _cTensao == "5"
    		 _cTensao := "115V ~ 1"
    	Case _cTensao == "6"			//5078
    		 _cTensao := "380V ~ 3N"	//5078
    EndCase

	Do Case 
    	Case _cFreq == "1"
    		 _cFreq := "50 Hz"     	
    	Case _cFreq == "2"
    	     _cFreq := "60 Hz"
    	Case _cFreq == "3"
    	     _cFreq := "50/60 Hz"
    EndCase
	

	/*If ! RetCodUsr() $ _cUsers
		lRetusr	:= .F.
		MsgStop("Não é possível emitir a etiqueta, usuário não autorizado","Atenção")
	Else*/
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
		_oPrinter:Say(_nRow + 140 , 200, Alltrim(_cCodProd),_OFontGG)
		_oPrinter:Say(_nRow + 190 , 70, "Desc.: ",_OFontP)
		_oPrinter:Say(_nRow + 190 , 200, _cDescPro1 ,_OFontP)
		_oPrinter:Say(_nRow + 240 , 200, _cDescPro2 ,_OFontP)
		_oPrinter:Say(_nRow + 290 , 70, "BCode Model: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',9.4/*nRow*/,6/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		_oPrinter:Say(_nRow + 370 , 70, "Data Fab: " + AllTrim(DTOC(_dDtFab)) ,_OFontP)
		//_oPrinter:Say(_nRow + 370 , 200, DTOC(_dDtFab) ,_OFontP)
		_oPrinter:Say(_nRow + 450 , 70, "BCode Serial: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',12.4/*nRow*/,6/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
//12.9
		_oPrinter:QrCode(625,810,_cQRCode, 070)

		_oPrinter:Say(_nRow + 505 , 270, Alltrim(_cNumSer),_OFontGG) //525
		_oPrinter:Say(_nRow + 685 , 1030, "FGQ-025 Rev.00", _OFontP)
		
		If _cINMETRO =="1"
			_oPrinter:SayBitMap( _nRow + 260, 1080 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 60 * 2.5 , 60 * 2.5)
		Endif
		
		_oPrinter:Say(_nRow + 530 , 450, "ESPECIFICAÇÕES TÉCNICAS: " ,_OFontP) //560
	
		If _cFamilia == "000001"
            If _cTpFluido == "1"
             		_cTxFluido := "R134a"
            ElseIf _cTpFluido == "2"
              		_cTxFluido := "R404A"
            ElseIf _cTpFluido == "3"
                    _cTxFluido := "R404A/R134a"
            ElseIf _cTpFluido == "4"			//#5495
                    _cTxFluido := "R290"		//#5495
			ElseIf _cTpFluido == "5"			//#5917
                    _cTxFluido := "R452A"		//#5917		

            Endif        
                    
			_oPrinter:Say(_nRow + 575 , 70, "Fluído Refrigerante: " + _cTxFluido ,_OFontP)
			_oPrinter:Say(_nRow + 615 , 70, "Carga de Fluído: "     + _cVlrFluido + "g", _OFontP)
			_oPrinter:Say(_nRow + 655 , 70, "Potência: " 			+ _cPotencia, _OFontP)
			
			_oPrinter:Say(_nRow + 575 , 450, "Potência degelo: " 	+ _cPdeGelo , _OFontP)			//#6033
			_oPrinter:Say(_nRow + 615 , 450, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
			_oPrinter:Say(_nRow + 655 , 450, "Classe Climática: " 	+ _cClClima , _OFontP)

			_oPrinter:Say(_nRow + 575 , 800, "Corrente: " 			+ _cCorrente + " A", _OFontP)
			_oPrinter:Say(_nRow + 615 , 800, "Tensão: " 			+ _cTensao, _OFontP)
			_oPrinter:Say(_nRow + 655 , 800, "Frequência: " 		+ _cFreq, _OFontP)

		EndIf

		If _cFamilia == "000004"
            If _cTpFluido == "1"
             		_cTxFluido := "R134a"
            ElseIf _cTpFluido == "2"
              		_cTxFluido := "R404A"
            ElseIf _cTpFluido == "3"
                    _cTxFluido := "R404A/R134a"
			ElseIf _cTpFluido == "4"			//#5495
                    _cTxFluido := "R290"		//#5495
			ElseIf _cTpFluido == "5"			//#5917
                    _cTxFluido := "R452A"		//#5917	
            Endif        
                    
			_oPrinter:Say(_nRow + 605 , 70, "Fluído Refrigerante: " + _cTxFluido ,_OFontP)
			_oPrinter:Say(_nRow + 645 , 70, "Carga de Fluído: " + _cVlrFluido + "g", _OFontP)
			_oPrinter:Say(_nRow + 685 , 70, "Potência: " + _cPotencia, _OFontP)
			
			_oPrinter:Say(_nRow + 605 , 550, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
			_oPrinter:Say(_nRow + 645 , 550, "Classe Climática: " + _cClClima , _OFontP)
			_oPrinter:Say(_nRow + 685 , 550, "Corrente: " + _cCorrente + " A", _OFontP)
			
			_oPrinter:Say(_nRow + 605 , 950, "Tensão: " + _cTensao, _OFontP)
			_oPrinter:Say(_nRow + 645 , 950, "Frequência: " + _cFreq, _OFontP)
		EndIf
		
		If _cFamilia == "000002"
			If _cCategoria == "1"
				_oPrinter:Say(_nRow + 645 , 70, "Gás: " + IIF(_cTpGas== "1", "GN", "GLP"), _OFontP)
	
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Consumo: " + _cConsumo, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + _cTensao + " " + _cFreq, _OFontP)

			ElseIf _cCategoria == "2"
				//_oPrinter:Say(_nRow + 645 , 70, "Tensão: " + _cTensao, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Corrente: " + _cCorrente + " A",_OFontP)
				
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + _cTensao + " " + _cFreq, _OFontP)
				
			ElseIf _cCategoria == "3"
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Consumo: " + _cConsumo, _OFontP)
			EndIf
		EndIf
				
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:cPrinter 		:= 'ZEBRA'

		_oPrinter:EndPage()
		_oPrinter:Print()

		FreeObj(_oPrinter)
		
	RecLock("ZAB", .F.)
			ZAB->ZAB_ETQINT := (ZAB_ETQINT + 1)
	MsUnlock()
	//EndIf
	//EndIf
Return
