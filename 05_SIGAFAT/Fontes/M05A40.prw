#Include 'Protheus.ch'


//------------------------------------------------------------------------------
//  Rotina de calculo de % de margem de custo médio
//------------------------------------------------------------------------------
User Function M05A40()

local cRet     := ""
local nVlBruto := CK_XVLUBRU
local nImposto := CK_XVLTIPI+CK_XVLTPS2+CK_XVLTCF2+CK_XVLTICM+CK_XVLTSOL
local nCustoMd := POSICIONE("SB2",1,XFILIAL("SB2")+SCK->CK_PRODUTO,"B2_CMFIM1")

   //MsgStop("TESTE")

   If !Empty(SCK->CK_TPPROD)
      cRet := ((nVlBruto-(nImposto)-(nCustoMd))/(nVlBruto+(nImposto))*100)
   else
      cRet := 0
   endif

return cRet
