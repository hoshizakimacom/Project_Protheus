#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
// 	Rotina respons�vel pelo calculo do acrescimo ou desconto de acordo com o valor
//	final informado pelo usu�rio.
// 	Chamada atrav�s do PE GMMA410BUT (A��es relacionadas) e tecla F2 do pedido de venda
//+---------------------------------------------------------------------------------------------------------
User Function M05A23()
	Local _aArea		:= GetArea()
	Local _oDlg			:= Nil
	Local _nValor		:= 0
	Local _cPicVal		:= '@E 999,999,999.99'
	Local _cTitle		:= 'Calcular Acr/Desc'

	Local _nOpc			:= 0

	If ALTERA .Or. INCLUI
		Define Dialog _oDlg From 000,000 To 155,350 Title _cTitle Pixel
			@018,020 Say  'Valor Total + IPI' Of _oDlg Colors CLR_GRAY Pixel
			@015,115 Say  Transform(TMP1->CK_XVLTBRU,_cPicVal) Of _oDlg Colors CLR_GRAY Pixel

			@033,020 Say  'Novo Valor Total + IPI' Of _oDlg Pixel
			@030,100 MsGet _nValor Size 055,011 Of _oDlg Pixel Valid U_M05V04("CK_DESCONT",_nValor) Picture _cPicVal
			
			@057,050 BUTTON "Aplicar" SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(_nValor > 0,(_nOpc := 1,_oDlg:End()), ))
			@057,095 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
		Activate MsDialog _oDlg Centered

		If _nOpc > 0
			MA07Proc(_nValor)
			oGetDad:oBrowse:Refresh(.T.)
		EndIf

		RestArea(_aArea)
	Else
		MsgInfo('Fun��o s� pode ser chamada na Altera��o ou Inclus�o de um pedido de venda.','Aten��o')
	EndIf

Return

//+---------------------------------------------------------------------------------------------------------
//
//+---------------------------------------------------------------------------------------------------------
Static Function MA07Proc(_nValor)
	Local _nDesc		:= TMP1->CK_DESCONT
	Local _nAcre		:= TMP1->CK_XACRESC
	Local _nBruto		:= 0

	Local _nDescNovo	:= 0
	Local _nAcreNovo	:= 0

	Private _cMsg		:= 'Deseja aplicar #1 de #2 ?'
	Private _cPicPer	:= '@E 999.999999'

//	REGTOMEMORY('SC6',.F.)

	//+-----------------------------------------
	// Limpa desconto
	//+-----------------------------------------
	If _nDesc > 0
		TMP1->CK_DESCONT  := 0
		M->CK_DESCONT     := 0

		U_M05G01('CK_DESCONT')
	EndIf

	//+-----------------------------------------
	// Limpa acr�scimo
	//+-----------------------------------------
	If _nAcre > 0
		TMP1->CK_XACRESC := 0

		M->CK_XACRESC	:= 0
		M->CK_XVLACR	:= 0

		U_M05G01('CK_XACRESC')
	EndIf

	_nBruto	:= TMP1->CK_XVLTBRU

	//+-----------------------------------------
	// Aplica Desconto
	//+-----------------------------------------
	If _nValor < _nBruto

		_nDescNovo		:= A410Arred(((_nValor / _nBruto ) - 1) * -100,'CK_DESCONT')

		TMP1->CK_DESCONT := _nDescNovo
		M->CK_DESCONT    := _nDescNovo

		U_M05G01('CK_DESCONT')
	EndIf

	//+-----------------------------------------
	// Aplica Acrescimo
	//+-----------------------------------------
	If _nValor > _nBruto

		_nAcreNovo		:= A410Arred(((_nValor / _nBruto ) - 1) * 100,'CK_XACRESC')

		TMP1->CK_XACRESC  := _nAcreNovo
		M->CK_XACRESC     := _nAcreNovo

		U_M05G01('CK_XACRESC')
	EndIf
Return

