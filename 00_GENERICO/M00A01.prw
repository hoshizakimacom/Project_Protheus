#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------
//  Fun��o que recebe o(s) c�digo(s) do(s) grupo(s) e retorna .T. se o usuario fizer parte do grupo ou
//  .F., caso o usu�rio n�o esteja no grupo
//+-------------------------------------------------------------------------------------------------------
User Function M00A01(_cGrupo)
    Local _lRet         := .F.
    Local _aGrpUser     := UsrRetGrp(UsrRetName(RetCodUsr()))
    Local _nX           := 0
    Local _cGrpUser     := ''
    Default _cGrupo     := ''

    For _nX := 1 To Len(_aGrpUser)

        _cGrpUser   := _aGrpUser[_nX]

        If _cGrpUser $ _cGrupo
            _lRet := .T.
            Exit
        EndIf
    Next
Return _lRet