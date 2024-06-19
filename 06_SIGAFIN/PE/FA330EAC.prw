#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------
//	Utilizado na exclusão de compensação de contas a receber, antes da contabilização
//+----------------------------------------------------------------------------------------
User Function FA330EAC()
	Local _aArea		:= GetArea()
	Local _cRAPre		:= 'PVA'
	Local _nValor		:= 0

	// Retira saldo a compensar do PVA
	If SE5->E5_PREFIXO == _cRAPre .AND. SE5->E5_TIPODOC $ '|CP|ES|' .AND. SE5->E5_MOTBX = 'CMP'

		DbSelectArea('SE1')
		SE1->(DbGoTop())
		SE1->(DbSetOrder(1))	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		If SE1->(DbSeek(xFilial('SE1') + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
			_nValor := IIf(Type('nValorBaixa') == 'N',nValorBaixa,SE5->E5_VALOR)
			U_M06A01('-',_nValor)
		EndIf
	EndIf

	RestArea(_aArea)
Return