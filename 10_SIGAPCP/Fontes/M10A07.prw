//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
 
Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
Static oBmpVerme    := LoadBitmap( GetResources(), "BR_VERMELHO")

/*/{Protheus.doc} M10A07
Função para fazer os apontamentos de Picking List
@author Graziella
@since 22/12/2022                (cAlias)->QTD,;                 

@version 1.0
@type function
/*/
 
User Function M10A07()

Local cPerg     := 'M10A07'
//Private cAnsul

PUBLIC _cNumOP  := ''
PUBLIC _nQuant   := 0
PUBLIC _cCdPro   := ""

If Pergunte(cPerg)

    _cNumOP := AllTrim(MV_PAR01)
    _nQuant := Posicione("SC2",1,xFilial("SC2")+AllTrim(MV_PAR01),"C2_QUANT")
    _cCdPro := AllTrim(Posicione("SC2",1,xFilial("SC2")+AllTrim(MV_PAR01),"C2_PRODUTO"))
//    cAnsul  := If(mv_par02==1,"1",If(mv_par02==2,"2","3"))    

    Processa({|| M10A0701(_cNumOP,_nQuant,_cCdPro)}, "Carregando dados P I C K I N G - L I S T ")

Endif

Return

Static Function M10A0701(_cNumOP,_nQuant,_cCdPro)

Local _cQuery   := ""
Local _nRegSg1  := 0
Local aSaldo    := {}
Local _ADETSD3  := {}
Local nSaldo    := 0
Local lDelLinha := .F.

Public _aCDetSD3 := {}

    _cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSqlName("SD3")+" WHERE D3_OP = '"+_cNumOP+"' AND D_E_L_E_T_ = ''"
    TcQuery _cQuery New Alias (cAlias := GetNextAlias())
    (cAlias)->(DbEval({|| _nRegSg1 ++ }))
    (cAlias)->(DbGoTop())

    If (cAlias)->QTD > 0 
        (cAlias)->(DBCLOSEAREA())
        FWAlertError("Favor utilizar a rotina de movimentação múltipla para OPs com apontamentos parciais", "Apontamento Parcial")
        Return
    Else
        _cQuery := ""
        _cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, ANSUL, NIVEL ) AS "
        _cQuery += "( "

        _cQuery += "SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, G1_XANSUL, 1 AS NIVEL "
        _cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "
        _cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
        _cQuery += "AND G1_FILIAL      = '"+FWxFilial("SG1")+"' " 
        If mv_par02 == 1  // Ansul Interno
            _cQuery += "AND G1_XANSUL = '1' " 
        ElseiF mv_par02 == 2  // Ansul Externo
            _cQuery += "AND G1_XANSUL = '2' "
        ElseiF mv_par02 == 3  // Não Ansul
            _cQuery += "AND G1_XANSUL NOT IN ('1','2') "
        EndIf
        _cQuery += "UNION ALL "

        _cQuery += "SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, G1_XANSUL, NIVEL + 1 "
        _cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "
        _cQuery += "INNER JOIN ESTRUT EST "
        _cQuery += "ON G1_COD = COD_COMP "
        _cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
        _cQuery += "AND SG1.G1_FILIAL = '"+FWxFilial("SG1")+"' "
        If mv_par02 == 1  // Ansul Interno
            _cQuery += "AND G1_XANSUL = '1' " 
        ElseiF mv_par02 == 2  // Ansul Externo
            _cQuery += "AND G1_XANSUL = '2' "
        ElseiF mv_par02 == 3  // Não Ansul
            _cQuery += "AND G1_XANSUL NOT IN ('1','2') "
        EndIf 
        _cQuery += ") "

        _cQuery += "SELECT * "
        _cQuery += "FROM ESTRUT E1 "
        _cQuery += "WHERE E1.CODIGO = '"+_cCdPro+"' "
        _cQuery += "AND E1.DT_FIM >= '20471231' "

        TcQuery _cQuery New Alias (cAlias := GetNextAlias())
        (cAlias)->(DbEval({|| _nRegSg1 ++ }))
        (cAlias)->(DbGoTop())

        While ! (cAlias)->(Eof())

            If Posicione("SB1",1,xFilial("SB1")+AllTrim((cAlias)->COD_COMP),"B1_XPICLIS") == "1" 
                
                aSaldo  := CalcEst(SB1->B1_COD,SB1->B1_LOCPAD,dDataBase + 1, SB1->B1_FILIAL)
                nSaldo  := aSaldo[1]

                If nSaldo >= (cAlias)->QTD
                    //Definindo a legenda padrão como preto
                    oBmpAux     := oBmpVerde
                    lDelLinha   := .F.
                else
                    //Definindo a legenda padrão como preto
                    oBmpAux     := oBmpVerme
                    lDelLinha   := .T.
                Endif
                                
                Aadd(_aDetSD3, {;
                    oBmpAux,;
                    FwxFilial("SD3"),;
                    '501',;
                    (cAlias)->COD_COMP,;
                    Posicione("SB1",1,xFilial("SB1")+AllTrim((cAlias)->COD_COMP),"B1_DESC"),;
                    Posicione("SB1",1,xFilial("SB1")+AllTrim((cAlias)->COD_COMP),"B1_UM"),;
                    (cAlias)->QTD*_nQuant,;                 
                    _cNumOP,;
                    Posicione("SB1",1,xFilial("SB1")+AllTrim((cAlias)->COD_COMP),"B1_LOCPAD"),;
                    (cAlias)->ANSUL,;
                    lDelLinha;
                })  

            Endif
            (cAlias)->(DbSkip())
        Enddo
        
        Processa({|| M10A0702(_aDetSD3)}, "Monta de Apontamento P I C K I N G - L I S T ")
    Endif
    (cAlias)->(DBCLOSEAREA())
Return

Static Function M10A0702(_aDetSD3)

    Local aArea := GetArea()
    Local aAlter:= {"D4_QTDEORI"}

    //Objetos da Janela
    Private oDlgPvt
    Private oMsGetSD3
    Private aHeadSD3 := {}
    Private aColsSD3 := _aDetSD3
    Private oBtnSalv
    Private oBtnFech
    Private oBtnLege
    //Tamanho da Janela
    Private    nJanLarg    := 1600
    Private    nJanAltu    := 700
    //Fontes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)
     
    //Criando o cabeçalho da Grid
    //              Título               Campo        Máscara                        Tamanho                   Decimal                   Valid      Usado  Tipo F3     Combo
    aAdd(aHeadSD3, {"",                  "XX_COR"   , "@BMP",                        002,                       0,                        ".F.",     "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHeadSD3, {"Filial",            "D4_FILIAL", "",                            TamSX3("D4_FILIAL")[01],   0,                        "",        ".T.", "C", "",    ""} )    
    aAdd(aHeadSD3, {"TM",                "D3_TM"    , "",                            TamSX3("D3_TM")[01],       0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"Código",            "D4_COD"   , "",                            TamSX3("D4_COD")[01],      0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"Descrição",         "B1_DESC"  , "",                            TamSX3("B1_DESC")[01],     0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"U.M.",              "B1_UM"    , "",                            TamSX3("B1_UM")[01],       0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"Quantidade",        "D4_QTDEORI","",                            TamSX3("D4_QTDEORI")[01],  0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadSD3, {"O.P",               "D4_OP"    , "",                            TamSX3("D4_OP")[01],       0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"Local",             "D4_LOCAL" , "",                            TamSX3("D4_LOCAL")[01],    0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadSD3, {"Ansul",             "G1_XANSUL", "",                            TamSX3("G1_XANSUL")[01],   0,                        "",        ".T.", "C", "",    ""} )
 

    //Criação da tela com os dados que serão informados
        DEFINE MSDIALOG oDlgPvt TITLE "Apontamentos Picking-List" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        
        //Labels gerais
        @ 004, 003 SAY "SIGAPCP"            SIZE 200, 030 FONT oFontAno  OF oDlgPvt COLORS RGB(149,179,215) PIXEL
        @ 004, 100 SAY "Apontamento de"     SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        @ 014, 100 SAY "Picking List  "     SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL
                  
        //Botões
        @ 006, 665 BUTTON oBtnFech                          PROMPT "Salvar"        SIZE 065, 018 OF oDlgPvt ACTION (fSalvar())         FONT oFontBtn PIXEL 
        @ 006, (nJanLarg/2-001)-(0067*01) BUTTON oBtnFech   PROMPT "Fechar"        SIZE 065, 018 OF oDlgPvt ACTION (oDlgPvt:End())     FONT oFontBtn PIXEL
               
        //Grid dos grupos
        oMsGetSD3 := MsNewGetDados():New(   029,;                   //nTop      - Linha Inicial
                                            003,;                   //nLeft     - Coluna Inicial
                                            (nJanAltu/2)-3,;        //nBottom   - Linha Final
                                            (nJanLarg/2)-3,;        //nRight    - Coluna Final
                                            GD_UPDATE + GD_DELETE,; //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
                                            "AllwaysTrue()",;       //cLinhaOk  - Validação da linha
                                            ,;                      //cTudoOk   - Validação de todas as linhas
                                            "",;                    //cIniCpos  - Função para inicialização de campos
                                            aAlter,;                //aAlter    - Colunas que podem ser alteradas
                                            1,;                     //nFreeze   - Número da coluna que será congelada
                                            9999,;                   //nMax      - Máximo de Linhas
                                            ,;                      //cFieldOK  - Validação da coluna
                                            ,;                      //cSuperDel - Validação ao apertar '+'
                                            ,;                      //cDelOk    - Validação na exclusão da linha
                                            oDlgPvt,;               //oWnd      - Janela que é a dona da grid
                                            aHeadSD3,;              //aHeader   - Cabeçalho da Grid
                                            aColsSD3)               //aCols     - Dados da Grid
        
    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    RestArea(aArea)
Return

/*--------------------------------------------------------*
 | Func.: fSalvar                                         |
 | Desc.: Função que percorre as linhas e faz a gravação  |
 *--------------------------------------------------------*/
Static Function fSalvar()

    Local aColsAux := oMsGetSD3:aCols
    Local nLinha   := 0
    Local _aCab1   := {}
    Local _aItem   := {}
    Local _atotitem:= {}
    Local nQueryRet:= 0
    Local _cQuery  := ""

    Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
    Private lMsErroAuto := .f. //necessario a criacao
    
    _aCab1 := { {"D3_DOC"    ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
                {"D3_TM"     ,"501"     , NIL},;
                {"D3_CC"     ,"        ", NIL},;
                {"D3_EMISSAO",ddatabase, NIL}}
    
    //Percorrendo todas as linhas
    For nLinha := 1 To Len(aColsAux)
        
        If aColsAux[nLinha,10] = .F.

            _aItem:={{"D3_COD" ,aColsAux[nLinha,4],NIL},;
                    {"D3_UM"   ,aColsAux[nLinha,6],NIL},; 
                    {"D3_QUANT",aColsAux[nLinha,7],NIL},;
                    {"D3_OP"   ,aColsAux[nLinha,8],NIL}}

            aadd(_atotitem,_aitem) 
            MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

            _atotitem:= {}
                
            If lMsErroAuto 
        
                Mostraerro() 
                DisarmTransaction() 
                break
        
            EndIf
        
        Endif

    Next nLinha
    
    Begin Transaction
        //Atualiza empenhos
        _cQuery := "UPDATE "+RetSqlName("SD4")
        _cQuery += "SET D4_QUANT = D4_QTDEORI -  ISNULL((SELECT SUM((CASE WHEN LEFT(D3_CF,2) = 'RE' THEN D3_QUANT ELSE D3_QUANT*-1 END))  "
        _cQuery += "   FROM "+RetSqlName("SD3")+" SD3  "
        _cQuery += "   WHERE D3_FILIAL = '"+FWxFilial("SD4")+"' "  "
        _cQuery += "   AND D3_OP = D4_OP  "
        _cQuery += "   AND D3_ESTORNO = ' ' "
        _cQuery += "   AND D3_COD = D4_COD  "
        _cQuery += "   AND D_E_L_E_T_ <> '*'),0) "

        _cQuery += "FROM  "+RetSqlName("SD4")
        _cQuery += "WHERE D4_FILIAL = '"+FWxFilial("SD4")+"' " "
        _cQuery += "AND D4_DATA >= '20210701' "
        _cQuery += "AND D4_QTDEORI -(D4_QUANT + ISNULL((SELECT SUM((CASE WHEN LEFT(D3_CF,2) = 'RE' THEN D3_QUANT ELSE D3_QUANT*-1 END))  "
        _cQuery += "   FROM  "+RetSqlName("SD3")+" SD3  "
        _cQuery += "   WHERE D3_FILIAL = '"+FWxFilial("SD4")+"' "  "
        _cQuery += "   AND D3_OP = D4_OP  "
        _cQuery += "   AND D3_ESTORNO = ' ' "
        _cQuery += "   AND D3_OP = '"+_cNumOP+"' "
        _cQuery += "   AND D3_COD = D4_COD 
        _cQuery += "   AND D_E_L_E_T_ <> '*'),0)) <> 0
        _cQuery += "AND D4_QUANT <> 0
        _cQuery += "AND D_E_L_E_T_ <> '*'
        nQueryRet := TCSQLEXEC(_cQuery)
 
        if nQueryRet != 0
                MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
                DisarmTransaction()
        endif
    End Transaction

    //Montar rotina de sem saldos
    FWMsgRun(, {|| U_M10A07R(_cNumOP) },'Picking - List - SEM SALDO ','Gerando relatório...')
    
    oDlgPvt:End()
Return(.T.)

User function M10A07R(_cNumOP)

Local oPrinter     := Nil
    Local oFont14B     := Nil
    Local oFont12      := Nil
    Local oFont12B     := Nil
    Local oFont18T     := Nil
    Local oFont9       := Nil
    Local nRow         := -0070
    Local cData        := DtoC(Date()) + ' ' + Time()
    //Local _nQtdOP      := SC2->C2_QUANT
    //Local _cCodProd    := SC2->C2_PRODUTO
    Local nPage        := 1
    
    Private nEstru     := 0
    
    M02RFont(@oFont9,@oFont12,@oFont12B,@oFont14B,@oFont18T)

    oPrinter := FWMSPrinter():New('PK' + _cNumOP + '_' + SubStr(DToS(Date()),7,2) + '_' + StrTran(Time(),":",""), IMP_PDF, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.)

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

        M10RIItens(oPrinter,oFont9,oFont12,oFont12B,@nRow,@nPage,cData,_cNumOP,_nQuant,_cCdPro)

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
    Local nRowStep      := 130

    nRow += nRowStep

    oPrinter:Say(nRow                ,0110                ,'C.B. CÓDIGO'          ,oFont12B)
    oPrinter:Say(nRow                ,0750                ,'CÓDIGO PRODUTO'       ,oFont12B)
    oPrinter:Say(nRow                ,1500                ,'DESCRIÇÃO'            ,oFont12B)
    oPrinter:Say(nRow                ,2550                ,'U.M.'                 ,oFont12B)
    oPrinter:Say(nRow                ,2680                ,'QUANTIDADE'           ,oFont12B)
    oPrinter:Say(nRow                ,2970                ,'C.B. QTD'             ,oFont12B)

Return

Static Function MR02Posiciona()
    Local lRet  := .T.

    dbSelectArea("SD4")
    SD4->(DbSetOrder(2))
    SD4->(DbGoTop())

    If !SD4->(DbSeek( xFilial('SD4') + _cNumOP ) )
        MsgInfo(I18N('Não foram encontrados dados da OP em questão #1 .' + CRLF + 'Verifique.',{_cNumOP}),"Atenção")
        lRet := .F.
    EndIf

Return lRet

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab1(oPrinter,oFont14B,oFont12,nRow)
    Local cNome         := ' AÇOS MACOM INDÚSTRIA E COMERCIO LTDA'
    Local cEndC         := 'Av Julia Gaiolli, 474, Bonsucesso, Guarulhos-SP, CEP 07251-500'
    Local cCGC          := ' CNPJ: 43.553.668/0001-79 I.E.: 336.179.661.113'
    Local cTel          := 'Telefone: 55 11 2085-7000'
    Local cMail         := 'www.acosmacom.com.br'
    Local nRowStep      := 45

    oPrinter:SayBitmap(nRow ,0100,GetSrvProfString("Startpath","") + 'LOGO_M05R02.BMP', 751 ,178 )

    oPrinter:Say(nRow                 ,2450         , cNome     ,oFont14B)
    oPrinter:Say(nRow += nRowStep     ,2400         , cEndC     ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2588         , cCGC      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2876         , cTel      ,oFont12)
    oPrinter:Say(nRow += nRowStep     ,2900         , cMail     ,oFont12) 

    nRow += nRowStep
Return

//+------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MR02Cab2(oPrinter,oFont12,oFont18T,nRow,oFont14B)
    Local lRet          := .T.
    Local nRowStep      := 45
    Local _cCodProd     := AllTrim(    posicione("SC2",1,xFilial("SC2")+_cNumOP,"C2_PRODUTO"))
    Local _nQuant       := AllTrim(Str(posicione("SC2",1,xFilial("SC2")+_cNumOP,"C2_QUANT")))
    Local _cDesc        := AllTrim(    Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC"))

    If lRet
        nRow += nRowStep  
        
        DbSelectArea('SC2')
        SC2->(DbselectArea('SC2'))

        oPrinter:Say(nRow                 ,0100    , "O.P. : " + AllTrim(_cNumOP) ,oFont14B)
        oPrinter:FWMSBAR('CODE128',2.3    ,10.3     , AllTrim(_cNumOP),oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)
        //oPrinter:Say(nRow += nRowStep   ,0100    , "ITEM O.P. : " + AllTrim(SC2->C2_ITEM)        ,oFont14B)
        oPrinter:Say(nRow += nRowStep     ,0100    , "PRODUTO : "    + _cCodProd, oFont14B)
        oPrinter:Say(nRow                 ,2876    , "QUANTIDADE = " + _nQuant, oFont14B)
        oPrinter:Say(nRow += nRowStep     ,0100    , _cDesc,oFont14B)
        oPrinter:Say(nRow                 ,2876    , "FGQ-AL-011-Rev01", oFont12)  //#6748

        nRow += nRowStep 

        oPrinter:Line(nRow, 0100,nRow, 3200)

        oPrinter:Say(nRow + 70            ,1150    , 'P  I  C  K  I  N  G  -  L  I  S  T       S E M     S A L D O  '                     ,oFont18T)
        
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
Static Function M10RIItens(oPrinter,oFont9,oFont12,oFont12B,nRow,nPage,cData,_cNumOP,_nQtdOP,_cCodProd)

    Local aEstru        := {}
    Local nRowStep      := 25
    Local nX            := 0
    Local nRowBar       := 9.5
    Local nColBar       := 2.3    
    Private nEstru      := 0
    
    M02RICabIt(oPrinter,oFont12B,@nRow)

    DbSelectArea("SD4")
    SD4->(DbSetOrder(2))
    SD4->(DbGoTop())

    If SD4->(DbSeek( xFilial('SD4') + _cNumOP ))

        While ! SD4->(Eof())  
            
            If Alltrim(SD4->D4_OP) = _cNumOP .And. SD4->D4_QUANT > 0

                Aadd(aEstru, {;
                        FwxFilial("SD4"),;
                        ' ',;
                        SD4->D4_COD,;
                        Posicione("SB1",1,xFilial("SB1")+AllTrim(SD4->D4_COD),"B1_DESC"),;
                        Posicione("SB1",1,xFilial("SB1")+AllTrim(SD4->D4_COD),"B1_UM"),;
                        SD4->D4_QUANT,;                 
                        SD4->D4_OP,;
                        Posicione("SB1",1,xFilial("SB1")+AllTrim(SD4->D4_COD),"B1_LOCPAD"),;
                        .F.;
                    })  
            Endif

            SD4->(DbSkip())

        Enddo

    Endif

    SD4->(DBCLOSEAREA())

    nRow += nRowStep 

    If Empty(aEstru)
    	oPrinter:Say(nRow  ,0120    ,"PRODUTO SEM ESTRUTURA"            ,oFont12B)
    Else
        For nX := 1 To Len(aEstru)
            If Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_XPICLIS") == "1" // Implementação futura qualidade -> .And. Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_TIPO") == "PI"
                If nRowBar == 44.9 .Or. nRowBar == 45.9
                       nRow          := 30
                       nRowStep      := 40 
                       nRowBar       := 0.1
                       nColBar       := 2.3
                       oPrinter:StartPage()
                Endif
                MR02ImpItem(oPrinter,@nRow,@nRowBar,@nColBar,oFont9,oFont12B,_cNumOP,_nQtdOP,_cCodProd,aEstru,nX)
            Endif
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
    oPrinter:Say(nRow    ,2550    ,AllTrim(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_UM"))                  ,oFont12B)    // Unidade de Medida
    oPrinter:Say(nRow    ,2750    ,AllTrim(Transform(NoRound(aEstru[nX,6] * SC2->C2_QUANT,2) ,"@E 999999.99"))               ,oFont12B)    // Quantidade do componente na estrutura proporcional a quantidade da O.P.
    oPrinter:FWMSBAR('CODE128',nRowBar,nColBarQtd,AllTrim(Transform(NoRound(aEstru[nX,6],2) ,"@E 999999.99")),oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)
    
Return
