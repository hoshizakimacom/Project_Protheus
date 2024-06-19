#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------
//	Ponto de Entrada que permite realizar grava��es complementares na tabela SE5,
//	ap�s a grava��o do movimento banc�rio do t�tulo principal na compensa��o a
//	receber autom�tica.
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
