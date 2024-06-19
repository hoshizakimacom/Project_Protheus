#Include 'Protheus.ch'

//+------------------------------------------------------------------------
//  Relat�rio de Comparativo cont�bil
//+------------------------------------------------------------------------
User Function M34R01()
//    Local _oReport      := Nil
Local _cPerg        := 'M34R01'

MR34PutSX1(_cPerg)

If Pergunte(_cPerg, .T.)
        _oReport := MR34RepDef(_oReport, _cPerg)
        _oReport:PrintDialog()
EndIf
 
   // U_M34R03()
Return

//+------------------------------------------------------------------------
Static Function MR34RepDef(_oReport, _cPerg)
    Local _cTitle       := 'Relat�rio Mensal de Conta Cont�bil'
    Local _cHelp        := 'Permite gerar relat�rio mensal das contas cont�beis'
    Local _cAlias1      := GetNextAlias()
    Local _cAlias2      := GetNextAlias()
    Local _oCCCusto     := Nil
    Local _oCCCustoA    := Nil
    Local _oSCCustoA    := Nil

    _oReport    := TReport():New('M34R01   ',_cTitle,_cPerg,{|_oReport| MR34Print(_oReport,_cAlias1,_cAlias2)},_cHelp)
    _oReport:SetMeter(3)

    //+-------------------------------------------
    //| Centro de Custo     - Sim
    //| Acumulado           - N�o
    //+-------------------------------------------
    _oCCCusto := TRSection():New(_oReport,'Com CCusto',{_cAlias1})

    TRCell():New(_oCCCusto,'TIPO'               , _cAlias1)
    TRCell():New(_oCCCusto,'CONTA'              , _cAlias1)
    TRCell():New(_oCCCusto,'CONTA_DESC'     , _cAlias1)
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
    TRCell():New(_oCCCustoA,'FEVEREIRO'         , _cAlias1)
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
    //| Centro de Custo     - N�o
    //| Acumulado           - N�o
    //+-------------------------------------------
    _oSCCustoA := TRSection():New(_oReport,'Sem CCusto Acum',{_cAlias2})

    TRCell():New(_oSCCustoA,'CONTA'             , _cAlias2)
    TRCell():New(_oSCCustoA,'CONTA_DESC'        , _cAlias2)
    TRCell():New(_oSCCustoA,'SALDO'             , _cAlias2)
    TRCell():New(_oSCCustoA,'JANEIRO'           , _cAlias2)
    TRCell():New(_oSCCustoA,'FEVEREIRO'         , _cAlias2)
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
        _oReport:Section(1):Cell('SETEMBRO'                 ):SetBlock( {||(_cAlias1)->SETEMBRO })
        _oReport:Section(1):Cell('OUTUBRO'                  ):SetBlock( {||(_cAlias1)->OUTUBRO })
        _oReport:Section(1):Cell('NOVEMBRO'                 ):SetBlock( {||(_cAlias1)->NOVEMBRO })
        _oReport:Section(1):Cell('DEZEMBRO'                 ):SetBlock( {||(_cAlias1)->DEZEMBRO })

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

        _oReport:Section(2):Cell('TIPO'              ):SetBlock( {||(_cAlias1)->TIPO })
        _oReport:Section(2):Cell('CONTA'             ):SetBlock( {||(_cAlias1)->CONTA })
        _oReport:Section(2):Cell('CONTA_DESC'        ):SetBlock( {||(_cAlias1)->CONTA_DESC })
        _oReport:Section(2):Cell('CCUSTO'            ):SetBlock( {||(_cAlias1)->CCUSTO })
        _oReport:Section(2):Cell('CCUSTO_DESC'       ):SetBlock( {||(_cAlias1)->CCUSTO_DESC })
        _oReport:Section(2):Cell('JANEIRO'           ):SetBlock( {||(_cAlias1)->JANEIRO })
        _oReport:Section(2):Cell('FEVEREIRO'         ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO })
        _oReport:Section(2):Cell('MARCO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO })
        _oReport:Section(2):Cell('ABRIL'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL })
        _oReport:Section(2):Cell('MAIO'              ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO })
        _oReport:Section(2):Cell('JUNHO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO })
        _oReport:Section(2):Cell('JULHO'             ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO })
        _oReport:Section(2):Cell('AGOSTO'            ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO })
        _oReport:Section(2):Cell('SETEMBRO'          ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO })
        _oReport:Section(2):Cell('OUTUBRO'           ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO })
        _oReport:Section(2):Cell('NOVEMBRO'          ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO + (_cAlias1)->NOVEMBRO })
        _oReport:Section(2):Cell('DEZEMBRO'          ):SetBlock( {||(_cAlias1)->JANEIRO + (_cAlias1)->FEVEREIRO + (_cAlias1)->MARCO + (_cAlias1)->ABRIL + (_cAlias1)->MAIO + (_cAlias1)->JUNHO + (_cAlias1)->JULHO + (_cAlias1)->AGOSTO + (_cAlias1)->SETEMBRO + (_cAlias1)->OUTUBRO + (_cAlias1)->NOVEMBRO + (_cAlias1)->DEZEMBRO })

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

        _oReport:Section(3):Cell('JANEIRO'          ):SetBlock( {||(_cAlias2)->SALDO + (_cAlias2)->MOVJAN})
        _oReport:Section(3):Cell('FEVEREIRO'        ):SetBlock( {||(_cAlias2)->SAFEV + (_cAlias2)->MOVFEV})
        _oReport:Section(3):Cell('MARCO'            ):SetBlock( {||(_cAlias2)->SAMAR + (_cAlias2)->MOVMAR})
        _oReport:Section(3):Cell('ABRIL'            ):SetBlock( {||(_cAlias2)->SAABR + (_cAlias2)->MOVABR})
        _oReport:Section(3):Cell('MAIO'             ):SetBlock( {||(_cAlias2)->SAMAI + (_cAlias2)->MOVMAI})
        _oReport:Section(3):Cell('JUNHO'            ):SetBlock( {||(_cAlias2)->SAJUN + (_cAlias2)->MOVJUN})
        _oReport:Section(3):Cell('JULHO'            ):SetBlock( {||(_cAlias2)->SAJUL + (_cAlias2)->MOVJUL})
        _oReport:Section(3):Cell('AGOSTO'           ):SetBlock( {||(_cAlias2)->SAAGO + (_cAlias2)->MOVAGO})
        _oReport:Section(3):Cell('SETEMBRO'         ):SetBlock( {||(_cAlias2)->SASET + (_cAlias2)->MOVSET})
        _oReport:Section(3):Cell('OUTUBRO'          ):SetBlock( {||(_cAlias2)->SAOUT + (_cAlias2)->MOVOUT})
        _oReport:Section(3):Cell('NOVEMBRO'         ):SetBlock( {||(_cAlias2)->SANOV + (_cAlias2)->MOVNOV})
        _oReport:Section(3):Cell('DEZEMBRO'         ):SetBlock( {||(_cAlias2)->SADEZ + (_cAlias2)->MOVDEZ})

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
        SELECT  DISTINCT  X.TIPO            AS TIPO
                    ,X.CT3_CONTA                AS CONTA
                    ,Y.CT1_DESC01               AS CONTA_DESC
                    ,X.CT3_CUSTO                AS CCUSTO
                    ,Z.CTT_DESC01               AS CCUSTO_DESC
                    ,JAN.SALDO              AS JANEIRO
                    ,FEV.SALDO              AS FEVEREIRO
                    ,MAR.SALDO              AS MARCO
                    ,ABR.SALDO              AS ABRIL
                    ,MAI.SALDO              AS MAIO
                    ,JUN.SALDO              AS JUNHO
                    ,JUL.SALDO              AS JULHO
                    ,AGO.SALDO              AS AGOSTO
                    ,SETE.SALDO                 AS SETEMBRO
                    ,OUT.SALDO              AS OUTUBRO
                    ,NOV.SALDO              AS NOVEMBRO
                    ,DEZ.SALDO              AS DEZEMBRO
            FROM        (SELECT DISTINCT    CT3_CUSTO   ,CT3_CONTA  ,SUBSTRING(CT3_CUSTO,1,1) TIPO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                        ) X
            LEFT JOIN (SELECT CT1_CONTA,CT1_DESC01
                            FROM %Table:CT1% WHERE  %NotDel%
                        ) Y ON X.CT3_CONTA = Y.CT1_CONTA
            LEFT JOIN (SELECT CTT_CUSTO,CTT_DESC01
                            FROM %Table:CTT% WHERE  %NotDel%
                        ) Z ON X.CT3_CUSTO = Z.CTT_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cJanFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) JAN ON X.CT3_CONTA = JAN.CT3_CONTA AND X.CT3_CUSTO = JAN.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cFevIni% AND %Exp:_cFevFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) FEV ON X.CT3_CONTA = FEV.CT3_CONTA AND X.CT3_CUSTO = FEV.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cMarIni% AND %Exp:_cMarFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) MAR ON X.CT3_CONTA = MAR.CT3_CONTA AND X.CT3_CUSTO = MAR.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cAbrIni% AND %Exp:_cAbrFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) ABR ON X.CT3_CONTA = ABR.CT3_CONTA AND X.CT3_CUSTO = ABR.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cMaiIni% AND %Exp:_cMaiFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) MAI ON X.CT3_CONTA = MAI.CT3_CONTA AND X.CT3_CUSTO = MAI.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cJunIni% AND %Exp:_cJunFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) JUN ON X.CT3_CONTA = JUN.CT3_CONTA AND X.CT3_CUSTO = JUN.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cJulIni% AND %Exp:_cJulFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) JUL ON X.CT3_CONTA = JUL.CT3_CONTA AND X.CT3_CUSTO = JUL.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cAgoIni% AND %Exp:_cAgoFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) AGO ON X.CT3_CONTA = AGO.CT3_CONTA AND X.CT3_CUSTO = AGO.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cSetIni% AND %Exp:_cSetFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) SETE ON X.CT3_CONTA = SETE.CT3_CONTA AND X.CT3_CUSTO = SETE.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cOutIni% AND %Exp:_cOutFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) OUT ON X.CT3_CONTA = OUT.CT3_CONTA AND X.CT3_CUSTO = OUT.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cNovIni% AND %Exp:_cNovFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) NOV ON X.CT3_CONTA = NOV.CT3_CONTA AND X.CT3_CUSTO = NOV.CT3_CUSTO
            LEFT JOIN  (SELECT CT3_CUSTO,CT3_CONTA,SUM(CT3_CREDIT) - SUM(CT3_DEBITO) SALDO
                            FROM %Table:CT3% WHERE  %NotDel% AND CT3_DATA BETWEEN %Exp:_cDezIni% AND %Exp:_cDezFin% AND CT3_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                            GROUP BY CT3_CUSTO, CT3_CONTA
                        ) DEZ ON X.CT3_CONTA = DEZ.CT3_CONTA AND X.CT3_CUSTO = DEZ.CT3_CUSTO
        ORDER BY  X.TIPO, X.CT3_CONTA, X.CT3_CUSTO
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
        SELECT   X.CT7_CONTA                                AS CONTA
                    ,Y.CT1_DESC01                               AS CONTA_DESC
                    ,JAN1.SALDOANT                          AS SALDO
                    ,JAN2.MOVIMENTO                             AS MOVJAN
                    ,JAN1.SALDOANT + JAN2.MOVIMENTO         AS JANEIRO
                    ,FEV1.SALDOANT                          AS SAFEV
                    ,FEV2.MOVIMENTO                             AS MOVFEV
                    ,FEV1.SALDOANT + FEV2.MOVIMENTO         AS FEVEREIRO
                    ,MAR1.SALDOANT                          AS SAMAR
                    ,MAR2.MOVIMENTO                             AS MOVMAR
                    ,MAR1.SALDOANT + MAR2.MOVIMENTO         AS MARCO
                    ,ABR1.SALDOANT                          AS SAABR
                    ,ABR2.MOVIMENTO                             AS MOVABR
                    ,ABR1.SALDOANT + ABR2.MOVIMENTO         AS ABRIL
                    ,MAI1.SALDOANT                          AS SAMAI
                    ,MAI2.MOVIMENTO                             AS MOVMAI
                    ,MAI1.SALDOANT + MAI2.MOVIMENTO         AS MAIO
                    ,JUN1.SALDOANT                          AS SAJUN
                    ,JUN2.MOVIMENTO                             AS MOVJUN
                    ,JUN1.SALDOANT + JUN2.MOVIMENTO         AS JUNHO
                    ,JUL1.SALDOANT                          AS SAJUL
                    ,JUL2.MOVIMENTO                             AS MOVJUL
                    ,JUL1.SALDOANT + JUL2.MOVIMENTO         AS JULHO
                    ,AGO1.SALDOANT                          AS SAAGO
                    ,AGO2.MOVIMENTO                             AS MOVAGO
                    ,AGO1.SALDOANT + AGO2.MOVIMENTO         AS AGOSTO
                    ,SET1.SALDOANT                          AS SASET
                    ,SET2.MOVIMENTO                             AS MOVSET
                    ,SET1.SALDOANT + SET2.MOVIMENTO         AS SETEMBRO
                    ,OUT1.SALDOANT                          AS SAOUT
                    ,OUT2.MOVIMENTO                             AS MOVOUT
                    ,OUT1.SALDOANT + OUT2.MOVIMENTO         AS OUTUBRO
                    ,NOV1.SALDOANT                          AS SANOV
                    ,NOV2.MOVIMENTO                             AS MOVNOV
                    ,NOV1.SALDOANT + NOV2.MOVIMENTO         AS NOVEMBRO
                    ,DEZ1.SALDOANT                          AS SADEZ
                    ,DEZ2.MOVIMENTO                             AS MOVDEZ
                    ,DEZ1.SALDOANT + DEZ2.MOVIMENTO         AS DEZEMBRO
                    ,' ' A
            FROM (SELECT DISTINCT CT7_CONTA
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% )  X
            INNER JOIN (SELECT CT1_CONTA,CT1_DESC01
                    FROM %Table:CT1% WHERE  %NotDel% )  Y ON X.CT7_CONTA = Y.CT1_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cJanIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JAN1 ON X.CT7_CONTA = JAN1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cJanFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JAN2 ON X.CT7_CONTA = JAN2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cFevIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  FEV1 ON X.CT7_CONTA = FEV1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cFevIni% AND %Exp:_cFevFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  FEV2 ON X.CT7_CONTA = FEV2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cMarIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  MAR1 ON X.CT7_CONTA = MAR1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cMarIni% AND %Exp:_cMarFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  MAR2 ON X.CT7_CONTA = MAR2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cAbrIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  ABR1 ON X.CT7_CONTA = ABR1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cAbrIni% AND %Exp:_cAbrFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  ABR2 ON X.CT7_CONTA = ABR2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cMaiIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  MAI1 ON X.CT7_CONTA = MAI1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cMaiIni% AND %Exp:_cMaiFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  MAI2 ON X.CT7_CONTA = MAI2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cJunIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JUN1 ON X.CT7_CONTA = JUN1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cJunIni% AND %Exp:_cJunFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JUN2 ON X.CT7_CONTA = JUN2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cJulIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JUL1 ON X.CT7_CONTA = JUL1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cJulIni% AND %Exp:_cJulFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  JUL2 ON X.CT7_CONTA = JUL2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cAgoIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  AGO1 ON X.CT7_CONTA = AGO1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cAgoIni% AND %Exp:_cAgoFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  AGO2 ON X.CT7_CONTA = AGO2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cSetIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  SET1 ON X.CT7_CONTA = SET1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cSetIni% AND %Exp:_cSetFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  SET2 ON X.CT7_CONTA = SET2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cOutIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  OUT1 ON X.CT7_CONTA = OUT1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cOutIni% AND %Exp:_cOutFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  OUT2 ON X.CT7_CONTA = OUT2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cNovIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  NOV1 ON X.CT7_CONTA = NOV1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cNovIni% AND %Exp:_cNovFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  NOV2 ON X.CT7_CONTA = NOV2.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) SALDOANT
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA < %Exp:_cDezIni% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  DEZ1 ON X.CT7_CONTA = DEZ1.CT7_CONTA
            LEFT JOIN (SELECT CT7_CONTA,SUM(CT7_DEBITO) DEBITO,SUM(CT7_CREDIT) CREDITO,SUM(CT7_CREDIT) - SUM(CT7_DEBITO) MOVIMENTO
                    FROM %Table:CT7% WHERE  %NotDel% AND CT7_DATA BETWEEN %Exp:_cDezIni% AND %Exp:_cDezFin% AND CT7_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                    GROUP BY CT7_CONTA )  DEZ2 ON X.CT7_CONTA = DEZ2.CT7_CONTA
        ORDER BY  X.CT7_CONTA
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
