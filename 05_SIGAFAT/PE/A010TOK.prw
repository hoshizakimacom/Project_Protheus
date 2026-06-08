User Function A010TOK()
    Local aArea     := GetArea()
    Local lRet      := .T.


    If INCLUI .OR. ALTERA

        // Valida grupo/tipo/conta contabil
        lRet := U_M05A27()

        // Valida FCI
        If lRet
            If (M->B1_TIPO == 'PA' .And. M->B1_ORIGEM >= '3') .And. Empty(M->B1_XFCICOD)
                lRet := .F.
                MsgInfo('É obrigatório informar o campo FCI Código para produtos tipo PA com origem superior ou igual a 3.','Atenção')
            EndIf
        EndIf

        // Valida NCM se o tipo do produto for diferente de PI
        /*If lRet
            If (M->B1_TIPO <> 'PI' .And. Empty(M->B1_POSIPI)) //#9728 - Chamado Vinicius Capeli
                lRet := .F.
                MsgInfo('É obrigatório informar o campo NCM diferentes do tipo PI.','Atenção')
            EndIf
        EndIf*/

        // Valida URL
        If lRet .And. !Empty(M->B1_XURL)
            If ! "www.hoshizakimacom.com.br" $ M->B1_XURL //#7554 - Chamado Tierre
                lRet := .F.
                MsgInfo('URL inválida !','Atenção')
            EndIf
        Endif
    EndIf

    RestArea(aArea)
Return lRet
