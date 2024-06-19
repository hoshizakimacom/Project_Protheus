#Include 'Protheus.ch'


/*/{Protheus.doc} F040BLQ

PE chamado para permitir inclusão, alteração ou exclusão de titulo manual no contas a receber.

@type method
@author Marcos Antonio Montes
@since 21/04/2024
/*/

User Function F040BLQ()
	Local _aArea   := GetArea()
	Local nRecAtu  := SE1->(RECNO())
	Local cNumero  := SE1->E1_NUM
	Local cParcela := SE1->E1_PARCELA
	Local lRet     := .T.

	/*
		
	Se titulo de PVA verifica se fora gerado o titulo de credito e não permite a exclusão

	*/
	If IsInCallStack("FA040DELET") 
	
		If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL"

			dbSelectArea("SE1")
			dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If dbSeek(xFilial("SE1")+"PVA"+cNumero+cParcela+"CRA")
				Aviso("F040BLQ","Titulo de PVA com crédito gerado! Não permitida a sua exclusão.",{"Fechar"})
				lRet := .F.
			EndIf
			SE1->(dbGoTo(nRecAtu))
		
		ElseIf SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "CRA" .And. !(IsInCallStack("EXCLUI")) //Trata a chamada da função da classe do PVA para permitir a exclusão do CRA quando da exclusão da baixa do PVA

			Aviso("F040BLQ","Título de crédito de PVA ! Não permitida a exclusão por esta rotina.",{"Fechar"})
			lRet := .F.
		
		EndIf

	EndIf
 
	RestArea(_aArea)

Return lRet 
