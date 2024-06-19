#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------------------
//| Validação SA1
//+---------------------------------------------------------------------------------------------------------------------------------------------
User Function M05V03(cField)
    Local aArea     := GetArea()
    Local lRet     := .T.
    Default cField := ''

    Do Case

    // Valida rede e grupo economico do cliente
    Case cField $ 'A1_XREDE'
        lRet   := MV05Rede()

    EndCase

    RestArea(aArea)
Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MV05Rede()
    Local lRet      := .F.
    Local aAreaZA6  := ZA6->(GetArea())

    ZA6->(DbSetOrder(1))
    ZA6->(DbGotop())

    If ZA6->(DbSeek( xFilial('ZA6')  + M->A1_XREDE))
        While ZA6->(!EOF()) .And. ZA6->ZA6_FILIAL == xFilial('ZA6') .And. ZA6->ZA6_COD == M->A1_XREDE
            If ZA6->ZA6_GRPE == M->A1_XGRPEC
                lRet := .T.
                Exit
            EndIf
            ZA6->(DbSkip())
        EndDo
    EndIf

    If !lRet
        MsgInfo(I18N('Rede #1 não pertence ao Grupo Econômico informado #2.' + CRLF + 'Verifique.',{AllTrim(M->A1_XREDE),AllTrim(M->A1_XGRPEC)}),'Atenção')
    EndIf

    RestArea(aAreaZA6)
Return lRet