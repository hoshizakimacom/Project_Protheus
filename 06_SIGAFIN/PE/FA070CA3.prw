#Include 'Protheus.ch'


/*/{Protheus.doc} FA070CA3

PE para validação do cancelamento/exclusão de baixa do contas a receber

@type method
@author Marcos Antonio Montes
@since 21/04/2024
/*/

User Function FA070CA3()
	Local _aArea    := GetArea()
	Local _aAreaSE1 := SE1->(GetArea())
	Local nRecAtu   := SE1->(RECNO())
	Local cNumero   := SE1->E1_NUM
	Local cParcela  := SE1->E1_PARCELA
	Local lRet      := .T.

	/*
	
	Se titulo de PVA verifica se titulo de credito sofreu baixa parcial ou total e não permite a exclusão

	*/
	If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL"

		dbSelectArea("SE1")
		dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		If dbSeek(xFilial("SE1")+"PVA"+cNumero+cParcela+"CRA") .And. (SE1->E1_SALDO <> SE1->E1_VALOR)
			Aviso("F040BLQ","Titulo de PVA com titulo de crédito baixado ! Não permite a exclusão."+CHR(13)+CHR(10)+"Verifique as baixas do titulos CRA correspondente.",{"Fechar"})
			lRet := .F.
		EndIf
		SE1->(dbGoTo(nRecAtu))
		
	EndIf
 
	RestArea(_aAreaSE1)
	RestArea(_aArea)

Return lRet 
