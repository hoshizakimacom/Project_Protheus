#Include 'Protheus.ch'


/*/{Protheus.doc} SE5FI070

PE chamado após gravação do SE5 na baixa do contas a receber.

@type method
@author Marcos Antonio Montes
@since 21/03/2024
/*/

User Function SE5FI070()
	Local _aArea	 := GetArea()
	Local oTituloCRA := Nil

	If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL" .And. SE5->E5_MOTBX $ "NOR/CAC/BND/FIN" .And. SE5->E5_TIPODOC $ "VL/V2/BA"

		oTituloCRA := ClassTituloCRA():New()
		If !oTituloCRA:Inclui()
			Aviso("SE5FI070",oTituloCRA:RetError(),{"Fechar"})
		EndIf

		//+---------------------------------------------------------------------------------
    	//  Verifica a existencia do titulo CRA / NF para compensação automática pelo Pedido
    	//+---------------------------------------------------------------------------------
		If !oTituloCRA:Compensa(SE1->E1_PEDIDO)
			Aviso("SE5FI070_CRA",oTituloCRA:RetError(),{"Fechar"})
		EndIf

	EndIf
 
	RestArea(_aArea)
Return
