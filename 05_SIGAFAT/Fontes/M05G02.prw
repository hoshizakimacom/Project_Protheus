#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
//  Função chamada de gatilhos na SA1
//+------------------------------------------------------------------------------------------------
User Function M05G02(_cField)
    Local _aArea        := GetArea()
    Local _xRet         := Nil

    Private lMVCSA1     := GETMV("MV_MVCSA1")

    Do Case
        Case _cField == 'A1_XGEN'
            _xRet   := &('M->'+_cField)

            MG02GetIns()    // Preenche inscrição estadual para clientes genéricos

        Case _cField == 'A1_TPESSOA'
            _xRet   := &('M->'+_cField)

            MG02GetCnt()    // Retorna de cliente é contribuinte ou não contribuinte
            MG02GetGrp()    // Retorna grupo de tributação

        Case _cField == 'A1_END'
            _xRet   := &('M->'+_cField)

            MG02SetE()

        Case _cField == 'A1_BAIRRO'
            _xRet   := &('M->'+_cField)

            MG02SetB()

        Case _cField == 'A1_EST'
            _xRet   := &('M->'+_cField)

            MG02SetEs()

        Case _cField == 'A1_CEP'
            _xRet   := &('M->'+_cField)

            MG02SetCep()

        Case _cField == 'A1_COD_MUN'
            _xRet   := &('M->'+_cField)

            MG02SetNat()

        Case _cField == 'A1_NATUREZ'
            _xRet   := &('M->'+_cField)

            MG02SetMun()

        Case _cField == 'A1_XGRPEC'
            _xRet   := &('M->'+_cField)

            MG02SetRed()

        Case _cField == 'A1_TIPO'
            _xRet   := &('M->'+_cField)

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

    If lMVCSA1
        FWFLDPUT("A1_LOJA", cLoja ) 
    Else   
        M->A1_LOJA  := cLoja
    EndIf
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

    If lMVCSA1
        FWFLDPUT("A1_CONTA", cConta ) 
    Else 
        M->A1_CONTA := cConta
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetRed()
    If lMVCSA1
        FWFLDPUT("A1_XREDE", Space(TamSX3('A1_XREDE')[1]) ) 
    Else
        M->A1_XREDE := Space(TamSX3('A1_XREDE')[1])
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetMun()

    If lMVCSA1
        FWFLDPUT("A1_MUNC", Posicione('CC2',1, xFilial('CC2') + M->A1_EST + M->A1_COD_MUN,'CC2_MUN' ) ) 
        FWFLDPUT("A1_CODMUNE", AllTrim(M->A1_COD_MUN) ) 
    Else
        M->A1_MUNC := Posicione('CC2',1, xFilial('CC2') + M->A1_EST + M->A1_COD_MUN,'CC2_MUN' )
        M->A1_CODMUNE := AllTrim(M->A1_COD_MUN)
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetCep()
    If lMVCSA1
        FWFLDPUT("A1_CEPC", AllTrim(M->A1_CEP) ) 
    Else
        M->A1_CEPC := AllTrim(M->A1_CEP)
    EndIf   
Return

//+------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------------------------------------
User Function MG02SetNat()
    
    //Local cTipo2    := AllTrim(M->A1_TIPO)
    //Local cNatur    := ""
        
    If lMVCSA1
        FWFLDPUT("A1_NATUREZ", AllTrim(M->A1_NATUREZ) ) 
    Else
        M->A1_NATUREZ := AllTrim(M->A1_NATUREZ)
    EndIf


    /*Do Case        
            Case M->cTipo2 == "F"
                cNatur:= "4110102"
            
            Case M->cTipo2 == "R"
                cNatur:= "4110102"
            
            Case M->cTipo2 == "X"
                cNatuz:= "4110103"
    EndCase*/
Return

//+------------------------------------------------------------------------------------------------


Static Function MG02SetEs()
    Local cReg      := ''
    Local cRegDes   := ''

    If lMVCSA1
        FWFLDPUT("A1_ESTC", AllTrim(M->A1_EST) )
        FWFLDPUT("A1_ESTE", AllTrim(M->A1_EST) )
    Else
        M->A1_ESTC    := AllTrim(M->A1_EST)
        M->A1_ESTE    := AllTrim(M->A1_EST)
    EndIf

    U_M05A30(M->A1_EST,@cReg,@cRegDes) 

    If lMVCSA1
        FWFLDPUT("A1_REGIAO", cReg)
        FWFLDPUT("A1_DSCREG", cRegDes)
    Else
        M->A1_REGIAO := cReg
        M->A1_DSCREG := cRegDes
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetB()
    If lMVCSA1
        FWFLDPUT("A1_BAIRROC", AllTrim(M->A1_BAIRRO) ) 
        FWFLDPUT("A1_BAIRROE", AllTrim(M->A1_BAIRRO) ) 
    Else
        M->A1_BAIRROC := AllTrim(M->A1_BAIRRO)
        M->A1_BAIRROE := AllTrim(M->A1_BAIRRO)
    EndIf
Return

//+------------------------------------------------------------------------------------------------
Static Function MG02SetE()
    If lMVCSA1
        FWFLDPUT("A1_ENDCOB", AllTrim(M->A1_END) ) 
        FWFLDPUT("A1_ENDENT", AllTrim(M->A1_END) ) 
    Else
        M->A1_ENDCOB := AllTrim(M->A1_END)
        M->A1_ENDENT := AllTrim(M->A1_END)
    EndIf
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

    If lMVCSA1
        FWFLDPUT("A1_CONTRIB", _cRet ) 
    Else
        M->A1_CONTRIB := _cRet
    EndIf   
Return

//+------------------------------------------------------------------------------------------------
//| Retorna inscrição estadual genérica de acordo com estado
//+------------------------------------------------------------------------------------------------

Static Function MG02GetIns()
    Local _cRet := ''
    

    //If M->A1_XGEN == '1'
        
        Do Case        
            Case M->A1_XGEN == "1".and. M->A1_EST == "AC"
                _cRet:= "0100482300112"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "AL"
                _cRet:= "240000048"

            Case M->A1_XGEN == "1".and. M->A1_EST == "AP"
                _cRet:= "30123459"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "AM"
                _cRet:= "999999990"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "BA"
                _cRet:= "12345663"

            Case M->A1_XGEN == "1".and. M->A1_EST == "CE"
                _cRet:= "060000015"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "DF"
                _cRet:= "730000100109"

            Case M->A1_XGEN == "1".and. M->A1_EST == "ES"
                _cRet:= "999999990"

            Case M->A1_XGEN == "1".and. M->A1_EST == "GO"
                _cRet:= "109876547"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "MA"
                _cRet:= "120000385"

            Case M->A1_XGEN == "1".and. M->A1_EST == "MT"
                _cRet:= "00130000019"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "MS"
                _cRet:= "283115947"

            Case M->A1_XGEN == "1".and. M->A1_EST == "MG"
                _cRet:= "0623079040081"

             Case M->A1_XGEN == "1".and. M->A1_EST == "PA"
                _cRet:= "159999995"

            Case M->A1_XGEN == "1".and. M->A1_EST == "PB"
                _cRet:= "060000015"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "PR"
                _cRet:= "1234567850"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "PE"
                _cRet:= "032141840"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "PI"
                _cRet:= "194419991"

            Case M->A1_XGEN == "1".and. M->A1_EST == "RJ"
                _cRet:= "99999993"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "RN"
                _cRet:= "200400401"

            Case M->A1_XGEN == "1".and. M->A1_EST == "RS"
                _cRet:= "2243658792"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "RO"
                _cRet:= "101625213"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "RR"
                _cRet:= "240066281"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "SC"
                _cRet:= "251040852"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "SP"
                _cRet:= "110042490114"
            
            Case M->A1_XGEN == "1".and. M->A1_EST == "SE"
                _cRet:= "271234563"

            Case M->A1_XGEN == "1".and. M->A1_EST == "TO"
                _cRet:= "29010227836"
            
        //    Case Empty(M->A1_EST)
        //        _cRet   := '0000000000'
        End Case  
    

    _cRet           := PadR(AllTrim(_cRet),TamSx3('A1_INSCR')[1])
    If lMVCSA1
        FWFLDPUT("A1_INSCR", _cRet ) 
    Else
        M->A1_INSCR := _cRet
    EndIf
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

    If lMVCSA1
        FWFLDPUT("A1_GRPTRIB", _cRet ) 
    Else
        M->A1_GRPTRIB := _cRet
    EndIf
Return

//+------------------------------------------------------------------------------------------------
