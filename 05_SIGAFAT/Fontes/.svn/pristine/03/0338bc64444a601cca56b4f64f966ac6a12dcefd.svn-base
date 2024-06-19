#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
//  Função chamada de gatilhos na SA1
//+------------------------------------------------------------------------------------------------
User Function M05G02(_cField)
    Local _aArea        := GetArea()
    Local _xRet         := Nil

    Do Case
        Case _cField == 'A1_XGEN'
            _xRet   := M->A1_XGEN

            MG02GetIns()    // Preenche inscrição estadual para clientes genéricos

        Case _cField == 'A1_TPESSOA'
            _xRet   := M->A1_TPESSOA

            MG02GetCnt()    // Retorna de cliente é contribuinte ou não contribuinte
            MG02GetGrp()    // Retorna grupo de tributação

        Case _cField == 'A1_END'
            _xRet   := M->A1_END

            MG02SetE()

        Case _cField == 'A1_BAIRRO'
            _xRet   := M->A1_BAIRRO

            MG02SetB()

        Case _cField == 'A1_EST'
            _xRet   := M->A1_EST

            MG02SetEs()

        Case _cField == 'A1_CEP'
            _xRet   := M->A1_CEP

            MG02SetCep()

        Case _cField == 'A1_COD_MUN'
            _xRet   := M->A1_COD_MUN

            MG02SetMun()

        Case _cField == 'A1_XGRPEC'
            _xRet   := M->A1_XGRPEC

            MG02SetRed()

        Case _cField == 'A1_TIPO'
            _xRet   := M->A1_TIPO

            MG02SetCon()

        Case _cField == 'A1_COD'
            _xRet   := &('M->'+_cField)

            MG02SetCod(@_xRet)
            MG02SetLj(_xRet)
    EndCase

    RestArea(_aArea)
Return _xRet

//+------------------------------------------------------------------------------------------------
Static Function MG02SetCod(_cCod)

    If !Empty(_cCod)
        _cCod := PadL(AllTrim(_cCod),6,'0')
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetLj(cCod)
    Local _cAlias       := GetNextAlias()
    Local cLoja         := StrZero(1,4)

    If !Empty(cCod)
        BeginSql Alias _cAlias
            Select A1_LOJA
            FROM %Table:SA1% SA1
            WHERE SA1.%NotDel%
            AND A1_FILIAL = %xFilial:SA1%
            AND A1_COD = %Exp:cCod%
            ORDER BY A1_LOJA DESC
        EndSql

        If (_cAlias)->(!EOf())
            cLoja := Soma1(PadL(AllTrim( (_cAlias)->A1_LOJA ),4,'0'))
        EndIf
    EndIf

    M->A1_LOJA  := cLoja
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetCon()
    Local cTipo     := AllTrim(M->A1_TIPO)
    Local cConta    := ''

    If cTipo == 'X'
        cConta  := '1120100002'
    Else
        cConta  := '1120100001'
    EndIf

    M->A1_CONTA := cConta
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetRed()
    M->A1_XREDE := Space(TamSX3('A1_XREDE')[1])
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetMun()

    M->A1_MUNC      := Posicione('CC2',1, xFilial('CC2') + M->A1_EST + M->A1_COD_MUN,'CC2_MUN' )
    M->A1_CODMUNE   := AllTrim(M->A1_COD_MUN)
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetCep()
    M->A1_CEPC    := AllTrim(M->A1_CEP)
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetEs()
    Local cReg      := ''
    Local cRegDes   := ''

    M->A1_ESTC    := AllTrim(M->A1_EST)
    M->A1_ESTE    := AllTrim(M->A1_EST)

    U_M05A30(M->A1_EST,@cReg,@cRegDes)

    M->A1_REGIAO  := cReg
    M->A1_DSCREG  := cRegDes
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetB()
    M->A1_BAIRROC    := AllTrim(M->A1_BAIRRO)
    M->A1_BAIRROE    := AllTrim(M->A1_BAIRRO)
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetE()
    M->A1_ENDCOB    := AllTrim(M->A1_END)
    M->A1_ENDENT    := AllTrim(M->A1_END)
Return

//+------------------------------------------------------------------------------------------------
//| Retorna se cliente é contribuinte ou não contribuinte dependendo do tipo de cliente informado
//| pelo usuário
//+------------------------------------------------------------------------------------------------
Static Function MG02GetCnt()
    Local _cRet := Space(TamSX3('A1_CONTRIB')[1])

    If M->A1_TPESSOA == 'CI'    //CI=Comercio/Industria;PF=Pessoa Fisica;OS=Prestacõo de Servico;EP=Empresa Publica
        _cRet   := '1'
    Else
        _cRet   := '2'
    EndIf

    M->A1_CONTRIB   := _cRet
Return

//+------------------------------------------------------------------------------------------------
//| Retorna inscrição estadual genérica de acordo com estado
//+------------------------------------------------------------------------------------------------

Static Function MG02GetIns()
    Local _cRet := '000000000000000000'

    If M->A1_XGEN == '1'
        Do Case
            Case Empty(M->A1_EST)
                _cRet   := '0000000000'

            Case M->A1_EST == 'AC'
                _cRet   := '0100482300112'

            Case M->A1_EST == 'AL'
                _cRet   := '240000048'

            Case M->A1_EST == 'AP'
                _cRet   := '30123459'

            Case M->A1_EST == 'AM'
                _cRet   := '999999990'

            Case M->A1_EST == 'BA'
                _cRet   := '12345663'

            Case M->A1_EST == 'CE'
                _cRet   := '060000015'

            Case M->A1_EST == 'DF'
                _cRet   := '0730000100109'

            Case M->A1_EST == 'ES'
                _cRet   := '999999990'

            Case M->A1_EST == 'GO'
                _cRet   := '109876547'

            Case M->A1_EST == 'MA'
                _cRet   := '120000385'

            Case M->A1_EST == 'MT'
                _cRet   := '00130000019'

            Case M->A1_EST == 'MS'
                _cRet   := '283115947'

            Case M->A1_EST == 'MG'
                _cRet   := '0623079040081'

            Case M->A1_EST == 'PA'
                _cRet   := '159999995'

            Case M->A1_EST == 'PB'
                _cRet   := '060000015'

            Case M->A1_EST == 'PR'
                _cRet   := '1234567850'

            Case M->A1_EST == 'PE'
                _cRet   := '032141840'

            Case M->A1_EST == 'PI'
                _cRet   := '194419991'

            Case M->A1_EST == 'RJ'
                _cRet   := '99999993'

            Case M->A1_EST == 'RN'
                _cRet   := '200400401'

            Case M->A1_EST == 'RN'
                _cRet   := '2000400400'

            Case M->A1_EST == 'RS'
                _cRet   := '2243658792'

            Case M->A1_EST == 'RO'
                _cRet   := '101625213'

            Case M->A1_EST == 'RR'
                _cRet   := '240066281'

            Case M->A1_EST == 'SC'
                _cRet   := '251040852'

            Case M->A1_EST == 'SP'
                _cRet   := '110042490114'

            Case M->A1_EST == 'SE'
                _cRet   := '271234563'

            Case M->A1_EST == 'TO'
                _cRet   := '29010227836'
        EndCase
    Else
        _cRet := ''
    EndIf

    _cRet           := PadR(AllTrim(_cRet),TamSx3('A1_INSCR')[1])
    M->A1_INSCR     := _cRet
Return

//+------------------------------------------------------------------------------------------------
//| Retorna grupo de tributação de acordo com o informado no campo Contribuinte
//+------------------------------------------------------------------------------------------------
Static Function MG02GetGrp()
    Local _cRet := Space(TamSX3('A1_GRPTRIB')[1])

    Do Case
        Case M->A1_CONTRIB == '1'// Sim
            _cRet   := 'CTB'

        Case M->A1_CONTRIB == '2'// Não
            _cRet := 'NCB'
    End Case

     M->A1_GRPTRIB    := _cRet
Return

//+------------------------------------------------------------------------------------------------