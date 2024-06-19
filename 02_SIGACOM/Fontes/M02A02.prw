#Include 'Protheus.ch'
#include "colors.ch"

Static _cPedido	:= ''
Static _cXItemP	:= ''
Static _cProdC	:= ''
Static _cProdV	:= ''
Static _cObsCom	:= ''
Static _cEtapa	:= ''
Static _cCliente	:= ''
Static _cItem		:= ''
Static _nQtdVen	:= 0

Static _cNumPCom	:= ''
Static _cItemPC	:= ''
Static _cFornece	:= ''
Static _cDescP	:= ''
Static _nQtdCom	:= 0

//+-------------------------------------------------------------------
//	Esta rotina tem como objetivo atualizar a etapa do item do pedido
//	de venda para "Sol Compra"
//+-------------------------------------------------------------------
User Function M02A02()
	Local _oDlg		:= Nil
	Local _aSize		:= FwGetDialogSize(oMainWnd)
	Local _cTitulo	:= 'Apontamento Compras'

	Local _bConfPV	:= {||( M02AGetPV())}
	Local _bConfPC	:= {||( M02AGetPC())}

	Local _oPedido	:= Nil
	Local _oItem		:= Nil
	Local _oCliente	:= Nil
	Local _oFornece	:= Nil
	Local _oEtapa		:= Nil
	Local _oXItemP	:= Nil
	Local _oProdC	:= Nil
	Local _oProdV	:= Nil
	Local _oQtdVen	:= Nil
	Local _oScr1		:= Nil

	Local _oNumPCom	:= Nil
	Local _oItemPC	:= Nil
	Local 	_oDescP	:= Nil
	Local _oQtdCom	:= Nil
	Private _oProd		:= Nil


	M02AClrPV(.T.)
	M02AClrPC(.T.)

	Define MsDialog _oDlg Title _cTitulo Style DS_MODALFRAME From  _aSize[1], _aSize[2] To _aSize[3], _aSize[4] Pixel

		//+----------------------------------------------------------------------------
		// Pedido de Venda
		//+----------------------------------------------------------------------------
		@085,010 GROUP _oGroupPV TO 300, 310 PROMPT 'Dados do Pedido de Venda' OF _oDlg COLOR CLR_GRAY PIXEL

		@015,020 Say  'Pedido de Venda:' Of _oDlg Pixel
		@012,080 Get _oPedido Var _cPedido Size 100,011 Of _oDlg Pixel Valid (Empty(_cPedido) .Or. ExistCpo('SC5',_cPedido))

		_oPedido:bLostFocus := _bConfPV

		@032,020 Say  'Sequência:' Of _oDlg Pixel
		@029,080 Get _oItem Var _cItem Size 100,010 Of _oDlg Pixel Valid (Empty(_cItem) .Or. Empty(_cPedido) .Or. ExistCpo('SC6',_cPedido + _cItem))

		_oItem:bLostFocus := _bConfPV

		@049,020 Say 'Etapa Atual:' Of _oDlg Pixel
		@046,080 Get _oEtapa Var _cEtapa Size 100,010 Of _oDlg Pixel WHEN .F.

		@105,020 Say  'Cliente:'  Of _oDlg Pixel
		@102,080 Get _oCliente Var _cCliente Size 180,010 Of _oDlg Pixel WHEN .F.

		@120,020 Say  'Produto:'  Of _oDlg Pixel
		@117,080 Get _oProdV Var _cProdV Size 100,010 Of _oDlg Pixel WHEN .F.

		@135,020 Say  'Item:'  Of _oDlg Pixel
		@132,080 Get _oXItemP Var _cXItemP Size 100,010 Of _oDlg Pixel WHEN .F.

		@150,020 Say  'Quantidade'  Of _oDlg Pixel
		@147,080 Get _oQtdVen Var Transform(_nQtdVen,"@E 999,999.9999")    Size 100,010 Of _oDlg Pixel WHEN .F.

		@165,020 Say  'Descr. Pedido:' Of _oDlg Pixel
		_oScr1 := TScrollBox():New(_oDlg,162,080,080,180,.T.,.T.,.T.)
		@005,005 Say {||_cObsCom} Size 180,200 Of _oScr1 Pixel

		//+----------------------------------------------------------------------------
		//	Pedido de Compra
		//+----------------------------------------------------------------------------

		@015,360 Say  'Pedido de Compra:' Of _oDlg Pixel
		@012,420 Get _oNumPCom Var _cNumPCom Size 100,011 Of _oDlg Pixel

		_oNumPCom:bLostFocus := _bConfPC

		@032,360 Say  'Sequência:' Of _oDlg Pixel
		@029,420 Get _oItemPC Var _cItemPC Size 100,010 Of _oDlg Pixel

		_oItemPC:bLostFocus := _bConfPC

		@085,350 GROUP _oGroupPV TO 300, 650 PROMPT 'Dados do Pedido de Compra' OF _oDlg COLOR CLR_GRAY PIXEL

		@105,360 Say  'Fornecedor:'  Of _oDlg Pixel
		@103,420 Get _oFornece Var _cFornece Size 180,010 Of _oDlg Pixel WHEN .F.

		@120,360 Say  'Produto:'  Of _oDlg Pixel
		@117,420 Get _oProdC Var _cProdC Size 180,010 Of _oDlg Pixel WHEN .F.

		@135,360 Say  'Descrição:' Of _oDlg Pixel
		@132,420 Get _oDescP Var _cDescP Size 180,010 Of _oDlg Pixel WHEN .F.

		@150,360 Say  'Quantidade'  Of _oDlg Pixel
		@147,420 Get _oQtdCom Var Transform(_nQtdCom,"@E 999,999.9999")    Size 100,010 Of _oDlg Pixel WHEN .F.

		@010,600 BUTTON "Confirmar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION ( M02AOk() )
		@040,600 BUTTON "Cancelar" 		SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())

	Activate MsDialog _oDlg Centered
Return

//+-------------------------------------------------------------------
Static Function M02AOk()

	If M02AValid()

		RecLock('SC6',.F.)
			SC6->C6_XETAPA 	:= 'G' // Sol Compra
			SC6->C6_XSCODT	:= dDataBase
			SC6->C6_XSCOHR	:= Time()
			SC6->C6_XSCOUS	:= Upper(UsrRetName(RetCodUsr()))
			SC6->C6_NUMPCOM	:= _cNumPCom
			SC6->C6_ITEMPC	:= _cItemPC
		SC6->(MsUnLock())

		MsgInfo('Etapa apontada com sucesso!','OK')

		M02AClrPV(.T.)
		M02AClrPC(.T.)

	EndIf
Return

//+-------------------------------------------------------------------
Static Function M02AValid()
	Local _lRet			:= .F.
	Local _cAtuDes		:= ''

	//+------------------------------
	// Verifica campos obrigatórios
	//+------------------------------
	If !(_lRet := !Empty(_cPedido) .And. !Empty(_cItem) .And. !Empty(_cNumPCom) .And. !Empty(_cItemPC))
		MsgInfo('Todos os campos são obrigatórios.' + CRLF + 'Verifique.','Atenção')
	EndIf

	//+----------------------------------
	// Verifica se pedido de venda existe
	//+----------------------------------
	If  _lRet
		SC6->(DbGoTop())
		SC6->(DbSetOrder(1))

		If !(_lRet := (SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))))
			MsgStop(I18N('Pedido de Venda #1 e sequência #2 não localizados.',{_cPedido,_cItem}))
		EndIf
	EndIf

	//+------------------------------------
	// verifica se pedido de compra existe
	//+------------------------------------
	If  _lRet
		SC7->(DbGoTop())
		SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

		If !(_lRet := (SC7->(DbSeek(xFilial('SC7') + PadR(AllTrim(_cNumPCom),TamSX3('C7_NUM')[1]) + PadR(AllTrim(_cItemPC),TamSX3('C7_ITEM')[1])))))
			MsgStop(I18N('Pedido de Compra #1 sequência #2 não localizados.',{_cNumPCom,_cItemPC}))
		EndIf
	EndIf

	//+------------------------------------------------------------------------------
	// verifica ja pedido de compra já informado anteriormente no pedido de venda
	//+------------------------------------------------------------------------------
	If _lRet .And. (!Empty(SC6->C6_NUMSC) .Or. !Empty(SC6->C6_ITEMSC))
		_lRet:= MsgYesNo(I18N('Pedido de Compra #1 sequência #2 já informados.' + CRLF + 'Deseja substituir?',{SC6->C6_NUMSC,SC6->C6_ITEMSC}),'Atenção')
	EndIf

	// Valida ordem de etapa
	If _lRet
		_lRet := U_M05A22('G' ,_cPedido,_cItem,@_cAtuDes)

		If ! _lRet
			MsgInfo(I18N('Apontamento não permitido.' + CRLF + CRLF + 'Motivo: Item já se encontra na etapa #1 .',{AllTrim(_cAtuDes)}),'Atenção')
		EndIf
	EndIf

Return _lRet

//+-------------------------------------------------------------------------------------------
Static Function M02AClrPV(_lPV)
	Default _lPV := .T.

	If _lPV
		_cPedido	:= Space(TamSX3('C6_NUM')[1])

		_cCliente	:= ''
	EndIf

	_cItem		:= Space(TamSX3('C6_ITEM')[1])
	_cObsCom	:= ''
	_cXItemP	:= ''
	_cProdV		:= ''
	_nQtdVen	:= 0
	_cEtapa	:= ''
Return

//+-------------------------------------------------------------------------------------------
Static Function M02AClrPC(_lPC)
	Default _lPC := .T.

	If _lPC
		_cNumPCom	:= Space(TamSX3('C7_NUM')[1])
		_cFornece	:= ''
	EndIf

	_cItemPC	:= Space(TamSX3('C7_ITEM')[1])
	_cDescP	:= ''
	_cProdC		:= ''
	_nQtdCom	:= 0
Return

//+-------------------------------------------------------------------------------------------
Static Function M02AGetPV()

	If !Empty(_cPedido)
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())

		If SC5->(DbSeek(xFilial('SC5') + _cPedido))
			_cCliente 	:= AllTrim(Posicione('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_NOME'))
		Else
			MsgStop(I18N('Pedido de Venda #1 não localizado.',{_cPedido}))
			M02AClrPV(.T.)
		EndIf
	Else
		M02AClrPV(.T.)
	EndIf

	If !Empty(_cItem)
		If !Empty(_cPedido)
			SC6->(DbSetOrder(1))
			SC6->(DbGoTop())

			If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
				_cObsCom 	:= M02AGetDes()
				_cXItemP	:= SC6->C6_XITEMP
				_cProdV		:= SC6->C6_PRODUTO
				_nQtdVen	:= SC6->C6_QTDVEN
				_cEtapa	:= M02AGetEt()
			Else
				MsgStop(I18N('Pedido de Venda #1 sequência #2 não localizados.',{_cPedido,_cItem}))
				M02AClrPV(.F.)
			EndIf
		EndIf
	Else
		M02AClrPV(.F.)
	EndIf
Return

//+-------------------------------------------------------------------------------------------
Static Function M02AGetPC()

	If !Empty(_cNumPCom)
		SC7->(DbSetOrder(1))
		SC7->(DbGoTop())

		If SC7->(DbSeek(xFilial('SC7') + PadR(AllTrim(_cNumPCom),TamSX3('C7_NUM')[1]) ))
			_cFornece 	:= AllTrim(Posicione('SA2',1,xFilial('SA2') + SC7->C7_FORNECE + SC7->C7_LOJA,'A2_NOME'))
		Else
			MsgStop(I18N('Pedido de Compra #1 não localizado.',{_cNumPCom}))
			M02AClrPC(.T.)
		EndIf
	Else
		M02AClrPC(.T.)
	EndIf

	If !Empty(_cItemPC)
		If !Empty(_cNumPCom)
			SC7->(DbSetOrder(1))
			SC7->(DbGoTop())

			If SC7->(DbSeek(xFilial('SC7') + PadR(AllTrim(_cNumPCom),TamSX3('C7_NUM')[1]) + PadR(AllTrim(_cItemPC),TamSX3('C7_ITEM')[1]) ))
				_cProdC		:= SC7->C7_PRODUTO
				_cDescP		:= SC7->C7_DESCRI
				_nQtdCom	:= SC7->C7_QUANT
			Else
				MsgStop(I18N('Pedido de Compra #1 sequência #2 não localizados.',{_cNumPCom,_cItemPC}))
				M02AClrPC(.F.)
			EndIf
		EndIf
	Else
		M02AClrPC(.F.)
	EndIf
Return

//+-------------------------------------------------------------------------------------------
Static Function M02AGetDes()
	Local lFiname		:= SC5->C5_CONDPAG $ AllTrim(SuperGetMV("AM_FINAME ", , "")) // checa se a condicao de pagamento faz parte do FINAME
	Local cDescRet	    := ""
	Private lDescom		:= .F.

	SB1->(dbSetOrder(1))
	SB1->(DbGotop())
	SB1->(dbSeek(xFilial("SB1")+ SC6->C6_PRODUTO))


	If lFiname
	   cDescRet := AllTrim(Posicione('ZA4',1,xFilial('ZA4') + SB1->B1_XFINAME,'ZA4_DESC'))
	Else
		cDescRet := AllTrim(SB1->B1_DESC)
	EndIf

Return cDescRet

//+-------------------------------------------------------------------------------------------
Static Function M02AGetEt()
	Local _cRet	:= ''

	_cRet := Posicione("ZA3",1,XFILIAL("ZA3") + SC6->C6_XETAPA,"ZA3_DESCRI")

Return _cRet

//+-------------------------------------------------------------------------------------------
