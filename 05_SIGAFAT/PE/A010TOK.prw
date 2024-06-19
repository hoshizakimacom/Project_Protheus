#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------
//  PE no OK da tela de cadastro de produtos
//+--------------------------------------------------------------------------------------------------------
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
                MsgInfo('� obrigat�rio informar o campo FCI C�digo para produtos tipo PA com origem superior ou igual a 3.','Aten��o')
            EndIf
        EndIf

        // Valida URL
        If lRet .And. !Empty(M->B1_XURL)
            If ! "www.acosmacom.com.br" $ M->B1_XURL
                lRet := .F.
                MsgInfo('URL inv�lida !','Aten��o')
            EndIf
        Endif
    EndIf

    RestArea(aArea)
Return lRet
