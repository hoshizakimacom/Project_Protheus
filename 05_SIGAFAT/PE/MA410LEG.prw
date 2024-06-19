#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
// Usado, em conjunto com o ponto MA410COR, para alterar os textos da legenda,
// que representam o “status” do pedido.
//+------------------------------------------------------------------------------
User Function MA410LEG()
    Local _aLegen := {}

    AAdd(_aLegen, {'BR_MARRON_OCEAN'   ,'Pedido de Venda Bloqueado por Crédito'})
    AAdd(_aLegen, {'BR_VIOLETA'        ,'Pedido de Venda Desbloqueado por Crédito'})
    AAdd(_aLegen, {'ENABLE'            ,'Pedido de Venda em Aberto'})
    AAdd(_aLegen, {'DISABLE'           ,'Pedido de Venda Encerrado'})
    AAdd(_aLegen, {'BR_AMARELO'        ,'Pedido de Venda Liberado'})
    AAdd(_aLegen, {'BR_AZUL'           ,'Pedido de Venda com Bloqueio de Regra'})
    AAdd(_aLegen, {'BR_LARANJA'        ,'Pedido de Venda com Bloqueio de Verba'})
    AAdd(_aLegen, {'BR_PRETO'		   ,'Pedido de Venda Inativo'})

Return AClone(_aLegen)