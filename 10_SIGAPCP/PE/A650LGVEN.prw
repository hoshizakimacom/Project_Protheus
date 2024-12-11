#INCLUDE 'TOTVS.CH'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

User Function A650LGVEN() // Bloqueio da Geração de OP

// Customizacao do usuário (retornar branco ou "X" através de expressão ADVPL para a condição para a legenda vermelha)// No exemplo abaixo, considera legenda vermelha (bloqueado para geração de OP) os pedidos de venda do cliente "C00003"cVermelha  := "If(C6_CLI <> 'C00003',' ','X')"Return (cVermelha)

Local cVermelha  := ""
Local _cItDese := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XITDESE")
Local _cPdf    := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XPDF")
Local _cDxf    := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XDFX")
Local _cEstru  := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XESTR")
Local _cMaoOb  := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XMDOBRA")
Local _cTipoPrd := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_TIPO")


/*
    If  _cItDese <> "S" .Or.     _cPdf <> "1"    .Or.     Empty(_cDxf)    .Or.     _cEstru <> "1"  .Or.     _cMaoOb <> "1"  .Or.     _cTipoPrd == "ME"

        MsgAlert("Produto com pendências da Engenharia", "Aviso")
    Endif

    Return (cVermelha) := 'X'
*/

/*
    If _cItDese <> "S" .Or. _cPdf <> "1" .Or. Empty(_cDxf) .Or. _cEstru <> "1" .Or. _cMaoOb <> "1" .Or. _cTipoPrd == "ME"
        // Destacar o item com legenda em vermelho
        cVermelha := "X"
    
        MsgAlert("Produto com pendências da Engenharia", "Aviso")
    EndIf

    Return (cVermelha)
*/


"C2_PRODUTO"cVermelha  := "If(_cItDese <> 'S',' ','X')"
Return (cVermelha)
