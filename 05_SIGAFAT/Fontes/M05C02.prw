#Include 'Protheus.ch'


//+--------------------------------------------------------------------------------------------
//| Filtro no cadastro de produtos para amarração de Familia X Grupo X Sub-Grupo
//+--------------------------------------------------------------------------------------------
User Function M05C02(_cCampo)
    Local _cFiltro      := ''
    Local _cFamilia     := M->B1_XFAMILI
    Local _cGrupo       := M->B1_GRUPO
    Local _cTipo		:= M->B1_TIPO

    Do Case
    Case _cCampo == 'B1_GRUPO'
        _cFiltro    := IIf(Empty(_cFamilia),"","@BM_XFAMILI = '" + _cFamilia + "'")

    Case _cCampo == 'B1_XSUBGRP'
        _cFiltro    := IIf(Empty(_cGrupo),"","@ZA2_GRUPO = '" + _cGrupo + "'")
    
    Case _cCampo	==	'B1_XFAMILI'
    	_cFiltro	:= IIF(Empty(_cTipo),"", "'"+_cTipo+"'" + " $ ZA1_TIPO")

    EndCase

Return _cFiltro
