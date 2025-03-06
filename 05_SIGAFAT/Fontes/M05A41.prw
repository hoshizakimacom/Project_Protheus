#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M05A41   ³ Autor ³ Wallace Manzini      ³ Data ³ 27/02/25 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funções Complementares - Relatório Gerencial de Vendas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - M05R09                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//------------------------------------------------------------------------------
//  Rotina de calculo de Valor Sem Impostos
//------------------------------------------------------------------------------
User Function M05A41()

local cRet        := ""
local nVlBruto    := SC6->C6_XVLTBRU
local nImposto    := SC6->C6_XVLTIPI + SC6->C6_XVLTPS2 + SC6->C6_XVLTICM + SC6->C6_XVLTSOL
// AQUI


   //MsgStop("TESTE")

   If !Empty(SC6->C6_TPPROD)
      cRet := (nVlBruto-(nImposto))
   else
      cRet := 0
   endif

return cRet


//------------------------------------------------------------------------------
//  Rotina de calculo de Despesas
//------------------------------------------------------------------------------
User Function M05A41A()

local cRet      := ""
local nVlBruto  := SC6->C6_XVLTBRU
local nFrete    := SC5->C5_FRETE
local nVlInst   := SC5->C5_XVLRINS 
local nAcrsPed  := SC5->C5_XACRESC
local nCondPag  := Posicione("SE4",1,xFilial("SE4") + SC5->C5_CONDPAG, "E4_ACRSFIN") 

   //MsgStop("TESTE")

   If !Empty(SC6->C6_TPPROD)
      cRet := (nVlBruto + nFrete + nVlInst)+((nVlBruto/nAcrsPed)+(nVlBruto/nCondPag))
      
   else
      cRet := 0
   endif

return cRet


//------------------------------------------------------------------------------
//  Rotina de calculo do Valor da Tabela de Preços Total
//------------------------------------------------------------------------------
User Function M05A41B()

local cRet          := ""
local nVlTabela     := SC6->C6_XVLUTAB
local nQuant        := SC6->C6_QTDVEN

   //MsgStop("TESTE")

   If !Empty(SC6->C6_TPPROD)
      cRet := (nVlTabela * nQuant)
   else
      cRet := 0
   endif

return cRet


//------------------------------------------------------------------------------
//  Rotina de calculo de Valor % Desconto
//------------------------------------------------------------------------------
User Function M05A41C()

local cRet          := ""
local nVlBruto      := SC6->C6_XVLTBRU
local nImposto      := SC6->C6_XVLTIPI + SC6->C6_XVLTPS2 + SC6->C6_XVLTICM + SC6->C6_XVLTSOL
local nVlTabela     := SC6->C6_XVLUTAB
local nQuant        := SC6->C6_QTDVEN

   //MsgStop("TESTE")

   If !Empty(SC6->C6_TPPROD)
      cRet := ((nVlBruto-(nImposto)) / (nVlTabela * nQuant)) -1
   else
      cRet := 0
   endif

return cRet


//------------------------------------------------------------------------------
//  Rotina de calculo de Valor Total Comissão
//------------------------------------------------------------------------------
User Function M05A41D()

local cRet          := ""
local nComis1       := SC5->C5_COMIS1
local nComis2       := SC5->C5_COMIS2
local nComis3       := SC5->C5_COMIS3
local nComis4       := SC5->C5_COMIS4
local nComis5       := SC5->C5_COMIS5



   //MsgStop("TESTE")

   If !Empty(SC6->C6_TPPROD)
      cRet := (nComis1 + nComis2 + nComis3 + nComis4 + nComis5)
   else
      cRet := 0
   endif

return cRet
