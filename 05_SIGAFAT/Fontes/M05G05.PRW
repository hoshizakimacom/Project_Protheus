//+-------------------------------------------------------------------------------------------------------------------
//| Função criada para liberar o relatório de Folow de acordo com o usuário logado
//| Chamado do 1587
//| Analista: Graziella Bianchin
//| Data: 26/10/2022
//+-------------------------------------------------------------------------------------------------------------------

User Function M05G05()

    Local _lRet     := .T.
    Local _cCodUsr  := RetCodusr()

    IF _cCodUsr $  GETMV("MV_XLBRFLW")
        _lRet     := .T.
    ELSE
        _lRet     := .F.
    ENDIF
Return _lRet
