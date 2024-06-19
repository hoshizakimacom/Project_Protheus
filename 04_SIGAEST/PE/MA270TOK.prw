User Function MA270TOK()

Local _aArea		:= {}
Local _lRet 		:= .T.
Local _cCodUsr	:= RetCodUsr()

_aArea := GetArea()

dbSelectArea("ZAA")
dbSetOrder(1)

If ZAA->(MsSeek(xFilial("ZAA")+_cCodUsr))
	RecLock("ZAA",.F.)
	ZAA->ZAA_CONTAG := M->B7_CONTAGE
	ZAA->(MsUnlock())
Else
	RecLock("ZAA",.T.)
	ZAA->ZAA_FILIAL	:= cFilAnt
	ZAA->ZAA_CODUSU	:= _cCodUsr
	ZAA->ZAA_CONTAG	:= M->B7_CONTAGE
	ZAA->(MsUnlock())
Endif

ZAA->(dbCloseArea())

RestArea(_aArea)

Return _lRet