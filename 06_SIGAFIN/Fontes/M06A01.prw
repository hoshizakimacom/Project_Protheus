#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------
// 	Rotina chamada do PE SACI008, SE5FI330 e FA110SE5
//	Responsável pela atualização do valor do saldo a compensar dos titulos de RA customizado
//+------------------------------------------------------------------------------------------
User Function M06A01(_cOpc,_nValor)
	Local _aArea		:= GetArea()
	Local _aAreaSE1		:= SE1->(GetArea())
	Local _aAreaSE5		:= SE5->(GetArea())

	Default _nValor		:= 0

	Do Case
		Case _cOpc == '+'
			MA01Inclui(_nValor)

		Case _cOpc == '-'
			MA01Deleta(_nValor)

	EndCase

	RestArea(_aAreaSE5)
	RestArea(_aAreaSE1)
	RestArea(_aArea)
Return

//+------------------------------------------------------------------------------------------
//	Incluir saldo a compensar
//+------------------------------------------------------------------------------------------
Static Function MA01Inclui(_nValor)
	Local _cRAPre		:= 'PVA'


	If AllTrim(SE5->E5_PREFIXO) == _cRAPre .And. _nValor > 0 .And. SE1->(FieldPos('E1_XSALDO')) > 0
		DbSelectArea('SE1')
		SE1->(DbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		SE1->(DbGoTop())

		If SE1->(DbSeek(xFilial('SE1') + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO))
			RecLock('SE1',.F.)
				SE1->E1_XSALDO := SE1->E1_XSALDO + _nValor
			SE1->(MsUnLock())
		EndIf
	ElseIf Type('nAltVal') == 'N' .And. nAltVal > 0 .And. SE1->(FieldPos('E1_XSALDO')) > 0 .And. SE1->E1_PREFIXO == 'PVA'
		RecLock('SE1',.F.)
			SE1->E1_XSALDO := SE1->E1_XSALDO + nAltVal
		SE1->(MsUnLock())
	EndIf

Return

//+------------------------------------------------------------------------------------------
//	Incluir saldo a compensar
//+------------------------------------------------------------------------------------------
Static Function MA01Deleta(_nValor)
	Local _cRAPre		:= 'PVA'

	If AllTrim(SE1->E1_PREFIXO) == _cRAPre .And. _nValor > 0 .And. SE1->(FieldPos('E1_XSALDO')) > 0
		RecLock('SE1',.F.)
			SE1->E1_XSALDO := SE1->E1_XSALDO - _nValor
		SE1->(MsUnLock())
	EndIf
Return