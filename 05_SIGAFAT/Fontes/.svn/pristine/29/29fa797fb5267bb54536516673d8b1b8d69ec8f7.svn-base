#Include 'Protheus.ch'

//+-----------------------------------------------------------------------------
// Responsável pelo retorno do tipo de operação
//+-----------------------------------------------------------------------------
User Function M05A02(_cTpCli,_cTpProd)
	Local _cRet	:= '01'

	Do Case
		Case _cTpCli == 'F' .And. _cTpProd == 'ME'
			_cRet := '38'
		Case _cTpCli == 'R' .And. _cTpProd == 'ME'
			_cRet := '02'
		Case _cTpCli == 'X' .And. _cTpProd == 'PA'
			_cRet := '28'
		Case _cTpCli == 'X' .And. _cTpProd == 'ME'
			_cRet := '39'
	EndCase
Return _cRet