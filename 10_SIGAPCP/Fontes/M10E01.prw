#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'
#include "colors.ch"

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10E01()
	Local _oDlg		:= Nil
	Local _nOpca		:= 0
	Local _cTitulo	:= 'Etiqueta de Identificação'

	Local _cPedido	:= Space(TamSX3('C5_NUM')[1])
	Local _cItem		:= Space(TamSX3('C6_ITEM')[1])
	Local _cSerie		:= Space(TamSX3('B1_SERIE')[1])
	Public _cPedido 	:= ""
	Public _cSerie	    := ""

	ChkFile('ZA0')

	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 185,280 PIXEL

	@ 002,002 TO 70, 140 OF _oDlg PIXEL

	@ 010,010 SAY 'Pedido' 	SIZE 55, 07 OF _oDlg PIXEL
	@ 010,050 MSGET _cPedido SIZE 80, 11 F3 'SC5' OF _oDlg PIXEL

	@ 030,010 SAY 'Seq.' SIZE 55, 07 OF _oDlg PIXEL
	@ 030,050 MSGET _cItem SIZE 80, 11 OF _oDlg PIXEL

	@ 050,010 SAY 'Num. Série' SIZE 55, 07 OF _oDlg PIXEL
	@ 050,050 MSGET _cSerie SIZE 80, 11 OF _oDlg PIXEL

	DEFINE SBUTTON FROM 75, 40 TYPE 1 ACTION (_nOpca := 1,(M10EMain(@_cPedido,@_cItem,@_cSerie))) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 75, 80 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EMain(_cPedido,_cItem,_cSerie)
	Local _aDescr		:= {}
	Local _cProd		:= ''
	Local _cCliente	:= ''
	Local _cFantasia	:= ''
	Local _cXItemP	:= ''
	Local _cNum		:= ''
	Local _cHora		:= ''
	Local _lImpOk		:= .F.

	BeginTran()

		// Valida se Campos obrigatórios foram informados
		If M10EValObr(@_cPedido,@_cItem,_cSerie)

			// Busca informações do item
			M10EGetInf(_cPedido,_cItem,@_cProd,@_aDescr,@_cCliente,@_cFantasia,@_cXItemP,@_cSerie,@_cNum,@_cHora)

			// Exibe dados na tela e solicita confirmação do usuário
			If M10EConfir(_cPedido,_cXItemP,_cItem,_cSerie,_cProd,_aDescr,_cCliente,_cFantasia)

				// Atualiza status ZA0 e SC6
				If (_lImpOk := M10EStatus(_cPedido,_cItem,_cSerie,_cHora,_cProd))

					// Imprime Etiqueta
					M10EPrint(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)

					_cPedido	:= Space(TamSX3('C5_NUM')[1])
					_cItem		:= Space(TamSX3('C6_ITEM')[1])
					_cSerie	:= Space(TamSX3('B1_SERIE')[1])
				EndIf
			EndIf
		EndIf
	EndTran()
	MsUnlockAll()

	If _lImpOk
		MsgInfo('Etiqueta impressa com sucesso.')
	EndIf

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EValObr(_cPedido,_cItem,_cSerie)
	Local _lRet 	:= .T.

	_cPedido		:= StrZero(Val(_cPedido),TamSX3('C5_NUM')[1])
	_cItem			:= UPPER(IIF(Len(AllTrim(_cItem)) < TamSX3('C6_ITEM')[1],StrZero(Val(_cItem),TamSX3('C6_ITEM')[1]),_cItem))


	If !(_lRet := !Empty(_cPedido))
		MsgInfo('Pedido é obrigatório.')
	EndIf

	If _lRet .And. !(_lRet := !Empty(_cItem))
		MsgInfo('Sequencia é obrigatória.')
	EndIf

	If _lRet .And. !(_lRet := !Empty(_cSerie))
		MsgInfo('Número de Série é obrigatório.')
	EndIf

	If _lRet
		SC5->(DbGotop())
		SC5->(DbSetOrder(1))

		If (_lRet := (SC5->(DbSeek( xFilial('SC5') + _cPedido))))
			SC6->(DbGoTop())
			SC6->(DbSetOrder(1))

			If !(_lRet := (SC6->(DbSeek( xFilial('SC6') + SC5->C5_NUM + _cItem ))))
				MsgInfo('Pedido e sequencia não encontrados.')
			EndIf
		Else
			MsgInfo('Pedido não encontrado.')
		EndIf
	EndIf

Return _lRet
//+----------------------------------------------------------------------------------------------------------------
Static Function M10EConfir(_cPedido,_cXItemP,_cItem,_cSerie,_cProd,_aDescr,_cCliente,_cFantasia)
	Local _lRet	:= .T.
	Local _nX		:= 1
	Local _cDescr	:= ''

	For _nX := 1 To Len(_aDescr)
		_cDescr += _aDescr[_nX]
	Next


	_lRet := MsgYesNo('Confirma impressão da etiqueta abaixo?' + CRLF + CRLF;
							+ 'Produto.....: '		+ _cProd		+ ' - ' + _cDescr + CRLF + CRLF;
							+ 'Cliente.....: '		+ _cCliente	+ CRLF;
						)

Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EStatus(_cPedido,_cItem,_cSerie,_cHora,_cProd)
	Local _lOk			:= .T.
	Local _lReImp		:= .F.
	Local _nZA0Recno	:= 0

	// Verifica se trata-se de uma re-impressao
	_lOk := M10EGetReI(_cSerie,_cPedido,_cItem,@_lReImp,@_nZA0Recno)

	// Caso não seja reimpressão, verifica se trata-se de
	// uma re-alocação
	If _lOk .And. !_lReImp
		_lOk	:= M10EValRea(_cPedido,_cItem,_cSerie,_cHora)
	EndIf

	// Atualiza etapa
	If _lOk
		M10ESetEta(IIf(_lReImp,'I','A'),_cPedido,_cItem,_cSerie,_cHora,_cProd,_nZA0Recno)
	EndIf
Return _lOk


//+----------------------------------------------------------------------------------------------------------------
Static Function M10EGetReI(_cSerie,_cPedido,_cItem,_lReImp,_nZA0Recno)
	Local _lRet 		:= .T.
	Local _cAlias		:= GetNextAlias()
	Local _cRealoc	:= 'S'

	_nZA0Recno	:= 0

	BeginSql Alias _cAlias
		SELECT ZA0.R_E_C_N_O_ AS ZA0_RECNO
		FROM %Table:ZA0% ZA0
		WHERE ZA0.%NotDel%
			AND ZA0_FILIAL = %xFilial:ZA0%
			AND ZA0_SERIE  = %Exp:_cSerie%
			AND ZA0_REALOC <> %Exp:_cRealoc%
			AND ZA0_PV     = %Exp:_cPedido%
			AND ZA0_ITEMPV = %Exp:_cItem%
		ORDER BY ZA0.R_E_C_N_O_ DESC
	EndSql

	If (_cAlias)->(!EOF())
		If (_lRet := MsgYesNo('Etiqueta já impressa para este pedido,seq. e série.' + CRLF + 'Deseja reimprimir?'))
			_lReImp 	:= .T.
			_nZA0Recno	:= (_cAlias)->ZA0_RECNO
		EndIf
	EndIf

	(_cAlias)->(DbCloseArea())
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EValRea(_cPedido,_cItem,_cSerie,_cHora)
	Local _lRet		:= .T.
	Local _nOpc		:= 0
	Local _oDlg		:= Nil
	Local _cTitle		:= 'Confirmação do número de série'
	Local _aZA0		:= {}
	Local _lRealoc	:= M10EGetZA0(_cSerie,@_aZA0)
	Local _oEtapa		:= Nil
	Local _aEtapas	:= {}
	Local _cEtapa		:= {}
	Local _nRecno		:= 0
	_cPedido 	:= Space(TamSX3('C6_NUM')[1] + TamSX3('C6_ITEM')[1])

	If _lRealoc
		_aEtapas		:= _aZA0[1]
		_cEtapa		:= _aEtapas[1]

		Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME  From 000,000 To 320,520 Pixel
			@015,020 Say 	I18N('Série #1 já impressa anteriormente.',{AllTrim(_cSerie)}) Of _oDlg COLOR CLR_RED Pixel



			@035,020 Say 	'Informe ação desejada:' Of _oDlg Pixel

			@045,030 Say 	'-> Realocar: altera status da série selecionada para Realocada' Of _oDlg Pixel
			@055,030 Say 	'-> Alocar: altera status desta série para Expedição' Of _oDlg Pixel
			@065,030 Say 	'-> Cancelar: cancela operação' Of _oDlg Pixel

			@085,020 Say  'Pedido | Seq | Produto' Of _oDlg Pixel

			_oEtapa := TComboBox():New(085,090,{|u|if(PCount()>0,_cEtapa:=u,_cEtapa)},;
	        									_aEtapas,150,20,_oDlg,,,,,,.T.,,,,,,,,,'_cEtapa')

			@130,070 BUTTON "Realocar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_nOpc := 1,_lRet := .F.,_oDlg:End())
			@130,115 BUTTON "Alocar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_nOpc := 2,_lRet := .T.,_oDlg:End())
			@130,160 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_lRet := .F.,_oDlg:End())

		Activate MsDialog _oDlg  Centered

		If _nOpc == 1 // Realocar
			If Empty(_cEtapa)
				MsgInfo('Para realocação é obrigatório informar a série a ser realocada.')
			Else
				_nRecno := _aZA0[2][Val(SubStr(_cEtapa,1,AT('-',_cEtapa)-1)) + 1]

				If ValType(_nRecno) == 'N'

					 If ZA0->(!EOF())
						M10ESetEta('R',ZA0->ZA0_PV,ZA0->ZA0_ITEMPV,''/*_cSerie*/,_cHora/*_cHora*/,''/*_cProd*/,_nRecno)
						_lRet := .T.
		//				M05EMail(ZA0->ZA0_PV,ZA0->ZA0_ITEMPV,ZA0->ZA0_PROD,_cSerie,DToC(dDataBase) + _cHora)
					Else
						MsgInfo('Erro ao Realocar série.')
					EndIf

				Else
					MsgInfo('Erro ao realocar série.')
				EndIf
			EndIf
		EndIf
	EndIf

Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EGetZA0(_cSerie,_aZA0)
	
	Local _cAlias	:= GetNextAlias()
	Local _nNum	:= 0
	Local _aAux1	:= {' '}
	Local _aAux2	:= {0}
	Local _cRealoc:= 'S'
	Local _lRet	:= .F.
	_cSerie	:= PadR(_cSerie,TamSX3('ZA0_SERIE')[1],'')

	_aZA0	:= {}

	BeginSql Alias _cAlias
		SELECT  ZA0_PV
				,ZA0_ITEMPV
				,ZA0_PROD
				,ZA0.R_E_C_N_O_ AS ZA0_RECNO
		FROM %Table:ZA0% ZA0
		WHERE ZA0.%NotDel%
			AND ZA0_FILIAL = %xFilial:ZA0%
			AND ZA0_SERIE  = %Exp:_cSerie%
			AND ZA0_REALOC <> %Exp:_cRealoc%
		ORDER BY ZA0_PV,ZA0_ITEMPV,ZA0_PROD
	EndSql

	If (_cAlias)->(!EOF())
		_lRet := .T.

		While (_cAlias)->(!EOF())
			AAdd(_aAux1	,CValToChar(++_nNum) + ' - Pedido: ' + (_cAlias)->ZA0_PV + ' | Seq.: ' + (_cAlias)->ZA0_ITEMPV	+ ' | Produto: ' + (_cAlias)->ZA0_PROD		)
			AAdd(_aAux2	,(_cAlias)->ZA0_RECNO)

			(_cAlias)->(DbSkip())
		EndDo

		AAdd(_aZA0,AClone(_aAux1))
		AAdd(_aZA0,AClone(_aAux2))
	EndIf

	(_cAlias)->(DbcloseArea())
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M10ESetEta(_cTipo,_cPedido,_cItem,_cSerie,_cHora,_cProd,_nRecno)

	ZA0->(DbgoTop())
	ZA0->(DbGoTo(_nRecno))

	Do Case
		Case _cTipo == 'A'	// Alocação
			RecLock('ZA0',.T.)
				ZA0->ZA0_FILIAL	:= xFilial('ZA0')
				ZA0->ZA0_PV		:= _cPedido
				ZA0->ZA0_ITEMPV	:= _cItem
				ZA0->ZA0_SERIE	:= _cSerie
				ZA0->ZA0_PROD		:= _cProd
				ZA0->ZA0_QTDIMP	:= 1
				ZA0->ZA0_DATA		:= dDataBase
				ZA0->ZA0_HORA		:= _cHora
				ZA0->ZA0_USER		:= AllTrim(UsrRetName(RetCodUsr()))
				ZA0->ZA0_REALOC	:= 'N'
			ZA0->(MsUnLock())

			M10ESetSC6(_cPedido,_cItem,'9')

		Case _cTipo == 'R'	// Realocação
			RecLock('ZA0',.F.)
				ZA0->ZA0_REALOC		:= 'S'
				ZA0->ZA0_USREAL		:= AllTrim(UsrRetName(RetCodUsr()))
				ZA0->ZA0_DTREAL		:= dDataBase
				ZA0->ZA0_HRREAL		:= _cHora
			ZA0->(MsUnLock())

			M10ESetSC6(_cPedido,_cItem,'F',_cHora)
		Case _cTipo == 'I'	// Impressão
			RecLock('ZA0',.F.)
				ZA0->ZA0_QTDIMP	:= ZA0->ZA0_QTDIMP + 1
				ZA0->ZA0_DATA		:= dDataBase
				ZA0->ZA0_HORA		:= _cHora
				ZA0->ZA0_USER		:= AllTrim(UsrRetName(RetCodUsr()))
				ZA0->ZA0_REALOC	:= 'N'
			ZA0->(MsUnLock())
	EndCase
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10ESetSC6(_cPedido,_cItem,_cEtapa,_cHora)

	Default _cHora := ''

	SC6->(DbGoTop())
	SC6->(DbSetOrder(1))

	If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
		RecLock('SC6',.F.)
			SC6->C6_XETAPA := _cEtapa // Exped

			// Se Realozação
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
	Local _oFontG1 		:= TFont():New('Arial',,30,.T.,.T.)
	Local _oFontG2 		:= TFont():New('Arial',,28,.T.,.T.)
	Local _oFontM1 		:= TFont():New('Arial',,15,.T.,.T.)
	Local _oFontP2 		:= TFont():New('Arial',,13)
	Local _oFontP1 		:= TFont():New('Arial',,12)
	Local _nColIni		:= 040
	Local _nCol02			:= _nColIni + 120
	Local _nCol03			:= _nCol02 + 600
	Local _nCol04			:= _nCol03 + 120
	Local _nNextLin		:= 60
	Private _nAlin			:= 10 - Len(_cXItemP)

	_oPrinter := FWMSPrinter():New('M10E001' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,2)

	_oPrinter:SetResolution(78)
	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:StartPage()

	//+-------------------------------------------------------------------------
	// Area 1
	//+-------------------------------------------------------------------------

	_oPrinter:SayBitMap( _nRow - 10, _nColIni + 40,GetSrvProfString("Startpath","") + "M10E001.bmp",60 * 3.5 ,17 * 3.5)
	_oPrinter:Say(_nRow + 20,_nCol03,'AÇOS MACOM IND. COM. LTDA',_oFontP1)

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

	_oPrinter:Say(_nRow,_nColIni,'Cód.:',_oFontP2)
	_oPrinter:Say(_nRow,_nCol02,_cProd,_oFontM1)

	_oPrinter:Say(_nRow,_nCol03,'Série:',_oFontP2)
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

	_oPrinter:Say(_nRow + _nNextLin	,630, _cXItemP, _oFontG2)

	_nRow += _nNextLin * 0.3

	_oPrinter:Say(_nRow, _nCol02 + 30 , DToC(dDataBase) + ' ' + _cHora, _oFontP1)

	_nRow += _nNextLin * 0.8
	_oPrinter:Say(_nRow, _nColIni + 25, _cNum, _oFontP1)

	_oPrinter:FWMSBAR('CODE128',17.5/*nRow*/,1/*nCol*/,_cNum,_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.7/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)

	_oPrinter:SetDevice(IMP_SPOOL)
	_oPrinter:cPrinter 		:= 'ZEBRA'

	_oPrinter:EndPage()
	_oPrinter:Print()

	FreeObj(_oPrinter)
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M10EGetInf(_cPedido,_cItem,_cProd,_aDescr,_cCliente,_cFantasia,_cXItemP,_cSerie,_cNum,_cHora)
	Local _cDescr		:= ''
	_cHora			:= Time()
	_cCliente 		:= Posicione('SA1',1,xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI),'A1_NOME')
	_cFantasia 	:= Posicione('SA1',1,xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI),'A1_NREDUZ')

	_cXItemP		:= SubStr(AllTrim(SC6->C6_XITEMP),1,10)
	_cNum			:= AllTrim(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM + _cSerie)
	_cProd			:= AllTrim(SC6->C6_PRODUTO)
	_cDescr		:= Posicione('SB1',1,xFilial('SB1') + SC6->C6_PRODUTO,'B1_DESC')
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
Static Function M10ENoCar(_cVar)
	_cVar := StrTran(_cVar,Chr(13) + Chr(10),' ')
	_cVar := StrTran(_cVar,Chr(13),' ')
	_cVar := StrTran(_cVar,Chr(10),' ')
	_cVar := StrTran(_cVar,Chr(9),' ')
Return _cVar

//+----------------------------------------------------------------------------------------------------------------
Static Function M05EMail(_cPedido,_cItem,_cProduto,_cSerie,_cData)
	Private _cServer		:= ALLTRIM(GetMv("MV_RELSERV"))	//Nome do servidor de envio de e-mail
	Private _cAccount		:= ALLTRIM(GetMv("MV_RELACNT"))	//Conta a ser utilizada no envio de e-mail
	Private _cPassword		:= ALLTRIM(GetMv("MV_RELPSW"))	//Senha da conta de e-mail para envio
	Private _lAutentica		:= GetMv("MV_RELAUTH")			//Determina se o Servidor de Email necessita de Autenticacao
	Private _cCabec			:= ''
	Private _cTitulo 		:= 'Produto realocado. Série: ' + _cSerie
	Private _cDe     		:= "schedule@cyberpolos.com.br"

   cPara   := "fbalthazar@marchon.com.br"
   cCo     := "gmagalhaes@marchon.com.br;alessandro.taki@polosit.com.br"
   cAssunto:= _cTitulo
   cAnexo  := ""



	_cCabec := '<html>'
	_cCabec += '<body>'
	_cCabec += '<p><font face="Arial" size="2"><br>'
	_cCabec += 'Produto realocado através da impressão de etiqueta (Expedição)<br></p><br></p>'
	_cCabec += 'Filial: '		+ xFilial('ZA0')		+ '<br></p>'
	_cCabec += 'Pedido: '		+ _cPedido				+ '<br></p>'
	_cCabec += 'Seq.: '			+ _cItem				+ '<br></p>'
	_cCabec += 'Produto: '		+ _cProduto			+ '<br></p>'
	_cCabec += 'Usuário: '		+ _cUser				+ '<br></p>'
	_cCabec += 'Data: '			+ _cData				+ '<br></p>'
	_cCabec += '<br><br><br>
	_cCabec += '</body>'
	_cCabec += '</html>'



   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lOk

   If lAutentica
      If !MailAuth(cAccount,cPassword)
         DISCONNECT SMTP SERVER
      Else
         SEND MAIL FROM _cAccount;
         TO _cPara;
         BCC cCo;
         SUBJECT cAssunto;
         BODY _cCabec;
         ATTACHMENT cAnexo;
         RESULT lEnviado

         If !lEnviado
            cMensagem := ""
            GET MAIL ERROR cMensagem
            ConOut(cMensagem)
         Endif

         DISCONNECT SMTP SERVER Result lDisconectou
      Endif
   Endif
Return

//+----------------------------------------------------------------------------------------------------------------
