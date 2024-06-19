#Include 'Protheus.ch'

User Function M34V02()

Local lret := .T.

DbSelectArea("SZC")
DbSetOrder(1)
If SZC->(DbSeek(xFilial("SZC") + Padr(M->ZC_CODUSER,TamSX3("ZC_CODUSER")[1])))
     msginfo("Registro ja existe")
     M->ZC_CODUSER = ""
     lret := .F.
else
     lret := .T.
Endif

Return lret
