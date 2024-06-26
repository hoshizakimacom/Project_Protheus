#INCLUDE "PROTHEUS.CH"
#INCLUDE "matr620.CH"
#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "TBICONN.CH"   // Necessario para o Prepare Environment
#INCLUDE "topconn.CH"   // Necessario para o Prepare Environment
#include "Fileio.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#include "parmtype.ch"
#include "totvs.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M05R12   � Autor � Cleber Maldonado      � Data � 22/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gerencial - Or�amentos			                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R12()

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
//EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 22/08/17 ���
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
oReport := TReport():New("M05R12","Gerencial - Or�amentos","M05R12", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de or�amentos em aberto." + " " + " N�o ser� apresentado or�amentos com status Cancelado ou Baixado.")
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
oVenProd := TRSection():New(oReport,"GERENCIAL - OR�AMENTOS",{"SCJ","SCK"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUM"			,/*Tabela*/	,"Numero"			 ,PesqPict("SCK","CK_NUM")		,TamSx3("CK_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Emissao"			 ,PesqPict("SCJ","CJ_EMISSAO")	,TamSx3("CJ_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao})		// Data de Emiss�o do Or�amento
TRCell():New(oVenProd,"ITEM"		,/*Tabela*/	,"Item"		 		 ,PesqPict("SCK","CK_ITEM")		,TamSx3("CK_ITEM")[1]		,/*lPixel*/,{|| cItem	})		// Item do Or�amento
TRCell():New(oVenProd,"FAMILIA"		,/*Tabela*/	,"Familia"			 ,PesqPict("SB1","B1_XFAMILI")	,TamSx3("B1_XFAMILI")[1]	,/*lPixel*/,{|| cXFami  })		// Familia
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Cod.Produto"		 ,PesqPict("SCK","CK_PRODUTO")	,TamSx3("CK_PRODUTO")[1]	,/*lPixel*/,{|| cProd	})		// C�digo do Produto
TRCell():New(oVenProd,"UM"			,/*Tabela*/	,"Un.Medida"	 	 ,PesqPict("SCK","CK_UM")		,TamSx3("CK_UM")[1]			,/*lPixel*/,{|| cUM		})		// Unidade de Medida
TRCell():New(oVenProd,"DESCRI"		,/*Tabela*/	,"Descri�ao"		 ,PesqPict("SCK","CK_DESCRI")	,TamSx3("CK_DESCRI")[1]		,/*lPixel*/,{|| cDescr	})		// Descri��o do Produto
TRCell():New(oVenProd,"QUANT"		,/*Tabela*/	,"Quantidade"		 ,PesqPict("SCK","CK_QTDVEN")	,TamSx3("CK_QTDVEN")[1]		,/*lPixel*/,{|| nQtdVen	})		// Quantidade
TRCell():New(oVenProd,"PRCVEN"		,/*Tabela*/	,"Prc.Venda"		 ,PesqPict("SCK","CK_PRCVEN")	,TamSx3("CK_PRCVEN")[1]		,/*lPixel*/,{|| nPrcUnit})		// Pre�o Unit�rio
TRCell():New(oVenProd,"VALTOT"		,/*Tabela*/ ,"Total"			 ,PesqPict("SCK","CK_VALOR")	,TamSx3("CK_VALOR")[1]		,/*lPixel*/,{|| nValTot	})		// Valor Total do Item
TRCell():New(oVenProd,"ENTREGA"		,/*Tabela*/	,"Dt.Entrega"		 ,PesqPict("SCJ","CJ_XFECENT")	,TamSx3("CJ_XFECENT")[1]	,/*lPixel*/,{|| dDtEntr	})		// Data de Entrega
TRCell():New(oVenProd,"TES"			,/*Tabela*/ ,"TES"				 ,PesqPict("SCK","CK_TES")		,TamSx3("CK_TES")[1]		,/*lPixel*/,{|| cTES	})		// C�digo de TES
TRCell():New(oVenProd,"XTPVEN"		,/*Tabela*/ ,"Tipo Venda"		 ,PesqPict("SCJ","CJ_XTPVEN")	,TamSx3("CJ_XTPVEN")[1]		,/*lPixel*/,{|| cXTpVen })		// Tipo de Venda
TRCell():New(oVenProd,"CODCLI"		,/*Tabela*/	,"Cod.Cliente"		 ,PesqPict("SCK","CK_CLIENTE")	,TamSx3("CK_CLIENTE")[1]	,/*lPixel*/,{|| cCodCli	})		// C�digo do Cliente
TRCell():New(oVenProd,"LOJACLI"		,/*Tabela*/	,"Loja"				 ,PesqPict("SCK","CK_LOJA")		,TamSx3("CK_LOJA")[1]		,/*lPixel*/,{|| cCodLoj	})		// C�digo da Loja
TRCell():New(oVenProd,"NOMECLI"		,/*Tabela*/ ,"Nome"				 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNome	})		// Nome do Cliente
TRCell():New(oVenProd,"REGIAO"		,/*Tabela*/	,"Regi�o"			 ,PesqPict("SA1","A1_DSCREG")	,TamSx3("A1_DSCREG")[1]		,/*lPixel*/,{|| cRegiao	})		// Regi�o do Cliente
TRCell():New(oVenProd,"ESTADO"		,/*Tabela*/	,"Estado"			 ,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cEstado })		// Estado do Cliente
TRCell():New(oVenProd,"MUNICIPIO"	,/*Tabela*/	,"Municipio"		 ,PesqPict("SA1","A1_MUN")		,TamSx3("A1_MUN")[1]		,/*lPixel*/,{|| cMunicio})		// Municipio do Cliente		#5914
TRCell():New(oVenProd,"GERENCIA"	,/*Tabela*/	,"Ger�ncia"			 ,PesqPict("SA1","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomGer })		// Nome do Gerente
TRCell():New(oVenProd,"DESCONT"		,/*Tabela*/	,"%Desconto"		 ,PesqPict("SCK","CK_DESCONT")	,TamSx3("CK_DESCONT")[1]	,/*lPixel*/,{|| nDesc 	})		// Percentual de Desconto
TRCell():New(oVenProd,"PRCUNIT"		,/*Tabela*/	,"Prc Lista"		 ,PesqPict("SCK","CK_PRUNIT")	,TamSx3("CK_PRUNIT")[1]		,/*lPixel*/,{|| nPrcList})		// Pre�o de Lista
TRCell():New(oVenProd,"CLASFIS"		,/*Tabela*/	,"Sit.Tribut."		 ,PesqPict("SCK","CK_CLASFIS")	,TamSx3("CK_CLASFIS")[1]	,/*lPixel*/,{|| cPosIpi	})		// Pos.IPI (N.C.M.)
TRCell():New(oVenProd,"DT1VEN"		,/*Tabela*/	,"1.Vencimento"		 ,PesqPict("SCK","CK_DT1VEN")	,TamSx3("CK_DT1VEN")[1]		,/*lPixel*/,{|| dDt1Ven	})		// Data de Primeiro Vencimento
TRCell():New(oVenProd,"ITEMPLANT"	,/*Tabela*/	,"Item Planta"		 ,PesqPict("SCK","CK_XITEMP")	,TamSx3("CK_XITEMP")[1]		,/*lPixel*/,{|| cItemP	})		// Item da Planta
TRCell():New(oVenProd,"VLUTAB"		,/*Tabela*/	,"Vlr Tabela"		 ,PesqPict("SCK","CK_XVLUTAB")	,TamSx3("CK_XVLUTAB")[1]	,/*lPixel*/,{|| nVluTab	})		// Valor de Tabela
TRCell():New(oVenProd,"VLTBRU"		,/*Tabela*/	,"Vl Tot + IPI"		 ,PesqPict("SCK","CK_XVLTBRU")	,TamSx3("CK_XVLTBRU")[1]	,/*lPixel*/,{|| nVltBru	})		// Valor Total + IPI
TRCell():New(oVenProd,"ACRES"		,/*Tabela*/	,"Acresc %"			 ,PesqPict("SCK","CK_XACRESC")	,TamSx3("CK_XACRESC")[1]	,/*lPixel*/,{|| nAcres	})		// % de Acrescimo
TRCell():New(oVenProd,"VLTIPI"		,/*Tabela*/	,"Vlr Tot IPI"		 ,PesqPict("SCK","CK_XVLTIPI")	,TamSx3("CK_XVLTIPI")[1]	,/*lPixel*/,{|| nVltIpi	})		// Valor Total de IPI
TRCell():New(oVenProd,"ALQPIS"		,/*Tabela*/	,"Aliq PIS"			 ,PesqPict("SCK","CK_XALQPS2")	,TamSx3("CK_XALQPS2")[1]	,/*lPixel*/,{|| nAlqPis	})		// Al�quota de PIS
TRCell():New(oVenProd,"VLTPIS"		,/*Tabela*/	,"Vlr Tot PIS"		 ,PesqPict("SCK","CK_XVLTPS2")	,TamSx3("CK_XVLTPS2")[1]	,/*lPixel*/,{|| nVltPis	})		// Valor Total de PIS
TRCell():New(oVenProd,"ALQCOF"		,/*Tabela*/	,"Aliq COFINS"		 ,PesqPict("SCK","CK_XALQCF2")	,TamSx3("CK_XALQCF2")[1]	,/*lPixel*/,{|| nAlqCof	})		// Al�quota de COFINS
TRCell():New(oVenProd,"VLTCOF"		,/*Tabela*/	,"Vl.Tot.COFINS"	 ,PesqPict("SCK","CK_XVLTCF2")	,TamSx3("CK_XVLTCF2")[1]	,/*lPixel*/,{|| nVltCof	})		// Valor Total de COFINS
TRCell():New(oVenProd,"ALQICM"		,/*Tabela*/	,"Aliq.ICM"			 ,PesqPict("SCK","CK_XALQICM")	,TamSx3("CK_XALQICM")[1]	,/*lPixel*/,{|| nAlqICM	})		// Al�quota de ICMS
TRCell():New(oVenProd,"VLTICM"		,/*Tabela*/	,"Vl.Tot.ICM"		 ,PesqPict("SCK","CK_XVLTICM")	,TamSx3("CK_XVLTICM")[1]	,/*lPixel*/,{|| nVltICM	})		// Valor Total de ICMS
TRCell():New(oVenProd,"ALQSOL"		,/*Tabela*/	,"Alq.Sol"			 ,PesqPict("SCK","CK_XALQSOL")	,TamSx3("CK_XALQSOL")[1]	,/*lPixel*/,{|| nAlqSol	})		// Al�quota de ICMS-ST
TRCell():New(oVenProd,"VLTSOL"		,/*Tabela*/	,"Vl.Tot.Sol"		 ,PesqPict("SCK","CK_XVLTSOL")	,TamSx3("CK_XVLTSOL")[1]	,/*lPixel*/,{|| nVltSol	})		// Valor Total de ICMS-ST
TRCell():New(oVenProd,"VEND1"		,/*Tabela*/ ,"Vendedor 1"		 ,PesqPict("SC5","CJ_XVEND1")	,TamSx3("CJ_XVEND1")[1]		,/*lPixel*/,{|| cVend1	})		// Cod. Vendedor 1
TRCell():New(oVenProd,"NOMVEND1"	,/*Tabela*/ ,"Nome"				 ,PesqPict("SC5","CJ_XVEND1")	,TamSx3("CJ_XVEND1")[1]		,/*lPixel*/,{|| cNomVen1})		// Nome do Vendedor 1
TRCell():New(oVenProd,"FECHAMENTO"	,/*Tabela*/ ,"Prev.Fechamento"	 ,PesqPict("ZA9","ZA9_XFUFEC")	,TamSx3("ZA9_XFUFEC")[1]	,/*lPixel*/,{|| dXFuFec })		// Data de Previs�o de fechamento da proposta
TRCell():New(oVenProd,"PROXIMO"		,/*Tabela*/	,"Prox. Contato"	 ,PesqPict("ZA9","ZA9_XFUPRX")	,TamSx3("ZA9_XFUPRX")[1]	,/*lPixel*/,{|| dXFuprx })		// Data de previs�o do pr�ximo contato
TRCell():New(oVenProd,"ULTIMO"		,/*Tabela*/	,"Ult.Contato"		 ,PesqPict("ZA9","ZA9_XFUULT")	,TamSx3("ZA9_XFUULT")[1]	,/*lPixel*/,{|| dXFuUlt })		// Data do ultimo contato realizado   
TRCell():New(oVenProd,"OBRAS"		,/*Tabela*/ ,"Ref. Obras"		 ,PesqPict("SCJ","CJ_XOBRAS")	,TamSx3("CJ_XOBRAS")[1]		,/*lPixel*/,{|| cXObras })		// Ref. Obras
TRCell():New(oVenProd,"STATUS"		,/*Tabela*/ ,"Status"		 	 ,PesqPict("SCJ","CJ_STATUS")	,TamSx3("CJ_STATUS")[1]		,/*lPixel*/,{|| cStatus })		// Status
TRCell():New(oVenProd,"ST FOLLOW UP",/*Tabela*/ ,"Status FlwUP"		 ,PesqPict("ZA9","ZA9_XFUST")	,TamSx3("ZA9_XFUST")[1]		,/*lPixel*/,{|| cStFup })		// Status Follow Up //#5035
TRCell():New(oVenProd,"CONTATO"		,/*Tabela*/ ,"Contato"			 ,PesqPict("SCJ","CJ_XCONTAT")	,TamSx3("CJ_XCONTAT")[1]	,/*lPixel*/,{|| cXcont })		// Contato			//#6227
TRCell():New(oVenProd,"TEL CONTATO" ,/*Tabela*/ ,"Tel Contato"		 ,PesqPict("SCJ","CJ_XTELCON")	,TamSx3("CJ_XTELCON")[1]	,/*lPixel*/,{|| cXtelco })		// Telefone Contato //#6227
TRCell():New(oVenProd,"EMAIL CONTAT",/*Tabela*/ ,"Email Contato"	 ,PesqPict("SCJ","CJ_XEMCON")	,TamSx3("CJ_XEMCON")[1]		,/*lPixel*/,{|| cXemcon })		// Email Contato 	//#6227
TRCell():New(oVenProd,"CONSULTOR"	,/*Tabela*/ ,"Consultor"		 ,PesqPict("SCJ","CJ_XCONSUL")	,TamSx3("CJ_XCONSUL")[1]	,/*lPixel*/,{|| cXconsu })		// Consultor 		//#6227

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

Local cXTpVenCod
Local cXStatus 		//#5035
Private cXStFup		//#5035
Private cStFup		//#5035
Private cXcont		//#6227
Private	cXtelco		//#6227
Private	cXemcon		//#6227
Private	cXconsu		//#6227


//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SCJ")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN CK_DT1VEN AS DATE

		SELECT 
			CK_FILIAL,CK_ITEM,CK_PRODUTO,CK_UM,CK_QTDVEN,CK_PRCVEN,CK_VALOR,CK_TES,CK_CLIENTE,CK_LOJA,
			CK_DESCONT,CK_NUM,CK_DESCRI,CK_PRUNIT,CK_CLASFIS,CK_DT1VEN,CK_XITEMP,CK_XVLUTAB,CK_XVLTBRU,CK_XACRESC,
			CK_XVLTIPI,CK_XALQPS2,CK_XVLTPS2,CK_XALQCF2,CK_XVLTCF2,CK_XALQICM,CK_XVLTICM,CK_XALQSOL,CK_XVLTSOL,
			CJ_EMISSAO,CJ_XFECENT,CJ_XTPVEN, CJ_XVEND1, CJ_XOBRAS, CJ_XTPVEN, CJ_XCONTAT, CJ_XTELCON, CJ_XEMCON, CJ_XCONSUL,
			(SELECT SA3.A3_NOME  FROM %Table:SA3% SA3 WHERE SA3.A3_FILIAL = %xFilial:SA3% AND SA3.A3_COD = SCJ.CJ_XVEND1 AND SA3.D_E_L_E_T_ = '') AS NOMEVEN,
			(SELECT SA3.A3_GEREN FROM %Table:SA3% SA3 WHERE SA3.A3_FILIAL = %xFilial:SA3% AND SA3.A3_COD = SCJ.CJ_XVEND1 AND SA3.D_E_L_E_T_ = '') AS CODGEN,
			(SELECT MAX(R_E_C_N_O_) FROM %Table:ZA9% ZA9 WHERE ZA9.ZA9_FILIAL = %xFilial:ZA9% AND ZA9.ZA9_XNUMOR = SCK.CK_NUM AND ZA9.D_E_L_E_T_ = '') AS RECZA9,
			CJ_STATUS
		FROM 
			%Table:SCK% SCK,
			%Table:SCJ% SCJ
		WHERE 
			SCK.CK_FILIAL = SCJ.CJ_FILIAL AND
			SCK.CK_NUM    = SCJ.CJ_NUM AND 
			SCK.CK_CLIENTE= SCJ.CJ_CLIENTE AND
			SCK.CK_LOJA   = SCJ.CJ_LOJA AND
			SCJ.CJ_STATUS NOT IN ('C') AND
			CJ_XTPVEN <> '30' AND

			SCK.CK_FILIAL >= %Exp:MV_PAR01% AND
			SCK.CK_FILIAL <= %Exp:MV_PAR02% AND
			SCK.CK_NUM    >= %Exp:MV_PAR03% AND
			SCK.CK_NUM    <= %Exp:MV_PAR04% AND
			SCJ.CJ_EMISSAO>= %Exp:MV_PAR05% AND
			SCJ.CJ_EMISSAO<= %Exp:MV_PAR06% AND
			SCK.%NotDel% AND
			SCJ.%NotDel% 
			
		ORDER BY
			%Order:SCK,1%
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
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->CK_CLIENTE+(cAliasQry)->CK_LOJA))

	If (cAliasQry)->RECZA9 <> 0
		lPosZA9	:= .T.
		ZA9->(dbGoto((cAliasQry)->RECZA9))
	Else
		lPosZA9	:= .F.
	EndIf

	dEmissao	:= substring(dtos(SCJ->CJ_EMISSAO),7,2)+"/"+SUBSTRING(dtos(SCJ->CJ_EMISSAO),5,2)+"/"+SUBSTRING(dtos(SCJ->CJ_EMISSAO),3,2)
	cVend1		:= (cAliasQry)->CJ_XVEND1 	//(cAliasQry)->CJ_XVEND1
	cNomVen1	:= (cAliasQry)->NOMEVEN 	//Posicione('SA3',1,XFILIAL('SA3') +(cAliasQry)->CJ_XVEND1 ,'A3_NOME')
	cCodGer		:= (cAliasQry)->CODGEN		//Posicione('SA3',1,XFilial('SA3') +(cAliasQry)->CJ_XVEND1 ,'A3_GEREN')
	cNomGer		:= Posicione('SA3',1,XFilial('SA3') +cCodGer,'A3_NOME')
	cXFami		:= Posicione('SB1',1,XFilial('SB1') +(cAliasQry)->CK_PRODUTO, 'B1_XFAMILI')
	dDtEntr		:= substring(dtos((cAliasQry)->CJ_XFECENT),7,2)+"/"+SUBSTRING(dtos((cAliasQry)->CJ_XFECENT),5,2)+"/"+SUBSTRING(dtos((cAliasQry)->CJ_XFECENT),3,2)//SCJ->CJ_XFECENT
	cXObras		:= (cAliasQry)->CJ_XOBRAS
	
	cXTpVenCod := AllTrim((cAliasQry)->CJ_XTPVEN)
	If cXTpVenCod == "1"
		cXTpVen		:= "1 - Projeto"
	ElseIf cXTpVenCod == "2"
		cXTpVen		:= "2 - Venda Unitaria"
	ElseIf cXTpVenCod  == "3"
		cXTpVen		:= "3 - Dealer"
	ElseIf cXTpVenCod == "4"
		cXTpVen		:= "4 - E-Commerce"
	ElseIf cXTpVenCod == "5"
		cXTpVen		:= "5 - Pronta Entrega"
	ElseIf cXTpVenCod == "6"
		cXTpVen		:= "6 - Projeto-Dealer"
	ElseIf cXTpVenCod == "7"
		cXTpVen		:= "7 - Venda Pecas"
	ElseIf cXTpVenCod == "8"
		cXTpVen		:= "8 - Sup.Tecnico"
	ElseIf cXTpVenCod == "9"
		cXTpVen		:= "9 - ARE"
	ElseIf cXTpVenCod == "10"
		cXTpVen		:= "10 - Serv"
	ElseIf cXTpVenCod == "11"
		cXTpVen		:= "11 - Itens Falta"
	ElseIf cXTpVenCod == "12"
		cXTpVen		:= "12 - SAC"
	ElseIf cXTpVenCod == ""
		cXTpVen		:= ""
	Endif	

	cVend1		:= (cAliasQry)->CJ_XVEND1
	cNomVen1	:= (cAliasQry)->NOMEVEN //Posicione('SA3',1,XFILIAL('SA3') +(cAliasQry)->CJ_XVEND1 ,'A3_NOME')
	cCodGer		:= (cAliasQry)->CODGEN	//Posicione('SA3',1,XFilial('SA3') +(cAliasQry)->CJ_XVEND1 ,'A3_GEREN')
	cNomGer		:= Posicione('SA3',1,XFilial('SA3') +cCodGer,'A3_NOME')
	dDtEntr		:= (cAliasQry)->CJ_XFECENT
	cXObras		:= (cAliasQry)->CJ_XOBRAS	
	dEmissao	:= substring(dtos((cAliasQry)->CJ_EMISSAO),7,2)+"/"+SUBSTRING(dtos((cAliasQry)->CJ_EMISSAO),5,2)+"/"+SUBSTRING(dtos((cAliasQry)->CJ_EMISSAO),3,2)//SCJ->CJ_EMISSAO

	If lPosA1
		cNome	:= SA1->A1_NOME
		cRegiao	:= SA1->A1_DSCREG
		cEstado	:= SA1->A1_EST
		cMunicio:= SA1->A1_MUN	//#5914

	Else
		cNome	:= ""
		cRegiao	:= ""
		cEstado := ""
		cMunicio:= ""	//#5914
	Endif

	If lPosZA9
		dXFuFec := substring(dtos(ZA9->ZA9_XFUFEC),7,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUFEC),5,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUFEC),3,2)//ZA9->ZA9_XFUFEC
		dXFuprx	:= substring(dtos(ZA9->ZA9_XFUPRX),7,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUPRX),5,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUPRX),3,2)//ZA9->ZA9_XFUPRX
		dXFuUlt := substring(dtos(ZA9->ZA9_XFUULT),7,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUULT),5,2)+"/"+SUBSTRING(dtos(ZA9->ZA9_XFUULT),3,2)//ZA9->ZA9_XFUULT
  		cXStFup  := ZA9->ZA9_XFUST 	

           
	Else
		dXFuFec := CTOD("  /  /  ")
        dXFuprx	:= CTOD("  /  /  ")
		dXFuUlt	:= CTOD("  /  /  ")
		cXStFup	:= ""
	
	Endif

	cItem	    := (cAliasQry)->CK_ITEM
	cProd		:= (cAliasQry)->CK_PRODUTO
	cUM			:= (cAliasQry)->CK_UM
	nQtdVen		:= (cAliasQry)->CK_QTDVEN
	nPrcUnit	:= (cAliasQry)->CK_PRCVEN
	nValTot		:= (cAliasQry)->CK_VALOR
	cTES		:= (cAliasQry)->CK_TES
	cCodCli		:= (cAliasQry)->CK_CLIENTE
	cCodLoj		:= (cAliasQry)->CK_LOJA
	nDesc		:= (cAliasQry)->CK_DESCONT
	cNum		:= (cAliasQry)->CK_NUM
	cDescr		:= (cAliasQry)->CK_DESCRI
	nPrcList	:= (cAliasQry)->CK_PRUNIT
	cPosIpi		:= (cAliasQry)->CK_CLASFIS
	dDt1Ven		:= substring(dtos((cAliasQry)->CK_DT1VEN),7,2)+"/"+SUBSTRING(dtos((cAliasQry)->CK_DT1VEN),5,2)+"/"+SUBSTRING(dtos((cAliasQry)->CK_DT1VEN),3,2)
	cItemP		:= (cAliasQry)->CK_XITEMP
	nVluTab		:= (cAliasQry)->CK_XVLUTAB
	nVltBru		:= (cAliasQry)->CK_XVLTBRU
	nAcres		:= (cAliasQry)->CK_XACRESC
	nVltIpi		:= (cAliasQry)->CK_XVLTIPI
	nAlqPis		:= (cAliasQry)->CK_XALQPS2
	nVltPis		:= (cAliasQry)->CK_XVLTPS2
	nAlqCof		:= (cAliasQry)->CK_XALQCF2
	nVltCof		:= (cAliasQry)->CK_XVLTCF2
	nAlqICM		:= (cAliasQry)->CK_XALQICM
	nVltICM		:= (cAliasQry)->CK_XVLTICM
	nAlqSol		:= (cAliasQry)->CK_XALQSOL
	nVltSol		:= (cAliasQry)->CK_XVLTSOL
	//cStatus     := (cAliasQry)->CJ_STATUS
    
	cXStatus := AllTrim((cAliasQry)->CJ_STATUS) //#5035
	If cXStatus 	== "A"
		cStatus		:= "A - Aberto"
	ElseIf cXStatus == "B"
		cStatus		:= "B - Aprovado"
	ElseIf cXStatus == "C"
		cStatus		:= "C - Cancelado"
	ElseIf cXStatus == "D"
		cStatus		:= "D - N�o Or�ado"
	Endif
	
	cXcont  := AllTrim((cAliasQry)->CJ_XCONTAT)
	cXtelco := AllTrim((cAliasQry)->CJ_XTELCON)
	cXemcon := AllTrim((cAliasQry)->CJ_XEMCON)
	cXconsu := AllTrim((cAliasQry)->CJ_XCONSUL)

    //ZA9_XFUST - Status Follow Up
	
	cStFup:= ""

    If cXStFup 	    == "1"
		cStFup		:= "1 - Projeto Cancelado"
	ElseIf cXStFup  == "2"
		cStFup		:= "2 - Perdido"
	ElseIf cXStFup  == "3"
		cStFup		:= "3 - Em Andamento"
	ElseIf cXStFup  == "4"
		cStFup		:= "4 - Substituido"
	Endif

	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return
