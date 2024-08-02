#INCLUDE 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch


//+------------------------------------------------------------------------------------------------------------------------------------------------------
//| Relatório Orçamento
//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05R02()

    FWMsgRun(, {|| U_M05R02A() },,'Gerando relatório...')

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05R02A()
    Local oPrinter     := Nil
    Local oFont14B     := Nil
    Local oFont12      := Nil
    Local oFont12B     := Nil
    Local oFont18T     := Nil
    Local oFont9       := Nil
    Local nRow         := -0080
    Local cData        := DtoC(Date()) + ' ' + Time()
    Local nPage        := 1
    //Local nRowStep     := 45

    M05RFont(@oFont9,@oFont12,@oFont12B,@oFont14B,@oFont18T)

    oPrinter := FWMSPrinter():New('PP' + SCJ->CJ_NUM + '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":",""), IMP_PDF, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.)

    oPrinter:SetResolution(78)
    oPrinter:SetLandscape()
    oPrinter:SetMargin(0,0,0,0)

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
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RICabIt(oPrinter,oFont12B,nRow)
    Local nRowStep      := 45

    nRow += nRowStep

    oPrinter:Box(nRow,0100,nRow + nRowStep * 2.5,3200)
//  oPrinter:Box(nRow,0100,nRow + nRowStep * 2,0200)                        // SQ
    oPrinter:Box(nRow,0200,nRow + nRowStep * 2.5,0403)                      // Item
//  oPrinter:Box(nRow,0400,nRow + nRowStep * 2,0700)                        // Código
    oPrinter:Box(nRow,0650,nRow + nRowStep * 2.5,1250)                      // Descrição
//  oPrinter:Box(nRow,1200,nRow + nRowStep * 2,1400)                        // NCM
    oPrinter:Box(nRow,1400,nRow + nRowStep * 2.5,1500)                      // QTD
//  oPrinter:Box(nRow,1500,nRow + nRowStep * 2,1700)                        // VALOR UNITÁRIO

    oPrinter:Box(nRow,1700,nRow + nRowStep * 2.5,1950)                      // IPI
    oPrinter:Box(nRow,1700,nRow + nRowStep * 1.25,1950)                     // IPI
    oPrinter:Box(nRow + nRowStep * 1.25,1700,nRow + nRowStep * 2.5,1770)    // IPI

//  oPrinter:Box(nRow,1950,nRow + nRowStep * 2,2200)                        // ICMS
    oPrinter:Box(nRow,1950,nRow + nRowStep * 1.25,2200)                     // ICMS
    oPrinter:Box(nRow + nRowStep * 1.25,1950,nRow + nRowStep * 2.5,2020)    // ICMS

    oPrinter:Box(nRow,2200,nRow + nRowStep * 2.5,2450)                      // PIS/COFINS
    oPrinter:Box(nRow,2200,nRow + nRowStep * 1.25,2450)                     // PIS/COFINS
    oPrinter:Box(nRow + nRowStep * 1.25,2200,nRow + nRowStep * 2.5,2270)    // PIS/COFINS

//  oPrinter:Box(nRow,2450,nRow + nRowStep * 2,2700)                        // VALOR ICMS ST
    oPrinter:Box(nRow,2700,nRow + nRowStep * 2.5,2950)                      // VALOR UNITARIO C/ IMPOSTOS
//  oPrinter:Box(nRow,2950,nRow + nRowStep * 2,3200)                        // VALOR TOTAL

    nRow += nRowStep

    oPrinter:Say(nRow                ,0120                ,'ITEM'          ,oFont12B)
    oPrinter:Say(nRow                ,0250                ,'PLANTA'        ,oFont12B)
    oPrinter:Say(nRow                ,0480                ,'CÓDIGO'        ,oFont12B)
    oPrinter:Say(nRow                ,0850                ,'DESCRIÇÃO'     ,oFont12B)
    oPrinter:Say(nRow                ,1280                ,'NCM'           ,oFont12B)
    oPrinter:Say(nRow                ,1420                ,'QTD'           ,oFont12B)
    oPrinter:Say(nRow                ,1550                ,'VALOR'         ,oFont12B)
    oPrinter:Say(nRow + nRowStep     ,1540                ,'UNITÁRIO'      ,oFont12B)

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
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RIItens(oPrinter,oFont9,oFont12,oFont12B,nRow,nPage,cData)
    Local nRowStep      := 45
    Local _cAlias       := GetNextAlias()
    Local nItem         := 0
    Local _nTotal       := 0

    M05RICabIt(oPrinter,oFont12B,@nRow)

 // MR05GetValue(@_cAlias)
    MR05Planil(SCJ->CJ_NUM,@_cAlias,@_nTotal)

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
    oPrinter:Box(nRow,0190,nRow + (nRowStep * 1.25 * Len(aDesc)),0403)                     // Item
    oPrinter:Box(nRow,0650,nRow + (nRowStep * 1.25 * Len(aDesc)),1250)                     // Descrição
    oPrinter:Box(nRow,1400,nRow + (nRowStep * 1.25 * Len(aDesc)),1500)                     // QTD
    oPrinter:Box(nRow,1700,nRow + (nRowStep * 1.25 * Len(aDesc)),1950)                     // IPI %
    oPrinter:Box(nRow,1700,nRow + (nRowStep * 1.25 * Len(aDesc)),1770)                     // IPI Valor
    oPrinter:Box(nRow,1950,nRow + (nRowStep * 1.25 * Len(aDesc)),2200)                     // ICMS %
    oPrinter:Box(nRow,1950,nRow + (nRowStep * 1.25 * Len(aDesc)),2020)                     // ICMS
    oPrinter:Box(nRow,2200,nRow + (nRowStep * 1.25 * Len(aDesc)),2450)                     // PIS/COFINS %
    oPrinter:Box(nRow,2200,nRow + (nRowStep * 1.25 * Len(aDesc)),2270)                     // PIS/COFINS
    oPrinter:Box(nRow,2700,nRow + (nRowStep * 1.25 * Len(aDesc)),2950)                     // VALOR UNITARIO C/ IMPOSTOS

    nRow += nRowStep

    oPrinter:Say(nRow - 0008                ,0125                ,(_cAlias)->_ITEM                                                                                                            ,oFont9)    // SQ
    oPrinter:Say(nRow - 0008                ,0200                ,SubStr(AllTrim((_cAlias)->_XITEMP),1,15)                                                                                    ,oFont9)    // ITEM
    oPrinter:Say(nRow - 0008                ,0415                ,(_cAlias)->_PRODUTO                                                                                                         ,oFont9)    // CÓDIGO
    oPrinter:Say(nRow - 0008                ,1267                ,Transform((_cAlias)->B1_POSIPI,"@R 9999.99.99")                                                                               ,oFont9)    // NCM
    oPrinter:Say(nRow - 0008                ,1414                ,Transform(NoRound(MaFisRet(nItem,"IT_QUANT")   ,2),"@E 999999.99")                                                                                       ,oFont9)    // QTD
    oPrinter:Say(nRow - 0008                ,1540                ,Transform(NoRound(MaFisRet(nItem,"IT_PRCUNI")     ,2),cPicVal)                                                              ,oFont9)    // VALOR UNITÁRIO
    oPrinter:Say(nRow - 0008                ,1709                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQIPI")  ,2),cPicAliq)                                                          ,oFont9)    // % IPI
    oPrinter:Say(nRow - 0008                ,1810                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALIPI")   ,2),cPicVal)                                                            ,oFont9)    // VALOR IPI
    //oPrinter:Say(nRow - 0008                ,1954                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQICM")  ,2),cPicAliq) 
    oPrinter:Say(nRow - 0008                ,1918                ,Transform(NoRound((_cAlias)->_XALQICM  ,2), cPicVal)                                                                       ,oFont9)    // % ICMS
    oPrinter:Say(nRow - 0008                ,2050                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALICM")   ,2),cPicVal)                                                            ,oFont9)    // VALOR ICMS
    oPrinter:Say(nRow - 0008                ,2210                ,Transform(NoRound(MaFisRet( nItem ,"IT_ALIQPS2") + MaFisRet( nItem ,"IT_ALIQCF2") ,2),cPicAliq)       ,oFont9)    // % PIS/COFINS
    oPrinter:Say(nRow - 0008                ,2290                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALPS2") + MaFisRet( nItem ,"IT_VALCF2"),2),cPicVal)          ,oFont9)    // VALOR PIS/COFINS
    oPrinter:Say(nRow - 0008                ,2550                ,Transform(NoRound(MaFisRet( nItem ,"IT_VALSOL"),2),cPicVal)                                                            ,oFont9)    // VALOR ICMS ST
    oPrinter:Say(nRow - 0008                ,2780                ,Transform(NoRound((MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_DESPESA") ) )  / (_cAlias)->_QTDVEN ,2),cPicVal)  ,oFont9)    // VALOR UNIT C/ IMPOSTOS
    oPrinter:Say(nRow - 0008                ,3010                ,Transform(NoRound(MaFisRet( nItem ,"IT_TOTAL") - (MaFisRet( nItem ,"IT_FRETE") + MaFisRet( nItem ,"IT_DESPESA") ),2) ,cPicVal)                           ,oFont12B)  // VALOR TOTAL

    For nDesc := 1 to Len(aDesc)
        oPrinter:Say(nRow - 0008            ,0660                ,aDesc[nDesc]                                                                                                                  ,oFont9)     // DESCRIÇÃO
        nRow += nRowStep
    Next

    nRow -= nRowStep

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RDescr(cProd,cDescSB1,cDescSCK,nComp,nLar,nAlt,cItem)
    Local aRet      := {}
    Local cAux      := ""
    Local cLetras   := ""
    Local cRet      := ""
    Local i         := 0
    Local nTam      := 45
    Local nIni      := 1
    Local nQuebra   := 1
    Local cPic      := "@E 999999"

    Default cDescSB1    := 'Produto sem complemento'

    If cProd == 'N/A'
        cDesc   := cDescSCK
    Else
        cDesc   := cDescSB1

        If nComp > 0 .And. nLar > 0 .And. nAlt > 0
            cDesc += ' - MEDINDO: ' + AllTrim(Transform(nComp,cPic)) + ' X ' + AllTrim(Transform(nLar,cPic)) + ' X ' + AllTrim(Transform(nAlt,cPic))
        EndIf
    EndIf
    
    //Tratamento para descrição FINAME
    If SCJ->CJ_XFINAME == "1"
    	cFiname 	:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_XFINAME")
    	cSerMacom	:= Posicione("ZA0",1,xFilial("ZA0")+SCJ->CJ_NUM+cItem,"ZA0_SERIE")
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

    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    If !SA1->(DbSeek( xFilial('SA1')  + SCJ->(CJ_CLIENTE + CJ_LOJA)))
        MsgInfo(I18N('Não foram encontrados dados do cliente #1 loja #2.' + CRLF + 'Verifique.',{SCJ->CJ_CLIENTE,SCJ->CJ_LOJA}),"Atenção")
        lRet := .F.
    EndIf

    If lRet
        SA3->(DbSetOrder(1))
        SA3->(DbGoTop())

        If !SA3->(DbSeek( xFilial('SA3') + SCJ->CJ_XVEND1 ))
            MsgInfo(I18N('Não foram encontrados dados do vendedor #1' + CRLF + 'Verifique.',{SCJ->CJ_XVEND1}),"Atenção")
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

   If cFilAnt <> "01"
        //cNome         := AllTrim(SM0->M0_NOMECOM)
        cEndC         := Capital(AllTrim(SM0->M0_ENDENT)+", "+AllTrim(SM0->M0_BAIRENT)+", "+AllTrim(SM0->M0_CIDENT))+"-"+AllTrim(SM0->M0_ESTENT)+", CEP "+Left(SM0->M0_CEPENT,5)+"-"+SubStr(SM0->M0_CEPENT,6,3)
        cCGC          := "CNPJ: "+SM0->M0_CGC+" I.E.: "+AllTrim(SM0->M0_INSC)
        cTel          := "Telefone: "+SM0->M0_TEL
    EndIf


    oPrinter:SayBitmap(nRow ,0100,GetSrvProfString("Startpath","") + 'LOGO_M05R02.BMP', 751 ,178 )

    oPrinter:Say(nRow                 ,2100         , cNome     ,oFont14B)
    oPrinter:Say(nRow += nRowStep     ,2100         , cEndC     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100         , cCGC      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100         , cTel      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2100         , cMail     ,oFont12)

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

        nRow += nRowStep

        oPrinter:Line(nRow, 0100,nRow, 3200)
    EndIf
Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Cab3(oPrinter,oFont12,nRow)
    Local nRowStep      := 45
    Local cAliasCont    := GetNextAlias()
    Local cEntidade     := 'SA1'
    Local cCodEnt       := PadR(SCJ->(CJ_CLIENTE + CJ_LOJA),TamSX3('AC8_CODENT')[1])
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

If Empty(SCJ->CJ_XCONT) .And. Empty(SCJ->CJ_XCONT2) .And. Empty(SCJ->CJ_XCONT3) .And. Empty(SCJ->CJ_XCONT4) .And. Empty(SCJ->CJ_XCONT5)  
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
		If 	(cAliasCont)->U5_CODCONT == SCJ->CJ_XCONT .Or. (cAliasCont)->U5_CODCONT == SCJ->CJ_XCONT2 .Or. (cAliasCont)->U5_CODCONT == SCJ->CJ_XCONT3 .Or. (cAliasCont)->U5_CODCONT == SCJ->CJ_XCONT4 .Or. (cAliasCont)->U5_CODCONT == SCJ->CJ_XCONT5  
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

    nRow += (nRowStep * 2)

    oPrinter:Line(nRow,0100,nRow, 3200)

    oPrinter:Say(nRow += nRowStep     ,0100    , 'PROPOSTA: '       ,oFont12)
    oPrinter:Say(nRow                 ,0300    , SCJ->CJ_NUM        ,oFont14B)

    oPrinter:Say(nRow                 ,1000    , 'CLIENTE/LOJA:'    ,oFont12)
    oPrinter:Say(nRow                 ,1250    , SCJ->CJ_CLIENTE + '/' + SCJ->CJ_LOJA        ,oFont12)

    oPrinter:Say(nRow                 ,1900    , 'REDE:'    ,oFont12)
    oPrinter:Say(nRow                 ,2150    , Posicione('SA1',1,xFilial('SA1') +SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,'A1_XREDE' )        ,oFont12)

    oPrinter:Say(nRow                 ,2700    , 'LOJA:'    ,oFont12)
    oPrinter:Say(nRow                 ,2900    , Posicione('SA1',1,xFilial('SA1') +SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,'A1_XIDLOJA' )        ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100    , 'COND PAG (MEDIANTE ANÁLISE DE CRÉDITO): '       ,oFont12) //#6898
    oPrinter:Say(nRow                 ,0800    , MR05GetCPg()       ,oFont12) //300

    oPrinter:Say(nRow += nRowStep     ,0100    ,'REFERÊNCIA:'     ,oFont12)
    oPrinter:Say(nRow                 ,0300    ,AllTrim(SCJ->CJ_XOBRAS)                 ,oFont12)

    nRow += (nRowStep * 0.50)
    oPrinter:Line(nRow, 0100,nRow, 3200)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Rod(oPrinter,oFont12,oFont12B,oFont14B,nRow,nPage,cData)
    Local nRowStep      := 45
    Local cPicVal       := "@E 99,999,999.99"
    //Local cPicAliq      := "@E 999.99"
    //Local cPicQtd       := "@E 999999.99"
    Local dValida       := SCJ->CJ_VALIDA
    Local cDespesa      := Transform(NoRound(MaFisRet(,"NF_DESPESA"),2),cPicVal)
    Local cFrete        := Transform(NoRound(IIF(SCJ->CJ_XTFRETE == 'C',MaFisRet(,"NF_FRETE"),0),2),cPicVal)
    Local cTotal        := Transform(NoRound(MaFisRet(,"NF_TOTAL"),2),"@E 9,999,999,999.99")
    Local cSubTot       := Transform(NoRound(( MaFisRet(,"NF_TOTAL") - ( MaFisRet(,"NF_FRETE") + MaFisRet(,"NF_DESPESA") ) ),2),"@E 9,999,999,999.99")
    Local cMoeda        := AllTrim(GetMv('MV_MOEDA' + cValToChar(SCJ->CJ_MOEDA),,''))

    nRow += (nRowStep * 5)

    If nRow > 1600
        nRow := 2100 + nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Proposta #1 impressa em #2.',{SCJ->CJ_NUM,cData })  ,oFont12)
        oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

        oPrinter:EndPage()
        oPrinter:StartPage()
        nRow := 0000

        nPage++
    EndIf

    oPrinter:Say(nRow += nRowStep     ,0100     ,'TIPO FRETE: '             ,oFont12)
    oPrinter:Say(nRow                 ,0300     ,M05RTpFret()               ,oFont12)

    oPrinter:Line(nRow - nRowStep * 1.25, 2350,nRow - nRowStep* 1.25 , 3200)
    oPrinter:Say(nRow                 ,2450     ,'SUB-TOTAL (' + cMoeda + ')'        ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,cSubTot                    ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100     ,'INSTALAÇÃO: '             ,oFont12)
    oPrinter:Say(nRow                 ,0300     ,M05RTpIsnt()               ,oFont12)
    oPrinter:Say(nRow                 ,2450     ,'VALOR FRETE: '            ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,cFrete                     ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100     ,'VALIDADE: '               ,oFont12)
    oPrinter:Say(nRow                 ,0300     ,DTOC(dValida)              ,oFont12)

    oPrinter:Say(nRow                 ,2450     ,'VALOR INSTALAÇÃO'         ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,cDespesa                   ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100     ,'PRAZO DE EMBARQUE: '       ,oFont12)
    oPrinter:Say(nRow				  ,0500		,SCJ->CJ_XPRZEMB			 ,oFont12)

    oPrinter:Line(nRow - nRowStep * 0.5, 2350,nRow - nRowStep * 0.5, 3200)
    oPrinter:Say(nRow += (nRowStep )  ,2450     ,'TOTAL GERAL'              ,oFont14B)
    oPrinter:Say(nRow                 ,2900     ,cTotal                     ,oFont14B)

    nRow += nRowStep
    nRow += nRowStep

    oPrinter:Say(nRow += nRowStep     ,0150    , 'De acordo e ciente das Condições Gerais de Fornecimento: '       ,oFont12)

    oPrinter:Say(nRow                 ,2450    , 'AÇOS MACOM INDÚSTRIA E COMERCIO LTDA'         ,oFont12B)

    oPrinter:Say(nRow += nRowStep     ,0300    , Upper(AllTrim(SA1->A1_NOME))                   ,oFont12B)
    oPrinter:Say(nRow                 ,2450    , 'GERÊNCIA: ' + AllTrim(SA3->A3_SUPER)          ,oFont12)

    nRow += nRowStep

    oPrinter:Say(nRow += nRowStep     ,2450    , 'REPRESENTANTE COMERCIAL '                     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2450    , AllTrim(SA3->A3_NOME)                          ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0150    , 'Por:_______________________________________________________________________________________________________________ '  ,oFont12)
    oPrinter:Say(nRow                 ,2450    , AllTrim(SA3->A3_NREDUZ),oFont12)

    oPrinter:Say(nRow += nRowStep     ,0200    , 'Nome e Cargo'  ,oFont12)
    oPrinter:Say(nRow                 ,1100    , 'Assinatura'  ,oFont12)
    oPrinter:Say(nRow                 ,1800    , 'Data'  ,oFont12)
    oPrinter:Say(nRow                 ,2450    , SA3->A3_DDDTEL + ' ' + Transform(AllTrim(SA3->A3_TEL), "@R 9999-99999" ) ,oFont12)


    nRow := 2100 + nRowStep

    oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Proposta #1 impressa em #2.',{SCJ->CJ_NUM,cData })  ,oFont12)
    oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

    oPrinter:EndPage()
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpFret()
    Local cRet  := ''

    Do Case
    Case SCJ->CJ_XTFRETE == 'C'
        cRet := 'CIF'
    Case SCJ->CJ_XTFRETE == 'F'
        cRet := 'FOB'
    Case SCJ->CJ_XTFRETE == 'T'
        cRet := 'Por Conta de Terceiros'
    Case SCJ->CJ_XTFRETE == 'E'
    	cRet := 'Ex-Works'
    Case SCJ->CJ_XTFRETE == 'S'
        cRet := 'Sem Frete'

    End Case
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M05RTpIsnt()
    Local cRet  := ''

    Do Case
    Case SCJ->CJ_XTPINST == '1'
        cRet := 'Sem Instalação'
    Case SCJ->CJ_XTPINST == '2'
        cRet := 'Credenciada (Vide condições gerais de fornecimento)'
    Case SCJ->CJ_XTPINST == '3'
        cRet := 'Macom'
    Case SCJ->CJ_XTPINST == '4'
        cRet := 'Rateio no Produto'

    End Case
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05GetCPg()
    Local cRet  := ''

    SE4->(DbSetOrder(1))
    SE4->(DbGotop())

    If SE4->(DbSeek( xFilial('SE4') + SCJ->CJ_CONDPAG ))
        cRet := AllTrim(SE4->E4_CODIGO) + ': ' + AllTrim(SE4->E4_DESCRI) + ' - '  + AllTrim(SCJ->CJ_XDESPAG)
    EndIf
Return cRet


Static Function MR05GetSA1()
    Local cRet  := ''

    SA1->(DbSetOrder(1))
    SA1->(DbGotop())

    If SA1->(DbSeek( xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA  ))
        If !Empty(SA1->A1_COMPLEM)
            cRet := AllTrim(SA1->A1_END) + ' - ' + AllTrim(SA1->A1_COMPLEM) + ' - ' + AllTrim(SA1->A1_BAIRRO) + ' - '  + AllTrim(SA1->A1_CEP) + ' - '  + AllTrim(SA1->A1_MUN)+ ' - '  + AllTrim(SA1->A1_EST)
        Else
            cRet := AllTrim(SA1->A1_END) + ' - '                                    + AllTrim(SA1->A1_BAIRRO) + ' - '  + AllTrim(SA1->A1_CEP) + ' - '  + AllTrim(SA1->A1_MUN)+ ' - '  + AllTrim(SA1->A1_EST)
        Endif
    EndIf
Return cRet


//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Date()
    Local cDay  := StrZero(Day(SCJ->CJ_EMISSAO),2)//StrZero(Day(Date()),2)
    Local nMon  := Month(SCJ->CJ_EMISSAO)
    Local cMon  := ''
    Local cYear := cValToChar(Year(SCJ->CJ_EMISSAO))

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

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Proposta #1 impressa em #2.',{SCJ->CJ_NUM,cData })  ,oFont12)
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

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR05Planil(cNum,cAliasPed,_nTotal)
    Local nTotValdesc  := 0
    Local nC5Desc1      := 0
    Local nC5Desc2      := 0
    Local nC5Desc3      := 0
    Local nC5Desc4      := 0
    Local nC5Frete      := 0
    Local nC5Seguro     := 0
    Local nC5Despesa    := 0

    Local aPedCli       := {}
    Local aC5Rodape     := {}
    Local aRelImp       := MaFisRelImp("MT100",{"SF2","SD2"})
    Local aFisGet       := Nil
    Local aFisGetSC5    := Nil
    Local cAliasSC6     := "SC6"
    Local cQryAd        := ""
    Local cPedido       := ""
    Local cCliEnt       := ""
    Local cNfOri        := Nil
    Local cSeriOri      := Nil
    Local nDesconto     := 0
    Local nPesLiq       := 0
    Local nRecnoSD1     := Nil
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
    Local aItemPed      := {}
    Local aCabPed       := {}

    Local cAliasCab     := 'SCJ'

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

    BeginSql Alias cAliasPed
        SELECT SCJ.R_E_C_N_O_       AS REC_CAB
            ,SCK.R_E_C_N_O_         AS REC_ITEM
            ,SCJ.CJ_FILIAL          AS _FILIAL
            ,SCJ.CJ_NUM             AS _NUM
            ,SCJ.CJ_CLIENTE         AS _CLIENTE
            ,SCJ.CJ_LOJA            AS _LOJA
            ,'N'                    AS _TIPO
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
            ,SCK.CK_DESCONT         AS _DESCONT
            ,SCK.CK_LOCAL           AS _LOCAL
            ,SCK.CK_XALQICM         AS _XALQICM
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
        %Exp:cQryAd%
        FROM %Table:SCJ% SCJ
        INNER JOIN %Table:SCK% SCK ON SCK.CK_FILIAL = %xFilial:SCK% AND SCK.CK_NUM   = SCJ.CJ_NUM AND SCK.%NotDel%
        INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD   = CJ_CLIENTE AND CJ_LOJA = A1_LOJA AND SA1.%NotDel%
        INNER JOIN %Table:SE4% SE4 ON SE4.E4_FILIAL = %xFilial:SE4% AND E4_CODIGO    = CJ_CONDPAG AND SE4.%NotDel%
        INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND B1_COD = CK_PRODUTO AND SB1.%NotDel%
        LEFT  JOIN %Table:SB5% SB5 ON SB5.B5_FILIAL = %xFilial:SB5% AND B1_COD = B5_COD AND SB5.%NotDel%
        WHERE   SCJ.CJ_FILIAL = %xFilial:SCJ% AND
                SCJ.%notdel% AND
                SCJ.CJ_NUM = %Exp:cNum%
        ORDER BY SCK.CK_XITEMP
    EndSql

    (cAliasPed)->( dbEval( {|| _nTotal++ } ) )
    (cAliasPed)->( dbGoTop() )

    dbSelectArea(cAliasCab)

    cCliEnt := (cAliasPed)->_CLIENTE
    aCabPed := {}

    MaFisIni(cCliEnt,;                      // 1-Codigo Cliente/Fornecedor
    (cAliasPed)->_LOJA,;                    // 2-Loja do Cliente/Fornecedor
    If((cAliasPed)->_TIPO$'DB',"F","C"),;   // 3-C:Cliente , F:Fornecedor
        (cAliasPed)->_TIPO,;                // 4-Tipo da NF
        (cAliasPed)->_TIPOCLI,;             // 5-Tipo do Cliente/Fornecedor
        aRelImp,;                           // 6-Relacao de Impostos que suportados no arquivo
        ,;                                  // 7-Tipo de complemento
        ,;                                  // 8-Permite Incluir Impostos no Rodape .T./.F.
        "SB1",;                             // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
        "MATA461")                          // 10-Nome da rotina que esta utilizando a funcao

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
                            Val((cAliasPed)->_VOLUME1)        ,;
                            (cAliasPed)->_ESPECI1             ,;
                            (cAliasPed)->_MOEDA               ,;
                            (cAliasPed)->_REAJUST             ,;
                            (cAliasPed)->_BANCO               ,;
                            (cAliasPed)->_ACRSFIN              ;
                            }
    nPesLiq := 0
    aPedCli := {}


    cPedido    := (cAliasPed)->_NUM
    aC5Rodape  := {}

    aadd(aC5Rodape,{    Val((cAliasPed)->_PBRUTO);
                       ,Val((cAliasPed)->_PESOL);
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
        dbSelectArea('SCK')

        //³Calcula o preco de lista                     ³
        nValMerc  := (cAliasPed)->_VALOR
        nPrcLista := (cAliasPed)->_PRUNIT

        If ( nPrcLista == 0 )
            nPrcLista := NoRound(nValMerc/(cAliasPed)->_QTDVEN,TamSX3("CK_PRCVEN")[2])
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
                            Val((cAliasPed)->_QTDEMP)             ,;
                            Val((cAliasPed)->_QTDLIB)             ,;
                            Val((cAliasPed)->_QTDENT)             ,;
                            })

        //³Forca os valores de impostos que foram informados no SC6.
        dbSelectArea('SCK')
        For nY := 1 to Len(aFisGet)
            If !Empty(&(aFisGet[ny][2]))
                MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
            EndIf
        Next nY

        //³Calculo do ISS                               ³
        SF4->(dbSetOrder(1))
        SF4->(MsSeek(xFilial("SF4")+(cAliasPed)->_TES))

        If (cAliasPed)->_INCISS == "N" .And. (cAliasPed)->_TIPO == "N"
            If ( SF4->F4_ISS=="S" )
                nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
                MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
                MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
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
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
