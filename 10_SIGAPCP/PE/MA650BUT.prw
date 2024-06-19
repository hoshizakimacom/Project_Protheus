#Include 'Protheus.ch'

//+----------------------------------------------------------------------
//|	Ponto de entrada nas ações relacionadas da tela de Ordem de Produção
//+----------------------------------------------------------------------
User Function MA650BUT()

	Aadd(aRotina,{OemToAnsi('Arquivo - Anexar')			,'U_M10A02A'	, 0 , 2})
	Aadd(aRotina,{OemToAnsi('Arquivo - Visualizar')		,'U_M10A02B'	, 0 , 2})
	Aadd(aRotina,{OemToAnsi('Imprimir')				    ,'U_M10R01'	    , 0 , 2})
	Aadd(aRotina,{OemToAnsi('Picking-List')             ,'U_M10R12'     , 0 , 2})
	Aadd(aRotina,{OemToAnsi('Gera Num. de Serie')		,'U_M10A03'		, 0 , 2})
	Aadd(aRotina,{OemToAnsi('Consulta Num. de Serie')	,'U_M10A04'		, 0 , 2})
	Aadd(aRotina,{OemToAnsi('Desvincula Op x Pv')       ,'U_M10A08'		, 0 , 2})
	
Return AClone(aRotina)

