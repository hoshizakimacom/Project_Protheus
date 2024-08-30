#INCLUDE 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'

//+------------------------------------------------------------------------------------------------------------------------------------------------------
//| Relatório PV
//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05R03(nTpImpr)

Private lImprVlr := nTpImpr == 1

FWMsgRun(, {|| U_M05R03A(.F.) },,'Gerando relatório...')

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05R03A(lAuto)

    Local oPrinter       := Nil
    //Local _oBrush      := TBrush():New( , RGB( 240 ,240 ,240))
    Local oFont14B       := Nil
    Local oFont12        := Nil
    Local oFont12B       := Nil
    Local oFont18T       := Nil
    Local oFont9         := Nil
    Local nRow           := -0080
    Local cData          := DtoC(Date()) + ' ' + Time()
    //Local _cAliasSA1   := GetNextAlias()
    //Local _cNumOrc     := SC5->C5_NUM
    //Local _lOk         := .T.
    Local nPage          := 1
    //Local nRowStep     := 45
    Local cFilePDF       := 'PV' + SC5->C5_NUM + ".pdf" // '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":","") + ".pdf"
    Local cPathInServer  := ""
    Local cBarra         := if(isSrvUnix(),"/","\")

    If lAuto
        cPathInServer  := cBarra + "temp" + cBarra
    
        If File(cPathInServer+cFilePDF) //Apaga arquivo gerado anteriormente para criar um novo
            FERASE(cPathInServer+cFilePDF)
        EndIf
    EndIf

    M05RFont(@oFont9,@oFont12,@oFont12B,@oFont14B,@oFont18T)

    oPrinter := FWMsPrinter():New( cFilePDF /*< cFilePrintert >*/, IMP_PDF/*[ nDevice]*/, .T./*[ lAdjustToLegacy]*/,;
                   cPathInServer/*[ cPathInServer]*/, .T./*[ lDisabeSetup ]*/, /*[ lTReport]*/, /*[ @oPrintSetup]*/,;
                /*[ cPrinter]*/, IIF(lAuto,.T.,.F.) /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, IIF(lAuto,.F.,.T.) /*[ lViewPDF]*/,;
                /*[ nQtdCopy]*/ )

    oPrinter:SetResolution(78)
    oPrinter:SetLandscape()
    oPrinter:SetMargin(0,0,0,0)
    If lAuto
        oPrinter:lServer := .T.
        oPrinter:nDevice := IMP_PDF
        oPrinter:cPathPDF := cPathInServer
    EndIf
    oPrinter:StartPage()


    //+----------------------------------------------------------------------------------------
    // Cabeçalho 1 - Dados Macom
    //+----------------------------------------------------------------------------------------
  
    MR05Cab1(oPrinter,oFont14B,oFont12,@nRow)

    If MR05Posiciona()

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 2 - Dados do Cliente
        //+----------------------------------------------------------------------------------------
        MR05Cab2(oPrinter,oFont12,oFont18T,@nRow)

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 3 - Dados do Contato - NÃO IMPLEMENTADO
        //+----------------------------------------------------------------------------------------
        MR05Cab3(oPrinter,oFont12,@nRow)

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 3 - Dados do Orçamento
        //+----------------------------------------------------------------------------------------
        MR05Cab4(oPrinter,oFont12,oFont14B,oFont18T,@nRow)

        //+----------------------------------------------------------------------------------------
        // Corpo do Orçamento
        //+----------------------------------------------------------------------------------------
        MaFisEnd()

        M05RIItens(oPrinter,oFont9,oFont12,oFont12B,@nRow,@nPage,cData)


        //+----------------------------------------------------------------------------------------
        // Rodapé
        //+----------------------------------------------------------------------------------------
        MR05Rod(oPrinter,oFont12,oFont12B,oFont14B,nRow,nPage,cData)

        MaFisEnd()
        oPrinter:EndPage()
        oPrinter:Print()
        FreeObj(oPrinter)

        //+----------------------------------------------------------------------------------------
        // Condições Gerais
        //+----------------------------------------------------------------------------------------
    EndIf
Return cFilePDF

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RICabIt(oPrinter,oFont12B,nRow)
    Local nRowStep      := 45

    nRow += nRowStep

    oPrinter:Box(nRow,0100,nRow + nRowStep * 2.5,3200)
//  oPrinter:Box(nRow,0100,nRow + nRowStep * 2,0200)                        // SQ
    oPrinter:Box(nRow,0185,nRow + nRowStep * 2.5,0403)                      // Item
//  oPrinter:Box(nRow,0400,nRow + nRowStep * 2,0700)                        // Código
    oPrinter:Box(nRow,0650,nRow + nRowStep * 2.5,1250)                      // Descrição
//  oPrinter:Box(nRow,1200,nRow + nRowStep * 2,1400)                        // NCM
    oPrinter:Box(nRow,1400,nRow + nRowStep * 2.5,1500)                      // QTD

    If lImprVlr
        //  oPrinter:Box(nRow,1500,nRow + nRowStep * 2,1700)                    // VALOR UNITÝRIO

        oPrinter:Box(nRow,1700,nRow + nRowStep * 2.5,1950)                      // IPI
        oPrinter:Box(nRow,1700,nRow + nRowStep * 1.25,1950)                     // IPI
        oPrinter:Box(nRow + nRowStep * 1.25,1700,nRow + nRowStep * 2.5,1770)    // IPI

        //  oPrinter:Box(nRow,1950,nRow + nRowStep * 2,2200)                    // ICMS
        oPrinter:Box(nRow,1950,nRow + nRowStep * 1.25,2200)                     // ICMS
        oPrinter:Box(nRow + nRowStep * 1.25,1950,nRow + nRowStep * 2.5,2020)    // ICMS

        oPrinter:Box(nRow,2200,nRow + nRowStep * 2.5,2450)                      // PIS/COFINS
        oPrinter:Box(nRow,2200,nRow + nRowStep * 1.25,2450)                     // PIS/COFINS
        oPrinter:Box(nRow + nRowStep * 1.25,2200,nRow + nRowStep * 2.5,2270)    // PIS/COFINS

        //  oPrinter:Box(nRow,2450,nRow + nRowStep * 2,2700)                    // VALOR ICMS ST
        oPrinter:Box(nRow,2700,nRow + nRowStep * 2.5,2950)                      // VALOR UNITARIO C/ IMPOSTOS
        //  oPrinter:Box(nRow,2950,nRow + nRowStep * 2,3200)                    // VALOR TOTAL

    Else
        oPrinter:Box(nRow,0650,nRow + nRowStep * 2.5,2900)                      // Descrição
        //  oPrinter:Box(nRow,1200,nRow + nRowStep * 2,1400)                    // NCM
        oPrinter:Box(nRow,3050,nRow + nRowStep * 2.5,3200)                      // QTD

    EndIf

    nRow += nRowStep
    oPrinter:Say(nRow                ,0115                ,'ITEM'          ,oFont12B)
    oPrinter:Say(nRow                ,0250                ,'PLANTA'        ,oFont12B)
    oPrinter:Say(nRow                ,0480                ,'CÓDIGO'        ,oFont12B)
    oPrinter:Say(nRow                ,0850                ,'DESCRIÇÃO'     ,oFont12B)

    If lImprVlr

        oPrinter:Say(nRow                ,1280                ,'NCM'           ,oFont12B)
        oPrinter:Say(nRow                ,1420                ,'QTD'           ,oFont12B)

        oPrinter:Say(nRow                ,1550                ,'VALOR'         ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,1540                ,'UNITÝRIO'      ,oFont12B)

        oPrinter:Say(nRow                ,1800                ,'IPI'            ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,1720                ,'%'              ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,1810                ,'VALOR'          ,oFont12B)

        oPrinter:Say(nRow                ,2040                ,'ICMS'           ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,1970                ,'%'              ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,2060                ,'VALOR'          ,oFont12B)

        oPrinter:Say(nRow                ,2260                ,'PIS/COFINS'     ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,2220                ,'%'              ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,2300                ,'VALOR'          ,oFont12B)

        oPrinter:Say(nRow                ,2490                ,'VALOR ICMS'     ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,2540                ,'ST'             ,oFont12B)

        oPrinter:Say(nRow                ,2750                ,'VALOR UNIT'     ,oFont12B)
        oPrinter:Say(nRow + nRowStep     ,2750                ,'C/IMPOSTOS'     ,oFont12B)

        oPrinter:Say(nRow                ,2980                ,'VALOR TOTAL'     ,oFont12B)
    
    else
    
        oPrinter:Say(nRow                ,2950                ,'NCM'           ,oFont12B)   // teste
        oPrinter:Say(nRow                ,3100                ,'QTD'           ,oFont12B)   // teste
    
    EndIf

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RIItens(oPrinter,oFont9,oFont12,oFont12B,nRow,nPage,cData)
    Local nRowStep      := 45
    Local _cAlias       := GetNextAlias()
    Local nItem         := 0
    Local _nTotal       := 0

    M05RICabIt(oPrinter,oFont12B,@nRow)

 // MR05GetValue(@_cAlias)
    MR05Planil(SC5->C5_NUM,@_cAlias,@_nTotal)

     nRow += nRowStep + 10

    (_cAlias)->(DbGoTop())

    While (_cAlias)->(!EOF())
        nItem++
        MR05ImpItem(_cAlias,oPrinter,@nRow,oFont9,oFont12B,nItem)

        MR05EndPag(oPrinter,oFont12,oFont12B,@nRow,nRowStep,@nPage,cData,nItem,_nTotal)

        (_cAlias)->(DbSkip())
    EndDo
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05ImpItem(_cAlias,oPrinter,nRow,oFont9,oFont12B,nItem)

    Local nRowStep      := 45
    Local cPicVal       := "@E 99,999,999.99"
    Local cPicAliq      := "@E 999.99"
    //Local cPicQtd       := "@E 999999.99"
    Local aDesc         := M05RDescr(AllTrim((_cAlias)->_PRODUTO),IIF(Empty((_cAlias)->B5_CEME),"PRODUTO SEM COMPLEMENTO",AllTrim((_cAlias)->B5_CEME)), AllTrim((_cAlias)->_DESCRI),(_cAlias)->B5_COMPRLC,(_cAlias)->B5_LARGLC,(_cAlias)->B5_ALTURLC,(_cAlias)->_ITEM)
    Local nDesc         := 1

    oPrinter:Box(nRow,0100,nRow + (nRowStep * 1.25 * Len(aDesc)),3200)                     // SQ
    oPrinter:Box(nRow,0185,nRow + (nRowStep * 1.25 * Len(aDesc)),0403)                     // Item


    If lImprVlr
        oPrinter:Box(nRow,0650,nRow + (nRowStep * 1.25 * Len(aDesc)),1250)                     // Descrição
        oPrinter:Box(nRow,1400,nRow + (nRowStep * 1.25 * Len(aDesc)),1500)                     // QTD
    Else
       oPrinter:Box(nRow,0650,nRow + (nRowStep * 1.25 * Len(aDesc)),2900)                     // Descrição
       oPrinter:Box(nRow,3050,nRow + (nRowStep * 1.25 * Len(aDesc)),3200)                     // QTD
    EndIf

    If lImprVlr

        oPrinter:Box(nRow,1700,nRow + (nRowStep * 1.25 * Len(aDesc)),1950)                     // IPI %
        oPrinter:Box(nRow,1700,nRow + (nRowStep * 1.25 * Len(aDesc)),1770)                     // IPI Valor
        oPrinter:Box(nRow,1950,nRow + (nRowStep * 1.25 * Len(aDesc)),2200)                     // ICMS %
        oPrinter:Box(nRow,1950,nRow + (nRowStep * 1.25 * Len(aDesc)),2020)                     // ICMS
        oPrinter:Box(nRow,2200,nRow + (nRowStep * 1.25 * Len(aDesc)),2450)                     // PIS/COFINS %
        oPrinter:Box(nRow,2200,nRow + (nRowStep * 1.25 * Len(aDesc)),2270)                     // PIS/COFINS
        oPrinter:Box(nRow,2700,nRow + (nRowStep * 1.25 * Len(aDesc)),2950)                     // VALOR UNITARIO C/ IMPOSTOS
    EndIf

    nRow += nRowStep

    oPrinter:Say(nRow - 0008                ,0125                ,(_cAlias)->_ITEM                                                                                                            ,oFont9)    // SQ
    oPrinter:Say(nRow - 0008                ,0190                ,SubStr(AllTrim((_cAlias)->_XITEMP),1,15)                                                                                    ,oFont9)    // ITEM
    oPrinter:Say(nRow - 0008                ,0415                ,(_cAlias)->_PRODUTO                                                                                                         ,oFont9)    // CÓDIGO
   
    If lImprVlr
        oPrinter:Say(nRow - 0008                ,1267                ,Transform((_cAlias)->B1_POSIPI,"@R 9999.99.99")                                                                             ,oFont9)    // NCM
        oPrinter:Say(nRow - 0008                ,1414                ,Transform(NoRound(MaFisRet(nItem,"IT_QUANT")   ,2),"@E 999999.99")                                                          ,oFont9)    // QTD
 
        oPrinter:Say(nRow - 0008                ,1540                ,Transform(NoRound(MaFisRet(nItem,"IT_PRCUNI"),2),cPicVal)                                                              ,oFont9)    // VALOR UNITÝRIO
        oPrinter:Say(nRow - 0008                ,1709                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQIPI"),2),cPicAliq)                                                          ,oFont9)    // % IPI
        oPrinter:Say(nRow - 0008                ,1810                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALIPI"),2),cPicVal)                                                            ,oFont9)    // VALOR IPI
        //oPrinter:Say(nRow - 0008                ,1954                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQICM"),2),cPicAliq)                                                        ,oFont9)    // % ICMS
        oPrinter:Say(nRow - 0008                ,1918                ,Transform(NoRound((_cAlias)->_XALQICM  ,2), cPicVal)                                                                   ,oFont9)    // % ICMS
        oPrinter:Say(nRow - 0008                ,2050                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALICM"),2),cPicVal)                                                            ,oFont9)    // VALOR ICMS
        oPrinter:Say(nRow - 0008                ,2210                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQPS2") + MaFisRet( nItem ,"IT_ALIQCF2"),2),cPicAliq)                         ,oFont9)    // % PIS/COFINS
        oPrinter:Say(nRow - 0008                ,2290                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALPS2") + MaFisRet( nItem ,"IT_VALCF2"),2),cPicVal)                            ,oFont9)    // VALOR PIS/COFINS
        oPrinter:Say(nRow - 0008                ,2550                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALSOL"),2),cPicVal)                                                            ,oFont9)    // VALOR ICMS ST
        oPrinter:Say(nRow - 0008                ,2780                ,Transform(NoRound((MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_DESPESA") ) )  / (_cAlias)->_QTDVEN,2) ,cPicVal)                                  ,oFont9)    // VALOR UNIT C/ IMPOSTOS
        oPrinter:Say(nRow - 0008                ,3010                ,Transform(NoRound(MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_DESPESA") ),2) ,cPicVal)                                                            ,oFont12B)  // VALOR TOTAL
    Else
    
        oPrinter:Say(nRow - 0008                ,2925                ,Transform((_cAlias)->B1_POSIPI,"@R 9999.99.99")                                                                             ,oFont9)    // NCM
        oPrinter:Say(nRow - 0008                ,3050                ,Transform(NoRound(MaFisRet(nItem,"IT_QUANT")   ,2),"@E 999999.99")                                                          ,oFont9)    // QTD

    EndIf

    For nDesc := 1 to Len(aDesc)
         oPrinter:Say(nRow - 0008               ,0660                ,aDesc[nDesc]     ,oFont9)     // DESCRIÇÃO

        nRow += nRowStep

    Next

    nRow -= nRowStep
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RDescr(cProd,cDescSB1,cDescSC6,nComp,nLar,nAlt,cItem)

    Local aRet      := {}
    Local cAux      := ""
    Local cLetras   := ""
    Local cRet      := ""
    Local i         := 0
    Local nTam      := 45
    Local nIni      := 1
    Local nQuebra   := 1
    Local cPic      := "@E 999999"

    If !lImprVlr
    
        nTam      := nTam * 3.5
    
    ENDIF

    If cProd == 'N/A'
        cDesc   := cDescSC6
    Else
        cDesc   := cDescSB1

        If nComp > 0 .And. nLar > 0 .And. nAlt > 0
            cDesc += ' - MEDINDO: ' + AllTrim(Transform(nComp,cPic)) + ' X ' + AllTrim(Transform(nLar,cPic)) + ' X ' + AllTrim(Transform(nAlt,cPic))
        EndIf
    EndIf
    
    //Tratamento para descrição FINAME
    If SC5->C5_XFINAME == "1"
    	cFiname 	:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_XFINAME")
    	cSerMacom	:= Posicione("ZA0",1,xFilial("ZA0")+SC5->C5_NUM+cItem,"ZA0_SERIE")
    	cDesc		:= "Cod.Finame:" + cFiname + " | " + "Nr.Serie:" + cSerMacom + " | " + cDesc
    Endif

    // Retira enter da descrição
    Replace( cDesc , chr(13) ," ")

    // Retira espaçoes duplicados
    For i := 1 to Len( cDesc ) - 1
        cLetras := Substr( cDesc , i , 2 )

        If cLetras <> "  "
            cRet += Left(cLetras,1)
        EndIf
    Next

    If i > 0 .and. cLetras <> "  "
        cRet += Right(cLetras,1)
    EndIf

    cDesc := cRet

    While Len(cDesc) > 0
        cAux    := SubString(cDesc,1,nTam)       // Quebra linha

        If nTam <= Len(cDesc)
            nQuebra := Rat(" ",cAux)                    // Tamanho da quebra

            AAdd(aRet, SubString(cDesc,1,nQuebra) )
        Else
            AAdd(aRet, cDesc )
            Exit
        EndIf

        nIni    := nQuebra++
        cDesc   := SubString(cDesc,nIni,Len(cDesc))
    EndDo
Return AClone(aRet)

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Posiciona()
    Local lRet  := .T.

    If !SC5->C5_TIPO $ "DB"
        SA1->(DbSetOrder(1))
        SA1->(DbGoTop())

        If !SA1->(DbSeek( xFilial('SA1')  + SC5->(C5_CLIENTE + C5_LOJACLI)))
            MsgInfo(I18N('Não foram encontrados dados do cliente #1 loja #2.' + CRLF + 'Verifique.',{SC5->C5_CLIENTE,SC5->C5_LOJACLI}),"Atenção")
            lRet := .F.
        EndIf
    Else
        SA2->(DbSetOrder(1))
        SA2->(DbGoTop())

        If !SA2->(DbSeek( xFilial('SA2')  + SC5->(C5_CLIENTE + C5_LOJACLI)))
            MsgInfo(I18N('Não foram encontrados dados do Fornecedor #1 loja #2.' + CRLF + 'Verifique.',{SC5->C5_CLIENTE,SC5->C5_LOJACLI}),"Atenção")
            lRet := .F.
        EndIf
    EndIf

    If lRet
        SA3->(DbSetOrder(1))
        SA3->(DbGoTop())

        If !SA3->(DbSeek( xFilial('SA3') + SC5->C5_VEND1 ))
            MsgInfo(I18N('Não foram encontrados dados do vendedor #1' + CRLF + 'Verifique.',{SC5->C5_VEND1}),"Atenção")
            lRet := .F.
        EndIf
    EndIf

Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RFont(oFont9,oFont12,oFont12B,oFont14B,oFont18T)
    oFont9      := TFont():New('Arial',,9)
    oFont12     := TFont():New('Arial',,12)
    oFont12B    := TFont():New('Arial',,12,.T.,.T.)
    oFont14B    := TFont():New('Arial',,14,.T.,.T.)
    oFont18T    := TFont():New('Arial',,18,.T.,.T.)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Cab1(oPrinter,oFont14B,oFont12,nRow)
    Local cNome         := 'AÇOS MACOM INDÚSTRIA E COMERCIO LTDA'
    Local cEndC         := 'Av Julia Gaiolli, 474, Bonsucesso, Guarulhos-SP, CEP 07251-500'
    Local cCGC          := 'CNPJ: 43.553.668/0001-79 I.E.: 336.179.661.113'
    Local cTel          := 'Telefone: 55 11 2085-7000'
    Local cMail         := 'www.acosmacom.com.br'
    Local nRowStep      := 45
    Local nSizecNome
    Local nSizecEndC
    Local nSizecCGC
    Local nSizecTel
    Local nSizecMail       
    //#Define PAD_JUSTIFY 3

   If cFilAnt <> "01"
        //cNome         := AllTrim(SM0->M0_NOMECOM)
        cEndC         := Capital(AllTrim(SM0->M0_ENDENT)+", "+AllTrim(SM0->M0_BAIRENT)+", "+AllTrim(SM0->M0_CIDENT))+"-"+AllTrim(SM0->M0_ESTENT)+", CEP "+Left(SM0->M0_CEPENT,5)+"-"+SubStr(SM0->M0_CEPENT,6,3)
        cCGC          := "CNPJ: "+SM0->M0_CGC+" I.E.: "+AllTrim(SM0->M0_INSC)
        cTel          := "Telefone: "+SM0->M0_TEL
    EndIf

    nSizecNome := oPrinter:GetTextWidth(cNome, oFont14B)
    nSizecEndC := oPrinter:GetTextWidth(cEndC, oFont12)
    nSizecCGC := oPrinter:GetTextWidth(cCGC, oFont12)
    nSizecTel := oPrinter:GetTextWidth(cTel, oFont12)
    nSizecMail := oPrinter:GetTextWidth(cMail, oFont12)
    
    oPrinter:SayBitmap(nRow ,0100,GetSrvProfString("Startpath","") + 'LOGO_M05R02.BMP', 751 ,178 )
    //MSGSTOP( nSizecNome) //906
    //MSGSTOP( nSizecEndC) //1218
    //MSGSTOP( nSizecCGC) //912
    //MSGSTOP( nSizecTel) //501
    //MSGSTOP( nSizecMail) //480

    oPrinter:Say(nRow                 ,2100 , cNome     ,oFont14B) //3520
    oPrinter:Say(nRow += nRowStep     ,2100 , cEndC     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100 , cCGC      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100 , cTel      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100 , cMail     ,oFont12)
    
    //oPrinter:SayAlign(nRow,                 3620,   cNome, oFont14B,  (3220 - 1000),  015, , PAD_JUSTIFY,  )
    //oPrinter:SayAlign(nRow,                 3620,   cEndC,  oFont12,  (3620 - nSizecEndC),  015, , PAD_JUSTIFY,  )


    //oPrinter:SayAlign(nRow,                 3620,   cNome   ,oFont14B    ,nSizecNome    ,CLR_BLACK, 0,  1)
    //oPrinter:SayAlign(nRow += nRowStep,     3620,   cEndC   ,oFont12     ,nSizecEndC    ,CLR_BLACK, 0,  1)
    //oPrinter:SayAlign(nRow += nRowStep,     3620,   cCGC    ,oFont12     ,nSizecCGC     ,CLR_BLACK, 0,  1)
    //oPrinter:SayAlign(nRow += nRowStep,     3620,   cTel    ,oFont12     ,nSizecTel     ,CLR_BLACK, 0,  1)
    //oPrinter:SayAlign(nRow += nRowStep,     3620,   cMail   ,oFont12     ,nSizecMail    ,CLR_BLACK, 0,  1)

    nRow += nRowStep
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Cab2(oPrinter,oFont12,oFont18T,nRow)
    Local lRet          := .T.
    Local cMascCPF      := "@R 999.999.999-99"
    Local cMascCNPJ     := "@R 99.999.999/9999-99"
    Local nRowStep      := 45

    If lRet
        nRow += nRowStep

        If !SC5->C5_TIPO $ "DB"
            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA1->A1_NOME))     ,oFont18T)      // Cliente
            oPrinter:Say(nRow                 ,1700    , 'CNPJ/CPF: '                     ,oFont12)
            oPrinter:Say(nRow                 ,1900    , Transform( AllTrim(SA1->A1_CGC), IIF(SA1->A1_PESSOA == 'F',cMascCPF,cMascCNPJ))     ,oFont12)

            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA1->A1_END)) + IIF(!Empty(SA1->A1_COMPLEM), " - " + SA1->A1_COMPLEM,"")     ,oFont12)
            oPrinter:Say(nRow                 ,1700    , 'IE.: '                         ,oFont12)
            oPrinter:Say(nRow                 ,1900    , Transform( AllTrim(SA1->A1_INSCR), "@R 999.999.999.999" ) ,oFont12)
            oPrinter:Say(nRow                 ,2700    , 'GUARULHOS, ' + MR05Date() ,oFont12)

            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA1->A1_BAIRRO)) + ' - ' + Upper(AllTrim(SA1->A1_MUN)) + ' - ' + Upper(AllTrim(SA1->A1_EST)) + ' - CEP: ' + Transform(AllTrim(SA1->A1_CEP), "@R 99999-999" ) ,oFont12)
            oPrinter:Say(nRow                 ,1700    , 'SUFRAMA.: '                   ,oFont12)
            oPrinter:Say(nRow                 ,1900    , SA1->A1_SUFRAMA                ,oFont12)
            oPrinter:Say(nRow                 ,2700    , 'REP.: ' + AllTrim(SA3->A3_NREDUZ) ,oFont12)
       Else
            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_NOME))     ,oFont18T)      // Cliente
            oPrinter:Say(nRow                 ,1700    , 'CNPJ/CPF: '                     ,oFont12)
            oPrinter:Say(nRow                 ,1900    , Transform( AllTrim(SA2->A2_CGC), cMascCNPJ)     ,oFont12)

            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_END)) + IIF(!Empty(SA2->A2_COMPLEM), " - " + SA2->A2_COMPLEM,"")     ,oFont12)
            oPrinter:Say(nRow                 ,1700    , 'IE.: '                         ,oFont12)
            oPrinter:Say(nRow                 ,1900    , Transform( AllTrim(SA2->A2_INSCR), "@R 999.999.999.999" ) ,oFont12)
            oPrinter:Say(nRow                 ,2700    , 'GUARULHOS, ' + MR05Date() ,oFont12)

            oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_BAIRRO)) + ' - ' + Upper(AllTrim(SA2->A2_MUN)) + ' - ' + Upper(AllTrim(SA2->A2_EST)) + ' - CEP: ' + Transform(AllTrim(SA2->A2_CEP), "@R 99999-999" ) ,oFont12)
            oPrinter:Say(nRow                 ,1700    , 'SUFRAMA.: '                   ,oFont12)
            oPrinter:Say(nRow                 ,1900    , ""                ,oFont12)
            oPrinter:Say(nRow                 ,2700    , 'REP.: ' + AllTrim(SA3->A3_NREDUZ) ,oFont12)
        EndIf


        nRow += nRowStep

        oPrinter:Line(nRow, 0100,nRow, 3200)
    EndIf
Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Cab3(oPrinter,oFont12,nRow)

Local nRowStep      := 45
Local cAliasCont    := GetNextAlias()
Local cEntidade     := 'SA1'
Local cCodEnt       := PadR(SC5->(C5_CLIENTE + C5_LOJACLI),TamSX3('AC8_CODENT')[1])
Local cPic1          := "@R 9999-99999"
Local cPic2          := "@R (999)"

BeginSql Alias cAliasCont
	SELECT U5_CODCONT,U5_CONTAT,U5_EMAIL,U5_FCOM1,U5_DDD,U5_CELULAR,UM_DESC
    FROM %Table:AC8% AC8
    LEFT JOIN %Table:SU5% SU5 ON SU5.%NotDel% AND U5_FILIAL = %xFilial:SU5% AND U5_CODCONT = AC8_CODCON
    INNER JOIN %Table:SUM% SUM ON SUM.%NotDel% AND UM_FILIAL = %xFilial:SUM% AND UM_CARGO = U5_FUNCAO
    WHERE AC8_ENTIDA = %Exp:cEntidade%
    AND AC8.%NotDel%
    AND AC8_FILIAL = %xFilial:AC8%
    AND AC8_CODENT = %Exp:cCodEnt%
EndSql
If Empty(SC5->C5_XCONT) .And. Empty(SC5->C5_XCONT2) .And. Empty(SC5->C5_XCONT3) .And. Empty(SC5->C5_XCONT4) .And. Empty(SC5->C5_XCONT5)  
    If (cAliasCont)->(!EOF())
        While (cAliasCont)->(!EOF())

            oPrinter:Say(nRow += nRowStep     ,0100    , 'CONTATO: '                                ,oFont12)
            oPrinter:Say(nRow                 ,0260    , AllTrim((cAliasCont)->U5_CONTAT)           ,oFont12)

            oPrinter:Say(nRow                 ,0820    , Upper(AllTrim((cAliasCont)->UM_DESC))      ,oFont12)

            oPrinter:Say(nRow                 ,1360    , Upper(AllTrim((cAliasCont)->U5_EMAIL))     ,oFont12)

            oPrinter:Say(nRow                 ,2120    , 'CELULAR: '                                ,oFont12)
            oPrinter:Say(nRow                 ,2300    , TransForm((cAliasCont)->U5_DDD,cPic2) + ' ' + TransForm((cAliasCont)->U5_CELULAR,cPic1)    ,oFont12)

            oPrinter:Say(nRow                 ,2700    , 'COMERCIAL: '                              ,oFont12)
            oPrinter:Say(nRow                 ,2900    , TransForm((cAliasCont)->U5_DDD,cPic2) + ' ' + TransForm((cAliasCont)->U5_FCOM1,cPic1)    ,oFont12)

			(cAliasCont)->(DbSkip())

        EndDo
    EndIf
Else
	While (cAliasCont)->(!EOF())
		If 	(cAliasCont)->U5_CODCONT == SC5->C5_XCONT .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT2 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT3 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT4 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT5  
            oPrinter:Say(nRow += nRowStep     ,0100    , 'CONTATO: '                                ,oFont12)
            oPrinter:Say(nRow                 ,0260    , AllTrim((cAliasCont)->U5_CONTAT)           ,oFont12)

            oPrinter:Say(nRow                 ,0820    , Upper(AllTrim((cAliasCont)->UM_DESC))      ,oFont12)

            oPrinter:Say(nRow                 ,1360    , Upper(AllTrim((cAliasCont)->U5_EMAIL))     ,oFont12)

            oPrinter:Say(nRow                 ,2120    , 'CELULAR: '                                ,oFont12)
            oPrinter:Say(nRow                 ,2300    , TransForm((cAliasCont)->U5_DDD,cPic2) + ' ' + TransForm((cAliasCont)->U5_CELULAR,cPic1)    ,oFont12)

            oPrinter:Say(nRow                 ,2700    , 'COMERCIAL: '                              ,oFont12)
            oPrinter:Say(nRow                 ,2900    , TransForm((cAliasCont)->U5_DDD,cPic2) + ' ' + TransForm((cAliasCont)->U5_FCOM1,cPic1)    ,oFont12)
        Endif
		(cAliasCont)->(DbSkip())
	End
Endif
	   
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Cab4(oPrinter,oFont12,oFont14B,oFont18T,nRow)
    Local nRowStep  := 45
    //Local oBrush    := TBrush():New( , RGB( 240 ,240 ,240))

    nRow += (nRowStep * 2)

    oPrinter:Line(nRow,0100,nRow, 3200)

    oPrinter:Say(nRow += nRowStep     ,0100    , 'PEDIDO DE VENDA: '       ,oFont12)
    oPrinter:Say(nRow                 ,0440    , SC5->C5_NUM        ,oFont14B)

    //oPrinter:Say(nRow += nRowStep     ,0100    , 'Data de Embarque: '       ,oFont12)
    //oPrinter:Say(nRow                 ,0440    , DtoC(SC5->C5_FECENT)    ,oFont12)

    oPrinter:Say(nRow                 ,1000    , 'CLIENTE/LOJA:'    ,oFont12)
    oPrinter:Say(nRow                 ,1250    , SC5->C5_CLIENTE + '/' + SC5->C5_LOJACLI        ,oFont12)

    oPrinter:Say(nRow                 ,1700    , 'REDE:'    ,oFont12)
    If !SC5->C5_TIPO $ "DB"
        oPrinter:Say(nRow             ,1800    , Posicione('SA1',1,xFilial('SA1') +SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_XREDE' ) + " - " + Posicione('ZA6',1,xFilial('ZA6') +SA1->A1_XREDE,'ZA6_DESC' )   ,oFont12)
    EndIf

    oPrinter:Say(nRow                 ,2700    , 'LOJA:'    ,oFont12)
    If !SC5->C5_TIPO $ "DB"
        oPrinter:Say(nRow             ,2900    , Posicione('SA1',1,xFilial('SA1') +SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_XIDLOJA' )        ,oFont12)
    EndIf


    oPrinter:Say(nRow += nRowStep     ,0100    , 'COND PAG (MEDIANTE ANÝLISE DE CRÉDITO): '       ,oFont12) // #6898


    oPrinter:Say(nRow                 ,800    , MR05GetCPg()       ,oFont12) //440

    oPrinter:Say(nRow += nRowStep     ,0100    ,'REFERÊNCIA:'     ,oFont12)
    oPrinter:Say(nRow                 ,0440    ,AllTrim(SC5->C5_XOBRAS)                 ,oFont12)

    nRow += (nRowStep * 0.50)
    oPrinter:Line(nRow, 0100,nRow, 3200)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Rod(oPrinter,oFont12,oFont12B,oFont14B,nRow,nPage,cData)
	Local aArea			:= {}
    Local nRowStep      := 45
    Local cPicVal       := "@E 99,999,999.99"
    //Local cPicAliq      := "@E 999.99"
    //Local cPicQtd       := "@E 999999.99"
    Local cDespesa      := Transfor(NoRound(MaFisRet(,"NF_DESPESA"),2),cPicVal)
    Local cFrete        := Transfor(NoRound(IIF(SC5->C5_TPFRETE == 'C',MaFisRet(,"NF_FRETE"),0),2),cPicVal)
    Local cTotal        := Transfor(NoRound(MaFisRet(,"NF_TOTAL"),2),"@E 9,999,999,999.99")
    Local cSubTot       := Transfor( NoRound(( MaFisRet(,"NF_TOTAL") - ( MaFisRet(,"NF_FRETE") + MaFisRet(,"NF_DESPESA") ) ),2),"@E 9,999,999,999.99")
    Local cMoeda        := AllTrim(GetMv('MV_MOEDA' + cValToChar(SC5->C5_MOEDA),,''))
    Local cPolitic      := 'A MACOM adota a política de proibição de oferta e/ou recebimento de presentes/brindes em transações comerciais, prezando por sua legitimidade, transparência e imparcialidade.'
    

    nRow += (nRowStep * 5)

    oPrinter:Say(nRow + 1200                ,0100        , cPolitic  ,oFont14b)
    
    If nRow > 1600
        nRow := 2100 + nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Pedido de Venda #1 impressa em #2.',{SC5->C5_NUM,cData })  ,oFont12)
        oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

        oPrinter:EndPage()
        oPrinter:StartPage()
        nRow := 0000

        nPage++
    EndIf

    oPrinter:Say(nRow += nRowStep     ,0100     ,'TIPO FRETE: '             ,oFont12)
    oPrinter:Say(nRow                 ,0300     ,M05RTpFret()               ,oFont12)

    If lImprVlr

        oPrinter:Line(nRow - nRowStep * 1.25, 2350,nRow - nRowStep* 1.25 , 3200)
        oPrinter:Say(nRow                 ,2450     ,'SUB-TOTAL (' + cMoeda + ')'        ,oFont12)
        oPrinter:Say(nRow                 ,2900     ,cSubTot                    ,oFont12)
    EndIf

    oPrinter:Say(nRow += nRowStep     ,0100     ,'INSTALAÇÃO: '             ,oFont12)
    oPrinter:Say(nRow                 ,0300     ,M05RTpIsnt()               ,oFont12)

    If lImprVlr
       oPrinter:Say(nRow                 ,2450     ,'VALOR FRETE: '            ,oFont12)
        oPrinter:Say(nRow                 ,2900     ,cFrete                     ,oFont12)

        oPrinter:Say(nRow += nRowStep     ,2450     ,'VALOR INSTALAÇÃO'         ,oFont12)
        oPrinter:Say(nRow                 ,2900     ,cDespesa                   ,oFont12)
    EndIf

    oPrinter:Say(nRow += nRowStep     ,0100     ,'PRAZO DE EMBARQUE: '       ,oFont12)
    oPrinter:Say(nRow				  ,0500		,SC5->C5_XPRZEMB			 ,oFont12)    
    nRow += nRowStep

   If lImprVlr
        oPrinter:Line(nRow - nRowStep * 0.5, 2350,nRow - nRowStep * 0.5, 3200)
        oPrinter:Say(nRow += (nRowStep )  ,2450     ,'TOTAL GERAL'              ,oFont14B)
        oPrinter:Say(nRow                 ,2900     ,cTotal                     ,oFont14B)
    EndIf

    nRow += nRowStep
    nRow += nRowStep
    oPrinter:Say(nRow += nRowStep     ,2450    , 'AÇOS MACOM INDÚSTRIA E COMERCIO LTDA'         ,oFont12B)

	aArea := SA3->(GetArea())
    oPrinter:Say(nRow += nRowStep     ,2450    , 'GERÊNCIA: ' + AllTrim(Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"SA3->A3_NOME"))          ,oFont12)

    nRow += nRowStep

	RestArea(aArea)
    oPrinter:Say(nRow += nRowStep     ,2450    , 'REPRESENTANTE COMERCIAL '                     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2450    , AllTrim(SA3->A3_NOME)                          ,oFont12)

    //oPrinter:Say(nRow += nRowStep     ,2450    , AllTrim(SA3->A3_NREDUZ),oFont12)

    oPrinter:Say(nRow += nRowStep     ,2450    , SA3->A3_DDDTEL + ' ' + Transform(AllTrim(SA3->A3_TEL), "@R 9999-99999" ) ,oFont12)


    nRow := 2100 + nRowStep

    oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Pedido de Venda #1 impressa em #2.',{SC5->C5_NUM,cData })  ,oFont12)
    oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

    oPrinter:EndPage()
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpFret()
    Local cRet  := ''

    Do Case
    Case SC5->C5_TPFRETE == 'C'
        cRet := 'CIF'
    Case SC5->C5_TPFRETE == 'F'
//        cRet := 'FOB (NÃO INCLUSO)'
        cRet := 'FOB (POR CONTA DO CLIENTE)'
    Case SC5->C5_TPFRETE == 'T'
        cRet := 'Por Conta de Terceiros'
    Case SC5->C5_TPFRETE == 'S'
        cRet := 'Sem Frete'
    Case SC5->C5_TPFRETE == 'E'
        cRet := 'Ex-Works'

    End Case
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpIsnt()
    Local cRet  := ''

    Do Case
    Case SC5->C5_XTPINST == '1'
        cRet := 'Sem Instalação'
    Case SC5->C5_XTPINST == '2'
//        cRet := 'Credenciada (Vide condições gerais de fornecimento)'
        cRet := 'Credenciada (Vide Credenciada Macom) - R$ '+Transform(SC5->C5_XVLRINS,"@E 99,999,999.99")
    Case SC5->C5_XTPINST == '3'
        cRet := 'Macom'
    Case SC5->C5_XTPINST == '4'
        cRet := 'Rateio no Produto'

    End Case
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05GetCPg()
    Local cRet  := ''

    SE4->(DbSetOrder(1))
    SE4->(DbGotop())

    If SE4->(DbSeek( xFilial('SE4') + SC5->C5_CONDPAG ))
        cRet := AllTrim(SE4->E4_CODIGO) + ': ' + AllTrim(SE4->E4_DESCRI) + ' - '  + AllTrim(SC5->C5_XDESPAG)
    EndIf
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Date()
    Local cDay  := StrZero(Day(SC5->C5_EMISSAO),2)   //StrZero(Day(Date()),2) -- Modelo Antigo
    Local nMon  := Month(SC5->C5_EMISSAO) 			 //Month(Date())		  -- Modelo Antigo
    Local cMon  := ''
    Local cYear := cValToChar(Year(SC5->C5_EMISSAO))

    Do Case
    Case nMon == 1
        cMon    := 'JANEIRO'
    Case nMon == 2
        cMon    := 'FEVEREIRO'
    Case nMon == 3
        cMon    := 'MARÇO'
    Case nMon == 4
        cMon    := 'ABRIL'
    Case nMon == 5
        cMon    := 'MAIO'
    Case nMon == 6
        cMon    := 'JUNHO'
    Case nMon == 7
        cMon    := 'JULHO'
    Case nMon == 8
        cMon    := 'AGOSTO'
    Case nMon == 9
        cMon    := 'SETEMBRO'
    Case nMon == 10
        cMon    := 'OUTUBRO'
    Case nMon == 11
        cMon    := 'NOVEMBRO'
    Case nMon == 12
        cMon    := 'DEZEMBRO'
    EndCase

    cRet := cDay + ' DE ' + cMon + ' DE ' +  cYear
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05EndPag(oPrinter,oFont12,oFont12B,nRow,nRowStep,nPage,cData,nItem,_nTotal)
    If nRow > 2000

        nRow := 2100 + nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Pedido de Venda #1 impressa em #2.',{SC5->C5_NUM,cData })  ,oFont12)
        oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

        oPrinter:EndPage()
        oPrinter:StartPage()
        nRow := 0000

        nPage++

        If nItem++ < _nTotal
            M05RICabIt(oPrinter,oFont12B,@nRow)
            nRow += nRowStep + 10
        EndIf
    EndIf
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function FisGetInit(aFisGet,aFisGetSC5)
    Local cValid      := ""
    Local cReferencia := ""
    Local nPosIni     := 0
    Local nLen        := 0

    If aFisGet == Nil
        aFisGet := {}
        dbSelectArea("SX3")
        dbSetOrder(1)
        MsSeek("SC6")
        While !Eof().And.X3_ARQUIVO=="SC6"
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
        MsSeek("SC5")
        While !Eof().And.X3_ARQUIVO=="SC5"
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

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Planil(cNum,cAliasPed,_nTotal)
//    Local nBaseIcm      := 0
//    Local nValIcm       := 0
//    Local nValIPI       := 0
//    Local nBaseRet      := 0
//    Local nValRet       := 0
//    Local nVlrTot       := 0
//    Local nBaseISS      := 0
//    Local vValISS       := 0
    Local nTotValdesc  := 0
    Local nC5Desc1      := 0
    Local nC5Desc2      := 0
    Local nC5Desc3      := 0
    Local nC5Desc4      := 0
    Local nC5Frete      := 0
    Local nC5Seguro     := 0
    Local nC5Despesa    := 0

//    Local cCondicao     := ""
//    Local aParcelas     := {}
    Local aPedCli       := {}
    Local aC5Rodape     := {}
    //Local aRelImp       := MaFisRelImp("MT100",{"SF2","SD2"})
    Local aFisGet       := Nil
    Local aFisGetSC5    := Nil
//    Local cKey          := ""
//    Local cAliasSC5     := "SC5"
    Local cAliasSC6     := "SC6"
    Local cQryAd        := ""
    Local cPedido       := ""
    Local cCliEnt       := ""
    Local cNfOri        := Nil
    Local cSeriOri      := Nil
    Local nDesconto     := 0
    Local nPesLiq       := 0
    Local nRecnoSD1     := Nil
//    Local nG            := 0
    Local nFrete        := 0
    Local nSeguro       := 0
    Local nFretAut      := 0
    Local nDespesa      := 0
    Local nDescCab      := 0
    Local nPDesCab      := 0
    Local nY            := 0
    Local nValMerc      := 0
    Local nPrcLista     := 0
    Local nAcresFin     := 0
//    Local nCont         := 0
    Local aItemPed      := {}
    Local aCabPed       := {}
//    Local nVlrtotal     := 0
//    Local nValSOL       := 0

    FisGetInit(@aFisGet,@aFisGetSC5)

    // Filtragem do relatório
    cQryAd := "%"
    For nY := 1 To Len(aFisGet)
        cQryAd += ","+aFisGet[nY][2]
    Next nY
    For nY := 1 To Len(aFisGetSC5)
        cQryAd += ","+aFisGetSC5[nY][2]
    Next nY
    cQryAd += "%"

    cAliasPed := cAliasSC6 := GetNextAlias()

//            ,SA1.A1_INCISS          AS _INCISS

    BeginSql Alias cAliasPed
        SELECT SC5.R_E_C_N_O_       AS REC_CAB
            ,SC6.R_E_C_N_O_         AS REC_ITEM
            ,SC5.C5_FILIAL          AS _FILIAL
            ,SC5.C5_NUM             AS _NUM
            ,SC5.C5_CLIENTE         AS _CLIENTE
            ,SC5.C5_LOJACLI         AS _LOJA
            ,SC5.C5_CLIENT          AS _CLIENT
            ,SC5.C5_LOJAENT         AS _LOJAENT
            ,SC5.C5_TIPO            AS _TIPO
            ,SC5.C5_TIPOCLI         AS _TIPOCLI
            ,SC5.C5_DESC1           AS _DESC1
            ,SC5.C5_DESC2           AS _DESC2
            ,SC5.C5_DESC3           AS _DESC3
            ,SC5.C5_DESC4           AS _DESC4
            ,SC5.C5_EMISSAO         AS _EMISSAO
            ,SC5.C5_CONDPAG         AS _CONDPAG
            ,SC5.C5_FRETE           AS _FRETE
            ,SC5.C5_DESPESA         AS _DESPESA
            ,SC5.C5_FRETAUT         AS _FRETAUT
            ,SC5.C5_TPFRETE         AS _TFRETE
            ,SC5.C5_SEGURO          AS _SEGURO
            ,SC5.C5_TABELA          AS _TABELA
            ,SC5.C5_MOEDA           AS _MOEDA
            ,SE4.E4_ACRSFIN         AS _ACRSFIN
            ,SC5.C5_VEND1           AS _VEND1
            ,SC5.C5_PDESCAB         AS _PDESCAB
            ,'N'                    AS _INSS
            ,SC6.C6_PRODUTO         AS _PRODUTO
            ,SC6.C6_TES             AS _TES
            ,' '                    AS _CF
            ,SC6.C6_QTDVEN          AS _QTDVEN
            ,SC6.C6_PRUNIT          AS _PRUNIT
            ,SC6.C6_VALDESC         AS _VALDESC
            ,SC6.C6_XALQICM         AS _XALQICM
            ,SC6.C6_VALOR           AS _VALOR
            ,SC6.C6_ITEM            AS _ITEM
            ,SC6.C6_XITEMP          AS _XITEMP
            ,SC6.C6_DESCRI          AS _DESCRI
            ,SC6.C6_UM              AS _UM
            ,SC6.C6_PRCVEN          AS _PRCVEN
            ,SC6.C6_ENTREG          AS _ENTREG
            ,SC6.C6_DESCONT         AS _DESCONT
            ,SC6.C6_LOCAL           AS _LOCAL
            ,SC5.C5_TRANSP          AS _TRANSP
            ,SC5.C5_VEND2           AS _VEND2
            ,SC5.C5_VEND3           AS _VEND3
            ,SC5.C5_VEND4           AS _VEND4
            ,SC5.C5_VEND5           AS _VEND5
            ,SC5.C5_COMIS1          AS _COMIS1
            ,SC5.C5_COMIS2          AS _COMIS2
            ,SC5.C5_COMIS3          AS _COMIS3
            ,SC5.C5_COMIS4          AS _COMIS4
            ,SC5.C5_COMIS5          AS _COMIS5
            ,SC5.C5_TPFRETE         AS _TPFRETE
            ,SC5.C5_PBRUTO          AS _PBRUTO
            ,SC5.C5_PESOL           AS _PESOL
            ,SC5.C5_VOLUME1         AS _VOLUME1
            ,SC6.C6_QTDEMP          AS _QTDEMP
            ,SC6.C6_QTDLIB          AS _QTDLIB
            ,SC6.C6_QTDENT          AS _QTDENT
            ,SC5.C5_ESPECI1         AS _ESPECI1
            ,SC5.C5_REAJUST         AS _REAJUST
            ,SC5.C5_BANCO           AS _BANCO
            ,SC5.C5_MENNOTA         AS _MENNOTA
            ,SC6.C6_NFORI           AS _NOTA
            ,SC6.C6_SERIORI         AS _SERIE
            ,SC6.C6_ITEMORI
            ,B1_POSIPI
            ,B5_CEME
            ,E4_DESCRI
            ,E4_ACRSFIN
            ,B5_COMPRLC
            ,B5_LARGLC
            ,B5_ALTURLC
        %Exp:cQryAd%
        FROM %Table:SC5% SC5
        INNER JOIN %Table:SC6% SC6 ON SC6.C6_FILIAL = %xFilial:SC6% AND SC6.C6_NUM   = SC5.C5_NUM AND SC6.%NotDel%
//        INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD   = C5_CLIENTE AND C5_LOJACLI = A1_LOJA AND SA1.%NotDel%
        INNER JOIN %Table:SE4% SE4 ON SE4.E4_FILIAL = %xFilial:SE4% AND E4_CODIGO    = C5_CONDPAG AND SE4.%NotDel%
        INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND B1_COD = C6_PRODUTO AND SB1.%NotDel%
        LEFT  JOIN %Table:SB5% SB5 ON SB5.B5_FILIAL = %xFilial:SB5% AND B1_COD = B5_COD AND SB5.%NotDel%
        WHERE   SC5.C5_FILIAL = %xFilial:SC5% AND
                SC5.%notdel% AND
                SC5.C5_NUM = %Exp:cNum%
        ORDER BY SC6.C6_XITEMP
    EndSql

    (cAliasPed)->( dbEval( {|| _nTotal++ } ) )
    (cAliasPed)->( dbGoTop() )

    dbSelectArea("SC5")

    cCliEnt := (cAliasPed)->_CLIENTE
    aCabPed := {}

    MaFisIni(Iif(Empty((cAliasPed)->_CLIENT),(cAliasPed)->_CLIENTE,(cAliasPed)->_CLIENT),;                      // 1-Codigo Cliente/Fornecedor
            (cAliasPed)->_LOJAENT,;		                                                                        // 2-Loja do Cliente/Fornecedor
            If((cAliasPed)->_TIPO$'DB',"F","C"),;                                                               // 3-C:Cliente , F:Fornecedor
            (cAliasPed)->_TIPO,;                                                                                // 4-Tipo da NF
            (cAliasPed)->_TIPOCLI,;                                                                             // 5-Tipo do Cliente/Fornecedor
            Nil,;                                                                                               // 6-Relacao de Impostos que suportados no arquivo
            Nil,;                                                                                               // 7-Tipo de complemento
            Nil,;                                                                                               // 8-Permite Incluir Impostos no Rodape .T./.F.
            Nil,;                                                                                               // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
            "MATA461",;                                                                                         //10-Nome da rotina que esta utilizando a funcao
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            Nil,;
            (cAliasPed)->_TPFRETE)

        nFrete      := (cAliasPed)->_FRETE
        nSeguro     := (cAliasPed)->_SEGURO
        nFretAut    := (cAliasPed)->_FRETAUT
        nDespesa    := (cAliasPed)->_DESPESA
        nDescCab    := 0 //(cAliasPed)->_DESCONT
        nPDesCab    := 0 //(cAliasPed)->_PDESCAB
        nC5Desc1    := 0 //(cAliasPed)->_DESC1
        nC5Desc2    := 0 //(cAliasPed)->_DESC2
        nC5Desc3    := 0 //(cAliasPed)->_DESC3
        nC5Desc4    := 0 //(cAliasPed)->_DESC4
        nC5Frete    := nFrete
        nC5Seguro   := nSeguro
        nC5Despesa  := nDespesa
        aItemPed    := {}
        aCabPed     := {    (cAliasPed)->_TIPO                ,;
                            (cAliasPed)->_CLIENTE             ,;
                            (cAliasPed)->_LOJA                ,;
                            (cAliasPed)->_TRANSP              ,;
                            (cAliasPed)->_CONDPAG             ,;
                            (cAliasPed)->_EMISSAO             ,;
                            (cAliasPed)->_NUM                 ,;
                            (cAliasPed)->_VEND1               ,;
                            (cAliasPed)->_VEND2               ,;
                            (cAliasPed)->_VEND3               ,;
                            (cAliasPed)->_VEND4               ,;
                            (cAliasPed)->_VEND5               ,;
                            (cAliasPed)->_COMIS1              ,;
                            (cAliasPed)->_COMIS2              ,;
                            (cAliasPed)->_COMIS3              ,;
                            (cAliasPed)->_COMIS4              ,;
                            (cAliasPed)->_COMIS5              ,;
                            (cAliasPed)->_FRETE               ,;
                            (cAliasPed)->_TPFRETE             ,;
                            (cAliasPed)->_SEGURO              ,;
                            (cAliasPed)->_TABELA              ,;
                            (cAliasPed)->_VOLUME1             ,;
                            (cAliasPed)->_ESPECI1             ,;
                            (cAliasPed)->_MOEDA               ,;
                            (cAliasPed)->_REAJUST             ,;
                            (cAliasPed)->_BANCO               ,;
                            (cAliasPed)->_ACRSFIN              ;
                            }
    nTotQtd := 0
    nTotVal := 0
    nPesBru := 0
    nPesLiq := 0
    aPedCli := {}


    cPedido    := (cAliasPed)->_NUM
    aC5Rodape  := {}

    aadd(aC5Rodape,{    (cAliasPed)->_PBRUTO;
                       ,(cAliasPed)->_PESOL;
                       ,0;
                       ,0;
                       ,0;
                       ,0;
                       ,(cAliasPed)->_MENNOTA})

    dbSelectArea(cAliasPed)

    For nY := 1 to Len(aFisGetSC5)
        If !Empty(&(aFisGetSC5[ny][2]))
            If aFisGetSC5[ny][1] == "NF_SUFRAMA"
                MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
            Else
                MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
            Endif
        EndIf
    Next nY

    While (cAliasPed)->(!EOF())
        cNfOri     := Nil
        cSeriOri   := Nil
        nRecnoSD1  := Nil
        nDesconto  := 0
        dbSelectArea('SC6')

        //³Calcula o preco de lista                     ³
        nValMerc  := (cAliasPed)->_VALOR
        nPrcLista := (cAliasPed)->_PRUNIT

        If ( nPrcLista == 0 )
            nPrcLista := NoRound(nValMerc/(cAliasPed)->_QTDVEN,TamSX3("C6_PRCVEN")[2])
        EndIf

        nAcresFin := A410Arred((cAliasPed)->_PRCVEN * (cAliasPed)->_ACRSFIN/100,"D2_PRCVEN")
        nValMerc  += A410Arred((cAliasPed)->_QTDVEN * nAcresFin,"D2_TOTAL")
        nDesconto := a410Arred(nPrcLista*(cAliasPed)->_QTDVEN,"D2_DESCON") - nValMerc
        nDesconto := IIf(nDesconto==0,(cAliasPed)->_VALDESC,nDesconto)
        nDesconto := Max(0,nDesconto)
        nTotValdesc += nDesconto
        nPrcLista += nAcresFin
        nValMerc  += nDesconto

        MaFisAdd(   (cAliasPed)->_PRODUTO           ,;  // 1-Codigo do Produto ( Obrigatorio )
                    (cAliasPed)->_TES               ,;  // 2-Codigo do TES ( Opcional )
                    (cAliasPed)->_QTDVEN            ,;  // 3-Quantidade ( Obrigatorio )
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



        aadd(aItemPed,  {   (cAliasPed)->_ITEM                    ,;
                            (cAliasPed)->_PRODUTO                 ,;
                            (cAliasPed)->_DESCRI                  ,;
                            (cAliasPed)->_TES                     ,;
                            (cAliasPed)->_CF                      ,;
                            (cAliasPed)->_UM                      ,;
                            (cAliasPed)->_QTDVEN                  ,;
                            (cAliasPed)->_PRCVEN                  ,;
                            (cAliasPed)->_NOTA                    ,;
                            (cAliasPed)->_SERIE                   ,;
                            (cAliasPed)->_CLIENTE                 ,;
                            (cAliasPed)->_LOJA                    ,;
                            (cAliasPed)->_VALOR                   ,;
                            (cAliasPed)->_ENTREG                  ,;
                            (cAliasPed)->_DESCONT                 ,;
                            (cAliasPed)->_LOCAL                   ,;
                            (cAliasPed)->_QTDEMP                  ,;
                            (cAliasPed)->_QTDLIB                  ,;
                            (cAliasPed)->_QTDENT                  ,;
                            })

        //³Forca os valores de impostos que foram informados no SC6.
        dbSelectArea('SC6')
        For nY := 1 to Len(aFisGet)
            If !Empty(&(aFisGet[ny][2]))
                MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
            EndIf
        Next nY

        //³Calculo do ISS                               ³
        SF4->(dbSetOrder(1))
        SF4->(MsSeek(xFilial("SF4")+(cAliasPed)->_TES))

        If !SC5->C5_TIPO $ "DB"
            SA1->(dbSetOrder(1))
            SA1->(MsSeek(xFilial("SA1")+(cAliasPed)->_CLIENTE + (cAliasPed)->_LOJA)) 
            If SA1->A1_INCISS == "N" .And. (cAliasPed)->_TIPO == "N"
                If ( SF4->F4_ISS=="S" )
                 nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                 nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                    MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
                    MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
                EndIf
            EndIf
        EndIf

        //³Altera peso para calcular frete              ³
        SB1->(dbSetOrder(1))
        SB1->(MsSeek(xFilial("SB1")+(cAliasPed)->_PRODUTO))

        MaFisAlt("IT_PESO",(cAliasPed)->_QTDVEN * SB1->B1_PESO,Len(aItemPed))
        MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
        MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))


        (cAliasPed)->(dbSkip())
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

    (cAliasPed)->(DbGoTop())
//    nVlrtotal   := MaFisRet(,"NF_BASEDUP")
//    nValIPI     := MaFisRet(,"NF_VALIPI")
//    nValSOL     := MaFisRet(,"NF_VALSOL")
//    nBaseIcm    := MaFisRet(,"NF_BASEICM")  // "Base Icms"
//    nValIcm     := MaFisRet(,"NF_VALICM")   // "Valor Icms"
//    nBaseIPI    := MaFisRet(,"NF_BASEIPI")  // "Base Ipi"
//    nValIPI     := MaFisRet(,"NF_VALIPI")   // "Valor Ipi"
//    nBaseRet    := MaFisRet(,"NF_BASESOL")  // "Base Retido"
//    nValRet     := MaFisRet(,"NF_VALSOL")   // "Valor Retido"
//    nVlrTot     := MaFisRet(,"NF_TOTAL" )   // "Valor Total"
//    nBaseISS    := MaFisRet(,"NF_BASEISS")  // "Base Iss"
//    vValISS     := MaFisRet(,"NF_VALISS")   // "Valor Iss"
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
