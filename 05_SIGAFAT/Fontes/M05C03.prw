#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------
//| Filtro no cadastro de clientes
//+--------------------------------------------------------------------------------------------
User Function M05C03(_cCampo)
    Local _cFiltro      := ''
    Local _cRede        := M->A1_XGRPEC

    Do Case
    Case _cCampo == 'A1_XREDE'
        _cFiltro    := IIf(Empty(_cCampo),"","@ZA6_GRPE = '" + _cRede + "'")

    EndCase

Return _cFiltro

