#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch' 
#include 'TBICONN.ch'
#include "colors.ch"

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impress�o de etiqueta t�rmica (ZEBRA GC420t)
//	Substitui utiliza��o da planilha SP02 / Etiqueta Identifica��o (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M04E02()
	Local _oDlg			:= Nil
	Local _nOpca		:= 0
	Local _cTitulo		:= 'Etiqueta Reserva/Pedido'

	Local _cPedido		:= Space(TamSX3('C5_NUM')[1])
	Local _cItem		:= Space(TamSX3('C6_ITEM')[1])
	Local _cSerie		:= Space(TamSX3('B1_SERIE')[1])
	Private _lRetusr		:= .T.
	
	If !RetCodUsr() $GETMV("MV_XPALB07")
		lRetusr	:= .F.
		MsgStop("N�o � poss�vel emitir a etiqueta, usu�rio n�o autorizado","Aten��o")
	Else
		
		DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 185,280 PIXEL

		@ 002,002 TO 70, 140 OF _oDlg PIXEL

		@ 010,010 SAY 'Pedido' 	SIZE 55, 07 OF _oDlg PIXEL
		@ 010,050 MSGET _cPedido SIZE 80, 11 F3 'SC5' OF _oDlg PIXEL

		@ 030,010 SAY 'Seq.' SIZE 55, 07 OF _oDlg PIXEL
		@ 030,050 MSGET _cItem SIZE 80, 11 OF _oDlg PIXEL

		@ 050,010 SAY 'Num. S�rie' SIZE 55, 07 OF _oDlg PIXEL
		@ 050,050 MSGET _cSerie SIZE 80, 11 OF _oDlg PIXEL

		DEFINE SBUTTON FROM 75, 40 TYPE 1 ACTION (_nOpca := 1,(M04EMain(@_cPedido,@_cItem,@_cSerie))) ENABLE OF _oDlg
		DEFINE SBUTTON FROM 75, 80 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

		ACTIVATE MSDIALOG _oDlg CENTERED
	EndIf
Return
//+----------------------------------------------------------------------------------------------------------------

Static Function M04EMain(_cPedido,_cItem,_cSerie)
Local _lPosZA0
Local _lPosZAB
Local _aDescr		:= {}
Local _cProd		:= ''
Local _cDescr       := ''
Local _cCliente		:= ''
Local _cFantasia	:= ''
Local _cXItemP		:= ''
Local _cNum			:= ''
Local _cHora		:= ''
Local _cFamili		:= ''
Local _cNomeCli		:= ''
Local _nX 			:= 0
Private _cNumPV		:= ''
Private _lImpOk		:= .F.

// ***
dbSelectArea("ZA0")
dbSetOrder(2) //ZA0_FILIAL+ZA0_SERIE

dbSelectArea("ZAB")
dbSetOrder(1) //ZAB_FILIAL+ZAB_NUMSER
 
 // Valida se Campos obrigat�rios foram informados
		If M04EValObr(@_cPedido,@_cItem,_cSerie)
		
			M10EGetInf(_cPedido,_cItem,@_cProd,@_aDescr,@_cCliente,@_cFantasia,@_cXItemP,@_cSerie,@_cNum,@_cHora)

			_cFamili := Posicione("SB1",1, xFilial("SB1") + _cProd, "B1_XFAMILI")
			
			For _nX := 1 To Len(_aDescr)
				_cDescr += _aDescr[_nX]
			Next

			_lPosZA0 := ZA0->(MsSeek(xFilial("ZA0") + _cSerie))
			_lPosZAB := ZAB->(MsSeek(xFilial("ZAB") + _cSerie))
			
			If _lPosZA0
				_cCodCli := Posicione("SC5",1,xFilial("SC5") + ZA0->ZA0_PV, "C5_CLIENTE")
				_cNomeCli := Posicione("SA1",1,xFilial("SA1") + _cCodCli, "A1_NOME") 
				
				If _cProd == Alltrim(ZA0->ZA0_PROD)
						_lRet := MsgYesNo('Produto j� alocado para o cliente : ' + CRLF + CRLF;
										 + _cNomeCli + CRLF + CRLF;
										 + 'Deseja realocar o produto para o cliente abaixo?' + CRLF + CRLF;
										 + 'Produto.....: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
										 + 'Cliente.....: '		+ _cCliente	+ CRLF;
										 )
						If _lRet
							RecLock("ZA0",.F.)
							ZA0->ZA0_QTDIMP	:= (ZA0->ZA0_QTDIMP + 1)
							ZA0->ZA0_DTREAL	:= DDATABASE
							ZA0->ZA0_HRREAL	:= _cHora
							ZA0->ZA0_USREAL	:= AllTrim(UsrRetName(RetCodUsr()))
							ZA0->ZA0_REALOC	:= "S"
							ZA0->ZA0_PV 	:= _cPedido
							ZA0->ZA0_ITEMPV	:= _cItem
							MsUnlock()
							
							M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)
							
							M04ESetSC6(_cPedido,_cItem,'F')
							
						EndIf
				Else
					MsgStop('Produto j� alocado para o cliente : ' + CRLF + CRLF;
										 + _cNomeCli + CRLF + CRLF;
										 + 'Produto Origem...: ' + Posicione("SB1",1,xFilial("SB1") + ZA0->ZA0_PROD, "B1_DESC") + CRLF + CRLF;
										 + 'N�o � poss�vel realocar o n�mero de s�rie para outro produto' + CRLF + CRLF;
										 + 'Produto Destino..: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
										 + 'Cliente..........: '		+ _cCliente	+ CRLF;
										 ,"Aten��o")
				EndIf
			ElseIf _lPosZAB
					If !Empty(ZAB->ZAB_NUMPV)
						_cCodCli  := SC6->C6_CLI
						_cNomeCli := Posicione("SA1",1,xFilial("SA1") + _cCodCli, "A1_NOME")
						_cNota	  := SC6->C6_NOTA

						If _cProd == Alltrim(ZAB->ZAB_CODPRO)
							_lRet := MsgYesNo('Produto j� alocado para o cliente : ' + CRLF + CRLF;
										 	+ _cNomeCli + CRLF + CRLF;
										 	+ 'Deseja realocar o produto para o cliente abaixo?' + CRLF + CRLF;
										 	+ 'Produto.....: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
										 	+ 'Cliente.....: '		+ _cCliente	+ CRLF;
										 	)
							If _lRet

								M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)

                                M04ESetSC6(ZAB->ZAB_NUMPV,ZAB->ZAB_ITEMPV,'F')

								RecLock("ZAB",.F.)
								ZAB->ZAB_NUMPV := _cPedido
								ZAB->ZAB_ITEMPV:= _cItem
								ZAB->ZAB_NOTA  := _cNota
								MsUnlock()

								MsgInfo("Produto: " + Posicione("SB1",1,xFilial("SB1") + ZAB->ZAB_CODPRO, "B1_DESC") + CRLF + CRLF;
										+ "Alocado para o pedido: " + _cPedido + " Item: " + _cItem, "Aten��o")
										
								M04ESetSC6(_cPedido,_cItem,'9')
							EndIf
						Else
							MsgStop('Produto j� alocado para o cliente : ' + CRLF + CRLF;
										 + _cNomeCli + CRLF + CRLF;
										 + 'Produto Origem...: ' + Posicione("SB1",1,xFilial("SB1") + ZAB->ZAB_CODPRO, "B1_DESC") + CRLF + CRLF;
										 + 'N�o � poss�vel realocar o n�mero de s�rie para outro produto' + CRLF + CRLF;
										 + 'Produto Destino..: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
										 + 'Cliente..........: '		+ _cCliente	+ CRLF;
										 ,"Aten��o")
						EndIf
					Else
						If _cProd == Alltrim(ZAB->ZAB_CODPRO)
							
							_cNota	  := SC6->C6_NOTA

							RecLock("ZAB",.F.)
							ZAB->ZAB_NUMPV := _cPedido
							ZAB->ZAB_ITEMPV:= _cItem
							ZAB->ZAB_NOTA  := _cNota
							MsUnlock()
							
							M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)						
							
							MsgInfo("Produto: " + Posicione("SB1",1,xFilial("SB1") + ZAB->ZAB_CODPRO, "B1_DESC") + CRLF + CRLF;
										+ "Alocado para o pedido: " + _cPedido + " Item: " + _cItem, "Aten��o")
										
							M04ESetSC6(_cPedido,_cItem,'9')
						Else
							MsgStop("N�o � poss�vel realocar o n�mero de s�rie para outro produto", "Aten��o")
						EndIf
					EndIf
			Else
				_lRet := MsgYesNo('Confirma impress�o da etiqueta abaixo?' + CRLF + CRLF;
							+ 'Produto.....: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
							+ 'Cliente.....: '		+ _cCliente	+ CRLF;
						)
				If _lRet
					M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)
							
							RecLock("ZA0",.T.)
							ZA0->ZA0_FILIAL := xFilial("ZA0")
							ZA0->ZA0_PV 	:= _cPedido
							ZA0->ZA0_ITEMPV	:= _cItem
							ZA0->ZA0_SERIE	:= _cSerie
							ZA0->ZA0_QTDIMP	:= (ZA0->ZA0_QTDIMP + 1)
							ZA0->ZA0_DATA	:= DDATABASE
							ZA0->ZA0_HORA	:= _cHora
							ZA0->ZA0_USER	:= AllTrim(UsrRetName(RetCodUsr()))
							ZA0->ZA0_PROD	:= _cProd
							ZA0->ZA0_REALOC	:= "N"
							MsUnlock()
							
							MsgInfo("Produto: " + Posicione("SB1",1,xFilial("SB1") + ZA0->ZA0_PROD, "B1_DESC") + CRLF + CRLF;
										+ "Alocado para o pedido: " + _cPedido + " Item: " + _cItem, "Aten��o")
										
							M04ESetSC6(_cPedido,_cItem,'9')
				EndIf
			EndIf
		EndIf
Return
		
//+----------------------------------------------------------------------------------------------------------------		
Static Function M04EValObr(_cPedido,_cItem,_cSerie)
	Local _lRet 	:= .T.
	Local _cFamilia := ""

	_cPedido		:= StrZero(Val(_cPedido),TamSX3('C5_NUM')[1])
	_cItem			:= UPPER(IIF(Len(AllTrim(_cItem)) < TamSX3('C6_ITEM')[1],StrZero(Val(_cItem),TamSX3('C6_ITEM')[1]),_cItem))


	If !(_lRet := !Empty(_cPedido))
		MsgInfo('Pedido � obrigat�rio.')
	EndIf

	If _lRet .And. !(_lRet := !Empty(_cItem))
		MsgInfo('Sequencia � obrigat�ria.')
	EndIf

	If _lRet .And. !(_lRet := !Empty(_cSerie))
		MsgInfo('N�mero de S�rie � obrigat�rio.')
	EndIf

	If _lRet
		SC5->(DbGotop())
		SC5->(DbSetOrder(1))

		If (_lRet := (SC5->(DbSeek( xFilial('SC5') + _cPedido))))
			SC6->(DbGoTop())
			SC6->(DbSetOrder(1))

			If !(_lRet := (SC6->(DbSeek( xFilial('SC6') + SC5->C5_NUM + _cItem ))))
				MsgInfo('Pedido e sequencia n�o encontrados.')
            Else
                dbSelectArea("ZAB")
                dbSetOrder(1)
                ZAB->(dbGoTop())
                
                _cFamilia := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XFAMILI")
                
                If _cFamilia $ "000001|000002|000003"
                    If !(_lRet := (ZAB->(DbSeek( xFilial('ZAB') + _cSerie )))) 
                         MsgInfo('N�mero de s�rie : '+ _cSerie +' n�o existe ! Verifique. ')
                    Else
                         If Empty(ZAB->ZAB_APONTA) .And. _cFamilia $ "000001|000002|000003" 
                              MsgInfo('O produto numero de s�rie : ' + Alltrim(_cSerie) + ' n�o foi apontado! Favor efetuar o apontamento!')
                              _lRet := .F.
                         Endif
                    Endif
		    	EndIf
		    Endif
		Else
			MsgInfo('Pedido n�o encontrado.')
		EndIf
	EndIf

Return _lRet
//+----------------------------------------------------------------------------------------------------------------
Static Function M10EGetInf(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)
	Local _cDescr	:= ''
	_cHora			:= Time()
	_cCliente 		:= Posicione('SA1',1,xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI),'A1_NOME')
	_cFantasia 		:= Posicione('SA1',1,xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI),'A1_NREDUZ')

	_cXItemP		:= SubStr(AllTrim(SC6->C6_XITEMP),1,10)
	_cNum			:= AllTrim(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM + _cSerie)
	_cProd			:= AllTrim(SC6->C6_PRODUTO)
	_cDescr			:= Posicione('SB1',1,xFilial('SB1') + SC6->C6_PRODUTO,'B1_DESC')
	_aDescr 		:= M10ESep(_cDescr)
Return
//+----------------------------------------------------------------------------------------------------------------
Static Function M10ESep(_cValor)
	Local _aRet 	:= {}
	Local _nX		:= 0
	Local _nQuant	:= 0
	Local _nOriQt	:= 40
	Local _cLinha	:= ''
	Local _lEmpty	:= .T.

	While _nX < Len(AllTrim(_cValor))
		_nQuant := _nOriQt

		While SubStr(AllTrim(_cValor),_nQuant, 1) <> ' '
			_nQuant--
		EndDo

		_cLinha := SubStr(AllTrim(_cValor),_nX, _nQuant)

		AAdd(_aRet, M10ENoCar(_cLinha) )

		_lEmpty := .F.
		_nX += _nQuant
	EndDo
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------------------------------
Static Function M04ESetSC6(_cPedido,_cItem,_cEtapa,_cHora)

	Default _cHora := Time()

	SC6->(DbGoTop())
	SC6->(DbSetOrder(1))

	If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
		RecLock('SC6',.F.)
			SC6->C6_XETAPA := _cEtapa // Exped

			// Se Realoca��o
			If _cEtapa == 'F'
				SC6->C6_XREADT 	:= dDataBase
				SC6->C6_XREAHR	:= _cHora
				SC6->C6_XREAUS	:= AllTrim(UsrRetName(RetCodUsr()))
			EndIf

		SC6->(MsUnLock())
	EndIf
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)
	Local _oPrinter		:= Nil
	Local _nX				:= 0
	Local _nRow 			:= 60
	Local _oFontG1 		:= TFont():New('Arial',,42,.T.,.T.)
	Local _oFontM1 		:= TFont():New('Arial',,15,.T.,.T.)
	Local _oFontP2 		:= TFont():New('Arial',,13)
	Local _oFontP1 		:= TFont():New('Arial',,12)
	Local _nColIni		:= 040
	Local _nCol02			:= _nColIni + 120
	Local _nCol03			:= _nCol02 + 600
	Local _nCol04			:= _nCol03 + 120
	Local _nNextLin		:= 60
	Private _nAlin			:= 10 - Len(_cXItemP)
	Private _oFontG2 		:= TFont():New('Arial',,28,.T.,.T.)
	
		_oPrinter := FWMSPrinter():New('M10E001' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,2)

		_oPrinter:SetResolution(78)
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:StartPage()

		//+-------------------------------------------------------------------------
		// Area 1
		//+-------------------------------------------------------------------------

		_oPrinter:SayBitMap( _nRow - 10, _nColIni + 40,GetSrvProfString("Startpath","") + "M10E001.bmp",60 * 3.5 ,17 * 3.5)
		_oPrinter:Say(_nRow + 20,_nCol03,'A�OS MACOM IND. COM. LTDA',_oFontP1)

		_nRow += _nNextLin * 1.7

		_oPrinter:Say(_nRow,_nColIni,'Equip.:',_oFontP2)

		For _nX := 1 To 2
			_oPrinter:Say(_nRow,_nCol02,_aDescr[_nX],_oFontM1)
			_nRow += _nNextLin - 10
		Next

		//+-------------------------------------------------------------------------
		// Area 2
		//+-------------------------------------------------------------------------
		_nRow -= 10
		_oPrinter:Line(_nRow,_nColIni,_nRow,_oPrinter:nPageWidth,0,'-4')

		_nRow += _nNextLin - 10

		_oPrinter:Say(_nRow,_nColIni,'C�d.:',_oFontP2)
		_oPrinter:Say(_nRow,_nCol02,_cProd,_oFontM1)

		_oPrinter:Say(_nRow,_nCol03,'S�rie:',_oFontP2)
		_oPrinter:Say(_nRow,_nCol04,IIF(Empty(_cSerie),'***',_cSerie),_oFontM1)

		_oPrinter:FWMSBAR('CODE128',7.5/*nRow*/,6/*nCol*/,_cProd,_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.6/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

		_nRow += _nNextLin * 2.5

		_oPrinter:Say(_nRow,_nCol03,'Item:',_oFontP2)
		_oPrinter:Say(_nRow,_nCol04,AllTrim(_cXItemP),_oFontM1)

		_nRow += _nNextLin * 0.8

		_oPrinter:Say(_nRow,_nColIni,'Pedido:',_oFontP2)
		_oPrinter:Say(_nRow,_nCol02,_cPedido,_oFontG1)

		_oPrinter:Say(_nRow + 05,_nCol03,'Seq:',_oFontP2)
		_oPrinter:Say(_nRow + 05,_nCol04,_cItem,_oFontM1)

		//+-------------------------------------------------------------------------
		// Area 3
		//+-------------------------------------------------------------------------
		_nRow += _nNextLin * 0.8

		_nRow -= 10
		_oPrinter:Line(_nRow, _nColIni, _nRow, _oPrinter:nPageWidth,0,'-3')
		_nRow += _nNextLin - 10

		_oPrinter:Say(_nRow,_nColIni,'Cliente:',_oFontP2)
		_oPrinter:Say(_nRow,_nCol02,_cCliente,_oFontM1)

		_nRow += _nNextLin * 0.75
		_oPrinter:Say(_nRow,_nCol02,_cFantasia,_oFontM1)

		_nRow += _nNextLin * 0.5

		//_oPrinter:Say(_nRow + _nNextLin	,630, _cXItemP, _oFontG2)

		_nRow += _nNextLin * 0.3

		_oPrinter:Say(_nRow, _nCol02 + 30 , DToC(dDataBase) + ' ' + _cHora, _oFontP1)

		_nRow += _nNextLin * 0.8
		_oPrinter:Say(_nRow, _nColIni + 25, _cNum, _oFontP1)

		//_oPrinter:Say(_nRow,_nCol04 + 150,'FGQ-006',_oFontP1)		#5006

		_nRow += _nNextLin * 0.8									//#5006

		_oPrinter:Say(_nRow,_nColIni,'FGQ-FB-009',_oFontP1)			//#5006
		_oPrinter:Say(_nRow,_nCol04 + 150,'REV.:00',_oFontP1)		//#5006

		//_oPrinter:FWMSBAR('CODE128',17.5/*nRow*/,1/*nCol*/,_cNum,_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.7/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:cPrinter 		:= 'ZEBRA'

		_oPrinter:EndPage()
		_oPrinter:Print()

		FreeObj(_oPrinter)
	
Return
//+----------------------------------------------------------------------------------------------------------------

Static Function M10ENoCar(_cVar)
	_cVar := StrTran(_cVar,Chr(13) + Chr(10),' ')
	_cVar := StrTran(_cVar,Chr(13),' ')
	_cVar := StrTran(_cVar,Chr(10),' ')
	_cVar := StrTran(_cVar,Chr(9),' ')
Return _cVar
//+----------------------------------------------------------------------------------------------------------------
