#Include 'Protheus.ch'

User Function M10A08()

Local lRet     := .T.
Local cUsers   := GetMv("AM_10A08")  //"000024|000247|000999|000304|000131" 
Local aArea    := GetArea() 
Local aAreaSC6 := SC6->(GetArea())

If Empty(SC2->C2_PEDIDO)
	MsgAlert("Ordem de Produção não possui vínculo com Pedido de Venda !","ATENÇÃO")
	lRet := .F.	
EndIf

If RetCodUsr() $ cUsers .And. lRet
	lRet := .F.	

    dbSelectArea("SC6")
    dbSetOrder(1)
    If !dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV)
    	MsgAlert("Pedido de Venda não Localizado - Pedido : "+SC2->C2_PEDIDO+" Item : "+SC2->C2_ITEMPV  ,"ATENÇÃO")

    Else

        If !MsgYesNo("Confirma Desvincular OP : "+SC6->C6_NUMOP+" - do Pedido : "+SC2->C2_PEDIDO,"Atenção")
            RestArea(aAreaSC6)
            RestArea(aArea)
            Return
        EndIf

        RecLock("SC6",.F.)
        SC6->C6_XNUMOP  := SC6->C6_NUMOP
        SC6->C6_XITEMOP := SC6->C6_ITEMOP
        SC6->C6_XOP     := SC6->C6_OP

        SC6->C6_NUMOP  := " "
        SC6->C6_ITEMOP := " " 
        SC6->C6_OP     := " "
        MsUnLock()

        RecLock("SC2",.F.)
        SC2->C2_XPEDID  := SC2->C2_PEDIDO
        SC2->C2_XITEMPV := SC2->C2_ITEMPV
        SC2->C2_XLOGPV  := AllTrim(cUserName)+" - "+Dtoc(Date())   // C(25)

        SC2->C2_PEDIDO := " "
        SC2->C2_ITEMPV := " " 
        MsUnLock()

    	MsgAlert("Retirado Vínculo de OP x Pedido de Venda  !","ATENÇÃO")
    EndIf

Endif

RestArea(aAreaSC6)
RestArea(aArea)

Return
