User Function MTA650E()

Local _aArea	:= GetArea()
Local _lRet		:= .T.

_lRet := MsgYesNo("Ao excluir a ordem de produção os número(s) de série não serão estornado(s). Continua?","Atenção")

If ! _lRet
	MsgStop("Operação cancelada pelo operador","Atenção")
Else
	DBSelectArea("ZAB")
	DBSetOrder(2)
	If MsSeek(xFilial("ZAB") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
		RecLock("ZAB", .F.)
		ZAB->ZAB_ESTORN := "1"
		MsUnlock()
	EndIf
	RestArea(_aArea)
EndIf


Return _lRet

