//+-------------------------------------------------------------------------------------------------------------------
//| Função criada para liberar o campo C5_DESCONT de acordo com o usuário logado
//| Chamado do SEM CHAMADO
//| Analista: Graziella Bianchin
//| Data: 25/10/2022
//+-------------------------------------------------------------------------------------------------------------------

User Function M05G04()

    Local _lRet     := .T.
    Local _cCodUsr  := RetCodusr()

    IF _cCodUsr $  GETMV("MV_XLBCDES")
        _lRet     := .T.
    ELSE
        _lRet     := .F.
    ENDIF
Return _lRet
