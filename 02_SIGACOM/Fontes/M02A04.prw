#Include 'Protheus.ch'
#Include 'Matr620.ch'

//+----------------------------------------------------------------------------------------------------------------------------------------------
// Chamado do PE MT100TOK
//+----------------------------------------------------------------------------------------------------------------------------------------------
User Function M02A04()
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local nPosCod   := AScan(aHeader,{|x,y|x[2] = 'D1_COD'})
    Local nPosRat   := AScan(aHeader,{|x,y|x[2] = 'D1_RATEIO'})
    Local nPosCC    := AScan(aHeader,{|x,y|x[2] = 'D1_CC'})
    Local nPosCta   := AScan(aHeader,{|x,y|x[2] = 'D1_CONTA'})
    Local nPosTipo  := AScan(aHeader,{|x,y|x[2] = 'D1_TP'})
    Local nPosItem  := AScan(aHeader,{|x,y|x[2] = 'D1_ITEM'})

    Local cCod      := ''
    Local cRat      := ''
    Local cCC       := ''
    Local cCta      := ''
    Local cTipoP     := ''
    Local cItem     := ''

    Local nBkp      := n
    Local N         := 1
    //+-------------------------------------------------------------------------
    // Obriga preenchimento da conta contábil e do centro de custo quando
    //  - rateio igual a Não
    //  - Tipo do produto MC, SV ou AI
    //+-------------------------------------------------------------------------
    If MafisRet(,'NF_TIPONF') == "N"

        For N:= 1 To Len(aCols)
            cCod      := aCols[n][nPosCod]
            cRat      := aCols[n][nPosRat]
            cCC       := aCols[n][nPosCC]
            cCta      := aCols[n][nPosCta]
            cTipoP    := aCols[n][nPosTipo]
            cItem     := aCols[n][nPosItem]

            If cRat == '2'
                If cTipoP $ 'MC-SV-AI'
                    If Empty(cCC) .Or. Empty(cCta)
                        MsgInfo(I18N('Conta Contábil e Centro de Custo são obrigatórios para produtos sem rateio (#1 item #2) e tipo do produto igual a #3.',{AllTrim(cCod),cItem,cTipoP}),'Atenção!')
                        lRet    := .F.
                        Exit
                    EndIf
                EndIf
            EndIf
        Next
    EndIf

    n := nBkp
    RestArea(aArea)
Return lRet
