#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------
//  Legenda da liberação de venda
//+----------------------------------------------------------------------------------------
User Function MA416COR()
    Local aCores    := {}
    Local aBkp     := ParamIXB
    Local nX       := 0

    If SCJ->(FieldPos('CJ_XCRED')) > 0
        AAdd(aCores, {"CJ_XCRED =='1'", 'BR_MARRON_OCEAN'}) // Orçamento Bloqueado por Crédito
        AAdd(aCores, {"CJ_XCRED =='2'", 'BR_VIOLETA'})      // Orçamento Desbloqueado por Crédito
    EndIf

    For nX := 1 To Len(aBkp)
        AAdd(aCores    ,aBkp[nX])
    Next

Return AClone(aCores)