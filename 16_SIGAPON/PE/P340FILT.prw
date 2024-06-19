#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//|	PE para aplicar filtro no browse da rotina PONA340 - Cadastro de Visitas
//+---------------------------------------------------------------------------------------------------------
User Function P340FILT()

Local _cFiltro    := ""
Local _cUserName  := ""

_cUserName := UsrFullName(RetCodUsr())

If "ROGERIO" $ _cUserName .Or. "GILDESIO" $ _cUserName .Or. "FABIO" $ _cUserName .Or. "WALLACE" $ _cUserName     
	_cFiltro := "SPY->PY_MAT == '001513' .Or. SPY->PY_MAT == '001930' .Or. SPY->PY_MAT == '000922' .Or. SPY->PY_MAT == '000131'"  
ElseIf "JAN CARLOS" $ _cUserName
    _cFiltro := "SPY->PY_MAT == '002086'
Endif

Return _cFiltro