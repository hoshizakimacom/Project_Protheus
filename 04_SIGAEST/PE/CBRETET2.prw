

User Function CBRETET2(aRet)

Local aArea  := GetArea()
Local lReturn := .F.

cCodProd := aRet[1]
cTipoId  := aRet[2]

If cTipoId == "01"
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+cCodProd)
	   	lReturn := .T.
	EndIf
EndIf

RestArea(aArea)

Return .F.

