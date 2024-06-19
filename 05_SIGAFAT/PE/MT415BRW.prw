#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------
//| Este Ponto de Entrada, esta localizado no MATA415 (Orçamento de Vendas), permite ao
//| usuário filtrar os registros que serão exibidos no browser.
//+--------------------------------------------------------------------------------------------
User Function MT415BRW()
    Local _aArea        := GetArea()
    Local cGrpCom       := GetMv('AM_05ACOM ',,'')
    Local _cFiltro      := ' '
    Local cVend         := ''

    Public __lRepres    := .F.
    Public __lComerc    := .F.
    Public __cEst       := ""

    __lRepres   := U_M05A29(@__cEst,@cVend)

    If __lRepres
        _cFiltro        := "CJ_XVEND1 == '" + cVend + "' "
    EndIf

    If !__lRepres
        __lComerc := U_M00A01(cGrpCom)
    EndIf

    RestArea(_aArea)
Return _cFiltro