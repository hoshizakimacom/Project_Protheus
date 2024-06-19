#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
//  Rotina de ajuste que informa região e descrição da região de acordo com o estado informado
//  no cadastro do cliente.
//+------------------------------------------------------------------------------------------------
User Function M05D05U()
    Local   _aSays          := {}
    Local   _aButton        := {}
    Local   _cTitulo        := FunName()

    Local lSimulacao        := MsgYesNo('Deseja executar em modo SIMULAÇÃO?','Atenção')
    Local _cArqLog          := ''

    If lSimulacao
        AADD(_aSays,OemToAnsi('*** SIMULAÇÃO *** '))
    EndIf

    AADD(_aSays,OemToAnsi("Rotina de ajuste de Região de Clientes"))

    aAdd( _aButton, { 1, .T., {|| MD05Proc(lSimulacao,@_cArqLog),FechaBatch()}} )
    aAdd( _aButton, { 2, .T., {|| FechaBatch()                  }}  )

    FormBatch( _cTitulo, _aSays, _aButton )

    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Proc(lSimulacao,_cArqLog)
    Local _oDlg         := Nil
    Local _cTitle       := 'Ajuste de Regiçao de Clientes'
    Local _oArqLog      := Nil

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME From 000,000 To 300,900 Pixel

    @040,020 Say  'Arquivo Log:' Of _oDlg Pixel
    @037,080 Get _oArqLog Var _cArqLog Size 300,010 Of _oDlg Pixel WHEN .F.

    @037,400 BUTTON "Selec. Arquivo"    SIZE 040, 015 PIXEL OF _oDlg ACTION ( MD05ArqLog(@_cArqLog) )

    @120,170 BUTTON "Confirmar"     SIZE 040, 012 PIXEL OF _oDlg ACTION ( MD05Ok(lSimulacao,@_cArqLog) )
    @120,220 BUTTON "Cancelar"      SIZE 040, 012 PIXEL OF _oDlg ACTION (_oDlg:End())

    Activate MsDialog _oDlg Centered

    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05ArqLog(_cArqLog)
    Local _cArq     :=  cGetFile('*.TXT'    ,'Informe diretorio para arquivo de log'    ,0,'',.F.           ,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T. )

    _cArqLog := _cArq + DToS(Date()) + '_' + (StrTran(Time(),':','')) + '.TXT'
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Ok(lSimulacao,_cArqLog)
    Local _nTotal   := 0
    Local _nReg     := 0
    Local _cLog     := 'Inicio ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF
    Local _cMsg     := ''
    Local _nErr     := 0
    Local _nInc     := 0
    Local _nAtu     := 0

    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    SA1->( DbEval( {|| _nTotal++ } ) )
    SA1->(DbGoTop())

    // Percorre itens do array
    While SA1->(!EOF())
        FWMsgRun(, {||MD05Exec(@_cLog,@_nErr,@_nInc,@_nAtu,lSimulacao) },,I18N('Atualizando Cliente #1 de #2 ...',{++_nReg,_nTotal}))

        SA1->(DbSkip())
    EndDo

    _cMsg := MD05Log(_cArqLog,_cMsg,@_cLog,_nErr,_nInc,_nAtu)

    Aviso('Atenção',I18N( _cMsg,{_nTotal,_cArqLog}),{'OK'},3)

    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Log(_cArqLog,_cMsg,_cLog,_nErr,_nInc,_nAtu)
    Local _nHandle      := 0

    _nHandle    := FCREATE(_cArqLog)

    _cLog := CRLF + CRLF + I18N('Regiões incluídas: #1',{_nInc})  +  CRLF + I18N('Regiões atualizadas: #1',{_nAtu})  +  CRLF  + I18N('Regiões não atualizadas: #1',{_nErr}) + CRLF + CRLF + _cLog
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
Static Function MD05Exec(_cLog,_nErr,_nInc,_nAtu,lSimulacao)
    Local _cMsgLog      := ''
    Local cReg          := ''
    Local cRegDes       := ''
    Local cRegOld       := ''
    Local cRegDesOld    := ''

    If !Empty(SA1->A1_EST)
        U_M05A30(SA1->A1_EST,@cReg,@cRegDes)

        cRegOld     := SA1->A1_REGIAO
        cRegDesOld  := SA1->A1_DSCREG

        If AllTrim(Upper(cRegDesOld)) <> AllTrim(Upper(cRegDes)) .Or. AllTrim(cRegOld) <> AllTrim(cReg)

            If Empty(SA1->A1_REGIAO)
                _cMsgLog    := 'Incluido'
                ++_nInc
            Else
                _cMsgLog    := 'Atualizado'
                ++_nAtu
            EndIf
            If !lSimulacao
                RecLock('SA1',.F.)
                    SA1->A1_REGIAO  := cReg
                    SA1->A1_DSCREG  := cRegDes
                SA1->(MsUnLock())
            EndIf


        Else
            _cMsgLog    := 'Regiao ja cadastrada'
            ++_nErr
        EndIf
    Else
        ++_nErr
        _cMsgLog    := 'Estado não preenchido'
    EndIf

    MD05GetLog(SA1->A1_COD,SA1->A1_LOJA,SA1->A1_EST,cReg,cRegDes,cRegOld,cRegDesOld,_cMsgLog,@_cLog)
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05GetLog(cCod,cLoja,cEst,cReg,cRegDes,cRegOld,cRegDesOld,_cMsgLog,_cLog)
    _cLog += CRLF
    _cLog += ' | Código: '          + cCod
    _cLog += ' | Loja: '            + cLoja
    _cLog += ' | Estado: '          + cEst
    _cLog += ' | Regiao Ant.: '     + cRegOld
    _cLog += ' | Desc Ant.: '       + cRegDesOld
    _cLog += ' | Regiao Nova: '     + cReg
    _cLog += ' | Desc Nova: '       + PadR(cRegDes,TamSX3('A1_DSCREG')[1])
    _cLog += ' | STATUS: '          + AllTrim(_cMsgLog) + ' |'
Return