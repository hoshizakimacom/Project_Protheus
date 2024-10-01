#Include "Protheus.ch"
#Include "Topconn.ch"

User Function M04A03()

AxCadastro("ZAJ")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ M04A03A  ³ Autor ³ Protheus             ³ Data ³ 01/10/2024³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Localiza regras SPEND								      ³±±
±±³          						                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M04A03A(cCanal,cRegiao,cCliente,cLoja,cGrupo,cProduto,cTipo,dDataAnaliz,cGrpCli)

Local aArea		 := GetArea()
Local nPercDesc := 0
Local aRegras   := {}
Local cQuery    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa por todas as regras validas para este caso          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += "SELECT * FROM " + RetSqlName("PZK") + " PZK "
cQuery += " WHERE PZK.PZK_FILIAL = '" + xFilial("PZK") + "'"
cQuery += " AND PZK.PZK_CANAL = '"+cCanal+"'"
cQuery += " AND (PZK.PZK_REGIAO = '   ' OR PZK.PZK_REGIAO = '"+cRegiao+"')"
cQuery += " AND (PZK.PZK_CLIENT = '      ' OR PZK.PZK_CLIENT = '"+cCliente+"')"
cQuery += " AND (PZK.PZK_LOJA = '  ' OR PZK.PZK_LOJA = '"+cLoja+"')"

cQuery += " AND (PZK.PZK_GRPCLI = '  ' OR PZK.PZK_GRPCLI = '"+cGrpCli+"')"

cQuery += " AND (PZK.PZK_GRUPO = '    ' OR PZK.PZK_GRUPO = '"+cGrupo+"')"
cQuery += " AND (PZK.PZK_PRODUT = '  ' OR PZK.PZK_PRODUT = '"+cProduto+"')"

cQuery += " AND '"+Dtos(dDataAnaliz)+"' BETWEEN PZK.PZK_DTINI AND PZK.PZK_DTFIM "
cQuery += " AND PZK.D_E_L_E_T_=' ' "

cQuery += " ORDER BY PZK_REGIAO, PZK_CLIENT,  PZK_LOJA, PZK_GRPCLI  "
cQuery := ChangeQuery(cQuery)

//MemoWrite("\QUERYSYS\EFATA01",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QUERY",.T.,.T.)
dbGotop()

While !Eof()
	
	Aadd(aRegras, {QUERY->PZK_REGIAO, QUERY->PZK_CLIENT, QUERY->PZK_LOJA, QUERY->PZK_GRPCLI, QUERY->PZK_PRODUT, QUERY->PZK_GRUPO, QUERY->PZK_DESCON })

	dbSkip()
EndDo

dbSelectArea("QUERY")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa por todas as regras validas para este caso          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aRegras,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]})
If Len(aRegras) <> 0
	nPercDesc := aRegras[1][7]

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)

Return(nPercDesc)
