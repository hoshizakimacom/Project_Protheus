#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//|	PE nas ações relacionadas do Cadastro de Visitas (PONA340)
//+---------------------------------------------------------------------------------------------------------
User Function P340ROTI()

Local _cUserName := "" 
Local _aMenu     := PARAMIXB[1]

_cUserName := UsrFullName(RetCodUsr())

If "GILDESIO" $ _cUserName .Or. "CLEBER" $ _cUserName
     aAdd( _aMenu,{ "Hr.Recebimento"  ,"U_M16A01('R')"	, 0 , 8, ,.F.})
Endif

If "JAN CARLOS" $ _cUserName .Or. "CLEBER" $ _cUserName 
     aAdd( _aMenu,{ "Hr.Carregamento" ,"U_M16A01('C')"	, 0 , 8, ,.F.})
Endif

Return _aMenu