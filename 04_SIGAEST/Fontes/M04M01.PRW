#include "Protheus.Ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM04M01    บAutor  ณMarcos Rocha	     บ Data ณ  08/03/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Requisicao de Mao de Obra no SD3 para os produtos     บฑฑ
ฑฑบ          ณ que os tenham cadastrados na estrutura.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Macom 		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M04M01()

Private d_DataRf 		:= ''
Private c_Perg       := 'M04M01'
Private c_TipoMO 		:= ''
Private c_TM    	 	:= ''
Private n_QuantBase	:= 0
Private n_QuantG1   	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Guarda parametros necessarios p/ o processamento.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
d_DataRf := GetMv("MV_ULMES")
c_TipoMO := "MO"

ValidPerg()
If !Pergunte(c_Perg, .T.)
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida data inicial informada no parametro                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While MV_PAR01 < d_DataRf
	msgAlert("A data inicial nใo pode ser menor que a do ๚ltimo fechamento " + DtoC(d_DataRf), "Aten็ใo")
	If !Pergunte(c_Perg, .T.)
		Return
	EndIf
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida data final informada no parametro                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While MV_PAR01 > MV_PAR02
	msgAlert("A data final nใo pode ser menor que a inicial.", "Aten็ใo")
	If !Pergunte(c_Perg, .T.)
		Return
	EndIf
EndDo

c_TM  := mv_par03

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCancela as Movimentacoes de MODs Geradas                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({||DelMODs()},"Excluindo possํveis movimentos gerados!!!")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera novas Movimentacoes para o intervalo informado                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({||GeraMOD()},"Gerando Movimentos de Requisi็ใo de MOD - Chapas !")

Processa({||GeraMOD2()},"Gerando Movimentos de Requisi็ใo de MOD !")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelMODs   บAutor  ณ                    บ Data ณ  01/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela possiveis movimentacoes geradas p/ o intervalo     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
'฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DelMODs()

Local cEOL	:= Chr(10)+Chr(13)
Local cQry	:= " "

cQry := "SELECT R_E_C_N_O_ RECNO1 FROM "+RetSqlName("SD3")
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
//cQry += " AND LEFT(D3_COD,3) IN ('MO-','MOD','   ') "+cEOL
//cQry += " AND LEFT(D3_COD,3) IN ('MOD','   ') "+cEOL
cQry += " AND LEFT(D3_COD,3) IN ('MO-') "+cEOL
cQry += " AND D3_TIPO = '"+c_TipoMO+"'"+cEOL
cQry += " AND D3_TM = '"+c_TM+"' "+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D_E_L_E_T_ <> '*' "+cEOL

If Select("TRB_DEL") > 0
	DbSelectArea("TRB_DEL")
	DbCloseArea()
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_DEL", .F., .T.)
DbSelectArea("TRB_DEL")
TRB_DEL->(DbGotop())

ProcRegua(1000)

While TRB_DEL->(!EOF())
	SD3->(DbGoto(TRB_DEL->RECNO1))
	IncProc("Deletando MOD's. filial:"+SD3->D3_FILIAL)
	RECLOCK("SD3",.F.)
	DbDelete()
	MsUnLock()
	TRB_DEL->(DbSkip())
EndDo

If Select("TRB_DEL") > 0
	DbSelectArea("TRB_DEL")
	DbCloseArea()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraMOD   บAutor  ณ                    บ Data ณ  01/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera as movimentacoes das MODs.                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraMOD()

local cEOL		:= Chr(10)+Chr(13)
Local cQry		:= " "
Local nProc
Private aEstrutura := {}

cQry := "SELECT D3_FILIAL, D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ,SUM(D3_QUANT) D3_QUANT,   SUM(D3_CUSTO1) D3_CUSTO1"+cEOL
cQry += " FROM "+RetSqlName("SD3")+" SD3 "+cEOL
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D3_OP <> ' ' AND SUBSTRING(D3_CF,1,2)='PR' AND D3_ESTORNO<>'S' "+cEOL

//cQry += " AND D3_COD = 'FTC1-AN        ' "+cEOL  // Teste Fritadeira
//cQry += " AND D3_OP = 'S4802201008   ' "+cEOL  // Teste Fritadeira
//cQry += " AND D3_DOC = 'ZTESTFUNT' "+cEOL  // Teste Fritadeira

cQry += " AND D_E_L_E_T_ <> '*' "+cEOL
cQry += " GROUP BY D3_FILIAL,D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ORDER BY D3_FILIAL,D3_COD"+cEOL

//cQry += " AND (SELECT COUNT(*) FROM "+RetSqlName("SB1")+" SB1 "+cEOL
//cQry += "  	 		 		  WHERE SB1.B1_FILIAL = SD3.D3_FILIAL "+cEOL
//cQry += " 					  AND SB1.B1_COD = SD3.D3_COD"+cEOL
//cQry += " 					  AND SB1.B1_USAMOD <> '2'"+cEOL Esta linha habilita usar este campo para definir se vai ou nใo apropriar o rateio da mao de obra na op
//cQry += " 					  AND SB1.B1_USAMOD <> '2'"+cEOL
//cQry += " 					  AND SB1.D_E_L_E_T_ <> '*') > 0"+cEOL

If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)
TcSetField("TRB_SD3","D3_QUANT"  ,"N",14,4)
TcSetField("TRB_SD3","D3_EMISSAO","D")

dbSelectArea("TRB_SD3")
TRB_SD3->(dbGoTop())

ProcRegua(1000)

While TRB_SD3->(!Eof())
	IncProc("Incluindo MOD's de Chapas Filial: "+TRB_SD3->D3_FILIAL)

//	MsgStop("GERANDO ESTRUTURA..."+TRB_SD3->D3_COD)

	dbSelectArea("SB1")
	dbSetOrder(1)
	If !MsSeek(xFilial("SB1")+TRB_SD3->D3_COD)
		dbSelectArea("TRB_SD3")
		TRB_SD3->(dbSkip())
		Loop
	EndIf

	// Usar a Funcao que explode a extrutura
	//aEsruct   // Pegar da Rotina de Custo Standard
	aEstrutura  := {}
	BuscaEstru(TRB_SD3->D3_COD,"001")

//	c("Qtd de Linhas da Estrutura : "+Str(Len(aEstrutura)))

	// Processa outros niveis
	BusEstr2("001","002")
	BusEstr2("002","003")
	BusEstr2("003","004")
	BusEstr2("004","005")
	BusEstr2("005","006")
	BusEstr2("006","007")

//	MsgStop("Qtd de Linhas da Estrutura - Apos Todos Niveis : "+Str(Len(aEstrutura)))

	// Busca os c๓digos de Chapas na Estrutura
	aProdChapa  := BuscaChapa(aEstrutura)

//	MsgStop("Qtd de Linhas da Estrutura - Apos Todos Limpeza - S๓ Chapas : "+Str(Len(aProdChapa)))

	//nConv    := If(SB1->B1_CONV = 0,1,SB1->B1_CONV)

	For nProc := 1 To Len(aProdChapa)

		cProduto := aProdChapa[nProc,1]
		nQtd     := aProdChapa[nProc,2]

		dbSelectArea("SB1")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB1")+cProduto)
			MsgStop("C๓digo nใo Localizado no cad produtos : "+cProduto)
		EndIf

		// Tabela de DePara Chapas x MOD - ZAH
		dbSelectArea("ZAH")
		dbSetOrder(1)
		If !dbSeek(xFilial("ZAH")+Left(Dtos(dDataBase),6)+cProduto)
//			MsgStop("C๓digo nใo Localizado na tabela ZAH - Serแ Criado Automatico : "+cProduto)

			Reclock("ZAH",.T.)
			ZAH->ZAH_FILIAL := xFilial("ZAH")
			ZAH->ZAH_ANOMES := Left(Dtos(dDataBase),6)
			ZAH->ZAH_COD    := cProduto
			ZAH->ZAH_CODMOD := "MOD"+SubStr(cProduto,4,11)
			MsUnLock()
		EndIf
		cMODChapa := ZAH->ZAH_CODMOD

		dbSelectArea("SB1")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB1")+cMODChapa)
//			MsgStop("C๓digo nใo Localizado no cad produtos - Serแ Criado Automatico : "+cMODChapa)

			Reclock("SB1",.T.)
			SB1->B1_FILIAL := xFilial("SB1")
			SB1->B1_COD    := cMODChapa
			SB1->B1_DESC   := "MOD DE RATEIO DA CHAPA "+cProduto
			SB1->B1_UM     := "KG"
			SB1->B1_TIPO   := "MO"
			SB1->B1_LOCPAD := "01"
			MsUnLock()
		EndIf

		dbSelectArea("SD3")
		RecLock("SD3",.T.)
		   SD3->D3_FILIAL   := xFilial("SD3")
		   SD3->D3_CF		:= 'RE0'
		   SD3->D3_TM		:= c_TM
		   SD3->D3_EMISSAO	:= TRB_SD3->D3_EMISSAO
//		   SD3->D3_COD      := SB1->B1_COD
		   SD3->D3_COD      := cMODChapa
		   SD3->D3_QUANT    := nQtd * TRB_SD3->D3_QUANT
		   SD3->D3_DOC      := TRB_SD3->D3_DOC
		   SD3->D3_UM		:= SB1->B1_UM
		   SD3->D3_SEGUM	:= SB1->B1_SEGUM
		   SD3->D3_TIPO		:= SB1->B1_TIPO
		   SD3->D3_LOCAL	:= SB1->B1_LOCPAD
	  	   SD3->D3_CC		:= SB1->B1_CC
		   SD3->D3_CONTA	:= SB1->B1_CONTA
		   SD3->D3_GRUPO	:= SB1->B1_GRUPO
		   SD3->D3_CHAVE	:= 'E0'
		   SD3->D3_NUMSEQ	:= TRB_SD3->D3_NUMSEQ
		   SD3->D3_OP		:= TRB_SD3->D3_OP
		   SD3->D3_USUARIO	:= Alltrim(cUsername)
		MsUnLock()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o SB2 se ele nao existir                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD) //U_CriaSB2Esp(SB1->B1_COD,SB1->B1_LOCPAD)
	Next

	dbSelectArea("TRB_SD3")
	TRB_SD3->(dbSkip())
EndDo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณBuscaEStruบ Autor ณ 				     บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function BuscaEStru(cProduto,cNivel)

Local aArea     := GetArea()
//	aProdutos  := {}

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Desconsidera somente itens vencidos , sem opcionais ou fora  ณ
		//ณ da revisao atual.                                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//If QtdComp(nQuantItem) != QtdComp(0)
		//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
		//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
		//	nCusTot := nCusTot + (nQuantItem * nCusto)
		//EndIf

		// Tratar a Validade da Estrutura
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

		//dbSelectArea("SB1")
		//dbSeek(xFilial("SB1")+SG1->G1_COD)
		Aadd(aEstrutura,{SG1->G1_COMP,SG1->G1_QUANT,cNivel})

		dbSelectArea("SG1")	
		dbSkip()
	EndDo

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณBuscaEStruบ Autor ณ 				     บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function BusEstr2(cNivel1,cNivel2)

Local aArea     := GetArea()
Local nProc2

For nProc2 := 1 to Len(aEstrutura)

	If aEstrutura[nProc2,3] <> cNivel1
		Loop
	EndIf

	cProduto := aEstrutura[nProc2,1]   // Produto

	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+cProduto)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Desconsidera somente itens vencidos , sem opcionais ou fora  ณ
		//ณ da revisao atual.                                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//If QtdComp(nQuantItem) != QtdComp(0)
		//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
		//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
		//	nCusTot := nCusTot + (nQuantItem * nCusto)
		//EndIf

		// Tratar a Validade da Estrutura  // 06/07/23 - Nใo tratar (o pode se tratar de OPS antigas e estrutura jแ vencida na data atual)
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

		//dbSelectArea("SB1")
		//dbSeek(xFilial("SB1")+SG1->G1_COD)
		Aadd(aEstrutura,{SG1->G1_COMP,SG1->G1_QUANT,cNivel2})

		dbSelectArea("SG1")	
		dbSkip()
	EndDo

Next

RestArea(aArea)

Return

// Criar uma Matriz somente com as chapas
Static Function BuscaChapa(aEstrutura)

Local nProc
Local aProdChapa := {}

For nProc := 1 To Len(aEstrutura)

	If Left(aEstrutura[nProc,1],2) == "CH" 
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aEstrutura[nProc,1])
		If Left(SB1->B1_DESC,5) == "CHAPA"   // Chapas
			Aadd(aProdChapa,{aEstrutura[nProc,1],aEstrutura[nProc,2]})
		EndIf
	EndIf
Next

Return(aProdChapa)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณValidPerg บ Autor ณ 				     บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

//              Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
aAdd(aRegs,{c_Perg,"01"  ,"Data de              ?",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"02"  ,"Data ate             ?",""      ,""     ,"MV_CH2","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"03"  ,"Tipo de Movimento    ?",""      ,""     ,"MV_CH3","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf	
Next

dbSelectArea(_sAlias)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraMOD   บAutor  ณ                    บ Data ณ  01/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera as movimentacoes das MODs.                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraMOD2()   // MOD da estrutura mesmo
 
local cEOL		:= Chr(10)+Chr(13)
Local cQry		:= " "
Local nProc
Private aEstrutura := {}

//Return // Desabilitado em Jan/24 - Marcos

cQry := "SELECT D3_FILIAL, D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ,SUM(D3_QUANT) D3_QUANT,   SUM(D3_CUSTO1) D3_CUSTO1"+cEOL
cQry += " FROM "+RetSqlName("SD3")+" SD3 "+cEOL
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D3_OP <> ' ' AND SUBSTRING(D3_CF,1,2)='PR' AND D3_ESTORNO<>'S' "+cEOL

//cQry += " AND D3_COD = 'FTC1-AN        ' "+cEOL  // Teste Fritadeira
//cQry += " AND D3_OP = 'S4802201008   ' "+cEOL  // Teste Fritadeira
//cQry += " AND D3_DOC = 'ZTESTFUNT' "+cEOL  // Teste Fritadeira

cQry += " AND D_E_L_E_T_ <> '*' "+cEOL
cQry += " GROUP BY D3_FILIAL,D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ORDER BY D3_FILIAL,D3_COD"+cEOL

//cQry += " AND (SELECT COUNT(*) FROM "+RetSqlName("SB1")+" SB1 "+cEOL
//cQry += "  	 		 		  WHERE SB1.B1_FILIAL = SD3.D3_FILIAL "+cEOL
//cQry += " 					  AND SB1.B1_COD = SD3.D3_COD"+cEOL
//cQry += " 					  AND SB1.B1_USAMOD <> '2'"+cEOL Esta linha habilita usar este campo para definir se vai ou nใo apropriar o rateio da mao de obra na op
//cQry += " 					  AND SB1.B1_USAMOD <> '2'"+cEOL
//cQry += " 					  AND SB1.D_E_L_E_T_ <> '*') > 0"+cEOL

If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)
TcSetField("TRB_SD3","D3_QUANT"  ,"N",14,4)
TcSetField("TRB_SD3","D3_EMISSAO","D")

dbSelectArea("TRB_SD3")
TRB_SD3->(dbGoTop())

ProcRegua(1000)

While TRB_SD3->(!Eof())
	IncProc("Incluindo MOD's Filial: "+TRB_SD3->D3_FILIAL)

//	MsgStop("GERANDO ESTRUTURA..."+TRB_SD3->D3_COD)

	dbSelectArea("SB1")
	dbSetOrder(1)
	If !MsSeek(xFilial("SB1")+TRB_SD3->D3_COD)
		dbSelectArea("TRB_SD3")
		TRB_SD3->(dbSkip())
		Loop
	EndIf

	// Usar a Funcao que explode a extrutura
	//aEsruct   // Pegar da Rotina de Custo Standard
	aEstrutura  := {}
	BuscaEstru(TRB_SD3->D3_COD,"001")

	// Processa outros niveis
	BusEstr2("001","002")
	BusEstr2("002","003")
	BusEstr2("003","004")
	BusEstr2("004","005")
	BusEstr2("005","006")
	BusEstr2("006","007")

	// Busca os c๓digos de Chapas na Estrutura
	aProdMOD  := BuscaMOD(aEstrutura)

//	MsgStop("Qtd de Linhas da Estrutura - Apos Todos Niveis : "+Str(Len(aEstrutura)))
//	MsgStop("Qtd de Linhas da Estrutura - Apos Todos Limpeza - S๓ Chapas : "+Str(Len(aProdChapa)))
	//nConv    := If(SB1->B1_CONV = 0,1,SB1->B1_CONV)

	For nProc := 1 To Len(aProdMOD)

		cProduto := aProdMOD[nProc,1]
		nQtd     := aProdMOD[nProc,2]

		// Tabela de DePara Chapas x MOD - ZAH
//		dbSelectArea("ZAH")
//		dbSetOrder(1)
//		dbSeek(xFilial("ZAH")+Left(Dtos(dDataBase),6)+cProduto)
//		cMODChapa := ZAH->ZAH_CODMOD

		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+cProduto)

		dbSelectArea("SD3")
		RecLock("SD3",.T.)
		   SD3->D3_FILIAL   := xFilial("SD3")
		   SD3->D3_CF		:= 'RE0'
		   SD3->D3_TM		:= c_TM
		   SD3->D3_EMISSAO	:= TRB_SD3->D3_EMISSAO
		   SD3->D3_COD      := SB1->B1_COD
		   SD3->D3_QUANT    := nQtd * TRB_SD3->D3_QUANT
		   SD3->D3_DOC      := TRB_SD3->D3_DOC
		   SD3->D3_UM		:= SB1->B1_UM
		   SD3->D3_SEGUM	:= SB1->B1_SEGUM
		   SD3->D3_TIPO		:= SB1->B1_TIPO
		   SD3->D3_LOCAL	:= SB1->B1_LOCPAD
	  	   SD3->D3_CC		:= SB1->B1_CC
		   SD3->D3_CONTA	:= SB1->B1_CONTA
		   SD3->D3_GRUPO	:= SB1->B1_GRUPO
		   SD3->D3_CHAVE	:= 'E0'
		   SD3->D3_NUMSEQ	:= TRB_SD3->D3_NUMSEQ
		   SD3->D3_OP		:= TRB_SD3->D3_OP
		   SD3->D3_USUARIO	:= Alltrim(cUsername)
		MsUnLock()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o SB2 se ele nao existir                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD) //U_CriaSB2Esp(SB1->B1_COD,SB1->B1_LOCPAD)
	Next

	dbSelectArea("TRB_SD3")
	TRB_SD3->(dbSkip())
EndDo

Return

// Criar uma Matriz somente com as chapas
Static Function BuscaMOD(aEstrutura)

Local nProc
Local aProdmod := {}

For nProc := 1 To Len(aEstrutura)


	If Left(aEstrutura[nProc,1],3) == "MO-" 
		// Tratar a Validade da Estrutura
//		dbSelectArea("SB1")
//		dbSeek(xFilial("SB1")+aEstrutura[nProc,1])
//		If Left(SB1->B1_DESC,5) == "CHAPA"   // Chapas
			Aadd(aProdmod,{aEstrutura[nProc,1],aEstrutura[nProc,2]})
//		EndIf
	EndIf
Next

Return(aProdmod)
