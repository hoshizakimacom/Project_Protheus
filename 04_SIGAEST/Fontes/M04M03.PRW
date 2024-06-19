#include "Protheus.Ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M04M03    บAutor  ณMarcos Rocha	     บ Data ณ  23/07/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Custo das Chapas na tabela ZAH para ser usada na  บฑฑ
ฑฑบ          ณ rotina MA330MOD.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Macom 		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M04M03()

Private dDataRf := ''
Private c_Perg  := 'M04M03'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Guarda parametros necessarios p/ o processamento.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dDataRf := GetMv("MV_ULMES")

ValidPerg()
If !Pergunte(c_Perg, .T.)
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida data inicial informada no parametro                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While MV_PAR01 < dDataRf
	msgAlert("A data Fechamento nใo pode ser menor que a do ๚ltimo fechamento " + DtoC(dDataRf), "Aten็ใo")
	If !Pergunte(c_Perg, .T.)
		Return
	EndIf
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza Tabela de Custo Consumo de Chapas a Absorver                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| AtuCstChapas()},"Atualizando Custo de Consumo de Chapas na tabela de Absor็ใo !")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza Custo em processo das OPS dos Periodos anteriores                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Processa({|| AtuSldProc()},"Atualizando Saldo em Processo - OPS perํodos anteriores !")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuCstChapas บAutor  ณ                 บ Data ณ  01/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizando Custo de Consumo de Chapas                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuCstChapas()

Local cEOL   := Chr(10)+Chr(13)
Local cQuery := " "

cQuery := "UPDATE " + RetSqlName("ZAH")+ " "+cEOL 
cQuery += " SET ZAH_VALOR = ISNULL((SELECT SUM(D3_CUSTO1) FROM  "+RetSqlName("SD3")+" SD3 "+cEOL
cQuery += "   WHERE D3_FILIAL = '" + xFilial("SD3") + "' "+cEOL
cQuery += "   AND LEFT(D3_EMISSAO,6) = '"+Left(DTOS(mv_par01),6)+"' "+cEOL
cQuery += "   AND SD3.D_E_L_E_T_ <> '*' "+cEOL
cQuery += "   AND D3_COD = ZAH_COD "+cEOL

cQuery += "   AND D3_LOCAL = '03' "+cEOL  // Corrigir Depois - Colocar parametro 05/12/23

cQuery += "   AND D3_DOC <> 'INVENT' "+cEOL
cQuery += "	   AND D3_CF IN ('RE0','RE1')),0) "+cEOL
cQuery += " WHERE ZAH_FILIAL = '" + xFilial("ZAH") + "' "+cEOL
cQuery += " AND ZAH_ANOMES = '"+Left(DTOS(mv_par01),6)+"' "+cEOL
cQuery += " AND LEFT(ZAH_COD,3) <> 'MO-' "+cEOL
cQuery += " AND D_E_L_E_T_ <> '*' "+cEOL
//MsgStop(cQuery)

TcSqlExec(cQuery) 

MsgStop("Atualizando Custo de Consumo de Chapas !")

Return

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
aAdd(aRegs,{c_Perg,"01"  ,"Data de Fechamento   ?",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

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
ฑฑบPrograma  ณ AtuSldProc  บAutor  ณ                 บ Data ณ  01/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizando Saldo em Processo                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSldProc()

Local cQuery := " "

//DELETA A TABELA TEMPORARIA GERADA ANTERIORMENTE
cQuery := " DROP TABLE SC2ALT2 "
TcSqlExec(cQuery) 
//MsgStop("Deleta tabela temporแria SC2ALT2 !")

//GERA TABELA TEMPORARIA (SC2ALT2) COM O CUSTO A APROPRIAR COM POSICAO DO ULTIMO FECHAMENTO
cQuery := " SELECT OP, C2_EMISSAO, C2_VINI1, CSTREQ, CSTPROD, (CSTREQ-CSTPROD) CSTNAPR "
cQuery += " INTO SC2ALT2 FROM ( "
cQuery += " SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP, C2_EMISSAO, C2_VINI1, "
cQuery += " ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) "
cQuery += "   FROM "+RetSqlName("SD3")+" SD3 "
cQuery += "   WHERE D3_FILIAL = '" + xFilial("SD3") + "' "
cQuery += "   AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN+'  ' "
cQuery += "   AND D3_EMISSAO <= '"+ Dtos(dDataRf)+"' "
cQuery += "   AND D3_CF IN ('RE0','RE1','DE0','DE1') "
cQuery += "   AND SD3.D_E_L_E_T_ <> '*' ),0) CSTREQ, "
cQuery += " ISNULL((SELECT SUM(D3_CUSTO1) "
cQuery += "   FROM "+RetSqlName("SD3")+" SD3 "
cQuery += "   WHERE D3_FILIAL = '" + xFilial("SD3") + "' "
cQuery += "   AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN+'  ' "
cQuery += "   AND D3_EMISSAO <= '"+ Dtos(dDataRf)+"' "
cQuery += "   AND D3_CF IN ('PR0','PR1') "
cQuery += "   AND SD3.D_E_L_E_T_ <> '*' ),0) CSTPROD "
cQuery += " FROM "+RetSqlName("SC2")+" SC2 (NOLOCK) "
cQuery += " WHERE C2_FILIAL = '" + xFilial("SC2") + "' "
cQuery += " AND C2_EMISSAO <= '"+ Dtos(dDataRf)+"' "
cQuery += " AND (C2_DATRF > '"+ Dtos(dDataRf)+"' OR C2_DATRF = ' ')  "
cQuery += " AND SC2.D_E_L_E_T_ <> '*') TAB "
TcSqlExec(cQuery) 
MsgStop("Gera Tabela Temporaria  (SC2ALT2) com o custo a apropriar com a posicao do ๚ltimo Fechamento !")

// DELETA OPS SEM CUSTO
cQuery := "DELETE FROM SC2ALT2 "
cQuery += " WHERE CSTREQ < CSTPROD OR CSTREQ < 0 OR (CSTPROD = 0 AND CSTREQ = 0) "
TcSqlExec(cQuery) 

// ZERA TODAS AS OPS ABERTAS NA DATA DE FECHAMENTO ANTERIOR
cQuery := " UPDATE "+RetSqlName("SC2")
cQuery += " SET C2_VINI1 = 0, C2_APRINI1 = 0, C2_APRFIM1 = 0 "
cQuery += " WHERE C2_FILIAL = '" + xFilial("SC2") + "' "
cQuery += " AND C2_VINI1 <> 0 "
cQuery += " AND (C2_DATRF > '"+ Dtos(dDataRf)+"'  OR C2_DATRF = ' ')  "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcSqlExec(cQuery) 

//   GRAVA O CUSTO INICIAL DA OP A APROPRIAR ( C2_VINI1 ) A PARTIR DA TABELA TEMPORARIA
//   COM O CALCULO DAS REQUISICOES/DEVOLUCOES DA OP ATษ O ULTIMO FECHAMENTO
cQuery := " UPDATE "+RetSqlName("SC2")
cQuery += " SET C2_VINI1 = ISNULL((SELECT SUM(CSTNAPR) "
cQuery += "    FROM SC2ALT2 "
cQuery += "    WHERE OP = C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "    AND CSTNAPR > 0),0), "
cQuery += " C2_APRINI1 = ISNULL((SELECT SUM(CSTPROD) "
cQuery += "    FROM SC2ALT2 "
cQuery += "     WHERE OP = C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "     AND CSTPROD > 0),0), "
cQuery += " C2_APRFIM1 = ISNULL((SELECT SUM(CSTPROD) "
cQuery += "   FROM SC2ALT2 "
cQuery += "   WHERE OP = C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "   AND CSTPROD > 0),0) "
cQuery += "   WHERE (SELECT COUNT(*) "
cQuery += "   FROM SC2ALT2 "
cQuery += " WHERE OP = C2_NUM+C2_ITEM+C2_SEQUEN) > 0 "
cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcSqlExec(cQuery) 

MsgStop("Atualizado Saldo em Processo - Periodos anteriores ! ")

Return
