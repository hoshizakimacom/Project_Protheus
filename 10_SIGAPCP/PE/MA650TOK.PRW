#INCLUDE "TOTVS.CH"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'
#INCLUDE "TopConn.ch"

User Function MA650TOK()

Local aArea     := GetArea()
Local aAreaZAB  := ZAB->(GetArea())
Local _lRet     := .T.
Local aRet      := {}

// Validação de Campos Checklist Engenahria para liberação de Abertura de OP #6839

Local _cTipoPrd := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_TIPO")
Local _cItDese  := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XITDESE")
Local _cPdf     := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XPDF")
Local _cDxf     := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XDFX")
Local _cEstru   := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XESTR")
Local _cLibEng  := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XESPLIB")
//Local _cPadrao   := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XPADRAO")		//1=Sim 2=Não
Local cAviso    := ""

if _cTipoPrd == "ME"
    cAviso += "Não é permitida a inclusão de ordem de produção para produtos do tipo 'ME'"+CRLF
	_lRet := .F.
Endif

If _cLibEng == "2"
    cAviso += "Produto não está liberado pela engenharia"+CRLF
	_lRet := .F.
EndIf

IF _cItDese <> "S" //Diferente de Sim
	_lRet := .F.
    cAviso += "Não é permitida a inclusão de ordem de produção, Item não está desenvolvido"+CRLF
EndIf

If _cPdf <> "1" //Diferente de Sim
    cAviso += "Não é permitida a inclusão de ordem de produção, PDF não está disponível"+CRLF
	_lRet     := .F.
Endif

If Empty(_cDxf) //Diferente de Sim
    cAviso += "Não é permitida a inclusão de ordem de produção, DXF não está disponível"+CRLF
	_lRet     := .F.
EndIf

If _cEstru <> "1" //Diferente de Sim
    cAviso += "Não é permitida a inclusão de ordem de produção, Não há estrutura liberada"+CRLF
	 _lRet     := .F.
EndIf

If _lRet
	aRet   := U_M10AETQ(M->C2_PRODUTO,M->C2_QUANT,M->C2_QUJE,M->C2_NUM,M->C2_ITEM,M->C2_SEQUEN,.T. /*lImprime*/,.T. /*lCtrlImp*/)
	_lRet  := aRet[1]
	cAviso += aRet[2]
EndIf

If !EMPTY(cAviso)
	Aviso("ATENÇÃO",cAviso,{"Ok"},3)
EndIf

RestArea(aAreaZAB)
RestArea(aArea)

Return _lRet

//+----------------------------------------------------------------------------------------------------------------
// Rotina de geração de numero de serie e impressão de etiqueta térmica (ZEBRA GC420t)
// Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10AETQ(cProduto,_nQtdOP,_nQtdJE,cOP,cItem,cSequen,lImprime,lCtrlImp)

Local _cNumSer 	 := ""
Local _cAno		 := ""
Local _cMes		 := ""
Local _nSerial 	 := GetMV("AM_NUMSER")
Local _nAno		 := year(ddatabase)
Local _nMes		 := month(ddatabase)
Local _nX		 := 0
Local _lRet		 := .T.
Local cAviso     := ""
Local cAM_FAMSER := GetMv("AM_FAMSER",.F.,"000001|000002|000003|000004|000014|000015")
Local cAliasTMP  := ""
Local aRetPar    := {}
Local aPergs     := {}

Public _aNumSer := {}

Default cProduto := SC2->C2_PRODUTO
Default cOP      := SC2->C2_NUM
Default cItem    := SC2->C2_ITEM
Default cSequen  := SC2->C2_SEQUEN
Default lImprime := .F.
Default lCtrlImp := .T.

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)

DBSelectArea("ZAB")
DBSetOrder(2)

If _nQtdJE <> 0
	cAviso += "Não é possível a geração de Número(s) de Série, para Ordem de Produção Encerrada ou Iniciada "+CRLF
	_lRet := .F.
Else
	If ! SB1->B1_XFAMILI $ cAM_FAMSER
		cAviso += "Só é posível gerar Número(s) de Série para as Famílias Cocção, Mobiliário, Refrigeração e Máquinas de Gelo Exportação "+CRLF
	Else
		/*If ZAB->(MSSeek(xFILIAL("ZAB")+cOP))
			cAviso += "Número(s) de Série já gerados para esta Ordem de Produção - Número de Serie : "+ZAB->ZAB_NUMSER+CRLF 
			_lRet := .F.
		Else*/

			If RIGHT(Alltrim(cProduto),2) <> "-A" //Nao for produto de Avaria

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

				/*
				If Substr(ZAB->ZAB_NUMSER, 9,1) <> _cMes
					_nSerial := "0"
				EndIf
		
				_nSerial := Val(_nSerial)
				*/

				// Busca Ultimo Número de Série no Mês e Ano 
				cQuery := "SELECT MAX(ZAB_NUMSER) NUMSER "
				cQuery += " FROM "+RetSqlName("ZAB")+" ZAB "
				cQuery += " WHERE ZAB_FILIAL = '"+xFilial("ZAB")+"' "
				cQuery += " AND LEFT(ZAB_NUMSER,2) = '1"+_cAno+"' "
				cQuery += " AND SUBSTRING(ZAB_NUMSER,9,1) = '"+_cMes+"' "
				cQuery += " AND D_E_L_E_T_ <> '*' "

				TcQuery cQuery New Alias (cAliasTMP := GetNextAlias())
				
				dbSelectArea(cAliasTMP)
				_nSerial := 0
				dbGoTop()
				If !Eof()
					_nSerial := Val(SubStr((cAliasTMP)->NUMSER,3,6))
				EndIf
				dbCloseArea()
				DBSelectArea("ZAB")

				For _nX :=1 to _nQtdOP
					Sleep(500)		
					_nSerial ++ 
					_cNumSer := "1" + _cAno + strzero(_nSerial,6) + _cMes
					If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
						cAviso += "Problemas na geração do Número de Série, entre em contato com o TI - "+ _cNumSer
						_lRet := .F.
					Else

						cAviso += "Número de Série Gerado ! "+_cNumSer

						Reclock("ZAB",.T.)
						ZAB->ZAB_FILIAL := xFilial("ZAB")
						ZAB->ZAB_NUMSER	:= _cNumSer
						ZAB->ZAB_CODPRO	:= cProduto
						ZAB->ZAB_NUMOP	:= cOP 
						ZAB->ZAB_ITEMOP	:= cItem
						ZAB->ZAB_SEQOP	:= cSequen
						ZAB->(MsUnlock())
		
						Aadd(_aNumSer , { cProduto, cOP, cItem, cSequen, _cNumSer } )
		
						DBSelectArea("SX6")
						GetMV("AM_NUMSER")
						RecLock("SX6",.F.)
						X6_CONTEUD := Alltrim(STR(_nSerial))
						MsUnlock()

						If lImprime
							U_M10EPrin(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW
							U_M10EPri1(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW
							U_M10EPri1(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW //Adicionado mais uma impressão etq. Checklist
						EndIf
					Endif
				Next _nX
						
			Else
				
				aRetPar := {}
				aPergs  := {}
		
				Aadd(aPergs, {1, "Numero de Série Origem:",SPACE(TAMSX3("ZAB_NUMSER")[1]),"@X","","ZAB","",60,.F.})
				Aadd(aPergs, {1, "Nro.Relatório Avaria:"  ,"A   -"+RIGHT(STR(YEAR(dDataBase),4),2),"@R A999-99","","   ","",60,.T.})

				If !ParamBox(aPergs, "Produto Avariado - Informe o seguinte dados", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,.F./*lCanSave*/,.F./*lUserSave*/)
					cAviso += "Produto Avariado e não informado o numero de serie origem para geração da serie de avaria"+CRLF
					_lRet := .F.
				Else

					_cNumSer := PADR(ALLTRIM(aRetPar[1])+"-"+aRetPar[2],TAMSX3("ZAB_NUMSER")[1])

					If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
						cAviso += "Problemas na geração do Número de Série, entre em contato com o TI - "+ _cNumSer
						_lRet := .F.
					Else

						Reclock("ZAB",.T.)
						ZAB->ZAB_FILIAL := xFilial("ZAB")
						ZAB->ZAB_NUMSER	:= _cNumSer
						ZAB->ZAB_CODPRO	:= cProduto
						ZAB->ZAB_NUMOP	:= cOP
						ZAB->ZAB_ITEMOP	:= cItem
						ZAB->ZAB_SEQOP	:= cSequen
						ZAB->(MsUnlock())

						If lImprime
							U_M10EPrin(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW
							U_M10EPri1(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW
							U_M10EPri1(cProduto , _nQtdOP, _cNumSer, lCtrlImp) //MA650TOK.PRW //Adicionado mais uma impressão etq. Checklist
						EndIf
					EndIf
				EndIf

		//	EndIf	
		EndIf
	EndIf
EndIf

Return({_lRet,cAviso})


User Function M10EPrin(_cCodProd,_nQtd,_cNumSer,lCtrlImp,_nQtdImp)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 90
	
	Local _oFontP 		:= TFont():New('Arial',,12)
	//Local _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
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
	Local _cTpFluido	:= Alltrim(Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFLUIDO"))
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
	Local _cQRCode		:= AllTrim(Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XURL"))
	Local _cPdeGelo		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPDGELO")	//6033

	Private _nCol02		:= _nCol01 + 430
	Private _nCol03		:= _nCol01 + 700

	Default _nQtdImp    := 1

    Do Case 
    	Case _cClClima == "1"
    		 _cClClima := "4"     	
    	Case _cClClima == "2"
    	     _cClClima := "6"
    	Case _cClClima == "3"
    	     _cClClima := "ST"
		Case _cClClima == "4" // #4410
    	     _cClClima := "5" // #4410
		Case _cClClima == "5" // #7629
			 _cClClima := "3" // #7629
    EndCase

    Do Case 					//6033
   		Case _cPdeGelo == "1"
    		 _cPdeGelo := "150W"   
    	Case _cPdeGelo == "2"	//6386
    		 _cPdeGelo := "400W"    	
    	Case _cPdeGelo == "3"	//6386
    		 _cPdeGelo := "500W" 
		Case _cPdeGelo == "4"	//6633
			 _CPdeGelo := "300W"
		Case _cPdeGelo == "5"	//7835
			 _cPdeGelo := "250W"  
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
    	Case _cTensao == "1"			//#8206
    		 _cTensao := "220V 3 ~"     	
    	Case _cTensao == "2"			//#8206
    	     _cTensao := "220V ~"
    	Case _cTensao == "3"			//#8206
    	     _cTensao := "127V ~"
    	Case _cTensao == "4"			//#8206
    		 _cTensao := "380V 3 ~"
    	Case _cTensao == "5"			//#8206
    		 _cTensao := "115V ~"
	   	Case _cTensao == "6"			//5078		//#8206
    		 _cTensao := "380V 3N ~"	
		Case _cTensao == "7"			//7835		//#8206
    		 _cTensao := "220-240V ~"	
    EndCase

	Do Case 
    	Case _cFreq == "1"
    		 _cFreq := "50 Hz"     	
    	Case _cFreq == "2"
    	     _cFreq := "60 Hz"
    	Case _cFreq == "3"
    	     _cFreq := "50/60 Hz"
    EndCase

	_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)
	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E006.bmp", 100 * 4.0 , 30 * 4.0)
	//_oPrinter:Say(_nRow + 100 , 70 , "Grupo HOSHIZAKI",_oFontMI)
	_oPrinter:Say(_nRow ,800 , "HOSHIZAKI MACOM Ltda",_oFontP) /**#7666**/
	_oPrinter:Say(_nRow += _nNextLin ,800 , "CNPJ: 43.553.668/0001-79",_oFontP)
	_oPrinter:Say(_nRow + _nNextLin ,800 , "Telefone: (011) 2085-7000",_oFontP)
	_oPrinter:Say(_nRow + 77 ,800 , "www.hoshizakimacom.com.br",_oFontP)
	_oPrinter:Say(_nRow + 140 ,70, "Modelo: ",_OFontP)
	_oPrinter:Say(_nRow + 140 , 200, Alltrim(_cCodProd),_OFontGG)
	_oPrinter:Say(_nRow + 190 , 70, "Desc.: ",_OFontP)
	_oPrinter:Say(_nRow + 190 , 200, _cDescPro1 ,_OFontP)
	_oPrinter:Say(_nRow + 240 , 200, _cDescPro2 ,_OFontP)
	_oPrinter:Say(_nRow + 290 , 70, "BCode Model: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',9.4/*nRow*/,6/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
	_oPrinter:Say(_nRow + 370 , 70, "Data Fab: " + AllTrim(DTOC(_dDtFab)) ,_OFontP)
	_oPrinter:Say(_nRow + 450 , 70, "BCode Serial: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',12.4/*nRow*/,6/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
	_oPrinter:Say(_nRow + 505 , 270, Alltrim(_cNumSer),_OFontGG)
	_oPrinter:Say(_nRow + 685 , 1025, "FGQ-FB-008 Rev.00", _OFontP) /**#7666**/
		
	If _cINMETRO =="1"
		//_oPrinter:SayBitMap( 500, 900 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 30 * 4.0 , 30 * 4.0) // *** Valdemir - 03/03/2023 *** // #7976 de 800 para 900 
		_oPrinter:SayBitMap( _nRow + 260, 1080 ,GetSrvProfString("Startpath","") + "M10E005.BMP", 60 * 2.5 , 60 * 2.5)
	Endif

	//_oPrinter:QrCode(635,950,_cQRCode, 070)  // *** Valdemir - 03/03/2023 *** //
	_oPrinter:QrCode(625,810,_cQRCode, 070) // #7976

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
        EndIf  
	
		If _cTpGas <> "4"
						
				_oPrinter:Say(_nRow + 580, 70, "Carga de Fluído: "     + _cVlrFluido + "g", _OFontP)
				_oPrinter:Say(_nRow + 655 , 70, "Potência: " 			+ _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 580 , 450, "Potência degelo: " 	+ _cPdeGelo , _OFontP)			//#6033
				_oPrinter:Say(_nRow + 620 , 450, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
				_oPrinter:Say(_nRow + 660 , 450, "Classe Climática: " 	+ _cClClima , _OFontP)

				_oPrinter:Say(_nRow + 575 , 800, "Corrente: " 			+ _cCorrente + " A", _OFontP)
				_oPrinter:Say(_nRow + 620 , 800, "Tensão: " 			+ UPPER(_cTensao), _OFontP)
				_oPrinter:Say(_nRow + 660 , 800, "Frequência: " 		+ _cFreq, _OFontP)

		Else

				_oPrinter:Say(_nRow + 580 , 800, "Gás: " 				+ "Ciclopentano", _OFontP)
				_oPrinter:Say(_nRow + 580 , 70, "Fluído Refrigerante: " + _cTxFluido ,_OFontP)
				_oPrinter:Say(_nRow + 620 , 70, "Carga de Fluído: "     + _cVlrFluido + "g", _OFontP)
				_oPrinter:Say(_nRow + 660 , 70, "Potência: " 			+ _cPotencia, _OFontP)

				//_oPrinter:Say(_nRow + 580 , 450, "Potência degelo: " 	+ _cPdeGelo , _OFontP)
				_oPrinter:Say(_nRow + 620 , 450, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
				_oPrinter:Say(_nRow + 660 , 450, "Classe Climática: " 	+ _cClClima , _OFontP)
				_oPrinter:Say(_nRow + 580 , 450, "Corrente: " 			+ _cCorrente + " A", _OFontP)
				
				_oPrinter:Say(_nRow + 620 , 800, "Tensão: " 			+ UPPER(_cTensao), _OFontP)
				_oPrinter:Say(_nRow + 660 , 800, "Frequência: " 		+ _cFreq, _OFontP)
		EndIf

	ElseIf _cFamilia == "000002"

		If _cCategoria == "1"
				_oPrinter:Say(_nRow + 645 , 70, "Gás: " + IIF(_cTpGas== "1", "GN", "GLP"), _OFontP)
	
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Consumo: " + _cConsumo, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + UPPER(_cTensao) + " " + _cFreq, _OFontP)

		ElseIf _cCategoria == "2"
				//_oPrinter:Say(_nRow + 645 , 70, "Tensão: " + UPPER(_cTensao), _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Corrente: " + _cCorrente + " A",_OFontP)
				
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 645 , 920, "Grau de Proteção: IP " + _cGrProtecao, _OFontP)

				_oPrinter:Say(_nRow + 685 , 550,"Tensao/Freq: " + UPPER(_cTensao) + " " + _cFreq, _OFontP)
				
		ElseIf _cCategoria == "3"
				_oPrinter:Say(_nRow + 645 , 550, "Potência: " + _cPotencia, _OFontP)
				
				_oPrinter:Say(_nRow + 685 , 70, "Consumo: " + _cConsumo, _OFontP)
		EndIf

	ElseIf _cFamilia == "000004"

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
        EndIf        
                    
		_oPrinter:Say(_nRow + 605 , 70, "Fluído Refrigerante: " + _cTxFluido ,_OFontP)
		_oPrinter:Say(_nRow + 645 , 70, "Carga de Fluído: " + _cVlrFluido + "g", _OFontP)
		_oPrinter:Say(_nRow + 685 , 70, "Potência: " + _cPotencia, _OFontP)
			
		_oPrinter:Say(_nRow + 605 , 550, "Grau de Proteção: IP" + _cGrProtecao, _OFontP)
		_oPrinter:Say(_nRow + 660 , 550, "Classe Climática: " + _cClClima , _OFontP)
		_oPrinter:Say(_nRow + 685 , 550, "Corrente: " + _cCorrente + " A", _OFontP)
			
		_oPrinter:Say(_nRow + 605 , 950, "Tensão: " + UPPER(_cTensao), _OFontP)
		_oPrinter:Say(_nRow + 645 , 950, "Frequência: " + _cFreq, _OFontP)
		
	EndIf
				
	_oPrinter:SetDevice(IMP_SPOOL)
		
	_oPrinter:cPrinter 		:= 'ZEBRA'

	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
	
	If lCtrlImp
		RecLock("ZAB", .F.)
		ZAB->ZAB_ETQINT := (ZAB->ZAB_ETQINT + 1)
		MsUnlock()
	EndIf

Return

//+----------------------------------------------------------------------------------------------------------------
User Function M10EPri1(_cCodProd,_nQtd,_cNumSer,lCtrlImp)
	Private _oPrinter		:= Nil
	Private _nRow 		    := 90
	
	Private _oFontP 		:= TFont():New('Arial',,12)
	Private _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	//Private _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	Private _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Private _oFontGG		:= TFont():New('Arial',,24,.T.,.T.)

	Private _nCol01		    := 020
	Private _nCol02		    := _nCol01 + 430
	Private _nCol03		    := _nCol01 + 700
	Private _nNextLin		:= 50
	Private _cUnid		    := Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM") 
	Private _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Private _cDescPro1	    := SubStr(_cDescPro,1,64)
	Private _cDescPro2	    := SubStr(_cDescPro,65,129)
	Private _dDtFab		    := Posicione("SD3",18,xFilial("SD3")+ AllTrim(_cNumSer), "D3_EMISSAO")
	Private _cINMETRO		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XINMETR")
	Private _cFamilia		:= Posicione("SB1",1,xFilial("SB1")+ _cCodProd, "B1_XFAMILI")
	Private _cTpFluido	    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XFLUIDO")
	Private _cPotencia	    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPOTENC")
	Private _cClClima		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCLASCL")
	Private _cTensao		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XTENSAO")
	Private _cCategoria	    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCATEGO")
	Private _cTpGas		    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGAS")
	Private _cGrProtecao	:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XGPROT")
	Private _cCorrente	    := Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XCORNT")
	Private _lRetusr		:= .T.
	Private _cPedido		:= ZAB->ZAB_NUMPV
	Private _cOP			:= ZAB->(ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP)
	Private _cPdeGelo		:= Posicione("SB5",1,xFilial("SB5")+ _cCodProd, "B5_XPDGELO")

	_oPrinter := FWMSPrinter():New('M02E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,1)
	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	_oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E006.bmp", 100 * 4.0 , 30 * 4.0)
	//_oPrinter:Say(_nRow + 100 , 70 , "Grupo HOSHIZAKI",_oFontMI)
	_oPrinter:Say(_nRow ,650 , "HOSHIZAKI MACOM Ltda",_oFontP)
	_oPrinter:Say(_nRow += 38 ,650 , "CNPJ: 43.553.668/0001-79",_oFontP)
	_oPrinter:Say(_nRow + 40 ,650 , "Telefone: (011) 2085-7000",_oFontP)
	_oPrinter:Say(_nRow + 82 ,650 , "www.hoshizakimacom.com.br",_oFontP)
	_oPrinter:Say(_nRow + 140 ,70, "Modelo: ",_OFontP)
	_oPrinter:Say(_nRow + 140 , 250, Alltrim(_cCodProd),_OFontGG)
	_oPrinter:Say(_nRow + 515 , 70, "OP.: ",_OFontP)
	_oPrinter:Say(_nRow + 515 , 150, AllTrim(_cOP) ,_OFontP) //#7032

	_oPrinter:Say(_nRow + 390 , 70, "BCode OP: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',12.9/*nRow*/,1.5/*nCol*/,AllTrim(_cOP),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/) //#7032

	_oPrinter:Say(_nRow + 515 , 700, "Pedido.:" ,_OFontP)
	_oPrinter:Say(_nRow + 515 , 880, AllTrim(_cPedido) ,_OFontP)

	_oPrinter:Say(_nRow + 180 , 70, "BCode Model: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',7.8/*nRow*/,1.5/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)
	
	_oPrinter:Say(_nRow + 180 , 700, "Nº de Série: " ,_OFontP)
	_oPrinter:Say(_nRow + 180 , 880, Alltrim(_cNumSer) ,_OFontGG)

	_oPrinter:Say(_nRow + 278 , 700, "BCode Serial: " ,_OFontP)
	_oPrinter:FWMSBAR('CODE128',10.2/*nRow*/,15.5/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/)

	_oPrinter:Say(_nRow + 560 , 70, "DESCRICAO.: " ,_OFontP)
	_oPrinter:Say(_nRow + 605 , 70, _cDescPro1 ,_OFontP)
	_oPrinter:Say(_nRow + 645 , 70, _cDescPro2 ,_OFontP)
		
	_oPrinter:Say(_nRow + 685 , 1025, "FGQ-008 Rev.01" ,_OFontP) /**#7666**/	
				
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 		:= 'ZEBRA'
	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)

	If lCtrlImp
		RecLock("ZAB", .F.)
				ZAB->ZAB_ETQCKL := (ZAB_ETQCKL + 1)
		MsUnlock()
	EndIf

Return
