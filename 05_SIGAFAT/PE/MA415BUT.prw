#Include 'Protheus.ch'

User Function MA415BUT()

    Local _aArea        := GetArea()
    Local _aRotina      := {}

    AAdd(_aRotina   ,{'NOTE'        ,{|| U_M05A23()     },"Calcular Acr/Desc"           ,"Calcular Acr/Desc"            })
    AAdd(_aRotina	,{'NOTE'		,{|| U_M5A33Inc()	},"Cadastrar Follow Up"			,"Cadastrar Follow Up"			})

    SetKey( VK_F2,          { || U_M05A23() } )

    RestArea(_aArea)
Return _aRotina

