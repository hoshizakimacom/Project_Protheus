#Include "FINR190.ch"
#Include "Protheus.ch"
#Include "Dbstruct.ch"

// - Conteudo do array - aRelat[x]
#Define ID_PREFIXO     01 // Prefixo
#Define ID_NUMERO      02 // Numero
#Define ID_PARCELA     03 // Parcela
#Define ID_TIPO        04 // Tipo do Documento
#Define ID_CLIFOR      05 // Cod Cliente/Fornec
#Define ID_NOMECLIFOR  06 // Nome Cli/Fornec
#Define ID_NATUREZA    07 // Natureza
#Define ID_VENCIMENTO  08 // Vencimento
#Define ID_HISTORICO   09 // Historico
#Define ID_DTBAIXA     10 // Data de Baixa
#Define ID_VALORORIG   11 // Valor Original
#Define ID_JUROSMULTA  12 // Jur/Multa
#Define ID_CORRECAO    13 // Correcao
#Define ID_DESCONTO    14 // Descontos
#Define ID_ABATIMENTO  15 // Abatimento
#Define ID_IMPOSTO     16 // Impostos
#Define ID_TOTALPAGO   17 // Total Pago
#Define ID_BANCO       18 // Banco
#Define ID_DTDIGITACAO 19 // Data Digitacao
#Define ID_MOTIVO      20 // Motivo
#Define ID_FILORIG     21 // Filial de Origem
#Define ID_FILIAL      22 // Filial
#Define ID_E5BENEFIC   23 // E5_BENEF - cCliFor
#Define ID_E5LOTE      24 // E5_LOTE
#Define ID_E5DTDISPO   25 // E5_DTDISPO
#Define ID_LORIGINAL   26 // LORIGINAL
#Define ID_VALORPG     27 // VALORPG
#Define ID_E5RECNO     28 // Recno SE5
#Define ID_TEMVALOR    29 // Tem Valor para apresentar
#Define ID_AGENCIA     30 // Agencia
#Define ID_CONTA       31 // Conta
#Define ID_LOJA        32 // Loja
#Define ID_TIPODOC     33 // Tipo de Documento
#Define ID_VALORVA      34 // Tipo de Documento
#Define ID_ARRAYSIZE    34 // Tamanho do Array

Static lFwCodFil    := .T.
Static lUnidNeg     := IIf(lFwCodFil, SubStr(FwSM0Layout(), 1, 1) $ "U", .F.)   // Indica se usa Gestao Corporativa
Static __oFINR190   := Nil
Static __lTemFKD    := .F.
Static oFinR190Tb   := Nil
Static _aMotBaixa   := {}
Static lRelMulNat   := .F.

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Rela��o de Baixas                                                          ||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
User Function XFinR190()

    Local oReport           As Object

    Private aSelFil         As Array

    Private cChaveInterFun  As Character
    Private cSitCartei      As Character

    aSelFil         := {}
    cChaveInterFun  := ""
    cSitCartei      := FN022LSTCB(1) + Space(TamSX3("E5_SITCOB")[1])
    __lTemFKD       := TableInDic("FKD")

    //Interface de impressao
    oReport := ReportDef()
    oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
A funcao estatica ReportDef devera ser criada para todos os relatorios que poderao ser agendados pelo usuario.

@type       function
@author     Nereu Humberto Junior
@since      16/05/2006
@return     object, objeto do relat�rio
/*/
Static Function ReportDef() As Object

    Local nPlus     As Numeric

    Local oReport   As Object
    Local oBaixas   As Object

    nPlus := 0

    //Criacao do componente de impressao
    oReport := TReport():New("XFinR190", STR0009, "FIN190", {|oReport| ReportPrint(oReport)}, STR0006 + " " + STR0007 + " " + STR0008) //"Relacao de Amarracao Grupo x Fornecedor"##"Este programa tem como objetivo , relacionar os Grupos e seus"##"respectivos Fornecedores."

    If !(FwGetRunSchedule())
        Pergunte("FIN190", .F.)
    EndIf

    oReport:SetLandScape()

    /* GESTAO - inicio */
    oReport:SetUseGC(.F.)
    oReport:SetGCVPerg(.F.)
    /* GESTAO - fim */

    oBaixas := TRSection():New(oReport, STR0072, {"SE5", "SED"}, {STR0001, STR0002, STR0003, STR0004, STR0032, STR0005, STR0036, STR0048}) //"Baixas"
    // ORDEM:
    /*"Por Data" "Por Banco" "Por Natureza" "Alfabetica"
    "Nro. Titulo" "Dt.Digitacao" " Por Lote" "Por Data de Credito"*/

    oBaixas:SetTotalInLine(.F.)

    TRCell():New(oBaixas, "E5_PREFIXO",, STR0049,, TamSX3("E5_PREFIXO")[1], .F.)        //"Prf"

    If "PTG/MEX" $ cPaisLoc
        TRCell():New(oBaixas, "E5_NUMERO",, STR0050,, TamSX3("E5_NUMERO")[1] + 18, .F.) //"Numero"
    Else
        TRCell():New(oBaixas, "E5_NUMERO",, STR0050,, TamSX3("E5_NUMERO")[1] + 02, .F.)  //"Numero"
    EndIf

    If cPaisLoc == "BRA"
        nPlus := 5
    Else
        nPlus := 3
    EndIf

    TRCell():New(oBaixas, "E5_PARCELA"      ,, STR0051  ,, TamSX3("E5_PARCELA")[1]          , .F.)                          //"Prc"
    TRCell():New(oBaixas, "E5_TIPODOC"      ,, STR0052  ,, TamSX3("E5_TIPODOC")[1]          , .F.)                          //"TP"
    TRCell():New(oBaixas, "E5_CLIFOR"       ,, STR0053  ,, TamSX3("E5_CLIFOR")[1]           , .F.)                          //"Cli/For"
    TRCell():New(oBaixas, "NOME CLI/FOR"    ,, STR0054  ,, 15                               , .F.)                          //"Nome Cli/For"
    TRCell():New(oBaixas, "E5_NATUREZ"      ,, STR0055  ,, 11                               , .F.)                          //"Natureza"
    TRCell():New(oBaixas, "E5_VENCTO"       ,, STR0056  ,, TamSX3("E5_VENCTO")[1]           , .F.)                          //"Vencto"
    TRCell():New(oBaixas, "E5_HISTOR"       ,, STR0057  ,, TamSX3("E5_HISTOR")[1] / 2 + 1   , .F.   ,,,.T.)                 //"Historico"
    TRCell():New(oBaixas, "E5_DATA"         ,, STR0058  ,, TamSX3("E5_DATA")[1] + 1         , .F.)                          //"Dt Baixa"
    TRCell():New(oBaixas, "E5_VALOR"        ,, STR0059  ,, TamSX3("E5_VALOR")[1] + nPlus    , Nil   ,, "RIGHT",, "RIGHT")   //"Valor Original"
    TRCell():New(oBaixas, "JUROS/MULTA"     ,, STR0060  ,, TamSX3("E5_VLJUROS")[1]          , Nil   ,, "RIGHT",, "RIGHT")   //"Jur/Multa"
    TRCell():New(oBaixas, "CORRECAO"        ,, STR0061  ,, TamSX3("E5_VLCORRE")[1]          , Nil   ,, "RIGHT",, "RIGHT")   //"Correcao"
    TRCell():New(oBaixas, "DESCONTO"        ,, STR0062  ,, TamSX3("E5_VLDESCO")[1]          , Nil   ,, "RIGHT",, "RIGHT")   //"Descontos"
    TRCell():New(oBaixas, "ABATIMENTO"      ,, STR0063  ,, TamSX3("E5_VLDESCO")[1]          , Nil   ,, "RIGHT",, "RIGHT")   //"Abatim."
    TRCell():New(oBaixas, "IMPOSTOS"        ,, STR0064  ,, TamSX3("E5_VALOR")[1]            , Nil   ,, "RIGHT",, "RIGHT")   //"Impostos"

    If __lTemFKD
        TRCell():New(oBaixas, "VALACESS"    ,, STR0079  ,, TamSX3("FKD_VLCALC")[1]          , Nil   ,, "RIGHT",, "RIGHT")   //"Valor Acess�rio"
    EndIf

    TRCell():New(oBaixas,"E5_VALORPG"       ,, STR0065  ,, TamSX3("E5_VALOR")[1] + nPlus    , Nil   ,, "RIGHT",, "RIGHT")   //"Total Baixado"
    TRCell():New(oBaixas,"E5_BANCO"         ,, STR0066  ,, TamSX3("E5_BANCO")[1] + 1        ,.F.)                           //"Bco"
    TRCell():New(oBaixas,"E5_DTDIGIT"       ,, STR0067  ,, 10                               ,.F.)                           //"Dt Dig."
    TRCell():New(oBaixas,"E5_MOTBX"         ,, STR0068  ,, 3                                ,.F.)                           //"Mot"
    TRCell():New(oBaixas,"E5_ORIG"          ,, STR0069  ,, FwSizeFilial() + 2               ,.F.)                           //"Orig"

    oBaixas:SetNoFilter({"SED"})

Return oReport

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Realiza a impress�o do relat�rio.                                          ||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function ReportPrint(oReport As Object)

    Local aRelat        As Array
    Local aTotais       As Array

    Local cTotText      As Character

    Local nDecs         As Numeric
    Local nGerOrig      As Numeric
    Local nI            As Numeric
    Local nJ            As Numeric
    Local nOrdem        As Numeric
    Local nRegSM0       As Numeric
    Local nRegSE5       As Numeric

    Local oBaixas       As Object
    Local oBreak2       As Object
    Local oBreak1       As Object

    Private cNomeArq    As Character
    Private cTxtFil     As Character
    Private lVarFil     As Logical
    Private nCond1      As Numeric

    _aMotBaixa  := ReadMotBx()
    oBaixas     := oReport:Section(1)
    nOrdem      := oReport:Section(1):GetOrder()
    oBreak1     := Nil
    oBreak2     := Nil
    nDecs       := GetMv("MV_CENT" + (IIf(MV_PAR12 > 1 , STR(MV_PAR12, 1), "")))
    aRelat      := {}
    nI          := 1
    lVarFil     := (MV_PAR17 == 1 .And. SM0->(RecCount()) >= 1) // Cons filiais abaixo //Alterado para quando houver 1 filial ou mais
    aTotais     := {}
    cTotText    := ""
    nGerOrig    := 0
    nRegSM0     := SM0->(Recno())
    nRegSE5     := SE5->(Recno())
    nJ          := 1
    nCond1      := ID_DTBAIXA

    //GESTAO - inicio
    If MV_PAR40 == 1
        If Empty(aSelFil)
            aSelFil := AdmGetFil(.F., .F., "SE5")
            If Empty(aSelFil)
                AAdd(aSelFil, cFilAnt)
            EndIf
        EndIf
    Else
        AAdd(aSelFil, cFilAnt)
    EndIf

    lVarFil := Len(aSelFil) >= 1 //Alterado para quando houver 1 filial ou mais
    //GESTAO - fim

    If !Empty(MV_PAR28) .And. ! ";" $ MV_PAR28 .And. Len(AllTrim(MV_PAR28)) > 3
        ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres"
        Return Nil
    EndIf
    If !Empty(MV_PAR29) .And. ! ";" $ MV_PAR29 .And. Len(AllTrim(MV_PAR29)) > 3
        ApMsgAlert(STR0074)//"Separe os tipos que n�o deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres"
        Return Nil
    EndIf

    lRelMulNat := IIf(MV_PAR11 == 2, MV_MULNATP, MV_MULNATR) .And. MV_PAR38 == 2 .And. MV_PAR39 != 2

    FA190ImpR4(@aRelat, nOrdem, @aTotais, oReport, nGerOrig, @nI, @cTotText)

    If Len(aRelat) == 0
        Return Nil
    EndIf

    If lRelMulNat
        InitReport(oReport, aRelat, @nI, @cTotText)
        oBaixas:Init()
        nI := 1

        While nI <= Len(aRelat)

            If oReport:Cancel()
                nI++
                Exit
            EndIf

            If aRelat[nI][ID_CLIFOR] == Nil
                aRelat[nI][ID_CLIFOR] := ""
            EndIf

            If !(Empty(aRelat[nI][ID_E5RECNO]))
                SE5->(DbGoTo(aRelat[nI][ID_E5RECNO]))
            EndIf

            //Posiciona na Filial do Movimento a ser impresso
            //cFilAnt := SE5->E5_FILORIG

            If aRelat[nI][ID_TIPODOC] == "VA"
                ZeraVA(aRelat[nI])
            EndIf

            oBaixas:PrintLine()

            If (nOrdem == 1 .Or. nOrdem == 6 .Or. nOrdem == 8)
                cTotText := STR0071 + " : " + DToC(aRelat[nI][nCond1]) //"Sub Total"
            Else //nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 7
                cTotText := STR0071 + " : " + aRelat[nI][nCond1]       //"Sub Total"
                If nOrdem == 2 //Banco
                    SA6->(DbSetOrder(1))
                    SA6->(MsSeek(FwXFilial("SA6") + aRelat[nI][nCond1] + aRelat[nI][ID_AGENCIA] + aRelat[nI][ID_CONTA]))
                    cTotText += " " + Trim(SA6->A6_NOME)
                ElseIf nOrdem == 3 //Natureza
                    SED->(DbSetOrder(1))
                    SED->(MsSeek(FwXFilial("SED") + StrTran(aRelat[nI][nCond1], ".", "")))
                    cTotText += SED->ED_DESCRIC
                EndIf
            EndIf

            If lVarFil
                cTxtFil := aRelat[nI][ID_FILIAL]
            EndIf
            nI++
        End
    EndIf

    SE5->(DbGoTo(nRegSE5))
    SM0->(DbGoTo(nRegSM0))

    cFilAnt := IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)

    //nao retirar "nI--" pois eh utilizado na impressao do ultimo TRFunction
    nI--

    oBaixas:Finish()

    PrintTot(aTotais, oReport, .F., 3, @nJ)

    FwFreeArray(aRelat)

Return Nil

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| REfetua a inicializa��o do relat�rio.                                      ||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function InitReport(oReport As Object, aRelat As Array, nI As Numeric, cTotText As Character)

    Local cSuf      As Character
    Local cTitulo   As Character

    Local nDecs     As numeric
    Local cMoeda    As Numeric
    Local nOrdem    As Numeric

    Local oBaixas   As Object
    Local oBreak1   As Object
    Local oBreak2   As Object
    Local oBreak3   As Object
    Local oBreak4   As Object

    oBaixas := oReport:Section(1)
    nOrdem  := oBaixas:GetOrder()

    cSuf    := LTrim(Str(MV_PAR12))
    cMoeda  := GetMv("MV_MOEDA" + cSuf)
    nDecs   := GetMv("MV_CENT" + (IIf(MV_PAR12 > 1, STR(MV_PAR12, 1), "")))

    // Defini��o dos cabe�alhos
    If MV_PAR11 == 1
        cTitulo := STR0011 + cMoeda  //"Relacao dos Titulos Recebidos em "
    Else
        cTitulo := STR0013 + cMoeda  //"Relacao dos Titulos Pagos em "
    EndIf

    Do Case
        Case nOrdem == 1
            nCond1  := ID_DTBAIXA
            cTitulo += STR0015      //" por data de pagamento"
        Case nOrdem == 2
            nCond1  := ID_BANCO
            cTitulo += STR0016      // " por Banco"
        Case nOrdem == 3
            nCond1  := ID_NATUREZA
            cTitulo += STR0017      //" por Natureza"
        Case nOrdem == 4
            nCond1  := ID_E5BENEFIC //E5_BENEF
            cTitulo += STR0020      //" Alfabetica"
        Case nOrdem == 5
            nCond1  := ID_NUMERO
            cTitulo += STR0035      //" Nro. dos Titulos"
        Case nOrdem == 6 //Ordem 6 (Digitacao)
            nCond1  := ID_DTDIGITACAO
            cTitulo += STR0019      //" Por Data de Digitacao"
        Case nOrdem == 7            // por Lote
            nCond1  := ID_E5LOTE    //"E5_LOTE"
            cTitulo += STR0036      //" por Lote"
        OtherWise   // Data de Cr�dito (dtdispo)
            nCond1  := ID_E5DTDISPO //"E5_DTDISPO"
            cTitulo += STR0015      //" por data de pagamento"
    EndCase

    //Posiciona em um registro de uma outra tabela. O posicionamento ser� realizado antes da impressao de cada linha do relat�rio
    TRPosition():New(oBaixas, "SED", 1, {|| FwXFilial("SED") + SE5->E5_NATUREZ})

    //Inicio da impressao do fluxo do relat�rio
    oBaixas:Cell("E5_PREFIXO"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_PREFIXO],     "")})
    oBaixas:Cell("E5_NUMERO"):SetBlock(     { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_NUMERO],      "")})
    oBaixas:Cell("E5_PARCELA"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_PARCELA],     "")})
    oBaixas:Cell("E5_TIPODOC"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_TIPO],        "")})
    oBaixas:Cell("E5_CLIFOR"):SetBlock(     { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_CLIFOR],      "")})
    oBaixas:Cell("NOME CLI/FOR"):SetBlock(  { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_NOMECLIFOR],  "")})
    oBaixas:Cell("E5_NATUREZ"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_NATUREZA],    "")})
    oBaixas:Cell("E5_VENCTO"):SetBlock(     { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_VENCIMENTO],  "")})
    oBaixas:Cell("E5_HISTOR"):SetBlock(     { || aRelat[nI][ID_HISTORICO]})
    oBaixas:Cell("E5_DATA"):SetBlock(       { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_DTBAIXA],     "")})
    oBaixas:Cell("E5_VALOR"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_VALORORIG],   Nil)})
    oBaixas:Cell("JUROS/MULTA"):SetBlock(   { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_JUROSMULTA],  Nil)})
    oBaixas:Cell("CORRECAO"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_CORRECAO],    Nil)})
    oBaixas:Cell("DESCONTO"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_DESCONTO],    Nil)})
    oBaixas:Cell("ABATIMENTO"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_ABATIMENTO],  Nil)})
    oBaixas:Cell("IMPOSTOS"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_IMPOSTO],     Nil)})

    If __lTemFKD .And. ExistFunc("FxLoadFK6")
        If !lRelMulNat
            oBaixas:Cell("VALACESS"):SetBlock(  { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_VALORVA],     Nil)})
        Else
            oBaixas:Cell("VALACESS"):SetBlock({ || If(aRelat[nI][ID_TIPODOC] <> "VA", FxLoadFK6(AllTrim("FK" + CValToChar(MV_PAR11)), SE5->E5_IDORIG, "VA")[1][2], Nil)})
        EndIf
    EndIf

    oBaixas:Cell("E5_VALORPG"):SetBlock(    { || aRelat[nI][ID_TOTALPAGO]})
    oBaixas:Cell("E5_BANCO"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_BANCO],       Nil)})
    oBaixas:Cell("E5_DTDIGIT"):SetBlock(    { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_DTDIGITACAO], Nil)})
    oBaixas:Cell("E5_MOTBX"):SetBlock(      { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_MOTIVO],      Nil)})
    oBaixas:Cell("E5_ORIG"):SetBlock(       { || If(aRelat[nI][ID_TIPODOC] <> "VA", aRelat[nI][ID_FILORIG],     Nil)})

    oBaixas:SetHeaderPage()

    If (nOrdem == 1 .Or. nOrdem == 6 .Or. nOrdem == 8)
        oBreak1 := TRBreak():New(oBaixas, { || aRelat[nI][ID_FILIAL] + DToS(aRelat[nI][nCond1])}, STR0071) //"Sub Total"
        oBreak1:SetTotalText({ || cTotText}) //"Sub Total"
    Else //nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 7
        oBreak1 := TRBreak():New(oBaixas, { || aRelat[nI][ID_FILIAL] + aRelat[nI][nCond1]}, STR0071) //"Sub Total"
        oBreak1:SetTotalText({ || cTotText}) //"Sub Total"
    EndIf

    TRFunction():New(oBaixas:Cell("E5_VALOR"),,     "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALOR"):nSize, nDecs), {|| If(aRelat[nI][ID_LORIGINAL], aRelat[nI][ID_VALORORIG], 0)}, .F., .F.,.F.) //"Sub Total"

    TRFunction():New(oBaixas:Cell("JUROS/MULTA"),,  "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("JUROS/MULTA"):nSize, nDecs),,   .F., .F.,.F.) //"Sub Total"
    TRFunction():New(oBaixas:Cell("CORRECAO"),,     "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("CORRECAO"):nSize, nDecs),,      .F., .F.,.F.) //"Sub Total"
    TRFunction():New(oBaixas:Cell("DESCONTO"),,     "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("DESCONTO"):nSize, nDecs),,      .F., .F.,.F.) //"Sub Total"
    TRFunction():New(oBaixas:Cell("ABATIMENTO"),,   "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("ABATIMENTO"):nSize, nDecs),,    .F., .F.,.F.) //"Sub Total"
    TRFunction():New(oBaixas:Cell("IMPOSTOS"),,     "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("IMPOSTOS"):nSize, nDecs),,      .F., .F.,.F.) //"Sub Total"

    If __lTemFKD
        TRFunction():New(oBaixas:Cell("VALACESS"),, "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize, nDecs),,      .F., .F.,.F.) //"Sub Total"
    EndIf

    TRFunction():New(oBaixas:Cell("E5_VALORPG"),,   "SUM", oBreak1, STR0071, TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALORPG"):nSize, nDecs), {|| aRelat[nI][ID_VALORPG]}    , .F., .F.,.F.) //"Sub Total"

    // Imprimir TOTAL por filial somente quando houver 1 filial ou mais.
    If lVarFil .And. !(Empty(FwxFilial("SE5")))
        oBreak2 := TRBreak():New(oBaixas, { || aRelat[nI][ID_FILIAL]}, STR0070) //"FILIAL"
        TRFunction():New(oBaixas:Cell("E5_VALOR"),, "SUM", oBreak2, STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALOR"):nSize, nDecs), {|| If(aRelat[nI][ID_LORIGINAL], aRelat[nI][ID_VALORORIG], 0)}, .F., .F.) //"FILIAL"
        TRFunction():New(oBaixas:Cell("JUROS/MULTA")    ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("JUROS/MULTA"):nSize,    nDecs)  ,, .F., .F.) //"FILIAL"
        TRFunction():New(oBaixas:Cell("CORRECAO")       ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("CORRECAO"):nSize,       nDecs)  ,, .F., .F.) //"FILIAL"
        TRFunction():New(oBaixas:Cell("DESCONTO")       ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("DESCONTO"):nSize,       nDecs)  ,, .F., .F.) //"FILIAL"
        TRFunction():New(oBaixas:Cell("ABATIMENTO")     ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("ABATIMENTO"):nSize,     nDecs)  ,, .F., .F.) //"FILIAL"
        TRFunction():New(oBaixas:Cell("IMPOSTOS")       ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("IMPOSTOS"):nSize,       nDecs)  ,, .F., .F.) //"FILIAL"
        If __lTemFKD
            TRFunction():New(oBaixas:Cell("VALACESS")   ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize, nDecs)    ,, .F., .F.) //"FILIAL"
        EndIf
        TRFunction():New(oBaixas:Cell("E5_VALORPG")     ,, "SUM", oBreak2  , STR0070, TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALORPG"):nSize, nDecs)    , {|| aRelat[nI][ID_VALORPG]}, .F., .F.) //"FILIAL"
        oBreak2:SetTotalText({ || STR0070 + " : " + cTxtFil}) //"FILIAL"
    EndIf

    oBaixas:Cell("E5_VALOR"):SetPicture(        TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALOR"):nSize,    nDecs))
    oBaixas:Cell("JUROS/MULTA"):SetPicture(     TM(SE5->E5_VALOR, oBaixas:Cell("JUROS/MULTA"):nSize, nDecs))
    oBaixas:Cell("CORRECAO"):SetPicture(        TM(SE5->E5_VALOR, oBaixas:Cell("CORRECAO"):nSize,    nDecs))
    oBaixas:Cell("DESCONTO"):SetPicture(        TM(SE5->E5_VALOR, oBaixas:Cell("DESCONTO"):nSize,    nDecs))
    oBaixas:Cell("ABATIMENTO"):SetPicture(      TM(SE5->E5_VALOR, oBaixas:Cell("ABATIMENTO"):nSize,  nDecs))
    oBaixas:Cell("IMPOSTOS"):SetPicture(        TM(SE5->E5_VALOR, oBaixas:Cell("IMPOSTOS"):nSize,    nDecs))

    If __lTemFKD
        oBaixas:Cell("VALACESS"):SetPicture(    TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize,    nDecs))
    EndIf

    oBaixas:Cell("E5_VALORPG"):SetPicture(      TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALORPG"):nSize,  nDecs))

    //Total Geral
    oBreak3 := TRBreak():New(oBaixas, { ||}, STR0029) //"Total Geral"

    TRFunction():New(oBaixas:Cell("E5_VALOR"),,     "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALOR"):nSize, nDecs),     {|| If(aRelat[nI][ID_LORIGINAL], aRelat[nI][ID_VALORORIG], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("JUROS/MULTA"),,  "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("JUROS/MULTA"):nSize, nDecs),  {|| aRelat[nI][ID_JUROSMULTA]}, .F., .F.,.F.)
    TRFunction():New(oBaixas:Cell("CORRECAO"),,     "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("CORRECAO"):nSize, nDecs),     {|| If(aRelat[nI][ID_LORIGINAL], aRelat[nI][ID_CORRECAO], 0)}  , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("DESCONTO"),,     "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("DESCONTO"):nSize, nDecs),     {|| If(aRelat[nI][ID_LORIGINAL] .Or. aRelat[nI][ID_DESCONTO] > 0, aRelat[nI][ID_DESCONTO], 0)}, .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("ABATIMENTO"),,   "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("ABATIMENTO"):nSize, nDecs),   {|| aRelat[nI][ID_ABATIMENTO]}, .F., .F.,.F.)
    TRFunction():New(oBaixas:Cell("IMPOSTOS"),,     "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("IMPOSTOS"):nSize, nDecs),     {|| If(aRelat[nI][ID_LORIGINAL], aRelat[nI][ID_IMPOSTO], 0)}, .F., .F.,.F.)
    If __lTemFKD
        TRFunction():New(oBaixas:Cell("VALACESS"),, "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize, nDecs),, .F., .F.,.F.)
    EndIf
    TRFunction():New(oBaixas:Cell("E5_VALORPG"),,   "SUM", oBreak3  , "", TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALORPG"):nSize, nDecs),   {|| aRelat[nI][ID_VALORPG]}, .F., .F.,.F.)

    //Total sem movimenta��o
    oBreak4 := TRBreak():New(oBaixas, {||}, STR0081) //"Total Geral S/Movimenta��o"
    TRFunction():New(oBaixas:Cell("E5_VALOR"),,     "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALOR"):nSize, nDecs),     {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_VALORORIG], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("JUROS/MULTA"),,  "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("JUROS/MULTA"):nSize, nDecs),  {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_JUROSMULTA], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("CORRECAO"),,     "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("CORRECAO"):nSize, nDecs),     {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_CORRECAO], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("DESCONTO"),,     "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("DESCONTO"):nSize, nDecs),     {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_DESCONTO], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("ABATIMENTO"),,   "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("ABATIMENTO"):nSize, nDecs),   {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_ABATIMENTO], 0)} , .F., .F., .F.)
    TRFunction():New(oBaixas:Cell("IMPOSTOS"),,     "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("IMPOSTOS"):nSize, nDecs),     {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_IMPOSTO], 0)} , .F., .F., .F.)
    If __lTemFKD 
        If !lRelMulNat
            TRFunction():New(oBaixas:Cell("VALACESS"),, "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize, nDecs),{|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_VALORVA], 0)}, .F., .F., .F.)
        Else
            TRFunction():New(oBaixas:Cell("VALACESS"),, "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("VALACESS"):nSize, nDecs),{|| If(aRelat[nI][ID_TEMVALOR], FxLoadFK6(AllTrim("FK" + CValToChar(MV_PAR11)), SE5->E5_IDORIG, "VA")[1][2], 0)}, .F., .F., .F.)
        EndIf
    EndIf
    TRFunction():New(oBaixas:Cell("E5_VALORPG"),,   "SUM", oBreak4  , "", TM(SE5->E5_VALOR, oBaixas:Cell("E5_VALORPG"):nSize, nDecs),   {|| If(aRelat[nI][ID_TEMVALOR], aRelat[nI][ID_TOTALPAGO], 0)}  , .F., .F., .F.)

    oReport:SetTitle(cTitulo)

Return Nil

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Imprime os totais "Baixados", "Mov Fin.", "Compens.                        ||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function PrintTot(aTotais As Array, oReport As Object, lFil As Logical, nBreak As Numeric, nJ As Numeric)

    Local cAnt      As Character
    Local cGeral    As Character

    Local nDecs     As Numeric
    Local nAscan    As Numeric
    Local nTamAnt   As Numeric

    Default nJ      := 1

    nDecs     := GetMv("MV_CENT" + (If(MV_PAR12 > 1 , Str(MV_PAR12, 1), "")))
    cAnt      := ""
    nAscan    := 0
    cGeral    := OemToAnsi(STR0075)
    nTamAnt   := 0

    If lFil == .T.
        oReport:SkipLine(2)
    EndIf

    nAscan := AScan(aTotais, {|total| AllTrim(total[1]) ==  cGeral})

    If nBreak <> 3
        If Len(aTotais) > 0
            If (MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3
                cAnt := aTotais[nJ][4]
            Else
                cAnt := aTotais[nJ][1]
            EndIf
        EndIf

        While ((IIf((ValType(cAnt) <> ValType(aTotais[nJ][1]) .And. Len(aTotais[nJ]) == 3), "" , cAnt)) ==;
            (IIf(((MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3), aTotais[nJ][4], aTotais[nJ][1])) .And. (nJ < nAscan))
            nTamAnt := Len(aTotais[nJ])
            oReport:PrintText(PadR(aTotais[nJ][2], 12, " ") + Transform(aTotais[nJ][3], TM(aTotais[nJ][3], 20, nDecs)))
            nJ++
            If nTamAnt < Len(aTotais[nJ])
                // significa quebra de filial. Antes, com print de total de filial, o tamanho � 3, com este proximo total de outra filial, tamanho ser� 4
                Exit
            EndIf
        End
    Else
        oReport:PrintText("")
        While nAscan > 0
            oReport:PrintText(PadR(aTotais[nAscan][2], 12, " ") + Transform(aTotais[nAscan][3], TM(aTotais[nAscan][3], 20, nDecs)))
            nAscan := If((nAscan + 1) <= Len(aTotais) .And. aTotais[nAscan + 1][1] == cGeral, nAscan + 1, 0)
        End
    EndIf

Return Nil

/*/{Protheus.doc} Fr190TstCond
Testa as condicoes do registro do SE5 para permitir a impress�o.

@type       function
@author     Claudio D. de Souza
@since      22/08/2002
@param      cFilSE5, character, Filtro em CodBase
@return     logical, .T. se permite imprimir linha .F. caso n�o
/*/
User Function Fr190TstCond(cFilSE5 As Character) As Logical

    Local lManual   As Logical
    Local lRet      As Logical

    Local nMoedaBco As Numeric

    lManual     := .F.
    lRet        := .T.
    nMoedaBco   := 1

    If MV_PAR16 == 1 .And. (Empty(NEWSE5->E5_TIPODOC) .Or. Empty(NEWSE5->E5_NUMERO))
        lManual := .T.
    EndIf

    //Se escolhido o par�metro "baixas normais", apenas imprime as baixas que gerarem movimenta��o banc�ria e as movimenta��es financeiras manuais, se consideradas.
    If lRet .And. MV_PAR14 == 1 .And. !u_F190MovBco(NEWSE5->E5_MOTBX) .And. !lManual
        lRet := .F.
    EndIf

    If lRet .And. MV_PAR24 == 2 .And. NEWSE5->E5_MOTBX == "CMP"
        If NEWSE5->E5_RECPAG == "R" .And. NEWSE5->E5_TIPO $ MVRECANT + "/" + MV_CRNEG
            lRet := .F.
        ElseIf NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPO $ MVPAGANT + "/" + MV_CPNEG
        	lRet := .F.
    	EndIf
    EndIf

    If lRet .And. MV_PAR25 == 2
        nMoedaBco := Val(NEWSE5->E5_MOEDA)

        If nMoedaBco == 0 .And. !Empty(NEWSE5->E5_BANCO) .And. !Empty(NEWSE5->E5_AGENCIA) .And. !Empty(NEWSE5->E5_CONTA)
            SA6->(DbSetOrder(1))
            If SA6->(MsSeek(FwXFilial("SA6", NEWSE5->E5_FILORIG) + NEWSE5->(E5_BANCO + E5_AGENCIA + E5_CONTA))) .And. SA6->A6_MOEDA > 0
                nMoedaBco := SA6->A6_MOEDA
            EndIf
        EndIf
            nMoedaBco := IIf(nMoedaBco == 0, 1, nMoedaBco)
            lRet := (nMoedaBco == MV_PAR12)
        EndIf

    // Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, n�o imprimir o mov.
    If lRet .And. MV_PAR16 == 1
        If u_Fr190MovCan(17, "NEWSE5")
            lRet := .F.
        EndIf
    EndIf

    // Se for um recebimento de Titulo pago em dinheiro originado pelo SIGALOJA, nao imprime o mov.
    If lRet .And. NEWSE5->E5_TIPODOC == "BA" .And. NEWSE5->E5_MOTBX == "LOJ" .And. IsMoney(NEWSE5->E5_MOEDA)
        lRet := .F.
    EndIf

    //Tratamento p/ � imp t�t aglutinador quando o mesmo n�o estiver sofrido baixa.
    If lRet .And. Empty(NEWSE5->(E5_TIPO + E5_DOCUMEN + E5_IDMOVI + E5_FILORIG + E5_MOEDA))
        lRet := .F.
    EndIf

Return lRet

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Efetua montagem do array para definir quais baixas ser�o apresentadas no relat�rio. ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function FA190ImpR4(aRet As Array, nOrdem As Numeric, aTotais As Array, oReport As Object, nGerOrig As Numeric, nI As Numeric, cTotText As Character) As Array

    Local aAreaBk       As Array
    Local aAreaSE2      As Array
    Local aAreaSE5      As Array
    Local aCampos       As Array 
    Local aChaveTit     As Array 
    Local aColu         As Array 
    Local aIndex        As Array
    Local aModoComp     As Array 
    Local aStru         As Array 
    Local aTam          As Array 

    Local cAge          As Character
    Local cAnterior     As Character
    Local cAuxFilNome   As Character
    Local cAuxCliFor    As Character
    Local cAuxLote      As Character
    Local cBanco        As Character
    Local cCarteira     As Character
    Local cChave        As Character
    Local cChaveTit     As Character
    Local cCliFor       As Character
    Local cCliFor190    As Character
    Local cCond2        As Character
    Local cCondicao     As Character
    Local cContaBco     As Character
    Local cDelete1      As Character
    Local cEmpresa      As Character
    Local cEstorno      As Character
    Local cFilNome      As Character
    Local cFilOrig      As Character
    Local cFilSE5       As Character
    Local cFilTrb       As Character
    Local cFilUser      As Character
    Local cHistorico    As Character
    Local cInsert       As Character
    Local cLayout       As Character
    Local cLoja         As Character
    Local cMascNat      As Character
    Local cMotBaixa     As Character
    Local cNatureza     As Character
    Local cRecPag       As Character
    Local cSelUpdat1    As Character
    Local cSelUpdat2    As Character
    Local cSGBD         As Character
    Local cTipoDoc      As Character
    Local cTmpSE5Fil    As Character
    Local cUpdate1      As Character
    Local cUpdate2      As Character
    Local cXFilSA1      As Character
    Local cXFilSA2      As Character
    Local cXFilSA6      As Character
    Local cXFilSE1      As Character
    Local cXFilSE2      As Character
    Local cXFilSE5      As Character
    Local cXFilSED      As Character
    Local cXFilSEH      As Character
    Local cXFilSEI      As Character
    Local tamanho       As Character

    Local dAuxDtDispo   As Date
    Local dDigit        As Date
    Local dDtMovFin     As Date

    Local lAchou        As Logical
    Local lAchouEmp     As Logical
    Local lAchouEst     As Logical
    Local lBxTit        As Logical
    Local lConsImp      As Logical
    Local lContinua     As Logical
    Local lDB2          As Logical
    Local lExclusivo    As Logical
    Local lF190Qry      As Logical
    Local lFilSit       As Logical
    Local lGestao       As Logical
    Local lManual       As Logical
    Local lMultiNat     As Logical
    Local lMVGlosa      As Logical
    Local lMVLjTroco    As Logical
    Local lNovaGestao   As Logical
    Local lOracle       As Logical
    Local lOriginal     As Logical
    Local lPCCBaixa     As Logical
    Local lPccBxCr      As Logical
    Local lRelatInit    As Logical
    Local lRaRtImp      As Logical
    Local lSkpNewSe5    As Logical
    Local lTroco        As Logical

    Local nAbat         As Numeric
    Local nAbatLiq      As Numeric
    Local nCM           As Numeric
    Local nCT           As Numeric
    Local nDesc         As Numeric
    Local nDecs         As Numeric
    Local nFilAbLiq     As Numeric
    Local nFilAbImp     As Numeric
    Local nFilBaixado   As Numeric
    Local nFilCM        As Numeric
    Local nFilComp      As Numeric
    Local nFilDesc      As Numeric
    Local nFilFat       As Numeric
    Local nFilJurMul    As Numeric
    Local nFilMovFin    As Numeric
    Local nFilOrig      As Numeric
    Local nFilValor     As Numeric
    Local nGerAbImp     As Numeric
    Local nGerAbLiq     As Numeric
    Local nGerBaixado   As Numeric
    Local nGerCm        As Numeric
    Local nGerComp      As Numeric
    Local nGerDesc      As Numeric
    Local nGerFat       As Numeric
    Local nGerJurMul    As Numeric
    Local nGerMovFin    As Numeric
    Local nGerValor     As Numeric
    Local nJurMul       As Numeric
    Local nJuros        As Numeric
    Local nLenSelFil    As Numeric
    Local nMoedaBco     As Numeric
    Local nMoedMov      As Numeric
    Local nMulta        As Numeric
    Local nPccBxCr      As Numeric
    Local nRecEmp       As Numeric
    Local nRecChkd      As Numeric
    Local nRecno        As Numeric
    Local nRecnoSE5     As Numeric
    Local nRecSE2       As Numeric
    Local nRecSe5       As Numeric
    Local nSelFil       As Numeric
    Local nTamEH        As Numeric
    Local nTamEI        As Numeric
    Local nTamRet       As Numeric
    Local nTaxa         As Numeric
    Local nTotAbImp     As Numeric
    Local nTotAbLiq     As Numeric
    Local nTotBaixado   As Numeric
    Local nTotCm        As Numeric
    Local nTotComp      As Numeric
    Local nTotDesc      As Numeric
    Local nTotFat       As Numeric
    Local nTotImp       As Numeric
    Local nTotJurMul    As Numeric
    Local nTotMovFin    As Numeric
    Local nTotOrig      As Numeric
    Local nTotValor     As Numeric
    Local nValor        As Numeric
    Local nValTroco     As Numeric
    Local nVlImp        As Numeric
    Local nVlMovFin     As Numeric
    Local nVlr          As Numeric
    Local nVlrGlosa     As Numeric    
    Local nCasDec       As Numeric
    Local oBaixas       As Object

    Default aRet        := {}

    oBaixas     := oReport:Section(1)
    nValor      := 0
    nDesc       := 0
    nJuros      := 0
    nMulta      := 0
    nJurMul     := 0
    nCM         := 0
    nVlMovFin   := 0
    nTotValor   := 0
    nTotDesc    := 0
    nTotJurMul  := 0
    nTotCm      := 0
    nTotOrig    := 0
    nTotBaixado := 0
    nTotMovFin  := 0
    nTotComp    := 0
    nTotFat     := 0
    nGerValor   := 0
    nGerDesc    := 0
    nGerJurMul  := 0
    nGerCm      := 0
    nGerBaixado := 0
    nGerMovFin  := 0
    nGerComp    := 0
    nGerFat     := 0
    nFilOrig    := 0
    nFilJurMul  := 0
    nFilCM      := 0
    nFilDesc    := 0
    nFilAbLiq   := 0
    nFilAbImp   := 0
    nFilValor   := 0
    nFilBaixado := 0
    nFilMovFin  := 0
    nFilComp    := 0
    nFilFat     := 0
    nAbatLiq    := 0
    nTotAbImp   := 0
    nTotImp     := 0
    nTotAbLiq   := 0
    nGerAbLiq   := 0
    nGerAbImp   := 0
    cBanco      := ""
    cCondicao   := ""
    cNatureza   := ""
    cAnterior   := ""
    cCliFor     := ""
    nCT         = 0
    cLoja       := ""
    lContinua   := .T.
    lBxTit      := .F.
    tamanho     := "G"
    aCampos     := {}
    nVlr        := 0
    nVlImp      := 0
    lOriginal   := .T.
    nAbat       := 0
    lManual     := .F.
    nRecSe5     := 0
    nRecEmp     := SM0->(Recno())
    cMotBaixa   := CriaVar("E5_MOTBX")
    cFilNome    := Space(15)
    cCliFor190  := ""
    aTam        := IIf(MV_PAR11 == 1, TamSX3("E1_CLIENTE"), TamSX3("E2_FORNECE"))
    aColu       := {}
    nDecs       := GetMv("MV_CENT" + (IIf(MV_PAR12 > 1 , STR(MV_PAR12, 1), "")))
    nMoedaBco   := 1
    aStru       := SE5->(DbStruct())
    cFilSE5     := ".T."

    //FwXFilial Por Empresa/Filial
    cXFilSA1    := ""
    cXFilSA2    := ""
    cXFilSA6    := ""
    cXFilSE1    := ""
    cXFilSE2    := ""
    cXFilSE5    := ""
    cXFilSED    := ""
    cXFilSEH    := ""
    cXFilSEI    := ""
    cChave      := ""
    lAchou      := .F.
    lF190Qry    := ExistBlock("F190QRY")
    lFilSit     := !Empty(MV_PAR15)
    lAchouEmp   := .T.
    lAchouEst   := .F.
    nTamEH      := TamSX3("EH_NUMERO")[1]
    nTamEI      := TamSX3("EI_NUMERO")[1] + TamSX3("EI_REVISAO")[1] + TamSX3("EI_SEQ")[1]
    nRecSE2     := 0
    cFilUser    := ""
    lPCCBaixa   := SuperGetMv("MV_BX10925", .T., "2") == "1"
    nTaxa       := 0
    lMVLjTroco  := SuperGetMV("MV_LJTROCO",, .F.)
    nRecnoSE5   := 0
    nValTroco   := 0
    lTroco      := .F.
    cEstorno    := STR0080 // "Estorno de tranferencia"

    //Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss�o(default))
    lPccBxCr    := FPccBxCr()
    nPccBxCr    := 0

    //Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = N�o controla reten��o de impostos no RA(default))
    lRaRtImp    := FRaRtImp()
    cEmpresa    := IIf(lUnidNeg, FwCodEmp(), "")
    cAge        := ""
    cContaBco   := ""
    cMascNat    := ""
    lConsImp    := .T.
    lMVGlosa    := SuperGetMv("MV_GLOSA", .F., .F.)
    nVlrGlosa   := 0
    nTamRet     := 0
    aChaveTit   := {}
    cChaveTit   := ""
    nMoedMov    := 0
    //GESTAO - inicio */
    cTmpSE5Fil  := ""
    lNovaGestao := .F.
    nSelFil     := 0
    nLenSelFil  := 0
    cLayout     := FwSM0Layout()
    lGestao     := IIf(lFwCodFil, ("E" $ cLayout .And. "U" $ cLayout), .F.)// Indica se usa Gestao Corporativa
    lExclusivo  := .F.
    aModoComp   := {}
    lMultiNat   := .F.
    nRecChkd    := 0
    lSkpNewSe5  := .F.
    //GESTAO - fim
    cUpdate1    := ""
    cUpdate2    := ""
    cDelete1    := ""
    cSelUpdat1  := ""
    cSelUpdat2  := ""
    lRelatInit  := .F.
    cSGBD       := Upper(TCGetDB())
    lOracle     := "ORACLE" $ cSGBD
    lDB2        := "DB2" $ cSGBD
    nCasDec     := Iif(MV_PAR11 == 1, TamSx3("FK1_TXMOED")[2], TamSx3("FK2_TXMOED")[2])
    
    //GESTAO - inicio
    lNovaGestao := .T.
    //GESTAO - fim

    If lFwCodFil .And. lGestao
        AAdd(aModoComp, FwModeAccess("SE5", 1))
        AAdd(aModoComp, FwModeAccess("SE5", 2))
        AAdd(aModoComp, FwModeAccess("SE5", 3))
        lExclusivo := AScan(aModoComp, "E") > 0
    Else
        DbSelectArea("SE5")
        lExclusivo := !Empty(FwXFilial("SE5"))
    EndIf

    If MV_PAR41 == 2
        lConsImp := .F.
    EndIf

    nGerOrig := 0

    //Atribui valores as variaveis ref a filiais
    /* GESTAO - inicio */
    If lNovaGestao
        nLenSelFil := Len(aSelFil)
        If MV_PAR40 == 1
            If nLenSelFil > 0
                cFilDe  := aSelFil[1]
                cFilAte := aSelFil[nLenSelFil]
            EndIf
        Else
            If MV_PAR17 == 2 // Cons filiais abaixo
                cFilDe := IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)
                cFilAte:= IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)
            Else
                cFilDe := MV_PAR18 // Todas as filiais
                cFilAte:= MV_PAR19
            EndIf
        EndIf
    Else
        If MV_PAR17 == 2 // Cons filiais abaixo
            cFilDe := IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)
            cFilAte:= IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)
        Else
            cFilDe := MV_PAR18 // Todas as filiais
            cFilAte:= MV_PAR19
        EndIf
    EndIf
    /* GESTAO - fim */

    F190InitTb()

    // Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo usuario.
    DbSelectArea("SE5")
    Do Case
    Case nOrdem == 1
        cCond2 := "E5_DATA"
        cChave := IndexKey(1)
        aIndex := {"E5_FILIAL", "E5_DATA", "E5_BANCO", "E5_AGENCIA", "E5_CONTA", "E5_NUMCHEQ"}
    Case nOrdem == 2
        cCond2 := "E5_BANCO"
        cChave := IndexKey(3)
        aIndex := {"E5_FILIAL", "E5_BANCO", "E5_AGENCIA", "E5_CONTA", "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA" ,"E5_TIPO", "E5_DATA"}
    Case nOrdem == 3
        cCond2 := "E5_NATUREZ"
        cChave := IndexKey(4)
        aIndex := {"E5_FILIAL", "E5_NATUREZ", "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA", "E5_TIPO", "E5_DTDIGIT", "E5_RECPAG", "E5_CLIFOR", "E5_LOJA"}
    Case nOrdem == 4
        cCond2 := "E5_BENEF"
        cChave := "E5_FILIAL+E5_BENEF+DToS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
        aIndex := {"E5_FILIAL", "E5_BENEF", "E5_DATA", "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA"}
    Case nOrdem == 5
        cCond2 := "E5_NUMERO"
        cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DToS(E5_DATA)"
        aIndex := {"E5_FILIAL", "E5_NUMERO", "E5_PARCELA", "E5_PREFIXO", "E5_DATA"}
    Case nOrdem == 6        //Ordem 6 (Digitacao)
        cCond2 := "E5_DTDIGIT"
        cChave := "E5_FILIAL+DToS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DToS(E5_DATA)"
        aIndex := {"E5_FILIAL", "E5_DTDIGIT", "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA", "E5_DATA"}
    Case nOrdem == 7        // por Lote
        cCond2 := "E5_LOTE"
        cChave := IndexKey(5)
        aIndex := {"E5_FILIAL", "E5_LOTE", "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA", "E5_TIPO", "E5_DATA"}
    OtherWise               // Data de Cr�dito (dtdispo)
        cCond2 := "E5_DTDISPO"
        cChave := "E5_FILIAL+DToS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
        aIndex := {"E5_FILIAL", "E5_DTDISPO", "E5_BANCO", "E5_AGENCIA", "E5_CONTA", "E5_NUMCHEQ"}
    EndCase

    cChaveInterFun := cChave

    F190IndexTb(aIndex)

    oFinR190Tb:Create()

    cCondicao := ".T."
    DbSelectArea("SE5")

    cTable  := oFinR190Tb:GetRealName()
    cCampos := ""

    // Preenche todos os campos do arquivo temporario.
    AEval(aStru, {|Estrutura| If( Estrutura[DBS_TYPE] <> "M", cCampos += "," + AllTrim(Estrutura[DBS_NAME]), Nil)})

    cValues := SubStr(cCampos, 2)

    cInsert := " INSERT "

    If lOracle
        cInsert += " /*+ APPEND */ "
    EndIf

    cInsert += " INTO " + cTable  + " ( " + cValues  + " , SE5RECNO, SE5MAXSEQ, SE5VA) "
    cInsert += " SELECT " + cValues + " , SE5.R_E_C_N_O_ SE5RECNO, '" + Space(GetSX3Cache("E5_SEQ", "X3_TAMANHO")) + "' SE5MAXSEQ, 0 SE5VA"
    cInsert += " FROM " + RetSQLName("SE5") + " SE5 "

    If !Empty(MV_PAR42) .And. MV_PAR42 == 2
        cInsert += "WHERE E5_RECPAG = '" + IIf(MV_PAR11 == 1, "R", "P") + "' AND "
    Else
        If MV_PAR11 == 1
            cInsert += "WHERE E5_RECPAG = (CASE WHEN E5_TIPODOC = 'TR' AND  E5_HISTOR LIKE '%" + cEstorno + "%' THEN 'P' Else 'R' END ) AND"
        Else
            cInsert += "WHERE E5_RECPAG = (CASE WHEN E5_TIPODOC = 'TR' AND  E5_HISTOR LIKE '%" + cEstorno + "%' THEN 'R' Else 'P' END ) AND"
        EndIf
    EndIf

    cInsert += " E5_DATA    BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' AND "
    cInsert += " E5_DATA    <= '" + DToS(dDataBase) + "' AND "

    cInsert += " E5_MOTBX <> 'DSD' AND " //Retirado da fun��o FR190TstCond

    If cPaisLoc == "ARG" .And. MV_PAR03 == MV_PAR04
        cInsert += " (E5_BANCO = '" + MV_PAR03 + "' OR E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
    Else
        cInsert += " E5_BANCO   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
    EndIf
    If cPaisLoc == "ARG" .And. MV_PAR11 == 2 // pagar
        cInsert += " (E5_DOCUMEN <> ' ' AND E5_TIPO <> 'CH') AND "
    EndIf
    
    If MV_PAR35 == 2 //Retirado da fun��o FR190TstCond
        cInsert += "E5_TIPODOC NOT IN ('RA','PA') AND "
    EndIf
    
    // Realiza filtragem pela natureza principal
    If MV_PAR39 == 2
        cInsert +=  " E5_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
    Else
        cInsert +=       " (E5_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' OR "
        cInsert +=       " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
        cInsert +=                 " FROM " + RetSQLName("SEV") + " SEV "
        cInsert +=                " WHERE E5_FILIAL  = EV_FILIAL AND "
        cInsert +=                       "E5_PREFIXO = EV_PREFIXO AND "
        cInsert +=                       "E5_NUMERO  = EV_NUM AND "
        cInsert +=                       "E5_PARCELA = EV_PARCELA AND "
        cInsert +=                       "E5_TIPO    = EV_TIPO AND "
        cInsert +=                       "E5_CLIFOR  = EV_CLIFOR AND "
        cInsert +=                       "E5_LOJA    = EV_LOJA AND "
        cInsert +=                       "EV_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
        cInsert +=                       "SEV.D_E_L_E_T_ = ' ')) AND "
    EndIf
    cInsert += "        E5_CLIFOR  BETWEEN '" + MV_PAR07       + "' AND '" + MV_PAR08       + "' AND "
    cInsert += "        E5_DTDIGIT BETWEEN '" + DToS(MV_PAR09) + "' AND '" + DToS(MV_PAR10) + "' AND "
    cInsert += "        E5_LOTE    BETWEEN '" + MV_PAR20       + "' AND '" + MV_PAR21       + "' AND "
    cInsert += "        E5_LOJA    BETWEEN '" + MV_PAR22       + "' AND '" + MV_PAR23       + "' AND "
    cInsert += "        E5_PREFIXO BETWEEN '" + MV_PAR26       + "' AND '" + MV_PAR27       + "' AND "
    //cInsert += "        E5_MOVCX <> 'S' AND "
    cInsert += "        SE5.D_E_L_E_T_ = ' '  AND "
    cInsert += "        E5_SITUACA NOT IN ('C','E','X') AND NOT EXISTS ( "
    cInsert += "                                                                SELECT SE5ES.E5_NUMERO "
    cInsert += "                                                                FROM " + RetSQLName("SE5") + " SE5ES "
    cInsert += "                                                                WHERE SE5ES.E5_FILIAL  = SE5.E5_FILIAL "
    cInsert += "                                                                    AND SE5ES.E5_PREFIXO = SE5.E5_PREFIXO "
    cInsert += "                                                                    AND SE5ES.E5_NUMERO  = SE5.E5_NUMERO "
    cInsert += "                                                                    AND SE5ES.E5_PARCELA = SE5.E5_PARCELA "
    cInsert += "                                                                    AND SE5ES.E5_TIPO    = SE5.E5_TIPO "
    cInsert += "                                                                    AND SE5ES.E5_CLIFOR  = SE5.E5_CLIFOR "
    cInsert += "                                                                    AND SE5ES.E5_LOJA    = SE5.E5_LOJA "
    cInsert += "                                                                    AND SE5ES.E5_SEQ     = SE5.E5_SEQ "
    cInsert += "                                                                    AND SE5ES.E5_BANCO   = SE5.E5_BANCO "
    cInsert += "                                                                    AND SE5ES.E5_AGENCIA = SE5.E5_AGENCIA "
    cInsert += "                                                                    AND SE5ES.E5_CONTA   = SE5.E5_CONTA "
    cInsert += "                                                                    AND SE5ES.E5_MOVCX   = SE5.E5_MOVCX "
    cInsert += "                                                                    AND SE5ES.E5_TIPODOC = 'ES' "
    cInsert += "                                                                    AND SE5ES.E5_ORIGEM <> 'FINA100 ' "
    cInsert += "                                                                    AND (SE5ES.E5_KEY NOT LIKE '%PA%' OR "
    cInsert += "                                                                    SE5ES.E5_KEY LIKE '%PA%' AND "
    cInsert += "                                                                    SE5ES.E5_NUMERO = '" + Space(Len(E5_NUMERO)) + "')"
    cInsert += "                                                            AND SE5ES.D_E_L_E_T_ = ' ' "
    cInsert += "                                                            ) AND "
    cInsert += "    ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR (E5_TIPODOC <> 'CD')) "
    cInsert += "        AND E5_HISTOR NOT LIKE '%" + STR0077 + "%'"
    cInsert += "        AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','ES'  "

    If !Empty(MV_PAR42) .And. MV_PAR42 == 2 // Cons. Baixa por Mov. Banc�rio //retira a impress�o do TR e seus estornos
        cInsert += "        ,'TR'"
        If MV_PAR11 == 2
            cInsert += " , 'E2'"
        Else//ElseIf MV_PAR11 == 1
            cInsert += " , 'E2', 'CB'"
        EndIf
    EndIf

   
    If MV_PAR16 == 2
        cInsert += " ,' '"
        cInsert += " ,'CH'"
        cInsert += " ,'TE'"
        cInsert += " ,'TR'"
    EndIf
    cInsert += " )"

    If !Empty(MV_PAR42) .And. MV_PAR42 == 2
        cInsert += " AND E5_ORIGEM <> 'FINA100' "
        cInsert += " AND E5_NUMERO  <> '" + Space(Len(E5_NUMERO)) + "'"
    EndIf

    If MV_PAR16 == 2
        cInsert += " AND E5_NUMERO  <> '" + Space(Len(E5_NUMERO)) + "'"
        cInsert += " AND E5_TIPO  <> '" + Space(Len(E5_TIPODOC)) + "'"
    EndIf

    If !Empty(MV_PAR28) // Deseja imprimir apenas os tipos do parametro 28
        cInsert += " AND E5_TIPO IN " + FormatIn(MV_PAR28, ";")
    ElseIf !Empty(MV_PAR29) // Deseja excluir os tipos do parametro 29
        cInsert += " AND E5_TIPO NOT IN " + FormatIn(MV_PAR29, ";")
    EndIf

    If MV_PAR11 == 1 .And. MV_PAR36 == 2 .And. !Empty(cSitCartei) // Nao imprime titulos em carteira
        cInsert += " AND E5_SITCOB NOT IN " + FormatIn(cSitCartei, "|")
    EndIf

    cCondFil := "NEWSE5->E5_FILIAL==FwXFilial('SE5')"

    /* GESTAO - inicio */
    If MV_PAR40 == 1 .And. !Empty(aSelFil)
        If lExclusivo
            cInsert += " AND " + FinSelFil(aSelFil, "SE5", .F., .T., 20)
        Else
            cInsert += " AND " + FinSelFil(aSelFil, "SE5", .T., .T., 20)
        EndIf
    Else
        If MV_PAR17 == 2
            cInsert += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
        Else
            If !lExclusivo
                cInsert += " AND E5_FILORIG BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
            Else
                cInsert += " AND E5_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
            EndIf
        EndIf
    EndIf
    /* GESTAO - fim */

    cFilUser := oBaixas:GetSQLExp("SE5")

    If lF190Qry
        cInsertAdd := ExecBlock("F190QRY", .F., .F., {cFilUser})
        If ValType(cInsertAdd) == "C"
            cInsert += " AND (" + cInsertAdd + ")"
        EndIf
    EndIf

    If !Empty(cFilUser)
        cInsert += " AND (" + cFilUser + ") "
    EndIf

    cInsert += IIf(FindFunction("JurQWRelBx"), JurQWRelBx() , "")

    // seta a ordem de acordo com a opcao do usuario
    cInsert += " ORDER BY " + SQLOrder(cChave)

    If lDB2
        cInsert += " FOR READ ONLY "
    EndIf

    If TCSQLExec(cInsert) < 0
        DbOnError(TCSqlError(), "cInsert")
        Return Nil
    EndIf

    If MV_PAR37 == 1 .Or. MV_PAR37 == 2
        cDelete1 := DeleteChq()

        If TCSQLExec(cDelete1) < 0
            DbOnError(TCSqlError(), "cDelete1")
            Return Nil
        EndIf
    EndIf

    cSelUpdat1 += " SELECT ISNULL(MAX(E5_SEQ), '" + Space(GetSX3Cache("E5_SEQ", "X3_TAMANHO")) + "') SE5MAXSEQ "
    cSelUpdat1 += " FROM " + RetSQLName("SE5") + " SE5 "
    cSelUpdat1 += " WHERE SE5.E5_FILIAL =   " + cTable + ".E5_FILIAL "
    cSelUpdat1 +=   " AND SE5.E5_PREFIXO =  " + cTable + ".E5_PREFIXO "
    cSelUpdat1 +=   " AND SE5.E5_NUMERO =   " + cTable + ".E5_NUMERO "
    cSelUpdat1 +=   " AND SE5.E5_PARCELA =  " + cTable + ".E5_PARCELA "
    cSelUpdat1 +=   " AND SE5.E5_TIPO =     " + cTable + ".E5_TIPO "
    cSelUpdat1 +=   " AND SE5.E5_CLIFOR =   " + cTable + ".E5_CLIFOR "
    cSelUpdat1 +=   " AND SE5.E5_LOJA =     " + cTable + ".E5_LOJA "
    cSelUpdat1 +=   " AND SE5.E5_RECPAG =   " + cTable + ".E5_RECPAG "
    cSelUpdat1 +=   " AND SE5.E5_SITUACA =  " + cTable + ".E5_SITUACA "
    cSelUpdat1 +=   " AND SE5.E5_NATUREZ =  " + cTable + ".E5_NATUREZ "
    cSelUpdat1 +=   " AND SE5.E5_SITUACA NOT IN ('C','E','X') "
    cSelUpdat1 +=   " AND SE5.D_E_L_E_T_ = ' ' "
    cSelUpdat1 +=   " AND NOT EXISTS "
    cSelUpdat1 += " (SELECT A.E5_NUMERO "
    cSelUpdat1 += " FROM " + RetSQLName("SE5") + " A "
    cSelUpdat1 += " WHERE "
    cSelUpdat1 +=   " A.E5_FILIAL = SE5.E5_FILIAL "
    cSelUpdat1 +=   " AND A.E5_PREFIXO = SE5.E5_PREFIXO "
    cSelUpdat1 +=   " AND A.E5_NUMERO = SE5.E5_NUMERO "
    cSelUpdat1 +=   " AND A.E5_PARCELA = SE5.E5_PARCELA "
    cSelUpdat1 +=   " AND A.E5_TIPO = SE5.E5_TIPO "
    cSelUpdat1 +=   " AND A.E5_CLIFOR = SE5.E5_CLIFOR "
    cSelUpdat1 +=   " AND A.E5_LOJA = SE5.E5_LOJA "
    cSelUpdat1 +=   " AND A.E5_SEQ = SE5.E5_SEQ "
    cSelUpdat1 +=   " AND A.E5_TIPODOC = 'ES' "
    cSelUpdat1 += " ) "

    cUpdate1 := " UPDATE " + cTable + " SET SE5MAXSEQ = ( " + ChangeQuery(cSelUpdat1) + ") "
    cUpdate1 += " WHERE " + cTable + ".E5_ORIGEM <> 'FINA100' "
    cUpdate1 += "   AND " + cTable + ".E5_NUMERO <> '" + Space(GetSX3Cache("E5_SEQ", "X3_TAMANHO"))  + "' "

    If TCSQLExec(cUpdate1) < 0
        DbOnError(TCSqlError(), "cUpdate1")
        Return Nil
    EndIf

    If TableInDic("FKD")
        cSelUpdat2 := " SELECT ISNULL(SUM(CASE WHEN FK6.FK6_ACAO = '1' THEN FK6.FK6_VALMOV ELSE -FK6.FK6_VALMOV END), 0) "
        If MV_PAR11 == 1
            cSelUpdat2 += " FROM " + RetSQLName("FK1") + " FK1 "
            cSelUpdat2 += " INNER JOIN " + RetSQLName("FK6") + " FK6 ON "
            cSelUpdat2 += " FK6.FK6_FILIAL = FK1.FK1_FILIAL "
            cSelUpdat2 += " AND FK6.FK6_IDORIG = FK1.FK1_IDFK1 "
            cSelUpdat2 += " AND FK6.FK6_TABORI = 'FK1' "
            cSelUpdat2 += " AND FK6.D_E_L_E_T_ = ' ' "
            cSelUpdat2 += " WHERE FK6.FK6_TPDOC = 'VA' "
            cSelUpdat2 += " AND FK1_FILIAL = " + cTable + ".E5_FILIAL "
            cSelUpdat2 += " AND FK1.FK1_IDFK1 = " + cTable + ".E5_IDORIG "
            cSelUpdat2 += " AND FK1.D_E_L_E_T_ = ' ' "
            cSelUpdat2 += " AND " + cTable + ".E5_TIPODOC <> 'VA' "
        Else
            cSelUpdat2 += " FROM " + RetSQLName("FK2") + " FK2 "
            cSelUpdat2 += " INNER JOIN " + RetSQLName("FK6") + " FK6 ON "
            cSelUpdat2 += " FK6.FK6_FILIAL = FK2.FK2_FILIAL "
            cSelUpdat2 += " AND FK6.FK6_IDORIG = FK2.FK2_IDFK2 "
            cSelUpdat2 += " AND FK6.FK6_TABORI = 'FK2' "
            cSelUpdat2 += " AND FK6.D_E_L_E_T_ = ' ' "
            cSelUpdat2 += " WHERE FK6.FK6_TPDOC = 'VA' "
            cSelUpdat2 += " AND FK2_FILIAL = " + cTable + ".E5_FILIAL "
            cSelUpdat2 += " AND FK2.FK2_IDFK2 = " + cTable + ".E5_IDORIG "
            cSelUpdat2 += " AND FK2.D_E_L_E_T_ = ' ' "
            cSelUpdat2 += " AND " + cTable + ".E5_TIPODOC <> 'VA' "
        EndIf

        cUpdate2 := " UPDATE " + cTable + " SET SE5VA = (" + ChangeQuery(cSelUpdat2) + ") "

        If TCSQLExec(cUpdate2) < 0
            DbOnError(TCSqlError(), "cUpdate2")
            Return Nil
        EndIf
    EndIf

    DbSelectArea("NEWSE5")
    DbGoTop()

    //Define array para arquivo de trabalho
    AAdd(aCampos, {"LINHA", "C", 80, 0})

    //Cria arquivo de Trabalho
    If (__oFINR190 <> Nil)
        __oFINR190:Delete()
        __oFINR190 := Nil
    EndIf

    __oFINR190 := FwTemporaryTable():New("TRB")
    __oFINR190:SetFields(aCampos)
    __oFINR190:AddIndex("1", {"LINHA"})
    __oFINR190:Create()

    aColu := IIf(aTam[1] > 6, {023, 027, TamParcela("E1_PARCELA", 40, 39, 38), 042, 000, 022}, {000, 004, TamParcela("E1_PARCELA", 17, 16, 15), 019, 023, 030})

    If MV_PAR16 == 1
        DbSelectArea("SE5")
        DbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
        DbGoTop()
    EndIf

    /* GESTAO - inicio */
    If MV_PAR40 == 1 .And. lNovaGestao
        nSelFil := 0
    Else
        SM0->(DbSeek(cEmpAnt + If(Empty(cFilDe), "", cFilDe), .T.))
    EndIf

    While SM0->(!EoF()) .And. SM0->M0_CODIGO == cEmpAnt .And.  If(MV_PAR40 == 1 .And. lNovaGestao, (nSelFil < nLenSelFil) .And. cFilDe <= cFilAte, SM0->M0_CODFIL <= cFilAte)
        If MV_PAR40 == 1 .And. lNovaGestao
            nSelFil++
            SM0->(DbSeek(cEmpAnt + aSelFil[nSelFil], .T.))
        EndIf
        /* GESTAO - fim */

        cFilAnt := IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)
        cFilNome:= SM0->M0_FILIAL
        DbSelectArea("NEWSE5")

        /* GESTAO - inicio */
        If !lNovaGestao
            If lUnidNeg .And. (cEmpresa <> FwCodEmp())
                SM0->(DbSkip())
                Loop
            EndIf
        EndIf
        /* GESTAO - fim */

        If MV_PAR11 == 2  //Pagar
            If MV_PAR39 != 3  //diferente de multinatureza verifica no SE2 se o campo esta preenchido
                SE2->(DbSetOrder(1))
                If SE2->(MsSeek(NEWSE5->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA))) //Alimentar a vari�vel lMultiNat apenas se for encontrado o t�tulo na filial corrente
                    lMultiNat := .F.//Inicializa vari�vel apenas se encontrar o t�tulo na filial corrente
                    lMultiNat := (SE2->E2_MULTNAT == "1") //pq se o campo nao estiver preenchido nao desvia para FINR199
                    lMultiNat := (lMultiNat .And. lRelMulNat)
                EndIf
            Else
                lMultiNat := lRelMulNat
            EndIf
        ElseIf MV_PAR11 = 1  //Receber
            lMultiNat := lRelMulNat
        EndIf

        If lMultiNat

            Finr199(    @nGerOrig, @nGerValor, @nGerDesc, @nGerJurMul, @nGerCM, @nGerAbLiq, @nGerAbImp, @nGerBaixado, @nGerMovFin, @nGerComp,;
                        @nFilOrig, @nFilValor, @nFilDesc, @nFilJurMul, @nFilCM, @nFilAbLiq, @nFilAbImp, @nFilBaixado, @nFilMovFin, @nFilComp,;
                        .F., cCondicao, cCond2, aColu, lContinua, cFilSE5, .T., Tamanho, @aRet, @aTotais, nOrdem, @nGerFat, @nFilFat, lNovaGestao)

            DbSelectArea("SE5")
            DbCloseArea()
            ChKFile("SE5")
            DbSelectArea("SE5")
            DbSetOrder(1)

            If Empty(FwXFilial("SE5"))
                Exit
            EndIf

            DbSelectArea("SM0")
            DbSkip()
            Loop
        Else
            cXFilSA1 := FwXFilial("SA1")
            cXFilSA2 := FwXFilial("SA2")
            cXFilSA6 := FwXFilial("SA6")
            cXFilSE1 := FwXFilial("SE1")
            cXFilSE2 := FwXFilial("SE2")
            cXFilSE5 := FwXFilial("SE5")
            cXFilSED := FwXFilial("SED")
            cXFilSEH := FwXFilial("SEH")
            cXFilSEI := FwXFilial("SEI")

            While NEWSE5->(!EoF()) .And. NEWSE5->E5_FILIAL == cXFilSE5

                DbSelectArea("NEWSE5")
                // Testa condicoes de filtro
                If (nRecChkd <> NEWSE5->SE5RECNO) .And. !u_Fr190TstCond()
                    NEWSE5->(DbSkip()) // filtro de registros desnecessarios
                    Loop
                Else
                    nRecChkd := NEWSE5->SE5RECNO
                EndIf

                //Titulo normal ou Adiantamento
                If (NEWSE5->E5_RECPAG == "R" .And. ! (NEWSE5->E5_TIPO $ "PA /" + MV_CPNEG)) .Or. (NEWSE5->E5_RECPAG == "P" .And. (NEWSE5->E5_TIPO $ "RA /" + MV_CRNEG))
                    cCarteira := "R"
                Else
                    cCarteira := "P"
                EndIf

                DbSelectArea("NEWSE5")
                cAnterior   := &cCond2
                nTotValor   := 0
                nTotDesc    := 0
                nTotJurMul  := 0
                nTotCM      := 0
                nCT         := 0
                nTotOrig    := 0
                nTotBaixado := 0
                nTotAbLiq   := 0
                nTotImp     := 0
                nTotMovFin  := 0
                nTotComp    := 0
                nTotFat     := 0

                While NEWSE5->(!EoF()) .And. NEWSE5->E5_FILIAL == cXFilSE5 .And. &cCond2 == cAnterior

                    lManual     := .F.
                    lSkpNewSe5  := .F.
                    DbSelectArea("NEWSE5")

                    If (Empty(NEWSE5->E5_TIPODOC) .And. MV_PAR16 == 1) .Or. (Empty(NEWSE5->E5_NUMERO)  .And. MV_PAR16 == 1)
                        lManual := .T. 
                    EndIf

                    // Testa condicoes de filtro
                    If (nRecChkd <> NEWSE5->SE5RECNO) .And. !u_Fr190TstCond()
                        NEWSE5->(DbSkip()) // filtro de registros desnecessarios
                        Loop
                    Else
                        nRecChkd := NEWSE5->SE5RECNO
                    EndIf

                    cNumero     := NEWSE5->E5_NUMERO
                    cPrefixo    := NEWSE5->E5_PREFIXO
                    cParcela    := NEWSE5->E5_PARCELA
                    dBaixa      := NEWSE5->E5_DATA
                    cBanco      := NEWSE5->E5_BANCO
                    cAge        := NEWSE5->E5_AGENCIA
                    cContaBco   := NEWSE5->E5_CONTA
                    cNatureza   := NEWSE5->E5_NATUREZ
                    cCliFor     := NEWSE5->E5_BENEF
                    cLoja       := NEWSE5->E5_LOJA
                    cSeq        := NEWSE5->E5_SEQ
                    cNumCheq    := NEWSE5->E5_NUMCHEQ
                    cRecPag     := NEWSE5->E5_RECPAG
                    cTipoDoc    := NEWSE5->E5_TIPODOC
                    cMotBaixa   := NEWSE5->E5_MOTBX
                    cCheque     := NEWSE5->E5_NUMCHEQ
                    cSeq        := NEWSE5->E5_SEQ
                    cTipo       := NEWSE5->E5_TIPO
                    cFornece    := NEWSE5->E5_CLIFOR
                    dDigit      := NEWSE5->E5_DTDIGIT
                    lBxTit      := .F.
                    cFilorig    := NEWSE5->E5_FILORIG
                    nMoedMov    := Val(NEWSE5->E5_MOEDA)

                    cMaxSeq := NEWSE5->SE5MAXSEQ

                    //Titulo normal ou Adiantamento
                    If (NEWSE5->E5_RECPAG == "R" .And. ! (NEWSE5->E5_TIPO $ "PA /" + MV_CPNEG)) .Or. (NEWSE5->E5_RECPAG == "P" .And. (NEWSE5->E5_TIPO $ "RA /" + MV_CRNEG));
                        .Or. (NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC == "E2")
                        DbSelectArea("SE1")
                        DbSetOrder(1)
                        // Procuro SE1 pela filial origem
                        lBxTit := MsSeek(FwXFilial("SE1", cFilOrig) + cPrefixo + cNumero + cParcela + cTipo)
                        If !lBxTit
                            lBxTit := MsSeek(NEWSE5->E5_FILORIG + cPrefixo + cNumero + cParcela + cTipo)
                        EndIf
                        cCarteira := "R"
                        dDtMovFin := IIf (lManual, CToD("//"), SE1->E1_VENCREA)
                        While SE1->(!EoF()) .And. SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO == cPrefixo + cNumero + cParcela + cTipo
                            If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja // Cliente igual, Ok
                                Exit 
                            EndIf
                            SE1->(DbSkip())
                        End
                        If !SE1->(EoF()) .And. MV_PAR11 == 1 .And. !lManual .And. (NEWSE5->E5_RECPAG == "R" .And. !(NEWSE5->E5_TIPO $ MVPAGANT + "/" + MV_CPNEG))
                            If lFilSit .And. !Empty(NEWSE5->E5_SITCOB) //Verifica se filtra por situa��o MV_PAR15 em branco exibi todas situa��es
                                If !(NEWSE5->E5_SITCOB $ MV_PAR15)
                                    DbSelectArea("NEWSE5")
                                    NEWSE5->(DbSkip()) // filtro de registros desnecessarios
                                    Loop
                                EndIf
                            EndIf

                        EndIf
                        cCond3  := "1"
                        nDesc   := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
                    Else
                        DbSelectArea("SE2")
                        DbSetOrder(1)
                        cCarteira := "P"
                        // Procuro SE2 pela filial origem
                        lBxTit := MsSeek(FwXFilial("SE2", cFilOrig) + cPrefixo + cNumero + cParcela + cTipo + cFornece + cLoja)

                        IIf(lBxTit, nRecSE2 := SE2->(Recno()), nRecSE2 := 0)

                        If !lBxTit
                            lBxTit := MsSeek(NEWSE5->E5_FILORIG + cPrefixo + cNumero + cParcela + cTipo + cFornece + cLoja)
                        EndIf
                        dDtMovFin := IIf(lManual, CToD("//"), SE2->E2_VENCREA)
                        cCond3  := "2"
                        nDesc   := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
                        cCheque := IIf(Empty(NEWSE5->E5_NUMCHEQ), SE2->E2_NUMBCO, NEWSE5->E5_NUMCHEQ)
                    EndIf

                    DbSelectArea("NEWSE5")
                    cHistorico := Space(40)
                    While NEWSE5->(!EoF()) .And. NEWSE5->E5_FILIAL == cXFilSE5 .And.;
                        IIf(cCond3 == "1",;
                        NEWSE5->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + DToS(E5_DATA) + E5_SEQ + E5_NUMCHEQ) == cPrefixo + cNumero + cParcela + cTipo + DToS(dBaixa) + cSeq + cNumCheq,;
                        NEWSE5->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + DToS(E5_DATA) + E5_SEQ + E5_NUMCHEQ) == cPrefixo + cNumero + cParcela + cTipo + cFornece + DToS(dBaixa) + cSeq + cNumCheq)

                        DbSelectArea("NEWSE5")
                        cTipoDoc    := NEWSE5->E5_TIPODOC
                        cCheque     := NEWSE5->E5_NUMCHEQ

                        lSkpNewSe5  := .F.
                        lAchouEmp   := .T.
                        lAchouEst   := .F.
                        nVlrGlosa   := 0

                        // Testa condicoes de filtro
                        If (nRecChkd <> NEWSE5->SE5RECNO) .And. !u_Fr190TstCond()
                            NEWSE5->(DbSkip()) // filtro de registros desnecessarios
                            lSkpNewSe5 := .T.
                            Loop
                        Else
                            nRecChkd := NEWSE5->SE5RECNO
                        EndIf

                        If NEWSE5->E5_LOJA != cLoja
                            Exit
                        EndIf

                        If NEWSE5->E5_FILORIG < MV_PAR33 .Or. NEWSE5->E5_FILORIG > MV_PAR34
                            DbSelectArea("NEWSE5")
                            NEWSE5->(DbSkip())
                            lSkpNewSe5 := .T.
                            Loop
                        EndIf

                        //Nao imprime os registros de emprestimos excluidos
                        If NEWSE5->E5_TIPODOC == "EP"
                            aAreaSE5 := NEWSE5->(GetArea())
                            DbSelectArea("SEH")
                            DbSetOrder(1)
                            lAchouEmp := MsSeek(cXFilSEH + SubStr(NEWSE5->E5_DOCUMEN, 1, nTamEH))
                            RestArea(aAreaSE5)
                            If !lAchouEmp
                                NEWSE5->(DbSkip())
                                lSkpNewSe5 := .T.
                                Loop
                            EndIf
                        EndIf

                        //Nao imprime os registros de pagamento de emprestimos estornados
                        If NEWSE5->E5_TIPODOC == "PE"
                            aAreaSE5 := NEWSE5->(GetArea())
                            DbSelectArea("SEI")
                            DbSetOrder(1)
                            If MsSeek(cXFilSEI + "EMP" + SubStr(NEWSE5->E5_DOCUMEN, 1, nTamEI))
                                If SEI->EI_STATUS == "C"
                                    lAchouEst := .T.
                                EndIf
                            EndIf
                            RestArea(aAreaSE5)
                            If lAchouEst
                                NEWSE5->(DbSkip())
                                lSkpNewSe5 := .T.
                                Loop
                            EndIf
                        EndIf

                        //Verifica o vencto do Titulo
                        cFilTrb := If(cCarteira == "R", "SE1", "SE2")
                        If (cFilTrb)->(!EoF()) .And. ((cFilTrb)->&(Right(cFilTrb, 2) + "_VENCREA") < MV_PAR31 .Or.;
                            (!Empty(MV_PAR32) .And. (cFilTrb)->&(Right(cFilTrb, 2) + "_VENCREA") > MV_PAR32))
                            DbSelectArea("NEWSE5")
                            NEWSE5->(DbSkip())
                            lSkpNewSe5 := .T.
                            Loop
                        EndIf

                        dBaixa      := NEWSE5->E5_DATA
                        cBanco      := NEWSE5->E5_BANCO
                        cAge        := NEWSE5->E5_AGENCIA
                        cContaBco   := NEWSE5->E5_CONTA
                        cNatureza   := NEWSE5->E5_NATUREZ
                        cCliFor     := NEWSE5->E5_BENEF
                        cSeq        := NEWSE5->E5_SEQ
                        cNumCheq    := NEWSE5->E5_NUMCHEQ
                        cRecPag     := NEWSE5->E5_RECPAG
                        cMotBaixa   := NEWSE5->E5_MOTBX
                        cTipo190    := NEWSE5->E5_TIPO
                        cFilorig    := NEWSE5->E5_FILORIG

                        //Obter moeda da conta no Banco.
                        If (cPaisLoc # "BRA" .And. !Empty(NEWSE5->E5_BANCO + NEWSE5->E5_AGENCIA + NEWSE5->E5_CONTA)) .Or. FXMultSld()
                            SA6->(DbSetOrder(1))
                            SA6->(MsSeek(cXFilSA6 + NEWSE5->E5_BANCO + NEWSE5->E5_AGENCIA + NEWSE5->E5_CONTA))
                            nMoedaBco := Max(SA6->A6_MOEDA, 1)
                        Else
                            nMoedaBco := 1
                        EndIf

                        If !Empty(NEWSE5->E5_NUMERO)
                            If (NEWSE5->E5_RECPAG == "R" .And. !(NEWSE5->E5_TIPO $ MVPAGANT + "/" + MV_CPNEG)) .Or. ;
                                (NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPO $ MVRECANT + "/" + MV_CRNEG) .Or.;
                                (NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
                                DbSelectArea("SA1")
                                DbSetOrder(1)
                                lAchou := .F.
                                If MsSeek(cXFilSA1 + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                    lAchou := .T.
                                EndIf
                                If !lAchou
                                    cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
                                    If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                        If Upper(AllTrim(SA1->A1_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                            lAchou := .T.
                                        Else
                                            cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
                                            If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                                If Upper(AllTrim(SA1->A1_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                                    lAchou := .T.
                                                EndIf
                                            EndIf
                                        EndIf
                                    Else
                                        cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
                                        If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                            If Upper(AllTrim(SA1->A1_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                                lAchou := .T.
                                            EndIf
                                        EndIf
                                    EndIf
                                EndIf
                                If lAchou
                                    cCliFor := IIf(MV_PAR30 == 1, GetLGPDValue("SA1", "A1_NREDUZ"), GetLGPDValue("SA1", "A1_NOME"))
                                Else
                                    cCliFor := Upper(AllTrim(GetLGPDValue("NEWSE5", "E5_BENEF")))
                                EndIf
                            Else
                                DbSelectArea("SA2")
                                DbSetOrder(1)
                                lAchou := .F.
                                If MsSeek(cXFilSA2 + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                    lAchou := .T.
                                EndIf
                                If !lAchou
                                    cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
                                    If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                        If Upper(AllTrim(SA2->A2_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                            lAchou := .T.
                                        Else
                                            cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
                                            If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                                If Upper(AllTrim(SA2->A2_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                                    lAchou := .T.
                                                EndIf
                                            EndIf
                                        EndIf
                                    Else
                                        cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
                                        If MsSeek(cFilOrig + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                            If Upper(AllTrim(SA2->A2_NREDUZ)) == Upper(AllTrim(NEWSE5->E5_BENEF))
                                                lAchou := .T.
                                            EndIf
                                        EndIf
                                    EndIf
                                EndIf
                                If lAchou
                                    cCliFor := IIf(MV_PAR30 == 1, GetLGPDValue("SA2", "A2_NREDUZ"), GetLGPDValue("SA2", "A2_NOME"))
                                Else
                                    cCliFor := Upper(AllTrim(GetLGPDValue("NEWSE5", "E5_BENEF")))
                                EndIf
                            EndIf
                        EndIf
                        DbSelectArea("SM2")
                        DbSetOrder(1)
                        DbSeek(NEWSE5->E5_DATA)
                        DbSelectArea("NEWSE5")
                        nTaxa := 0

                        If cPaisLoc == "BRA"
                            nTaxa := NEWSE5->E5_TXMOEDA
                            If nTaxa == 0 .And. (nMoedMov <> 1 .Or. SE2->E2_MOEDA <> 1)
                                If nMoedaBco == 1
                                    nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
                                Else
                                    nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
                                EndIf
                            ElseIf nTaxa > 0 .And.  nMoedMov == 1 .And. SE2->E2_MOEDA == 1 .And. (NEWSE5->E5_TIPODOC == "PA" .And. NEWSE5->E5_TIPO $ MVPAGANT)
                                nTaxa := 0
                            EndIf
                        EndIf

                        nRecSe5 := NEWSE5->SE5RECNO
                        nDesc   += IIf(MV_PAR12 == 1 .And. nMoedaBco == 1, NEWSE5->E5_VLDESCO, Round(xMoeda(NEWSE5->E5_VLDESCO, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, nTaxa), nDecs + 1))
                        nJuros  += IIf(MV_PAR12 == 1 .And. nMoedaBco == 1, NEWSE5->E5_VLJUROS, Round(xMoeda(NEWSE5->E5_VLJUROS, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs +  1, nTaxa), nDecs + 1))
                        nMulta  += IIf(MV_PAR12 == 1 .And. nMoedaBco == 1, NEWSE5->E5_VLMULTA, Round(xMoeda(NEWSE5->E5_VLMULTA, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, nTaxa), nDecs + 1))
                        nJurMul += nJuros + nMulta
                        nCM     += IIf(MV_PAR12 == 1 .And. nMoedaBco == 1, NEWSE5->E5_VLCORRE, Round(xMoeda(NEWSE5->E5_VLCORRE, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, nTaxa), nDecs + 1))

                        If lPccBaixa .And. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL) .And. cCarteira == "P"
                            If nRecSE2 > 0

                                aAreaBk  := GetArea()
                                aAreaSE2 := SE2->(GetArea())
                                SE2->(DbGoTo(nRecSE2))

                                nTotAbImp += (NEWSE5->E5_VRETPIS) + (NEWSE5->E5_VRETCOF) + (NEWSE5->E5_VRETCSL) + SE2->E2_INSS + SE2->E2_ISS + SE2->E2_IRRF

                                RestArea(aAreaSE2)
                                RestArea(aAreaBk)
                            Else
                                nTotAbImp += (NEWSE5->E5_VRETPIS) + (NEWSE5->E5_VRETCOF) + (NEWSE5->E5_VRETCSL) + IIf(lMvGlosa , NEWSE5->E5_VRETIRF + NEWSE5->E5_VRETISS + NEWSE5->E5_VRETINS , 0)
                            EndIf

                            nVlrGlosa := nTotAbImp
                        EndIf

                        If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
                            nValTroco := 0
                            cHistorico := NEWSE5->E5_HISTOR

                            If MV_PAR11 == 2
                                If cPaisLoc == "ARG" .And. !Empty(NEWSE5->E5_ORDREC)
                                    nValor += IIf(nMoedMov == MV_PAR12, NEWSE5->E5_VALOR, Round(xMoeda(NEWSE5->E5_VALOR, Val(NEWSE5->E5_MOEDA), MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, NEWSE5->E5_TXMOEDA), nDecs + 1))
                                Else
                                    If MV_PAR12 == nMoedMov
                                        nValor += NEWSE5->E5_VALOR
                                    Else
                                        If cCarteira == "P" .AND. MV_PAR12 == SE2->E2_MOEDA .AND. nMoedMov > 1 .AND. SE2->E2_MOEDA > 1
                                            nValor += NEWSE5->E5_VLMOED2
                                        Else
                                            nValor += Round(xMoeda(NEWSE5->E5_VALOR, nMoedMov, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, IIf(nMoedMov == 1, 0, nTaxa), IIf(nMoedMov == 1, nTaxa, 0)), nDecs + 1)
                                        EndIf
                                    EndIf
                                EndIf
                            Else
                                If cPaisLoc <> "BRA" .And. !Empty(NEWSE5->E5_ORDREC)
                                    nValor += IIf(MV_PAR12 == 1 .And. nMoedaBco == 1, NEWSE5->E5_VALOR, Round(xMoeda(NEWSE5->E5_VLMOED2, Val(NEWSE5->E5_MOEDA), MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, If(cPaisLoc == "BRA", NEWSE5->E5_TXMOEDA, 0)), nDecs + 1))
                                Else
                                    If NEWSE5->E5_VLMOED2 > 0 .And. MovMoedEs(NEWSE5->E5_MOEDA, NEWSE5->E5_TIPODOC, NEWSE5->E5_MOTBX, DTOS(NEWSE5->E5_DATA), NEWSE5->E5_RECPAG)
                                        nValor += If(MV_PAR12 == 2, NEWSE5->E5_VALOR, NEWSE5->E5_VLMOED2)
                                    Else
                                        If nMoedMov == MV_PAR12
                                            nValor += NEWSE5->E5_VALOR
                                        ElseIf NEWSE5->E5_TIPODOC == "RA" .And. ((MV_PAR12 ==nMoedaBco) .Or. (MV_PAR12 == 1))
                                            If MV_PAR12 = nMoedaBco
                                                nValor += NEWSE5->E5_VALOR
                                            Else
                                                nValor += NEWSE5->E5_VLMOED2
                                            EndIf
                                        Else
                                            If nMoedMov == 1
                                                nValor += Round(xMoeda(NEWSE5->E5_VALOR, nMoedMov, MV_PAR12, NEWSE5->E5_DATA, nCasDec, 0, nTaxa), 2)
                                            Else
                                                nValor += Round(xMoeda(NEWSE5->E5_VALOR, nMoedMov, MV_PAR12, NEWSE5->E5_DATA, nCasDec, nTaxa), 2)
                                            EndIf
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf

                            If lMVLjTroco
                                lTroco := If(SubStr(NEWSE5->E5_HISTOR, 1, 3) == "LOJ", .T., .F.)
                                If lTroco
                                    nRecnoSE5 := SE5->(Recno())
                                    DbSelectArea("SE5")
                                    DbSetOrder(7)
                                    If DbSeek(cXFilSE5 + NEWSE5->E5_PREFIXO + NEWSE5->E5_NUMERO + NEWSE5->E5_PARCELA + Space(TamSX3("E5_TIPO")[1]) + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA)
                                        While !EoF() .And. cXFilSE5 == SE5->E5_FILIAL .And. NEWSE5->E5_PREFIXO + NEWSE5->E5_NUMERO + NEWSE5->E5_PARCELA + Space(TamSX3("E5_TIPO")[1]) + NEWSE5->E5_CLIFOR + NEWSE5->E5_LOJA == SE5->E5_PREFIXO + ;
                                                            SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA

                                            If SE5->E5_MOEDA = "TC" .And. SE5->E5_TIPODOC = "VL" .And. SE5->E5_RECPAG = "P"
                                                nValTroco := SE5->E5_VALOR
                                            EndIf
                                            SE5->(DbSkip())
                                        End
                                    EndIf
                                    SE5->(DbGoTo(nRecnoSE5))
                                EndIf
                            EndIf

                            DbSelectArea("NEWSE5")

                            nValor -= nValTroco

                            //Pcc Baixa CR
                            If cCarteira == "R" .And. lPccBxCr .And. cPaisLoc == "BRA" .And. (IIf(lRaRtImp, NEWSE5->E5_TIPO $ MVRECANT, .T.) .Or. lPccBaixa)
                                If Empty(NEWSE5->E5_PRETPIS)
                                    nPccBxCr += IIf(MV_PAR12 == 1.And.nMoedaBco == 1, NEWSE5->E5_VRETPIS, Round(xMoeda(NEWSE5->E5_VRETPIS, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1,, NEWSE5->E5_TXMOEDA), nDecs + 1))
                                EndIf
                                If Empty(NEWSE5->E5_PRETCOF)
                                    nPccBxCr += IIf(MV_PAR12 == 1.And.nMoedaBco == 1, NEWSE5->E5_VRETCOF, Round(xMoeda(NEWSE5->E5_VRETCOF, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1,, NEWSE5->E5_TXMOEDA), nDecs + 1))
                                EndIf
                                If Empty(NEWSE5->E5_PRETCSL)
                                    nPccBxCr += IIf(MV_PAR12 == 1.And.nMoedaBco == 1, NEWSE5->E5_VRETCSL, Round(xMoeda(NEWSE5->E5_VRETCSL, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1,, NEWSE5->E5_TXMOEDA), nDecs + 1))
                                EndIf
                            EndIf
                        Else
                            nVlMovFin   += IIf(MV_PAR12 == 1.And.nMoedaBco == 1, NEWSE5->E5_VALOR, Round(xMoeda(NEWSE5->E5_VALOR, nMoedaBco, MV_PAR12, NEWSE5->E5_DATA, nDecs + 1, nTaxa), nDecs + 1))
                            cHistorico  := IIf(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL", NEWSE5->E5_HISTOR)
                            cNatureza   := NEWSE5->E5_NATUREZ
                        EndIf

                        cAuxFilNome := cFilAnt + " - " + cFilNome
                        cAuxCliFor  := cCliFor
                        cAuxLote    := E5_LOTE
                        dAuxDtDispo := E5_DTDISPO
                        Exit
                    End

                    If (nDesc + nValor + nJurMul + nVlMovFin) <> 0
                        AAdd(aRet, Array(ID_ARRAYSIZE))
                        nTamRet := Len(aRet)
                        // Defaults >>>
                        aRet[nTamRet][ID_PREFIXO]   := ""
                        aRet[nTamRet][ID_NUMERO ]   := ""
                        aRet[nTamRet][ID_PARCELA]   := ""
                        aRet[nTamRet][ID_TIPO]      := ""
                        aRet[nTamRet][ID_CLIFOR]    := ""
                        aRet[nTamRet][ID_LOJA]      := ""
                        // <<< Defaults

                        aRet[nTamRet][ID_FILIAL]    := cAuxFilNome
                        aRet[nTamRet][ID_E5BENEFIC] := cAuxCliFor
                        aRet[nTamRet][ID_E5LOTE]    := cAuxLote
                        aRet[nTamRet][ID_E5DTDISPO] := dAuxDtDispo

                        //C�lculo do Abatimento
                        If cCarteira == "R" .And. !lManual
                            DbSelectArea("SE1")
                            nRecno      := Recno()
                            nAbat       := 0
                            nAbatLiq    := 0

                            // Entra no If abaixo se titulo totalmente baixado e se for a maior sequnecia de baixa no SE5
                            If !SE1->E1_TIPO $ MVRECANT + "/" + MV_CRNEG .And. Empty(SE1->E1_SALDO) .And. cMaxSeq == cSeq
                                // Calcula o valor total de abatimento do titulo e impostos se houver
                                nTotAbImp  := 0
                                nAbat := SumAbatRec(cPrefixo, cNumero, cParcela, SE1->E1_MOEDA, "V", dBaixa, @nTotAbImp,;
                                Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil, .T.)
                                
                                nAbatLiq   := nAbat - nTotAbImp

                                cCliFor190 := SE1->E1_CLIENTE + SE1->E1_LOJA

                                SA1->(DbSetOrder(1))
                                If cPaisLoc == "BRA" .And. SA1->(DbSeek(cXFilSA1 + cCliFor190))
                                    lCalcIRF := SA1->A1_RECIRRF == "1" .And. SA1->A1_IRBAX == "1" // se for na baixa
                                Else
                                    lCalcIRF := .F.
                                EndIf
                                If lCalcIRF .And. !lMvGlosa
                                    nTotAbImp += SE1->E1_IRRF
                                EndIf
                            EndIf
                            DbSelectArea("SE1")
                            DbGoTo(nRecno)
                        ElseIf !lManual
                            DbSelectArea("SE2")
                            nRecno := Recno()
                            nAbat := 0
                            nAbatLiq := 0
                            If !SE2->E2_TIPO $ MVPAGANT + "/" + MV_CPNEG .And. Empty(SE2->E2_SALDO) .And. cMaxSeq == cSeq //NEWSE5->E5_SEQ
                                nAbat       := SomaAbat(cPrefixo, cNumero, cParcela, "P", MV_PAR12,, cFornece, cLoja)
                                nAbatLiq    := nAbat
                            EndIf
                            DbSelectArea("SE2")
                            DbGoTo(nRecno)
                        EndIf

                        aRet[nTamRet][ID_CLIFOR]    := " "
                        aRet[nTamRet][ID_LOJA]      := " "

                        If MV_PAR11 == 1 .And. aTam[1] > 6 .And. !lManual
                            If lBxTit
                                aRet[nTamRet][ID_CLIFOR] := SE1->E1_CLIENTE
                                aRet[nTamRet][ID_LOJA]   := SE1->E1_LOJA
                            EndIf
                            aRet[nTamRet][ID_NOMECLIFOR] := AllTrim(cCliFor)
                        ElseIf MV_PAR11 == 2 .And. aTam[1] > 6 .And. !lManual
                            If lBxTit
                                aRet[nTamRet][ID_CLIFOR] := SE2->E2_FORNECE
                                aRet[nTamRet][ID_LOJA]   := SE2->E2_LOJA
                            EndIf
                            aRet[nTamRet][ID_NOMECLIFOR] := AllTrim(cCliFor)
                        EndIf

                        aRet[nTamRet][ID_PREFIXO] := cPrefixo
                        aRet[nTamRet][ID_NUMERO ] := cNumero
                        aRet[nTamRet][ID_PARCELA] := cParcela
                        aRet[nTamRet][ID_TIPO]    := cTipo

                        If !lManual
                            DbSelectArea("TRB")
                            lOriginal := .T.
                            //Baixas a Receber
                            If cCarteira == "R"
                                cCliFor190 := SE1->E1_CLIENTE + SE1->E1_LOJA
                                nVlr := Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, MV_PAR12, SE1->E1_BAIXA, nDecs + 1, If(cPaisLoc == "BRA", nTaxa, 0)), nDecs + 1)
                                //Baixa de PA
                            Else
                                cCliFor190 := SE2->E2_FORNECE + SE2->E2_LOJA

                                If cPaisLoc == "BRA"
                                    lCalcIRF:= Posicione("SA2", 1, cXFilSA2 + cCliFor190, "A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
                                            Posicione("SA2", 1, cXFilSA2 + cCliFor190, "A2_CALCIRF") == " "
                                Else
                                    lCalcIRF:=.F.
                                EndIf

                                nVlImp := 0
                                //efetua tratamento de Soma de Impostos
                                If lConsImp   //default soma os impostos no valor original (MV_PAR41)
                                    // MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
                                    nVlImp := SE2->E2_INSS + IIf(GetNewPar("MV_MRETISS", "1") == "1", SE2->E2_ISS, 0) + IIf(lCalcIRF, SE2->E2_IRRF, 0)
                                    If ! lPccBaixa  // SE PCC NA EMISSAO SOMA PCC
                                        nVlImp += SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL
                                    EndIf
                                EndIf
                                
                                //impostos sempre estar�o em reais.
                                nVlImp  := Round(xMoeda(nVlImp, 1, MV_PAR12, SE2->E2_BAIXA, nDecs + 1, IIf(MV_PAR12 == 1, nTaxa, 0), IIf(MV_PAR12 > 1, nTaxa, 0)), nDecs + 1)
                                If MV_PAR12 == SE2->E2_MOEDA
                                    nVlr := SE2->E2_VALOR + nVlImp
                                Else
                                    nVlr := Round(xMoeda(SE2->E2_VALOR, SE2->E2_MOEDA, MV_PAR12, SE2->E2_BAIXA, nDecs + 1, IIf(MV_PAR12 == 1, nTaxa, 0), IIf(MV_PAR12 > 1, nTaxa, 0)) + nVlImp, nDecs + 1)
                                EndIf
                            EndIf
                            aRet[nTamRet, ID_E5RECNO] := nRecSE5
                            DbGoTo(nRecSe5)
                            cFilTrb := If(cCarteira == "R", "SE1", "SE2")
                            If DbSeek(IIf(cFilTrb == "SE1", cXFilSE1, cXFilSE2) + cPrefixo + cNumero + cParcela + cCliFor190 + cTipo)
                                nAbat       := 0
                                lOriginal   := .F.
                            Else
                                If cMaxSeq == cSeq
                                    RecLock("TRB", .T.)
                                    Replace linha With IIf(cFilTrb == "SE1", cXFilSE1, cXFilSE2) + cPrefixo + cNumero + cParcela + cCliFor190 + cTipo
                                    MsUnlock()
                                EndIf
                            EndIf
                        Else
                            DbSelectArea("SE5")
                            aRet[nTamRet, ID_E5RECNO] := nRecSE5
                            DbGoTo(nRecSe5)
                            nVlr := Round(xMoeda(E5_VALOR, nMoedaBco, MV_PAR12, E5_DATA, nDecs + 1,, If(cPaisLoc == "BRA", nTaxa, 0)), nDecs + 1)

                            nAbat:= 0
                            lOriginal := .T.
                            nRecSe5 := NEWSE5->SE5RECNO
                            DbSelectArea("TRB")
                        EndIf

                        If cCarteira == "R"
                            If (!lManual)
                                If MV_PAR13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
                                    cHistorico := IIf(Empty(cHistorico), SE1->E1_HIST, cHistorico)
                                Else
                                    cHistorico := IIf(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST)
                                EndIf
                            EndIf
                            If aTam[1] <= 6 .And. !lManual
                                If lBxTit
                                    aRet[nTamRet][ID_CLIFOR]    := SE1->E1_CLIENTE
                                    aRet[nTamRet][ID_LOJA]      := SE1->E1_LOJA
                                EndIf
                                aRet[nTamRet][ID_NOMECLIFOR]    := AllTrim(cCliFor)
                            EndIf
                            cMascNat := MascNat(cNatureza)
                            aRet[nTamRet][ID_NATUREZA] := If(Len(AllTrim(cNatureza)) > 8, cNatureza, cMascNat)
                            If Empty(dDtMovFin) .Or. dDtMovFin == Nil
                                dDtMovFin := CToD("  /  /  ")
                            EndIf
                            aRet[nTamRet][ID_VENCIMENTO]    := IIf(lManual, dDtMovFin, SE1->E1_VENCREA) //Vencto
                            aRet[nTamRet][ID_HISTORICO]     := AllTrim(cHistorico)
                            aRet[nTamRet][ID_DTBAIXA]       := dBaixa
                            cChaveTit := SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)
                        Else
                            If MV_PAR13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
                                cHistorico := IIf(Empty(cHistorico), SE2->E2_HIST, cHistorico)
                            Else
                                cHistorico := IIf(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST)
                            EndIf
                            If aTam[1] <= 6 .And. !lManual
                                If lBxTit
                                    aRet[nTamRet][ID_CLIFOR] := SE2->E2_FORNECE
                                    aRet[nTamRet][ID_LOJA]   := SE2->E2_LOJA
                                EndIf
                                aRet[nTamRet][ID_NOMECLIFOR] := AllTrim(cCliFor)
                            EndIf
                            cMascNat := MascNat(cNatureza)
                            aRet[nTamRet][ID_NATUREZA] := If(Len(AllTrim(cNatureza)) > 8, cNatureza, cMascNat)
                            If Empty(dDtMovFin) .Or. dDtMovFin == Nil
                                dDtMovFin := CToD("  /  /  ")
                            EndIf
                            aRet[nTamRet][ID_VENCIMENTO] := IIf(lManual, dDtMovFin, SE2->E2_VENCREA)
                            If !Empty(cCheque)
                                aRet[nTamRet][ID_HISTORICO] := AllTrim(cCheque) + "/" + Trim(cHistorico)
                            Else
                                aRet[nTamRet][ID_HISTORICO] := AllTrim(cHistorico)
                            EndIf
                            aRet[nTamRet][ID_DTBAIXA] := dBaixa
                            cChaveTit := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)
                        EndIf

                        aRet[nTamRet][ID_VALORORIG] := nVlr
                        nCT++
                        aRet[nTamRet][ID_JUROSMULTA] := nJurMul

                        If cCarteira == "R" .And. MV_PAR12 == SE1->E1_MOEDA
                            aRet[nTamRet][ID_CORRECAO] := 0

                        ElseIf cCarteira == "P" .And. MV_PAR12 == SE2->E2_MOEDA
                            aRet[nTamRet][ID_CORRECAO] := 0

                        Else
                            aRet[nTamRet][ID_CORRECAO] := nCM 
                        EndIf

                        //PCC Baixa CR
                        //Somo aos abatimentos de impostos, os impostos PCC na baixa.
                        //Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
                        //O sistema encontra duas vezes o valor de impostos por conta do par�metro mv_glosa, portanto � necess�rio somar apenas um deles
                        If lMvGlosa .And. cCarteira == "R" .And. Empty(nTotAbImp) .And. nVlrGlosa > 0 .And. nVlrGlosa > nPccBxCr
                            nTotAbImp := nVlrGlosa
                        ElseIf !lMvGlosa
                            nTotAbImp := nTotAbImp + nPccBxCr
                        EndIf

                        aRet[nTamRet][ID_DESCONTO  ] := nDesc           //PicTure tm(nDesc, 11, nDecs)
                        aRet[nTamRet][ID_ABATIMENTO] := nAbatLiq        //Picture tm(nAbatLiq, 11, nDecs)
                        aRet[nTamRet][ID_IMPOSTO   ] := nTotAbImp       //Picture tm(nTotAbImp, 11, nDecs)

                        If nVlMovFin <> 0
                            aRet[nTamRet][ID_TOTALPAGO] := nVlMovFin    //PicTure tm(nVlMovFin, 15, nDecs)
                        Else
                            aRet[nTamRet][ID_TOTALPAGO] := nValor       //PicTure tm(nValor, 15, nDecs)
                        EndIf
                        aRet[nTamRet][ID_BANCO]   := cBanco
                        aRet[nTamRet][ID_AGENCIA] := cAge
                        aRet[nTamRet][ID_CONTA]   := cContaBco
                        If Len(DToC(dDigit)) <= 8
                            aRet[nTamRet][ID_DTDIGITACAO] := dDigit
                        Else
                            aRet[nTamRet][ID_DTDIGITACAO] := dDigit
                        EndIf

                        If Empty(cMotBaixa)
                            cMotBaixa := "NOR"  //NORMAL
                        EndIf

                        aRet[nTamRet][ID_MOTIVO ] := SubStr(cMotBaixa, 1, 3)
                        aRet[nTamRet][ID_FILORIG] := cFilorig

                        aRet[nTamRet][ID_LORIGINAL] := lOriginal
                        aRet[nTamRet][ID_VALORPG]   := If(nVlMovFin <> 0, nVlMovFin, If(u_F190MovBco(cMotBaixa), nValor, 0))
                        aRet[nTamRet][ID_TEMVALOR]  := aRet[nTamRet][ID_VALORPG] = 0
                        nTotOrig    += If(lOriginal, nVlr, 0)
                        nTotBaixado += If(cTipoDoc $ "CP/BA" .And. cMotBaixa $ "CMP/FAT", 0, nValor) //n�o soma, pois j� somou no principal
                        nTotDesc    += nDesc
                        nTotJurMul  += nJurMul
                        nTotCM      += nCM
                        nTotAbLiq   += nAbatLiq
                        nTotImp     += nTotAbImp
                        nTotValor   += aRet[nTamRet][ID_VALORPG]
                        nTotMovFin  += nVlMovFin
                        nTotComp    += If(cTipoDoc == "CP", nValor, 0)
                        nTotFat     += If(cMotBaixa $ "FAT", nValor, 0)
                        nDesc       := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
                        nPccBxCr    := 0    //PCC Baixa CR

                        If lOriginal .and. !Empty(cChaveTit) .And. aRet[nTamRet][ID_VALORORIG] != 0 .And. Len(aChaveTit) > 0 .And. AScan(aChaveTit, cChaveTit) > 0 
                            aRet[nTamRet][ID_LORIGINAL] := .F.
                        Else
                            AAdd(aChaveTit, cChaveTit)
                        EndIf

                        aRet[nTamRet][ID_TIPODOC] := cTipoDoc

                        aRet[nTamRet][ID_VALORVA] := NEWSE5->SE5VA

                        If !lRelMulNat
                            SE5->(DbGoTo(aRet[nTamRet][ID_E5RECNO]))
                            If !lRelatInit
                                lRelatInit := .T.
                                InitReport(oReport, aRet, @nI, @cTotText)
                                oBaixas:Init()
                            EndIf

                            nI := nTamRet
                            If oReport:Cancel()
                                nI++
                                EndReport()
                                FwFreeArray(aChaveTit)
                                Return Nil
                            EndIf

                            If aRet[nTamRet][ID_CLIFOR] == Nil
                                aRet[nTamRet][ID_CLIFOR] := ""
                            EndIf

                            If aRet[nTamRet][ID_TIPODOC] == "VA"
                                ZeraVA(aRet[nTamRet])
                            EndIf

                            oBaixas:PrintLine()

                            If (nOrdem == 1 .Or. nOrdem == 6 .Or. nOrdem == 8)
                                cTotText := STR0071 + " : " + DToC(aRet[nTamRet][nCond1])   //"Sub Total"
                            Else //nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 7
                                cTotText := STR0071 + " : " + aRet[nTamRet][nCond1]         //"Sub Total"
                                If nOrdem == 2 //Banco
                                    SA6->(DbSetOrder(1))
                                    SA6->(MsSeek(cXFilSA6 + aRet[nTamRet][nCond1] + aRet[nTamRet][ID_AGENCIA] + aRet[nTamRet][ID_CONTA]))
                                    cTotText += " " + Trim(SA6->A6_NOME)
                                ElseIf nOrdem == 3 //Natureza
                                    SED->(DbSetOrder(1))
                                    SED->(MsSeek(cXFilSED + StrTran (aRet[nTamRet][nCond1], ".", "")))
                                    cTotText += SED->ED_DESCRIC
                                EndIf
                            EndIf

                            If lVarFil
                                cTxtFil := aRet[nTamRet][ID_FILIAL]
                            EndIf
                            nI++
                        EndIf
                    EndIf

                    If !lSkpNewSe5
                        DbSelectArea("NEWSE5")
                        NEWSE5->(DbSkip())
                    EndIf

                    If lManual
                        Exit
                    EndIf
                End

                If (nOrdem == 1 .Or. nOrdem == 6 .Or. nOrdem == 8)
                    cQuebra := DToS(cAnterior)
                Else //nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 7
                    cQuebra := cAnterior
                EndIf

                If (nTotValor + nDesc + nJurMul + nCM + nTotOrig + nTotMovFin + nTotComp + nTotFat) > 0
                    If nCT > 0
                        If nTotBaixado > 0
                            AAdd(aTotais, {cQuebra, STR0028, nTotBaixado})  //"Baixados"
                        EndIf
                        If nTotMovFin > 0
                            AAdd(aTotais, {cQuebra, STR0031, nTotMovFin})  //"Mov Fin."
                        EndIf
                        If nTotComp > 0
                            AAdd(aTotais, {cQuebra, STR0037, nTotComp})  //"Compens."
                        EndIf
                        If nTotFat > 0
                            AAdd(aTotais, {cQuebra, STR0076, nTotFat})  //"Bx.Fatura"
                        EndIf
                    EndIf
                EndIf

                //Incrementa Totais Gerais
                nGerBaixado += nTotBaixado
                nGerMovFin  += nTotMovFin
                nGerComp    += nTotComp
                nGerFat     += nTotFat

                //Incrementa Totais Filial
                nFilOrig    += nTotOrig
                nFilValor   += nTotValor
                nFilDesc    += nTotDesc
                nFilJurMul  += nTotJurMul
                nFilCM      += nTotCM
                nFilAbLiq   += nTotAbLiq
                nFilAbImp   += nTotImp
                nFilBaixado += nTotBaixado
                nFilMovFin  += nTotMovFin
                nFilComp    += nTotComp
                nFilFat     += nTotFat
            End
        EndIf

        //Imprimir TOTAL por filial somente quando houver 1 filial ou mais.
        If MV_PAR17 == 1 .And. SM0->(RecCount()) >= 1
            If nFilBaixado > 0
                AAdd(aTotais, {IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL), STR0028, nFilBaixado})  //"Baixados"
            EndIf
            If nFilMovFin > 0
                AAdd(aTotais, {IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL), STR0031, nFilMovFin})  //"Mov Fin."
            EndIf
            If nFilComp > 0
                AAdd(aTotais, {IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL), STR0037, nFilComp})  //"Compens."
            EndIf
            If nFilFat > 0
                AAdd(aTotais, {IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL), STR0076, nFilFat})  //"Compens."
            EndIf

            If MV_PAR17 == 2 .And. Empty(cXFilSE5)
                Exit
            EndIf

            nFilOrig    := nFilJurMul := nFilCM := nFilDesc := nFilAbLiq := nFilAbImp := nFilValor := 0
            nFilBaixado := nFilMovFin := nFilComp := nFilFat:= 0
        EndIf

        DbSelectArea("SM0")
        SM0->(DbSkip())
    End

    If nGerBaixado > 0
        AAdd(aTotais, {STR0075, STR0028, nGerBaixado})  //"Baixados"
    EndIf

    If nGerMovFin > 0
        AAdd(aTotais, {STR0075, STR0031, nGerMovFin})   //"Mov Fin."
    EndIf

    If nGerComp > 0
        AAdd(aTotais, {STR0075, STR0037, nGerComp})     //"Compens."
    EndIf

    If nGerFat > 0
        AAdd(aTotais, {STR0075, STR0076, nGerFat})      //"Bx.Fatura"
    EndIf

    SM0->(DbGoTo(nRecEmp))
    cFilAnt := IIf(lFwCodFil, FWGETCODFILIAL, SM0->M0_CODFIL)

    If (__oFINR190 <> Nil)
        __oFINR190:Delete()
        __oFINR190 := Nil
    EndIf

    /* GESTAO - inicio */
    If !Empty(cTmpSE5Fil)
        CtbTmpErase(cTmpSE5Fil)
    EndIf
    /* GESTAO - fim */

    EndReport()

    FwFreeArray(aChaveTit)

    DbSelectArea("SE5")
    DbSetOrder(1)

Return NIl

/*/{Protheus.doc} FR190MovCan
Verifica se o registro selecionado pertente a um titulo cuja baixa foi cancelada, mas que gerou mov bancario.

@type       function
@author     Marcelo Celi Marques
@since      05/10/2009
@param      nIndexSE5, numeric, �ndice de verifica��o
@param      _SE5, character, alias a ser utilizado na verifica��o
@return     logical, .T. caso tenha gerado
/*/
User Function FR190MovCan(nIndexSE5 As Numeric, _SE5 As Character) As Logical

    Local aAreaSE5  As Array
    Local lRet      As Logical

    aAreaSE5    := (_SE5)->(GetArea())
    lRet        := .F.

    If Empty((_SE5)->E5_MOTBX)
        DbSelectArea("SE5")
        DbSetOrder(nIndexSE5)
        If DbSeek((_SE5)->(E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ + "EC" + E5_SEQ))
            lRet := .T.
        EndIf
        DbSelectArea(_SE5)
        RestArea(aAreaSE5)
    EndIf

Return lRet

/*/{Protheus.doc} F190MovBco
Efetua busca do motivo de baixa para verificar se o mesmo movimenta banco. Utiliza o array _aMotBaixa (vari�vel static).

@type       function
@author     Rafael Riego
@since      15/09/2020
@param      cMotBx, character, motivo de baixa a ser buscado
@return     logical, .T. caso tenha encontrado e movimente banco, .F. caso n�o encontre ou caso n�o movimente banco
/*/
User Function F190MovBco(cMotBx As Character) As Logical

    Local lRet  As Logical

    Local nPos  As Numeric

    lRet := .F.

    If !(Empty(cMotBx))
        If (nPos := AScan(_aMotBaixa, {|motivo_baixa| SubStr(motivo_baixa, 1, 3) == Upper(cMotBx)})) > 0
            lRet := IIf(SubStr(_aMotBaixa[nPos], 19, 1) == "S", .T., .F.)
        EndIf
    EndIf

Return lRet

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Efetua a cria��o da tabela tempor�ria para realiza��o da busca das baixas a serem impressas. ||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function F190InitTb()

    Local aFields   As Array

    Local cAliasTMP As Character

    aFields   := {}
    cAliasTMP := "NEWSE5"

    If oFinR190Tb != Nil
        oFinR190Tb:Delete()
        oFinR190Tb := Nil
    EndIf

    aFields := u_F190Fields()

    oFinR190Tb := FwTemporaryTable():New(cAliasTMP)
    oFinR190Tb:SetFields(aFields)

    FwFreeArray(aFields)

Return Nil

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//Efetua a cria��o do �ndice da tabela tempor�ria se baseando na ordem escolhida pelo usu�rio.   ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function F190IndexTb(aIndex As Array)

    AAdd(aIndex, "SE5RECNO") //Adiciona recno ao final do �ndice selecionado para manter a ordena��o correta para todos os SGBD
    oFinR190Tb:AddIndex("1", aIndex)

Return Nil

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||Retorna os campos que estar�o presentes na tabela tempor�ria.                                ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

User Function F190Fields() As Array

    Local aFields   As Array
    Local aStruct   As Array

    aFields := {}
    aStruct := SE5->(DbStruct())
    AEval(aStruct, {|campo| campo[DBS_TYPE] <> "M", AAdd(aFields, AClone(campo)), Nil})

    AAdd(aFields, {"SE5RECNO", "N", 8, 0})
    AAdd(aFields, {"SE5MAXSEQ", GetSX3Cache("E5_SEQ", "X3_TIPO"), GetSX3Cache("E5_SEQ", "X3_TAMANHO"), GetSX3Cache("E5_SEQ", "X3_DECIMAL")})
    AAdd(aFields, {"SE5VA", GetSX3Cache("FK6_VALMOV", "X3_TIPO"), GetSX3Cache("FK6_VALMOV", "X3_TAMANHO"), GetSX3Cache("FK6_VALMOV", "X3_DECIMAL")})

    FwFreeArray(aStruct)

Return aFields

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||Fun��o para logar os erros de execu��o do TcSQLExec.                                         ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function FR190Log(cLogText As Character, cSQLControl As Character)

    Local cFunction As Character
    Local cLogFile  As Character
    Local cLogHead  As Character
    Local cPath     As Character
    Local cProcLine As Character
    Local cThreadID As Character

    Local lContinua As Logical

    Local nHandle   As Numeric

    lContinua := .T.
    cPath := "\SYSTEM\"
    cLogFile := cPath + "FR190Log" + AllTrim(cEmpAnt + cFilAnt) + "_" + DToS(Date()) + ".log"

    If !(File(cLogFile))
        nHandle := FCreate(cLogFile)
        If nHandle == -1
            lContinua := .F.
        Else
            cLogHead := STR0083 + DToC(Date()) + CRLF //"Log de incosist�ncias de execu��o dos comandos SQL do FINR190 em"
            FSeek(nHandle, 0, 2)    // Posiciona no final do arquivo.
            FWrite(nHandle, cLogHead, Len(cLogHead))
            FClose(nHandle)
        EndIf
    EndIf

    If lContinua
        cThreadID   := AllTrim(Str(ThreadID())) //Retorna o ID (n�mero de identifica��o) da thread em que a chamada da fun��o foi realizada
        cProcLine   := AllTrim(Str(ProcLine(1)))    //Retorna o n�mero da linha do c�digo fonte executado que fez a chamada da gera��o do LOG
        cFunction   := ProcName(1)                  //Retorna o nome da funcao em execu��o que fez a chamada da gera��o do LOG

        cFunction := " Function " + cFunction

        cLogText := Time() + " " + "[" + cThreadID + "]" + cFunction + " Line " + cProcLine + CRLF + Space(5) +  "[" + cSQLControl + "] " + cLogText + CRLF

        // Grava o texto no Arquivo de LOG
        nHandle := FOpen(cLogFile, 2)
        FSeek(nHandle, 0, 2)   // Posiciona no final do arquivo.
        FWrite(nHandle, cLogText, Len(cLogText))
        FClose(nHandle)
    EndIf

Return Nil

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||Efetua a montagem do comando SQL de exclus�o dos registros.                                  ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function DeleteChq(cSGBD As Character) As Character

    Local cDelete       As Character
    Local cSubSelect    As Character
    Local cTable        As Character
    
    Local lCheque       As Logical
    Local cTipoWhere    As Character

    Default cSGBD       := Upper(TCGetDB())

    cTable  := oFinR190Tb:GetRealName()

    lCheque     := MV_PAR37 == 1
    cDelete := " DELETE FROM " + cTable

    If lCheque
        cDelete += " WHERE (" + cTable + ".E5_TIPODOC = 'BA' OR " + cTable + ".E5_TIPODOC = 'VL')"
        cTipoWhere := "CH"
    Else
        cDelete += " WHERE " + cTable + ".E5_TIPODOC = 'CH' "
        cTipoWhere := "BA"
    EndIf

    cDelete += " AND (" + cTable + ".E5_BANCO <> ' ' OR " + cTable + ".E5_AGENCIA <> ' ' OR " + cTable + ".E5_CONTA <> ' ' OR " + cTable + ".E5_NUMCHEQ <> ' ')"
    cDelete += " AND EXISTS ( "

    cSubSelect := " SELECT 'MOVIMENTO' "
    cSubSelect += " FROM " + RetSQLName("SE5") + " SE5BA "
    cSubSelect += " WHERE SE5BA.E5_FILIAL   = " + cTable + ".E5_FILIAL "
    cSubSelect += "   AND SE5BA.E5_BANCO    = " + cTable + ".E5_BANCO "
    cSubSelect += "   AND SE5BA.E5_AGENCIA  = " + cTable + ".E5_AGENCIA "
    cSubSelect += "   AND SE5BA.E5_CONTA    = " + cTable + ".E5_CONTA "
    cSubSelect += "   AND SE5BA.E5_NUMCHEQ  = " + cTable + ".E5_NUMCHEQ "
    cSubSelect += "   AND SE5BA.E5_TIPODOC  = '" + cTipoWhere + "' "
    cSubSelect += "   AND SE5BA.D_E_L_E_T_  = ' ' "
    cSubSelect += ") "

    cDelete := cDelete + cSubSelect

Return cDelete

// *** Rotina acionada ap�s encontrar error nos comandos SQL executados. ***//
Static Function DbOnError(cSQLError As Character, cVariable As Character)

    EndReport()
    FR190Log(STR0082 + cSQLError, cVariable) //Ocorreu um problema na execu��o do comando SQL no seu banco de dados, avalie os detalhes:
    Help(" ", 1, "SGDBInfo",, STR0084, 2, 0,,,,,, {STR0085}) //Help: "Ocorreram inconsist�ncias na utiliza��o de comandos no banco de dados! Banco de dados n�o homologado" Solu��o: "Avalie o log de incosist�ncias gerado na pasta system."

Return Nil


// *** Encerra o alias tempor�rio, exclu� a tabela tempor�ria, libera o array de motivos de baixa da mem�ria e exclu� a tabela de filiais selecionadas. ***//
Static Function EndReport()

    DbSelectArea("NEWSE5")
    DbCloseArea()

    If oFinR190Tb != Nil
        oFinR190Tb:Delete()
        oFinR190Tb := Nil
    EndIf

    FwFreeArray(_aMotBaixa)

    If FindFunction("FinEraseTmpFil")
        FinEraseTmpFil()
    EndIf

    If cNomeArq # Nil
        FErase(cNomeArq + OrdBagExt())
    EndIf

Return Nil


// *** Zera valores do array quando movimento for do tipo VA. *** //
Static Function ZeraVA(aMovimento As Array)

    aMovimento[ID_PREFIXO]      := ""
    aMovimento[ID_NUMERO]       := ""
    aMovimento[ID_PARCELA]      := ""
    aMovimento[ID_TIPO]         := ""
    aMovimento[ID_CLIFOR]       := ""
    aMovimento[ID_NOMECLIFOR]   := ""
    aMovimento[ID_NATUREZA]     := ""
    aMovimento[ID_VENCIMENTO]   := ""
    aMovimento[ID_VALORORIG]    := 0
    aMovimento[ID_JUROSMULTA]   := 0
    aMovimento[ID_CORRECAO]     := 0
    aMovimento[ID_DESCONTO]     := 0
    aMovimento[ID_ABATIMENTO]   := 0
    aMovimento[ID_IMPOSTO]      := 0
    aMovimento[ID_BANCO]        := ""
    aMovimento[ID_DTDIGITACAO]  := ""
    aMovimento[ID_MOTIVO]       := ""
    aMovimento[ID_FILORIG]      := ""
    aMovimento[ID_VALORPG]      := 0

Return Nil
