#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//	Ponto de entrada para adicionar botoes na enchoice do pedido de venda MATA040
//+---------------------------------------------------------------------------------------------------------
User Function GMMA410BUT()
	Local _aArea		:= GetArea()
	Local _aRotina		:= {}

	AAdd(_aRotina	,{'NOTE'		,{|| U_M05A07() 	},"Calcular Acr/Desc"			,"Calcular Acr/Desc"			})

	SetKey( VK_F2,			{ || U_M05A07() } )

	RestArea(_aArea)
Return AClone(_aRotina)