#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------------
//  Valida preenchimento orbrigat�rio da inscri��o estadual
//  Chamado do PE MA030TOK
//+-------------------------------------------------------------------------------------------------------------------------
User Function M05A31()
    Local lRet      := .T.
    Local cTPessoa  := M->A1_TPESSOA    // CI=Comercio/Industria;PF=Pessoa Fisica;OS=Prestac�o de Servico;EP=Empresa Publica
    Local cInscEst  := M->A1_INSCR
    Local cEst      := M->A1_EST

    If cTPessoa = 'CI' .And. Empty(cInscEst) .And. cEst <> 'EX'
        lRet := .F.
        MsgInfo('Obrigat�rio o preenchimento do campo Inscri��o Estadual quando Tipo Pessoa for "Com�rcio/Ind�stria','Aten��o')
    EndIf
Return lRet