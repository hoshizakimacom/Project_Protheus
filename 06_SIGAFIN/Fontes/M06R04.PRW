#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06R01   ³ Autor ³ Cleber Maldonado      ³ Data ³ 07/07/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferência de Comissões                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M06R04()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Cleber Maldonado      ³ Data ³ 21/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oTitulos
Local cAliasQry := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("M06R04","Conferência Comissões","M06R04", {|oReport| ReportPrint(oReport,cAliasQry,oTitulos)},"Este relatorio emite a relacao de titulos de comissões " + " " + " de acordo com os parâmetros informados.")
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTitulos := TRSection():New(oReport,STR0023,{"SE1","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oTitulos:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oTitulos,"FILIAL"		,/*Tabela*/ ,"Filial"			,PesqPict("SE1","E1_FILIAL")	,TamSx3("E1_FILIAL")[1]		,/*lPixel*/,{|| cxFilial })		// Filial
TRCell():New(oTitulos,"EMISSAO"		,/*Tabela*/ ,"Dt.Movimento"		,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao })		// Data de Emissão do Pedido
TRCell():New(oTitulos,"TIPO"		,/*Tabela*/ ,"Tipo"				,PesqPict("SE1","E1_TIPO")		,TamSx3("E1_TIPO")[1]		,/*lPixel*/,{|| cTipo	 })		// Tipo do título
TRCell():New(oTitulos,"VALTIT"		,/*Tabela*/ ,"Vlr.Movimento"	,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nValor	 })		// Valor do Titulo
TRCell():New(oTitulos,"VENCTO"		,/*Tabela*/ ,"Dt. Vencimento"	,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dVencto	 })		// Data de Vencimento
TRCell():New(oTitulos,"BENEF"		,/*Tabela*/ ,"Beneficiario"		,PesqPict("SE1","E1_NOMCLI")	,TamSx3("E1_NOMCLI")[1]		,/*lPixel*/,{|| cBenef	 })		// Beneficiário
TRCell():New(oTitulos,"RAZAO"		,/*Tabela*/ ,"Razao Social"		,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1] 		,/*lPixel*/,{|| cNomCli	 })		// Razão Social do Cliente
TRCell():New(oTitulos,"PREFIXO"		,/*Tabela*/ ,"Prefixo"			,PesqPict("SE1","E1_PREFIXO")	,TamSx3("E1_PREFIXO")[1]	,/*lPixel*/,{|| cPrefixo })		// Prefixo do Título
TRCell():New(oTitulos,"NUMTIT"		,/*Tabela*/ ,"Num.Titulo"		,PesqPict("SE1","E1_NUM")		,TamSx3("E1_NUM")[1]		,/*lPixel*/,{|| cNumTit	 })		// Numero do Título
TRCell():New(oTitulos,"NUMPED"		,/*Tabela*/	,"Num.Pedido"		,PesqPict("SE1","E1_PEDIDO")	,TamSx3("E1_PEDIDO")[1]		,/*lPixel*/,{|| cNumPed	 })		// Numero do Pedido
TRCell():New(oTitulos,"PARCELA"		,/*Tabela*/ ,"Parcela"			,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cParcela })		// Parcela do Título
TRCell():New(oTitulos,"CLIENTE"		,/*Tabela*/ ,"Cliente"			,PesqPict("SA1","E1_CLIENTE")   ,TamSx3("E1_CLIENTE")[1]	,/*lPixel*/,{|| cCodCli  })		// Código do Cliente
TRCell():New(oTitulos,"LOJA"		,/*Tabela*/ ,"Loja"				,PesqPict("SE1","E1_LOJA")		,TamSx3("E1_LOJA")[1]	 	,/*lPixel*/,{|| cLoja	 })		// Loja do Cliente
TRCell():New(oTitulos,"PAGTO"		,/*Tabela*/	,"Dt. Baixa"	 	,PesqPict("SE1","E1_BAIXA")		,TamSx3("E1_BAIXA")[1]		,/*lPixel*/,{|| dBaixa	 })		// Data da baixa - Pagamento
TRCell():New(oTitulos,"CODVEND1"	,/*Tabela*/ ,"Vendedor 1"		,PesqPict("SE1","E1_VEND1")		,TamSx3("E1_VEND1")[1]		,/*lPixel*/,{|| cCodVen1 })		// Código do Vendedor 1
TRCell():New(oTitulos,"CODVEND2"	,/*Tabela*/ ,"Vendedor 2"		,PesqPict("SE1","E1_VEND2")		,TamSx3("E1_VEND2")[1]		,/*lPixel*/,{|| cCodVen2 })		// Código do Vendedor 2
TRCell():New(oTitulos,"CODVEND3"	,/*Tabela*/ ,"Vendedor 3"		,PesqPict("SE1","E1_VEND3")		,TamSx3("E1_VEND3")[1]		,/*lPixel*/,{|| cCodVen3 })		// Código do Vendedor 3
TRCell():New(oTitulos,"CODVEND4"	,/*Tabela*/ ,"Vendedor 4"		,PesqPict("SE1","E1_VEND4")		,TamSx3("E1_VEND4")[1]		,/*lPixel*/,{|| cCodVen4 })		// Código do Vendedor 4
TRCell():New(oTitulos,"CODVEND5"	,/*Tabela*/ ,"Vendedor 5"		,PesqPict("SE1","E1_VEND5")		,TamSx3("E1_VEND5")[1]		,/*lPixel*/,{|| cCodVen5 })		// Código do Vendedor 5
TRCell():New(oTitulos,"COMISS1"		,/*Tabela*/	,"% Comissao 1"		,PesqPict("SE1","E1_COMIS1")	,TamSx3("E1_COMIS1")[1]		,/*lPixel*/,{|| nComis1  })		// % de Comissão Vendedor 1
TRCell():New(oTitulos,"COMISS2"		,/*Tabela*/ ,"% Comissao 2"		,PesqPict("SE1","E1_COMIS2")	,TamSx3("E1_COMIS2")[1]		,/*lPixel*/,{|| nComis2  })		// % de Comissão Vendedor 2
TRCell():New(oTitulos,"COMISS3"		,/*Tabela*/ ,"% Comissao 3"		,PesqPict("SE1","E1_COMIS3")	,TamSx3("E1_COMIS3")[1]		,/*lPixel*/,{|| nComis3  })		// % de Comissão Vendedor 3
TRcell():New(oTitulos,"COMISS4"		,/*Tabela*/ ,"% Comissao 4"		,PesqPict("SE1","E1_COMIS4")	,TamSx3("E1_COMIS4")[1]		,/*lPixel*/,{|| nComis4  })		// % de Comissão Vendedor 4
TRCell():New(oTitulos,"COMISS5"		,/*Tabela*/ ,"% Comissao 5"		,PesqPict("SE1","E1_COMIS5")	,TamSx3("E1_COMIS5")[1]		,/*lPixel*/,{|| nComis5	 })		// % de Comissão Vendedor 5
TRCell():New(oTitulos,"DESCONT"		,/*Tabela*/ ,"Desconto"			,PesqPict("SE1","E1_DESCON1")	,TamSx3("E1_DESCON1")[1]	,/*lPixel*/,{|| nDesc	 })		// Valor do Desconto
TRCell():New(oTitulos,"HISTOR"		,/*Tabela*/ ,"Historico"		,PesqPict("SE1","E1_HIST")		,TamSx3("E1_HIST")[1]		,/*lPixel*/,{|| cHist	 })		// Histórico

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Cleber Maldonado	    ³ Data ³ 07/07/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry,oTitulos)

Local lPosA1	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
				E1_FILIAL,E1_PEDIDO,E1_TIPO,E1_EMISSAO,E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA,E1_VENCTO,E1_PREFIXO,
				E1_BAIXA,E1_PORTADO,E1_VALLIQ,E1_ACRESC,E1_DECRESC,E1_DESCON1,E1_VALOR,E1_HIST,E1_VEND1,E1_NOMCLI,
				E1_VEND1,E1_VEND2,E1_VEND3,E1_VEND4,E1_VEND5,E1_COMIS1,E1_COMIS2,E1_COMIS3,E1_COMIS4,E1_COMIS5 
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL IN ("01", "03") AND
			SE1.E1_BAIXA >= %Exp:MV_PAR01% AND
			SE1.E1_BAIXA <= %Exp:MV_PAR02% AND
			SE1.E1_VEND1 >= %Exp:MV_PAR03% AND
			SE1.E1_VEND1 <= %Exp:MV_PAR04% AND
			SE1.E1_TIPO NOT IN ( 'RA' , 'NCC' , 'IN-' ) AND
			SE1.%NotDel%
		ORDER BY SE1.E1_NUM
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SE5")
dbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ                                                                                      
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosE5 	:= SE5->(MsSeek(xFilial('SE5')+(cAliasQry)->E1_PREFIXO+(cAliasQry)->E1_NUM+(cAliasQry)->E1_PARCELA))
	
	If lPosE5
		If SE5->E5_MOTBX <> "NOR"
			(cAliasQry)->(dbSkip())
			Loop
		Endif
	Else
		(cAliasQry)->(dbSkip())
		Loop		
	Endif		
	
	cNumPed		:= (cAliasQry)->E1_PEDIDO
	cTipo		:= (cAliasQry)->E1_TIPO
	cxFilial	:= (cAliasQry)-> E1_FILIAL
	dEmissao	:= (cAliasQry)->E1_EMISSAO
	cNumTit		:= (cAliasQry)->E1_NUM
	cParcela	:= (cAliasQry)->E1_PARCELA
	dVencto		:= (cAliasQry)->E1_VENCTO
	dBaixa		:= (cAliasQry)->E1_BAIXA
	nDesc		:= (cAliasQry)->E1_DESCON1
	nValor		:= SE5->E5_VALOR
	cBenef		:= (cAliasQry)->E1_NOMCLI
	cPrefixo	:= (cAliasQry)->E1_PREFIXO
	cCodVen1	:= (cAliasQry)->E1_VEND1
	cCodVen2	:= (cAliasQry)->E1_VEND2
	cCodVen3	:= (cAliasQry)->E1_VEND3
	cCodVen4	:= (cAliasQry)->E1_VEND4
	cCodVen5	:= (cAliasQry)->E1_VEND5		
	nComis1		:= (cAliasQry)->E1_COMIS1
	nComis2		:= (cAliasQry)->E1_COMIS2
	nComis3		:= (cAliasQry)->E1_COMIS3
	nComis4		:= (cAliasQry)->E1_COMIS4
	nComis5		:= (cAliasQry)->E1_COMIS5	
	cHist		:= (cAliasQry)->E1_HIST
	
	If lPosA1
		cCodCli		:= SA1->A1_COD
		cLoja		:= SA1->A1_LOJA
		cNomCli		:= SA1->A1_NOME
	Endif
		
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return