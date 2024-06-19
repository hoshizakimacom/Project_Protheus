#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
// 	Rotina responsável pelo calculo do acrescimo ou desconto de acordo com o valor
//	final informado pelo usuário.
// 	Chamada através do PE GMMA410BUT (Ações relacionadas) e tecla F2 do pedido de venda
//+---------------------------------------------------------------------------------------------------------
User Function M05A07()
	Local _aArea		:= GetArea()
	Local _oDlg			:= Nil
	Local _nValor		:= 0
	Local _cPicVal		:= '@E 999,999,999.99'
	Local _cTitle		:= 'Calcular Acr/Desc'

	Local _nOpc			:= 0

	If ALTERA .Or. INCLUI
		Define Dialog _oDlg From 000,000 To 155,350 Title _cTitle Pixel
			@018,020 Say  'Valor Total + IPI' Of _oDlg Colors CLR_GRAY Pixel
			@015,115 Say  Transform(GDFieldGet('C6_XVLTBRU',N),_cPicVal) Of _oDlg Colors CLR_GRAY Pixel

			@033,020 Say  'Novo Valor Total + IPI' Of _oDlg Pixel
			@030,100 MsGet _nValor Size 055,011 Of _oDlg Pixel Valid U_M05V04("C6_DESCONT",_nValor) Picture _cPicVal

			@057,050 BUTTON "Aplicar" SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(_nValor > 0,(_nOpc := 1,_oDlg:End()), ))
			@057,095 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
		Activate MsDialog _oDlg Centered

		If _nOpc > 0
			MA07Proc(_nValor)
			oGetDad:oBrowse:Refresh(.T.)
		EndIf

		RestArea(_aArea)
	Else
		MsgInfo('Função só pode ser chamada na Alteração ou Inclusão de um pedido de venda.','Atenção')
	EndIf

Return

//+---------------------------------------------------------------------------------------------------------
//
//+---------------------------------------------------------------------------------------------------------
Static Function MA07Proc(_nValor)
	Local _nItem		:= n

	Local _nDesc		:= GDFieldGet('C6_DESCONT',_nItem)
	Local _nAcre		:= GDFieldGet('C6_XACRESC',_nItem)
	Local _nBruto		:= 0

	Local _nDescNovo	:= 0
	Local _nAcreNovo	:= 0

	Private _cMsg		:= 'Deseja aplicar #1 de #2 ?'
	Private _cPicPer	:= '@E 999.999999'

	REGTOMEMORY('SC6',.F.)

	//+-----------------------------------------
	// Limpa desconto
	//+-----------------------------------------
	If _nDesc > 0
		GDFieldPut('C6_DESCONT',0,_nItem)

		M->C6_DESCONT	:= 0

		U_M05G01('C6_DESCONT')
	EndIf

	//+-----------------------------------------
	// Limpa acréscimo
	//+-----------------------------------------
	If _nAcre > 0
		GDFieldPut('C6_XACRESC',0,_nItem)

		M->C6_XACRESC	:= 0
		M->C6_XVLACR	:= 0

		U_M05G01('C6_XACRESC')
	EndIf

	_nBruto	:= GDFieldGet('C6_XVLTBRU',_nItem)

	//+-----------------------------------------
	// Aplica Desconto
	//+-----------------------------------------
	If _nValor < _nBruto

		_nDescNovo		:= A410Arred(((_nValor / _nBruto ) - 1) * -100,'C6_DESCONT')

		GDFieldPut('C6_DESCONT',_nDescNovo,_nItem)
		M->C6_DESCONT := _nDescNovo

		U_M05G01('C6_DESCONT')
	EndIf

	//+-----------------------------------------
	// Aplica Acrescimo
	//+-----------------------------------------
	If _nValor > _nBruto

		_nAcreNovo		:= A410Arred(((_nValor / _nBruto ) - 1) * 100,'C6_XACRESC')

		GDFieldPut('C6_XACRESC',_nAcreNovo,_nItem)
		M->C6_XACRESC := _nAcreNovo

		U_M05G01('C6_XACRESC')
	EndIf
Return

