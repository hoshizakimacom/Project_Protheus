#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------
//	Ponto de Entrada que permite realizar gravações complementares na tabela SE5,
//	após a gravação do movimento bancário do título principal na compensação a
//	receber automática.
//+----------------------------------------------------------------------------------------
User Function SE5FI330()
	Local _aArea		:= GetArea()
	Local _cRAPre		:= 'PVA'

	// Inclui saldo a compensar no PVA
	If SE1->E1_PREFIXO == _cRAPre
		U_M06A01('+',0)
	EndIf

	RestArea(_aArea)
Return
