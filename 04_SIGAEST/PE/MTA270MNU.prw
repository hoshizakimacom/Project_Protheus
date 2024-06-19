#INCLUDE "Protheus.ch"  
#INCLUDE "TopConn.ch"
#Include "TOTVS.ch"
#INCLUDE "Rwmake.ch"
//#INCLUDE "FIVEWIN.CH"
#Include "TBICONN.CH"

User Function MTA270MNU_XX()

aAdd(aRotina,{"Gera 1a Contagem"       ,"U_A270G1Ctg", 0 , 3,17	})
aAdd(aRotina,{"Sel Contagem por Status","U_A270Ctg"  , 0 , 3,17	})

Return (NIL)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A270Contag³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 09/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona contagem do inventario                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A270Contag(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A270Ctg(cAlias,nReg,nOpc)

Local aArea      := GetArea()
Local nOpca      := 1
//Local aOpcao   := {"S=Sim","N=Não"}
//Local oOpcao
Local aOpcao2  := {}
Local oOpcao2
Local oDocInv, oLocais, oClasses, oTolerA, oTolerB, oTolerC, oTolerD

Private oDlg1
Private cDocInv  := GetMv("AM_INVDOC")
Private cLocais  := Left(GetMv("AM_INVLOC")+Space(40),40)  //"01;03;08;35;36;50;51;53;58;60"
Private cClasses := Left(GetMv("AM_INVCLAS")+Space(10),10)  //A;B;C;D
Private nTolerA  := GetMv("AM_INVTOLA")
Private nTolerB  := GetMv("AM_INVTOLB")
Private nTolerC  := GetMv("AM_INVTOLC")
Private nTolerD  := GetMv("AM_INVTOLD")
Private dDataInv := mv_par05

//AM_INVLOC    // Locais de Inventário a Considerar - 01;03;08;35;36;50;51;53;58;60
//AM_INVCLAS   // CLasses de produtos a Considerar -  A;B;C;D
//AM_INV1CTG   // Habilita Geracao de primeira contagem com o saldo de estoque 
//AM_INVTOLA   // Tolerancia de divergencia classe A
//AM_INVTOLB   // Tolerancia de divergencia classe B
//AM_INVTOLC   // Tolerancia de divergencia classe C
//AM_INVTOLD   // Tolerancia de divergencia classe D
//AM_INVENDE   // Usa analise por endereço 

//If mv_par04 == 1 // Por produto
aRotina :={{"Seleciona","A270SelCon",0,4}}	 	//"Seleciona"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Venda Balcao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPreOpc  := 'Não'
cPreOpc2 := '1N - 1a CONT. PENDENTE / SEM CONTAGEM'

Aadd(aOpcao2,cPreOpc2)
Aadd(aOpcao2,'2S - 1a CONTAGEM OK - PROD. CLASSE `D` ')
Aadd(aOpcao2,'3S - CONTAG. 1a e 2a - OK')
Aadd(aOpcao2,'4S - CONTAG. 1a e 2a COM DIF - DENTRO TOLERANCIA')
Aadd(aOpcao2,'5S - CONTAG. 1a e 2a COM DIF - SELECIONADO')	
Aadd(aOpcao2,'6N - 3a CONTAGEM - PENDENTE')
Aadd(aOpcao2,'7S - 3a CONTAGEM - OK / ASSUMIDA')
Aadd(aOpcao2,'8N - ANALISAR')
Aadd(aOpcao2,'9N - TODOS')

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Seleção dos Status : ") FROM 200,001 TO 570,600 PIXEL //300,450 PIXEL

//@ 045,030 SAY OEMTOANSI("Somente a efetivar  : ") SIZE 100,07 OF oDlg PIXEL
//@ 045,090 MSCOMBOBOX oOpcao VAR cPreOpc ITEMS aOpcao SIZE 050,10 OF oDlg PIXEL

@ 050,015 SAY OemToAnsi("Seleção do Status : ") SIZE 100,07 OF oDlg PIXEL
@ 050,090 MSCOMBOBOX oOpcao2 VAR cPreOpc2 ITEMS aOpcao2 SIZE 200,10 OF oDlg PIXEL

@ 065,015 SAY OemToAnsi("Documento Inventário  : ") SIZE 100,07 OF oDlg PIXEL
@ 065,090 GET oDocInv VAR cDocInv  SIZE 40,10  OF oDlg PIXEL WHEN .F. 

@ 080,015 SAY OemToAnsi("Locais a Considerar : ") SIZE 100,07 OF oDlg PIXEL
@ 080,090 GET oLocais VAR cLocais  SIZE 120,10  OF oDlg PIXEL WHEN .F. 

@ 095,015 SAY OemToAnsi("Classes a Considerar :") SIZE 100,07 OF oDlg PIXEL
@ 095,090 GET oClasses VAR cClasses  SIZE 50,10  OF oDlg PIXEL  WHEN .F.

@ 110,015 SAY OemToAnsi("Tolerância Prod. Classe A :") SIZE 100,07 OF oDlg PIXEL
@ 110,090 GET oTolerA VAR nTolerA  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 125,015 SAY OemToAnsi("Tolerância Prod. Classe B :") SIZE 100,07 OF oDlg PIXEL
@ 125,090 GET oTolerB VAR nTolerB  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 140,015 SAY OemToAnsi("Tolerância Prod. Classe C :") SIZE 100,07 OF oDlg PIXEL
@ 140,090 GET oTolerC VAR nTolerC  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 155,015 SAY OemToAnsi("Tolerância Prod. Classe D :") SIZE 100,07 OF oDlg PIXEL
@ 155,090 GET oTolerD VAR nTolerD  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera o Pedido de Venda                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1
	Processa({|| U_A270Ctg2()} , "Aguarde... Carregando Dados")
Endif

// Restaura ambiente original
RestArea(aArea)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona Registros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A270Ctg2

Local oQtdRegs 
Local lUsaEnd := .F.  

If !lUsaEnd
	MsgStop("Análise por Endereço : Desabilitado ")
EndIf

// Executa Query
cQuery := " SELECT LOC, LOCALIZ, PRODUTO, CL, TIPO, UM,"
cQuery += " (CASE WHEN CL='D' AND TR=0 THEN 1 ELSE TR END) AS TR, "
cQuery += " QTD_MIN 'MIN', "
cQuery += " QTD_MAX 'MAX', "
cQuery += " DESCRICAO, " 
cQuery += " CONT_1, "
cQuery += " CONT_2, "
cQuery += " TR_1_2, " 
cQuery += " CONT_3, "

cQuery += " (CASE WHEN LEFT(XSTATUS,1) = '2' THEN '1' "

cQuery += " 	  WHEN LEFT(XSTATUS,1) IN ('3','4') THEN (CASE WHEN CONT_1  < CONT_2  THEN '1' ELSE '2' END) "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '5' THEN '2' "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '7' THEN '3' ELSE ' ' END) 'SELECT_C', "

cQuery += " (CASE WHEN LEFT(XSTATUS,1) = '2' THEN CONT_1 "
cQuery += " 	  WHEN LEFT(XSTATUS,1) IN ('3','4') THEN (CASE WHEN CONT_1  < CONT_2  THEN CONT_1 ELSE CONT_2 END) "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '5' THEN CONT_2  "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '7' THEN CONT_3 ELSE 0 END) 'SELECT_QTD', "

cQuery += " XSTATUS 'STATUS', XSTATUS, DOC, ESCOLHA, QTDREG, RECCONT1, RECCONT2, RECCONT3 "

cQuery += " FROM ( "
cQuery += " SELECT LOCAL LOC, LOC LOCALIZ, "
cQuery += " PRODUTO, "
cQuery += " CL, TIPO, UM, TR/100 AS TR,"

cQuery += " ROUND(CONT_1-((TR/100)*CONT_1),0) AS QTD_MIN,"
cQuery += " ROUND(CONT_1+((TR/100)*CONT_1),0) AS QTD_MAX,"
cQuery += " ROUND(CONT_2-((TR/100)*CONT_2),0) AS QTD_MIN2,"
cQuery += " ROUND(CONT_2+((TR/100)*CONT_2),0) AS QTD_MAX2,"

cQuery += " DESCRICAO, "
cQuery += " CONT_1 , "
cQuery += " CONT_2 , "
cQuery += " ISNULL((CASE WHEN CONT_1 = 0 Or CONT_2 = 0 THEN 0"
cQuery += " 	  WHEN CONT_1 > CONT_2 THEN (ROUND((CONT_2/CONT_1),2)-1)*(-1)"
cQuery += " 	  WHEN CONT_1 < CONT_2 THEN (ROUND((CONT_1/CONT_2),2)-1)*(-1)"
cQuery += " 	  END),0) TR_1_2,"
cQuery += " CONT_3 AS CONT_3,"
cQuery += " 	 	  (CASE WHEN ((CONT_1 <> 0 AND CONT_2 <> 0) OR QTDREG > 1 ) AND (CONT_1 <> CONT_2) AND ESCOLHA = 'S' THEN '5 - COUNT 1a and 2a Ok With difference - Select' "

cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (CONT_1 <> CONT_2) AND CONT_3 <> 0 THEN '7 - 3a Assumed' "
cQuery += " 	 	  WHEN CONT_1 = 0 AND QTDREG = 0 THEN '1 - 1a COUNT Pending' "
cQuery += " 	 	  WHEN QTDREG > 0 AND CONT_2 = 0 AND CL = 'D' THEN '2 - 1a COUNT OK - CLASS D' "
cQuery += " 	 	  WHEN (((CONT_1 = 0 AND QTDREG > 0) OR CONT_1 > 0) AND CONT_2 = 0 AND QTDREG < 2 ) THEN '1 - 2a COUNT Pending' "	
cQuery += " 	 	  WHEN ((CONT_1 <> 0 AND CONT_2 <> 0) OR QTDREG > 1 ) AND CONT_1 = CONT_2 THEN '3 - COUNT 1a and 2a Ok' "
cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (ABS((1-(CONT_1 / CONT_2))) < (TR/100)) THEN '4 - COUNT 1a and 2a Ok With difference - Toler' "
cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (CONT_1 <> CONT_2) AND CONT_3 = 0 AND ESCOLHA <> 'S' THEN '6 - 3a COUNT Pending' "
cQuery += " 	 	  WHEN QTDREG > 2 THEN '7 - 3a COUNT OK' "
cQuery += " 	 	  ELSE '8 - To analyze' END ) XSTATUS, "

cQuery += " 	  DOC,"
cQuery += " 	  ESCOLHA, QTDREG, "
cQuery += " RECCONT1,"
cQuery += " RECCONT2,"
cQuery += " RECCONT3"
cQuery += " FROM ("

cQuery += " SELECT LOC, PRODUTO, DESCRICAO, LOCAL, SUM(CONT_1) CONT_1, DOC, TR, CL, TIPO, UM, "
cQuery += " SUM(CONT_2) CONT_2,"
cQuery += " SUM(CONT_3) CONT_3,"
cQuery += " '  ' STATUS,"
cQuery += " MAX(ESCOLHA)  ESCOLHA,"
cQuery += " MAX(RECCONT1) RECCONT1,"
cQuery += " MAX(RECCONT2) RECCONT2,"
cQuery += " MAX(RECCONT3) RECCONT3,"
cQuery += " SUM(QTDREG) QTDREG"

cQuery += " FROM ("

cQuery += " SELECT "+If(lUsaEnd," B7_LOCALIZ  "," ' ' ")+" LOC, B7_COD PRODUTO, LEFT(B1_DESC,30) DESCRICAO, B7_LOCAL LOCAL, B7_DOC DOC, B7_QUANT CONT_1, "
cQuery += " 0 CONT_2, 0 CONT_3, "+If(lUsaEnd," B7_XENDERE "," ' ' ")+" ENDERECO, B1_XINVTOL TR, B1_XCLASIN CL, B7_ESCOLHA ESCOLHA, B1_TIPO TIPO, B1_UM UM, "
cQuery += " SB7.R_E_C_N_O_ RECCONT1, 0 RECCONT2, 0 RECCONT3, 1 QTDREG"

cQuery += " FROM "+RetSqlName("SB7")+" SB7, "+RetSqlName("SB1")+" SB1"
cQuery += " WHERE B7_FILIAL = '01'"
cQuery += " AND B7_DATA >= '"+Dtos(dDataInv)+"'"
cQuery += " AND SB7.D_E_L_E_T_ <> '*'"
cQuery += " AND (B7_CONTAGE = '001' OR B7_CONTAGE = '1')"
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND B1_COD = B7_COD"
cQuery += " AND B1_XCLASIN  IN " + FormatIn(cClasses, ";")
cQuery += " AND LEFT(B1_DESC,11) NOT IN ('MAO DE OBRA','MOD DE RATE')"
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"

cQuery += " UNION ALL"

cQuery += " SELECT "+If(lUsaEnd," B7_LOCALIZ  "," ' ' ")+" LOC,B7_COD PRODUTO, LEFT(B1_DESC,30) DESCRICAO, B7_LOCAL LOCAL, B7_DOC DOC, 0 CONT_1, "
cQuery += " B7_QUANT CONT_2, 0 CONT_3, "+If(lUsaEnd," B7_XENDERE "," ' ' ")+" ENDERECO,B1_XINVTOL TR, B1_XCLASIN CL, B7_ESCOLHA ESCOLHA, B1_TIPO TIPO, B1_UM UM, "
cQuery += " 0 RECCONT1, SB7.R_E_C_N_O_ RECCONT2, 0 RECCONT3, 1 QTDREG"
cQuery += " FROM "+RetSqlName("SB7")+" SB7, "+RetSqlName("SB1")+" SB1"
cQuery += " WHERE B7_FILIAL = '01'"
cQuery += " AND B7_DATA >= '"+Dtos(dDataInv)+"'"
cQuery += " AND SB7.D_E_L_E_T_ <> '*'"
cQuery += " AND (B7_CONTAGE = '002' OR B7_CONTAGE = '2')"
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND B1_COD = B7_COD"
cQuery += " AND B1_XCLASIN  IN " + FormatIn(cClasses, ";")
cQuery += " AND LEFT(B1_DESC,11) NOT IN ('MAO DE OBRA','MOD DE RATE')"
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"

cQuery += " UNION ALL"

cQuery += " SELECT "+If(lUsaEnd," B7_LOCALIZ  "," ' ' ")+" LOC,B7_COD PRODUTO, LEFT(B1_DESC,30) DESCRICAO, B7_LOCAL LOCAL, B7_DOC DOC, 0 CONT_1, 0 CONT_2, "
cQuery += " B7_QUANT CONT_3, "+If(lUsaEnd," B7_XENDERE "," ' ' ")+" ENDERECO, B1_XINVTOL TR, B1_XCLASIN CL, B7_ESCOLHA ESCOLHA, B1_TIPO TIPO, B1_UM UM, "
cQuery += " 0 RECCONT1, 0 RECCONT2, SB7.R_E_C_N_O_ RECCONT3, 1 QTDREG"
cQuery += " FROM "+RetSqlName("SB7")+" SB7, "+RetSqlName("SB1")+" SB1"
cQuery += " WHERE B7_FILIAL = '01'"
cQuery += " AND B7_DATA >= '"+Dtos(dDataInv)+"'"
cQuery += " AND SB7.D_E_L_E_T_ <> '*'"
cQuery += " AND (B7_CONTAGE = '003' OR B7_CONTAGE = '3')"
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND B1_COD = B7_COD"
cQuery += " AND B1_XCLASIN  IN " + FormatIn(cClasses, ";")
cQuery += " AND LEFT(B1_DESC,11) NOT IN ('MAO DE OBRA','MOD DE RATE')"
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"

cQuery += " UNION ALL "

cQuery += " SELECT '' LOC, B2_COD PRODUTO, LEFT(B1_DESC,30) DESCRICAO, B2_LOCAL LOCAL, '  ' DOC, 0 CONT_1, 0 CONT_2, 0 CONT_3, "
cQuery += " '  ' ENDERECO, B1_XINVTOL TR, B1_XCLASIN CL, B1_TIPO TIPO, B1_UM UM, ' ' ESCOLHA,"
cQuery += " 0 RECCONT1, 0 RECCONT2, 0 RECCONT3, 0 QTDREG "
cQuery += " FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1"
cQuery += " WHERE B2_FILIAL = 'XX'"  // Desabilitado SB2 para a efetivação
cQuery += " AND B2_QATU <> 0"
cQuery += " AND B2_LOCAL IN " + FormatIn(cLocais, ";")
cQuery += " AND SB2.D_E_L_E_T_ <> '*'"
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND B1_COD = B2_COD"
cQuery += " AND B1_XCLASIN  IN " + FormatIn(cClasses, ";")
cQuery += " AND LEFT(B1_DESC,11) NOT IN ('MAO DE OBRA','MOD DE RATE')"
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "

cQuery += " ) TAB "
cQuery += " GROUP BY LOC, PRODUTO, DESCRICAO, LOCAL,DOC,TR, CL, TIPO, UM "
cQuery += " ) TAB2 "
cQuery += " ) TAB3 "
cQuery += " ORDER BY PRODUTO, LOC "

TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())

nQtdRegs := 0
Acols:={}

While !Eof() 

	IncProc("Carregando Produtos")

	If  Left(cPreOpc2,1)  == "9" .Or. Left(cPreOpc2,1) == Left(XSTATUS,1)
		Aadd(Acols,{PRODUTO, DESCRICAO, LOCALIZ, TIPO, UM, CL, LOC, CONT_1, CONT_2, CONT_3, STATUS, SELECT_C, ESCOLHA, RECCONT1, RECCONT2, RECCONT3,.F.})
	EndIf

	nQtdRegs ++

	QUERY->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe Resumo de Revisoes utilizadas ou Criadas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta aHeader. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:={}

//Aadd(aHeader,{ "Seq"       , ""       , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Produto"    , "PRODUTO"   , "@!"            ,15 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Descricao"  , "DESCRICAO" , "@!"            ,20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Localiz "   , "LOCALIZ"   , "@!",08 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Tipo"       , "TP"        , "@!",02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Um"         , "UM"        , "@!",02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Classe"     , "CL"        , "@!",01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Local"      , "Local"     , "@!"            ,02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Contagem 1" , "CONT_1"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Contagem 2" , "CONT_2"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Contagem 3" , "CONT_3"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Status"     , "STATUS"    , "@!"            ,20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Cont.Selec.", "SELECT_C"  , "@!"            ,01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Escolha"    , "ESCOLHA"   , "@!"            ,01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Reg.Cont1"  , "RECCONT1"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Reg.Cont2"  , "RECCONT2"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Reg.Cont3"  , "RECCONT3"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
nUsado := 4

_nItem := 0

@ 150,1 TO 720	,1220 Dialog oDlg1 Title "Resumo dos Status"

//	@ 030,020 TO 115,210 Multiline Modify Delete Valid LineOk() Object oLinhas
@ 010,010 TO 255,600 Multiline Object oLinhas

@ 265,020 Say 'Quantidade :'  Of oDlg1 Pixel
@ 265,080 Get oQtdRegs Var nQtdRegs Size 50,010 Of oDlg1 Pixel WHEN .F.

//@ 215,470 BmpButton Type 1 Action Close(oDlg1)
@ 265,510 BmpButton Type 2 Action Close(oDlg1)

//@ 215,470 BmpButton Type 1 Action Close(oDlg1)
//If Left(cPreOpc,1) == "S"
	@ 265,570 BmpButton Type 1 Action A270Grava(Acols,cPreOpc2)  // Funcao GRava
//EndIf

Activate Dialog oDlg1 Centered

QUERY->(dbCloseArea())

//Close(oDlg1)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A270G1Ct ³ Autor ³ Marcos Rocha          ³ Data ³ 08/02/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera 1a contagem do inventario                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function A270G1Ctg(cAlias,nReg,nOpc)

Local aArea      := GetArea()
Local nOpca      := 1
Local oDocInv, oLocais, oClasses, oTolerA, oTolerB, oTolerC, oTolerD
Private oDlg1
Private cDocInv  := GetMv("AM_INVDOC")
Private cLocais  := Left(GetMv("AM_INVLOC")+Space(40),40)  //"01;03;08;35;36;50;51;53;58;60"
Private cClasses := Left(GetMv("AM_INVCLAS")+Space(10),10)  //A;B;C;D
Private nTolerA  := GetMv("AM_INVTOLA")
Private nTolerB  := GetMv("AM_INVTOLB")
Private nTolerC  := GetMv("AM_INVTOLC")
Private nTolerD  := GetMv("AM_INVTOLD")

If GetMv("AM_INV1CTG") == "N"
	MsgStop("Geração de Primeira Contagem com o saldo em estoque Desabilitada - Parâmetro "+AM_INV1CTG)
	Return
EndIf

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Gera Primeira Contagem : ") FROM 200,001 TO 530,600 PIXEL //300,450 PIXEL

@ 040,015 SAY OemToAnsi("Documento Inventário  : ") SIZE 100,07 OF oDlg PIXEL
@ 040,090 GET oDocInv VAR cDocInv  SIZE 40,10  OF oDlg PIXEL WHEN .F. 

@ 055,015 SAY OemToAnsi("Locais a Considerar : ") SIZE 100,07 OF oDlg PIXEL
@ 055,090 GET oLocais VAR cLocais  SIZE 120,10  OF oDlg PIXEL WHEN .T. 

@ 070,015 SAY OemToAnsi("Classes a Considerar :") SIZE 100,07 OF oDlg PIXEL
@ 070,090 GET oClasses VAR cClasses  SIZE 50,10  OF oDlg PIXEL  WHEN .T.

@ 085,015 SAY OemToAnsi("Tolerância Prod. Classe A :") SIZE 100,07 OF oDlg PIXEL
@ 085,090 GET oTolerA VAR nTolerA  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 100,015 SAY OemToAnsi("Tolerância Prod. Classe B :") SIZE 100,07 OF oDlg PIXEL
@ 100,090 GET oTolerB VAR nTolerB  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 115,015 SAY OemToAnsi("Tolerância Prod. Classe C :") SIZE 100,07 OF oDlg PIXEL
@ 115,090 GET oTolerC VAR nTolerC  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

@ 130,015 SAY OemToAnsi("Tolerância Prod. Classe D :") SIZE 100,07 OF oDlg PIXEL
@ 130,090 GET oTolerD VAR nTolerD  SIZE 20,10  OF oDlg PIXEL  WHEN .F.

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera o Pedido de Venda                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1
	Processa({|| U_A270Ger2()} , "Aguarde... Carregando Dados")
Endif

// Restaura ambiente original
RestArea(aArea)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera primaira contagem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A270Ger2()

Local oQtdRegs 

// Executa Query
cQuery := " SELECT LOC, LOCALIZ, PRODUTO, CL, TIPO, UM,"
cQuery += " (CASE WHEN CL='D' AND TR=0 THEN 1 ELSE TR END) AS TR, "
cQuery += " QTD_MIN 'MIN', "
cQuery += " QTD_MAX 'MAX', "
cQuery += " DESCRICAO, " 
cQuery += " CONT_1, "
cQuery += " CONT_2, "
cQuery += " TR_1_2, " 
cQuery += " CONT_3, "

cQuery += " (CASE WHEN LEFT(XSTATUS,1) = '2' THEN '1' "

cQuery += " 	  WHEN LEFT(XSTATUS,1) IN ('3','4') THEN (CASE WHEN CONT_1  < CONT_2  THEN '1' ELSE '2' END) "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '5' THEN '2' "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '7' THEN '3' ELSE ' ' END) 'SELECT_C', "

cQuery += " (CASE WHEN LEFT(XSTATUS,1) = '2' THEN CONT_1 "
cQuery += " 	  WHEN LEFT(XSTATUS,1) IN ('3','4') THEN (CASE WHEN CONT_1  < CONT_2  THEN CONT_1 ELSE CONT_2 END) "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '5' THEN CONT_2  "
cQuery += " 	  WHEN LEFT(XSTATUS,1) = '7' THEN CONT_3 ELSE 0 END) 'SELECT_QTD', "

cQuery += " XSTATUS 'STATUS', DOC, ESCOLHA, QTDREG, RECCONT1, RECCONT2, RECCONT3 "

cQuery += " FROM ( "
cQuery += " SELECT LOCAL LOC, LOC LOCALIZ, "
cQuery += " PRODUTO, "
cQuery += " CL, TIPO, UM, TR/100 AS TR,"

cQuery += " ROUND(CONT_1-((TR/100)*CONT_1),0) AS QTD_MIN,"
cQuery += " ROUND(CONT_1+((TR/100)*CONT_1),0) AS QTD_MAX,"

cQuery += " ROUND(CONT_2-((TR/100)*CONT_2),0) AS QTD_MIN2,"
cQuery += " ROUND(CONT_2+((TR/100)*CONT_2),0) AS QTD_MAX2,"

cQuery += " DESCRICAO, "
cQuery += " CONT_1 , "
cQuery += " CONT_2 , "
cQuery += " ISNULL((CASE WHEN CONT_1 = 0 Or CONT_2 = 0 THEN 0"
cQuery += " 	  WHEN CONT_1 > CONT_2 THEN (ROUND((CONT_2/CONT_1),2)-1)*(-1)"
cQuery += " 	  WHEN CONT_1 < CONT_2 THEN (ROUND((CONT_1/CONT_2),2)-1)*(-1)"
cQuery += " 	  END),0) TR_1_2,"
cQuery += " CONT_3 AS CONT_3,"

cQuery += " 	 	  (CASE WHEN ((CONT_1 <> 0 AND CONT_2 <> 0) OR QTDREG > 1 ) AND (CONT_1 <> CONT_2) AND ESCOLHA = 'S' THEN '5 - COUNT 1a and 2a Ok With difference - Select' "

cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (CONT_1 <> CONT_2) AND CONT_3 <> 0 THEN '7 - 3a Assumed' "
cQuery += " 	 	  WHEN CONT_1 = 0 AND QTDREG = 0 THEN '1 - 1a COUNT Pending' "
cQuery += " 	 	  WHEN QTDREG > 0 AND CONT_2 = 0 AND CL = 'D' THEN '2 - 1a COUNT OK - CLASS D' "
cQuery += " 	 	  WHEN (((CONT_1 = 0 AND QTDREG > 0) OR CONT_1 > 0) AND CONT_2 = 0 AND QTDREG < 2 ) THEN '1 - 2a COUNT Pending' "	
cQuery += " 	 	  WHEN ((CONT_1 <> 0 AND CONT_2 <> 0) OR QTDREG > 1 ) AND CONT_1 = CONT_2 THEN '3 - COUNT 1a and 2a Ok' "
cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (ABS((1-(CONT_1 / CONT_2))) < (TR/100)) THEN '4 - COUNT 1a and 2a Ok With difference - Toler' "
cQuery += " 	 	  WHEN (CONT_1 <> 0 AND CONT_2 <> 0) AND (CONT_1 <> CONT_2) AND CONT_3 = 0 AND ESCOLHA <> 'S' THEN '6 - 3a COUNT Pending' "
cQuery += " 	 	  WHEN QTDREG > 2 THEN '6 - 3a COUNT OK' "
cQuery += " 	 	  ELSE '7 - To analyze' END ) XSTATUS, "

cQuery += " 	  DOC,"
cQuery += " 	  ESCOLHA, QTDREG, "
cQuery += " RECCONT1,"
cQuery += " RECCONT2,"
cQuery += " RECCONT3"
cQuery += " FROM ("

cQuery += " SELECT LOC, PRODUTO, DESCRICAO, LOCAL, SUM(CONT_1) CONT_1, DOC, TR, CL, TIPO, UM, "
cQuery += " SUM(CONT_2) CONT_2,"
cQuery += " SUM(CONT_3) CONT_3,"
cQuery += " '  ' STATUS,"
cQuery += " MAX(ESCOLHA)  ESCOLHA,"
cQuery += " MAX(RECCONT1) RECCONT1,"
cQuery += " MAX(RECCONT2) RECCONT2,"
cQuery += " MAX(RECCONT3) RECCONT3,"
cQuery += " SUM(QTDREG) QTDREG"

cQuery += " FROM ("

cQuery += " SELECT '' LOC, B2_COD PRODUTO, LEFT(B1_DESC,30) DESCRICAO, B2_LOCAL LOCAL, '  ' DOC, B2_QATU CONT_1, 0 CONT_2, 0 CONT_3, "
cQuery += " '  ' ENDERECO, B1_XINVTOL TR, B1_XCLASIN CL, B1_TIPO TIPO, B1_UM UM, ' ' ESCOLHA,"
cQuery += " 0 RECCONT1, 0 RECCONT2, 0 RECCONT3, 0 QTDREG "
cQuery += " FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1"
cQuery += " WHERE B2_FILIAL = '"+xFilial("SB2")+"' "  // Desabilitado SB2 para a efetivação
cQuery += " AND B2_QATU <> 0"
cQuery += " AND B2_LOCAL IN " + FormatIn(cLocais, ";")
cQuery += " AND SB2.D_E_L_E_T_ <> '*'"
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND B1_COD = B2_COD"
cQuery += " AND B1_XCLASIN  IN " + FormatIn(cClasses, ";")
cQuery += " AND B1_TIPO IN ('BN','EM','ME','MI','MP','PA','PI','PP')"
cQuery += " AND LEFT(B1_DESC,11) NOT IN ('MAO DE OBRA','MOD DE RATE')"
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "

cQuery += " ) TAB "
//	cQuery += " WHERE PRODUTO = '1E09256-01R ' "

cQuery += " GROUP BY LOC, PRODUTO, DESCRICAO, LOCAL,DOC,TR, CL, TIPO, UM "
cQuery += " ) TAB2 "
cQuery += " ) TAB3 "
cQuery += " ORDER BY PRODUTO, LOC "

TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())

nQtdRegs := 0
Acols:={}

While !Eof() 

	IncProc("Carregando Produtos")

	Aadd(Acols,{PRODUTO, DESCRICAO, LOCALIZ, TIPO, UM, CL, LOC, CONT_1, CONT_2, CONT_3, STATUS, SELECT_C, ESCOLHA, RECCONT1, RECCONT2, RECCONT3,.F.})
	nQtdRegs ++

	QUERY->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe Resumo de Revisoes utilizadas ou Criadas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta aHeader. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:={}

//Aadd(aHeader,{ "Seq"       , ""       , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Produto"    , "PRODUTO"   , "@!"            ,15 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Descricao"  , "DESCRICAO" , "@!"            ,20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Localiz "   , "LOCALIZ"   , "@!",08 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Tipo"       , "TP"        , "@!",02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Um"         , "UM"        , "@!",02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Classe"     , "CL"        , "@!",01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Local"      , "Local"     , "@!"            ,02 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Contagem 1" , "CONT_1"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Contagem 2" , "CONT_2"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Contagem 3" , "CONT_3"    , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Status"     , "STATUS"    , "@!"            ,20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Cont.Selec.", "SELECT_C"  , "@!"            ,01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Escolha"    , "ESCOLHA"   , "@!"            ,01 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Reg.Cont1"  , "RECCONT1"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Reg.Cont2"  , "RECCONT2"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Reg.Cont3"  , "RECCONT3"  , "@E 999,999"    ,06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
nUsado := 4

_nItem := 0

@ 150,1 TO 720	,1220 Dialog oDlg1 Title "Gera Primeira Contagem"

//	@ 030,020 TO 115,210 Multiline Modify Delete Valid LineOk() Object oLinhas
@ 010,010 TO 255,600 Multiline Object oLinhas

@ 265,020 Say 'Quantidade :'  Of oDlg1 Pixel
@ 265,080 Get oQtdRegs Var nQtdRegs Size 50,010 Of oDlg1 Pixel WHEN .F.

@ 265,510 BmpButton Type 2 Action Close(oDlg1)

//If Left(cPreOpc,1) == "S"
	@ 265,570 BmpButton Type 1 Action A270Gera(Acols,cDocInv)  // Funcao GRava
//EndIf

Activate Dialog oDlg1 Centered

QUERY->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A270Grava  ³ Autor ³ Marcos Rocha          ³Data  ³20/12/23³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava a escolha no SB7                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270Grava(Acols,cPreOpc2)

Local aArea    := GetArea()
Local nProc

MsgStop("Gravaçâo da Escolha !")
//Aadd(Acols,{PRODUTO, DESCRICAO, LOC, CONT_1, CONT_2, CONT_3, STATUS,.F.,RECCONT1, RECCONT2, RECCONT3})

For nProc := 1 To Len(Acols)

	nRecSB7E  := 0
	nRecSB7N1 := 0
	nRecSB7N2 := 0 

	If Acols[nProc,12] == "1" .And. Acols[nProc,14] <> 0
		nRecSB7E  := Acols[nProc,14]   // Recno da Contagem Selecionada na Regra
		nRecSB7N1 := Acols[nProc,15]   // Recno da Contagem Selecionada na Regra
		nRecSB7N2 := Acols[nProc,16]   // Recno da Contagem Selecionada na Regra

	ElseIf Acols[nProc,12] == "2" .And. Acols[nProc,15] <> 0
		nRecSB7E := Acols[nProc,15]   // Recno da Contagem Selecionada na Regra
		nRecSB7N1 := Acols[nProc,14]   // Recno da Contagem Selecionada na Regra
		nRecSB7N2 := Acols[nProc,16]   // Recno da Contagem Selecionada na Regra

	ElseIf Acols[nProc,12] == "3" .And. Acols[nProc,16] <> 0
		nRecSB7E := Acols[nProc,16]   // Recno da Contagem Selecionada na Regra
		nRecSB7N1 := Acols[nProc,14]   // Recno da Contagem Selecionada na Regra
		nRecSB7N2 := Acols[nProc,15]   // Recno da Contagem Selecionada na Regra

	EndIf

	If nRecSB7E <> 0
		dbGoto(nRecSB7E)
		Reclock("SB7",.F.)
		SB7->B7_ESCOLHA := "S"
		SB7->(MsUnlock())
	EndIf

	If nRecSB7N1 <> 0
		dbGoto(nRecSB7N1)
		Reclock("SB7",.F.)
		SB7->B7_ESCOLHA := " "
		SB7->(MsUnlock())
	EndIf

	If nRecSB7N2 <> 0
		dbGoto(nRecSB7N2)
		Reclock("SB7",.F.)
		SB7->B7_ESCOLHA := " "
		SB7->(MsUnlock())
	EndIf


Next

Close(oDlg1)

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A270Grava  ³ Autor ³ Marcos Rocha          ³Data  ³20/12/23³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava a escolha no SB7                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270Gera(Acols,cDocInv)

Local aArea := GetArea()
Local nProc

MsgStop("Será gerada a primeira contagem conforme os registros demonstrados na tela. São saldos dos almoxarifados selecionados !")

dbSelectArea("SB7")
For nProc := 1 To Len(Acols)

	RecLock("SB7",.T.)
	SB7->B7_FILIAL  := xFilial("SB7")
	SB7->B7_COD     := Acols[nProc,1]
//	SB7->B7_XENDERE := aStruct[nProc,2]
	SB7->B7_QUANT   := Acols[nProc,8]
	SB7->B7_CONTAGE := "001"
	SB7->B7_LOCAL   := Acols[nProc,7]
	SB7->B7_DOC     := cDocInv
	SB7->B7_DATA    := dDataBase
	SB7->B7_TIPO    := Posicione("SB1",1,xFilial("SB1")+Acols[nProc,1],"B1_TIPO")
	SB7->B7_ORIGEM  := "MTA270MNU"
	SB7->B7_XCODUSR := SubStr(cUsuario,7,15)
	MsUnLock()
	//Aadd(Acols,{PRODUTO, DESCRICAO, LOCALIZ, TIPO, UM, CL, LOC, CONT_1, CONT_2, CONT_3, STATUS, SELECT_C, ESCOLHA, RECCONT1, RECCONT2, RECCONT3,.F.})

Next

MsgStop("Gravação Finalizada !")

RestArea(aArea)

Return

// Grava o FLAG de selecao apenas nos registros selecionados na MarkBrowse
/*/
SB7->(dbSeek(cFilSB7 + DtoS(mv_par05)))
While !SB7->(Eof()) .And. SB7->B7_FILIAL == cFilSB7 .And. DtoS(SB7->B7_DATA) == DtoS(mv_par05)

	If SB7->B7_OK == cMarca
		Reclock("SB7",.F.)
		SB7->B7_ESCOLHA := "S"
		SB7->(MsUnlock())
	Else
		Reclock("SB7",.F.)
		SB7->B7_OK      := Space(Len(B7_OK))
		SB7->B7_ESCOLHA := Space(Len(B7_ESCOLHA))
		SB7->(MsUnlock())
	EndIf
	SB7->(dbSkip())
EndDo

RestArea(aArea)

CloseBrowse()

Return
/*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A270VldPar  ³ Autor ³ Emerson Rony Oliveira ³Data  ³03/03/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validar os parametros (usando selecao por data/contagem)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A270VldPar()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270VldPar()
Local lRet := .T.

If lRet .And. Empty(DtoS(mv_par05))
	Help( ' ', 1, 'A270DTCONT' )
	lRet := .F.
EndIf

If lRet .And. Empty(mv_par06)
	Help( ' ', 1, 'A270CONTAG' )
	lRet := .F.
EndIf

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UsaContage³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 09/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia de campos para controle de contagem  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1:=UsaContage()                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 = Indica se utiliza controle de contagem ou nao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UsaContage()
Return (SuperGetMv('MV_CONTINV',.F.,.F.))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A270Mark  ³ Autor ³ Rodrigo A Sartorio   ³ Data ³09.08.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Controla marcacao para marcar somente um item por vez      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*/
Static Function A270Mark()
Local aAreaAnt	:= GetArea()
Local cMarca    := ThisMark()

//If !Empty(SB7->B7_CONTAGE)

	If IsMark("B7_OK",cMarca)
		Reclock("SB7",.F.)
		Replace OK With Space(Len(B7_OK))
		MsUnlock()
	Else
		Reclock("SB7",.F.)
		Replace OK With cMarca
		MsUnlock()
//		If mv_par04 == 1
//			MarcaSimil(cMarca)
//		EndIf
	EndIf
//EndIf
/*/

//RestArea(aAreaAnt)
//MarkBRefresh()
//Return .T.
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaSimilº Autor ³Rodrigo A Sartorio  ³ Data ³  09/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desmarca todos os itens diferentes do registro posicionado  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ MarcaSimil(ExpC1)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpC1 = marca                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA270                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MarcaSimil(cMarca)
Local cSeek      := B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE
Local nRecno     := Recno()
If dbSeek(cSeek,.F.)
	Do While !Eof() .And. cSeek == B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE
		If nRecno <> Recno() 
			Reclock('SB7',.F.)
			Replace B7_OK With Space(Len(B7_OK))
			MsUnlock()
		EndIf
		dbSkip()
	Enddo
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A27TudMk  ³ Autor ³ Rodrigo A Sartorio   ³ Data ³09.08.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Nao permite marcar tudo                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270TudMk()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A270SelCon  ³ Autor ³ Rodrigo de A. Sartorio³Data  ³09/08/04³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca contagem selecionada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A270SelCon(ExpC1,ExpN1,ExpN2,ExpC2,ExpL1)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±³          ³ ExpC2 = marca                                              ³±±
±±³          ³ ExpL1 = controle da marcacao (nao utiliz.)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270SelCon(cAlias,cCampo,nOpcE,cMarca,lInverte)

Local cSeek:= B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE
If dbSeek(cSeek,.F.)
	Do While !Eof() .And. cSeek == B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE
		Reclock('SB7',.F.)
		Replace B7_ESCOLHA With If(!Empty(B7_OK),"S",Space(Len(B7_ESCOLHA)))
		MsUnlock()
		dbSkip()
	Enddo
EndIf
CloseBrowse()

Return Nil
