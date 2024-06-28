#Include 'Protheus.ch'

/*/{Protheus.doc} FA070CAN

PE chamado ap�s grava��o do cancelamento da baixa a receber.

@type method
@author N�o registrado
@since N�o registrado
/*/
User Function FA070CAN()
	Local _aArea	 := GetArea()
	Local oTituloCRA := Nil

    Private _cRAPre  := 'PVA'

	// Retira saldo a compensar do PVA
	  U_M06A01('-',nValPadrao)

	If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL" .And. SE5->E5_MOTBX $ "NOR/CAC/BND/FIN" .And. SE5->E5_TIPODOC $ "VL/V2/BA"

		oTituloCRA := ClassTituloCRA():New()
		oTituloCRA:lTransaction := .F. //Desabilita controle de transa��o, pois caso n�o exista o titulo CRA este permita excluir a baixa e n�o d� roolback
		If !oTituloCRA:Exclui()
			Aviso("FA070CAN",oTituloCRA:RetError(),{"Fechar"})
		EndIf

	EndIf

	RestArea(_aArea)
Return
