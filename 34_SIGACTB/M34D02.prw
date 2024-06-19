#Include 'Protheus.ch'
#Include 'TBICONN.ch'

Static _cArqOri     := ''
Static _cArqLog     := ''

//+-------------------------------------------------------------------------------------------------
//  Rotina de importação de fornecedores a partir de arquivo CSV
//+-------------------------------------------------------------------------------------------------
User Function M34D02()
    Local   _aSays          := {}
    Local   _aButton        := {}
    Local   _cTitulo        := FunName()

    AADD(_aSays,OemToAnsi("Esta rotina tem como objetivo criar item contábil para os fornecedores que ainda não possuem."))
    AADD(_aSays,OemToAnsi(" "))

    aAdd( _aButton, { 1, .T., {|| Processa({||MD34Proc()}),FechaBatch()}}   )
    aAdd( _aButton, { 2, .T., {|| FechaBatch()                  }}  )

    FormBatch( _cTitulo, _aSays, _aButton )

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34Proc()
    Local _oDlg         := Nil
    Local _cTitle       := 'Importação Fornecedores + Item Contabil'
    Local _oArqLog      := Nil
    Private _oArqOri      := Nil

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME From 000,000 To 300,900 Pixel

//    @020,020 Say  'Arquivo Origem *.CSV:' Of _oDlg Pixel
//    @017,080 Get _oArqOri Var _cArqOri Size 300,010 Of _oDlg Pixel WHEN .F.

//    @017,400 BUTTON "Selec. Arquivo"    SIZE 040, 015 PIXEL OF _oDlg ACTION ( MD05ArqOri() )

    @040,020 Say  'Arquivo Log:' Of _oDlg Pixel
    @037,080 Get _oArqLog Var _cArqLog Size 300,010 Of _oDlg Pixel WHEN .F.

    @037,400 BUTTON "Selec. Arquivo"    SIZE 040, 015 PIXEL OF _oDlg ACTION ( MD34ArqLog() )

    @120,170 BUTTON "Confirmar"     SIZE 040, 012 PIXEL OF _oDlg ACTION ( MD34Ok() )
    @120,220 BUTTON "Cancelar"      SIZE 040, 012 PIXEL OF _oDlg ACTION (_oDlg:End())

    Activate MsDialog _oDlg Centered

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34ArqLog()
    Local _cArq     :=  cGetFile('*.TXT'    ,'Informe diretorio para arquivo de log'    ,0,'',.F.           ,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T. )

    _cArqLog := _cArq + DToS(Date()) + '_' + (StrTran(Time(),':','')) + '.TXT'
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34Ok()
    
    Local _nReg     := 0
    Local _cLog     := 'Inicio ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF
    Local _cMsg     := ''
    Local _nErr     := 0
    Local _nInc     := 0
    Local _cAlias   := GetNextAlias()
    Private _lValid   := .T.
    Private _aItens   := {}
    Private _aField   := {}
    Private _nTotal   := 0
    Private _nItem    := 0

   MD34Select(_cAlias,@_nTotal)

    // Percorre itens do array
    While (_cAlias)->(!EOF())
        FWMsgRun(, {||MD34Exec(_cAlias,@_cLog,@_nErr,@_nInc) },,I18N('Importanto Item Contábil #1 de #2 ...',{++_nReg,_nTotal}))

        (_cAlias)->(DbSkip())
    EndDo

    _cMsg := MD34Log(_cArqLog,_cMsg,@_cLog,_nErr,_nInc)

    Aviso('Atenção',I18N( _cMsg,{_nTotal,_cArqLog}),{'OK'},3)

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34Select(_cAlias,_nTotal)

    BeginSql Alias _cAlias
        SELECT   A2_COD
                ,A2_LOJA
                ,A2_XITEMC
                ,A2_NOME
                ,R_E_C_N_O_ AS SA2_RECNO
        FROM %Table:SA2% SA2
        WHERE SA2.%NotDel% AND A2_XITEMC = ' '
    EndSql

    (_cAlias)->( dbEval( {|| _nTotal++ } ) )
    (_cAlias)->( dbGoTop() )
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34Log(_cArqLog,_cMsg,_cLog,_nErr,_nInc)
    Local _nHandle      := 0

    _nHandle    := FCREATE(_cArqLog)

    _cLog := CRLF + CRLF + I18N('Clientes Incluídos: #1',{_nInc})  +  CRLF + I18N('Clientes não incluídos (erro): #1',{_nErr}) + CRLF + CRLF + _cLog
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
Static Function MD34Exec(_cAlias,_cLog,_nErr,_nInc)
    Local cItemC        := '2' + AllTrim((_cAlias)->A2_COD )+ AllTrim((_cAlias)->A2_LOJA)
    Local _cMsgLog      := ''
    Local _aDados       := {}
    Local cNome         := AllTrim((_cAlias)->A2_NOME)

    lMsErroAuto     := .F.


    CTD->(DbSetOrder(1))    // CTD_FILIAL+CTD_ITEM
    CTD->(DbGoTop())


    // Verifica se item contabil já existe. Se não, inclui
    If !CTD->(DbSeek( xFilial('CTD') + cItemC ))

        AAdd(_aDados,   {'CTD_ITEM'     ,cItemC                     ,Nil})
        AAdd(_aDados,   {'CTD_CLASSE'   ,'2'                        ,Nil})  // 1=Sintetica;2=Analitica
        AAdd(_aDados,   {'CTD_DESC01'   ,cNome                      ,Nil})  // Descrição da moeda 1
        AAdd(_aDados,   {'CTD_BLOQ'     ,'2'                        ,Nil})  // Bloqueado? 1=Sim;2=Nao
        AAdd(_aDados,   {'CTD_DTEXIS'   ,SToD('19800101')           ,Nil})  // Data inicio de existencia
        AAdd(_aDados,   {'CTD_DTEXSF'   ,SToD('20401231')           ,Nil})  // Data fim de existencia
        AAdd(_aDados,   {'CTD_CLOBRG'   ,'2'                        ,Nil})  // Nao - Classe Valor Obrigatório
        AAdd(_aDados,   {'CTD_ACCLVL'   ,'1'                        ,Nil})  // Sim - Aceita Classe de Valor

        MSExecAuto({|x,y| CTBA040(x,y)},_aDados,3)
    EndIf

    If !lMsErroAuto
        // Atualiza cadastro do cliente
        SA2->(DbGoto( (_cAlias)->SA2_RECNO ))

        If SA2->(!EOF())
            RecLock('SA2',.F.)
                SA2->A2_XITEMC  := cItemC
            SA2->(MsUnLock())
        EndIf
        ++_nInc
        _cMsgLog    := 'Incluído'
    Else

        ++_nErr
        _cMsgLog    := MD34GetErr()
    EndIf

    MD34GetLog((_cAlias)->A2_COD,(_cAlias)->A2_LOJA,cItemC,_cMsgLog,@_cLog)
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34GetLog(cCod,cLoja,cItemC,_cMsgLog,_cLog)
    _cLog += CRLF
    _cLog += ' | Código: '      + cCod
    _cLog += ' | Loja: '        + cLoja
    _cLog += ' | Item Contabil: '        + cItemC
    _cLog += ' | STATUS: '      + AllTrim(_cMsgLog) + ' |'
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD34GetErr()
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

//+-------------------------------------------------------------------------------------------------------------------
//| Cadastro de item contabil por cliente no momento da aprovação do orçamento de vendas
//+-------------------------------------------------------------------------------------------------------------------
Static Function MD34ItemC(cCod,cLoja,cItemC,_cMsgLog)

Return
