#INCLUDE 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

//+------------------------------------------------------------------------------------------------------------------------------------------------------
//| Contrato de Parceria
//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M02R06(lEnvEmail)

Local aArea := GetArea()

FWMsgRun(, {|| U_M02R06A(lEnvEmail) },'Contrato de Parceria','Gerando relatório...')

RestArea(aArea)

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M02R06A(lEnvEmail)


    Local oPrinter     := Nil
    Local oFont14B     := Nil
    Local oFont12      := Nil
    Local oFont12B     := Nil
    Local oFont18T     := Nil
    Local oFont9       := Nil
    Local nRow         := -0080
    Local cData        := DtoC(Date()) + ' ' + Time()
  
    Local nTotPed      := 0
    Local nValFret     := 0
    Local nValDesp     := 0
    Local nValDesc     := 0
    Local nValST       := 0
    Local cLocal	:= GetSrvProfString ("STARTPATH","")

    Private _cAliasSA1   := GetNextAlias()
    Private _oBrush      := TBrush():New( , RGB( 240 ,240 ,240))
    Private _cNumOrc     := SC7->C7_NUM
    Private _lOk         := .T.
    Private nPage        := 1
    Private nRowStep     := 45

    M02RFont(@oFont9,@oFont12,@oFont12B,@oFont14B,@oFont18T)

    If !lEnvEmail
        cFileImp := 'CP' + SC3->C3_NUM + '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":","")
        oPrinter := FWMSPrinter():New(cFileImp, IMP_PDF, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.)
    Else
        cFileImp := 'CP' + SC3->C3_NUM + '_' + DToS(Date())
    	cLocal   := "\SPOOL\"

        // Exclui arquivo gerado anteriormente
        Ferase(cLocal+cFileImp+".pdf")

        oPrinter := FWMSPrinter():New(cFileImp, IMP_PDF, .T./*_lAdjustToLegacy*/, cLocal,.T.,,,,,,,.F.)
       // oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy,cDirPDF /*cPathInServer*/,.T.,,,,.F.,,,.F.)
       // oPrinter:=FWMSPrinter():New(cNumPed,6,.F.,,lDisableSetup,,,,,,,lViewPDF)
   
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³Define o local de impressão padrao caso o Setup esteja desabilitado ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oPrinter:cPathPDF := cLocal
		oPrinter:nDevice  := IMP_PDF
    EndIf

    oPrinter:SetResolution(78)
    oPrinter:SetLandscape()
    oPrinter:SetMargin(0,0,0,0)

    oPrinter:StartPage()

    //+----------------------------------------------------------------------------------------
    // Cabeçalho 1 - Dados Macom
    //+----------------------------------------------------------------------------------------
    MR02Cab1(oPrinter,oFont14B,oFont12,@nRow)

    If MR02Posiciona()

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 2 - Dados do Fornecedor   *****************
        //+----------------------------------------------------------------------------------------
        MR02Cab2(oPrinter,oFont12,oFont18T,@nRow,oFont14B)

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 3 - Dados do Contato - NÃO IMPLEMENTADO
        //+----------------------------------------------------------------------------------------
        //MR05Cab3(oPrinter,oFont12,@nRow)

        //+----------------------------------------------------------------------------------------
        // Cabeçalho 3 - Dados do Orçamento
        //+----------------------------------------------------------------------------------------
        MR02Cab4(oPrinter,oFont12,oFont14B,oFont18T,@nRow)

        //+----------------------------------------------------------------------------------------
        // Corpo do Orçamento
        //+----------------------------------------------------------------------------------------
        //MaFisEnd()

        M02RIItens(oPrinter,oFont9,oFont12,oFont12B,@nRow,@nPage,cData,@nTotPed,@nValFret,@nValDesp,@nValDesc,@nValST)

        //+----------------------------------------------------------------------------------------
        // Rodapé
        //+----------------------------------------------------------------------------------------
        MR02Rod(oPrinter,oFont12,oFont12B,oFont14B,nRow,nPage,cData,@nTotPed,@nValFret,@nValDesp,@nValDesc,@nValST)

        //MaFisEnd()
        oPrinter:EndPage()
        oPrinter:Print()
        FreeObj(oPrinter)

        //+----------------------------------------------------------------------------------------
        // Condições Gerais
        //+----------------------------------------------------------------------------------------
    EndIf
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M02RICabIt(oPrinter,oFont12B,nRow)

    Local nRowStep      := 45
    nRow += nRowStep

    oPrinter:Box(nRow,0100,nRow + nRowStep * 2.5,3200)
//  oPrinter:Box(nRow,0100,nRow + nRowStep * 2,0200)                        // SQ

    oPrinter:Box(nRow,0180,nRow + nRowStep * 2.5,0403)                      // Item
//  oPrinter:Box(nRow,0400,nRow + nRowStep * 2,0700)                        // Código

    oPrinter:Box(nRow,0650,nRow + nRowStep * 2.5,1250)                      // Descrição
//  oPrinter:Box(nRow,1200,nRow + nRowStep * 2,1400)                        // MEDIDA

    oPrinter:Box(nRow,1400,nRow + nRowStep * 2.5,1500)                      // QTD
//  oPrinter:Box(nRow,1500,nRow + nRowStep * 2,1700)                        // VALOR UNITÁRIO

    oPrinter:Box(nRow,1700,nRow + nRowStep * 2.5,1950)                      // IPI
    oPrinter:Box(nRow,1700,nRow + nRowStep * 1.25,1950)                     // IPI
    oPrinter:Box(nRow + nRowStep * 1.30,1700,nRow + nRowStep * 2.5,1770)    // IPI

//  oPrinter:Box(nRow,1950,nRow + nRowStep * 2,2200)                        // ICMS
    oPrinter:Box(nRow,1950,nRow + nRowStep * 1.25,2200)                     // ICMS
    oPrinter:Box(nRow + nRowStep * 1.30,1950,nRow + nRowStep * 2.5,2020)    // ICMS

    oPrinter:Box(nRow,2200,nRow + nRowStep * 2.5,2450)                      // PIS/COFINS
    oPrinter:Box(nRow,2200,nRow + nRowStep * 1.25,2450)                     // PIS/COFINS
    oPrinter:Box(nRow + nRowStep * 1.30,2200,nRow + nRowStep * 2.5,2270)    // PIS/COFINS

//  oPrinter:Box(nRow,2450,nRow + nRowStep * 2,2700)                        // VALOR ICMS ST
    oPrinter:Box(nRow,2700,nRow + nRowStep * 2.5,2950)                      // VALOR UNITARIO C/ IMPOSTOS
//  oPrinter:Box(nRow,2950,nRow + nRowStep * 2,3200)                        // VALOR TOTAL

    nRow += nRowStep
    oPrinter:Say(nRow                ,0110                ,'ITEM'          ,oFont12B)
    oPrinter:Say(nRow                ,0200                ,'DT.ENTREGA'    ,oFont12B)
    oPrinter:Say(nRow                ,0480                ,'CÓDIGO'        ,oFont12B)
    oPrinter:Say(nRow                ,0850                ,'DESCRIÇÃO'     ,oFont12B)
    oPrinter:Say(nRow                ,1280                ,'MEDIDA'        ,oFont12B)
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

    oPrinter:Say(nRow                ,2750                ,'VALOR TOTAL'    ,oFont12B)
    oPrinter:Say(nRow + nRowStep     ,2750                ,'+ FRET/DESP'     ,oFont12B)

    oPrinter:Say(nRow                ,2980                ,'VALOR TOTAL'     ,oFont12B)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M02RIItens(oPrinter,oFont9,oFont12,oFont12B,nRow,nPage,cData,nTotPed,nValFret,nVAlDesp,nValDesc,nValST)
    Local nRowStep      := 45
    Local _cAlias       := GetNextAlias()
    Local nItem         := 0
    Local _nTotal       := 0

    M02RICabIt(oPrinter,oFont12B,@nRow)

 // MR05GetValue(@_cAlias)
    MR02Planil(SC3->C3_NUM,@_cAlias,@_nTotal)

     nRow += nRowStep + 10

    (_cAlias)->(DbGoTop())

    While (_cAlias)->(!EOF())
        nItem++
        MR02ImpItem(_cAlias,oPrinter,@nRow,oFont9,oFont12B,nItem,@nTotPed,@nValFret,@nValDesp,@nValDesc,@nValST)

        MR02EndPag(oPrinter,oFont12,oFont12B,@nRow,nRowStep,@nPage,cData,nItem,_nTotal)

        (_cAlias)->(DbSkip())
    EndDo
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02ImpItem(_cAlias,oPrinter,nRow,oFont9,oFont12B,nItem,nTotPed,nValFret,nValDesp,nValDesc,nValST)
    Local nDesc         := 1
    Local nRowStep      := 45
    Local aDesc         := {}
    Local cDescB5		:= ""    
    Local cPicVal       := "@E 99,999,999.99"
    Local cPicAliq      := "@E 999.99"
    
    Local nTaxaCof		:= SuperGetMv("MV_TXCOFIN", .F. , 0)
    Local nTaxaPis		:= SuperGetMv("MV_TXPIS", .F. , 0)
    Private cPicQtd       := "@E 999999.99"
    
    cDescB5 := Posicione("SB5",1,xFilial("SB5")+(_cAlias)->_PRODUTO,"B5_CEME")
    
    aDesc	:= M02RDescr(AllTrim((_cAlias)->_PRODUTO),IIF(!Empty(cDescB5),AllTrim(cDescB5),"PRODUTO SEM COMPLEMENTO"), AllTrim((_cAlias)->_DESCRI),0 ,0 ,0,(_cAlias)->_ITEM)

    oPrinter:Box(nRow,0100,nRow + (nRowStep * 1.25 * Len(aDesc)),3200)                     // SQ
    oPrinter:Box(nRow,0180,nRow + (nRowStep * 1.25 * Len(aDesc)),0403)                     // Item
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
    oPrinter:Say(nRow - 0008   ,0120    ,SubStr(AllTrim((_cAlias)->_ITEM),1,15)                                                                                                 ,oFont9)    // ITEM
    oPrinter:Say(nRow - 0008   ,0225    ,Substr((_cAlias)->_DATPRF,7,2)+"/"+Substr((_cAlias)->_DATPRF,5,2)+"/"+Substr((_cAlias)->_DATPRF,1,4)                                   ,oFont9)    // DT.ENTREGA
    oPrinter:Say(nRow - 0008   ,0415    ,(_cAlias)->_PRODUTO                                                                                                                    ,oFont9)    // CÓDIGO
    oPrinter:Say(nRow - 0008   ,1267    ,Posicione("SB1",1,xFilial("SB1")+(_cAlias)->_PRODUTO,"B1_UM")                                                                          ,oFont9)    // MEDIDA
    oPrinter:Say(nRow - 0008   ,1414    ,Transform(NoRound((_cAlias)->_QTDCOM,2) ,"@E 999999.99")                                                                               ,oFont9)   // QTD
    oPrinter:Say(nRow - 0008   ,1540    ,Transform(NoRound((_cAlias)->_PRUNIT,2) ,cPicVal)                                                                                      ,oFont9)    // VALOR UNITÁRIO
    oPrinter:Say(nRow - 0008   ,1709    ,Transform(NoRound((_cAlias)->_IPI,2) ,cPicAliq)                                                                                        ,oFont9)    // % IPI
    oPrinter:Say(nRow - 0008   ,1810    ,Transform(NoRound((_cAlias)->_VALIPI,2) ,cPicVal)                                                                                      ,oFont9)    // VALOR IPI
    oPrinter:Say(nRow - 0008   ,1954    ,Transform(NoRound((_cAlias)->_PICM,2), cPicAliq)                                                                                       ,oFont9)    // % ICMS
    oPrinter:Say(nRow - 0008   ,2050    ,Transform(NoRound((_cAlias)->_VALICM,2),cPicVal)                                                                                       ,oFont9)    // VALOR ICMS
    oPrinter:Say(nRow - 0008   ,2210    ,Transform(NoRound(nTaxaCof + nTaxaPis,2),cPicAliq)                                                                                     ,oFont9)    // % PIS/COFINS
    oPrinter:Say(nRow - 0008   ,2290    ,Transform(NoRound((_cAlias)->_VALIMP5 + (_cAlias)->_VALIMP6,2),cPicVal)                                                                ,oFont9)    // VALOR PIS/COFINS
    oPrinter:Say(nRow - 0008   ,2550    ,Transform(NoRound((_cAlias)->_ICMSRET,2),cPicVal)                                                                                      ,oFont9)    // VALOR ICMS ST
    oPrinter:Say(nRow - 0008   ,2780    ,Transform(NoRound((_cAlias)->_TOTAL + ((_cAlias)->_FRETE + (_cAlias)->_DESPESA) + (_cAlias)->_VALIPI / (_cAlias)->_QTDCOM,2),cPicVal)  ,oFont9)    // VALOR UNIT C/ IMPOSTOS
    oPrinter:Say(nRow - 0008   ,3010    ,Transform(NoRound((_cAlias)->_TOTAL + ((_cAlias)->_FRETE + (_cAlias)->_DESPESA ) + (_cAlias)->_VALIPI,2) ,cPicVal)                     ,oFont12B)  // VALOR TOTAL
    
    //Adiciona valor nas variáveis totalizadoras para uso no rodapé
    nTotPed += 	((_cAlias)->_TOTAL + (_cAlias)->_VALIPI + (_cAlias)->_FRETE + (_cAlias)->_DESPESA) 
    nValFret += (_cAlias)->_VALFRE
    nValDesp += (_cAlias)->_DESPESA
    nValDesc += (_cAlias)->_DESCONT
    nValST   += (_cAlias)->_ICMSRET

    For nDesc := 1 to Len(aDesc)
        oPrinter:Say(nRow - 0008       ,0660           ,aDesc[nDesc]                                                                                                           ,oFont9)     // DESCRIÇÃO
        nRow += nRowStep
    Next

    nRow -= nRowStep
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M02RDescr(cProd,cDescSB1,cDescSC6,nComp,nLar,nAlt,cItem)
    Local aRet      := {}
    Local cAux      := ""
    Local cLetras   := ""
    Local cRet      := ""
    Local i         := 0
    Local nTam      := 45
    Local nIni      := 1
    Local nQuebra   := 1
    Local cPic      := "@E 999999"

    If cProd == 'N/A'
        cDesc   := cDescSC6
    Else
        cDesc   := cDescSB1

        If nComp > 0 .And. nLar > 0 .And. nAlt > 0
            cDesc += ' - MEDINDO: ' + AllTrim(Transform(nComp,cPic)) + ' X ' + AllTrim(Transform(nLar,cPic)) + ' X ' + AllTrim(Transform(nAlt,cPic))
        EndIf
    EndIf
    
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
Static Function MR02Posiciona()
    Local lRet  := .T.

    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    If !SA2->(DbSeek( xFilial('SA2')  + SC3->(C3_FORNECE + C3_LOJA)))
        MsgInfo(I18N('Não foram encontrados dados do fornecedor #1 loja #2.' + CRLF + 'Verifique.',{SC3->C3_FORNECE,SC3->C3_LOJA}),"Atenção")
        lRet := .F.
    EndIf

Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M02RFont(oFont9,oFont12,oFont12B,oFont14B,oFont18T)
    oFont9      := TFont():New('Arial',,9)
    oFont12     := TFont():New('Arial',,12)
    oFont12B    := TFont():New('Arial',,12,.T.,.T.)
    oFont14B    := TFont():New('Arial',,14,.T.,.T.)
    oFont18T    := TFont():New('Arial',,18,.T.,.T.)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab1(oPrinter,oFont14B,oFont12,nRow)
    Local cNome         := 'HOSHIZAKI MACOM LTDA'
    Local cEndC         := 'Av Julia Gaiolli, 474, Bonsucesso, Guarulhos-SP, CEP 07251-500'
    Local cCGC          := 'CNPJ: 43.553.668/0001-79 I.E.: 336.179.661.113'
    Local cTel          := 'Telefone: 55 11 2085-7000'
    Local cMail         := 'www.acosmacom.com.br'
    Local nRowStep      := 45

    oPrinter:SayBitmap(nRow ,0100,GetSrvProfString("Startpath","") + 'LOGO_M05R02.BMP', 751 ,178 )

    oPrinter:Say(nRow                 ,2404         , cNome     ,oFont14B)
    oPrinter:Say(nRow += nRowStep     ,2404         , cEndC     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2404         , cCGC      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2404        , cTel      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2404        , cMail     ,oFont12)

    nRow += nRowStep
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab2(oPrinter,oFont12,oFont18T,nRow,oFont14B)
    Local lRet          := .T.
    Local cMascCPF      := "@R 999.999.999-99"
    Local cMascCNPJ     := "@R 99.999.999/9999-99"
    Local nRowStep      := 45

    If lRet
        nRow += nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_NOME))     ,oFont18T)      // Fornecedor
        oPrinter:Say(nRow                 ,1800    , 'CNPJ/CPF: '                     ,oFont12)
        oPrinter:Say(nRow                 ,2000    , Transform( AllTrim(SA2->A2_CGC), IIF(SA2->A2_TIPO == 'F',cMascCPF,cMascCNPJ))     ,oFont12)
        oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_END))     ,oFont12)
        oPrinter:Say(nRow                 ,1800    , 'IE.: '                         ,oFont12)
        oPrinter:Say(nRow                 ,2000    , Transform( AllTrim(SA2->A2_INSCR), "@R 999.999.999.999" ) ,oFont12)
        oPrinter:Say(nRow                 ,2700    , 'GUARULHOS, ' + MR02Date() ,oFont12)
        oPrinter:Say(nRow += nRowStep     ,0100    , Upper(AllTrim(SA2->A2_BAIRRO)) + ' - ' + Upper(AllTrim(SA2->A2_MUN)) + ' - ' + Upper(AllTrim(SA2->A2_EST)) + ' - CEP: ' + Transform(AllTrim(SA2->A2_CEP), "@R 99999-999" ) ,oFont12)

        nRow += nRowStep
        oPrinter:Line(nRow, 0100,nRow, 3200)
        oPrinter:Say(nRow + 70            ,1300    , 'CONTRATO DE PARCERIA'          ,oFont18T)
        
    EndIf
Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab4(oPrinter,oFont12,oFont14B,oFont18T,nRow)
    Local nRowStep  := 45
    Private oBrush    := TBrush():New( , RGB( 240 ,240 ,240))

    nRow += (nRowStep * 2)

    oPrinter:Line(nRow,0100,nRow, 3200)

    oPrinter:Say(nRow += nRowStep     ,0100    , 'CONTRATO DE FORNECIMENTO: '     ,oFont12)
    oPrinter:Say(nRow                 ,0640    , SC3->C3_NUM  		              ,oFont14B)

	oPrinter:Say(nRow                 ,2700    , 'FORNECEDOR/LOJA:'    ,oFont12)
    oPrinter:Say(nRow                 ,3050    , SC3->C3_FORNECE + '/' + SC3->C3_LOJA   ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100    , 'COND PAG: '                           ,oFont12)
    oPrinter:Say(nRow                 ,0440    , MR02GetCPg()                           ,oFont12)
    
    oPrinter:Say(nRow                 ,2700    , 'SOLIC. COMPRA: '                          ,oFont12)
//  oPrinter:Say(nRow                 ,3050    , SC3->C3_NUMSC                          ,oFont12) 
    
    oPrinter:Say(nRow += nRowStep     ,0100    ,'OBSERVAÇÕES'     ,oFont12)
//  oPrinter:Say(nRow                 ,0440    ,AllTrim(SC3->C3_OBS)                    ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,0100    ,'COMPRADOR RESPONSÁVEL'                 ,oFont12)
    oPrinter:Say(nRow                 ,0550    ,AllTrim(USRFULLNAME(SC3->C3_USER))      ,oFont12)
    
    oPrinter:Say(nRow                 ,2700    , 'CONTATO: '                            ,oFont12)
    oPrinter:Say(nRow                 ,3050    , SC3->C3_CONTATO                        ,oFont12)     
        
    nRow += (nRowStep * 0.50)
    oPrinter:Line(nRow, 0100,nRow, 3200)
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Rod(oPrinter,oFont12,oFont12B,oFont14B,nRow,nPage,cData,nTotPed,nValFret,nValDesp,nValDesc,nValST)
	
    Local nRowStep      := 45
    Private cPicVal       := "@E 99,999,999.99"
    Private cPicAliq      := "@E 999.99"
    Private cPicQtd       := "@E 999999.99"
    Private cPolitic      := 'A MACOM adota a política de proibição de oferta e/ou recebimento de presentes/brindes em transações comerciais, prezando por sua legitimidade, transparência e imparcialidade.'
    Private aArea			:= {}
//    Local cDespesa      := Transfor(NoRound(MaFisRet(,"NF_DESPESA"),2),cPicVal)
//    Local cFrete        := Transfor(NoRound(IIF(SC5->C5_TPFRETE == 'C',MaFisRet(,"NF_FRETE"),0),2),cPicVal)
//    Local cTotal        := Transfor(NoRound(MaFisRet(,"NF_TOTAL"),2),cPicVal)
//    Local cSubTot       := Transfor( NoRound(( MaFisRet(,"NF_TOTAL") - ( MaFisRet(,"NF_FRETE") + MaFisRet(,"NF_DESPESA") ) ),2),cPicVal)
//    Local cMoeda        := AllTrim(GetMv('MV_MOEDA' + cValToChar(SC5->C5_MOEDA),,''))

    nRow += (nRowStep * 5)

    oPrinter:Say(nRow + 1260                ,0100        , cPolitic  ,oFont14b)

    If nRow > 1600
        nRow := 2100 + nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Contrato de Fornecimento #1 impresso em #2.',{SC3->C3_NUM,cData })  ,oFont12)
        oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)

        oPrinter:EndPage()
        oPrinter:StartPage()
        nRow := 0000

        nPage++
    EndIf

//    oPrinter:Say(nRow += nRowStep     ,0100     ,'TIPO FRETE: '                ,oFont12)
//    oPrinter:Say(nRow                 ,0300     ,M05RTpFret()                  ,oFont12)

//    oPrinter:Line(nRow - nRowStep * 1.25, 2350,nRow - nRowStep* 1.25 , 3200)
    oPrinter:Say(nRow                 ,2450     ,'DESCONTO:'                                     ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,Transform(NoRound(nValDesc,2) ,"@E 999999.99")  ,oFont12)

//    oPrinter:Say(nRow += nRowStep     ,0100     ,'DESCONTO: '                                    ,oFont12)
//    oPrinter:Say(nRow                 ,0300     ,Transform(NoRound(nValDesc,2) ,"@E 999999.99")  ,oFont12)
    
    oPrinter:Say(nRow += nRowStep     ,2450     ,'VALOR FRETE: '                                 ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,Transform(NoRound(nValFret,2) ,"@E 999999.99")  ,oFont12)

    oPrinter:Say(nRow += nRowStep     ,2450     ,'DESPESA'                     ,oFont12)
    oPrinter:Say(nRow                 ,2900     ,Transform(NoRound(nValDesp,2) ,"@E 999999.99")  ,oFont12)

    nRow += nRowStep

    oPrinter:Line(nRow - nRowStep * 0.5, 2350,nRow - nRowStep * 0.5, 3200)
    oPrinter:Say(nRow += (nRowStep )  ,2450     ,'TOTAL GERAL'                                              ,oFont14B)
    oPrinter:Say(nRow                 ,2900     ,Transform(NoRound(nTotPed + nValFret + nValST - nValDesc,2) ,"@E 9,999,999.99")   ,oFont14B) 
                                                 
    nRow += nRowStep
    nRow += nRowStep

    oPrinter:Say(nRow += nRowStep     ,2450    , 'HOSHIZAKI MACOM LTDA'         ,oFont12B)
//	aArea := SA3->(GetArea())
//  oPrinter:Say(nRow += nRowStep     ,2450    , 'GERÊNCIA: ' + AllTrim(Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"SA3->A3_NOME"))          ,oFont12)

    nRow += nRowStep

//	RestArea(aArea)
//    oPrinter:Say(nRow += nRowStep     ,2450    , 'REPRESENTANTE COMERCIAL '                     ,oFont12)
//    oPrinter:Say(nRow += nRowStep     ,2450    , AllTrim(SA3->A3_NOME)                          ,oFont12)
    //oPrinter:Say(nRow += nRowStep     ,2450    , AllTrim(SA3->A3_NREDUZ),oFont12)
//    oPrinter:Say(nRow += nRowStep     ,2450    , SA3->A3_DDDTEL + ' ' + Transform(AllTrim(SA3->A3_TEL), "@R 9999-99999" ) ,oFont12)

    nRow := 2100 + nRowStep

    oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Contrato de Fornecimento #1 impresso em #2.',{SC3->C3_NUM,cData })  ,oFont12)
    oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)
    
    oPrinter:Say(nRow += nRowStep     ,0100    , 'NOTA: Só aceitaremos a mercadoria se na sua Nota Fiscal constar o numero de nosso Contrato'                                                      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,0100    , 'As faturas/Boletos para pagamentos aos fornecedores serão efetuados somente as SEXTAS-FEIRAS, respeitando o prazo mínimo acordado em contrato de fornecimento.'  ,oFont12)        
    

    oPrinter:EndPage()
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
Static Function M05RTpFret()
    Local cRet  := ''

    Do Case
    Case SC5->C5_TPFRETE == 'C'
        cRet := 'CIF'
    Case SC5->C5_TPFRETE == 'F'
        cRet := 'FOB'
    Case SC5->C5_TPFRETE == 'T'
        cRet := 'Por Conta de Terceiros'
    Case SC5->C5_TPFRETE == 'S'
        cRet := 'Sem Frete'

    End Case
Return cRet
/*/

//+------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
Static Function M05RTpIsnt()
    Local cRet  := ''

    Do Case
    Case SC5->C5_XTPINST == '1'
        cRet := 'Sem Instalação'
    Case SC5->C5_XTPINST == '2'
        cRet := 'Credenciada (Vide condições gerais de fornecimento)'
    Case SC5->C5_XTPINST == '3'
        cRet := 'Macom'
    Case SC5->C5_XTPINST == '4'
        cRet := 'Rateio no Produto'

    End Case
Return cRet
/*/

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02GetCPg()
    Local cRet  := ''

    SE4->(DbSetOrder(1))
    SE4->(DbGotop())

    If SE4->(DbSeek( xFilial('SE4') + SC3->C3_COND ))
        cRet := AllTrim(SE4->E4_CODIGO) + ': ' + AllTrim(SE4->E4_DESCRI) //+ ' - '  + AllTrim(SC5->C5_XDESPAG)
    EndIf
Return cRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Date()
    Local cDay  := StrZero(Day(SC3->C3_EMISSAO),2)   //StrZero(Day(Date()),2) -- Modelo Antigo
    Local nMon  := Month(SC3->C3_EMISSAO) 			 //Month(Date())		  -- Modelo Antigo
    Local cMon  := ''
    Local cYear := cValToChar(Year(SC3->C3_EMISSAO))

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
Static Function MR02EndPag(oPrinter,oFont12,oFont12B,nRow,nRowStep,nPage,cData,nItem,_nTotal)
    If nRow > 2000

        nRow := 2100 + nRowStep

        oPrinter:Say(nRow += nRowStep     ,0100    , I18N('Contrato de Fornecimento #1 impresso em #2.',{SC3->C3_NUM,cData })  ,oFont12)
        oPrinter:Say(nRow                 ,3000    , I18N('Pág. #1',{oPrinter:nPageCount  })  ,oFont12)
		oPrinter:Say(nRow += nRowStep     ,2450    , 'HOSHIZAKI MACOM LTDA'         ,oFont12B)	
        oPrinter:EndPage()
        oPrinter:StartPage()
        nRow := 0000

        nPage++
    EndIf
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Planil(cNum,cAliasPed,_nTotal)

    Private nBaseIcm      := 0
    Private nValIcm       := 0
    Private nValIPI       := 0
    Private nBaseRet      := 0
    Private nValRet       := 0
    Private nVlrTot       := 0
    Private nBaseISS      := 0
    Private vValISS       := 0
    Private nTotValdesc  := 0
    Private nC5Desc1      := 0
    Private nC5Desc2      := 0
    Private nC5Desc3      := 0
    Private nC5Desc4      := 0
    Private nC5Frete      := 0
    Private nC5Seguro     := 0
    Private nC5Despesa    := 0

    Private cCondicao     := ""
    Private aParcelas     := {}
    Private aPedCli       := {}
    Private aC5Rodape     := {}
    Private aFisGet       := Nil
    Private aFisGetSC5    := Nil
    Private cKey          := ""
    Private cAliasSC3     := "SC3"
    Private cQryAd        := ""
    Private cPedido       := ""
    Private cCliEnt       := ""
    Private cNfOri        := Nil
    Private cSeriOri      := Nil
    Private nDesconto     := 0
    Private nPesLiq       := 0
    Private nRecnoSD1     := Nil
    Private nG            := 0
    Private nFrete        := 0
    Private nSeguro       := 0
    Private nFretAut      := 0
    Private nDespesa      := 0
    Private nDescCab      := 0
    Private nPDesCab      := 0
    Private nY            := 0
    Private nValMerc      := 0
    Private nPrcLista     := 0
    Private nAcresFin     := 0
    Private nCont         := 0
    Private aItemPed      := {}
    Private aCabPed       := {}
    Private nVlrtotal     := 0
    Private nValSOL       := 0

    cAliasPed := cAliasSC3 := GetNextAlias()
    BeginSql Alias cAliasPed
        SELECT SC3.R_E_C_N_O_       AS REC_CAB
            ,SC3.R_E_C_N_O_         AS REC_ITEM
            ,SC3.C3_FILIAL          AS _FILIAL
            ,SC3.C3_NUM             AS _NUM
            ,SC3.C3_FORNECE         AS _FORNECE
            ,SC3.C3_LOJA            AS _LOJA
            ,SC3.C3_EMISSAO         AS _EMISSAO
            ,SC3.C3_DATPRF          AS _DATPRF
            ,SC3.C3_COND         	AS _CONDPAG
            ,SC3.C3_QUANT           AS _QTDCOM
            ,SC3.C3_PRECO           AS _PRUNIT
            ,SC3.C3_TOTAL           AS _TOTAL            
            ,SC3.C3_FRETE           AS _FRETE
            ,SC3.C3_VALFRE          AS _VALFRE
            ,SC3.C3_TPFRETE         AS _TFRETE            
            ,SC3.C3_MOEDA           AS _MOEDA
            ,SC3.C3_PRODUTO         AS _PRODUTO
            ,SC3.C3_ITEM            AS _ITEM
            ,SC3.C3_DATPRF          AS _ENTREG
            ,0          AS _DESPESA
            ,0          AS _SEGURO
            ,'   '      AS _TES
            ,' '        AS _CODTAB
            ,0          AS _VALDESC
            ,' '        AS _DESCRI
            ,' '        AS _UM
            ,0          AS _DESCONT
            ,' '        AS _LOCAL
            ,0          AS _IPI
            ,0          AS _VALIPI
            ,0          AS _PICM
            ,0          AS _VALICM
            ,0          AS _VALIMP5
            ,0          AS _VALIMP6
            ,0          AS _ICMSRET

//            ,SC3.C3_DESPESA         AS _DESPESA
//            ,SC3.C3_SEGURO          AS _SEGURO
//            ,SC3.C3_TES             AS _TES
//            ,SC3.C3_CODTAB          AS _CODTAB
//            ,SC3.C3_DESC            AS _VALDESC
//            ,SC3.C3_DESCRI          AS _DESCRI
//            ,SC3.C3_UM              AS _UM
//            ,SC3.C3_VLDESC          AS _DESCONT
//            ,SC3.C3_LOCAL           AS _LOCAL
//            ,SC3.C3_REAJUST         AS _REAJUST
//            ,SC3.C3_IPI             AS _IPI
//            ,SC3.C3_VALIPI          AS _VALIPI
//            ,SC3.C3_PICM            AS _PICM
//            ,SC3.C3_VALICM          AS _VALICM
//            ,SC3.C3_VALIMP5         AS _VALIMP5
//            ,SC3.C3_VALIMP6         AS _VALIMP6
//            ,SC3.C3_ICMSRET         AS _ICMSRET
//            ,SC3.C3_REAJUST         AS _REAJUST

            ,SC3.C3_OBS         	AS _OBS
            ,SC3.C3_USER            AS _CODUSR
        FROM %Table:SC3% SC3
        WHERE   SC3.C3_FILIAL = %xFilial:SC3% AND
                SC3.C3_NUM = %Exp:cNum% AND
                SC3.%notdel% 
        ORDER BY SC3.C3_ITEM
    EndSql

    (cAliasPed)->(DbGoTop())
Return
