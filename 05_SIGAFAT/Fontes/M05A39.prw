#Include 'Protheus.ch'


//------------------------------------------------------------------------------
//  Rotina de calculo de % de margem de custo standard
//------------------------------------------------------------------------------
User Function M05A39()

local cRet     := ""
local nVlBruto := CK_XVLUBRU
local nImposto := CK_XVLTIPI+CK_XVLTPS2+CK_XVLTCF2+CK_XVLTICM+CK_XVLTSOL
local nCustoSd := POSICIONE("SB1",1,XFILIAL("SB1")+SCK->CK_PRODUTO,"B1_CUSTD") 

   //MsgStop("TESTE")

   If !Empty(SCK->CK_TPPROD)
      cRet := ((nVlBruto-(nImposto)-(nCustoSd))/(nVlBruto+(nImposto))*100)
   else
      cRet := 0
   endif

return cRet
