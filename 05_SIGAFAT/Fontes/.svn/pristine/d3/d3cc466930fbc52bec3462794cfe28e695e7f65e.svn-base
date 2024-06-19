#Include 'Protheus.ch'
#Include 'TBICONN.ch'

Static _cArqOri     := ''
Static _cArqLog     := ''

//+-------------------------------------------------------------------------------------------------
//  Rotina de exclusão de produtos a partir de arquivo CSV
//+-------------------------------------------------------------------------------------------------
User Function M05D03D()
    Local   _aSays          := {}
    Local   _aButton        := {}
    Local   _cTitulo        := FunName()

    AADD(_aSays,OemToAnsi("Esta rotina tem como objetivo deletar produtos a partir de um arquivo CSV."))
    AADD(_aSays,OemToAnsi(" "))

    aAdd( _aButton, { 1, .T., {|| Processa({||MD05Proc()}),FechaBatch()}}   )
    aAdd( _aButton, { 2, .T., {|| FechaBatch()                  }}  )

    FormBatch( _cTitulo, _aSays, _aButton )

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Proc()
    Local _oDlg         := Nil
    Local _cTitle       := 'Exclusão de Produtos'
    Local _oArqOri      := Nil
    Local _oArqLog      := Nil

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME From 000,000 To 300,900 Pixel

    @020,020 Say  'Arquivo Origem *.CSV:' Of _oDlg Pixel
    @017,080 Get _oArqOri Var _cArqOri Size 300,010 Of _oDlg Pixel WHEN .F.

    @017,400 BUTTON "Selec. Arquivo"    SIZE 040, 015 PIXEL OF _oDlg ACTION ( MD05ArqOri() )

    @040,020 Say  'Arquivo Log:' Of _oDlg Pixel
    @037,080 Get _oArqLog Var _cArqLog Size 300,010 Of _oDlg Pixel WHEN .F.

    @037,400 BUTTON "Selec. Arquivo"    SIZE 040, 015 PIXEL OF _oDlg ACTION ( MD05ArqLog() )

    @120,170 BUTTON "Confirmar"     SIZE 040, 012 PIXEL OF _oDlg ACTION ( MD05Ok() )
    @120,220 BUTTON "Cancelar"      SIZE 040, 012 PIXEL OF _oDlg ACTION (_oDlg:End())

    Activate MsDialog _oDlg Centered

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05ArqOri()
    _cArqOri    := cGetFile("CSV | *.csv","Selecione arquivo de Produtos",,"",.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY )
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05ArqLog()
    Local _cArq     :=  cGetFile('*.TXT'    ,'Informe diretorio para arquivo de log'    ,0,'',.F.           ,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T. )

    _cArqLog := _cArq + DToS(Date()) + '_' + (StrTran(Time(),':','')) + '.TXT'
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Ok()
    Local _lValid   := .T.
    Local _aItens   := {}
    Local _aField   := {}
    Local _nTotal   := 0
    Local _nItem    := 0
    Local _nReg     := 0
    Local _cLog     := 'Inicio ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF
    Local _cMsg     := ''
    Local _nErr     := 0
    Local _nInc     := 0

    _lValid := MD05VldArq(@_aField,@_aItens,@_nTotal)

    If _lValid


        // Percorre itens do array
        For _nItem := 1 To Len(_aItens)
            FWMsgRun(, {||MD05Exec(_aField,_aItens[_nItem],@_cLog,@_nErr,@_nInc) },,I18N('Excluindo produto #1 de #2 ...',{++_nReg,_nTotal}))
        Next

        _cMsg := MD05Log(_cArqLog,_cMsg,@_cLog,_nErr,_nInc)

        Aviso('Atenção',I18N( _cMsg,{_nTotal,_cArqLog}),{'OK'},3)

        _cArqOri        := ''
        _cArqLog        := ''
    EndIf
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Log(_cArqLog,_cMsg,_cLog,_nErr,_nInc)
    Local _nHandle      := 0

    _nHandle    := FCREATE(_cArqLog)

    _cLog := CRLF + CRLF + I18N('Produtos Excluídos: #1',{_nInc})  +  CRLF + I18N('Produtos não excluídos (erro): #1',{_nErr}) + CRLF + CRLF + _cLog
    _cLog += CRLF + CRLF + 'Fim ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF

    If _nHandle = -1
        _cMsg   += " Erro ao criar arquivo - ferror " + Str(Ferror())
    Else
        _cMsg += ' Verifique arquivo de log gerado: ' + CRLF + CRLF + '#2 ' + CRLF
        FWrite(_nHandle, _cLog)
        FClose(_nHandle)
    EndIf
Return _cMsg

//+-------------------------------------------------------------------------------------------------
Static Function MD05Exec(_aField,_aItem,_cLog,_nErr,_nInc)
    Local _cCod         := ''
    Local _cTipo        := ''
    Local _cOrigem      := ''
    Local _cMsgLog      := ''
    Local nPos          := 0
    Local aProd         := {}
    Local aComp         := {}

        aProd   := M05DProd(_aField,_aItem)
        aComp   := M05DComp(_aField,_aItem)

        If ( nPos := AScan(aProd,{|x| AllTrim(x[1]) == 'B1_COD'}) ) > 0
            _cCod       := aProd[nPos][2]
        EndIf

        If ( nPos := AScan(aProd,{|x| AllTrim(x[1]) == 'B1_TIPO'}) ) > 0
            _cTipo       := aProd[nPos][2]
        EndIf

        If ( nPos := AScan(aProd,{|x| AllTrim(x[1]) == 'B1_ORIGEM'}) ) > 0
            _cOrigem       := aProd[nPos][2]
        EndIf


        MD05PutSB1(aProd,aComp,@_cMsgLog,@_nErr,@_nInc)

        MD05GetLog(_cCod,_cTipo,_cOrigem,_cMsgLog,@_cLog)

Return

//+-------------------------------------------------------------------------------------------------
// verifica se o campo existe no top
//+-------------------------------------------------------------------------------------------------
Static Function MD05VldFld(aField)
    Local aAreaSX3  := SX3->(GetArea())
    Local lRet      := .T.
    Local Nx        := 0
    Local aAuxaField    := AClone(aField)

    aField          := {}

    DbSelectArea('SX3')


    For Nx := 1 to Len(aAuxaField)
        SX3->(DbSetOrder(2))
        SX3->(DbgoTop())

        cCampo  := PadR(AllTrim(aAuxaField[Nx]),10)

        If SX3->(DBSeek( cCampo ))
            AAdd(aField,{cCampo,SX3->X3_TIPO })
        Else
            lErro   := .T.
            Exit
        EndIf
    Next


    If !lRet
        MsgInfo(I18N('Campo #1 informado no arquivo origem não existe na base de dados.' + CRLF + 'Verifique',{AllTrim(cCampo)}), 'Atenção')
    EndIf

    RestArea(aAreaSX3)
Return lRet

//+-------------------------------------------------------------------------------------------------
Static Function MD05GetLog(_cCod,_cTipo,_cOrigem,_cMsgLog,_cLog)
    _cLog += CRLF
    _cLog += ' | Código: '      + _cCod
    _cLog += ' | Tipo: '        + _cTipo
    _cLog += ' | Origem: '      + _cOrigem
    _cLog += ' | STATUS: '      + AllTrim(_cMsgLog) + ' |'
Return

//+-------------------------------------------------------------------------------------------------
Static Function M05DProd(aField,aItem)
    Local aRet      := {}
    Local nX        := 0

    For nX := 1 To Len(aField)

        If SubStr(aField[nX][1],1,2) == 'B1'
            Do Case
            Case aField[nX][2] == 'N'
                AAdd(aRet ,{aField[nX][1]   ,Val(aItem[nX])                     ,Nil})
            Case aField[nX][2] == 'C'
                AAdd(aRet ,{aField[nX][1]   ,aItem[nX]                          ,Nil})
            Case aField[nX][2] == 'L'
                AAdd(aRet ,{aField[nX][1]   ,IFF(aItem[nX] == '.T.',.T.,.F.)     ,Nil})
            Case aField[nX][2] == 'D'
                AAdd(aRet ,{aField[nX][1]   ,SToD(aItem[nX])                    ,Nil})
            EndCase
       EndIf
    Next

    aRet := FWVetByDic(aRet,'SB1')
Return AClone(aRet)

//+-------------------------------------------------------------------------------------------------
Static Function M05DComp(aField,aItem)
    Local aRet      := {}
    Local nX        := 0

    For nX := 1 To Len(aField)

        If SubStr(aField[nX][1],1,2) == 'B5'
            Do Case
            Case aField[nX][2] == 'N'
                AAdd(aRet ,{aField[nX][1]   ,Val(aItem[nX])                     ,Nil})
            Case aField[nX][2] == 'C'
                AAdd(aRet ,{aField[nX][1]   ,aItem[nX]                          ,Nil})
            Case aField[nX][2] == 'L'
                AAdd(aRet ,{aField[nX][1]   ,IFF(aItem[nX] == '.T.',.T.,.F.)     ,Nil})
            Case aField[nX][2] == 'D'
                AAdd(aRet ,{aField[nX][1]   ,SToD(aItem[nX])                    ,Nil})
            EndCase
        EndIf
    Next

    aRet := FWVetByDic(aRet,'SB5')
Return AClone(aRet)

//+-------------------------------------------------------------------------------------------------
Static Function MD05PutSB1(aProd,aComp,_cMsgLog,_nErr,_nInc)

    BeginTran()

        lMsErroAuto := .F.

        MSExecAuto({|x,y| Mata010(x,y)},aProd,5)

        If lMsErroAuto
            ++_nErr
            _cMsgLog    := MD05GetErr()
        EndIf


        // Inclui complemento
//        If !lMsErroAuto
//
//            MSExecAuto({|x,y| Mata180(x,y)},aComp,3)
//
//            If lMsErroAuto
//                ++_nErr
//                _cMsgLog    := MD05GetErr()
//            Else
//                _cMsgLog    := ' Incluído'
//                ++_nInc
//            EndIf
//        EndIf

        If lMsErroAuto
            DisarmTransaction()
        Else
            EndTran()
        EndIf

    MsUnlockAll()
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05GetErr()
    Local _cRet         := ''
    Local _cFileError   := NomeAutoLog()
    Local _cMemo            := MemoRead( _cFileError )
    Local _nY               := 0
    Local _cAux         := ''
    Local _lTitulo      := .T.

    For _nY := 1 To MLCount(_cMemo)
        _cAux := AllTrim(MemoLine(_cMemo,,_nY))

        If Len(_cAux) > 0 .And. _lTitulo
            _cRet += _cAux + " "
        Else
            If At("< --", _cAux) > 0
                _cRet += " | " + _cAux
            EndIf
            _lTitulo    := .F.
        EndIf
    Next _nY

    Ferase(_cFileError)
Return _cRet

//+-------------------------------------------------------------------------------------------------
Static Function MD05VldArq(_aField,_aItens,_nTotal)
    Local _lRet := .T.

    If !(_lRet := !(Empty(_cArqOri) .Or. Empty (_cArqLog)))
        MsgInfo('Arquivo Origem e Arquivo de Log são obrigatórios.' + CRLF + 'Verifique.', 'Atenção!')
    EndIf

    If _lRet
        MD05ArqInf(@_aField,@_aItens,@_nTotal) // carrega dados do arquivo no array
    EndIf

    If _lRet
        _lRet  := MD05VldFld(@_aField)
    EndIf

Return _lRet

//+-------------------------------------------------------------------------------------------------
Static Function MD05ArqInf(_aField,_aItens,_nTotal)
    Local _aLinha   := {}
    Local _cLinha   := ''
    Local _nArq     := FOpen(_cArqOri, 0)
    Local lField    := .T.

    FT_FUSE(_cArqOri)
    FT_FGOTOP()

    While !FT_FEOF()
        _cLinha     := FT_FREADLN()
        _aLinha     := {}
        _aLinha     := Separa(_cLinha,";",.T.)

        If Len(_aLinha) > 0
            If lField
                lField := .F.
                _aField := AClone(_aLinha)
            Else

                AAdd(_aItens,_aLinha)
            EndIf
        EndIf

        FT_FSKIP()
    EndDo

    _nTotal := Len(_aItens)

    FT_FUse()
    FClose(_nArq)
Return
