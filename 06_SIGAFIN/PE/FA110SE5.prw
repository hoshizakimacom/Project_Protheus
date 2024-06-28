#Include 'Protheus.ch'

/*/{Protheus.doc} FA110SE5

O ponto de entrada FA110SE5 será utilizado na gravação de dados complementares
 na baixa a receber automática. Será executado após gravar o SE5.

@type method
@author Não registrado
@since Não registrado
/*/
User Function FA110SE5()
	Local _aArea		:= GetArea()
	Local _aAreaSE1		:= SE1->(GetArea())
	Local _cRAPre		:= 'PVA'
	Local _cFilter		:= SE1->(DbFilter())
	Local oTituloCRA    := Nil

	//+-------------------------------------------------------
	// Rotina que atualiza saldo a compensar de titulos com
	// prefixo PVA
	//+-------------------------------------------------------
	If SE5->E5_PREFIXO == _cRAPre .AND. SE5->E5_MOTBX $ "NOR/CAC/BND/FIN"
		If !Empty(_cFilter)
			SE1->(DbClearFilter())
		EndIf

		U_M06A01('+',SE5->E5_VALOR)

		If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL" .And. SE5->E5_TIPODOC $ "VL/V2/BA"

			oTituloCRA := ClassTituloCRA():New()
			If !oTituloCRA:Inclui()
				Aviso("FA110SE5",oTituloCRA:RetError(),{"Fechar"})
			EndIf

			//+---------------------------------------------------------------------------------
			//  Verifica a existencia do titulo CRA / NF para compensação automática pelo Pedido
			//+---------------------------------------------------------------------------------
			If !oTituloCRA:Compensa(SE1->E1_PEDIDO)
				Aviso("FA110SE5_CRA",oTituloCRA:RetError(),{"Fechar"})
			EndIf

		EndIf

		If !Empty(_cFilter)
			SE1->(dbSetFilter({||&_cFilter},_cFilter))
		EndIf
	EndIf

	RestArea(_aAreaSE1)
	RestArea(_aArea)
Return

