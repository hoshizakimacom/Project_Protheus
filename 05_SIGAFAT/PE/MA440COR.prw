#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Este ponto de entrada pertence � rotina de libera��o de pedidos de venda,
// MATA440
//+------------------------------------------------------------------------------
User Function MA440COR()
    Local _aBkp     := ParamIXB
    Local _aCores   := {}
    Local _nX       := 0


    If SC5->(FieldPos('C5_XCRED')) > 0
       AAdd(_aCores ,{"C5_XCRED =='1'"      ,'BR_MARRON_OCEAN'}) // Pedido de Venda Bloqueado por Cr�dito
       AAdd(_aCores ,{"C5_XCRED =='2'"      ,'BR_VIOLETA'}) // Pedido de Venda Aprovado por Cr�dito
    EndIf

    For _nX := 1 To Len(_aBkp)
        AAdd(_aCores    ,_aBkp[_nX])
    Next
Return AClone(_aCores)