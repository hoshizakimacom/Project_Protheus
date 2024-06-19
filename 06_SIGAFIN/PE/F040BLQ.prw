#Include 'Protheus.ch'


/*/{Protheus.doc} F040BLQ

PE chamado para permitir inclus�o, altera��o ou exclus�o de titulo manual no contas a receber.

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
		
	Se titulo de PVA verifica se fora gerado o titulo de credito e n�o permite a exclus�o

	*/
	If IsInCallStack("FA040DELET") 
	
		If SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "BOL"

			dbSelectArea("SE1")
			dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If dbSeek(xFilial("SE1")+"PVA"+cNumero+cParcela+"CRA")
				Aviso("F040BLQ","Titulo de PVA com cr�dito gerado! N�o permitida a sua exclus�o.",{"Fechar"})
				lRet := .F.
			EndIf
			SE1->(dbGoTo(nRecAtu))
		
		ElseIf SE1->E1_PREFIXO == "PVA" .And. SE1->E1_TIPO == "CRA" .And. !(IsInCallStack("EXCLUI")) //Trata a chamada da fun��o da classe do PVA para permitir a exclus�o do CRA quando da exclus�o da baixa do PVA

			Aviso("F040BLQ","T�tulo de cr�dito de PVA ! N�o permitida a exclus�o por esta rotina.",{"Fechar"})
			lRet := .F.
		
		EndIf

	EndIf
 
	RestArea(_aArea)

Return lRet 
