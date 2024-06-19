#Include 'Protheus.ch'
#Include 'TBICONN.ch'

Static _cArqOri     := ''
Static _cArqLog     := ''

//+-------------------------------------------------------------------------------------------------
//  Rotina de alteração de produtos a partir de arquivo CSV
//+-------------------------------------------------------------------------------------------------
User Function M06D01U()
    Local   _aSays          := {}
    Local   _aButton        := {}
    Local   _cTitulo        := FunName()

    AADD(_aSays,OemToAnsi("Esta rotina tem como objetivo alterar o código de vendedor e percentual dos  "))
    AADD(_aSays,OemToAnsi("títulos a partir de um arquivo CSV. "))
    AADD(_aSays,OemToAnsi("  "))
    AADD(_aSays,OemToAnsi("Essa rotina é de uso provisório e está disponível até 30/09/2017."))

    aAdd( _aButton, { 1, .T., {|| Processa({||MD05Proc()}),FechaBatch()}}   )
    aAdd( _aButton, { 2, .T., {|| FechaBatch()                  }}  )

    FormBatch( _cTitulo, _aSays, _aButton )

    _cArqOri        := ''
    _cArqLog        := ''
Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05Proc()
Local _oDlg         := Nil
Local _cTitle       := 'Alteração de Vendedores/Comissões'
Local _oArqOri      := Nil
Local _oArqLog      := Nil

If ddatabase < CTOD("30/09/2017")
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
Else
	MsgStop("Prazo de uso da rotina expirou !","Atenção!")
Endif

Return

//+-------------------------------------------------------------------------------------------------
Static Function MD05ArqOri()
    _cArqOri    := cGetFile("CSV | *.csv","Selecione arquivo de Titulos",,"",.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY )
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
            FWMsgRun(, {||MD05Exec(_aField,_aItens[_nItem],@_cLog,@_nErr,@_nInc) },,I18N('Alterando título #1 de #2 ...',{++_nReg,_nTotal}))
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

    _cLog := CRLF + CRLF + I18N('Título alterado: #1',{_nInc})  +  CRLF + I18N('Títulos não alterados (erro): #1',{_nErr}) + CRLF + CRLF + _cLog
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
    Local _cMsgLog      := ''
    Local aProd         := {}
    Local aComp         := {}
    Private nPos          := 0

	dbSelectArea("SE1")
	dbSetOrder(1)

    aProd   := M05DProd(_aField,_aItem)
    aComp   := M05DComp(_aField,_aItem)

	If _aItem[1] == '1'
		_aItem[1] := '1  '
	Endif
	
	If Len(_aItem[2]) == 6
		_aItem[2] := _aItem[2]+Space(3)
	Endif
	
	If MsSeek(xFilial("SE1")+_aItem[1]+_aItem[2]+_aItem[3])
		If SE1->E1_TIPO $ 'NF |BOL'
			RecLock('SE1',.F.)
			SE1->E1_VEND1 	:= _aItem[9]
			SE1->E1_COMIS1	:= Val(_aItem[4])
			SE1->E1_VEND2 	:= _aItem[10]
			SE1->E1_COMIS2	:= Val(_aItem[5])
			SE1->E1_VEND3 	:= _aItem[11]
			SE1->E1_COMIS3	:= Val(_aItem[6])
			SE1->E1_VEND4 	:= _aItem[12]
			SE1->E1_COMIS4	:= Val(_aItem[7])
			SE1->E1_VEND5 	:= _aItem[13]
			SE1->E1_COMIS5	:= Val(_aItem[8])			
			If _aItem[3] <> "0"
				SE1->E1_PEDIDO := _aItem[14]
			Endif
			MsUnlock()
			_cCod 		:= SE1->E1_NUM
			_cMsgLog	:= 	"Alterado com Sucesso."
		Endif
	Else
		_cCod 		:= _aItem[2]
		_cMsgLog	:= 	"Não encontrado"
	Endif
	
	MD05PutSB1(aProd,aComp,@_cMsgLog,@_nErr,@_nInc)
	
    MD05GetLog(_cCod,_cMsgLog,@_cLog)

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
Static Function MD05GetLog(_cCod,_cMsgLog,_cLog)
    _cLog += CRLF
    _cLog += ' | Título: '      + _cCod   + ' |'
    _cLog += ' | STATUS: '      + AllTrim(_cMsgLog) + ' |'
Return

//+-------------------------------------------------------------------------------------------------
Static Function M05DProd(aField,aItem)
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

        lMsErroAuto := .F.

        If lMsErroAuto
            ++_nErr
            _cMsgLog    := MD05GetErr()
        Else
            _cMsgLog    := ' Alterado'
            ++_nInc
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
