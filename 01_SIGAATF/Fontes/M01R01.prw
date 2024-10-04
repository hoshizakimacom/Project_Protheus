#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M01R01   � Autor � Cleber Maldonado      � Data � 11/11/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Ativos                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAATF                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M01R01()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 16/11/17 ���
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
oReport := TReport():New("M01R01","Rela��o de Ativos","M01R01", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de ativos." + " " + " ")
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
oVenProd := TRSection():New(oReport,"RELA��O DE ATIVOS",{"SN1","SN3"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Ativos"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
// SN1 - DADOS DO ATIVO FIXO
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SN1","N1_FILIAL")	,TamSx3("N1_FILIAL")[1]		,/*lPixel*/,{|| cCodFil		})		// C�digo da Filial
TRCell():New(oVenProd,"GRUPO"		,/*Tabela*/ ,"Grupor"			 ,PesqPict("SN1","N1_GRUPO")	,TamSx3("N1_GRUPO")[1]		,/*lPixel*/,{|| cGrupo  	})		// Grupo do Bem
TRCell():New(oVenProd,"CBASE"		,/*Tabela*/ ,"Codigo Base"		 ,PesqPict("SN1","N1_CBASE")	,TamSx3("N1_CBASE")[1]		,/*lPixel*/,{|| cCodBase	})		// Codigo Base do Bem
TRCell():New(oVenProd,"ITEM"		,/*Tabela*/ ,"Item"				 ,PesqPict("SN1","N1_ITEM")		,TamSx3("N1_ITEM")[1]		,/*lPixel*/,{|| cItem		})		// C�digo do Item
TRCell():New(oVenProd,"AQUISIC"		,/*Tabela*/	,"Dt.Aquisicao"		 ,PesqPict("SN1","N1_AQUISIC")	,TamSx3("N1_AQUISIC")[1]	,/*lPixel*/,{|| dDtaAquis	})		// Data de Aquisicao        
TRCell():New(oVenProd,"QUANTIDADE"	,/*Tabela*/ ,"Quantidade"		 ,PesqPict("SN1","N1_QUANTD")	,TamSx3("N1_QUANTD")[1]		,/*lPixel*/,{|| nQuant		})		// Quantidade do Bem        
TRCell():New(oVenProd,"DTBAIXA"		,/*Tabebla*/,"Dt.de Baixa"		 ,PesqPict("SN1","N1_BAIXA")	,TamSx3("N1_BAIXA")[1]		,/*lPixel*/,{|| dDtBaixa 	})		// Data da Baixa
TRCell():New(oVenProd,"DESCR"		,/*Tabela*/ ,"Descr. Sint."		 ,PesqPict("SN1","N1_DESCRIC")	,TamSx3("N1_DESCRIC")[1]	,/*lPixel*/,{|| cDescr		})		// Descricao Sintetica      
TRCell():New(oVenProd,"CHAPA"		,/*Tabela*/ ,"Chapa"			 ,PesqPict("SN1","N1_CHAPA")	,TamSx3("N1_CHAPA")[1]		,/*lPixel*/,{|| cChapa	 	})		// Numero da Plaqueta
TRCell():New(oVenProd,"NFISCAL"		,/*Tabela*/ ,"Nt.Fiscal"		 ,PesqPict("SN1","N1_NFISCAL")	,TamSx3("N1_NFISCAL")[1]	,/*lPixel*/,{|| cNfiscal	})		// Numero da Nota Fiscal
TRCell():New(oVenProd,"CODCIAP"		,/*Tabela*/ ,"Cod.CIAP"			 ,PesqPict("SN1","N1_CODCIAP")	,TamSx3("N1_CODCIAP")[1]	,/*lPixel*/,{|| cCodCiap	})		// Codigo CIAP
TRCell():New(oVenProd,"ICMSAPR"		,/*Tabela*/ ,"Icms do Item"		 ,PesqPict("SN1","N1_ICMSAPR")	,TamSx3("N1_ICMSAPR")[1]	,/*lPixel*/,{|| nIcmsApr	})		// Icms do Item
TRCell():New(oVenProd,"DTBLOQ"		,/*Tabela*/ ,"Dt.Bloqueio"		 ,PesqPict("SN1","N1_DTBLOQ")	,TamSx3("N1_DTBLOQ")[1]		,/*lPixel*/,{|| dDtBloq 	})		// Data para bloqueio
TRCell():New(oVenProd,"VLAQUIS"		,/*Tabela*/ ,"Vl.Aquisicao"		 ,PesqPict("SN1","N1_VLAQUIS")	,TamSx3("N1_VLAQUIS")[1]	,/*lPixel*/,{|| nVlrAquis	})		// Valor de Aquisicao
TRCell():New(oVenProd,"POSIPI"		,/*Tabela*/ ,"Pos.IPI/NCM"		 ,PesqPict("SN1","N1_XPOSIPI")	,TamSx3("N1_XPOSIPI")[1]	,/*lPixel*/,{|| cPosIpi		})		// Pos.IPI/NCM
TRCell():New(oVenProd,"PIS"			,/*Tabela*/ ,"PIS"				 ,PesqPict("SN1","N1_XPIS")		,TamSx3("N1_XPIS")[1]		,/*lPixel*/,{|| nXPis	 	})		// Valor do PIS
TRCell():New(oVenProd,"COFINS"		,/*Tabela*/ ,"COFINS"			 ,PesqPict("SN1","N1_XCOFINS")	,TamSx3("N1_XCOFINS")[1]	,/*lPixel*/,{|| nXCofins	})		// Valor do COFINS
TRCell():New(oVenProd,"DIFAL"		,/*Tabela*/ ,"DIFAL"			 ,PesqPict("SN1","N1_DIFAL")	,TamSx3("N1_DIFAL")[1]		,/*lPixel*/,{|| nDifal		})		// Valor do DIFAL
//SN3 - SALDOS E VALORES
TRCell():New(oVenProd,"CONTA"		,/*Tabela*/ ,"Conta Contabil"	 ,PesqPict("SN3","N3_CCONTAB")	,TamSx3("N3_CCONTAB")[1]	,/*lPixel*/,{|| cContab		})		// Conta Contabil
TRCell():New(oVenProd,"CCUSTO"		,/*Tabela*/ ,"C.Custo Bem"	 	 ,PesqPict("SN3","N3_CUSTBEM")	,TamSx3("N3_CUSTBEM")[1]	,/*lPixel*/,{|| cCustBem	})		// C Custo da Conta do Bem
TRCell():New(oVenProd,"CDESPDEPR"	,/*Tabela*/ ,"Cta.Desp.Dep." 	 ,PesqPict("SN3","N3_CDEPREC")	,TamSx3("N3_CDEPREC")[1]	,/*lPixel*/,{|| cCdePrec	})		// Conta Despesa Depreciacao
TRCell():New(oVenProd,"CCDESP"		,/*Tabela*/ ,"CC Despesa"	 	 ,PesqPict("SN3","N3_CCUSTO")	,TamSx3("N3_CCUSTO")[1]		,/*lPixel*/,{|| cCCusto		})		// Centro de Custo Despesa
TRCell():New(oVenProd,"CCDEPR"		,/*Tabela*/ ,"Cta.Dep.Acum." 	 ,PesqPict("SN3","N3_CCDEPR")	,TamSx3("N3_CCDEPR")[1]		,/*lPixel*/,{|| cCCdePr		})		// Conta Deprec. Acumulada  
TRCell():New(oVenProd,"DINDEPR"		,/*Tabela*/ ,"Dt.In.Deprec." 	 ,PesqPict("SN3","N3_DINDEPR")	,TamSx3("N3_DINDEPR")[1]	,/*lPixel*/,{|| dDtInDepr	})		// Data Inicio depreciacao  
TRCell():New(oVenProd,"FIMDEPR"		,/*Tabela*/ ,"Dt.Fim Deprec." 	 ,PesqPict("SN3","N3_FIMDEPR")	,TamSx3("N3_FIMDEPR")[1]	,/*lPixel*/,{|| dDtFimDepr	})		// Data fim da depreciacao  
TRCell():New(oVenProd,"VORIG1"		,/*Tabela*/ ,"Vlr.Orig.M1" 		 ,PesqPict("SN3","N3_VORIG1")	,TamSx3("N3_VORIG1")[1]		,/*lPixel*/,{|| nVlrOrg1 	})		// Valor Original Moeda 1
TRCell():New(oVenProd,"XVDEPAN"		,/*Tabela*/ ,"Vlr.Dep.Ant." 	 ,PesqPict("SN3","N3_XVDEPAN")	,TamSx3("N3_XVDEPAN")[1]	,/*lPixel*/,{|| nXVDepan	})		// Valor Deprec. Anterior   
TRCell():New(oVenProd,"VRDACM1"		,/*Tabela*/ ,"Depr.Acum.M1"		 ,PesqPict("SN3","N3_VRDACM1")	,TamSx3("N3_VRDACM1")[1]	,/*lPixel*/,{|| nVlrAcm1	})		// Correcao Deprecia��o Moeda1
TRCell():New(oVenProd,"VRDMES1"		,/*Tabela*/ ,"Depr.Mes M1"	 	 ,PesqPict("SN3","N3_VRDMES1")	,TamSx3("N3_VRDMES1")[1]	,/*lPixel*/,{|| nVldMes1	})		// Valor Depr. Mes Moeda 1  
TRCell():New(oVenProd,"TXDEPR1"		,/*Tabela*/ ,"Tx.An.Depr.1"	 	 ,PesqPict("SN3","N3_TXDEPR1")	,TamSx3("N3_TXDEPR1")[1]	,/*lPixel*/,{|| nTxDepr1	})		// Taxa Anual Depreciacao 1

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 21/11/17 ���
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
dbSelectArea("SN1")		// Ativo Fixo
dbSetOrder(1)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN N1_AQUISIC AS DATE	
		COLUMN N1_BAIXA   AS DATE
		COLUMN N3_DINDEPR AS DATE
		COLUMN N3_FIMDEPR AS DATE

		SELECT 
			SN1.N1_FILIAL,SN1.N1_GRUPO,SN1.N1_CBASE,SN1.N1_ITEM,SN1.N1_AQUISIC,SN1.N1_QUANTD,SN1.N1_BAIXA,SN1.N1_DESCRIC,SN1.N1_CHAPA,SN1.N1_NFISCAL,
			SN1.N1_CODCIAP,SN1.N1_ICMSAPR,SN1.N1_DTBLOQ,SN1.N1_VLAQUIS,SN1.N1_XPOSIPI,SN1.N1_XPIS,SN1.N1_XCOFINS,SN1.N1_DIFAL,SN3.N3_FILIAL,
			SN3.N3_CCONTAB,SN3.N3_CUSTBEM,SN3.N3_CDEPREC,SN3.N3_CCUSTO,SN3.N3_CCDEPR,SN3.N3_DINDEPR,SN3.N3_FIMDEPR,SN3.N3_VORIG1,SN3.N3_XVDEPAN,
			SN3.N3_VRDACM1,SN3.N3_VRDMES1,SN3.N3_TXDEPR1,SN3.N3_ITEM, SN3.N3_DTBAIXA
		FROM 
			%Table:SN1% SN1 
		INNER JOIN 
			%Table:SN3% SN3 
				ON  SN1.N1_FILIAL = SN3.N3_FILIAL AND
					SN1.N1_CBASE = SN3.N3_CBASE AND 
					SN1.N1_ITEM = SN3.N3_ITEM 
		WHERE 
			SN1.N1_FILIAL >= %Exp:MV_PAR01% AND
			SN1.N1_FILIAL <= %Exp:MV_PAR02% AND			
			SN1.N1_CHAPA >= %Exp:MV_PAR03% AND
			SN1.N1_CHAPA <= %Exp:MV_PAR04% AND
			SN1.N1_AQUISIC >= %Exp:MV_PAR05% AND
			SN1.N1_AQUISIC <= %Exp:MV_PAR06% AND
			SN1.N1_GRUPO >= %Exp:MV_PAR07% AND
			SN1.N1_GRUPO <= %Exp:MV_PAR08% AND
			SN3.N3_CCUSTO >= %Exp:MV_PAR09% AND
			SN3.N3_CCUSTO <= %Exp:MV_PAR10% AND
			SN1.%NotDel% AND
			SN3.%NotDel%
		ORDER BY 
			SN1.N1_FILIAL
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
dbSelectArea("SB5")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
	
	cCodFil		:= (cAliasQry)->N1_FILIAL
	cGrupo		:= (cAliasQry)->N1_GRUPO
	cCodBase	:= (cAliasQry)->N1_CBASE
	cItem		:= (cAliasQry)->N1_ITEM
	dDtaAquis	:= (cAliasQry)->N1_AQUISIC	
	nQuant		:= (cAliasQry)->N1_QUANTD
    dDtBaixa	:= (cAliasQry)->N3_DTBAIXA
    cDescr		:= (cAliasQry)->N1_DESCRIC
	cChapa		:= (cAliasQry)->N1_CHAPA
    cNfiscal	:= (cAliasQry)->N1_NFISCAL
    cCodCiap	:= (cAliasQry)->N1_CODCIAP
    nIcmsApr	:= (cAliasQry)->N1_ICMSAPR
    dDtBloq		:= (cAliasQry)->N1_DTBLOQ
	nVlrAquis	:= (cAliasQry)->N1_VLAQUIS
	cPosIpi		:= (cAliasQry)->N1_XPOSIPI
	nXPis		:= (cAliasQry)->N1_XPIS
	nXCofins	:= (cAliasQry)->N1_XCOFINS
	nDifal		:= (cAliasQry)->N1_DIFAL
	cContab		:= (cAliasQry)->N3_CCONTAB
	cCustBem	:= (cAliasQry)->N3_CUSTBEM
	cCdePrec	:= (cAliasQry)->N3_CDEPREC
	cCCusto		:= (cAliasQry)->N3_CCUSTO
	cCCdePr		:= (cAliasQry)->N3_CCDEPR
	dDtInDepr	:= (cAliasQry)->N3_DINDEPR
	dDtFimDepr	:= (cAliasQry)->N3_FIMDEPR
	nVlrOrg1	:= (cAliasQry)->N3_VORIG1
	nXVDepan	:= (cAliasQry)->N3_XVDEPAN
	nVlrAcm1	:= (cAliasQry)->N3_VRDACM1
	nVldMes1	:= (cAliasQry)->N3_VRDMES1
	nTxDepr1	:= (cAliasQry)->N3_TXDEPR1

	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return
