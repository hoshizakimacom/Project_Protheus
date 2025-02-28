#Include 'Protheus.ch'

//------------------------------------------------------------------------------
//  Rotina de calculo de Saldo em Aberto no Pedido de Compras
//------------------------------------------------------------------------------
User Function M02A11()

local cRet        := ""
local nQuant      := SC7->C7_QUANT
local nQEntreg    := SC7->C7_QUJE

   //MsgStop("TESTE")

   If !Empty(SC7->C7_NUM)
      cRet := (nQuant- nQEntreg)
   else
      cRet := 0
   endif

return cRet
