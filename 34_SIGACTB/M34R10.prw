#Include 'Protheus.ch'

//+------------------------------------------------------------------------
//  Relatorio de Comparativo contabil
//+------------------------------------------------------------------------
User Function M34R10()

    Local _oReport      := Nil
    Local _cPerg        := 'M34R10   '
    Local cDepto1 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO1")
    Local cDepto2 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO2")
    Local cDepto3 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO3")
    //Local cPar := GetMV("MV_XBUDGET")

    If (__cUserID $ GetMV("MV_XBUDGET") ) .or. !Empty(cDepto1) .or. !Empty(cDepto2) .or. !Empty(cDepto3)
        
        MR34PutSX1(_cPerg)

        If FindFunction('TRepInUse') .And. TRepInUse(.F.)   //verifica se relatorios personalizaveis esta disponivel
            If Pergunte(_cPerg, .T.)
                _oReport := MR34RepDef(_oReport, _cPerg)
                _oReport:PrintDialog()
            EndIf
        EndIf
    Else
        MsgAlert("Usuário não possui acesso a nenhum departamento!", "Atenção!!!")    
    EndIf   

Return

//+------------------------------------------------------------------------
Static Function MR34RepDef(_oReport, _cPerg)
    Local _cTitle       := 'Relatorio Mensal de Conta Contabil'
    Local _cHelp        := 'Permite gerar relatorio mensal das contas contabeis'
    Local _cAlias1      := GetNextAlias()
    //Local _cAlias2      := GetNextAlias()
    Local _oCCCusto     := Nil
    //Local _oCCCustoA    := Nil
    //Local _oSCCustoA    := Nil

    //_oReport    := TReport():New('M34R03   ',_cTitle,_cPerg,{|_oReport| MR34Print(_oReport,_cAlias1,_cAlias2)},_cHelp)
    _oReport    := TReport():New('M34R10   ',_cTitle,_cPerg,{|_oReport| MR34Print(_oReport,_cAlias1)},_cHelp)
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
    TRCell():New(_oCCCusto,'TOTAL_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'JAN_REAL'           , _cAlias1)
    TRCell():New(_oCCCusto,'JAN_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'JAN_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'FEV_REAL'          , _cAlias1)
    TRCell():New(_oCCCusto,'FEV_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'FEV_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'MAR_REAL'              , _cAlias1)
    TRCell():New(_oCCCusto,'MAR_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'MAR_VAR'            , _cAlias1)    
    TRCell():New(_oCCCusto,'ABR_REAL'              , _cAlias1)
    TRCell():New(_oCCCusto,'ABR_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'ABR_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'MAI_REAL'               , _cAlias1)
    TRCell():New(_oCCCusto,'MAI_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'MAI_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'JUN_REAL'              , _cAlias1)
    TRCell():New(_oCCCusto,'JUN_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'JUN_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'JUL_REAL'              , _cAlias1)
    TRCell():New(_oCCCusto,'JUL_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'JUL_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'AGO_REAL'             , _cAlias1)
    TRCell():New(_oCCCusto,'AGO_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'AGO_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'SET_REAL'           , _cAlias1)
    TRCell():New(_oCCCusto,'SET_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'SET_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'OUT_REAL'            , _cAlias1)
    TRCell():New(_oCCCusto,'OUT_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'OUT_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'NOV_REAL'           , _cAlias1)
    TRCell():New(_oCCCusto,'NOV_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'NOV_VAR'            , _cAlias1)
    TRCell():New(_oCCCusto,'DEZ_REAL'           , _cAlias1)
    TRCell():New(_oCCCusto,'DEZ_BUDGET'       , _cAlias1)
    TRCell():New(_oCCCusto,'DEZ_VAR'            , _cAlias1)

    _oCCCusto:oReport:cFontBody                 := 'Calibri'
    _oCCCusto:oReport:nFontBody                 := 11

Return(_oReport)

//+------------------------------------------------------------------------
Static Function MR34Print(_oReport,_cAlias1)

    Local _nTotal           := 0

    //+-------------------------------------------
    //| Inicio da impressao
    //+-------------------------------------------
    MR34GetCCC(_cAlias1,@_nTotal)  

    _oReport:SetMeter(_nTotal)
    _oReport:IncMeter()

    MR34Print1(_cAlias1,_oReport)       // Centro de Custo (S) | Acumulado (N)
        
    (_cAlias1)->(DbCloseArea())

return

//+------------------------------------------------------------------------
Static Function MR34Print1(_cAlias1,_oReport)

    //Local cPar := GetMV("MV_XBUDGET")
    Local cDepto1 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO1")
    Local cDepto2 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO2")
    Local cDepto3 := Posicione("SZC",1, xFilial("SZC") + __cUserID , "ZC_DEPTO3")

    _oReport:IncMeter()

    _oReport:Section(1):Init()
    (_cAlias1)->(DbGoTop())

    While !_oReport:Cancel() .And. (_cAlias1)->(!EOF())
        
      If __cUserID $ GetMV("MV_XBUDGET")

            _oReport:Section(1):Cell('TIPO'                     ):SetBlock( {||(_cAlias1)->TIPO })
            _oReport:Section(1):Cell('CONTA'                    ):SetBlock( {||(_cAlias1)->CONTA })
            _oReport:Section(1):Cell('CONTA_DESC'               ):SetBlock( {||(_cAlias1)->CONTA_DESC })
            _oReport:Section(1):Cell('CCUSTO'                   ):SetBlock( {||(_cAlias1)->CCUSTO })
            _oReport:Section(1):Cell('CCUSTO_DESC'              ):SetBlock( {||(_cAlias1)->CCUSTO_DESC })
            _oReport:Section(1):Cell('TOTAL_BUDGET'             ):SetBlock( {||(_cAlias1)->TOTAL_PREV })
            _oReport:Section(1):Cell('JAN_REAL'                 ):SetBlock( {||(_cAlias1)->JAN_REAL })
            _oReport:Section(1):Cell('JAN_BUDGET'               ):SetBlock( {||(_cAlias1)->JAN_PREV })
            _oReport:Section(1):Cell('JAN_VAR'                  ):SetBlock( {||(_cAlias1)->JAN_VAR })
            _oReport:Section(1):Cell('FEV_REAL'                 ):SetBlock( {||(_cAlias1)->FEV_REAL })
            _oReport:Section(1):Cell('FEV_BUDGET'               ):SetBlock( {||(_cAlias1)->FEV_PREV })
            _oReport:Section(1):Cell('FEV_VAR'                  ):SetBlock( {||(_cAlias1)->FEV_VAR })
            _oReport:Section(1):Cell('MAR_REAL'                 ):SetBlock( {||(_cAlias1)->MAR_REAL })
            _oReport:Section(1):Cell('MAR_BUDGET'               ):SetBlock( {||(_cAlias1)->MAR_PREV })
            _oReport:Section(1):Cell('MAR_VAR'                  ):SetBlock( {||(_cAlias1)->MAR_VAR })
            _oReport:Section(1):Cell('ABR_REAL'                 ):SetBlock( {||(_cAlias1)->ABR_REAL })
            _oReport:Section(1):Cell('ABR_BUDGET'               ):SetBlock( {||(_cAlias1)->ABR_PREV })
            _oReport:Section(1):Cell('ABR_VAR'     ):SetBlock( {||(_cAlias1)->ABR_VAR })
            _oReport:Section(1):Cell('MAI_REAL'    ):SetBlock( {||(_cAlias1)->MAI_REAL })
            _oReport:Section(1):Cell('MAI_BUDGET'  ):SetBlock( {||(_cAlias1)->MAI_PREV })
            _oReport:Section(1):Cell('MAI_VAR'     ):SetBlock( {||(_cAlias1)->MAI_VAR })
            _oReport:Section(1):Cell('JUN_REAL'    ):SetBlock( {||(_cAlias1)->JUN_REAL })
            _oReport:Section(1):Cell('JUN_BUDGET'  ):SetBlock( {||(_cAlias1)->JUN_PREV })
            _oReport:Section(1):Cell('JUN_VAR'     ):SetBlock( {||(_cAlias1)->JUN_VAR })
            _oReport:Section(1):Cell('JUL_REAL'    ):SetBlock( {||(_cAlias1)->JUL_REAL })
            _oReport:Section(1):Cell('JUL_BUDGET'  ):SetBlock( {||(_cAlias1)->JUL_PREV })
            _oReport:Section(1):Cell('JUL_VAR'     ):SetBlock( {||(_cAlias1)->JUL_VAR })
            _oReport:Section(1):Cell('AGO_REAL'    ):SetBlock( {||(_cAlias1)->AGO_REAL })
            _oReport:Section(1):Cell('AGO_BUDGET'  ):SetBlock( {||(_cAlias1)->AGO_PREV })
            _oReport:Section(1):Cell('AGO_VAR'     ):SetBlock( {||(_cAlias1)->AGO_VAR })
            _oReport:Section(1):Cell('SET_REAL'    ):SetBlock( {||(_cAlias1)->SET_REAL })
            _oReport:Section(1):Cell('SET_BUDGET'  ):SetBlock( {||(_cAlias1)->SET_PREV })
            _oReport:Section(1):Cell('SET_VAR'     ):SetBlock( {||(_cAlias1)->SET_VAR })
            _oReport:Section(1):Cell('OUT_REAL'    ):SetBlock( {||(_cAlias1)->OUT_REAL })
            _oReport:Section(1):Cell('OUT_BUDGET'  ):SetBlock( {||(_cAlias1)->OUT_PREV })
            _oReport:Section(1):Cell('OUT_VAR'     ):SetBlock( {||(_cAlias1)->OUT_VAR })
            _oReport:Section(1):Cell('NOV_REAL'    ):SetBlock( {||(_cAlias1)->NOV_REAL })
            _oReport:Section(1):Cell('NOV_BUDGET'  ):SetBlock( {||(_cAlias1)->NOV_PREV })
            _oReport:Section(1):Cell('NOV_VAR'     ):SetBlock( {||(_cAlias1)->NOV_VAR })
            _oReport:Section(1):Cell('DEZ_REAL'    ):SetBlock( {||(_cAlias1)->DEZ_REAL })
            _oReport:Section(1):Cell('DEZ_BUDGET'  ):SetBlock( {||(_cAlias1)->DEZ_PREV })
            _oReport:Section(1):Cell('DEZ_VAR'     ):SetBlock( {||(_cAlias1)->DEZ_VAR })

            _oReport:Section(1):PrintLine()

            (_cAlias1)->(DbSkip())

        ElseIf  !Empty((_cAlias1)->CTT_XDEPTO) .AND. (ALLTRIM((_cAlias1)->CTT_XDEPTO) == ALLTRIM(cDepto1) .OR. ALLTRIM((_cAlias1)->CTT_XDEPTO) == ALLTRIM(cDepto2) .OR. ALLTRIM((_cAlias1)->CTT_XDEPTO) == ALLTRIM(cDepto3))

            _oReport:Section(1):Cell('TIPO'                     ):SetBlock( {||(_cAlias1)->TIPO })
            _oReport:Section(1):Cell('CONTA'                    ):SetBlock( {||(_cAlias1)->CONTA })
            _oReport:Section(1):Cell('CONTA_DESC'               ):SetBlock( {||(_cAlias1)->CONTA_DESC })
            _oReport:Section(1):Cell('CCUSTO'                   ):SetBlock( {||(_cAlias1)->CCUSTO })
            _oReport:Section(1):Cell('CCUSTO_DESC'              ):SetBlock( {||(_cAlias1)->CCUSTO_DESC })
            _oReport:Section(1):Cell('TOTAL_BUDGET'             ):SetBlock( {||(_cAlias1)->TOTAL_PREV })
            _oReport:Section(1):Cell('JAN_REAL'                 ):SetBlock( {||(_cAlias1)->JAN_REAL })
            _oReport:Section(1):Cell('JAN_BUDGET'               ):SetBlock( {||(_cAlias1)->JAN_PREV })
            _oReport:Section(1):Cell('JAN_VAR'                  ):SetBlock( {||(_cAlias1)->JAN_VAR })
            _oReport:Section(1):Cell('FEV_REAL'                 ):SetBlock( {||(_cAlias1)->FEV_REAL })
            _oReport:Section(1):Cell('FEV_BUDGET'               ):SetBlock( {||(_cAlias1)->FEV_PREV })
            _oReport:Section(1):Cell('FEV_VAR'                  ):SetBlock( {||(_cAlias1)->FEV_VAR })
            _oReport:Section(1):Cell('MAR_REAL'                 ):SetBlock( {||(_cAlias1)->MAR_REAL })
            _oReport:Section(1):Cell('MAR_BUDGET'               ):SetBlock( {||(_cAlias1)->MAR_PREV })
            _oReport:Section(1):Cell('MAR_VAR'                  ):SetBlock( {||(_cAlias1)->MAR_VAR })
            _oReport:Section(1):Cell('ABR_REAL'                 ):SetBlock( {||(_cAlias1)->ABR_REAL })
            _oReport:Section(1):Cell('ABR_BUDGET'               ):SetBlock( {||(_cAlias1)->ABR_PREV })
            _oReport:Section(1):Cell('ABR_VAR'                  ):SetBlock( {||(_cAlias1)->ABR_VAR })
            _oReport:Section(1):Cell('MAI_REAL'                 ):SetBlock( {||(_cAlias1)->MAI_REAL })
            _oReport:Section(1):Cell('MAI_BUDGET'               ):SetBlock( {||(_cAlias1)->MAI_PREV })
            _oReport:Section(1):Cell('MAI_VAR'                  ):SetBlock( {||(_cAlias1)->MAI_VAR })
            _oReport:Section(1):Cell('JUN_REAL'                 ):SetBlock( {||(_cAlias1)->JUN_REAL })
            _oReport:Section(1):Cell('JUN_BUDGET'               ):SetBlock( {||(_cAlias1)->JUN_PREV })
            _oReport:Section(1):Cell('JUN_VAR'                  ):SetBlock( {||(_cAlias1)->JUN_VAR })
            _oReport:Section(1):Cell('JUL_REAL'                 ):SetBlock( {||(_cAlias1)->JUL_REAL })
            _oReport:Section(1):Cell('JUL_BUDGET'               ):SetBlock( {||(_cAlias1)->JUL_PREV })
            _oReport:Section(1):Cell('JUL_VAR'                  ):SetBlock( {||(_cAlias1)->JUL_VAR })
            _oReport:Section(1):Cell('AGO_REAL'                 ):SetBlock( {||(_cAlias1)->AGO_REAL })
            _oReport:Section(1):Cell('AGO_BUDGET'               ):SetBlock( {||(_cAlias1)->AGO_PREV })
            _oReport:Section(1):Cell('AGO_VAR'                  ):SetBlock( {||(_cAlias1)->AGO_VAR })
            _oReport:Section(1):Cell('SET_REAL'             	):SetBlock( {||(_cAlias1)->SET_REAL })
            _oReport:Section(1):Cell('SET_BUDGET'               ):SetBlock( {||(_cAlias1)->SET_PREV })
            _oReport:Section(1):Cell('SET_VAR'                  ):SetBlock( {||(_cAlias1)->SET_VAR })
            _oReport:Section(1):Cell('OUT_REAL'                 ):SetBlock( {||(_cAlias1)->OUT_REAL })
            _oReport:Section(1):Cell('OUT_BUDGET'               ):SetBlock( {||(_cAlias1)->OUT_PREV })
            _oReport:Section(1):Cell('OUT_VAR'                  ):SetBlock( {||(_cAlias1)->OUT_VAR })
            _oReport:Section(1):Cell('NOV_REAL'            		):SetBlock( {||(_cAlias1)->NOV_REAL })
            _oReport:Section(1):Cell('NOV_BUDGET'               ):SetBlock( {||(_cAlias1)->NOV_PREV })
            _oReport:Section(1):Cell('NOV_VAR'                  ):SetBlock( {||(_cAlias1)->NOV_VAR })
            _oReport:Section(1):Cell('DEZ_REAL'             	):SetBlock( {||(_cAlias1)->DEZ_REAL })
            _oReport:Section(1):Cell('DEZ_BUDGET'               ):SetBlock( {||(_cAlias1)->DEZ_PREV })
            _oReport:Section(1):Cell('DEZ_VAR'                  ):SetBlock( {||(_cAlias1)->DEZ_VAR })        

            _oReport:Section(1):PrintLine()

            (_cAlias1)->(DbSkip())
        else
            (_cAlias1)->(DbSkip())
        EndIf
    EndDo

    _oReport:Section(1):Finish()
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
                ,SZA.ZA_BUDTOTA                         AS TOTAL_PREV
                ,JAN_REAL.SALDO                         AS JAN_REAL
                ,SZA.ZA_VALJANE                         AS JAN_PREV
                ,(JAN_REAL.SALDO) + (SZA.ZA_VALJANE)    AS JAN_VAR                
                ,FEV_REAL.SALDO                         AS FEV_REAL
                ,SZA.ZA_VALFEVE                         AS FEV_PREV
                ,(FEV_REAL.SALDO-SZA.ZA_VALFEVE)        AS FEV_VAR
                ,MAR_REAL.SALDO                         AS MAR_REAL
                ,SZA.ZA_VALMARC                         AS MAR_PREV
                ,(MAR_REAL.SALDO - SZA.ZA_VALMARC)      AS MAR_VAR
                ,ABR_REAL.SALDO                         AS ABR_REAL
                ,SZA.ZA_VALABRI                         AS ABR_PREV
                ,(ABR_REAL.SALDO - SZA.ZA_VALABRI)      AS ABR_VAR
                ,MAI_REAL.SALDO                         AS MAI_REAL
                ,SZA.ZA_VALMAIO                         AS MAI_PREV
                ,(MAI_REAL.SALDO - SZA.ZA_VALMAIO)      AS MAI_VAR
                ,JUN_REAL.SALDO                         AS JUN_REAL
                ,SZA.ZA_VALJUNH                         AS JUN_PREV
                ,(JUN_REAL.SALDO - SZA.ZA_VALJUNH)      AS JUN_VAR
                ,JUL_REAL.SALDO                         AS JUL_REAL
                ,SZA.ZA_VALJULH                         AS JUL_PREV
                ,(JUL_REAL.SALDO - SZA.ZA_VALJULH)      AS JUL_VAR
                ,AGO_REAL.SALDO                         AS AGO_REAL
                ,SZA.ZA_VALAGOS                         AS AGO_PREV
                ,(AGO_REAL.SALDO - SZA.ZA_VALAGOS)      AS AGO_VAR
                ,SET_REAL.SALDO                         AS SET_REAL
                ,SZA.ZA_VALSETE                         AS SET_PREV
                ,(SET_REAL.SALDO - SZA.ZA_VALSETE)      AS SET_VAR
                ,OUT_REAL.SALDO                         AS OUT_REAL
                ,SZA.ZA_VALOUTU                         AS OUT_PREV
                ,(OUT_REAL.SALDO - SZA.ZA_VALOUTU)      AS OUT_VAR
                ,NOV_REAL.SALDO                         AS NOV_REAL
                ,SZA.ZA_VALNOVE                         AS NOV_PREV
                ,(NOV_REAL.SALDO - SZA.ZA_VALNOVE)      AS NOV_VAR
                ,DEZ_REAL.SALDO                         AS DEZ_REAL
                ,SZA.ZA_VALDEZE                         AS DEZ_PREV
                ,(DEZ_REAL.SALDO - SZA.ZA_VALDEZE)      AS DEZ_VAR
                ,CTT.CTT_XDEPTO                         AS CTT_XDEPTO
        FROM %Table:CT1% CT1 
		LEFT JOIN %Table:CQ2% CQ2 ON CT1.%NotDel% AND CT1.CT1_CONTA = CQ2.CQ2_CONTA
        FULL JOIN %Table:SZA% SZA ON SZA.%NotDel% AND CQ2.CQ2_CCUSTO = SZA.ZA_CCUSTO AND CQ2.CQ2_CONTA = SZA.ZA_CONTAB AND SZA.ZA_ANOBUDT = %Exp:MV_PAR01%
        Inner JOIN %Table:CTT% CTT ON CTT.%NotDel% AND CTT.CTT_CUSTO = CQ2.CQ2_CCUSTO
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJanIni% AND %Exp:_cJanFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JAN_REAL ON CQ2.CQ2_CCUSTO = JAN_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JAN_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cFevIni% AND %Exp:_cFevFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) FEV_REAL ON CQ2.CQ2_CCUSTO = FEV_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = FEV_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cMarIni% AND %Exp:_cMarFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) MAR_REAL ON CQ2.CQ2_CCUSTO = MAR_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = MAR_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cAbrIni% AND %Exp:_cAbrFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) ABR_REAL ON CQ2.CQ2_CCUSTO = ABR_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = ABR_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cMaiIni% AND %Exp:_cMaiFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) MAI_REAL ON CQ2.CQ2_CCUSTO = MAI_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = MAI_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJunIni% AND %Exp:_cJunFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JUN_REAL ON CQ2.CQ2_CCUSTO = JUN_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JUN_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cJulIni% AND %Exp:_cJulFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) JUL_REAL ON CQ2.CQ2_CCUSTO = JUL_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = JUL_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cAgoIni% AND %Exp:_cAgoFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) AGO_REAL ON CQ2.CQ2_CCUSTO = AGO_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = AGO_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cSetIni% AND %Exp:_cSetFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) SET_REAL ON CQ2.CQ2_CCUSTO = SET_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = SET_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cOutIni% AND %Exp:_cOutFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) OUT_REAL ON CQ2.CQ2_CCUSTO = OUT_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = OUT_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cNovIni% AND %Exp:_cNovFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) NOV_REAL ON CQ2.CQ2_CCUSTO = NOV_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = NOV_REAL.CQ2_CONTA
        LEFT JOIN (SELECT CQ2_CONTA,CQ2_CCUSTO,SUM(CQ2_CREDIT) - SUM(CQ2_DEBITO) AS SALDO FROM %Table:CQ2% SQ2 WHERE SQ2.%NotDel% AND CQ2_DATA BETWEEN %Exp:_cDezIni% AND %Exp:_cDezFin% AND CQ2_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% GROUP BY CQ2_CONTA,CQ2_CCUSTO) DEZ_REAL ON CQ2.CQ2_CCUSTO = DEZ_REAL.CQ2_CCUSTO AND CQ2.CQ2_CONTA = DEZ_REAL.CQ2_CONTA
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
