#Include 'Protheus.ch'

//+---------------------------------------------------------------------
//  Obrigado informar grupo para as familias 000009 - 000010 e 000012
//  e Tipo MC SV  AI
//+-----------------------------------------------------------------
User Function M05A27()
    Local aArea     := GetArea()
    Local lRet      := .T.

    //+---------------------------------------------------------------------
    //  Obrigado informar grupo para as familias 000009 - 000010 e 000012
    //  e Tipo MC SV  AI
    //+---------------------------------------------------------------------

    If Empty(M->B1_GRUPO)
        If M->B1_TIPO $ 'MC-SV-AI'
            MsgInfo(I18N('É obrigatório informar Grupo quando Tipo #1.',{M->B1_TIPO}),"Atenção")
            lRet    := .F.
        EndIf

        If lRet .And. M->B1_XFAMILI $ ('000009-000010-000012')
            MsgInfo(I18N('É obrigatório informar Grupo quando Família #1',{M->B1_XFAMILI}),"Atenção")
            lRet    := .F.
        EndIf
    EndIf

    RestArea(aArea)
Return lRet