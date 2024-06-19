#Include 'Protheus.ch'

//+------------------------------------------------------------------------
//  Relatorio de Comparativo contabil
//+------------------------------------------------------------------------
User Function M34R03()
    Local _oReport      := Nil
    Local _cPerg        := 'M34R03   '

    MR34PutSX1(_cPerg)

    If FindFunction('TRepInUse') .And. TRepInUse(.F.)   //verifica se relatorios personalizaveis esta disponivel
        If Pergunte(_cPerg, .T.)
            _oReport := MR34RepDef(_oReport, _cPerg)
            _oReport:PrintDialog()
        EndIf
    EndIf
Return

//+------------------------------------------------------------------------
Static Function MR34RepDef(_oReport, _cPerg)
    Local _cTitle       := 'Relatorio Mensal de Conta Contabil'
    Local _cHelp        := 'Permite gerar relatorio mensal das contas contabeis'
    Local _cAlias1      := GetNextAlias()
    Local _cAlias2      := GetNextAlias()
    Local _oCCCusto     := Nil
    Local _oCCCustoA    := Nil
    Local _oSCCustoA    := Nil

    _oReport    := TReport():New('M34R03   ',_cTitle,_cPerg,{|_oReport| MR34Print(_oReport,_cAlias1,_cAlias2)},_cHelp)
    _oReport:SetMeter(3)

    //+-------------------------------------------
    //| Centro de Custo     - Sim
    //| Acumulado           - Nao
    //+-------------------------------------------
    _oCCCusto := TRSection():New(_oReport,'Com CCusto',{_cAlias1})

    TRCell():New(_oCCCusto,'TIPO'               , _cAlias1)
    TRCell():New(_oCCCusto,'CONTA'              , _cAlias1)
    TRCell():New(_oCCCusto,'CONTA_DESC'     	, _cAlias1)
    TRCell():New(_oCCCusto,'CCUSTO'             , _cAlias1)
    TRCell():New(_oCCCusto,'CCUSTO_DESC'        , _cAlias1)
    TRCell():New(_oCCCusto,'JANEIRO'            , _cAlias1)
    TRCell():New(_oCCCusto,'FEVEREIRO'          , _cAlias1)
    TRCell():New(_oCCCusto,'MARCO'              , _cAlias1)
    TRCell():New(_oCCCusto,'ABRIL'              , _cAlias1)
    TRCell():New(_oCCCusto,'MAIO'               , _cAlias1)
    TRCell():New(_oCCCusto,'JUNHO'              , _cAlias1)
    TRCell():New(_oCCCusto,'JULHO'              , _cAlias1)
    TRCell():New(_oCCCusto,'AGOSTO'             , _cAlias1)
    TRCell():New(_oCCCusto,'SETEMBRO'           , _cAlias1)
    TRCell():New(_oCCCusto,'OUTUBRO'            , _cAlias1)
    TRCell():New(_oCCCusto,'NOVEMBRO'           , _cAlias1)
    TRCell():New(_oCCCusto,'DEZEMBRO'           , _cAlias1)

    _oCCCusto:oReport:cFontBody                 := 'Calibri'
    _oCCCusto:oReport:nFontBody                 := 11

    //+-------------------------------------------
    //| Centro de Custo     - Sim
    //| Acumulado           - Sim
    //+-------------------------------------------
    _oCCCustoA := TRSection():New(_oReport,'Com CCusto Acum',{_cAlias1})

    TRCell():New(_oCCCustoA,'TIPO'              , _cAlias1)
    TRCell():New(_oCCCustoA,'CONTA'             , _cAlias1)
    TRCell():New(_oCCCustoA,'CONTA_DESC'        , _cAlias1)
    TRCell():New(_oCCCustoA,'CCUSTO'            , _cAlias1)
    TRCell():New(_oCCCustoA,'CCUSTO_DESC'       , _cAlias1)
    TRCell():New(_oCCCustoA,'JANEIRO'           , _cAlias1)
    TRCell():New(_oCCCustoA,'FEVEREIRO'     	, _cAlias1)
    TRCell():New(_oCCCustoA,'MARCO'             , _cAlias1)
    TRCell():New(_oCCCustoA,'ABRIL'             , _cAlias1)
    TRCell():New(_oCCCustoA,'MAIO'              , _cAlias1)
    TRCell():New(_oCCCustoA,'JUNHO'             , _cAlias1)
    TRCell():New(_oCCCustoA,'JULHO'             , _cAlias1)
    TRCell():New(_oCCCustoA,'AGOSTO'            , _cAlias1)
    TRCell():New(_oCCCustoA,'SETEMBRO'          , _cAlias1)
    TRCell():New(_oCCCustoA,'OUTUBRO'           , _cAlias1)
    TRCell():New(_oCCCustoA,'NOVEMBRO'          , _cAlias1)
    TRCell():New(_oCCCustoA,'DEZEMBRO'          , _cAlias1)

    _oCCCusto:oReport:cFontBody                 := 'Calibri'
    _oCCCusto:oReport:nFontBody                 := 11


    //+-------------------------------------------
    //| Centro de Custo     - Nao
    //| Acumulado           - Nao
    //+-------------------------------------------
    _oSCCustoA := TRSection():New(_oReport,'Sem CCusto Acum',{_cAlias2})

    TRCell():New(_oSCCustoA,'CONTA'             , _cAlias2)
    TRCell():New(_oSCCustoA,'CONTA_DESC'        , _cAlias2)
    TRCell():New(_oSCCustoA,'SALDO'             , _cAlias2)
    TRCell():New(_oSCCustoA,'JANEIRO'           , _cAlias2)
    TRCell():New(_oSCCustoA,'FEVEREIRO'     	, _cAlias2)
    TRCell():New(_oSCCustoA,'MARCO'             , _cAlias2)
    TRCell():New(_oSCCustoA,'ABRIL'             , _cAlias2)
    TRCell():New(_oSCCustoA,'MAIO'              , _cAlias2)
    TRCell():New(_oSCCustoA,'JUNHO'             , _cAlias2)
    TRCell():New(_oSCCustoA,'JULHO'             , _cAlias2)
    TRCell():New(_oSCCustoA,'AGOSTO'            , _cAlias2)
    TRCell():New(_oSCCustoA,'SETEMBRO'          , _cAlias2)
    TRCell():New(_oSCCustoA,'OUTUBRO'           , _cAlias2)
    TRCell():New(_oSCCustoA,'NOVEMBRO'          , _cAlias2)
    TRCell():New(_oSCCustoA,'DEZEMBRO'          , _cAlias2)

    _oSCCustoA:oReport:cFontBody                := 'Calibri'
    _oSCCustoA:oReport:nFontBody                := 11

Return(_oReport)

//+------------------------------------------------------------------------
Static Function MR34Print(_oReport,_cAlias1,_cAlias2)
    
    Local _nTotal           := 0
    Private _oSection         := _oReport:Section(1)
    Private _cChave           := ''

    //+-------------------------------------------
    //| Inicio da impressao
    //+-------------------------------------------
    MR34GetCCC(_cAlias1,@_nTotal)
    MR34GetSCC(_cAlias2,@_nTotal)

    _oReport:SetMeter(_nTotal)
    _oReport:IncMeter()

    MR34Print1(_cAlias1,_oReport)       // Centro de Custo (S) | Acumulado (N)
    MR34Print2(_cAlias1,_oReport)       // Centro de Custo (S) | Acumulado (S)
    MR34Print3(_cAlias2,_oReport)       // Centro de Custo (N) | Acumulado (S)

    (_cAlias1)->(DbCloseArea())
    (_cAlias2)->(DbCloseArea())
return

//+------------------------------------------------------------------------
Static Function MR34Print1(_cAlias1,_oReport)
    _oReport:IncMeter()

    _oReport:Section(1):Init()
    (_cAlias1)->(DbGoTop())

    While !_oReport:Cancel() .And. (_cAlias1)->(!EOF())
        _oReport:Section(1):Cell('TIPO'                     ):SetBlock( {||(_cAlias1)->TIPO })
        _oReport:Section(1):Cell('CONTA'                    ):SetBlock( {||(_cAlias1)->CONTA })
        _oReport:Section(1):Cell('CONTA_DESC'               ):SetBlock( {||(_cAlias1)->CONTA_DESC })
        _oReport:Section(1):Cell('CCUSTO'                   ):SetBlock( {||(_cAlias1)->CCUSTO })
        _oReport:Section(1):Cell('CCUSTO_DESC'              ):SetBlock( {||(_cAlias1)->CCUSTO_DESC })
        _oReport:Section(1):Cell('JANEIRO'                  ):SetBlock( {||(_cAlias1)->JANEIRO })
        _oReport:Section(1):Cell('FEVEREIRO'                ):SetBlock( {||(_cAlias1)->FEVEREIRO })
        _oReport:Section(1):Cell('MARCO'                    ):SetBlock( {||(_cAlias1)->MARCO })
        _oReport:Section(1):Cell('ABRIL'                    ):SetBlock( {||(_cAlias1)->ABRIL })
        _oReport:Section(1):Cell('MAIO'                     ):SetBlock( {||(_cAlias1)->MAIO })
        _oReport:Section(1):Cell('JUNHO'                    ):SetBlock( {||(_cAlias1)->JUNHO })
        _oReport:Section(1):Cell('JULHO'                    ):SetBlock( {||(_cAlias1)->JULHO })
        _oReport:Section(1):Cell('AGOSTO'                   ):SetBlock( {||(_cAlias1)->AGOSTO })
        _oReport:Section(1):Cell('SETEMBRO'             	):SetBlock( {||(_cAlias1)->SETEMBRO })
        _oReport:Section(1):Cell('OUTUBRO'                  ):SetBlock( {||(_cAlias1)->OUTUBRO })
        _oReport:Section(1):Cell('NOVEMBRO'            		):SetBlock( {||(_cAlias1)->NOVEMBRO })
        _oReport:Section(1):Cell('DEZEMBRO'             	):SetBlock( {||(_cAlias1)->DEZEMBRO })

        _oReport:Section(1):PrintLine()

        (_cAlias1)->(DbSkip())
    EndDo

    _oReport:Section(1):Finish()
Return

//+------------------------------------------------------------------------
Static Function MR34Print2(_cAlias1,_oReport)

    _oReport:Section(2):Init()
    (_cAlias1)->(DbGoTop())

    While !_oReport:Cancel() .And. (_cAlias1)->(!EOF())
        _oReport:IncMeter()

        _oReport:Section(2):Cell('TIPO'                 ):SetBlock( {||(_cAlias1)->TIPO })
        _oReport:Section(2):Cell('CONTA'                ):SetBlock( {||(_cAlias1)->CONTA })
        _oReport:Section(2):Cell('CONTA_DESC'           ):SetBlock( {||(_cAlias1)->CONTA_DESC })
        _oReport:Section(2):Cell('CCUSTO'               ):SetBlock( {||(_cAlias1)->CCUSTO })
        _oReport:Section(2):Cell('CCUSTO_DESC'          ):SetBlock( {||(_cAlias1)->CCUSTO_DESC })
        _oReport:Section(2):Cell('JANEIRO'              ):SetBlock( {||(_cAlias1)->JANEIRO })
        _oReport:Section(2):Cell('FEVEREIRO'            ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO })
        _oReport:Section(2):Cell('MARCO'                ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO })
        _oReport:Section(2):Cell('ABRIL'                ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL })
        _oReport:Section(2):Cell('MAIO'                 ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO })
        _oReport:Section(2):Cell('JUNHO'                ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO })
        _oReport:Section(2):Cell('JULHO'                ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO })
        _oReport:Section(2):Cell('AGOSTO'               ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO })
        _oReport:Section(2):Cell('SETEMBRO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO })
        _oReport:Section(2):Cell('OUTUBRO'              ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO })
        _oReport:Section(2):Cell('NOVEMBRO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO + (_cAlias1)->NOVEMBRO })
        _oReport:Section(2):Cell('DEZEMBRO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO + (_cAlias1)->NOVEMBRO + (_cAlias1)->DEZEMBRO })

        _oReport:Section(2):PrintLine()

        (_cAlias1)->(DbSkip())
    EndDo

    _oReport:Section(2):Finish()
Return

//+------------------------------------------------------------------------
Static Function MR34Print3(_cAlias2,_oReport)

    _oReport:Section(3):Init()
    (_cAlias2)->(DbGoTop())
        
    While !_oReport:Cancel() .And. (_cAlias2)->(!EOF())

        _oReport:IncMeter()

		If SubStr((_cAlias2)->CONTA,1,1) $ '3|4|5'
			_oReport:Section(3):Cell('SALDO'            ):SetBlock( {|| 0 })
			_oReport:Section(3):Cell('JANEIRO'          ):SetBlock( {|| (_cAlias2)->MOVJAN})
        	_oReport:Section(3):Cell('FEVEREIRO'        ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV})
        	_oReport:Section(3):Cell('MARCO'            ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR})
        	_oReport:Section(3):Cell('ABRIL'            ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR})
        	_oReport:Section(3):Cell('MAIO'             ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI})
        	_oReport:Section(3):Cell('JUNHO'            ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN})
        	_oReport:Section(3):Cell('JULHO'            ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL})
        	_oReport:Section(3):Cell('AGOSTO'           ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO})
        	_oReport:Section(3):Cell('SETEMBRO'         ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET})
        	_oReport:Section(3):Cell('OUTUBRO'          ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT})
        	_oReport:Section(3):Cell('NOVEMBRO'         ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT + (_cAlias2)->MOVNOV})
        	_oReport:Section(3):Cell('DEZEMBRO'         ):SetBlock( {|| (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT + (_cAlias2)->MOVNOV + (_cAlias2)->MOVDEZ})
		Else
			_oReport:Section(3):Cell('SALDO'            ):SetBlock( {||(_cAlias2)->SALDO })
			_oReport:Section(3):Cell('JANEIRO'          ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN})
        	_oReport:Section(3):Cell('FEVEREIRO'        ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV})
        	_oReport:Section(3):Cell('MARCO'            ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR})
        	_oReport:Section(3):Cell('ABRIL'            ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR})
        	_oReport:Section(3):Cell('MAIO'             ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI})
        	_oReport:Section(3):Cell('JUNHO'            ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN})
        	_oReport:Section(3):Cell('JULHO'            ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL})
        	_oReport:Section(3):Cell('AGOSTO'           ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO})
        	_oReport:Section(3):Cell('SETEMBRO'         ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET})
        	_oReport:Section(3):Cell('OUTUBRO'          ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT})
        	_oReport:Section(3):Cell('NOVEMBRO'         ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT + (_cAlias2)->MOVNOV})
        	_oReport:Section(3):Cell('DEZEMBRO'         ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN + (_cAlias2)->MOVFEV + (_cAlias2)->MOVMAR + (_cAlias2)->MOVABR + (_cAlias2)->MOVMAI + (_cAlias2)->MOVJUN + (_cAlias2)->MOVJUL + (_cAlias2)->MOVAGO + (_cAlias2)->MOVSET + (_cAlias2)->MOVOUT + (_cAlias2)->MOVNOV + (_cAlias2)->MOVDEZ})
		Endif
        _oReport:Section(3):PrintLine()

        (_cAlias2)->(DbSkip())
    EndDo

    _oReport:Section(3):Finish()
Return

//+------------------------------------------------------------------------
Static Function MR34GetCCC(_cAlias1,_nTotal)
    Local _cJanIni      := AllTrim(MV_PAR01)+'0101'
    Local _cJanFin      := AllTrim(MV_PAR01)+'0131'

    Local _cFevIni      := AllTrim(MV_PAR01)+'0201'
    Local _cFevFin      := AllTrim(MV_PAR01)+'0229'

    Local _cMarIni      := AllTrim(MV_PAR01)+'0301'
    Local _cMarFin      := AllTrim(MV_PAR01)+'0331'

    Local _cAbrIni      := AllTrim(MV_PAR01)+'0401'
    Local _cAbrFin      := AllTrim(MV_PAR01)+'0430'

    Local _cMaiIni      := AllTrim(MV_PAR01)+'0501'
    Local _cMaiFin      := AllTrim(MV_PAR01)+'0531'

    Local _cJunIni      := AllTrim(MV_PAR01)+'0601'
    Local _cJunFin      := AllTrim(MV_PAR01)+'0630'

    Local _cJulIni      := AllTrim(MV_PAR01)+'0701'
    Local _cJulFin      := AllTrim(MV_PAR01)+'0731'

    Local _cAgoIni      := AllTrim(MV_PAR01)+'0801'
    Local _cAgoFin      := AllTrim(MV_PAR01)+'0831'

    Local _cSetIni      := AllTrim(MV_PAR01)+'0901'
    Local _cSetFin      := AllTrim(MV_PAR01)+'0930'

    Local _cOutIni      := AllTrim(MV_PAR01)+'1001'
    Local _cOutFin      := AllTrim(MV_PAR01)+'1031'

    Local _cNovIni      := AllTrim(MV_PAR01)+'1101'
    Local _cNovFin      := AllTrim(MV_PAR01)+'1130'

    Local _cDezIni      := AllTrim(MV_PAR01)+'1201'
    Local _cDezFin      := AllTrim(MV_PAR01)+'1231'

    BeginSQL Alias _cAlias1
        SELECT   DISTINCT CQ2.CQ2_CONTA                 AS CONTA
                ,SUBSTRING(CQ2.CQ2_CCUSTO,1,1)          AS TIPO
                ,CT1.CT1_DESC01                         AS CONTA_DESC
                ,CQ2.CQ2_CCUSTO                         AS CCUSTO
                ,CTT_DESC01                             AS CCUSTO_DESC
                ,JANEIRO.SALDO                          AS JANEIRO
                ,FEVEREIRO.SALDO                        AS FEVEREIRO
                ,MARCO.SALDO                            AS MARCO
                ,ABRIL.SALDO                            AS ABRIL
                ,MAIO.SALDO                             AS MAIO
                ,JUNHO.SALDO                            AS JUNHO
                ,JULHO.SALDO                            AS JULHO
                ,AGOSTO.SALDO                           AS AGOSTO
                ,SETEMBRO.SALDO                         AS SETEMBRO
                ,OUTUBRO.SALDO                          AS OUTUBRO
                ,NOVEMBRO.SALDO                         AS NOVEMBRO
                ,DEZEMBRO.SALDO                         AS DEZEMBRO
        FROM %Table:CQ2% CQ2
        LEFT JOIN %Table:CT1% CT1 ON CT1.%NotDel% AND CT1.CT1_CONTA = CQ2.CQ2_CONTA
        LEFT JOIN %Table:CTT% CTT ON CTT.%NotDel% AND CTT.CTT_CUSTO = CQ2.CQ2_CCUSTO
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cJanFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JANEIRO ON CQ2.CQ2_CCUSTO = JANEIRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JANEIRO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cFevIni% AND %Exp:_cFevFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) FEVEREIRO ON CQ2.CQ2_CCUSTO = FEVEREIRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = FEVEREIRO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cMarIni% AND %Exp:_cMarFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) MARCO ON CQ2.CQ2_CCUSTO = MARCO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = MARCO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cAbrIni% AND %Exp:_cAbrFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) ABRIL ON CQ2.CQ2_CCUSTO = ABRIL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = ABRIL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cMaiIni% AND %Exp:_cMaiFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) MAIO ON CQ2.CQ2_CCUSTO = MAIO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = MAIO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJunIni% AND %Exp:_cJunFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JUNHO ON CQ2.CQ2_CCUSTO = JUNHO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JUNHO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJulIni% AND %Exp:_cJulFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JULHO ON CQ2.CQ2_CCUSTO = JULHO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JULHO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cAgoIni% AND %Exp:_cAgoFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) AGOSTO ON CQ2.CQ2_CCUSTO = AGOSTO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = AGOSTO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cSetIni% AND %Exp:_cSetFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) SETEMBRO ON CQ2.CQ2_CCUSTO = SETEMBRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = SETEMBRO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cOutIni% AND %Exp:_cOutFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) OUTUBRO ON CQ2.CQ2_CCUSTO = OUTUBRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = OUTUBRO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cNovIni% AND %Exp:_cNovFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) NOVEMBRO ON CQ2.CQ2_CCUSTO = NOVEMBRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = NOVEMBRO.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cDezIni% AND %Exp:_cDezFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) DEZEMBRO ON CQ2.CQ2_CCUSTO = DEZEMBRO.CQ2_CCUSTO AND CQ2.CQ2_CONTA = DEZEMBRO.CQ2_CONTA
        WHERE   CQ2.%NotDel%
            AND CQ2.CQ2_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cDezFin%
        ORDER BY  2, 3, 5
    EndSql

    //+-------------------------------------------
    // Atualiza regua de processamento
    //+-------------------------------------------
    (_cAlias1)->( dbEval( {|| _nTotal++ } ) )
Return

//+------------------------------------------------------------------------
Static Function MR34GetSCC(_cAlias2,_nTotal)
    Local _cJanIni      := AllTrim(MV_PAR01)+'0101'
    Local _cJanFin      := AllTrim(MV_PAR01)+'0131'

    Local _cFevIni      := AllTrim(MV_PAR01)+'0201'
    Local _cFevFin      := AllTrim(MV_PAR01)+'0229'

    Local _cMarIni      := AllTrim(MV_PAR01)+'0301'
    Local _cMarFin      := AllTrim(MV_PAR01)+'0331'

    Local _cAbrIni      := AllTrim(MV_PAR01)+'0401'
    Local _cAbrFin      := AllTrim(MV_PAR01)+'0430'

    Local _cMaiIni      := AllTrim(MV_PAR01)+'0501'
    Local _cMaiFin      := AllTrim(MV_PAR01)+'0531'

    Local _cJunIni      := AllTrim(MV_PAR01)+'0601'
    Local _cJunFin      := AllTrim(MV_PAR01)+'0630'

    Local _cJulIni      := AllTrim(MV_PAR01)+'0701'
    Local _cJulFin      := AllTrim(MV_PAR01)+'0731'

    Local _cAgoIni      := AllTrim(MV_PAR01)+'0801'
    Local _cAgoFin      := AllTrim(MV_PAR01)+'0831'

    Local _cSetIni      := AllTrim(MV_PAR01)+'0901'
    Local _cSetFin      := AllTrim(MV_PAR01)+'0930'

    Local _cOutIni      := AllTrim(MV_PAR01)+'1001'
    Local _cOutFin      := AllTrim(MV_PAR01)+'1031'

    Local _cNovIni      := AllTrim(MV_PAR01)+'1101'
    Local _cNovFin      := AllTrim(MV_PAR01)+'1130'

    Local _cDezIni      := AllTrim(MV_PAR01)+'1201'
    Local _cDezFin      := AllTrim(MV_PAR01)+'1231'

    BeginSql Alias _cAlias2
        SELECT   DISTINCT
                 CQ0.CQ0_CONTA          		AS CONTA
                ,CT1_DESC01             		AS CONTA_DESC
                ,SALDO.SALDO           			AS SALDO
                ,JANEIRO.MOVI           		AS MOVJAN
                ,FEVEREIRO.MOVI         		AS MOVFEV
                ,MARCO.MOVI             		AS MOVMAR
                ,ABRIL.MOVI             		AS MOVABR
                ,MAIO.MOVI              		AS MOVMAI
                ,JUNHO.MOVI             		AS MOVJUN
                ,JULHO.MOVI             		AS MOVJUL
                ,AGOSTO.MOVI            		AS MOVAGO
                ,SETEMBRO.MOVI          		AS MOVSET
                ,OUTUBRO.MOVI           		AS MOVOUT
                ,NOVEMBRO.MOVI          		AS MOVNOV
                ,DEZEMBRO.MOVI          		AS MOVDEZ
        FROM %Table:CQ0% CQ0
        LEFT JOIN %Table:CT1% CT1 ON CT1.%NotDel% AND CT1_CONTA = CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS SALDO FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA < %Exp:_cJanIni% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) SALDO ON SALDO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cJanFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) JANEIRO ON JANEIRO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cFevIni% AND %Exp:_cFevFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) FEVEREIRO ON FEVEREIRO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cMarIni% AND %Exp:_cMarFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) MARCO ON MARCO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cAbrIni% AND %Exp:_cAbrFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) ABRIL ON ABRIL.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cMaiIni% AND %Exp:_cMaiFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) MAIO ON MAIO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cJunIni% AND %Exp:_cJunFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) JUNHO ON JUNHO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cJulIni% AND %Exp:_cJulFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) JULHO ON JULHO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cAgoIni% AND %Exp:_cAgoFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) AGOSTO ON AGOSTO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cSetIni% AND %Exp:_cSetFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) SETEMBRO ON SETEMBRO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cOutIni% AND %Exp:_cOutFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) OUTUBRO ON OUTUBRO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cNovIni% AND %Exp:_cNovFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) NOVEMBRO ON NOVEMBRO.CQ0_CONTA = CQ0.CQ0_CONTA
        LEFT JOIN (SELECT CQ0_CONTA,SUM(CQ0_CREDIT) - SUM(CQ0_DEBITO) AS MOVI FROM %Table:CQ0% CQ0 WHERE CQ0.%NotDel% AND CQ0_DATA BETWEEN %Exp:_cDezIni% AND %Exp:_cDezFin% AND CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ0_CONTA) DEZEMBRO ON DEZEMBRO.CQ0_CONTA = CQ0.CQ0_CONTA
        WHERE   CQ0.%NotDel%
            AND CQ0.CQ0_DATA <= %Exp:_cDezFin%
            AND CQ0.CQ0_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
        ORDER BY  1
    EndSql

    //+-------------------------------------------
    // Atualiza regua de processamento
    //+-------------------------------------------
    (_cAlias2)->( dbEval( {|| _nTotal++ } ) )
    
Return

//+------------------------------------------------------------------------
Static Function MR34PutSX1(_cPerg)
    Local _aAreaSX1     := SX1->(GetArea())

    SX1->(DbGoTop())
    SX1->(DbSetOrder(1))

    If !SX1->(DbSeek(_cPerg))
        PutSX1(_cPerg,'01','Ano ?'                  ,'Ano ?'                    ,'Ano ?'                ,'mv_ch1','C',04,0, ,'G','','   ',,,'mv_par01',,,,Space(4))
        PutSX1(_cPerg,'02','Filial De ?'            ,'Filial De ?'              ,'Filial De ?'          ,'mv_ch2','C',02,0, ,'G','','   ',,,'mv_par02',,,,Space(2))
        PutSX1(_cPerg,'03','Filial Ate ?'           ,'Filial Ate ?'             ,'Filial Ate ?'         ,'mv_ch3','C',02,0, ,'G','','   ',,,'mv_par03',,,,Space(2))
    EndIf

    RestArea(_aAreaSX1)
Return
