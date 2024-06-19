#Include 'Protheus.ch'

/*/{Protheus.doc} SACI008

PE chamado após gravação da baixa a receber.

@type method
@author Não registrado
@since Não registrado
/*/
User Function SACI008()
	Local _aArea	:= GetArea()
	//Local oTituloCRA := Nil

	// Inclui saldo a compensar no PVA
	U_M06A01('+',nValPadrao)

	/*
	If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL" .And. SE5->E5_MOTBX  $ "NOR/CAC" .And. SE5->E5_TIPODOC $ "VL/V2/BA"

		oTituloCRA := ClassTituloCRA():New()
		If !oTituloCRA:Inclui()
			Aviso("SACI008",oTituloCRA:RetError(),{"Fechar"})
		EndIf

		//+---------------------------------------------------------------------------------
    	//  Verifica a existencia do titulo CRA / NF para compensação automática pelo Pedido
    	//+---------------------------------------------------------------------------------
		If !oTituloCRA:Compensa(SE1->E1_PEDIDO)
			Aviso("SACI008_CRA",oTituloCRA:RetError(),{"Fechar"})
		EndIf

	EndIf
	*/

	RestArea(_aArea)
Return
