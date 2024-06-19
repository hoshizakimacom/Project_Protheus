#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------------------------------------------
//  Relat�rio de Or�amento em Excel
//+----------------------------------------------------------------------------------------------------------------------------
User Function M05R04()
    Local oReport      := Nil
    Local cPerg        := 'M05R04   '


    If FindFunction('TRepInUse') .And. TRepInUse(.F.)    //verifica se relatorios personalizaveis esta disponivel
        If Pergunte(cPerg, .T.)
            oReport := MR05Def(oReport, cPerg)
            oReport:PrintDialog()
        EndIf
    EndIf
Return

//+----------------------------------------------------------------------------------------------------------------------------
Static Function MR05Def(oReport,cPerg)
	Local cFamilia			:= ''
    Local cCodInst          := ''
    Local cDescInst         := ''
    Local cTitle            := 'Relat�rio Or�amentos'
    Local cHelp             := 'Relat�rio Or�amentos'
    Local cAliasX         	:= GetNextAlias()
    Local oSection1         := Nil

    oReport    := TReport():New('PP' + MV_PAR01+ '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":","") ,cTitle,cPerg,{|oReport| MR05Print(oReport,cAliasX)},cHelp)

    //+-------------------------------------------
    //| Secao dos itens do Pedido de Vendas
    //+-------------------------------------------
    oSection1 := TRSection():New(oReport,'OR�AMENTOS',{cAliasX})

    TRCell():New(oSection1,'ORCAMENTO'              ,cAliasX)
    TRCell():New(oSection1,'CLIENTE'                ,cAliasX)
    TRCell():New(oSection1,'LOJA'                   ,cAliasX)
    TRCell():New(oSection1,'NOME'                   ,cAliasX)
    TRCell():New(oSection1,'COND_PAGAMENTO'         ,cAliasX)

    TRCell():New(oSection1,'SEQ'                    ,cAliasX)
    TRCell():New(oSection1,'ITEM'                   ,cAliasX)
    TRCell():New(oSection1,'PRODUTO'                ,cAliasX)
    TRCell():New(oSection1,'DESCRICAO'              ,cAliasX)
    TRCell():New(oSection1,'COD_INST'				,cCodInst)
    TRCell():New(oSection1,'DESC_INST'				,cDescInst)
    TRCell():New(oSection1,'FAMILIA'				,cFamilia)
    TRCell():New(oSection1,'NCM'                    ,cAliasX)
    TRCell():New(oSection1,'QTD'                    ,cAliasX)
    TRCell():New(oSection1,'VLR_UNITARIO'           ,cAliasX)
    TRCell():New(oSection1,'DESCONTO'				,cAliasX)
    TRCell():New(oSection1,'ACRESCIMO'				,cAliasX)
    TRCell():New(oSection1,'IPI_ALQ'                ,cAliasX)
    TRCell():New(oSection1,'IPI_VLR'                ,cAliasX)
    TRCell():New(oSection1,'ICMS_ALQ'               ,cAliasX)
    TRCell():New(oSection1,'ICMS_VLR'               ,cAliasX)
    TRCell():New(oSection1,'PIS_COF_ALQ'            ,cAliasX)
    TRCell():New(oSection1,'PIS_COF_VLR'            ,cAliasX)
    TRCell():New(oSection1,'ICMS_ST_VLR'            ,cAliasX)
    TRCell():New(oSection1,'VLR_UNIT_COM_IMPOSTOS'  ,cAliasX)
    TRCell():New(oSection1,'VLR_TOTAL_ITEM'         ,cAliasX)

    TRCell():New(oSection1,'SUB_TOTAL'              ,cAliasX)
    TRCell():New(oSection1,'TIPO_FRETE'             ,cAliasX)
    TRCell():New(oSection1,'VLR_FRETE'              ,cAliasX)
    TRCell():New(oSection1,'TIPO_INSTALACAO'        ,cAliasX)
    TRCell():New(oSection1,'VLR_INSTALACAO'         ,cAliasX)
    TRCell():New(oSection1,'TOTAL_GERAL'            ,cAliasX)

    oSection1:oReport:cFontBody          := 'Calibri'
    oSection1:oReport:nFontBody          := 11

Return(oReport)

//+----------------------------------------------------------------------------------------------------------------------------
Static Function MR05Print(oReport,cAliasX)

    Local cDesc         := ''
    Local cFamilia		:= ''
    Local cCodInst      := ''
    Local cDescInst     := ''
    Local nItem         := 0
    Private oSection      := oReport:Section(1)
    Private cPicVal       := "@E 99,999,999.99"
    Private cPicAliq      := "@E 999.99"

    oReport:Section(1):Init()
    oReport:IncMeter()

    MR05GetSCK(cAliasX,oReport)
    //+-------------------------------------------
    //| Inicio da impressao
    //+-------------------------------------------

    While !oReport:Cancel() .And. (cAliasX)->(!EOF())

        SCJ->(DbGoto((cAliasX)->REC_CAB))

        cDesc           := M05RDescr(AllTrim((cAliasX)->_PRODUTO),IIF(Empty((cAliasX)->B5_CEME),"PRODUTO SEM COMPLEMENTO",AllTrim((cAliasX)->B5_CEME)), AllTrim((cAliasX)->_DESCRI),(cAliasX)->B5_COMPRLC,(cAliasX)->B5_LARGLC,(cAliasX)->B5_ALTURLC)
        cCodFam			:= Posicione('SB1',1,xFilial('SB1')+AllTrim((cAliasX)->_PRODUTO),'B1_XFAMILI')
        cFamilia		:= Alltrim(Posicione('ZA1',1,xFilial('ZA1')+cCodFam,'ZA1_DESC'))
        cCodInst        := Posicione('SB1',1,xFilial('SB1')+AllTrim((cAliasX)->_PRODUTO),'B1_XCODINS')
        cDescInst       := Posicione('ZA5',1,xFilial('ZA5')+AllTrim(cCodInst),'ZA5_DESC')
        nItem++

        oReport:Section(1):Cell('ORCAMENTO'                 ):SetBlock( {||(cAliasX)->_NUM })
        oReport:Section(1):Cell('CLIENTE'                   ):SetBlock( {||(cAliasX)->_CLIENTE })
        oReport:Section(1):Cell('LOJA'                      ):SetBlock( {||(cAliasX)->_LOJA })
        oReport:Section(1):Cell('NOME'                      ):SetBlock( {||(cAliasX)->_NOME })
        oReport:Section(1):Cell('COND_PAGAMENTO'            ):SetBlock( {||AllTrim((cAliasX)->E4_CODIGO) + ': ' + AllTrim((cAliasX)->E4_DESCRI) + ' - '  + AllTrim((cAliasX)->CJ_XDESPAG) })

        oReport:Section(1):Cell('SEQ'                       ):SetBlock( {||(cAliasX)->_ITEM })
        oReport:Section(1):Cell('ITEM'                      ):SetBlock( {||(cAliasX)->_XITEMP })
        oReport:Section(1):Cell('PRODUTO'                   ):SetBlock( {||(cAliasX)->_PRODUTO })
        oReport:Section(1):Cell('DESCRICAO'                 ):SetBlock( {|| cDesc })
        oReport:Section(1):Cell('FAMILIA'					):SetBlock( {|| cFamilia }) 
        oReport:Section(1):Cell('COD_INST'					):SetBlock( {|| cCodInst }) 
        oReport:Section(1):Cell('DESC_INST'					):SetBlock( {|| cDescInst }) 
        oReport:Section(1):Cell('NCM'                       ):SetBlock( {||Transform((cAliasX)->B1_POSIPI,"@R 9999.99.99")  })
        oReport:Section(1):Cell('QTD'                       ):SetBlock( {||NoRound(MaFisRet(nItem,"IT_QUANT")   ,2)})
        oReport:Section(1):Cell('VLR_UNITARIO'              ):SetBlock( {||NoRound(MaFisRet(nItem,"IT_PRCUNI")     ,2) })
        oReport:Section(1):Cell('DESCONTO'					):SetBlock( {||(cAliasX)->_DESCONT	})
        oReport:Section(1):Cell('ACRESCIMO'					):SetBlock( {||(cAliasX)->_XACRESC	})
        oReport:Section(1):Cell('IPI_ALQ'                   ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_ALIQIPI")  ,2) })
        oReport:Section(1):Cell('IPI_VLR'                   ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_VALIPI")   ,2) })
        oReport:Section(1):Cell('ICMS_ALQ'                  ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_ALIQICM")  ,2) })
        oReport:Section(1):Cell('ICMS_VLR'                  ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_VALICM")   ,2) })
        oReport:Section(1):Cell('PIS_COF_ALQ'               ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_ALIQPS2") + MaFisRet( nItem ,"IT_ALIQCF2") ,2) })
        oReport:Section(1):Cell('PIS_COF_VLR'               ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_VALPS2") + MaFisRet( nItem ,"IT_VALCF2"),2) })
        oReport:Section(1):Cell('ICMS_ST_VLR'               ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_VALSOL"),2) })
        oReport:Section(1):Cell('VLR_UNIT_COM_IMPOSTOS'     ):SetBlock( {||NoRound((MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_FRETE") ) )  / (cAliasX)->_QTDVEN ,2) })
        oReport:Section(1):Cell('VLR_TOTAL_ITEM'            ):SetBlock( {||NoRound(MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_DESPESA") ),2)  })
        oReport:Section(1):Cell('SUB_TOTAL'                 ):SetBlock( {||NoRound(( MaFisRet(,"NF_TOTAL") - ( MaFisRet(,"NF_FRETE") + MaFisRet(,"NF_DESPESA") ) ),2) })
        oReport:Section(1):Cell('TIPO_FRETE'                ):SetBlock( {||M05RTpFret() })
        oReport:Section(1):Cell('VLR_FRETE'                 ):SetBlock( {||NoRound(IIF(SCJ->CJ_XTFRETE == 'C',MaFisRet(,"NF_FRETE"),0),2) })
        oReport:Section(1):Cell('TIPO_INSTALACAO'           ):SetBlock( {||M05RTpIsnt() })
        oReport:Section(1):Cell('VLR_INSTALACAO'            ):SetBlock( {||NoRound(MaFisRet(,"NF_DESPESA"),2) })
        oReport:Section(1):Cell('TOTAL_GERAL'               ):SetBlock( {||NoRound(MaFisRet(,"NF_TOTAL"),2)})
       
        oReport:Section(1):PrintLine()

        oReport:IncMeter()

        (cAliasX)->(DbSkip())
    EndDo

    oReport:Section(1):Finish()

    (cAliasX)->(DbCloseArea())
Return

//+----------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpFret()
    Local cRet  := ''

    Do Case
    Case SCJ->CJ_XTFRETE == 'C'
        cRet := 'CIF'
    Case SCJ->CJ_XTFRETE == 'F'
        cRet := 'FOB'
    Case SCJ->CJ_XTFRETE == 'T'
        cRet := 'Por Conta de Terceiros'
    Case SCJ->CJ_XTFRETE == 'S'
        cRet := 'Sem Frete'

    End Case
Return cRet

//+----------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpIsnt()
    Local cRet  := ''

    Do Case
    Case SCJ->CJ_XTPINST == '1'
        cRet := 'Sem Instala��o'
    Case SCJ->CJ_XTPINST == '2'
        cRet := 'Credenciada'
    Case SCJ->CJ_XTPINST == '3'
        cRet := 'Macom'
    Case SCJ->CJ_XTPINST == '4'
        cRet := 'Rateio no Produto'

    End Case
Return cRet

//+----------------------------------------------------------------------------------------------------------------------------
Static Function M05RDescr(cProd,cDescSB1,cDescSCK,nComp,nLar,nAlt)

    Local cLetras   := ""
    Local cRet      := ""
    Local i         := 0
    Private aRet      := {}
    Private cAux      := ""
    Private nTam      := 45
    Private nIni      := 1
    Private nQuebra   := 1
    Private cPic      := "@E 999999"

    Default cDescSB1    := 'Produto sem complemento'

    If cProd == 'N/A'
        cDesc   := cDescSCK
    Else
        cDesc   := cDescSB1

        If nComp > 0 .And. nLar > 0 .And. nAlt > 0
            cDesc += ' - MEDINDO: ' + AllTrim(Transform(nComp,cPic)) + ' X ' + AllTrim(Transform(nLar,cPic)) + ' X ' + AllTrim(Transform(nAlt,cPic))
        EndIf
    EndIf

    // Retira enter da descri��o
    Replace( cDesc , chr(13) ," ")

    // Retira espa�oes duplicados
    For i := 1 to Len( cDesc ) - 1
        cLetras := Substr( cDesc , i , 2 )

        If cLetras <> "  "
            cRet += Left(cLetras,1)
        EndIf
    Next

    If i > 0 .and. cLetras <> "  "
        cRet += Right(cLetras,1)
    EndIf
Return cRet

//+----------------------------------------------------------------------------------------------------------------------------

//+----------------------------------------------------------------------------------------------------------------------------
Static Function MR05GetSCK(cAliasX,oReport)
    Local nTotal           := 0
    Local cQryAd        := ""
    Local nY            := 0
    Local aFisGet       := Nil
    Local aFisGetSC5    := Nil
    Local aRelImp       := MaFisRelImp("MT100",{"SF2","SD2"})
    Local nTotValdesc  := 0

    FisGetInit(@aFisGet,@aFisGetSC5)

    // Filtragem do relat�rio
    cQryAd := "%"
    For nY := 1 To Len(aFisGet)
        cQryAd += ","+aFisGet[nY][2]
    Next nY
    For nY := 1 To Len(aFisGetSC5)
        cQryAd += ","+aFisGetSC5[nY][2]
    Next nY
    cQryAd += "%"


    BeginSql Alias cAliasX
        SELECT SCJ.R_E_C_N_O_       AS REC_CAB
            ,SCK.R_E_C_N_O_         AS REC_ITEM
            ,SCJ.CJ_FILIAL          AS _FILIAL
            ,SCJ.CJ_NUM             AS _NUM
            ,SCJ.CJ_CLIENTE         AS _CLIENTE
            ,SCJ.CJ_LOJA            AS _LOJA
            ,'N'                    AS _TIPO
            ,SA1.A1_NOME            AS _NOME
            ,SA1.A1_TIPO            AS _TIPOCLI
            ,SA1.A1_INCISS          AS _INCISS
            ,SCJ.CJ_DESC1           AS _DESC1
            ,SCJ.CJ_DESC2           AS _DESC2
            ,SCJ.CJ_DESC3           AS _DESC3
            ,SCJ.CJ_DESC4           AS _DESC4
            ,SCJ.CJ_EMISSAO         AS _EMISSAO
            ,SCJ.CJ_CONDPAG         AS _CONDPAG
            ,SCJ.CJ_FRETE           AS _FRETE
            ,SCJ.CJ_DESPESA         AS _DESPESA
            ,SCJ.CJ_FRETAUT         AS _FRETAUT
            ,SCJ.CJ_XTFRETE         AS _TFRETE
            ,SCJ.CJ_SEGURO          AS _SEGURO
            ,SCJ.CJ_TABELA          AS _TABELA
            ,SCJ.CJ_MOEDA           AS _MOEDA
            ,SE4.E4_ACRSFIN         AS _ACRSFIN
            ,SCJ.CJ_XVEND1          AS _VEND1
            ,SCJ.CJ_PDESCAB         AS _PDESCAB
            ,'N'                    AS _INSS
            ,SCK.CK_PRODUTO         AS _PRODUTO
            ,SCK.CK_TES             AS _TES
            ,' '                    AS _CF
            ,SCK.CK_QTDVEN          AS _QTDVEN
            ,SCK.CK_PRUNIT          AS _PRUNIT
            ,SCK.CK_VALDESC         AS _VALDESC
            ,SCK.CK_VALOR           AS _VALOR
            ,SCK.CK_ITEM            AS _ITEM
            ,SCK.CK_XITEMP          AS _XITEMP
            ,SCK.CK_DESCRI          AS _DESCRI
            ,SCK.CK_UM              AS _UM
            ,SCK.CK_PRCVEN          AS _PRCVEN
            ,SCK.CK_ENTREG          AS _ENTREG
            ,SCK.CK_LOCAL           AS _LOCAL
            ,SCK.CK_DESCONT			AS _DESCONT
            ,SCK.CK_XACRESC			AS _XACRESC
            ,''                     AS _TRANSP
            ,''                     AS _VEND2
            ,''                     AS _VEND3
            ,''                     AS _VEND4
            ,''                     AS _VEND5
            ,''                     AS _COMIS1
            ,''                     AS _COMIS2
            ,''                     AS _COMIS3
            ,''                     AS _COMIS4
            ,''                     AS _COMIS5
            ,SCJ.CJ_XTFRETE         AS _TPFRETE
            ,'0'                    AS _PBRUTO
            ,'0'                    AS _PESOL
            ,'0'                    AS _VOLUME1
            ,'0'                    AS _QTDEMP
            ,'0'                    AS _QTDLIB
            ,'0'                    AS _QTDENT
            ,''                     AS _ESPECI1
            ,''                     AS _REAJUST
            ,''                     AS _BANCO
            ,''                     AS _MENNOTA
            ,''                     AS _NOTA
            ,''                     AS _SERIE
            ,B1_POSIPI
            ,B5_CEME
            ,E4_DESCRI
            ,E4_ACRSFIN
            ,B5_COMPRLC
            ,B5_LARGLC
            ,B5_ALTURLC
            ,E4_CODIGO
            ,E4_DESCRI
            ,CJ_XDESPAG
        %Exp:cQryAd%
        FROM %Table:SCJ% SCJ
        INNER JOIN %Table:SCK% SCK ON SCK.CK_FILIAL = %xFilial:SCK% AND SCK.CK_NUM   = SCJ.CJ_NUM AND SCK.%NotDel%
        INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD   = CJ_CLIENTE AND CJ_LOJA = A1_LOJA AND SA1.%NotDel%
        INNER JOIN %Table:SE4% SE4 ON SE4.E4_FILIAL = %xFilial:SE4% AND E4_CODIGO    = CJ_CONDPAG AND SE4.%NotDel%
        INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND B1_COD = CK_PRODUTO AND SB1.%NotDel%
        LEFT  JOIN %Table:SB5% SB5 ON SB5.B5_FILIAL = %xFilial:SB5% AND B1_COD = B5_COD AND SB5.%NotDel%
        WHERE   SCJ.CJ_FILIAL = %xFilial:SCJ% AND
                SCJ.%notdel% AND
                SCJ.CJ_NUM = %Exp:MV_PAR01%
        ORDER BY SCK.CK_XITEMP
    EndSql

    (cAliasX)->( dbEval( {|| nTotal++ } ) )
    (cAliasX)->( dbGoTop() )

    DbSelectArea('SCJ')

    cCliEnt := (cAliasX)->_CLIENTE
    aCabPed := {}

    MaFisIni(cCliEnt,;                      // 1-Codigo Cliente/Fornecedor
    (cAliasX)->_LOJA,;                    // 2-Loja do Cliente/Fornecedor
    If((cAliasX)->_TIPO$'DB',"F","C"),;   // 3-C:Cliente , F:Fornecedor
        (cAliasX)->_TIPO,;                // 4-Tipo da NF
        (cAliasX)->_TIPOCLI,;             // 5-Tipo do Cliente/Fornecedor
        aRelImp,;                           // 6-Relacao de Impostos que suportados no arquivo
        ,;                                  // 7-Tipo de complemento
        ,;                                  // 8-Permite Incluir Impostos no Rodape .T./.F.
        "SB1",;                             // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
        "MATA461")                          // 10-Nome da rotina que esta utilizando a funcao

        nFrete      := (cAliasX)->_FRETE
        nSeguro     := (cAliasX)->_SEGURO
        nFretAut    := (cAliasX)->_FRETAUT
        nDespesa    := (cAliasX)->_DESPESA
        nDescCab    := 0 //(cAliasX)->_DESCONT
        nPDesCab    := 0 //(cAliasX)->_PDESCAB
        nC5Desc1    := 0 //(cAliasX)->_DESC1
        nC5Desc2    := 0 //(cAliasX)->_DESC2
        nC5Desc3    := 0 //(cAliasX)->_DESC3
        nC5Desc4    := 0 //(cAliasX)->_DESC4
        nC5Frete    := nFrete
        nC5Seguro   := nSeguro
        nC5Despesa  := nDespesa
        aItemPed    := {}
        aCabPed     := {    (cAliasX)->_TIPO                ,;
                            (cAliasX)->_CLIENTE             ,;
                            (cAliasX)->_LOJA                ,;
                            (cAliasX)->_TRANSP              ,;
                            (cAliasX)->_CONDPAG             ,;
                            (cAliasX)->_EMISSAO             ,;
                            (cAliasX)->_NUM                 ,;
                            (cAliasX)->_VEND1               ,;
                            (cAliasX)->_VEND2               ,;
                            (cAliasX)->_VEND3               ,;
                            (cAliasX)->_VEND4               ,;
                            (cAliasX)->_VEND5               ,;
                            (cAliasX)->_COMIS1              ,;
                            (cAliasX)->_COMIS2              ,;
                            (cAliasX)->_COMIS3              ,;
                            (cAliasX)->_COMIS4              ,;
                            (cAliasX)->_COMIS5              ,;
                            (cAliasX)->_FRETE               ,;
                            (cAliasX)->_TPFRETE             ,;
                            (cAliasX)->_SEGURO              ,;
                            (cAliasX)->_TABELA              ,;
                            Val((cAliasX)->_VOLUME1)        ,;
                            (cAliasX)->_ESPECI1             ,;
                            (cAliasX)->_MOEDA               ,;
                            (cAliasX)->_REAJUST             ,;
                            (cAliasX)->_BANCO               ,;
                            (cAliasX)->_ACRSFIN              ;
                            }
    nPesLiq := 0
    aPedCli := {}


    cPedido    := (cAliasX)->_NUM
    aC5Rodape  := {}

    aadd(aC5Rodape,{    Val((cAliasX)->_PBRUTO);
                       ,Val((cAliasX)->_PESOL);
                       ,0;
                       ,0;
                       ,0;
                       ,0;
                       ,(cAliasX)->_MENNOTA})

    dbSelectArea(cAliasX)

    For nY := 1 to Len(aFisGetSC5)
        If !Empty(&(aFisGetSC5[ny][2]))
            If aFisGetSC5[ny][1] == "NF_SUFRAMA"
                MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
            Else
                MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
            Endif
        EndIf
    Next nY

    While (cAliasX)->(!EOF())
        cNfOri     := Nil
        cSeriOri   := Nil
        nRecnoSD1  := Nil
        nDesconto  := 0
        dbSelectArea('SCK')

        //�Calcula o preco de lista                     �
        nValMerc  := (cAliasX)->_VALOR
        nPrcLista := (cAliasX)->_PRUNIT

        If ( nPrcLista == 0 )
            nPrcLista := NoRound(nValMerc/(cAliasX)->_QTDVEN,TamSX3("CK_PRCVEN")[2])
        EndIf

        nAcresFin := A410Arred((cAliasX)->_PRCVEN * (cAliasX)->_ACRSFIN/100,"D2_PRCVEN")
        nValMerc  += A410Arred((cAliasX)->_QTDVEN * nAcresFin,"D2_TOTAL")
        nDesconto := a410Arred(nPrcLista*(cAliasX)->_QTDVEN,"D2_DESCON") - nValMerc
        nDesconto := IIf(nDesconto==0,(cAliasX)->_VALDESC,nDesconto)
        nDesconto := Max(0,nDesconto)
        nTotValdesc += nDesconto
        nPrcLista += nAcresFin
        nValMerc  += nDesconto

        MaFisAdd(   (cAliasX)->_PRODUTO           ,;  // 1-Codigo do Produto ( Obrigatorio )
                    (cAliasX)->_TES               ,;  // 2-Codigo do TES ( Opcional )
                    (cAliasX)->_QTDVEN            ,;  // 3-Quantidade ( Obrigatorio )
                    nPrcLista                       ,;  // 4-Preco Unitario ( Obrigatorio )
                    nDesconto                       ,;  // 5-Valor do Desconto ( Opcional )
                    cNfOri                          ,;  // 6-Numero da NF Original ( Devolucao/Benef )
                    cSeriOri                        ,;  // 7-Serie da NF Original ( Devolucao/Benef )
                    nRecnoSD1                       ,;  // 8-RecNo da NF Original no arq SD1/SD2
                    0                               ,;  // 9-Valor do Frete do Item ( Opcional )
                    0                               ,;  // 10-Valor da Despesa do item ( Opcional )
                    0                               ,;  // 11-Valor do Seguro do item ( Opcional )
                    0                               ,;  // 12-Valor do Frete Autonomo ( Opcional )
                    nValMerc                        ,;  // 13-Valor da Mercadoria ( Obrigatorio )
                    0                               ,;  // 14-Valor da Embalagem ( Opiconal )
                    0                               ,;  // 15-RecNo do SB1
                    0                               )   // 16-RecNo do SF4



        aadd(aItemPed,  {   (cAliasX)->_ITEM                    ,;
                            (cAliasX)->_PRODUTO                 ,;
                            (cAliasX)->_DESCRI                  ,;
                            (cAliasX)->_TES                     ,;
                            (cAliasX)->_CF                      ,;
                            (cAliasX)->_UM                      ,;
                            (cAliasX)->_QTDVEN                  ,;
                            (cAliasX)->_PRCVEN                  ,;
                            (cAliasX)->_NOTA                    ,;
                            (cAliasX)->_SERIE                   ,;
                            (cAliasX)->_CLIENTE                 ,;
                            (cAliasX)->_LOJA                    ,;
                            (cAliasX)->_VALOR                   ,;
                            (cAliasX)->_ENTREG                  ,;
                            (cAliasX)->_LOCAL                   ,;
                            Val((cAliasX)->_QTDEMP)             ,;
                            Val((cAliasX)->_QTDLIB)             ,;
                            Val((cAliasX)->_QTDENT)             ,;
                            })

//                            (cAliasX)->_DESCONT                 ,;
		//                          (cAliasX)->_XACRESC					,;

        //�Forca os valores de impostos que foram informados no SC6.
        dbSelectArea('SCK')
        For nY := 1 to Len(aFisGet)
            If !Empty(&(aFisGet[ny][2]))
                MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
            EndIf
        Next nY

        //�Calculo do ISS                               �
        SF4->(dbSetOrder(1))
        SF4->(MsSeek(xFilial("SF4")+(cAliasX)->_TES))

        If (cAliasX)->_INCISS == "N" .And. (cAliasX)->_TIPO == "N"
            If ( SF4->F4_ISS=="S" )
                nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
                MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
            EndIf
        EndIf

        //�Altera peso para calcular frete              �
        SB1->(dbSetOrder(1))
        SB1->(MsSeek(xFilial("SB1")+(cAliasX)->_PRODUTO))

        MaFisAlt("IT_PESO",(cAliasX)->_QTDVEN * SB1->B1_PESO,Len(aItemPed))
        MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
        MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))


        (cAliasX)->(dbSkip())
    EndDo

    MaFisAlt("NF_FRETE"   ,nFrete)
    MaFisAlt("NF_SEGURO"  ,nSeguro)
    MaFisAlt("NF_AUTONOMO",nFretAut)
    MaFisAlt("NF_DESPESA" ,nDespesa)

    If nDescCab > 0
        MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
    EndIf

    If nPDesCab > 0
        MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
    EndIf

    (cAliasX)->(DbGoTop())
Return

//+----------------------------------------------------------------------------------------------------------------------------
Static Function FisGetInit(aFisGet,aFisGetSC5)
    Local cValid      := ""
    Local cReferencia := ""
    Local nPosIni     := 0
    Local nLen        := 0

    If aFisGet == Nil
        aFisGet := {}
        dbSelectArea("SX3")
        dbSetOrder(1)
        MsSeek("SCK")
        While !Eof().And.X3_ARQUIVO=="SCK"
            cValid := UPPER(X3_VALID+X3_VLDUSER)
            If 'MAFISGET("'$cValid
                nPosIni     := AT('MAFISGET("',cValid)+10
                nLen        := AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
                cReferencia := Substr(cValid,nPosIni,nLen)
                aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
            EndIf
            If 'MAFISREF("'$cValid
                nPosIni     := AT('MAFISREF("',cValid) + 10
                cReferencia :=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
                aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
            EndIf
            dbSkip()
        EndDo
        aSort(aFisGet,,,{|x,y| x[3]<y[3]})
    EndIf

    If aFisGetSC5 == Nil
        aFisGetSC5  := {}
        dbSelectArea("SX3")
        dbSetOrder(1)
        MsSeek("SCJ")
        While !Eof().And.X3_ARQUIVO=="SCJ"
            cValid := UPPER(X3_VALID+X3_VLDUSER)
            If 'MAFISGET("'$cValid
                nPosIni     := AT('MAFISGET("',cValid)+10
                nLen        := AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
                cReferencia := Substr(cValid,nPosIni,nLen)
                aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
            EndIf
            If 'MAFISREF("'$cValid
                nPosIni     := AT('MAFISREF("',cValid) + 10
                cReferencia :=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
                aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
            EndIf
            dbSkip()
        EndDo
        aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
    EndIf
    MaFisEnd()
Return(.T.)

//+----------------------------------------------------------------------------------------------------------------------------
