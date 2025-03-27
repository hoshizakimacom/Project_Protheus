#INCLUDE 'TOTVS.CH'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

User Function MTA650I() // Geração de Ordens de Produção

Local aArea         := GetArea()
Local aAreaSB1      := SB1->(GetArea())

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)

//MsgStop("Teste"+SC2->C2_PRODUTO,"Aviso")

If SB1->B1_XPADRAO == "2"
	Reclock("SB1",.F.)
	SB1->B1_XESPLIB := "2"
	MsUnlock()
EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return
