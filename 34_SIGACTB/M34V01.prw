#Include 'Protheus.ch'

User Function M34V01()

DbSelectArea("SZB")
DbSetOrder(1)
If SZB->(DbSeek(xFilial("SZB") + Padr(M->ZB_COD,TamSX3("ZB_COD")[1])))
     msginfo("Registro ja existe")
     M->ZB_COD = ""
     lret := .F.
else
     lret := .T.
Endif

Return lret
