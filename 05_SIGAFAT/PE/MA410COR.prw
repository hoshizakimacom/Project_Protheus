#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
// Usado, em conjunto com o ponto MA410LEG, para alterar cores do “browse” do
// cadastro, que representam o “status” do pedido.
//+------------------------------------------------------------------------------
User Function MA410COR(aCores)
    Local _aBkp     := ParamIXB
    Local _aCores   := {}
    Local _nX       := 0

    
    If SC5->(FieldPos('C5_XCRED')) > 0
       AAdd(_aCores ,{"C5_XCRED =='1'"      ,'BR_MARRON_OCEAN'	,"Pedido de Venda Bloqueado por Crédito"})
       AAdd(_aCores ,{"C5_XCRED =='2'"      ,'BR_VIOLETA'		,"Pedido de Venda Aprovado por Crédito"}) 
       AAdd(_aCores ,{"C5_MSBLQL =='1'"		,'BR_PRETO' 		,"Pedido de Venda Inativo"}) 
    EndIf


    For _nX := 1 To Len(_aBkp)
        AAdd(_aCores    ,_aBkp[_nX])
    Next

Return AClone(_aCores)