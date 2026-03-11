#Include 'Protheus.ch'

// +------------------------------------------------------------+
// | Efetua gravação do numero da nota fiscal na tabela de      |
// | de serie macom (ZAB).                                      |
// +------------------------------------------------------------+
User Function MSD2460()

Local _aArea        := GetArea()
Local _nQuant       := SD2->D2_QUANT
Local nX            := 0
Local _lFamilia     := .F.

_lFamilia := (Posicione("SB1",1,xFilial("SB1")+ SD2->D2_COD, "B1_XFAMILI") $ "000001|000002")

dbSelectArea("ZAB")
dbSetOrder(3)


If _lFamilia .And. ZAB->(MsSeek(xFilial("ZAB")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
    For nX :=1 to _nQuant
        If SD2->D2_PEDIDO == ZAB->ZAB_NUMPV .And. SD2->D2_ITEMPV == ZAB->ZAB_ITEMPV
            Reclock("ZAB",.F.)
            ZAB->ZAB_NOTA := SD2->D2_DOC
            MsUnlock()
            U_M28A01(SD2->D2_FILIAL,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_COD,ZAB->ZAB_NUMSER,SD2->D2_EMISSAO,SD2->D2_DOC,SD2->D2_PEDIDO)
            ZAB->(DBSkip())
        Else 
            MsgAlert("O equipamento " + Alltrim(SD2->D2_COD) + " item " + SD2->D2_ITEMPV +" não possuí número de série resevado. Não será gerada base instalada. Verifique junto a expedição.", "ATENÇÃO")
        EndIf
    Next nX
EndIf  

RestArea(_aArea)

Return
