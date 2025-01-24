#Include 'Protheus.ch'


//------------------------------------------------------------------------------
//  Rotina de calculo de margem de custo médio
//------------------------------------------------------------------------------
User Function M05A38()

local cRet := ""

   //MsgStop("TESTE")

   If !Empty(SCK->CK_TPPROD)
      cRet := CK_XVLUBRU-(CK_XVLTIPI+CK_XVLTPS2+CK_XVLTCF2+CK_XVLTICM+CK_XVLTSOL)-(POSICIONE("SB2",1,XFILIAL("SB2")+SCK->CK_PRODUTO,"B2_CMFIM1")) 
   else
      cRet := 0
   endif

return cRet
