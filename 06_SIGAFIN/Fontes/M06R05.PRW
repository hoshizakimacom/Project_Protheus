#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#include "Fileio.ch"
#Include "finr560.ch"

#DEFINE CRLF Chr(13) + Chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR560	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 26.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Movimento do Caixinha                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR560(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Sigafin                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M06R05()
Private oReport

If TRepInUse()
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	Return U_M06R05R3() // Executa versão anterior do fonte
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 26.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection11
Local oFilial //Gestão Corporativa
Local oSecFil //Gestão Corporativa

Local aDados := Array(9)

oReport := TReport():New("FINR560",STR0004,"FIR560",;
{|oReport| ReportPrint(oReport,aDados)},STR0001+STR0002+STR0003)

pergunte("FIR560",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                       ³
//³ mv_par01            // de caixinha                         ³
//³ mv_par02            // Ate caixinha                        ³
//³ mv_par03            // De data digitacao                   ³
//³ mv_par04            // Ate data digitacao                  ³
//³ mv_par05            // Mostra Movimento                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetLandscape(.T.)

oSection := TRSection():New(oReport,STR0011,{"SEU"},) //"Caixinha   "
oSection:SetTotalInLine(.F.)
TRCell():New(oSection,"EU_CAIXA","SEU",STR0011,,28,.F.,)  //"Caixinha   "

If FXMultSld() .Or. cPaisLoc == "PER"
	TRCell():New(oSection,"FIJ_SLDANT","FIJ","Saldo Anterior do Caixinha",,68,.F.,)  //definido por SetBlock
EndIf

oSection:SetHeaderSection(.F.)

oSection1 := TRSection():New(oSection,STR0004,{"SEU"},) //"Movimento do Caixinha"
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1 ,"TIPO"       ,      ,STR0028              , ,28 ,.F. ,{ || aDados[1] })  //"Descricao"
TRCell():New(oSection1 ,"EU_BENEF"   ,"SEU" ,STR0029              , ,   ,.F. ,{ || aDados[2] })  //"Usuario"
TRCell():New(oSection1 ,"EU_NRCOMP"  ,"SEU" ,STR0030              , ,   ,.F. ,{ || aDados[3] })  //"Comprovante"
TRCell():New(oSection1 ,"EU_NUM"     ,"SEU" ,STR0031+CRLF+STR0032 , ,   ,.F. ,{ || aDados[4] })  //"Nro. Interno"###"do Movimento"
TRCell():New(oSection1 ,"EU_NROADIA" ,"SEU" ,STR0033+CRLF+STR0034 , ,   ,.F. ,{ || aDados[5] })  //"Numero de"###"Adiant."
TRCell():New(oSection1 ,"EU_DTDIGIT" ,"SEU" ,STR0035+CRLF+STR0036 , ,   ,.F. ,{ || aDados[6] })  //"Data de"###"Digitacao"
TRCell():New(oSection1 ,"EU_VALOR"   ,"SEU" ,STR0037              , ,   ,.F. ,{ || aDados[7] })  //"Valor"
TRCell():New(oSection1 ,"EU_SLDADIA" ,"SEU" ,STR0038              , ,   ,.F. ,{ || aDados[8] })  //"Baixado"
oSection1:SetHeaderPage()

If FXMultSld() .Or. cPaisLoc == "PER"
	TRCell():New(oSection1,"EU_SLDCXA","FIJ","Sld. ",,,.F.,)
EndIf

//Gestão Corporativa - Início
oFilial := TRSection():New(oReport,"",{"SEI"})
TRCell():New(oFilial,"Filial",,,,TamSx3("EI_FILIAL")[1] + Len("Filial")) //"Filial : "
oFilial:SetHeaderSection(.F.)

oSecFil := TRSection():New(oReport,"SECFIL",{})
TRCell():New(oSecFil,"CODFIL" ,,"Codigo",/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)		//"Código"
TRCell():New(oSecFil,"EMPRESA",,"Empresa",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)		//"Empresa"
TRCell():New(oSecFil,"UNIDNEG",,"Unid.Negoc.",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)		//"Unidade de negócio"
TRCell():New(oSecFil,"NOMEFIL",,"Filial",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)		//"Filial"

oReport:SetUseGC(.F.)
//Gestão Corporativa - Fim

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³26/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,aDados)
Local oSection		:= oReport:Section(1)
Local oSection1	:= oReport:Section(1):Section(1)
Local cFilterUser	:= oReport:Section(1):GetAdvplExp("SEU")
Local cAliasQry1	:= GetNextAlias()
Local cQuery		:= ""
Local cCaixa		:= ""
Local cAdia,lSaldo:= .T.
Local lPrinted		:= .F.
Local titulo		:= STR0004 //"Movimento do Caixinha"
Local oTotValor
Local oSldDia
Local oBreak2
Local oTotCx
Local cAdto		:= ""
Local lProcAlc		:= SuperGetMV("MV_FINCTAL", .T., "1") == "2"
Local cWhere		:= ""

//Gestão Corporativa - Início
Local aAreaSEU := SEU->(GetArea())
Local aAreaSET := SET->(GetArea())
Local aAreaSM0 := SM0->(GetArea())
Local aAreaORI := GetArea()
Local oFilial		:= oReport:Section(2)
Local aTmpFil	:= {}
Local cTmpSEUFil := ""
Local cRngFilSEU := NIL
Local lGestao   := ( FWSizeFilial() > 2 )
Local lSEUExcl  := Iif( lGestao, FWModeAccess("SEU",1) == "E", FWModeAccess("SEU",3) == "E")
Local cSEUFil  := FWModeAccess("SEU",3)
Local cSEUUN   := FWModeAccess("SEU",2)
Local cSEUEmp  := FWModeAccess("SEU",1)
Local nX 		:= 1
Local nC := 1
Local oSecFil	:= oReport:Section("SECFIL")
Local nRegSM0	:= SM0->(Recno())
Local aSelFil := {}
Local cUNold := ""
Local cEmpOld := ""
Local cFilialAnt := cFilAnt
Local cDtini	:= Dtos(mv_par03)
Local cDtfim	:= Dtos(mv_par04)
Local lPrtFil := .T.
//Gestão Corporativa - Fim

Private nSaldo		:= 0
Private nSldAdia  := 0
Private nSaldoTot	:= 0
Private nSaldoCxa	:= 0
Private cSeqCxa   := ""
Private nSalAbat	 := 0
Private _lSemlibc := .F. //Registro sem Liberacao e Cancelado
//Caso selecione Pend Prest Contas exibe coluna adicional
If MV_PAR05 == 2
	TRCell():New(oSection1 ,"EU_SLDADIA" ,"SEU" , , , ,.F. ,{ || aDados[9] })  //"Saldo Antecipo"
EndIf

//Gestão Corporativa - Início

nRegSM0 := SM0->(Recno())

If (lSEUExcl .and. mv_par06 == 1)
	If !IsBlind()	//controle via job
		aSelFil := FwSelectGC()
	EndIf	
Endif

If Empty(aSelFil)
	aSelFil := {cFilAnt}
Endif

SM0->(DbGoTo(nRegSM0))

If Len(aSelFil) > 1
	cRngFilSEU := GetRngFil( aSelFil, "SEU", .T., @cTmpSEUFil )
	aAdd(aTmpFil, cTmpSEUFil)
	oSection1:SetHeaderSection(.F.)
	aSM0 := FWLoadSM0()
	nTamEmp := Len(FWSM0LayOut(,1))
	nTamUnNeg := Len(FWSM0LayOut(,2))
	cTitulo := oReport:Title()
	oReport:SetTitle(cTitulo + " (" + "Filial" +  ")")	//"Filiais selecionadas para o relatorio"
	nTamTit := Len(oReport:Title())
	oSecFil:Init()
	oSecFil:Cell("CODFIL"):SetBlock({||cFilSel})
	oSecFil:Cell("EMPRESA"):SetBlock({||aSM0[nLinha,SM0_DESCEMP]})
	oSecFil:Cell("UNIDNEG"):SetBlock({||aSM0[nLinha,SM0_DESCUN]})
	oSecFil:Cell("NOMEFIL"):SetBlock({||aSM0[nLinha,SM0_NOMRED]})
	For nX := 1 To Len(aSelFil)
		nLinha := Ascan(aSM0,{|sm0|,sm0[SM0_CODFIL] == aSelFil[nX]})
		If nLinha > 0
			cFilSel := Substr(aSM0[nLinha,SM0_CODFIL],1,nTamEmp)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + 1,nTamUnNeg)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + nTamUnNeg + 1)
			oSecFil:PrintLine()
		Endif
	Next
	oReport:SetTitle(cTitulo)
	oSecFil:Finish()
	oReport:EndPage()
	RestArea(aAreaSM0)
	cFilSEU := " EU_FILIAL "+ cRngFilSEU + " AND "
Else
	cFilSEU := " EU_FILIAL = '"+ xFilial("SEU",aSelFil[1]) + "' AND "
Endif
cFilSEU := "%"+cFilSEU+"%"
oSection1:SetHeaderSection(.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_PAR05 - Mostra movimento³
//³	1 - Adiantamento          ³
//³	2 - Prestacao de contas   ³
//³	3 - Gastos                ³
//³	4 - Todos                 ³
//³EU_TIPO                    ³
//³ 00=Despesa                ³
//³ 01=Adiantamento           ³
//³ 02=Dev.Adiantamento       ³
//³ 03=Complemento adiantam   ³
//³ 10=Mov.Banco/Caixinha     ³
//³ 11=Mov.Caixinha/Banco     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Incrementa a clausula WHERE de acordo com os parametros
Do Case
	Case MV_PAR05 == 1 //Adiantamento
		cWhere	+= " AND EU_TIPO = '01' "
	Case MV_PAR05 == 2 //Pend. Prestacao de contas
		cWhere	+= " AND EU_TIPO = '00' AND EU_NROADIA != ''"
	Case MV_PAR05 == 3 //Gastos
		cWhere	+= " AND EU_TIPO IN ('00','02') "
	Case MV_PAR05 == 4 //Todos (Exceto tipo = 02)
		cWhere	+= " AND EU_TIPO <> '02' "
EndCase

cWhere	+= If(lProcAlc," AND EU_STATUS <> '01' AND EU_STATUS <> '02' AND EU_STATUS <> '04' ","")
cWhere	:= "%" + cWhere + "%"

cQuery += SqlOrder(SEU->(IndexKey(4)))	//EU_FILIAL + EU_CAIXA + DTOS(EU_DTDIGIT) + EU_NUM
cQuery := "%" + cQuery + "%"

BeginSQL Alias cAliasQry1
	COLUMN EU_DTDIGIT AS DATE
	SELECT *
	FROM %table:SEU% SEU
	WHERE %exp:cFilSEU%
	EU_CAIXA BETWEEN %exp:mv_par01% AND %exp:mv_par02% AND
	EU_DTDIGIT BETWEEN %exp:cDtini% AND %exp:cDtfim% AND
	SEU.%NotDel%
	%Exp:cWhere%
	ORDER BY %Exp:cQuery%
EndSQL

oSection:Cell("EU_CAIXA"):SetBlock({|| STR0011 + (cAliasQry1)->EU_CAIXA + " - " + SET->ET_NOME } )

If FXMultSld() .Or. cPaisLoc == "PER"
	oSection:Cell("FIJ_SLDANT"):SetBlock({|| STR0039 + ": " + Transform( getSldAnt( (cAliasQry1)->EU_FILIAL, (cAliasQry1)->EU_CAIXA, MV_PAR03 ), "@e 9,999,999.99" ) } )
EndIf

oBreak1 := TRBreak():New( oSection,{|| (cAliasQry1)->(EU_CAIXA)},"",.F.)
oTotValor := TRFunction():New(oSection1:Cell("EU_VALOR"),/*CNAME*/,"SUM",oBreak1,STR0013,PesqPict("SEU","EU_VALOR",16)/*CPICTURE*/,/*UFORMULA*/,.F.,.F.,.F.,oSection1,{|| Iif(cPaisLoc $ "ARG|COS",!(cAliasQry1)->(EU_TIPO) $ "91|92",.T.) },.T.,/*BCANPRINT*/) //"Saldo dos Movimentos do Caixinha"
TRFunction():New(oSection1:Cell("EU_VALOR"),/*CNAME*/,"ONPRINT",oBreak1,STR0013,PesqPict("SEU","EU_VALOR",16)/*CPICTURE*/,{|| oTotValor:GetValue() + nSldAdia - nSalAbat},.F.,.F.,.F.,oSection1,/*BCONDITION*/,/*LDISABLE*/,/*BCANPRINT*/) //"Saldo dos Movimentos do Caixinha"

If FXMultSld() .Or. cPaisLoc == "PER"
	oBreak2 := TRBreak():New( oSection,{|| (cAliasQry1)->(EU_CAIXA)},"",.F.)
	oBreak2:SetTitle( STR0040 )
	oTotCx := TRFunction():New(oSection1:Cell("EU_VALOR"),/*CNAME*/,"SUM",oBreak2,STR0040,PesqPict("SEU","EU_VALOR",16)/*CPICTURE*/,/*UFORMULA*/,.F.,.F.,.F.,oSection1,/*BCONDITION*/,.T.,/*BCANPRINT*/) //"Saldo dos Movimentos do Caixinha"
	TRFunction():New(oSection1:Cell("EU_VALOR"),/*CNAME*/,"ONPRINT",oBreak2,STR0040,PesqPict("SEU","EU_VALOR",16)/*CPICTURE*/,{|| /*oTotCx:GetValue()*/ nSaldoCxa},.F.,.F.,.F.,oSection1,/*BCONDITION*/,/*LDISABLE*/,/*BCANPRINT*/) //"Saldo dos Movimentos do Caixinha" 
EndIf

(cAliasQry1)->(dbGoTop())

If MV_PAR05 == 3 //Gastos
	oSection1:SetTotalText(STR0014) //"Total Despesas -->"
	oBreak1:SetTitle(STR0014) //"Total Despesas -->"
Else
	oSection1:SetTotalText(STR0013) //"Saldo dos Movimentos do Caixinha->"
	oBreak1:SetTitle(STR0013) //"Saldo dos Movimentos do Caixinha->"
EndIf

If Len(aSelFil) > 1
	aSort(aSelFil)
	cFilAnt := aSelFil[nC]
	cUN  := FWUnitBusiness()
	cEmp := FWCodEmp()
	cUNold := cUN
	cEmpOld := cEmp
EndIf

For nC := 1 To Len(aSelFil) Step 1

	If aSelFil[nC] <> cFilAnt .And. mv_par06 == 1

		If cSEUEmp == "E" .And. cSEUUN == "E" .And. cSEUFil == "C" .And. mv_par06 == 1
			While cUN == cUNold
				nC += 1
				If nC > Len(aSelFil)
					cUN := ""
				Else
					cFilAnt := aSelFil[nC]
					cUN := FWUnitBusiness()
				EndIf
			EndDo

			If nC > Len(aSelFil)
				Loop
			EndIf 
		EndIf

		If cSEUEmp == "E" .And. cSEUUN == "C" .And. cSEUFil == "C" .And. mv_par06 == 1
			While cEmp == cEmpOld
				nC += 1
				If nC > Len(aSelFil)
					cEmp := ""
				Else
					cFilAnt := aSelFil[nC]
					cEmp := FWCodEmp()
				EndIf
			EndDo

			If nC > Len(aSelFil)
				Loop
			EndIf 
		EndIf

		If cSEUEmp == "C" .And. cSEUUN == "C" .And. cSEUFil == "C" .And. mv_par06 == 1
			nC := Len(aSelFil) + 1
			Loop
		EndIf

		cFilAnt := aSelFil[nC]
		cUN  := FWUnitBusiness()
		cEmp := FWCodEmp()
		cUNold := cUN
		cEmpOld := cEmp

		SEU->(dbSeek(xFilial("SEU")))

		If SEU->(EOF())
			Loop
		Else
			lPrtFil := .T.
		EndIf
	EndIf

	While (cAliasQry1)->(!EOF()) .And. (cAliasQry1)->EU_FILIAL == xFilial("SEU")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cAliasQry1)		
		If !Empty(cFilterUser).and.!(&cFilterUser)
			(cAliasQry1)->(dbSkip())
			Loop
		Endif

		If cCaixa <> (cAliasQry1)->EU_CAIXA
			cSeqCxa := Fa570SeqAtu( (cAliasQry1)->EU_CAIXA )
		EndIf

	 	If cCaixa <> (cAliasQry1)->EU_CAIXA .And. MV_PAR05 <> 3
			If !lSaldo
				nSaldoTot	+= nSaldo
				nSaldo		:= 0
				lSaldo		:= .T.
				lPrinted	:= .F.
			Endif
			If FXMultSld() .Or. cPaisLoc == "PER"
				nSaldoCxa	:= getSldDia((cAliasQry1)->EU_FILIAL /*cFilCx*/, cCaixa/*(cAliasQry1)->EU_CAIXA*/, MV_PAR04 )
			EndIf
		Endif
		//No caso de impressao de adiantamentos em aberto nao imprime os outros movimentos.
		If MV_PAR05 == 1 .And. !(cAliasQry1)->(Empty(EU_NROADIA)) .and. (cAliasQry1)->EU_TIPO <> "02"
			aArea	:=	(cAliasQry1)->(GetArea())
			SEU->(DbSetOrder(3))
			SEU->(DbSeek(xFilial()+(cAliasQry1)->EU_NROADIA))
			If SEU->EU_SLDADIA > 0 .Or. (cAliasQry1)->EU_TIPO == "00"
				RestArea(aArea)
				(cAliasQry1)->(DbSkip())
				Loop
			Endif
			RestArea(aArea)
		Endif

		If !lPrinted
			//Gestão Corporativa - Início
			If lPrtFil
				If mv_par06 == 1
					oReport:SkipLine()
					oFilial:Init()
					oFilial:Cell("Filial"):SetBlock({|| "Filial" + xFilial("SEU")}) //"Filial : "
					oFilial:PrintLine()
					oFilial:Finish()
					oReport:SkipLine()
				EndIf
				lPrtFil := .F.
				nFilCx := cFilAnt
			EndIf
			//Gestão Corporativa - Fim
			oSection:Init()
			oSection1:Init()
			SET->(DbSetOrder(1))
			SET->(DbSeek(xFilial() + (cAliasQry1)->EU_CAIXA))
			oSection:PrintLine()
			cCaixa := (cAliasQry1)->EU_CAIXA
			lPrinted := .T.
			nSldAdia := 0
		Endif

		lSaldo := .F.
		SEU->(DbSetOrder(1))
		SEU->(DbSeek(xFilial()+ (cAliasQry1)->EU_NUM))

		If (cAliasQry1)->EU_DTDIGIT >= mv_par03 .and. (cAliasQry1)->EU_DTDIGIT <= mv_par04
			If (cAliasQry1)->EU_TIPO <> "02"
				IIf(MV_PAR05 == 2, aDados[9] := SEU->EU_SLDADIA, Nil) //Se for exibir as Pend Prest Contas mostra o saldo pendente
				F560PrintR4(0,Titulo,.T.,cAliasQry1,@aDados)
				If (mv_par05 == 1 .OR. mv_par05 == 4).And. (cAliasQry1)->EU_TIPO $ "01"
					If (cAliasQry1)->(EU_VALOR-EU_SLDADIA) > 0
						aDados[8] := (cAliasQry1)->(EU_VALOR-EU_SLDADIA)  // imprime o valor do adiantamento que já foi devolvido
					EndIf
					If (cAliasQry1)->EU_VALOR <> (cAliasQry1)->EU_SLDADIA .AND. mv_par05 == 4
					nSldAdia  += (cAliasQry1)->(EU_VALOR-EU_SLDADIA)   // soma o que ja foi devolvido para compor o saldo corretamente
					EndIf
				EndIf
				oSection1:PrintLine()
				aFill(aDados, nil)
			Else
			 If MV_PAR05 == 3 //.And. ((cAliasQry1)->EU_TIPO == "00" .OR.  (cAliasQry1)->EU_TIPO == "02")
		 	    F560PrintR4(0,Titulo,.T.,cAliasQry1,@aDados)
		 	 Endif
				aArea:=GetArea()
				SEU->(DbSetOrder(1))
				If (cAliasQry1)->EU_TIPO $ "00|02" //.OR.  (cAliasQry1)->EU_TIPO == "02")//SEU->(DbSeek(xFilial()+ (cAliasQry1)->EU_NROADIA)) .And. SEU->EU_TIPO =="00"
					RestArea(aArea)
					F560PrintR4(0,Titulo,.T.,cAliasQry1,@aDados)
					oSection1:PrintLine()
					aFill(aDados, nil)
				Else
					RestArea(aArea)
				EndIf
			EndIf

			If (mv_par05 == 1 .Or. mv_par05 == 2)  .And. (cAliasQry1)->EU_TIPO $ "01|03"
				If (cAliasQry1)->EU_VALOR <> (cAliasQry1)->EU_SLDADIA
					aFill(aDados, nil)
					aDados[1] := "  " + STR0012 //"Detalhes do Adiantamento"
					oSection1:PrintLine()
					aFill(aDados, nil)
					aArea	:=	GetArea()
					SEU->(DbSetOrder(3))
					cAdia	:=	(cAliasQry1)->EU_NUM
					SEU->(DbSeek(xFilial()+cAdia))
					cAdto	:= SEU->EU_NROADIA
					While !SEU->(EOF()) .And. xFilial("SEU") == SEU->EU_FILIAL .And. SEU->EU_NROADIA == cAdia
						F560PrintR4(4,Titulo,.F.,"SEU",@aDados)
						oSection1:PrintLine()
						aFill(aDados, nil)
						SEU->(DbSkip())
					Enddo
					RestArea(aArea)
			   	Endif
			Endif
		EndIf

		(cAliasQry1)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		If cCaixa <> (cAliasQry1)->EU_CAIXA .And. !lSaldo
			nSaldoTot	+= nSaldo - nSalAbat 
			nSaldo		:= 0
			nSalAbat   := 0
			lSaldo		:= .T.
			lPrinted	:= .F.
			If (cAliasQry1)->(EOF()) .Or. (cAliasQry1)->EU_FILIAL != xFilial("SEU")
				If Empty(cCaixa)
					cCaixa := (cAliasQry1)->EU_CAIXA 	
				Endif			
				nSaldoCxa	:= getSldDia( xFilial("SEU",aSelFil[nC]) /*cFilCx*/, cCaixa/*(cAliasQry1)->EU_CAIXA*/, MV_PAR04 )
			EndIf
			oSection1:Finish()
		Endif
	EndDo

	If !lSaldo
		nSaldoTot	+=	nSaldo
	Endif

	oSection:Finish()
	oSection1:Finish()
Next

cFilAnt := cFilialAnt //Gestão Corporativa

//Gestão Corporativa - Início

For nX := 1 TO Len(aTmpFil)
	CtbTmpErase(aTmpFil[nX])
Next


RestArea(aAreaSEU)
RestArea(aAreaSET)
RestArea(aAreaORI)
//Gestão Corporativa - Fim

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³F560PrintR4º Autor ³ Bruno Sobieski     º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime um item.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F560PrintR4(nDesp,Titulo,lEst,cAliasQry1,aDados)
Local cTipo := ""
Local nVlRep:= 0

Do Case
	Case (cAliasQry1)->EU_TIPO == "00"
		cTipo := IIf(Empty((cAliasQry1)->EU_HISTOR),STR0016,(cAliasQry1)->EU_HISTOR) //"Gasto"

	Case (cAliasQry1)->EU_TIPO == "01"
		cTipo := IIf(Empty((cAliasQry1)->EU_HISTOR),STR0017,STR0018+ Substr((cAliasQry1)->EU_HISTOR,1,20)) //"Anticipo"###"Ant. "

	Case (cAliasQry1)->EU_TIPO == "02"
		cTipo := If(lEst,STR0027,STR0019) //"Estorno de Despesa"###"Dev. Anticipo"

	Case (cAliasQry1)->EU_TIPO == "10"
		cTipo := STR0020 //"Reposicion"

	Case (cAliasQry1)->EU_TIPO == "11"
		cTipo := IIf(Empty((cAliasQry1)->EU_HISTOR),STR0021,(cAliasQry1)->EU_HISTOR) //"Transf. por cierre"

	Case (cAliasQry1)->EU_TIPO == "12"
		cTipo := IIf(Empty((cAliasQry1)->EU_HISTOR),STR0022,(cAliasQry1)->EU_HISTOR) //"Dev. por cierre Caja Menor"

	Case (cAliasQry1)->EU_TIPO == "13"
		cTipo := IIf(Empty((cAliasQry1)->EU_HISTOR),STR0023,(cAliasQry1)->EU_HISTOR) //"Repos. Caja Menor"

	Case (cAliasQry1)->EU_TIPO == "90"
		cTipo := STR0024 //"Reposicao cancelada"

	Case (cAliasQry1)->EU_TIPO == "91"
		cTipo := STR0025 //"Aguardando autorizacao para reposicao"

	Case (cAliasQry1)->EU_TIPO == "92"
		cTipo := STR0026 //"Aguardando debito do titulo para reposicao"

	Case (cAliasQry1)->EU_TIPO == "03"
		cTipo := (cAliasQry1)->EU_HISTOR
Endcase
//If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
//	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//	nLin := 9
//Endif

aDados[1] := Space(nDesp) + cTipo
//@nLin,000+nDesp	PSAY	cTipo

If (cAliasQry1)->EU_TIPO < "90"
	aDados[2] := (cAliasQry1)->EU_BENEF
	//@nLin,029			PSAY	Substr(EU_BENEF,1,19)
Endif

aDados[3] := (cAliasQry1)->EU_NRCOMP
aDados[4] := (cAliasQry1)->EU_NUM
aDados[5] := (cAliasQry1)->EU_NROADIA
aDados[6] := (cAliasQry1)->EU_DTDIGIT
/*
@nLin,049			PSAY	EU_NRCOMP 	PICTURE PesqPict("SEU","EU_NRCOMP")
@nLin,062			PSAY	EU_NUM		PICTURE PesqPict("SEU","EU_NUM")
@nLin,076			PSAY	EU_NROADIA	PICTURE PesqPict("SEU","EU_NROADIA")
@nLin,088			PSAY	DTOC(EU_DTDIGIT)
*/
If (cAliasQry1)->EU_TIPO < "90"
	nSigno	:=	IIf(MV_PAR05 == 3 .Or. !((cAliasQry1)->EU_TIPO $ "00|01|03|11|13"),1,-1)

	//If (!Empty((cAliasQry1)->EU_NROADIA) .and. mv_par06 == 2  .And. (cAliasQry1)->EU_TIPO == "02") .Or. (cAliasQry1)->EU_TIPO == "12"
	//	nSigno	:=  -1
		//nSalAbat += (cAliasQry1)->EU_VALOR
	//EndIf

	If cSeqCxa == (cAliasQry1)->EU_SEQCXA .And. (cAliasQry1)->EU_TIPO == "10"
		nVlRep := (cAliasQry1)->EU_VALOR * nSigno
		aDados[7] := nVlRep
		If (nVlRep+SET->ET_SALANT) > SET->ET_VALOR
			nSaldo	  := nvlRep
			nSldAdia  := 0
		Else
	 		nSaldo	  += nvlRep
		EndIf
	Else
		If nDesp == 0
			If MV_PAR05 <> 3	
				aDados[7] := (cAliasQry1)->EU_VALOR *  Iif(SEU->EU_TIPO $ "02" .And. nSigno < 1, 1, nSigno)
			Else 
				aDados[7] := (cAliasQry1)->EU_VALOR * nSigno
			EndIf 
			//@nLin,098			PSAY	(EU_VALOR*nSigno)	PICTURE PesqPict("SEU","EU_VALOR",16)
		ElseIf  (cAliasQry1)->EU_TIPO == "03" //Devolucao de adiantamento
			aDados[7] := (cAliasQry1)->EU_VALOR * nSigno
		Else
			If (cAliasQry1)->EU_TIPO == "02" //Devolucao de adiantamento
				aDados[7] := (cAliasQry1)->EU_VALOR
				//@nLin,098		PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
			Endif
			aDados[8] := (cAliasQry1)->EU_VALOR
			//@nLin,116			PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
		Endif
   		If nDesp == 0 .Or. (cAliasQry1)->EU_TIPO $ "02|03"
   			If MV_PAR05 <> 3
   				nSigno := Iif(SEU->EU_TIPO $ "02|03" .And. nSigno < 1, 1, nSigno) //devoluç no caixinha 
   			EndIf 
			nSaldo		+=	((cAliasQry1)->EU_VALOR * nSigno)
		Endif
	EndIf
ElseIf (cAliasQry1)->EU_TIPO>"90"
	aDados[7] := (cAliasQry1)->EU_VALOR
	//@nLin,098			PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
Endif

Return

/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR560R3³ Autor ³ Bruno Sobieski 		  ³ Data ³ 02.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Movimento do Caixinha			 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR560R3(void)														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Sigafin  																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M06R05R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         	:= STR0001 //"Este programa tiene como objetivo imprimir un "
Local cDesc2         	:= STR0002 //"informe de movimientos de Caja Chica de acuerdo con"
Local cDesc3         	:= STR0003 //"los parametros informados por el usuario."
Local titulo       	:= STR0004 //"Movimiento de caja chica"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""

Private lEnd         	:= .F.
Private lAbortPrint   := .F.
Private limite        := 132
Private tamanho       := "M"
Private nomeprog      := "FINR560" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo         := 18
Private aReturn       := { STR0005, 1, STR0006, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey      := 0
Private cPerg       	:= "FIR560"
Private CONTFL     	:= 1
Private m_pag      	:= 1
Private wnrel      	:= "FINR560" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SEU"
Private cSeqCxa     	:= ""

dbSelectArea("SEU")
dbSetOrder(4)

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
//          10        20        30        40        50        60        70        80        90        100       110
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
Cabec1       	:= STR0007+IIf(mv_par05==1,STR0008,"") //"Descripcion                     Usuario          Comprobante  Nro. Interno  Numero de   Fecha de             Valor"###"           Rendido"
Cabec2       	:= STR0009       //"                                                              de Movimiento Anticipo    Tipeo                          "

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Bruno Sobieski     º Data ³  02/07/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cAdia,lSaldo	:=	.T.
Local aArea
Local cFil				:=	""
Local cCaixa			:=	""
Local lPrinted 		:=	.F.
Local cbtxt	      	:= Space(10)
Local cbcont	     	:= 1
Local nSalAbat 		:= 0
Local cFilterUser 	:= aReturn[7]
Local cAdto			:= ""
Local lMSaldo 			:= .T.
Local lImpress		:= .T.

Private nSaldo			:=	0
Private nSaldoTot		:= 0

dbSelectArea("SEU")
dbSetOrder(4)
SetRegua(RecCount())

DbSeek(xFilial()+mv_par01+DTOS(mv_par03),.T.)

While !EOF() .And.xFilial() == EU_FILIAL .And. EU_CAIXA <= MV_PAR02
	
	lImpress := .T.
	
	IncRegua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lAbortPrint
		@nLin,00 PSAY STR0010 //"*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If cCaixa <> EU_CAIXA
		aArea:=GetArea()
		cSeqCxa := Fa570SeqAtu( EU_CAIXA )
		RestArea(aArea)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		SEU->(dbSkip())
		Loop
	Endif

	If mv_par05 = 2 .And. EU_TIPO ==	"01"
		DbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso seja tabelas exclusivas somente faz a impressao do movimento dessa filial³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SEU->EU_FILIAL != xFilial("SEU")
		SEU->(dbSkip())
		Loop
    Endif

		//Vou me posicionar no primeiro registro para porcessar de acordo com a data de inicio.
	If EU_DTDIGIT > mv_par04 .And. cCaixa == EU_CAIXA
		SET->(DbSetOrder(1))
		SET->(DbSeek(xFilial()+SEU->EU_CAIXA))
		SET->(DbSkip())
		If !SET->(EOF())  .and. SET->ET_FILIAL == xFilial("SET") .and. (SET->ET_CODIGO >= mv_par01 .and. SET->ET_CODIGO <= mv_par02)
			SEU->(DbSeek(xFilial()+SET->ET_CODIGO+DTOS(mv_par03),.T.))
		Else
			lSaldo := .t.
			lImpress := .F.
		EndIf
	Endif

	dbSelectArea("SEU")
	If SEU->EU_CAIXA < MV_PAR01 .or. SEU->EU_CAIXA > MV_PAR02
		DbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	//Posicionar no primeiro registro de acordo com a data escolhida.
	If cCaixa <> EU_CAIXA .And. MV_PAR05 <> 3 .And. SEU->EU_DTDIGIT >= mv_par03 .and. SEU->EU_DTDIGIT <= mv_par04
		If !lSaldo
			nLin++

			If  MV_PAR05 <> 3
				@nLin, 062 PSAY STR0013 // "Saldo dos Movimentos do Caixinha->"
			Else
				@nLin, 077 PSAY STR0014 //"Total Gastos ---->"
			EndIf

			@nLin, 098 PSAY (nSaldo - nSalAbat)	PICTURE PesqPict("SEU","EU_VALOR",16) 
			nSaldoTot	+=	nSaldo 
			nSaldo	:=	0
			lSaldo	:=	.T.
			lPrinted :=	.F.
		Endif
	Endif

	If MV_PAR05 <> 3 .And. !Empty(EU_NROADIA) .and. EU_TIPO <> "02"
		aArea	:=	GetArea()
		DbSetOrder(3)
		DbSeek(xFilial()+EU_NROADIA)
		If EU_SLDADIA > 0 .Or.( MV_PAR05==1 .And. EU_TIPO == "00" )
			RestArea(aArea)
			DbSkip()
			Loop
		Endif
		RestArea(aArea)
	Endif

	If MV_PAR05 == 3 .And. EU_TIPO <> "00"  .And.  EU_TIPO <> "02" //So listar despesas
		lImpress := .F.
	Endif

	If !lPrinted
		If !Empty(cCaixa)
			nLin=nLin
		Else
			nLin++
		Endif

		cFil	:= EU_FILIAL
		cCaixa	:=	EU_CAIXA
		If SEU->EU_DTDIGIT >= mv_par03 .and. SEU->EU_DTDIGIT <= mv_par04
			SET->(DbSetOrder(1))
			SET->(DbSeek(xFilial()+SEU->EU_CAIXA))
			@nLin++, 05 PSAY STR0011+ SEU->EU_CAIXA + " - "+SET->ET_NOME //"Caja chica "

			If FXMultSld() .Or. cPaisLoc == "PER"
				@nLin++, 05 PSAY STR0039 + " --> " + Transform( getSldAnt( cFil,cCaixa, MV_PAR03 ), "@E 9,999,999.99" )
			EndIf
   			lPrinted	:=	.T.
   		EndIf
   		
	Endif
	lSaldo	:=	.F.

	If SEU->EU_DTDIGIT >= mv_par03 .and. SEU->EU_DTDIGIT <= mv_par04 .And. lImpress
		If EU_TIPO <> "02"
			If MV_PAR05 = 1 .And. EU_TIPO != "10" .and. EU_TIPO != "00"
				nLin++
	 			F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
	 		ElseIf MV_PAR05 = 2 .And. EU_TIPO == "00" .And. !Empty(EU_NROADIA)
	 			nLin++
	 			F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
	 		ElseIf MV_PAR05 = 3 .And. EU_TIPO == "00" .And. Empty(EU_NROADIA)
	 			nLin++
	 			F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
	 		ElseIf MV_PAR05 = 4
	 			nLin++
	 			F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
	 		EndIf
		Else
		    If MV_PAR05 = 3 .And. EU_TIPO == "00" .And.  EU_TIPO == "02"
		 		nLin++
		 		F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
		 	 Endif
			aArea:=GetArea()
			DbSetOrder(1)
		    If DbSeek(xFilial()+ EU_NROADIA) .And. EU_TIPO == "00" .And. Empty(EU_NROADIA) .And. MV_PAR05 = 4
		    	nLin++
		    	RestArea(aArea)
			    F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.T.)
			Else
				RestArea(aArea)
		    EndIf
		EndIf

		If (mv_par05 = 1 .OR. mv_par05 = 4) .And. EU_TIPO $ "01|03"
			If (EU_VALOR - EU_SLDADIA) > 0
				@nLin,116	PSAY	EU_VALOR - EU_SLDADIA PICTURE PesqPict("SEU","EU_VALOR",16)
			EndIf
			If EU_VALOR <> EU_SLDADIA .AND. mv_par05 <> 4
				nLin++
				@nLin,002	PSAY	STR0012 //"Detalles del Anticipo"
				aArea	:=	GetArea()
				DbSetOrder(3)
				cAdia	:=	EU_NUM
				DbSeek(xFilial()+cAdia)
				cAdto	:=	EU_NROADIA
				While !EOF()	.And.	xFilial() == EU_FILIAL .And. EU_NROADIA == cAdia
					nLin++
					F560Print(@nLin,4,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,.F.)
					DbSkip()
				Enddo
				RestArea(aArea)
			ElseIf EU_VALOR <> EU_SLDADIA .AND. mv_par05 == 4
				nSaldo += (EU_VALOR - EU_SLDADIA)
			Endif
		//ElseIf (mv_par05 == 1 .OR. mv_par05 == 4).And. EU_TIPO $"00" .And. ! Empty(EU_NROADIA)
			//nSaldo += (EU_VALOR - EU_SLDADIA)
		Endif
	EndIf
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	If ( (!Empty(cCaixa) .And. cCaixa <> EU_CAIXA) .Or. SEU->(EOF())) .And. !lSaldo
	
		nLin+=2
		If  MV_PAR05 <> 3
			@nLin, 062 PSAY STR0013 // "Saldo dos Movimentos do Caixinha->"
		Else
			@nLin, 077 PSAY STR0014 //"Total Gastos ---->"
		EndIf

		@nLin, 098 PSAY (nSaldo - nSalAbat)	PICTURE PesqPict("SEU","EU_VALOR",16) 

		If FXMultSld() .Or. cPaisLoc == "PER"
			nLin++
			@nLin, 062 PSAY STR0040
			@nLin, 098 PSAY getSldDia( xFilial("SEU"),cCaixa, MV_PAR04 ) PICTURE PesqPict( "FIJ", "FIJ_SALDO", 16 )
			lMSaldo := .F.
		EndIf

		nSaldoTot	+=	nSaldo
		nSaldo		:=	0
		lSaldo		:=	.T.
		lPrinted	:=	.F.
	Endif

EndDo
If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
If !lSaldo
	nLin++

	If  MV_PAR05 <> 3
		@nLin, 062 PSAY STR0013 // "Saldo dos Movimentos do Caixinha->"
	Else
		@nLin, 077 PSAY STR0014 //"Total Gastos ---->"
	EndIf

	@nLin, 098 PSAY (nSaldo - nSalAbat)	PICTURE PesqPict("SEU","EU_VALOR",16)
	nSaldoTot	+=	nSaldo 
Endif
If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
If MV_PAR05 == 3
	nLin++
	nLin++
	@nLin, 071 PSAY STR0015 //"Total General Gastos ---->"
	@nLin, 098 PSAY nSaldoTot	PICTURE PesqPict("SEU","EU_VALOR",16)
Endif
//If mv_par05	==	2 .AND. FXMultSld()
If FXMultSld() .Or. ( lMSaldo .And. cPaisLoc == "PER" )
	nLin++
	//@nLin, 062 PSAY STR0040
	//@nLin, 098 PSAY getSldDia( xFilial("SEU"),cCaixa, MV_PAR04 ) PICTURE PesqPict( "FIJ", "FIJ_SALDO", 16 )
EndIf
If nLin != 80
	Roda(cbcont,cbtxt,Tamanho)
endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³F560Print º Autor ³ Bruno Sobieski     º Data ³  02/07/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime um item.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function F560Print(nLin,nDesp,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,lEst)
Local cTipo	:=	""
Local nVlRep  := 0

Do Case
	Case EU_TIPO == "00"
		cTipo := IIf(Empty(EU_HISTOR),STR0016,Substr(EU_HISTOR,1,20)) //"Gasto"
	Case EU_TIPO == "01"
		cTipo := IIf(Empty(EU_HISTOR),STR0017,STR0018+ Substr(EU_HISTOR,1,20)) //"Anticipo"###"Ant. "
	Case EU_TIPO == "02"
		If lEst
			cTipo := STR0027 //"Estorno de Despesa"
		Else
			cTipo := STR0019 //"Dev. Anticipo"
		EndIf
	Case EU_TIPO == "10"
		cTipo := STR0020 //"Reposicion"
	Case EU_TIPO == "11"
		cTipo := IIf(Empty(EU_HISTOR),STR0021,+ Substr(EU_HISTOR,1,20)) //"Transf. por cierre"
	Case EU_TIPO == "12"
		cTipo := IIf(Empty(EU_HISTOR),STR0022,+ Substr(EU_HISTOR,1,20)) //"Dev. por cierre Caja Menor"
	Case EU_TIPO == "13"
		cTipo := IIf(Empty(EU_HISTOR),STR0023,+ Substr(EU_HISTOR,1,20)) //"Repos. Caja Menor"
	Case EU_TIPO == "90"
		cTipo := STR0024 //"Reposicao cancelada"
	Case EU_TIPO == "91"
		cTipo := STR0025 //"Aguardando autorizacao para reposicao"
	Case EU_TIPO == "92"
		cTipo := STR0026 //"Aguardando debito do titulo para reposicao"
	Case EU_TIPO == "03"
		cTipo := Substr(EU_HISTOR,1,20)
Endcase

If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin,000+nDesp	PSAY	cTipo
If EU_TIPO<"90"
	@nLin,029			PSAY	Substr(EU_BENEF,1,19)
Endif
@nLin,049			PSAY	EU_NRCOMP 	PICTURE PesqPict("SEU","EU_NRCOMP")
@nLin,062			PSAY	EU_NUM		PICTURE PesqPict("SEU","EU_NUM")
@nLin,076			PSAY	EU_NROADIA	PICTURE PesqPict("SEU","EU_NROADIA")
@nLin,088			PSAY	DTOC(EU_DTDIGIT)
If EU_TIPO<"90"
	nSigno	:=	IIf(MV_PAR05 == 3 .Or. !(EU_TIPO $ "00|01|03|11|13"),1,-1)

	If !Empty(EU_NROADIA) .and. MV_PAR05 == 3  .And. EU_TIPO == "02"
		nSigno	:=  -1
	EndIf

	If cSeqCxa == EU_SEQCXA .And. EU_TIPO == "10"

		nVlRep := EU_VALOR * nSigno

		@nLin,098  PSAY	nVlRep PICTURE PesqPict("SEU","EU_VALOR",16)

		If (nVlRep+SET->ET_SALANT) > SET->ET_VALOR
			nSaldo := nVlRep
		Else
			nSaldo += nVlRep
		EndIf
		//nSldAdia  := 0
	Else
		If nDesp == 0 .Or. EU_TIPO == "03"
			@nLin,098			PSAY	(EU_VALOR*nSigno)	PICTURE PesqPict("SEU","EU_VALOR",16)
		Else
			If EU_TIPO == "02" //Devolucao de adiantamento
				@nLin,098		PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
			Endif
			@nLin,116			PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
		Endif
		If nDesp == 0 .Or. EU_TIPO$ "02|03"
			nSaldo		+=	(EU_VALOR*nSigno)
		Endif
	EndIf
ElseIf EU_TIPO>"90"
		@nLin,098			PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³getSldAnt º Autor ³ Totvs              º Data ³  13/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Obtem o saldo anterior da caixinha                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function getSldAnt( cFil, cCaixa, dData )
Local nRet		:= 0
Local cQry		:= ""
Local aArea	:= GetArea()

#IFDEF TOP

	cQry += "SELECT FIJ_DATA, FIJ_SALDO "
	cQry += "FROM " + RetSqlName( "FIJ" ) + " "
	cQry += "WHERE 	FIJ_DATA < '" + DtoS( dData ) + "' AND "
	cQry += "		FIJ_FILIAL = '" + FwXFilial("FIJ") + "' AND "
	cQry += "		FIJ_CODCX = '" + cCaixa + "' AND "
	cQry += "		D_E_L_E_T_ = ' '"
	cQry += "ORDER BY FIJ_DATA DESC	"
	cQry := ChangeQuery( cQry )

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), "FIJTMP", .T., .T. )

	If FIJTMP->( !Eof() )
		nRet := FIJTMP->FIJ_SALDO
	EndIf

	FIJTMP->( DbCloseArea() )

#ELSE

	cChave	:= "FIJ_FILIAL+DTOS(FIJ_DATA)+FIJ_CODCX"
	nOrdem 	:= FIJ->(IndexOrd())

	dbSelectArea("FIJ")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("FIJ")
	IndRegua("FIJ",cIndex,cChave,,Nil,)  //"Selecionando Registros..."
	nIndex	:= RetIndex("FIJ")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	FIJ->(DbSeek(xFilial("FIJ")))
	While !FIJ->(Eof()) .And. FIJ->FIJ_FILIAL = xFilial("FIJ")
		If Dtos(FIJ->FIJ_DATA) > Dtos(dData) .Or. FIJ->FIJ_CODCX <> cCaixa
			Exit
		ElseIf Dtos(FIJ->FIJ_DATA) < Dtos(dData) .And. FIJ->FIJ_CODCX = cCaixa
			nRet := FIJ->FIJ_SALDO
		Endif
		FIJ->(Dbskip())
	Enddo

	IF cIndex != ""
		FErase (cIndex+OrdBagExt())
	EndIF

	dbSetOrder(nOrdem)
#ENDIF
	RestArea( aArea )
Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³getSldDia º Autor ³ Totvs              º Data ³  13/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Obtem o saldo anterior da caixinha                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function getSldDia( cFil, cCaixa, dData )
Local nRet		:= 0
Local cQry		:= ""
Local aArea	:= GetArea()

#IFDEF TOP
	cQry += "SELECT FIJ_DATA, FIJ_SALDO "
	cQry += "FROM " + RetSqlName( "FIJ" ) + " "
	cQry += "WHERE 	FIJ_DATA <= '" + DtoS( dData ) + "' AND "
	cQry += "		FIJ_CODCX = '" + cCaixa + "' AND "
	cQry += "FIJ_FILIAL = '" + FwXFilial("FIJ") + "' AND "
	cQry += "		D_E_L_E_T_ = ' '"
	cQry += "ORDER BY FIJ_DATA DESC	"
	cQry := ChangeQuery( cQry )

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), "FIJTMP", .T., .T. )

	If FIJTMP->( !Eof() )
		nRet := FIJTMP->FIJ_SALDO
	EndIf

	FIJTMP->( DbCloseArea() )

#ELSE
	cChave	:= "FIJ_FILIAL+DTOS(FIJ_DATA)+FIJ_CODCX"
	nOrdem 	:= FIJ->(IndexOrd())

	dbSelectArea("FIJ")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("FIJ")
	IndRegua("FIJ",cIndex,cChave,,Nil,)  //"Selecionando Registros..."
	nIndex	:= RetIndex("FIJ")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	FIJ->(DbSeek(xFilial("FIJ")))
	While !FIJ->(Eof()) .And. FIJ->FIJ_FILIAL = xFilial("FIJ")
		If Dtos(FIJ->FIJ_DATA) > Dtos(dData) .Or. FIJ->FIJ_CODCX <> cCaixa
			Exit
		ElseIf Dtos(FIJ->FIJ_DATA) <= Dtos(dData) .And. FIJ->FIJ_CODCX = cCaixa
			nRet := FIJ->FIJ_SALDO
		Endif
		FIJ->(Dbskip())
	Enddo

	IF cIndex != ""
		FErase (cIndex+OrdBagExt())
	EndIF

	dbSetOrder(nOrdem)
#ENDIF
	RestArea( aArea )
Return nRet
