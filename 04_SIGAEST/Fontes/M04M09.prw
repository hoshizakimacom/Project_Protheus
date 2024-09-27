#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'

STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M04M09  ³ Autor ³ Marcos Rocha           ³ Data ³ 30/08/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera tabela ZG1 de Estruturas                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04M09()

Local cPerg   := "M04M09"

If IsInCallStack("U_M04M09J")
	lJob := .T.
Else
	lJob := .F.
Endif

If lJob
	Pergunte(cPerg,.F.)

	mv_par01 := "       "
	mv_par02 := "ZZZZZZZZZZ"
	mv_par03 := "  "
	mv_par04 := "ZZ"
	mv_par05 := "    "
	mv_par06 := "ZZZZ"
	mv_par07 := "   " // Revisão Estrutura
	mv_par08 := "99"  // Até Nivel
	mv_par09 := dDataBase //- 1   -- Testando com esta data
	mv_par10 := 2     // Bloqueados Não
	mv_par11 := "PA/EM/BN/MI/PI      "  //Tipos (Separar por /) ?      
	mv_par12 := 2  // 2- 6 Meses ; 4-Todas as Estruturas

//	MsgStop("M04M09_3")
    cMailDestino := "marcos.rocha@moovegestao.com.br"
	cAssunto     := "Inicio de Processamento - Geracao de Estruturas - ZG1"
	cTexto       := cAssunto
	cAnexos      := ""
	lMensagem    := .F.
	cMensQdoErro := ""

    lReturn := U_SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)

	U_M04M09Ger()

	cAssunto     := "Fincal  Processamento - Geracao de Estruturas - ZG1"
	cTexto       := cAssunto
    lReturn      := U_SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)

Else
//	MsgStop("M04M09_4")

	If Pergunte(cPerg,.T.)
		Processa({|| U_M04M09Ger()} , "Gerando Tabela de Estrututas... ZG1")
	EndIf

EndIf

Return

User Function M04M09J()

//MsgStop("M04M09J_1")

U_M04M09()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³ M04M09Ger ³ Autor ³ Marcos Rocha          ³ Data ³ 30/08/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera tabela ZG1 de Estruturas                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04M09Ger()

Local cProduto 	  := ""
Local nNivel   	  := 0
Local lContinua   := .T.
Local lDatRef     := !Empty(mv_par09)
Local cDataIni    := mv_par09
Private lNegEstr  := GETMV("MV_NEGESTR")
Private cNegativo := ALLTRIM(STR(MV_PAR10))
Private cSeqZG1 
Private cProdPai
Private nRegGrav := 0

dbSelectArea("ZG1")

// Deleta Registros Tabela ZG1
	If !lJob
		IncProc("Deletando Registros do dia...")
	EndIf

	cQuery := "DELETE FROM "+RetSqlName("ZG1")
	cQuery += " WHERE ZG1_FILIAL = '"+xFilial("ZG1")+"' "
	cQuery += " AND ZG1_DTINCL = '"+Dtos(mv_par09)+"' "
	TcSqlExec(cQuery)
//EndIf 

If !lJob
	IncProc("Atualizando data de Última Venda...")
EndIf

cDataIni := Dtos(mv_par09)
If mv_par12 == 1 // 3 Meses ou aberta
	cDataIni := Dtos(mv_par09-90)
ElseIf mv_par12 == 2 // 6 Meses ou aberta
	cDataIni := Dtos(mv_par09-180)
ElseIf mv_par12 == 3 // 1 Ano  ou aberta
	cDataIni := Dtos(mv_par09-365)
EndIf

If mv_par12 <> 4  // Todas as Estruturas -- Atualiza cadastro de Produtos Data de Ultima Venda ou OP

	cData    := Dtos(mv_par09)

    cQuery := " UPDATE " + RetSqlName("SB1") + " "
	cQuery += " SET B1_XDTMOVV = '"+cData+"'"
	cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "

	cQuery += " AND (SELECT COUNT(*) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " WHERE SC6.C6_FILIAL <> 'XX' "
	cQuery += " AND SC6.C6_PRODUTO = B1_COD "
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	cQuery += " AND C6_BLQ <> 'R' "
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' ) > 0 "

	cQuery += " OR (SELECT COUNT(*) FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5 "
	cQuery += " WHERE SC6.C6_FILIAL <> 'XX' "
	cQuery += " AND SC6.C6_PRODUTO = B1_COD "
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL  "
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
	cQuery += " AND SC5.C5_EMISSAO >= '"+cDataIni+"'"
	cQuery += " AND SC5.D_E_L_E_T_ <> '*' ) > 0 "

	cQuery += " OR (SELECT COUNT(*) FROM "+RetSqlName("SC2")+" SC2  "
	cQuery += " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "
	cQuery += " AND SC2.C2_PRODUTO = B1_COD "
	cQuery += " AND (SC2.C2_EMISSAO >= '"+cDataIni+"' OR SC2.C2_DATRF = ' ' )"
	cQuery += " AND SC2.D_E_L_E_T_ <> '*' ) > 0 "

	//Tenta executar o update
    nErro := TcSqlExec(cQuery)

EndIf

// OK - Tirar de relatório
// Montar um Update do campo B1_ e tratar a data aqui
// Gerar arquivo CSV na pasta - Chamar a rotina M04M02 Passando parametros
If !lJob
	IncProc("Gravando Estruturas...")
EndIf

cQuery := " SELECT SG1.R_E_C_N_O_ REGSG1, SG1.G1_COD, SG1.G1_COMP, SG1.G1_TRT"
cQuery += " FROM "+RetSqlName("SG1")+" SG1 ,"+ RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' "
cQuery += " AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND SG1.D_E_L_E_T_ <> '*' "
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND SB1.B1_COD = SG1.G1_COD "
cQuery += " AND SB1.B1_TIPO  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

If !Empty(mv_par11)
	cQuery += " AND SB1.B1_TIPO IN " + FormatIn(mv_par11, "/")
EndIf

If mv_par10 == 2  // Imprime Bloqueados se for Sim - 1 (não faz nada e carrega todos os produtos)
	cQuery += " AND SB1.B1_MSBLQL <> '1' " // *** Produtos diferentes de bloqueados - Branco ou "2"
EndIf

If mv_par12 <> 4 
	cQuery += " AND SB1.B1_XDTMOVV >= '"+cDataIni+"'"
EndIf

cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP, SG1.G1_TRT ASC "
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "SG1TRB"

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Montagem do Array para Retorno                                           º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
dbSelectArea("SG1TRB")

While SG1TRB->(!Eof())  //.And. SG1->G1_FILIAL+SG1->G1_COD <= xFilial('SG1')+mv_par02

	If !lJob
		IncProc("Gravando Estruturas..."+StrZero(SG1TRB->REGSG1,7))
	EndIf

	dbSelectArea("SG1")
	dbGoto(SG1TRB->REGSG1)

	If lDatRef .And. (G1_INI > mv_par09 .Or. G1_FIM < mv_par09)
	    dbSelectArea("SG1TRB")
		SG1TRB->(dbSkip())
		Loop
	EndIf

	cProduto  := SG1->G1_COD
	cProdPai  := SG1->G1_COD
	nNivel    := 2
    lContinua := .T.
	cSeqZG1 := "001"

	dbSelectArea('SB1')
	MsSeek(xFilial('SB1')+cProduto)
	If Eof() .Or. SB1->B1_TIPO < mv_par03 .Or. SB1->B1_TIPO > mv_par04 .Or. SB1->B1_GRUPO < mv_par05 .Or. SB1->B1_GRUPO > mv_par06
		dbSelectArea('SG1')
		While !Eof() .And. xFilial('SG1')+cProduto == SG1TRB->G1_FILIAL+SG1TRB->G1_COD
			dbSkip()
		EndDo
		lContinua := .F.
	EndIf

	If lContinua	
		//-- Explode Estrutura
		U_MTR225E2(cProduto,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,RetFldProd(SB1->B1_COD,"B1_OPC"),IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))	,IIf(Empty(mv_par07),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU ),mv_par07))
	
	EndIf
	
	// Pula todos os SG1 com o mesmo Codigo Pai
	dbSelectArea("SG1TRB")
	While SG1TRB->G1_COD == cProduto
		dbSkip()
	EndDo
EndDo

// Grava Parametro de Processamento
If nRegGrav > 0
	//	PutMv("AM_PROCZG1", Dtoc(mv_par09) + " - "+Transform(nRegGrav,"999,999,999") + " - Registro(s).")	

	cLogProc := Dtoc(mv_par09) + " - "+Transform(nRegGrav,"999,999,999") + " - Registro(s)."
	dbSelectArea("SX6")
	dbSetOrder(1)
	If dbSeek("  AM_PROCZG1")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := cLogProc
	EndIf
EndIf

dbSelectArea("SG1TRB")
dbClosearea()

//-- Devolve a condicao original do arquivo principal
dbSelectArea("SG1")
dbSetOrder(1)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MTR225ExplG³ Autor ³ Marcos V. Ferreira    ³ Data ³ 17/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MR225Expl(ExpO1,ExpO2,ExpC3,ExpN4,ExpN5,ExpC6,ExpN7,ExpC8) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do Relatorio                                ³±±
±±³          ³ ExpO2 = Sessao a ser impressa                              ³±±
±±³          ³ ExpC3 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN4 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN5 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC6 = Opcionais do produto                               ³±±
±±³          ³ ExpN7 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ ExpC8 = Numero da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MTR225E2(cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase,cRevisao)

Local nReg 		  := 0
Local nQuantItem  := 0
Local nPrintNivel := 0
Local cAteNiv     := If(mv_par08=Space(3),"999",mv_par08)
Local cRevEst	  := ''
Local lDatRef     := !Empty(mv_par09)
Local lVlOpc      := .T.

dbSelectArea('SG1')
While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial('SG1')+cProduto

	nReg := Recno()
	
	//Se não existir nenhum grupo/opcional default, deverá listar todos os opcionais
	If Empty(cOpcionais) .Or. cOpcionais == Nil
		lVlOpc := .F.
	EndIf
		
	nQuantItem := ExplEstr(nQuantPai,Iif(lDatRef,mv_par09,Nil),cOpcionais,cRevisao,,,,,,,,,lVlOpc)
	dbSelectArea('SG1')
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
		
			dbSelectArea('SB1')
			dbSetOrder(1)
			MsSeek(xFilial('SB1')+SG1->G1_COMP)

			//If SB1->B1_TIPO $ 'PA|PI|MI|BN|EM|MP|MC'

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao da Sessao 2			                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPrintNivel:=IIf(nNivel>17,17,nNivel-2)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe sub-estrutura                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea('SG1')
				MsSeek(xFilial('SG1')+SG1->G1_COMP)
				cRevEst := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )
				If Found()
					u_MTR225E2(SG1->G1_COD,nQuantItem,nNivel+1,SB1->B1_OPC,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),If(!Empty(cRevEst),cRevEst,mv_par07))
				EndIf
				dbGoto(nReg)

				nRegGrav ++

				RecLock("ZG1",.T.)
				ZG1->ZG1_FILIAL := xFilial("ZG1")
				ZG1->ZG1_COD    := cProdPai  //SG1->G1_COD
				ZG1->ZG1_SEQ    := cSeqZG1
				ZG1->ZG1_COMP   := SG1->G1_COMP
				ZG1->ZG1_NIVEL  := StrZero(nNivel,3)
				ZG1->ZG1_QUANT  := nQuantItem
				ZG1->ZG1_QTBASE := IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))
				ZG1->ZG1_PERDA  := SG1->G1_PERDA
				ZG1->ZG1_FIXVAR := SG1->G1_FIXVAR
				ZG1->ZG1_DTINCL := mv_par09
				MsUnLock()
				dbSelectArea('SG1')

				cSeqZG1 := Soma1(cSeqZG1)  // Incrementa Sequencia
		EndIf
	EndIf
	dbSkip()
EndDo

Return
