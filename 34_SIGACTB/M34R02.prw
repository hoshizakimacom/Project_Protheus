#Include 'Protheus.ch'

//+-----------------------------------------------------------------------------------------------------
//| Relatorio de saldo por item contabil
//+-----------------------------------------------------------------------------------------------------
User Function M34R02()
    Local _oReport      := Nil
    Local _cPerg        := 'M34R02   '

    MR34PutSX1(_cPerg)

    If FindFunction('TRepInUse') .And. TRepInUse(.F.)    //verifica se relatorios personalizaveis esta disponivel
        If Pergunte(_cPerg, .T.)
            _oReport := MR34Def(_oReport, _cPerg)
            _oReport:PrintDialog()
        EndIf
    EndIf
Return

//+-----------------------------------------------------------------------------------------------------
Static Function MR34GetCT2(_cAlias,_oReport)
    Local _nTotal           := 0

    BeginSQL Alias _cAlias
        SELECT   CONTA                          AS CONTA_CONTABIL
                ,ITEM                           AS ITEM_CONTABIL
                ,MAX(CREDITO)                   AS CREDITO
                ,MAX(DEBITO)                    AS DEBITO
                ,MAX(CREDITO)  - MAX(DEBITO)    AS SALDO
        FROM
            (
                SELECT   CONTA
                        ,ITEM
                        ,SUM(VALOR) DEBITO
                        ,'' CREDITO
                    FROM
                        (
                            SELECT   CT2_FILIAL FILIAL
                                    ,CT1_CONTA CONTA
                                    ,ISNULL(CT2_CCD,'') CUSTO
                                    ,ISNULL(CT2_ITEMD,'') ITEM
                                    ,ISNULL(CT2_CLVLDB,'') CLVL
                                    ,ISNULL(CT2_DATA,'') DDATA
                                    ,ISNULL(CT2_TPSALD,'') TPSALD
                                    ,ISNULL(CT2_DC,'') DC
                                    ,ISNULL(CT2_LOTE,'') LOTE
                                    ,ISNULL(CT2_SBLOTE,'') SUBLOTE
                                    ,ISNULL(CT2_DOC,'') DOC
                                    ,ISNULL(CT2_LINHA,'') LINHA
                                    ,ISNULL(CT2_CREDIT,'') XPARTIDA
                                    ,ISNULL(CT2_HIST,'') HIST
                                    ,ISNULL(CT2_SEQHIS,'') SEQHIS
                                    ,ISNULL(CT2_SEQLAN,'') SEQLAN
                                    ,'1' TIPOLAN
                                    ,ISNULL(CT2_VALOR,0) VALOR
                                    ,ISNULL(CT2_EMPORI,'') EMPORI
                                    ,ISNULL(CT2_FILORI,'') FILORI
                                FROM %Table:CT1% CT1
                                LEFT JOIN CT2010 CT2    ON CT1_CONTA = CT2_DEBITO
                                                        AND CT2_FILORI BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                                                        AND CT2.CT2_DEBITO = CT1.CT1_CONTA
                                                        AND CT2.CT2_DATA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
                                                        AND CT2.CT2_TPSALD = '1'    // real
                                                        AND CT2.CT2_MOEDLC = '01'   // moeda
                                                        AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3')
                                                        AND CT2_VALOR <> 0
                                                        AND CT2.%NotDel%
                                WHERE   CT1.CT1_FILIAL = %xFilial:CT1%
                                    AND CT1.CT1_CLASSE = '2'
                                    AND CT1.CT1_CONTA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                                    AND CT1.%NotDel%
                        ) DEBITO
                        GROUP BY  CONTA, ITEM

                        UNION

                SELECT   CONTA
                        , ITEM
                        , '' DEBITO
                        , SUM(VALOR) CREDITO
                    FROM
                        (
                            SELECT   CT2_FILIAL FILIAL
                                    , CT1_CONTA CONTA
                                    , ISNULL(CT2_CCC,'') CUSTO
                                    , ISNULL(CT2_ITEMC,'') ITEM
                                    , ISNULL(CT2_CLVLCR,'') CLVL
                                    , ISNULL(CT2_DATA,'') DDATA
                                    , ISNULL(CT2_TPSALD,'') TPSALD
                                    ,ISNULL(CT2_DC,'') DC
                                    , ISNULL(CT2_LOTE,'') LOTE
                                    , ISNULL(CT2_SBLOTE,'')SUBLOTE
                                    , ISNULL(CT2_DOC,'') DOC
                                    , ISNULL(CT2_LINHA,'') LINHA
                                    , ISNULL(CT2_DEBITO,'') XPARTIDA
                                    , ISNULL(CT2_HIST,'') HIST
                                    , ISNULL(CT2_SEQHIS,'') SEQHIS
                                    , ISNULL(CT2_SEQLAN,'') SEQLAN
                                    , '2' TIPOLAN
                                    ,ISNULL(CT2_VALOR,0) VALOR
                                    , ISNULL(CT2_EMPORI,'') EMPORI
                                    , ISNULL(CT2_FILORI,'') FILORI
                                FROM %Table:CT1% CT1
                                LEFT JOIN CT2010 CT2    ON CT1_CONTA = CT2_CREDIT
                                                        AND CT2_FILORI BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                                                        AND CT2.CT2_CREDIT =  CT1.CT1_CONTA
                                                        AND CT2.CT2_DATA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
                                                        AND CT2.CT2_TPSALD = '1'    // real
                                                        AND CT2.CT2_MOEDLC = '01'   // moeda
                                                        AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3')
                                                        AND CT2_VALOR <> 0
                                                        AND CT2.%NotDel%
                                WHERE   CT1.CT1_FILIAL = %xFilial:CT1%
                                    AND CT1.CT1_CLASSE = '2'
                                    AND CT1.CT1_CONTA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                                    AND CT1.%NotDel%
                            ) CREDITO
                            GROUP BY  CONTA, ITEM
                ) SALDO
                GROUP BY CONTA,ITEM
    EndSql


    // Atualiza regua de processamento
    (_cAlias)->( dbEval( {|| _nTotal++ } ) )
    (_cAlias)->( dbGoTop() )

    _oReport:SetMeter(_nTotal)
Return

//+-----------------------------------------------------------------------------------------------------
Static Function MR34Print(_oReport,_cAlias)
    Private _oSection         := _oReport:Section(1)

    _oReport:Section(1):Init()
    _oReport:IncMeter()

    MR34GetCT2(_cAlias,_oReport)
    //+-------------------------------------------
    //| Inicio da impressao
    //+-------------------------------------------

    While !_oReport:Cancel() .And. (_cAlias)->(!EOF())

        _oReport:Section(1):Cell('CONTA_CONTABIL'             ):SetBlock( {||(_cAlias)->CONTA_CONTABIL })
        _oReport:Section(1):Cell('ITEM_CONTABIL'              ):SetBlock( {||(_cAlias)->ITEM_CONTABIL })
        _oReport:Section(1):Cell('DEBITO'                     ):SetBlock( {||(_cAlias)->DEBITO })
        _oReport:Section(1):Cell('CREDITO'                    ):SetBlock( {||(_cAlias)->CREDITO })
        _oReport:Section(1):Cell('SALDO'                      ):SetBlock( {||(_cAlias)->SALDO })

        _oReport:Section(1):PrintLine()

        _oReport:IncMeter()
        (_cAlias)->(DbSkip())
    EndDo

    _oReport:Section(1):Finish()

    (_cAlias)->(dbCloseArea())
return

//+-----------------------------------------------------------------------------------------------------
Static Function MR34Def(_oReport, _cPerg)
    Local _cTitle   := 'Relatório de saldo por item contábil'
    Local _cHelp    := 'Relatório de saldo por item contábil'
    Local _cAlias   := GetNextAlias()
    Local _oSection1          := Nil

    _oReport    := TReport():New('M34R02   ',_cTitle,_cPerg,{|_oReport| MR34Print(_oReport,_cAlias)},_cHelp)

    //+-------------------------------------------
    //| Secao dos itens do Pedido de Vendas
    //+-------------------------------------------
    _oSection1 := TRSection():New(_oReport,'SALDO ITEM CONTABIL',{_cAlias})

    TRCell():New(_oSection1,'CONTA_CONTABIL'           , _cAlias)
    TRCell():New(_oSection1,'ITEM_CONTABIL'            , _cAlias)
    TRCell():New(_oSection1,'DEBITO'                   , _cAlias)
    TRCell():New(_oSection1,'CREDITO'                  , _cAlias)
    TRCell():New(_oSection1,'SALDO'                    , _cAlias)


    _oSection1:oReport:cFontBody          := 'Calibri'
    _oSection1:oReport:nFontBody          := 11

Return(_oReport)

//+-----------------------------------------------------------------------------------------------------
Static Function MR34PutSX1(_cPerg)
    Local _aAreaSX1     := SX1->(GetArea())

    SX1->(DbGoTop())
    SX1->(DbSetOrder(1))

    If !SX1->(DbSeek(_cPerg))
        PutSX1(_cPerg,'01','Filial De ?'        ,'Filial De ?'              ,'Filial De ?'              ,'mv_ch1'   ,'C',2,0,                       ,'G',''             ,'   ',,,'mv_par01',,,,Space(2))
        PutSX1(_cPerg,'02','Filial Ate ?'       ,'Filial Ate ?'             ,'Filial Ate ?'             ,'mv_ch2'   ,'C',2,0,                       ,'G','NaoVazio()'   ,'   ',,,'mv_par02',,,,Replicate('Z',2))

        PutSX1(_cPerg,'03','C.Contábil De ?'    ,'C.Contábil De ?'          ,'C.Contábil De  ?'         ,'mv_ch3'   ,'C',TamSx3('CT1_CONTA')[1],0, ,'G',''              ,'CT1',,,'mv_par03',,,,Space(TamSx3('CT1_CONTA')[1]))
        PutSX1(_cPerg,'04','C.Contábil Ate ?'   ,'C.Contábil Ate ?'         ,'C.Contábil Ate  ?'        ,'mv_ch4'   ,'C',TamSx3('CT1_CONTA')[1],0, ,'G','NaoVazio()'    ,'CT1',,,'mv_par04',,,,Replicate('Z',TamSx3('CT1_CONTA')[1]))

        PutSX1(_cPerg,'05','Data De ?'          ,'Data De ?'                ,'Data De ?'                ,'mv_ch5'   ,'D',08,0,                      ,'G','NaoVazio()'   ,'   ',,,'mv_par05',,,,'01/01/2001')
        PutSX1(_cPerg,'06','Data Ate ?'         ,'Data Ate ?'               ,'Data Ate ?'               ,'mv_ch6'   ,'D',08,0,                      ,'G','NaoVazio()'   ,'   ',,,'mv_par06',,,,'31/12/2022')
    EndIf

    RestArea(_aAreaSX1)

Return

//+-----------------------------------------------------------------------------------------------------
