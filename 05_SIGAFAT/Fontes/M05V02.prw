#Include 'Protheus.ch'


//+---------------------------------------------------------------------------------------------------------------------------------------------
//| Validação SB1
//+---------------------------------------------------------------------------------------------------------------------------------------------
User Function M05V02(cField)
    Local lRet     := .T.
    Default cField := ''


    Do Case
    Case cField $ 'B1_GRUPO'
        lRet   := MV05Grp(M->B1_XFAMILI,M->B1_GRUPO)

    Case cField $ 'B1_XSUBGRP'
        lRet   := MV05Sub(M->B1_GRUPO,M->B1_XSUBGRP)

    EndCase

Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
// Verifica se grupo pertence a familia informada
//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MV05Grp(cFamilia,cGrupo)
    Local lRet      := .T.
    Local aAreaSBM  := SBM->(GetArea())

    SBM->(DbGoTop())
    SBM->(DbSetOrder(1))

    If SBM->(DbSeek( xFilial('SBM') + cGrupo))
        If SBM->BM_XFAMILI <> cFamilia
            lRet := .F.
            MsgStop(I18N('Grupo #1 não pentence a Família #2 .' + CRLF + 'Verifique.',{cGrupo,cFamilia}))
        EndIf
    EndIf

    RestArea(aAreaSBM)

Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
// Verifica se subgrupo pertence ao grupo informado
//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MV05Sub(cGrupo,SubcGrupo)
    Local lRet      := .T.
    Local aAreaSBM  := SBM->(GetArea())

    ZA2->(DbGoTop())
    ZA2->(DbSetOrder(1))

    If ZA2->(DbSeek( xFilial('ZA2') + SubcGrupo))
        If ZA2->ZA2_GRUPO <> cGrupo
            lRet := .F.
            MsgStop(I18N('Subgrupo #1 não pentence ao Grupo #2 .' + CRLF + 'Verifique.',{SubcGrupo,cGrupo}))
        EndIf
    EndIf

    RestArea(aAreaSBM)

Return lRet