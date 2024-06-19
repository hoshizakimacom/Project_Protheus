#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------------
//  Valida preenchimento orbrigatório da inscrição estadual
//  Chamado do PE MA030TOK
//+-------------------------------------------------------------------------------------------------------------------------
User Function M05A31()
    Local lRet      := .T.
    Local cTPessoa  := M->A1_TPESSOA    // CI=Comercio/Industria;PF=Pessoa Fisica;OS=Prestacõo de Servico;EP=Empresa Publica
    Local cInscEst  := M->A1_INSCR
    Local cEst      := M->A1_EST

    If cTPessoa = 'CI' .And. Empty(cInscEst) .And. cEst <> 'EX'
        lRet := .F.
        MsgInfo('Obrigatório o preenchimento do campo Inscrição Estadual quando Tipo Pessoa for "Comércio/Indústria','Atenção')
    EndIf
Return lRet