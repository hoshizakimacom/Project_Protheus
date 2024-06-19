#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------
//	Valida hierarquia da etapa do item do pedido de venda
//	Chamada pelos fontes:
//		- M10A01.PRW	Apontamento de Produ��o
//		- M05A21.PRW	Apontamento Tec. Comercial
//		- M02A02.PRW	Apontamento Compras
//+-------------------------------------------------------------------------------
User Function M05A22(_cEtapaNov,_cPV,_cItemPV,_cEtapaDes)
	Local _aArea	:= GetArea()
	Local _aAreaZA3	:= ZA3->(GetArea())
	Local _aAreaSC6	:= SC6->(GetArea())

	Local _lRet		:= .T.

	Local _cEtapaAtu:= ''

	Local _nOrdAtu	:= 0
	Local _nOrdNov	:= 0

	Default _cEtapaAtu := ''

	// Retorna etapa atual do item do pedido de venda
	_cEtapaAtu := M05AGetAtu(_cPV,_cItemPV,@_cEtapaDes)

	// Retorna Ordem das etapas
	_nOrdAtu := M05AGetOrd(_cEtapaAtu)
	_nOrdNov := M05AGetOrd(_cEtapaNov)

	_lRet := _nOrdAtu <= _nOrdNov

	RestArea(_aAreaSC6)
	RestArea(_aAreaZA3)
	RestArea(_aArea)
Return _lRet

//+-------------------------------------------------------------------------------
Static Function M05AGetOrd(_cEtapa)
	Local _cRet	:= ''

	_cRet := Posicione('ZA3',1, xFilial('ZA3') + PadR(AllTrim(_cEtapa),TamSX3('ZA3_CODIGO')[1]),'ZA3_ORDEM' )

Return Val(_cRet)

//+-------------------------------------------------------------------------------
Static Function M05AGetAtu(_cPV,_cItemPV,_cEtapaDes)
	Local _cRet	:= ''

	// Verifica se possui Pedido de Venda
	If !Empty(_cPV) .And. !Empty(_cItemPV)
		_cRet 		:= Posicione('SC6',1,xFilial('SC6') + PadR(AllTrim(_cPV),TamSx3('C6_NUM')[1]) + PadR(AllTrim(_cItemPV),TamSx3('C6_ITEM')[1]),'C6_XETAPA')
		_cEtapaDes 	:= Posicione('ZA3',1,xFilial('ZA3') + PadR(AllTrim(_cRet),TamSx3('ZA3_CODIGO')[1]),'ZA3_DESCRI')
	EndIf

Return _cRet

//+-------------------------------------------------------------------------------
