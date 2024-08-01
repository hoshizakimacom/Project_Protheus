#INCLUDE 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
#Include "TopConn.ch"

//+------------------------------------------------------------------------------------------------------------------------------------------------------
//| Relatório Pick - List
//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M10R12()
    FWMsgRun(, {|| U_M10R12A() },'Picking - List','Gerando relatório...')
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M10R12A()

Local oPrinter     := Nil

Local nRow         := -0070
Local cData        := DtoC(Date()) + ' ' + Time()
Local _cNumOP      := SC2->C2_NUM
Local _nQtdOP      := SC2->C2_QUANT
Local _cCodProd    := SC2->C2_PRODUTO
Local nPage        := 1
Private oFont9     := TFont():New('Arial',,9)
Private oFont12    := TFont():New('Arial',,12)
Private oFont12B   := TFont():New('Arial',,12,.T.,.T.)
Private oFont14B   := TFont():New('Arial',,14,.T.,.T.)
Private oFont18T   := TFont():New('Arial',,18,.T.,.T.) 
Private nEstru     := 0

//M02RFont(@oFont9,@oFont12,@oFont12B,@oFont14B,@oFont18T)

oPrinter := FWMSPrinter():New('PK' + SC2->C2_NUM + '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":",""), IMP_PDF, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.)

oPrinter:SetResolution(78)
oPrinter:SetLandscape()
oPrinter:SetMargin(0,0,0,0)

//oPrinter:StartPage()

If MR02Posiciona()

    M10RIItens(oPrinter,oFont9,oFont12,oFont12B,@nRow,@nPage,cData,_cNumOP,_nQtdOP,_cCodProd)

    oPrinter:EndPage()
    oPrinter:Print()
    FreeObj(oPrinter)

EndIf

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function M10RIItens(oPrinter,oFont9,oFont12,oFont12B,nRow,nPage,cData,_cNumOP,_nQtdOP,_cCodProd)

Local aEstru        := {}
Local cQuery        := ''
Local _nRegSg1      := 0

Local nColBar       := 2.3    
Local nRowStep      := 25
Local nRowBar       := 60 //9.5
Local nX            := 0
Private nEstru      := 0
Private cAnsul      := " "
Private nPagina     := 0

cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, ANSUL, NIVEL ) AS "
cQuery += "( "

cQuery += "SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, G1_XANSUL, 1 AS NIVEL "
cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "
cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
cQuery += "AND G1_FILIAL      = '"+FWxFilial("SG1")+"' " 

cQuery += "UNION ALL "

cQuery += "SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, G1_XANSUL, NIVEL + 1 "
cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "
cQuery += "INNER JOIN ESTRUT EST "
cQuery += "ON G1_COD = COD_COMP "
cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
cQuery += "AND SG1.G1_FILIAL = '"+FWxFilial("SG1")+"' "

cQuery += ") "

cQuery += "SELECT * "
cQuery += "FROM ESTRUT E1 "
cQuery += "WHERE E1.CODIGO = '"+_cCodProd+"' "
cQuery += "AND E1.DT_FIM >= '20471231' "

TcQuery cQuery New Alias (cAlias := GetNextAlias())
(cAlias)->(DbEval({|| _nRegSg1 ++ }))
(cAlias)->(DbGoTop())

While ! (cAlias)->(Eof())  
    //AllTrim(aEstru[nX,3] ->(cAlias)->COD_COMP  
    //aEstru[nX,4] -> (cAlias)->QTD
    //aEstru := Estrut(_cCodProd,1)

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+(cAlias)->COD_COMP)
    If SB1->B1_XPICLIS <> "1"
        (cAlias)->(DbSkip())
        Loop
    EndIf

    Aadd(aEstru, {FwxFilial("SD3"),;
            '501',;
            (cAlias)->COD_COMP,;
            SB1->B1_DESC,;
            SB1->B1_TIPO,; //#5659
            SB1->B1_UM,;
            (cAlias)->QTD,;                 
            _cNumOP,;
            SB1->B1_LOCPAD,;
            (cAlias)->ANSUL,;                 
            .F.})  

    (cAlias)->(DbSkip())
Enddo

(cAlias)->(DBCLOSEAREA())

// Ordena por Ansul - 1-Interno ; 2-Externo ; 3-Nao/Vazio
aEstru := aSort(aEstru,,,{|x,y| x[10]+x[3] < y[10]+y[3]}) 

//lPklist       := IIF(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_XPICLIS") == "1",.T.,.F.)
nRow += nRowStep 

If Empty(aEstru)

    oPrinter:StartPage()

    //+----------------------------------------------------------------------------------------
    // Cabeçalho 1 - Dados Macom
    //+----------------------------------------------------------------------------------------
    MR02Cab1(oPrinter,oFont14B,oFont12,@nRow)

    //+----------------------------------------------------------------------------------------
    // Cabeçalho 2 - Dados do Fornecedor   *****************
    //+----------------------------------------------------------------------------------------
    MR02Cab2(oPrinter,oFont12,oFont18T,@nRow,oFont14B)

    M02RICabIt(oPrinter,oFont12B,@nRow,cAnsul)
    nRow += 100 
    oPrinter:Say(nRow  ,0120    ,"PRODUTO SEM ESTRUTURA"            ,oFont12B)

Else
    cAnsul := " "

    For nX := 1 To Len(aEstru)

//        If Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_XPICLIS") == "1" // Implementação futura qualidade -> .And. Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_TIPO") == "PI"

        If nRowBar > 44  .Or. cAnsul <> aEstru[nX,10] //== 9.5  // Primeira Vez ou troca de Ansul
            nRow      := -0070
            nRowBar   := 9.5
            nColBar   := 2.3
            cAnsul    := aEstru[nX,10]

            If nPagina == 0
                nPagina ++
            Else
                cPagina := "Folha "+StrZero(nPagina,3)
                nRowPag := 2360
                oPrinter:Say(nRowPag ,2930, cPagina,oFont18T)
                nPagina ++
            EndIf

            oPrinter:StartPage()

            //+----------------------------------------------------------------------------------------
            // Cabeçalho 1 - Dados Macom
            //+----------------------------------------------------------------------------------------
            MR02Cab1(oPrinter,oFont14B,oFont12,@nRow)

            //+----------------------------------------------------------------------------------------
            // Cabeçalho 2 - Dados do Fornecedor   *****************
            //+----------------------------------------------------------------------------------------
            MR02Cab2(oPrinter,oFont12,oFont18T,@nRow,oFont14B)

            M02RICabIt(oPrinter,oFont12B,@nRow,cAnsul)

        Endif
    
        MR02ImpItem(oPrinter,@nRow,@nRowBar,@nColBar,oFont9,oFont12B,_cNumOP,_nQtdOP,_cCodProd,aEstru,nX)

        If nX == Len(aEstru)
            cPagina := "Folha "+StrZero(nPagina,3)
            nRowPag := 2360
            oPrinter:Say(nRowPag ,2930, cPagina,oFont18T)
        Endif

 //       Endif
    Next
Endif

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02ImpItem(oPrinter,nRow,nRowBar,nColBar,oFont9,oFont12B,_cNumOP,_nQtdOP,_cCodProd,aEstru,nX)

Local nRowStep      := 80
Local nRowBStep     := 2.8 // valor anterior 2.2
Local nColBarQtd    := 67.8

nRow += nRowStep
nRowBar += nRowBStep

If nX > 2
    nRow += 55 // valor anterior 28
Endif	

oPrinter:FWMSBAR('CODE128',nRowBar,nColBar,AllTrim(aEstru[nX,3]),oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)
oPrinter:Say(nRow    ,0800    ,AllTrim(aEstru[nX,3])                                                                     ,oFont12B)    // Código do Produto
oPrinter:Say(nRow    ,1100    ,AllTrim(Substr(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_DESC"),1,84))   ,oFont12B)    // Descrição
oPrinter:Say(nRow    ,2400    ,AllTrim(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_TIPO"))                ,oFont12B)    // TIPO #5659
oPrinter:Say(nRow    ,2550    ,AllTrim(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_UM"))                  ,oFont12B)    // Unidade de Medida
oPrinter:Say(nRow    ,2750    ,AllTrim(Transform(NoRound(aEstru[nX,7] * SC2->C2_QUANT,2) ,"@E 999999.99"))               ,oFont12B)    // Quantidade do componente na estrutura proporcional a quantidade da O.P.
oPrinter:FWMSBAR('CODE128',nRowBar,nColBarQtd,AllTrim(Transform(NoRound(aEstru[nX,7] * SC2->C2_QUANT,2) ,"@E 999999.99")),oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
//
//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Posiciona()

Local lRet  := .T.

dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(DbSeek( xFilial('SB1') + SC2->C2_PRODUTO))
    MsgInfo(I18N('Não foram encontrados dados do produto #1 .' + CRLF + 'Verifique.',{SC2->C2_PRODUTO}),"Atenção")
    lRet := .F.
EndIf

Return lRet

Static Function MR02Cab1(oPrinter,oFont14B,oFont12,nRow)

Local cNome         := ' AÇOS MACOM INDÚSTRIA E COMERCIO LTDA'
Local cEndC         := 'Av Julia Gaiolli, 474, Bonsucesso, Guarulhos-SP, CEP 07251-500'
Local cCGC          := ' CNPJ: 43.553.668/0001-79 I.E.: 336.179.661.113'
Local cTel          := 'Telefone: 55 11 2085-7000'
Local cMail         := 'www.acosmacom.com.br'
Local nRowStep      := 45
Local _cUserImpress := PswChave(RetCodUsr())  //5659

oPrinter:SayBitmap(nRow ,0100,GetSrvProfString("Startpath","") + 'LOGO_M05R02.BMP', 751 ,178 )

oPrinter:Say(nRow                 ,2450         , cNome     ,oFont14B)
oPrinter:Say(nRow += nRowStep     ,2400         , cEndC     ,oFont12)
oPrinter:Say(nRow += nRowStep     ,2588         , cCGC      ,oFont12)
oPrinter:Say(nRow += nRowStep     ,2876         , cTel      ,oFont12)
oPrinter:Say(nRow += nRowStep     ,2900         , cMail     ,oFont12) 
oPrinter:Say(nRow += nRowStep     ,2580         ,'Impresso por: ' + _cUserImpress + ' as ' + Left(Time(),5) + ' de ' + DtoC(Date())         ,oFont12) //5659
nRow += nRowStep

Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab2(oPrinter,oFont12,oFont18T,nRow,oFont14B,cAnsul)

Local lRet          := .T.
Local nRowStep      := 45

If lRet
    nRow += nRowStep  
    
    oPrinter:Say(nRow                 ,0100    , "O.P. : " + Upper(AllTrim(SC2->C2_NUM)) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN) ,oFont14B)
    oPrinter:FWMSBAR('CODE128',2.3    ,10.3     , AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN),oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)
    //oPrinter:Say(nRow += nRowStep   ,0100    , "ITEM O.P. : " + AllTrim(SC2->C2_ITEM)        ,oFont14B)
    oPrinter:Say(nRow += nRowStep     ,0100    , "PRODUTO : " + AllTrim(SC2->C2_PRODUTO),oFont14B)
    oPrinter:Say(nRow                 ,2876    , "QUANTIDADE = " + AllTrim(Str(SC2->C2_QUANT)),oFont14B)

    oPrinter:Say(nRow += nRowStep     ,0100    , AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"))        ,oFont14B)
    oPrinter:Say(nRow                 ,2876    , "FGQ-AL-011-Rev01", oFont12)  //#6748

    nRow += nRowStep 
    oPrinter:Line(nRow, 0100,nRow, 3200)
EndIf

Return lRet

Static Function M02RICabIt(oPrinter,oFont12B,nRow,cAnsul)

Local nRowStep := 130

oPrinter:Say(nRow + 70 ,1350, "P  I  C  K  I  N  G  -  L  I  S  T"  ,oFont18T)
If cAnsul == "1"
    oPrinter:Say(nRow + 70 ,2830, "ANSUL INTERNO" ,oFont18T)
ElseIf cAnsul == "2"
    oPrinter:Say(nRow + 70 ,2830, "ANSUL EXTERNO" ,oFont18T)
EndIf

nRow += nRowStep
oPrinter:Say(nRow                ,0110                ,'C.B. CÓDIGO'          ,oFont12B)
oPrinter:Say(nRow                ,0750                ,'CÓDIGO PRODUTO'       ,oFont12B)
oPrinter:Say(nRow                ,1500                ,'DESCRIÇÃO'            ,oFont12B)
oPrinter:Say(nRow                ,2400                ,'TIPO'                 ,oFont12B) //5659
oPrinter:Say(nRow                ,2550                ,'U.M.'                 ,oFont12B)
oPrinter:Say(nRow                ,2680                ,'QUANTIDADE'           ,oFont12B)
oPrinter:Say(nRow                ,2970                ,'C.B. QTD'             ,oFont12B)
//  oPrinter:Say(nRow            ,3060                ,'ANSUL'                ,oFont12B)

Return
