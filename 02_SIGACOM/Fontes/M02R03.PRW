#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M02R03   � Autor � Cleber Maldonado      � Data � 26/11/20 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Compras                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M02R03()

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
oReport := TReport():New("M02R03","RELACAO DE COMPRAS","M02R03", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de pedidos de compra." + " " + " ")
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
oVenProd := TRSection():New(oReport,"RELACAO DE COMPRAS",{"SC7","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUM"			,/*Tabela*/	,"Pedido"	 		 ,PesqPict("SC7","C7_NUM")		,TamSx3("C7_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"ITEM"		,/*Tabela*/ ,"Item"				 ,PesqPict("SC7","C7_ITEM")		,TamSx3("C7_ITEM")[1]		,/*lPixel*/,{|| cItem	})		// Item do Pedido
TRCell():New(oVenProd,"CODFOR"		,/*Tabela*/ ,"Fornecedor"		 ,PesqPict("SC7","C7_FORNECE")	,TamSx3("C7_FORNECE")[1]	,/*lPixel*/,{|| cCodFor	})		// Codigo Fornecedor
TRCell():New(oVenProd,"LOJFOR"		,/*Tabela*/	,"Loja"			     ,PesqPict("SC7","C7_LOJA")	    ,TamSx3("C7_LOJA")[1]	    ,/*lPixel*/,{|| cLojFor	})		// Loja Fornecedor
TRCell():New(oVenProd,"NOMEFOR"		,/*Tabela*/ ,"Razao Social"		 ,PesqPict("SA2","A2_NOME")		,TamSx3("A2_NOME")[1]		,/*lPixel*/,{|| cNomeFor})		// Nome do Fornecedor
TRCell():New(oVenProd,"CODPROD"		,/*Tabela*/ ,"Produto"			 ,PesqPict("SC7","C7_PRODUTO")	,TamSx3("C7_PRODUTO")[1]	,/*lPixel*/,{|| cCodProd})		// C�digo do Produto
TRCell():New(oVenProd,"DESCRI"		,/*Tabela*/ ,"Descricao"		 ,PesqPict("SC7","C7_DESCRI")   ,TamSx3("C7_DESCRI")[1]     ,/*lPixel*/,{|| cDescPro})		// Descri��o do Produto
TRCell():New(oVenProd,"UM"		    ,/*Tabela*/ ,"Unid. Med."	     ,PesqPict("SC7","C7_UM")	    ,TamSx3("C7_UM")[1]       	,/*lPixel*/,{|| cUm   	})		// Unidade de Medida 
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"				 ,PesqPict("SB1","B1_TIPO")	    ,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{|| cTipo	})		// Tipo do Produto
TRCell():New(oVenProd,"QUANT"		,/*Tabela*/ ,"Quantidade"		 ,PesqPict("SC7","C7_QUANT")	,TamSx3("C7_QUANT")[1]		,/*lPixel*/,{|| nQuant	})		// Quantidade
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Dt. Emissao"		 ,PesqPict("SC7","C7_EMISSAO")	,TamSx3("C7_EMISSAO")[1] 	,/*lPixel*/,{|| dDtEmiss})		// Data de emiss�o do pedido
TRCell():New(oVenProd,"VLUNIT"		,/*Tabela*/ ,"Valor Unitario"	 ,PesqPict("SC7","C7_PRECO")	,TamSx3("C7_PRECO")[1]		,/*lPixel*/,{|| nVlUnit	})		// Valor Unit�rio
TRCell():New(oVenProd,"TOTAL"		,/*Tabela*/ ,"Valor Total"		 ,PesqPict("SC7","C7_TOTAL")	,TamSx3("C7_TOTAL")[1]		,/*lPixel*/,{|| nVlTot	})		// Valor total do item do pedido
TRCell():New(oVenProd,"GRUPO"		,/*Tabela*/ ,"Grupo de Produto"	 ,PesqPict("SB1","B1_GRUPO")	,TamSx3("B1_GRUPO")[1] 	    ,/*lPixel*/,{|| cCodGrup})		// Grupo de Produto
TRCell():New(oVenProd,"DESCGRUP"	,/*Tabela*/ ,"Nome"	             ,PesqPict("SBM","BM_DESC")	    ,TamSx3("BM_DESC")[1] 	    ,/*lPixel*/,{|| cNomGrup})		// Nome de Produto

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

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC7")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			C7_FILIAL,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_FORNECE,C7_LOJA,C7_UM,C7_QUANT,C7_EMISSAO,C7_PRECO,C7_TOTAL
		FROM 
			%Table:SC7% SC7
		WHERE 
			SC7.C7_EMISSAO >= %Exp:MV_PAR01% AND 
			SC7.C7_EMISSAO <= %Exp:MV_par02% AND
			SC7.C7_NUM >= %Exp:MV_PAR03% AND 
			SC7.C7_NUM <= %Exp:MV_par04% AND
			SC7.%NotDel%
		ORDER BY SC7.C7_NUM,C7_ITEM
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
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cNum		:= (cAliasQry)->C7_NUM
	cItem		:= (cAliasQry)->C7_ITEM
	cCodFor		:= (cAliasQry)->C7_FORNECE
	cLojFor		:= (cAliasQry)->C7_LOJA
    cNomeFor    := Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->C7_FORNECE+(cAliasQry)->C7_LOJA,"A2_NOME")
    cCodProd	:= (cAliasQry)->C7_PRODUTO
    cDescPro    := (cAliasQry)->C7_DESCRI
    cUm         := (cAliasQry)->C7_UM
    cTipo       := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->C7_PRODUTO,"B1_TIPO")
	nQuant		:= (cAliasQry)->C7_QUANT
    dDtEmiss    := (cAliasQry)->C7_EMISSAO
	nVlUnit     := (cAliasQry)->C7_PRECO
	nVlTot      := (cAliasQry)->C7_TOTAL
    cCodGrup    := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->C7_PRODUTO,"B1_GRUPO")
	cNomGrup    := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC")
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return
