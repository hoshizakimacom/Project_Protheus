#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M02R05   � Autor � Cleber Maldonado      � Data � 21/04/22 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Spend An�lises				                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M02R05()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oVenProd
Local cAliasQry := GetNextAlias()

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("M02R05","Spend Analises","M02R05", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de spend analises dos pedidos de compras.")
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oVenProd := TRSection():New(oReport,STR0023,{"SC7","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"CODFOR"		,/*Tabela*/ ,"Cod.Fornecedor"			,PesqPict("SC7","C7_FORNECE")	,TamSx3("C7_FORNECE")[1]+5				,/*lPixel*/,{|| cFornece	})	// Cod. Fornecedor
TRCell():New(oVenProd,"NFOR"		,/*Tabela*/ ,"Nome Fornecedor" 			,PesqPict("SA2","A2_NOME")		,TamSx3("A2_NOME")[1]					,/*lPixel*/,{|| cNome	})	// Nome Fornecedor
TRCell():New(oVenProd,"USUARIO"		,/*Tabela*/ ,"Usuario"					,PesqPict("SC7","C7_USER")		,TamSx3("C7_USER")[1]-10				,/*lPixel*/,{|| cUser		})	// Usuario
TRCell():New(oVenProd,"NUSUARIO"	,/*Tabela*/ ,"Usr Inclusao"				,PesqPict("SC7","C7_XINCLUI")	,TamSx3("C7_XINCLUI")[1]				,/*lPixel*/,{|| cUsrinclui	})	// Usuario Inclusao
TRCell():New(oVenProd,"NPEDIDO"		,/*Tabela*/ ,"Num Pedido"				,PesqPict("SC7","C7_NUM")		,TamSx3("C7_NUM")[1]					,/*lPixel*/,{|| cNpedido	})	// Num Pedido
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"					,PesqPict("SC7","C7_PRODUTO")	,TamSx3("C7_PRODUTO")[1]				,/*lPixel*/,{|| cProduto	})	// Produto
TRCell():New(oVenProd,"CONCAT"		,/*Tabela*/ ,"Concatenado"				,PesqPict("SC7","C7_PRODUTO")	,TamSx3("C7_FORNECE+C7_PRODUTO")[1]+5	,/*lPixel*/,{|| cConc		})	// Cod. Concatenado
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"						,PesqPict("SC7","C7_XTIPO")		,TamSx3("C7_XTIPO")[1]				 	,/*lPixel*/,{|| cTipo		})	// Tipo Produto
TRCell():New(oVenProd,"FAMILIA"		,/*Tabela*/ ,"Familia"		 			,PesqPict("SB1","B1_XDSCFA2")	,TamSx3("B1_XDSCFA2")[1]				,/*lPixel*/,{|| cFamilia	})	// Familia
TRCell():New(oVenProd,"DSCPROD"		,/*Tabela*/ ,"Desc Produto"	 			,PesqPict("SC7","C7_DESCRI")	,TamSx3("C7_DESCRI")[1]				 	,/*lPixel*/,{|| cDescri		})	// Descricao
TRCell():New(oVenProd,"VOLUME"		,/*Tabela*/ ,"Volume"					,PesqPict("SC7","C7_QUANT")		,TamSx3("C7_QUANT")[1]				 	,/*lPixel*/,{|| nVolume		})	// Volume
TRCell():New(oVenProd,"TOTNET"		,/*Tabela*/ ,"Total Net"				,PesqPict("SB1","B1_UPRC")		,TamSx3("B1_UPRC")[1]					,/*lPixel*/,{|| nUltprc		})	// Total Net
TRCell():New(oVenProd,"VANOEST"		,/*Tabela*/ ,"Vol. Ano Atual Estimado"	,PesqPict("SC7","C7_QUANT")		,TamSx3("C7_QUANT")[1]					,/*lPixel*/,{|| nVlanoest	})	// Vol. Ano Atual Estimado
TRCell():New(oVenProd,"UNIMED"		,/*Tabela*/ ,"UOM"						,PesqPict("SB1","B1_UM")		,TamSx3("B1_UM")[1]						,/*lPixel*/,{|| cUnimed		})	// Unidade de Medida
TRCell():New(oVenProd,"EXWBRUT"		,/*Tabela*/ ,"Prc Unit. EXW Bruto"		,PesqPict("SC7","C7_TOTAL")		,TamSx3("C7_TOTAL")[1]					,/*lPixel*/,{|| nExwBrut	})	// Prc. Unit EXW Bruto
TRCell():New(oVenProd,"EXWNET"		,/*Tabela*/ ,"Prc Unit. EXW Net"		,PesqPict("SC7","C7_TOTAL")		,TamSx3("C7_TOTAL")[1]					,/*lPixel*/,{|| nExwNet		})	// Prc. Unit EXW Net
TRCell():New(oVenProd,"MOEDA"		,/*Tabela*/ ,"Moeda"					,PesqPict("SC7","C7_MSG")		,TamSx3("C7_MSG")[1]					,/*lPixel*/,{|| cMoeda		})	// Moeda
TRCell():New(oVenProd,"EXWUSD"		,/*Tabela*/ ,"Prc. Unit. EXW USD"		,PesqPict("SC7","C7_PRECO")		,TamSx3("C7_PRECO")[1]					,/*lPixel*/,{|| nExwUsd		})	// Prc. Unit. EXW USD
TRCell():New(oVenProd,"APVUSD"		,/*Tabela*/ ,"APV EXW USD"				,PesqPict("SC7","C7_PRECO")		,TamSx3("C7_PRECO")[1]					,/*lPixel*/,{|| nApvUsd		})	// APV EXW USD
TRCell():New(oVenProd,"CODPGTO"		,/*Tabela*/ ,"Cod. Cond. Pagamento"		,PesqPict("SC7","C7_COND")		,TamSx3("C7_COND")[1]					,/*lPixel*/,{|| cCondPgto	})	// Cod. Cond. Pagamento
TRCell():New(oVenProd,"DESCPGTO"	,/*Tabela*/ ,"Desc. Cond. Pagamento"	,PesqPict("SC7","C7_XDESCPG")	,TamSx3("C7_PRECO")[1]					,/*lPixel*/,{|| cDescPgto	})	// Desc. Cond. Pagamento
TRCell():New(oVenProd,"LOCAL"		,/*Tabela*/ ,"Local/Importado"			,PesqPict("SA2","A2_NREDUZ")	,TamSx3("A2_NREDUZ")[1]					,/*lPixel*/,{|| cImport		})	// Local/Importado
TRCell():New(oVenProd,"PAIS"		,/*Tabela*/ ,"Pais"						,PesqPict("SYA","YA_DESCR")		,TamSx3("YA_DESCR")[1]					,/*lPixel*/,{|| cPais		})	// Pais
TRCell():New(oVenProd,"TAXA"		,/*Tabela*/ ,"Taxa Imposto"				,PesqPict("SC7","C7_TXMOEDA")	,TamSx3("C7_TXMOEDA")[1]				,/*lPixel*/,{|| cTxMoeda	})	// Taxa Imposto
TRCell():New(oVenProd,"TXPAIS"		,/*Tabela*/ ,"Taxa Pais"				,PesqPict("SC7","C7_XTXPAIS")	,TamSx3("C7_XTXPAIS")[1]				,/*lPixel*/,{|| cTxPais		})	// Taxa Pais
TRCell():New(oVenProd,"INTERCOM"	,/*Tabela*/ ,"Intercompany"				,PesqPict("SA2","A2_XINTERC")	,TamSx3("A2_XINTERC")[1]				,/*lPixel*/,{|| cInter		})	// Intercompany

//TRFunction():New(oVenProd:Cell("PESO")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//TRFunction():New(oVenProd:Cell("M3")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)

Local lPosA2	:= .F.
Local lPosB1	:= .F.
Local nMes    	:= Val(SubStr(DTOC(dDataBase),4,2))

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SCK")		// Itens do Or�amento
dbSetOrder(2)			// Produto,Numero

//oReport:Section(1):Cell("M3" ):SetBlock({|| nM3 })
//oReport:Section(1):Cell("PESO" ):SetBlock({|| nPeso })

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			C7_FILIAL, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_USER, C7_XINCLUI, C7_PRODUTO, C7_XTIPO, C7_DESCRI, C7_NUM, C7_TOTAL, C7_VALICM, C7_VALIMP5, C7_VALIMP6, C7_QUANT, C7_PRECO, C7_MOEDA, C7_TXMOEDA, C7_COND, C7_XDESCPG, C7_XTXPAIS 
		FROM 
			%Table:SC7% SC7
		WHERE 
			SC7.C7_FILIAL  >= %Exp:MV_PAR01% AND
			SC7.C7_FILIAL  <= %Exp:MV_PAR02% AND
			SC7.C7_EMISSAO >= %Exp:MV_PAR03% AND
			SC7.C7_EMISSAO <= %Exp:MV_PAR04% AND
			SC7.C7_PRODUTO >= %Exp:MV_PAR05% AND
			SC7.C7_PRODUTO <= %Exp:MV_PAR06% AND
			SC7.C7_FORNECE >= %Exp:MV_PAR07% AND
			SC7.C7_FORNECE <= %Exp:MV_PAR08% AND
			SC7.C7_LOJA    >= %Exp:MV_PAR09% AND
			SC7.C7_LOJA    <= %Exp:MV_PAR10% AND
			SC7.%NotDel%
		ORDER BY SC7.C7_EMISSAO
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

//oReport:Section(1):Cell("M3"):Disable()
//oReport:Section(1):Cell("PESO"):Disable()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA2 	:= SA2->(MsSeek(xFilial("SA2")+(cAliasQry)->C7_FORNECE + (cAliasQry)->C7_LOJA))
	lPosB1	:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->C7_PRODUTO))

	If lPosB1
		cFamilia	:= SB1->B1_XDSCFA2
		cUnimed		:= SB1->B1_UM
		nExwBrut	:= SB1->B1_UPRC
		nExwNet		:= ( SB1->B1_UPRC *9.25 ) / 10
	Else
		cFamilia	:= "NAO CADASTRADO"
		nExwBrut	:= 0
		cUnimed		:= " "
		nExwNet		:= 0
	EndIf

	If lPosA2
		cNome		:= SA2->A2_NOME
		cImport		:= IIF(SA2->A2_PAIS == "105", "LOCAL", "IMPORTADO")
		cPais		:= Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")
		cInter      := SA2->A2_XINTERC
	Else
		cNome		:= " "
		cImport		:= " "
		cPais		:= " "
		cInter		:= " "
	EndIf

	Do Case
		Case (cAliasQry)->C7_MOEDA == 1
			cMoeda := "BRL"
		Case (cAliasQry)->C7_MOEDA == 2
			cMoeda := "USD"
		Case (cAliasQry)->C7_MOEDA == 3
			cMoeda := "GBP"
		Case (cAliasQry)->C7_MOEDA == 4
			cMoeda := "EUR"
		Case (cAliasQry)->C7_MOEDA == 5
			cMoeda := "YEN"
	EndCase

	cFornece	:= (cAliasQry)->C7_FORNECE
	cUser		:= (cAliasQry)->C7_USER
	cUsrinclui	:= (cAliasQry)->C7_XINCLUI
	cNpedido	:= (cAliasQry)->C7_NUM
	cProduto	:= (cAliasQry)->C7_PRODUTO
	cConc		:= (cAliasQry)->C7_FORNECE+C7_PRODUTO
	cTipo		:= (cAliasQry)->C7_XTIPO
	cDescri		:= (cAliasQry)->C7_DESCRI		
	nVolume		:= U_CALCVOL(cProduto)
	nVlanoest	:= (nVolume/ nMes ) * 12 
	nUltprc     := ((cAliasQry)->C7_TOTAL - (cAliasQry)->C7_VALICM - (cAliasQry)->C7_VALIMP5 - (cAliasQry)->C7_VALIMP6) / (cAliasQry)->C7_QUANT
	nExwUsd		:= IIF((cAliasQry)->C7_MOEDA <> 2 ,nExwNet/ (cAliasQry)->C7_TXMOEDA,0)
	nApvUsd		:= nExwUsd* nVlanoest
	cCondPgto	:= (cAliasQry)->C7_COND
	cDescPgto	:= (cAliasQry)->C7_XDESCPG
	cTxMoeda	:= (cAliasQry)->C7_TXMOEDA
	cTxPais		:= (cAliasQry)->C7_XTXPAIS

	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M02R05   � Autor � Cleber Maldonado      � Data � 21/04/22 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Spend An�lises				                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function CALCVOL(cProduto)

Local nRet 		:= 0
Local cAliasVol := GetNextAlias()
Local cCFOP		:= " 1101', '2101', '3101', '1102' , '2102', '3102', '1111', '2111', '3111', '1113', '2113', '3113', '1116', '2116', '3116', '1117', '2117', '3117', '1118', '2118', '3118', '1120', '2120', '3120', '1121', '2121', '3121', '1122', '2122', '3122', '1126', '2126', '3126', '1127', '2127', '3127', '1128', '2128', '3128', '1251', '2251', '3251', '1252', '2252', '3252', '1302', '2302', '3302', '1401', '2401', '3401', '1403', '2403', '3403', '1407', '2407', '3407', '1556', '2556', '3556', '1651', '2651', '3651', '1652', '2652', '3652', '1653', '2653', '3653', '1912', '2912', '3112', '1913', '2913', '3913', '1915', '2915', '3915', '1916', '2916', '3916', '1922', '2922', '3922', '1949', '2949', '3949 "

BeginSql Alias cAliasVol
	
		SELECT 
			D1_COD, SUM(D1_QUANT) AS D1_QUANT
		FROM 
			%Table:SD1% SD1
		WHERE
			SD1.D1_FILIAL = '01' AND 
			SD1.D1_COD	  =  %Exp:cProduto% AND
			SD1.D1_DTDIGIT >= %Exp:MV_PAR03% AND
			SD1.D1_DTDIGIT <= %Exp:MV_PAR04% AND
			SD1.D1_CF IN  (%Exp:cCFOP%) AND
			SD1.%NotDel%
		GROUP BY SD1.D1_COD
EndSql 

dbSelectArea(cAliasVol)
dbGoTop()

nRet := (cAliasVol)->D1_QUANT 

(cAliasVol)->(dbCloseArea())

Return nRet
