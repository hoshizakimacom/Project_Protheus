#INCLUDE "TOTVS.CH"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'
#Include "Protheus.ch"
#include "Topconn.ch"
 
/*/{Protheus.doc} M10A06
Função Gerar o número de série e etiquetas para a O.P.
Alterei o fonte para criação de tela através do componente oDlg
Chamado 2123
@author Graziella Baicnchin
@since 07/12/2022
@version 1.0
@type function
*/

User Function M10A06()                        
	Local _oDlg		:= Nil
	Local _cTitulo	:= 'Gera N.S. e Etiquetas dos Produtos da O.P.'

	Local _cCodOpi	:= Space(11)
	Local cCodOpf	:= Space(11)
	Local nComboBo1 := '1'
	
	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

	@ 002,002 TO 200, 400 OF _oDlg PIXEL

	@ 020,010 SAY 'O.P. Inicial:' SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodOpi SIZE 80, 11 F3 'SC2' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'O.P. Final..:' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET cCodOpf SIZE 80, 11 F3 'SC2'OF _oDlg Picture '@!' PIXEL
	
    @ 053, 009 SAY "Gera Numero de Serie e Etiqueta?" SIZE 043, 015 OF _oDlg PIXEL
    @ 057, 070 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1-Sim","2-Não"} SIZE 072, 015 OF _oDlg PIXEL

	DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION U_M10A06G(@_cCodOpi,@cCodOpf,SUBSTRING(@nComboBo1,1,1)) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION _oDlg:End() ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return


User Function M10A06G(cGet1,cGet2,nComboBo1)

Local _cDeOP   	:= cGet1
Local _cAteOP  	:= cGet2
Local _cTpGera 	:= nComboBo1
Local _nRegSC2 	:= 0
Local _cQuery  	:= ""
Local _nRegZAB  := 0
Local _cNumSer  := ""
Private _cOp	 := ""
Private _cItem	 := ""
Private _cSequen := ""

_cDeOP   := Alltrim(cGet1)
_cAteOP  := Alltrim(cGet2)
_cTpGera := nComboBo1
_cQuery  := ""
_nRegSC2 := 0
_nRegZAB := 0

   	If _cTpGera = '1' // gera numero de serie e imprime etiquetas
		_cQuery:= "SELECT C2_FILIAL, C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_PRODUTO, C2_QUANT,C2_QUJE "
		_cQuery+= "FROM "+RetSqlName("SC2")+" SC2 "
		_cQuery+= "WHERE C2_FILIAL = '"+xFilial("SC2")+"' "
		_cQuery+= "AND C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+_cDeOP +"' " 
		_cQuery+= "AND C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+_cAteOP+"' "
		_cQuery+= "AND D_E_L_E_T_ = '' "

   		TcQuery _cQuery New Alias (cAlias := GetNextAlias())
		(cAlias)->(DbEval({|| _nRegSC2 ++ }))
		(cAlias)->(DbGoTop())

		While ! (cAlias)->(Eof())
			cProduto 	:= (cAlias)->C2_PRODUTO
			_nQtdOP		:= (cAlias)->C2_QUANT
			_nQtdJE		:= (cAlias)->C2_QUJE
			_cOp		:= (cAlias)->C2_NUM
			_cItem		:= (cAlias)->C2_ITEM
			_cSequen	:= (cAlias)->C2_SEQUEN

			DbSelectArea("ZAB")
			DbSetOrder(2)
			//ZAB_FILIAL, ZAB_NUMOP, ZAB_ITEMOP, ZAB_SEQOP, R_E_C_N_O_, D_E_L_E_T_
			If !(ZAB->(MSSeek(xFILIAL("ZAB")+_cOp+_cItem+_cSequen)))
				FWMsgRun(, {|| _lRet := U_M10A061(cProduto,_nQtdOP,_nQtdJE, _cOp, _cItem, _cSequen)},,'Gerando Números de série ...')
			else
				MsgAlert("Números de Série já gerados para a O.P. em questão " +  _cOp+_cItem+_cSequen +  ". ", "Geração de Número de Série")
			Endif
		    (cAlias)->(DbSkip())
		Enddo
		(cAlias)->(DbCloseArea())

    Else // imprime somente as etiquetas

		_cQuery:= " SELECT * "
		_cQuery+= "FROM "+RetSqlName("ZAB")+" ZAB "
		_cQuery+= "WHERE ZAB_FILIAL = '"+xFILIAL("ZAB")+"' "
		_cQuery+= "  AND ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP >= '"+_cDeOP +"' " 
		_cQuery+= "  AND ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP <= '"+_cAteOP+"' "
		_cQuery+= "  AND D_E_L_E_T_ = '' "

		TcQuery _cQuery New Alias (cAlias := GetNextAlias())
		(cAlias)->(DbEval({|| _nRegZAB ++ }))
		(cAlias)->(DbGoTop())

		While ! (cAlias)->(Eof())

			cProduto 	:= (cAlias)->ZAB_CODPRO
			_nQtdOP		:= Posicione("SC2",1, xFilial("SC2") + (cAlias)->ZAB_NUMOP+ (cAlias)->ZAB_ITEMOP+(cAlias)->ZAB_SEQOP,"C2_QUANT")
//			_cOP		:= (cAlias)->(ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP)
			_cOP		:= (cAlias)->(ZAB_NUMOP)
			_cItem		:= (cAlias)->(ZAB_ITEMOP)
			_cSequen	:= (cAlias)->(ZAB_SEQOP)

			For _nRegZAB := 1 to _nQtdOP
				_cNumSer	:= (cAlias)->ZAB_NUMSER

				M02EPrin(cProduto,_nQtdOP,_cNumSer)

				M02EPri1(cProduto,_nQtdOP,_cNumSer)
				M02EPri1(cProduto,_nQtdOP,_cNumSer)

				(cAlias)->(DbSkip())
			Next
		 	
		Enddo	
		(cAlias)->(DbCloseArea())
    Endif
Return


User Function M10A061(cProduto,_nQtdOP,_nQtdJE, _cOp, _cItem, _cSequen)

Local _cNumSer 	:= ""
Local _cAno		:= ""
Local _cMes		:= ""
Local _nSerial 	:= GetMV("AM_NUMSER")
Local _nAno		:= year(ddatabase)
Local _nMes		:= month(ddatabase)
Local _cFamilia := Posicione("SB1",1, xFilial("SB1") + cProduto,"B1_XFAMILI")

Local _nX		:= 0
Local _lRet		:= .T.
Local _n1		:= 0
Local _n2		:= 0

DBSelectArea("ZAB")
DBSetOrder(2)

If _nQtdJE <> 0
	MsgStop("-Não é possível a geração de Número(s) de Série, para Ordem de Produção Encerrada ou Iniciada ", "Atenção")
	_lRet := .F.
Else
	If ! _cFamilia $ "000001|000002|000003|000004"
		MsgStop("Só é possível gerar Número(s) de Série para as Famílias Cocção, Mobiliário e Refrigeração ", "Atenção")
	Else
		Do Case
			Case _nAno == 2015
				_cAno := "A"
		 	Case _nAno == 2016
		 		_cAno := "B"
			Case _nAno == 2017
				_cAno := "C"
			Case _nAno == 2018
				_cAno := "D"
			Case _nAno == 2019
				_cAno := "E"
			Case _nAno == 2020
				_cAno := "F"
			Case _nAno == 2021
				_cAno := "G"
			Case _nAno == 2022
				_cAno := "H"
			Case _nAno == 2023
				_cAno := "I"
			Case _nAno == 2024
				_cAno := "J"		 
			Case _nAno == 2025
				_cAno := "K"
			Case _nAno == 2026
				_cAno := "L"
			Case _nAno == 2027
				_cAno := "M"
			Case _nAno == 2028
				_cAno := "N"
			Case _nAno == 2029
				_cAno := "O"
			Case _nAno == 2030
				_cAno := "P"
			Case _nAno == 2031
				_cAno := "Q"
			Case _nAno == 2032
				_cAno := "R"
			Case _nAno == 2033
				_cAno := "S"
			Case _nAno == 2034
				_cAno := "T"
			Case _nAno == 2035
				_cAno := "U"
			Case _nAno == 2036
				_cAno := "V"
			Case _nAno == 2037
				_cAno := "X"
			Case _nAno == 2038
				_cAno := "Y"
			Case _nAno == 2039
				_cAno := "W"
			Case _nAno == 2040
				_cAno := "Z"
		EndCase

		Do Case
			Case _nMes == 1
				_cMes := "A"
			Case _nMes == 2
				_cMes := "B"
			Case _nMes == 3
				_cMes := "C"
			Case _nMes == 4
				_cMes := "D"
			Case _nMes == 5
				_cMes := "E"
			Case _nMes == 6
				_cMes := "F"
			Case _nMes == 7
				_cMes := "G"
			Case _nMes == 8
				_cMes := "H"
			Case _nMes == 9
				_cMes := "I"
			Case _nMes == 10
				_cMes := "J"
			Case _nMes == 11
				_cMes := "K"
			Case _nMes == 12
				_cMes := "L"
		EndCase
		
		DBSelectArea("ZAB")
		DBSetOrder(1)
		dbGoTo(Lastrec())
				
		If Substr(ZAB->ZAB_NUMSER, 9,1) <> _cMes
			_nSerial := "0"
		EndIf

		_nSerial := Val(_nSerial)


		For _nX:=1 to _nQtdOP
			Sleep(500)				
			_nSerial ++ 
			_cNumSer := "1" + _cAno + strzero(_nSerial,6) + _cMes
            If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
				_n2++
            Else
                Reclock("ZAB",.T.)
                ZAB->ZAB_FILIAL := xFilial("ZAB")
                ZAB->ZAB_NUMSER	:= _cNumSer
                ZAB->ZAB_CODPRO	:= cProduto
                ZAB->ZAB_NUMOP	:= _cOP 
                ZAB->ZAB_ITEMOP	:= _cItem
                ZAB->ZAB_SEQOP	:= _cSequen
                ZAB->(MsUnlock())

                DBSelectArea("SX6")
                GetMV("AM_NUMSER")
                RecLock("SX6",.F.)
                X6_CONTEUD := Alltrim(STR(_nSerial))
                MsUnlock()

				M02EPrin(cProduto,_nQtdOP, _cNumSer)  // 025 - 1X
				M02EPri1(cProduto,_nQtdOP, _cNumSer)  // 008 - 2X
				M02EPri1(cProduto,_nQtdOP, _cNumSer)

				_n1++
            Endif
		Next _nX
		
		if _n1 > 0 
			MsgStop("Número(s) de Série gerados com sucesso. ", "Atenção")
		Endif

		If _n2 > 0
			MsgStop("Não existem Número(s) de Série para serem gerados. ", "Atenção")
		Endif

	Endif
EndIf

Return(_lRet)


Static Function M02EPrin(_cCodOpi,_nQtd,_cNumSer)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 90
	
	Local _oFontP 		:= TFont():New('Arial',,12)
	Local _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	Local _oFontGG		:= TFont():New('Arial',,24,.T.,.T.)

	Local _cDescCat     := ""
	Local _cTxFluido    := ""
	Local _nNextLin		:= 50
	Local _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodOpi,"B1_DESC")
	Local _cDescPro1	:= SubStr(_cDescPro,1,64)
	Local _cDescPro2	:= SubStr(_cDescPro,65,129)
	Local _dDtFab		:= dDataBase // Retirado pois aparentemente pega a data de emissão Posicione("SD3",18,xFilial("SD3")+ AllTrim(_cNumSer), "D3_EMISSAO")
	Local _cINMETRO		:= Posicione("SB1",1,xFilial("SB1")+ _cCodOpi, "B1_XINMETR")
	Local _cFamilia		:= Posicione("SB1",1,xFilial("SB1")+ _cCodOpi, "B1_XFAMILI")	
	Local _cTpFluido	:= ALLTRIM(Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XFLUIDO"))
	Local _cVlrFluido	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XFLUID")
	Local _cPotencia	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XPOTENC")
	Local _cClClima		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCLASCL")
	Local _cTensao		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XTENSAO")
	Local _cCategoria	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCATEGO")
	Local _cTpGas		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XGAS")
	Local _cGrProtecao	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XGPROT")
	Local _cCorrente	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCORNT")
	Local _cConsumo	    := Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCONSUM")
	Local _cFreq    	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XFREQNT")
	Local _cQRCode		:= AllTrim(Posicione("SB1",1,xFilial("SB1")+_cCodOpi,"B1_XURL"))
	Local _cPdeGelo		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XPDGELO")	
	//MSGSTOP( _cTpFluido)

    Do Case 
    	Case _cClClima == "1"
    		 _cClClima := "4"     	
    	Case _cClClima == "2"
    	     _cClClima := "6"
    	Case _cClClima == "3"
    	     _cClClima := "ST"
		Case _cClClima == "4" // #4410
    	     _cClClima := "5" // #4410
    EndCase

   Do Case 						//6033
    	Case _cPdeGelo == "1"
    		 _cPdeGelo := "150W" 
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
    	     _cFreq := "60Hz"
    	Case _cFreq == "3"
    	     _cFreq := "50/60 Hz"
    EndCase
	

		_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,1)
		_oPrinter:SetResolution(78)
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:StartPage()

		_oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)
		_oPrinter:Say(_nRow + 100 , 70 , "Grupo HOSHIZAKI",_oFontMI)
		_oPrinter:Say(_nRow ,800 , "Aços Macom Ind. e Com. Ltda",_oFontP)
		_oPrinter:Say(_nRow += _nNextLin ,800 , "CNPJ: 43.553.668/0001-79",_oFontP)
		_oPrinter:Say(_nRow + _nNextLin ,800 , "Telefone: (011) 2085-7000",_oFontP)
		_oPrinter:Say(_nRow + 140 ,70, "Modelo: ",_OFontP)
		_oPrinter:Say(_nRow + 140 , 200, Alltrim(_cCodOpi),_OFontGG)
		_oPrinter:Say(_nRow + 190 , 70, "Desc.: ",_OFontP)
		_oPrinter:Say(_nRow + 190 , 200, _cDescPro1 ,_OFontP)
		_oPrinter:Say(_nRow + 240 , 200, _cDescPro2 ,_OFontP)
		_oPrinter:Say(_nRow + 290 , 70, "BCode Model: " ,_OFontP)

		
		_oPrinter:FWMSBAR('CODE128',9.4/*nRow*/,6/*nCol*/,AllTrim(_cCodOpi),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)

		//_oPrinter:QrCode(625,920,_cQRCode, 050)  // *** Valdemir - 03/03/2023 *** //

		//_oPrinter:QrCode(655,820,_cQRCode, 050)  // *** Valdemir - 02/03/2023 *** //
		//_oPrinter:QrCode(625,810,_cQRCode, 070)
		//_oPrinter:QRCode(_nRow + 500 ,  810, _cQRCode,070)
		//_oPrinter:QRCode(_nRow + 500 , 2100, _cQRCode,070)

		_oPrinter:Say(_nRow + 370 , 70, "Data Fab: " + AllTrim(DTOC(_dDtFab)) ,_OFontP)
		_oPrinter:Say(_nRow + 450 , 70, "BCode Serial: " ,_OFontP)
		_oPrinter:FWMSBAR('CODE128',12.4/*nRow*/,6/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		_oPrinter:Say(_nRow + 505 , 270, Alltrim(_cNumSer),_OFontGG)
		_oPrinter:Say(_nRow + 685 , 1030, "FGQ-025 Rev.00", _OFontP)
		
		If _cINMETRO =="1"
			_oPrinter:SayBitMap( 500, 800 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 30 * 4.0 , 30 * 4.0) // *** Valdemir - 03/03/2023 *** //
			//_oPrinter:SayBitMap( _nRow + 260, 1000 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 60 * 4.0 , 60 * 4.0)
		Endif

		_oPrinter:QrCode(635,950,_cQRCode, 070)  // *** Valdemir - 03/03/2023 *** //
		
		_oPrinter:Say(_nRow + 530 , 450, "ESPECIFICAÇÕES TÉCNICAS: " ,_OFontP)
	
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
			
			_oPrinter:Say(_nRow + 605 , 950, "Tensão: " + UPPER(_cTensao), _OFontP)
			_oPrinter:Say(_nRow + 645 , 950, "Frequência: " + _cFreq, _OFontP)
		EndIf
		
		If _cFamilia == "000002"
			If _cCategoria == "1"
				_oPrinter:Say(_nRow + 645 , 70, "Gás: " + IIF(_cTpGas== "1", "GN", "GLP"), _OFontP)
	
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Consumo: " + _cConsumo, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + upper(_cTensao) + " " + _cFreq, _OFontP)

			ElseIf _cCategoria == "2"
				//_oPrinter:Say(_nRow + 645 , 70, "Tensão: " + _cTensao, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Corrente: " + _cCorrente + " A",_OFontP)
				
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + UPPER(_cTensao) + " " + _cFreq, _OFontP)
				
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
	/*
	If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
		RecLock("ZAB", .F.)
		ZAB->ZAB_ETQINT := (ZAB_ETQINT + 1)
		MsUnlock()	
	Endif*/
Return

//+----------------------------------------------------------------------------------------------------------------
//Static Function M02EPri1(_cCodOpi,_nQtd,_cNumSer,_cItem,_cSequen)
Static Function M02EPri1(_cCodOpi,_nQtd,_cNumSer)

	Local _oPrinter		:= Nil
	Local _nRow 		:= 90
	
	Local _oFontP 		:= TFont():New('Arial',,12)
	//Local _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Local _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	//Local _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Local _oFontGG		:= TFont():New('Arial',,24,.T.,.T.)

	//Local _nCol01		:= 020
	//Local _nCol02		:= _nCol01 + 430
	//Local _nCol03		:= _nCol01 + 700
	Local _nNextLin		:= 50
	//Local _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodOpi,"B1_UM") 
	Local _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodOpi,"B1_DESC")
	Local _cDescPro1	:= SubStr(_cDescPro,1,64)
	Local _cDescPro2	:= SubStr(_cDescPro,65,129)
	/*Local _dDtFab		:= Posicione("SD3",18,xFilial("SD3")+ AllTrim(_cNumSer), "D3_EMISSAO")
	Local _cINMETRO		:= Posicione("SB1",1,xFilial("SB1")+ _cCodOpi, "B1_XINMETR")
	Local _cFamilia		:= Posicione("SB1",1,xFilial("SB1")+ _cCodOpi, "B1_XFAMILI")	
	Local _cTpFluido	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XFLUIDO")
	Local _cPotencia	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XPOTENC")
	Local _cClClima		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCLASCL")
	Local _cTensao		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XTENSAO")
	Local _cCategoria	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCATEGO")
	Local _cTpGas		:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XGAS")
	Local _cGrProtecao	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XGPROT")
	Local _cCorrente	:= Posicione("SB5",1,xFilial("SB5")+ _cCodOpi, "B5_XCORNT")
	Local _lRetusr		:= .T.*/
	Local _cPedido		:= ZAB->ZAB_NUMPV  //#7032	
//	Local _cItem		:= ZAB->ZAB_ITEMOP
//	Local _cSequen	    := ZAB->ZAB_SEQOP
	
	_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,1)
	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)
	_oPrinter:Say(_nRow + 100 , 70 , "Grupo HOSHIZAKI",_oFontMI)
	_oPrinter:Say(_nRow ,800 , "Aços Macom Ind. e Com. Ltda",_oFontP)
	_oPrinter:Say(_nRow += _nNextLin ,800 , "CNPJ: 43.553.668/0001-79",_oFontP)
	_oPrinter:Say(_nRow + _nNextLin ,800 , "Telefone: (011) 2085-7000",_oFontP)
	_oPrinter:Say(_nRow + 140 ,70, "Modelo: ",_OFontP)
	_oPrinter:Say(_nRow + 140 , 250, Alltrim(_cCodOpi),_OFontGG)
	_oPrinter:Say(_nRow + 510 , 70, "OP.: ",_OFontP)
//	_oPrinter:Say(_nRow + 510 , 150, AllTrim(_cOP) ,_OFontP) //#7032
	_oPrinter:Say(_nRow + 510 , 150, AllTrim(_cOP+_cItem+_cSequen) ,_OFontP) //#7032

	_oPrinter:Say(_nRow + 390 , 70, "BCode OP: " ,_OFontP)
//	_oPrinter:FWMSBAR('CODE128',12.9/*nRow*/,1.5/*nCol*/,AllTrim(_cOP),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/) //#7032
	_oPrinter:FWMSBAR('CODE128',12.9/*nRow*/,1.5/*nCol*/,AllTrim(_cOP+_cItem+_cSequen),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/) //#7032
	
	_oPrinter:Say(_nRow + 510 , 700, "Pedido.:" ,_OFontP)
	_oPrinter:Say(_nRow + 510 , 880, AllTrim(_cPedido) ,_OFontP)

	_oPrinter:Say(_nRow + 180 , 70, "BCode Model: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',7.8/*nRow*/,1.5/*nCol*/,AllTrim(_cCodOpi),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
	
	_oPrinter:Say(_nRow + 180 , 700, "Nº de Série: " ,_OFontP)
	_oPrinter:Say(_nRow + 180 , 880, Alltrim(_cNumSer) ,_OFontGG)

	_oPrinter:Say(_nRow + 278 , 700, "BCode Serial: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',10.2/*nRow*/,15.5/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
		
	_oPrinter:Say(_nRow + 560 , 70, "DESCRICAO.: " ,_OFontP)
	_oPrinter:Say(_nRow + 605 , 70, _cDescPro1 ,_OFontP)
	_oPrinter:Say(_nRow + 645 , 70, _cDescPro2 ,_OFontP)
		
	_oPrinter:Say(_nRow + 685 , 1030, "FGQ-FB-008 Rev.00" ,_OFontP)
				
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 	:= 'ZEBRA'
	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
	/*	
	If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
		RecLock("ZAB", .F.)
		ZAB->ZAB_ETQCKL := (ZAB_ETQCKL + 1)
		MsUnlock()	
	Endif
	*/
Return
