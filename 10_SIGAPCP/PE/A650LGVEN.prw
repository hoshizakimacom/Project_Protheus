#INCLUDE 'TOTVS.CH'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

User Function A650LGVEN() // Bloqueio da Geração de OP

Local aArea         := GetArea()
Local aAreaSB1      := SB1->(GetArea())
Local cVermelha     := ""
Local _cItDese      := ""
Local _cPdf         := ""
Local _cDxf         := ""
Local _cEstru       := ""
Local _cMaoOb       := ""
Local _cTipoPrd     := ""

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

_cItDese      := SB1->B1_XITDESE
_cPdf         := SB1->B1_XPDF
_cDxf         := SB1->B1_XDFX
_cEstru       := SB1->B1_XESTR
_cMaoOb       := SB1->B1_XMDOBRA
_cTipoPrd     := SB1->B1_TIPO

If _cItDese <> "S" .Or. _cPdf <> "1" .Or. Empty(_cDxf) .Or. _cEstru <> "1" .Or. _cMaoOb <> "1" .Or. _cTipoPrd == "ME"
    cVermelha := "X"
    MsgAlert("Produto com pendências da Engenharia", "Aviso")
EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return (cVermelha)
