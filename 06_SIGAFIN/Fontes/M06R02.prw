#INCLUDE 'PROTHEUS.CH'
#Include 'TopConn.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#INCLUDE 'totvs.ch'
//#Include 'matr540.ch'

		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relat�rio de comissoes", "Relatorio de Comiss�es" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emiss�o Do Relat�rio De Comiss�es.", "Emissao do relatorio de Comissoes." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Relat�rio de comiss�es ", "RELATORIO DE COMISSOES " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "(pgt Pela Emiss�o)", "(PGTO PELA EMISSAO)" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "(pgt Pela Baixa)", "(PGTO PELA BAIXA)" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Relat�rio De Comissoes", "RELATORIO DE COMISSOES" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Prf N�mero   Parc. C�digo  Do              Lj  Nome                                 Dt.base     Vencto      Data        Data       N�mero          Valor           Valor      %           Valor    Tipo", "PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     VENCTO      DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "    T�tulo         Cliente                                                         Comiss�o    Origem      Liquida��o       Pgt      Pedido         T�tulo            Base               Comiss�o   Comiss�o", "    TITULO         CLIENTE                                                         COMISSAO    ORIGEM      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0012 "Vendedor : "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total do vendedor --> ", "TOTAL DO VENDEDOR --> " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Total  crial      --> ", "TOTAL  GERAL      --> " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total  de ir      --> ", "TOTAL  DE IR      --> " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Total (-) ir      --> ", "TOTAL (-) IR      --> " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ajuste", "AJUSTE" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Anal�tico", "ANALITICO" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Sint�tico", "SINTETICO" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "C�digo Do Vendedor                                           Total            Total      %            Total           Total           Total", "CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "                                                         T�tulo             Base                Comiss�o              Ir          (-) Ir", "                                                         TITULO             BASE                COMISSAO              IR          (-) IR" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Detalhes : t�tulos de origem da liquida��o ", "Detalhes : Titulos de origem da liquida��o " )
		#define STR0024 "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq."
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Relat�rio de comissoes", "Relatorio de Comiss�es" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Emiss�o Do Relat�rio De Comiss�es.", "Emissao do relatorio de Comissoes." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Total De T�tulo", "Total Titulo" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Total Ir", "Total IR" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Total (-) Ir", "Total (-) IR" )
		#define STR0030 "Total Base"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Total Comiss�o", "Total Comissao" )
		#define STR0032 "%"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Vencto De Origem", "Vencto Origem" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Dt.levantamento", "Dt.Baixa" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Vlr De T�tulo", "Vlr Titulo" )
		#define STR0036 "Vlr Base"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Ajuste", "AJUSTE" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Comiss�o", "Comissao" )
		#define STR0039 "Pedido"
		#define STR0040 "Tipo"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Por Vendedor", "por Vendedor" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "T�tulos Origem Da Liquida��o", "Titulos Origem da Liquidacao" )
		#define STR0043 "Data Liq."
		#define STR0044 "Vlr. Liq."
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Vlr.base Liq.", "Vlr.Base Liq." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Por Vendedor+prefixo+t�tulo+parcela", "Por Vendedor+Prefixo+Titulo+Parcela" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Por Vendedor+cliente+loja+prefixo+t�tulo+parcela", "Por Vendedor+Cliente+Loja+Prefixo+Titulo+Parcela" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Comiss�es (anal�tico)", "Comissoes (Analitico)" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Comiss�es (sint�tico)", "Comissoes (Sintetico)" )
		#define STR0050 "Vendedores"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Comiss�es s/ Liquida��o", "Comissoes s/ Liquidacao" )
		#define STR0052 "Total Geral"
		#define STR0053 "Titulo"
		#define STR0054 "Perc."
		#define STR0055 "Comiss�o"

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR540  � Autor � Marco Bianchi            � Data � 23/05/06 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Comissoes.                                       ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR540(void)                                                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                      ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function M06R02()

Local oReport
Private cAliasQry := GetNextAlias()

#IFDEF TOP
   Private cAlias    := cAliasQry
#ELSE
   Private cAlias    := "SE3"
#ENDIF

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()  
Else
	U_M06R02R3()
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data �23/05/2006���
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
Local oComissaoA
Local oComissaoS
Local oDetalhe
Local oTotal,oGeral
Local cVend  		:= ""
Local dVencto   	:= CTOD( "" ) 
Local dBaixa    	:= CTOD( "" ) 
Local nVlrTitulo	:= 0
Local nBasePrt  	:= 0
Local nComPrt   	:= 0
Local cTipo     	:= ""
Local cLiquid 
Local aValLiq   	:= {}
Local nI2       	:= 0
Local aLiqProp  	:= {}
Local nValIR    	:= 0
Local nTotSemIR 	:= 0
Local nAc1			:= 0
Local nAc2			:= 0
Local nAc3      	:= 0
Local nDecPorc		:= TamSX3("E3_PORC")[2]
Local nTamData  	:= Len(DTOC(MsDate()))
Local lRndIrrf	:= GetMV("MV_RNDIRF")

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
oReport := TReport():New("M06R02",STR0025,"MTR540", {|oReport| ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal,oGeral)},STR0026)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte("MTR540",.F.)
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
oComissaoA := TRSection():New(oReport,STR0050,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoA:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//� Analitico                                                              �
//��������������������������������������������������������������������������
TRCell():New(oComissaoA,"PERIODO" ,/*Tabela*/	,/*Titulo*/		,/*Picture*/    	,45	         ,/*lPixel*/  ,{|| cPeriodo })
TRCell():New(oComissaoA,"E3_VEND" ,"SE3"		,/*Titulo*/		,/*Picture*/        ,/*Tamanho*/ ,/*lPixel*/  ,{|| cVend })
TRCell():New(oComissaoA,"A3_NOME" ,"SA3"		,/*Titulo*/		,/*Picture*/        ,/*Tamanho*/ ,/*lPixel*/  ,{|| SA3->A3_NOME })
TRCell():New(oComissaoA,"A3_GEREN","SA3"		,"Gerente"		,/*Picture*/	    ,/*Tamanho*/ ,/*lPixel*/  ,{|| SA3->A3_GEREN})
TRCell():New(oComissaoA,"A3_NOME" ,"SA3"		,/*Titulo*/		,/*Picture*/		,/*Tamanho*/ ,/*lPixel*/  ,{|| Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_NOME")})	

// Titulos da Comissao
oDetalhe := TRSection():New(oComissaoA,STR0048,{"SE3","SA3","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oDetalhe:SetTotalInLine(.F.)
oDetalhe:SetHeaderBreak(.T.)
TRCell():New(oDetalhe,"E3_PREFIXO" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_NUM"		,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,{|| E3_NUM })
TRCell():New(oDetalhe,"E3_PARCELA" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_CODCLI"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"A1_NREDUZ"	,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oDetalhe,"A1_NOME"		,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30)  })
TRCell():New(oDetalhe,"E3_EMISSAO"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"DVENCTO"		,"    ",STR0033   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dVencto })
TRCell():New(oDetalhe,"DBAIXA"		,"    ",STR0034   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dBaixa })
TRCell():New(oDetalhe,"E3_DATA"		,cAlias,/*Titulo*/,/*Picture*/               ,nTamData  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_PEDIDO"	,cAlias,STR0039   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"NVLRTITULO"	,"    ",STR0035,PesqPict('SE3','E3_BASE')	 ,TamSx3("E3_BASE"	)[1],/*lPixel*/,{|| 5,5 }) //nVlrTitulo })
TRCell():New(oDetalhe,"NBASEPRT"	,"    ",STR0036,PesqPict('SE3','E3_BASE')	 ,TamSx3("E3_BASE"	)[1],/*lPixel*/,{|| nBasePrt })
TRCell():New(oDetalhe,"E3_PORC"		,cAlias,STR0032,PesqPict('SE3','E3_PORC')	 ,TamSx3("E3_PORC"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"NCOMPRT"		,"    ",STR0038,PesqPict('SE3','E3_COMIS')   ,TamSx3("E3_COMIS" )[1],/*lPixel*/,{|| nComPrt })
TRCell():New(oDetalhe,"E3_BAIEMI"	,cAlias,STR0040,/*Picture*/                  ,/*Tamanho*/  ,/*lPixel*/,{|| Substr(cTipo,1,1) })
TRCell():New(oDetalhe,"AJUSTE"		,"    ",STR0037,/*Picture*/                  ,/*Tamanho*/  ,/*lPixel*/,{|| ""})

// Titulos de Liquidacao
oLiquida := TRSection():New(oDetalhe,STR0051,{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oLiquida:SetTotalInLine(.F.)
TRCell():New(oLiquida,"E1_NUMLIQ" 	,"   ",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,{|| cLiquid })
TRCell():New(oLiquida,"E1_PREFIXO"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_NUM"	    ,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_PARCELA" 	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_TIPO"   	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_CLIENTE"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_LOJA"		,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oLiquida,"A1_NREDUZ"	,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NREDUZ")[1],/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oLiquida,"A1_NOME"		,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NOME")[1],/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30) })

TRCell():New(oLiquida,"E1_VALOR"		,"SE1",/*Titulo*/ ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"NVALLIQ1"		,"   ",STR0043    ,/*Picture*/                ,nTamData	     		,/*lPixel*/,{|| aValLiq[nI2,1] })
TRCell():New(oLiquida,"NVALLIQ2"		,"   ",STR0044    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aValLiq[nI2,2] })
TRCell():New(oLiquida,"NLIQPROP"		,"   ",STR0045    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aLiqProp[nI2] })

//-- Secao Totalizadora do Valor do IR e Total (-) IR
oTotal := TRSection():New(oReport,"",{},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTotal,"TOTALIR"     ,"   ",STR0028,"@E 99,999,999.99",12         ,/*lPixel*/,{|| If(lRndIrrf,Round(nValIR,TamSX3("E2_IRRF")[2]),NoRound(nValIR,TamSX3("E2_IRRF")[2])) })
TRCell():New(oTotal,"TOTSEMIR"    ,"   ",STR0029,"@E 99,999,999.99",12         ,/*lPixel*/,{|| nTotSemIR })  

//-- TOTAL GERAL
oGeral := TRSection():New(oTotal,"",{},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oGeral, "TXTTOTAL"          , "" , STR0052  , , 08 ,/*lPixel*/,{ || "" } )
TRCell():New(oGeral, "GERAL"	         , "" , STR0053  , PesqPict('SE3','E3_COMIS')    	, TamSX3("E3_COMIS")[1]   ,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oGeral, "PERCENT"	         , "" , STR0054  , PesqPict("SE3","E3_PORC" )   	, TamSX3("E3_PORC" )[1]   ,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oGeral, "COMIS"		     , "" , STR0055  , PesqPict('SE3','E3_COMIS')    	, TamSX3("E3_COMIS")[1]   ,/*lPixel*/,/*CodeBlock*/)

//������������������������������������������������������������������������Ŀ
//� Sintetico                                                              �
//��������������������������������������������������������������������������
oComissaoS := TRSection():New(oReport,STR0049,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoS:SetTotalInLine(.F.)

TRCell():New(oComissaoS,"E3_VEND" ,"SE3",/*Titulo*/,/*Picture*/                	,/*Tamanho*/          	,/*lPixel*/	,{|| cVend })
TRCell():New(oComissaoS,"A3_NOME" ,"SA3",/*Titulo*/,/*Picture*/					,/*Tamanho*/          	,/*lPixel*/	,{|| SA3->A3_NOME })
TRCell():New(oComissaoS,"TOTALTIT",""	  ,STR0027   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc3 })
TRCell():New(oComissaoS,"E3_BASE" ,cAlias ,STR0030   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc1 })
TRCell():New(oComissaoS,"E3_PORC" ,cAlias ,STR0032   ,PesqPict('SE3','E3_PORC') 	,TamSx3("E3_PORC")[1] 	,/*lPixel*/	,{||NoRound((nAc2*100) / nAc1),2})
TRCell():New(oComissaoS,"E3_COMIS",cAlias ,STR0031   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{|| nAc2 })
TRCell():New(oComissaoS,"VALIR"   ,""     ,STR0028   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{|| If(lRndIrrf,Round(nValIR,TamSX3("E2_IRRF")[2]),NoRound(nValIR,TamSX3("E2_IRRF")[2])) })
TRCell():New(oComissaoS,"TOTSEMIR",""     ,STR0029   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{||nTotSemIR})

//������������������������������������������������������������������������Ŀ
//� Impressao do Cabecalho no topo da pagina                               �
//��������������������������������������������������������������������������
oReport:Section(1):SetHeaderPage()
oReport:Section(3):SetHeaderPage() 
oReport:Section(1):Setedit(.T.)
oReport:Section(1):Section(1):Setedit(.T.)
oReport:Section(1):Section(1):Section(1):Setedit(.T.)
oReport:Section(2):Setedit(.F.)

//������������������������������������������������������������������������Ŀ
//� Alinhamento a direita dos campos de valores                            �
//��������������������������������������������������������������������������
//Analitico
oDetalhe:Cell("NVLRTITULO"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NBASEPRT"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NCOMPRT"):SetHeaderAlign("RIGHT")
//Sintetico
oComissaoS:Cell("TOTALTIT"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_BASE" ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_COMIS"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("VALIR"   ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")

//IR
oTotal:Cell("TOTALIR"):SetHeaderAlign("RIGHT")
oTotal:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")       

//TOTAL GERAL
oGeral:Cell("TXTTOTAL"):SetHeaderAlign("RIGHT")
oGeral:Cell("GERAL"   ):SetHeaderAlign("RIGHT") 
oGeral:Cell("PERCENT" ):SetHeaderAlign("RIGHT")
oGeral:Cell("COMIS"   ):SetHeaderAlign("RIGHT")

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Eduardo Riera          � Data �04.05.2006���
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
Static Function ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal,oGeral)

Local lQuery   := .F.
Local dEmissao := CTOD( "" ) 
Local nTotLiq  := 0
Local aLiquid  := {}
Local ny 
Local cWhere   := ""
Local cNomArq, cFilialSE1, cFilialSE3
Local nI       := 0
Local cOrder   := ""
Local nDecs
Local nTotPorc	:= 0
Local nTotPerVen	:= 0
Local nTotPerGer	:= 0

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

Local cDocLiq   := ""
Local cTitulo   := ""                                     
Local cAjuste   := ""
Local nTotBase	:= 0
Local nTotComis	:= 0
Local nSection	:= 0
Local nOrdem	:= 0
Local nTGerBas  := 0
Local nTGerCom  := 0
Local cFilSE1	:= "" 
Local cFilSE3   := "" 
Local cFilSA1   := "" 
Local lVend	    := .F.
Local lFirst    := .F.
Local lRndIrrf	:= GetMV("MV_RNDIRF")

If oReport:Section(1):GetOrder() == 1		// Ordem: por Titulo
	nOrdem := 1
Else										// Ordem: por Cliente
	nOrdem := 2
EndIf	

If mv_par12 == 1	// Analitico
	oReport:Section(3):Disable()
	nSection := 1   
	
	If mv_par14 == 1
		oReport:Section(1):section(1):Cell("A1_NOME"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NOME"):Disable()
	Else
		oReport:Section(1):section(1):Cell("A1_NREDUZ"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NREDUZ"):Disable()
	EndIf
	oReport:Section(1):Cell("E3_VEND"):SetBlock({|| cVend })	
	oReport:Section(1):Section(1):Cell("DVENCTO" ):SetBlock({|| dVencto })	
	oReport:Section(1):Section(1):Cell("DBAIXA" ):SetBlock({|| dBaixa })	
	oReport:Section(1):Section(1):Cell("NVLRTITULO" ):SetBlock({|| nVlrTitulo })	
	oReport:Section(1):Section(1):Cell("NBASEPRT" ):SetBlock({|| nBasePrt })	
	oReport:Section(1):Section(1):Cell("NCOMPRT" ):SetBlock({|| nComPrt })	
	oReport:Section(1):Section(1):Cell("E3_BAIEMI" ):SetBlock({|| Substr(cTipo,1,1) })	
	oReport:Section(1):Section(1):Cell("AJUSTE" ):SetBlock({|| IIf( (cAjuste == "S" .And. MV_PAR07 == 1),"AJUSTE","" ) })	
	oReport:Section(1):Section(1):Section(1):Cell("E1_NUMLIQ" ):SetBlock({|| cLiquid  })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ1" ):SetBlock({|| aValLiq[nI2,1] })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ2" ):SetBlock({|| aValLiq[nI2,2] })	
	oReport:Section(1):Section(1):Section(1):Cell("NLIQPROP" ):SetBlock({|| aLiqProp[nI2] })	
	oReport:Section(2):Cell("TOTALIR" ):SetBlock({|| If(lRndIrrf,Round(nValIR,TamSX3("E2_IRRF")[2]),NoRound(nValIR,TamSX3("E2_IRRF")[2])) })	
	oReport:Section(2):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	
	
	oReport:SetPageFooter(20, {|| RodapeApr(oReport)})

    bVOrig := { || cDocLiq := SE1->E1_NUMLIQ, nVlrTitulo := Iif(cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA, nVlrTitulo, 0 ) }
   
	TRFunction():New(oDetalhe:Cell("NVLRTITULO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,bVOrig,.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NBASEPRT")  ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NCOMPRT")   ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict('SE3','E3_COMIS'),/*uFormula*/,.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)	
	TRFunction():New(oDetalhe:Cell("E3_PORC")   ,/* cID */,"ONPRINT",/*oBreak*/,/*cTitle*/,PesqPict('SE3','E3_PORC'),{|| nTotPorc },.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	
	If mv_par10 > 0
		TRFunction():New(oTotal:Cell("TOTALIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oTotal:Cell("TOTSEMIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	EndIf	

	cVend		:= ""
	dVencto 	:= ctod("  /  /  ")
	dBaixa 		:= ctod("  /  /  ")
	nVlrTitulo 	:= 0
	nBasePrt 	:= 0
	nComPrt 	:= 0
	cTipo 		:= ""
	cLiquid  	:= ""
	nValIR		:= 0
	nTotSemIR 	:= 0
	
Else				// Sintetico

	TRFunction():New(oComissaoS:Cell("TOTALTIT"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_BASE"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_PORC"),/* cID */,"ONPRINT",/*oBreak*/,/*cTitle*/,PesqPict('SE3','E3_PORC'),{||nTotPorc},.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_COMIS"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict('SE3','E3_COMIS'),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("VALIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("TOTSEMIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
              
	oReport:Section(1):Disable()
	oReport:Section(1):Section(1):Disable()
	oReport:Section(1):Section(1):Section(1):Disable()
	nSection := 3
	
	oReport:Section(3):Cell("E3_VEND" ):SetBlock({|| cVend })		
	oReport:Section(3):Cell("TOTALTIT" ):SetBlock({|| nAc3 })		
	oReport:Section(3):Cell("E3_BASE" ):SetBlock({|| nAc1 })		
	oReport:Section(3):Cell("E3_PORC" ):SetBlock({||NoRound((nAc2*100) / nAc1,TamSX3("E3_PORC")[2]) })		
	oReport:Section(3):Cell("E3_COMIS" ):SetBlock({||nAc2 })		
	oReport:Section(3):Cell("VALIR" ):SetBlock({|| If(lRndIrrf,Round(nValIR,TamSX3("E2_IRRF")[2]),NoRound(nValIR,TamSX3("E2_IRRF")[2])) })	
	oReport:Section(3):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	

	cVend		:= ""
	nAc1		:= 0
	nAc2		:= 0
	nAc3		:= 0
	nValIR		:= 0
	nTotSemIR	:= 0
	
EndIf
If len(oReport:Section(1):GetAdvplExp("SE1")) > 0
   cFilSE1 := oReport:Section(1):GetAdvplExp("SE1")
EndIf
If len(oReport:Section(3):GetAdvplExp("SE3")) > 0
   cFilSE3 := oReport:Section(3):GetAdvplExp("SE3")
EndIf
If len(oReport:Section(1):GetAdvplExp("SA1")) > 0
   cFilSA1 := oReport:Section(1):GetAdvplExp("SA1")
EndIf
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������

#IFDEF TOP

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "%E3_FILIAL,E3_VEND,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "%E3_FILIAL,E3_VEND,E3_CODCLI,E3_LOJA,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	EndIf	

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	lQuery := .T.                 
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)	
	
	oReport:Section(nSection):BeginQuery()
	cWhere :="%"             
	If mv_par01 == 1
		cWhere += "AND E3_BAIEMI <> 'B'"  //Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cWhere += "AND E3_BAIEMI =  'B'"  //Baseado pela baixa do titulo
	EndIf
	If mv_par06 == 1 		//Comissoes a pagar
		cWhere += "AND E3_DATA = '" + Dtos(Ctod("")) + "'"
	ElseIf mv_par06 == 2 //Comissoes pagas
		cWhere += "AND E3_DATA <> '" + Dtos(Ctod("")) + "'"
	Endif
	If ValType(mv_par15) == "N"
		If mv_par15 <> 1 // Todos
			If mv_par15 == 2 // Parceiros
				cWhere += "AND A3_TIPO = 'P'"
			ElseIf mv_par15 == 3 // Vendedores
				cWhere += "AND A3_TIPO <> 'P'"
			EndIf
		EndIf
	EndIf
	cWhere +="%"
	
	BEGIN REPORT QUERY oDetalhe
		BeginSql Alias cAliasQry
		SELECT E3_FILIAL,E3_BASE, E3_COMIS, E3_VEND, E3_PORC, A3_NOME, E3_PREFIXO,E3_NUM, E3_PARCELA,E3_TIPO,E3_CODCLI,E3_LOJA,E3_AJUSTE,E3_BAIEMI,E3_EMISSAO,E3_DATA, E3_PEDIDO
			FROM %table:SE3% SE3
			LEFT JOIN %table:SA3% SA3
		        ON A3_COD = E3_VEND
			WHERE A3_FILIAL = %xFilial:SA3%
				AND E3_FILIAL = %xFilial:SE3%
	
				AND	E3_EMISSAO >= %Exp:Dtos(mv_par02)%
				AND E3_EMISSAO <= %Exp:Dtos(mv_par03)%
				AND SE3.E3_VEND BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR05%
				AND SA3.%NotDel%
				AND SE3.%notdel%
				%Exp:cWhere%
		ORDER BY %Exp:cOrder%
		EndSql
	END REPORT QUERY oDetalhe 
	
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(nSection):EndQuery()


#ELSE
   
	//����������������������������������������������������������������������������������������������������Ŀ
	//�Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX �
	//������������������������������������������������������������������������������������������������������
	MakeAdvplExpr("MTR540") 

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "E3_FILIAL+E3_VEND+E3_PREFIXO+E3_NUM+E3_PARCELA"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA"
	EndIf	
	
	DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
	DbSetOrder(3)			// Por Vendedor, Cliente, Loja, Prefixo, Numero
	cFilialSE3 := xFilial()
	cNomArq    := CriaTrab("",.F.)
	
	cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
	
	If !Empty(mv_par04)
		cCondicao +=  " .AND. "+MV_PAR04
	EndIf
	
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'"	
	                                 
	If mv_par01 == 1
		cCondicao += " .AND. SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cCondicao += " .AND. SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
	Endif	
		
	If mv_par06 == 1 		// Comissoes a pagar
		cCondicao += " .AND. Dtos(SE3->E3_DATA)== '"+Dtos(Ctod(""))+"'"
	ElseIf mv_par06 == 2 // Comissoes pagas
		cCondicao += " .AND. Dtos(SE3->E3_DATA)!= '"+Dtos(Ctod(""))+"'"
	Endif
	
	oReport:Section(nSection):SetFilter(cCondicao,cOrder)      // abre tela de imprimindo...
	
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(nSection),"SA3",1,{|| xFilial("SA3")+cVend })
//TRPosition():New(oReport:Section(nSection),"SE3",2,{|| xFilial("SE3")+cVend+(cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_SEQ})
If mv_par12 == 1
   TRPosition():New(oReport:Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA })
   TRPosition():New(oReport:Section(1):Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA })
EndIf   


//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
If mv_par12 == 2 .Or. mv_par12 == 1 
	nTotBase	:= 0
	nTotComis	:= 0
EndIf

dbSelectArea(cAlias)
dbGoTop()
nDecs     := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))

oReport:SetMeter(SE3->(LastRec()))
dbSelectArea(cAlias)

cPeriodo	:= "De: "+DTOC(MV_PAR02) + " At�: "+DTOC(MV_PAR03)

While !oReport:Cancel() .And. !&(cAlias)->(Eof())
	
	cVend := &(cAlias)->(E3_VEND)
	nAc1 := 0
	nAc2 := 0
	nAc3 := 0
	nTotPerVen := 0
	
	oReport:Section(nSection):Init()
	If mv_par12 == 1 .And. Empty(cFilSE1) .And. Empty(cFilSE3) .And. Empty(cFilSA1)
		oReport:Section(nSection):PrintLine()
	EndIf	

	lVend:= .T. 
	lFirst := .T. 
	While !Eof() .And. xFilial("SE3") == (cAlias)->E3_FILIAL .And. (cAlias)->E3_VEND == cVend
		nBasePrt   := 0
		nComPrt    := 0
		nVlrTitulo := 0
		If mv_par12 == 1 
			nTotBase	:= 0
			nTotComis	:= 0
		EndIf

		dbSelectArea("SE3")
		dbSetOrder(2)
		dbSeek(xFilial("SE3")+cVend+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM)+&(cAlias)->(E3_PARCELA))
						
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM)+&(cAlias)->(E3_PARCELA)+&(cAlias)->(E3_TIPO))

		// Se nao imprime detalhes da origem, desconsidera titulos faturados
		If mv_par13 <> 1 .And. !Empty(SE1->E1_FATURA) .And. SE1->E1_FATURA <> "NOTFAT"
			(cAliasQry)->( dbSkip() )
			Loop
		EndIf

	   // Verifica filtro do usuario
	   	If !Empty(cFilSE1) .And. !(&cFilSE1)
		   dbSelectArea(cAliasQry)	
	       dbSkip()
		   Loop
		ElseIf !Empty(cFilSE1) .And. (&cFilSE1) .And. lFirst
			oReport:Section(nSection):PrintLine()
			lFirst := .F.    
		EndIf 
		If!Empty(cFilSE3) .And. !(cAliasQry)->(&cFilSE3)
		   dbSelectArea(cAliasQry)	
	       dbSkip()
		   Loop
		ElseIf !Empty(cFilSE3) .And. (cAliasQry)->(&cFilSE3) .And. lVend 
			If mv_par12 == 1
				oReport:Section(nSection):PrintLine()       
				lVend:= .F.
			EndIf   
		EndIf
		If!Empty(cFilSA1) 
		   	SA1->(dbSetOrder(1))               
			If SA1->(dbSeek(xFilial()+&(cAlias)->(E3_CODCLI)+&(cAlias)->(E3_LOJA)))
				If !( SA1->&cFilSa1)	
		  			dbSelectArea(cAliasQry)	
				   	dbSkip()
					Loop
				ElseIf (SA1->&cFilSA1) .And. lVend
					oReport:Section(nSection):PrintLine()
					lVend := .F.	
				EndIf	
		   	EndIf 
		EndIf 		   	
		If nModulo == 12 
			nVlrTitulo:= Round(xMoeda((cAlias)->E3_BASE,SE1->E1_MOEDA,MV_PAR08,(cAlias)->E3_EMISSAO,nDecs+1),nDecs)
		Else
			nVlrTitulo:= Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		EndIf	
		dEmissao  := SE1->E1_EMISSAO
		cLiquid   := ""
		cDocLiq   := SE1->E1_NUMLIQ
		
		If mv_par12 == 1
			dVencto   := SE1->E1_VENCTO
			aLiquid	  := {}
			aValLiq	  := {}
			aLiqProp  := {}
			nTotLiq	  := 0
			If mv_par13 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
				cLiquid := SE1->E1_NUMLIQ
				cDocLiq := SE1->E1_NUMLIQ
				// Obtem os registros que deram origem ao titulo gerado pela liquidacao
				Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
				For ny := 1 to Len(aValLiq)
					nTotLiq += aValLiq[ny,2]
				Next
				For ny := 1 to Len(aValLiq)
					aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
				Next
			Endif
			
			If (cAlias)->E3_BAIEMI == "B"
				dBaixa     := (cAlias)->E3_EMISSAO
			Else
				dBaixa     := SE1->E1_BAIXA
			Endif
		EndIf
		
		If Eof()

			dbSelectArea("SF1")
			dbSetOrder(1)

			dbSelectArea("SF2")
			dbSetorder(1)
			
			If AllTrim((cAlias)->E3_TIPO) == "NCC"
				SF1->(dbSeek(xFilial("SF1")+(cAlias)->E3_NUM+(cAlias)->E3_PREFIXO+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA,.t.))
			    nVlrTitulo := Round(xMoeda(SF1->F1_VALMERC,SF1->F1_MOEDA,mv_par08,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA),nDecs)
			    dEmissao   := SF1->F1_DTDIGIT
			Else
		   		dbSeek(xFilial()+(cAlias)->E3_NUM+(cAlias)->E3_PREFIXO)
				nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
		 		dEmissao   := SF2->F2_EMISSAO
			EndIf
			
			If mv_par12 == 1
				dVencto    := CTOD( "" )
				dBaixa     := CTOD( "" )  	
			EndIf
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM))
				While ( !Eof() .And. (cAlias)->E3_PREFIXO == SE1->E1_PREFIXO .And.;
					(cAlias)->E3_NUM == SE1->E1_NUM .And.;
					(cAlias)->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == (cAlias)->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == (cAlias)->E3_CODCLI .And. ;
						SE1->E1_LOJA == (cAlias)->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						
						If mv_par12 == 1
							dVencto    := CTOD( "" )
							dBaixa     := CTOD( "" )
						EndIf

						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
						
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif
		
		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		nBasePrt:=	Round(xMoeda((cAlias)->E3_BASE ,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda((cAlias)->E3_COMIS,1,MV_PAR08,dEmissao,TamSx3("E3_COMIS")[2]+1),TamSx3("E3_COMIS")[2])
		
		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif
		
		If mv_par12 == 1
			cAjuste := (cAlias)->E3_AJUSTE
			cTipo   := (cAlias)->E3_BAIEMI
			dbSelectArea(cAlias)
			oReport:Section(1):Section(1):Init()
 			oReport:Section(1):Section(1):PrintLine()
  			oReport:IncMeter()
			
			If mv_par13 == 1
				For nI := 1 To Len(aLiquid)
					nI2 := nI
					SE1->(MsGoto(aLiquid[nI]))
				    oReport:Section(1):SetHeaderBreak(.T.)
					oReport:Section(1):Section(1):Section(1):Init()
					oReport:Section(1):Section(1):Section(1):PrintLine()
				Next
				If Len(aLiquid) > 0
					oReport:Section(1):Section(1):Section(1):Finish()
				EndIf
			Endif			
			
		EndIf
		
		nAc1 += nBasePrt
		nAc2 += nComPrt
		nTotPerVen += (nBasePrt*(cAlias)->E3_PORC)/100
		nTotPerGer += nTotPerVen
		If cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA 
			nAc3   += nVlrTitulo
			cTitulo:= (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA
			cDocLiq:= ""
		EndIf
		
		dbSelectArea(cAlias)
		dbSkip()
	EndDo
	
	If mv_par12 == 1
		nTotBase 	+= nAc1
		nTotComis 	+= nAc2
		nTotPorc	:= NoRound((nTotComis / nTotBase)*100,TamSx3("E3_COMIS")[2])
		nTotPerVen  := NoRound((nTotPerVen/nAc1)*100,TamSx3("E3_PORC")[2])
		oReport:Section(1):Section(1):SetTotalText("Total do Vendedor " + cVend)
		oReport:Section(1):Section(1):Finish()
	EndIf
	
	nValIR    := 0
	nTotSemIR := 0
	If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
		nValIR    := nAc2 * (MV_PAR10/100)
		nTotSemIR := nAc2 - (nAc2 * (MV_PAR10/100))
	Else
		nTotSemIR := nAc2
	EndIf
	
	If mv_par12 == 2
		nTotBase 	+= nAc1
		nTotComis 	+= nAc2
		nTotPorc	:= NoRound((nTotComis / nTotBase)*100,TamSx3("E3_COMIS")[2])
		nTotPerVen  := NoRound((nTotPerVen/nAc1)*100,TamSx3("E3_PORC")[2])
		oReport:Section(nSection):Init()				
		oReport:Section(nSection):PrintLine()
	EndIf	
	oReport:Section(nSection):Finish()
	
	If mv_par12 == 1 .And. mv_par10 > 0
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	EndIf
	
	If mv_par11 == 1
	   oReport:Section(nSection):SetPageBreak(.T.)
	EndIf
	
	If mv_par12 == 2
		oReport:IncMeter()
	EndIf
	
	nTGerBas    += nAc1
    nTGerCom    += nAc2
	
EndDo

nTotPorc := ((nTGerCom*100)/nTGerBas) 
 
If mv_par11 == 1
	oGeral:SetPageBreak(.T.)
	oGeral:Cell("TXTTOTAL"):SetSize(21)
	oGeral:Cell("GERAL"   ):SetBlock  ( { || nTGerBas } ) 
	oGeral:Cell("PERCENT" ):SetBlock  ( { || nTotPorc } )
	oGeral:Cell("COMIS"   ):SetBlock  ( { || nTGerCom } ) 
	oGeral:Init()
	oGeral:PrintLine()
	oGeral:Finish()
	oGeral:SetPageBreak(.T.)
EndIf 

#IFNDEF TOP
   RetIndex("SE3")
#ENDIF
   


Return


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR540R3� Autor � Claudinei M. Benzi       � Data � 13.04.92 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Comissoes.                                       ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR540(void)                                                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                      ���
�����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������� 
����������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Programad.�ALTERACAO                                      ���
����������������������������������������������������������������������������Ĵ��
���05.02.03�XXXXXX�Eduardo Ju�Inclusao de Queries para filtros em TOPCONNECT.���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function M06R02R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel
Local titulo    := STR0001  //"Relatorio de Comissoes"
Local cDesc1    := STR0002  //"Emissao do relatorio de Comissoes."
Local tamanho   := "G"
Local limite    := 220
Local cString   := "SE3"
Local cAliasAnt := Alias()
Local cOrdemAnt := IndexOrd()
Local nRegAnt   := Recno()
Local cDescVend := " "

Private aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:= "M06R02"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "MTR540"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR540",.F.)

//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos      �
//� mv_par02        	// A partir da data                       �
//� mv_par03        	// Ate a Data                             �
//� mv_par04 	    	// Do Vendedor                            �
//� mv_par05	     	// Ao Vendedor                            �
//� mv_par06	     	// Quais (a Pagar/Pagas/Ambas)            �
//� mv_par07	     	// Incluir Devolucao ?                    �
//� mv_par08	     	// Qual moeda                             �
//� mv_par09	     	// Comissao Zerada ?                      �
//� mv_par10	     	// Abate IR Comiss                        �
//� mv_par11	     	// Quebra pag.p/Vendedor                  �
//� mv_par12	     	// Tipo de Relatorio (Analitico/Sintetico)�
//� mv_par13	     	// Imprime detalhes origem                �
//� mv_par14         // Nome cliente							  �
//�����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := "M06R02"
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C540Imp(@lEnd,wnRel,cString)},Titulo)

//��������������������������������������������������������������Ŀ
//� Retorna para area anterior, indice anterior e registro ant.  �
//����������������������������������������������������������������
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C540IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR540			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function C540Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local tamanho  := "G"
Local limite   := 220
Local nomeprog := "M06R02"
Local imprime  := .T.
Local cPict    := ""
Local cTexto,j :=0,nTipo:=0
Local cCodAnt,nCol:=0
Local nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,nAc4:=0,nAg4:=0,lFirstV:=.T.
Local nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
Local lContinua:= .T.
Local cNFiscal :=""
Local aCampos  :={}
Local lImpDev  := .F.
Local cBase    := ""
Local cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
Local nDecs    := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
Local nBasePrt :=0, nComPrt:=0 
Local aStru    := SE3->(dbStruct()), ni
Local nDecPorc := TamSX3("E3_PORC")[2]
Local nVlrTitulo := 0
Local nTotPerVen := 0
Local nTotPerGer := 0
Local lRndIrrf	:= GetMV("MV_RNDIRF")

Local cDocLiq   := ""
Local cTitulo  := "" 
Local dEmissao := CTOD( "" ) 
Local nTotLiq  := 0
Local aLiquid  := {}
Local aValLiq  := {}
Local aLiqProp := {}
Local ny
Local aColuna := IIF(cPaisLoc <> "MEX",{15,19,42,46,83,95,107,119,130,137,153,169,176,195,203},{28,35,58,62,99,111,123,135,146,153,169,185,192,211,219})
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
If mv_par12 == 1
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif

	cabec1:=OemToAnsi(STR0009)	//"PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO"
	cabec2:=OemToAnsi(STR0010)	//"    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO"
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	If cPaisLoc == "MEX"
		Cabec1 := Substr(Cabec1,1,10) + Space(16) + Substr(Cabec1,11)
		Cabec2 := Substr(Cabec2,1,10) + Space(16) + Substr(Cabec2,11)
	EndIf								
Else
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif
	cabec1:=OemToAnsi(STR0021) //"CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
	cabec2:=OemToAnsi(STR0022) //"                                                         TITULO             BASE                COMISSAO              IR          (-) IR"
                                //"XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 123456789012,23  123456789012,23  99.99  123456789012,23 123456789012,23 123456789012,23
                                //"0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
                                //"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
EndIf

//��������������������������������������������������������������Ŀ
//� Monta condicao para filtro do arquivo de trabalho            �
//����������������������������������������������������������������

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'" 

If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif 

If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif

If mv_par09 == 1 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf

//��������������������������������������������������������������Ŀ
//� Cria expressao de filtro do usuario                          �
//����������������������������������������������������������������
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif

nAg1 := nAg2 := nAg3 := nAg4 := 0

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOrder := SqlOrder(SE3->(IndexKey()))
		
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE3")
		cQuery += " WHERE E3_FILIAL = '" + xFilial("SE3") + "' AND "
	  	cQuery += "	E3_VEND >= '"  + mv_par04 + "' AND E3_VEND <= '"  + mv_par05 + "' AND " 
		cQuery += "	E3_EMISSAO >= '" + Dtos(mv_par02) + "' AND E3_EMISSAO <= '"  + Dtos(mv_par03) + "' AND " 
		
		If mv_par01 == 1
			cQuery += "E3_BAIEMI <> 'B' AND "  //Baseado pela emissao da NF
		Elseif mv_par01 == 2
			cQuery += "E3_BAIEMI =  'B' AND "  //Baseado pela baixa do titulo  
		EndIf	
		
		If mv_par06 == 1 		//Comissoes a pagar
			cQuery += "E3_DATA = '" + Dtos(Ctod("")) + "' AND "
		ElseIf mv_par06 == 2 //Comissoes pagas
  			cQuery += "E3_DATA <> '" + Dtos(Ctod("")) + "' AND "
		Endif 
		
		If mv_par09 == 1 		//Nao Inclui Comissoes Zeradas
   		cQuery+= "E3_COMIS <> 0 AND "
		EndIf  
		
		cQuery += "D_E_L_E_T_ <> '*' "   

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)
											
		dbSelectArea("SE3")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE3', .F., .T.)
			
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE3', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next 
	Else
	
#ENDIF	
		//��������������������������������������������������������������Ŀ
		//� Cria arquivo de trabalho                                     �
		//����������������������������������������������������������������
		cChave := IndexKey()
		cNomArq :=CriaTrab("",.F.)
		IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi(STR0016)) //"Selecionando Registros..."
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3") 
		#IFNDEF TOP
			DbSetIndex(cNomArq+OrdBagExT())
		#ENDIF
		DbSetOrder(nIndex+1)

#IFDEF TOP
	EndIf
#ENDIF	

SetRegua(RecCount())		// Total de Elementos da regua 
DbGotop()
While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0011)  //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//��������������������������������������������������������������Ŀ
	//� Processa condicao do filtro do usuario                       �
	//����������������������������������������������������������������
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif
	
	nAc1 := nAc2 := nAc3 := nAc4 := 0 
	nTotPerVen := 0
	lFirstV:= .T.
	cVend  := SE3->E3_VEND
	
	While !Eof() .AND. SE3->E3_VEND == cVend
		IncRegua()
		cDocLiq:= ""
		//��������������������������������������������������������������Ŀ
		//� Processa condicao do filtro do usuario                       �
		//����������������������������������������������������������������
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif  
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//��������������������������������������������������������������Ŀ
		//� Seleciona o Codigo do Vendedor e Imprime o seu Nome          �
		//����������������������������������������������������������������
		IF lFirstV
			dbSelectArea("SA3")
			dbSeek(xFilial()+SE3->E3_VEND)
			If mv_par12 == 1
				cDescVend := SE3->E3_VEND + " " + A3_NOME 
				@li, 00 PSAY OemToAnsi(STR0012) + cDescVend //"Vendedor : "
				li+=2
			Else
				@li, 00 PSAY SE3->E3_VEND
				@li, 07 PSAY A3_NOME 
			EndIf
			dbSelectArea("SE3")
			lFirstV := .F.
		EndIF
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		                                                           
		// Se nao imprime detalhes da origem, desconsidera titulos faturados
		If mv_par13 <> 1 .And. !Empty(SE1->E1_FATURA) .And. SE1->E1_FATURA <> "NOTFAT"
			SE3->( dbSkip() )
			Loop
		EndIf

		If mv_par12 == 1
			@li, 00 PSAY SE3->E3_PREFIXO
			@li, 04 PSAY SE3->E3_NUM
			@li, aColuna[1] PSAY SE3->E3_PARCELA
			@li, aColuna[2] PSAY SE3->E3_CODCLI
			@li, aColuna[3] PSAY SE3->E3_LOJA
		
			dbSelectArea("SA1")
			dbSeek(xFilial()+SE3->E3_CODCLI+SE3->E3_LOJA)
			@li, aColuna[4] PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
		
			dbSelectArea("SE3")
			@li, aColuna[5] PSAY SE3->E3_EMISSAO
		EndIf
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dVencto    := SE1->E1_VENCTO  
		dEmissao   := SE1->E1_EMISSAO 
		aLiquid	  := {}
		aValLiq		:= {}
		aLiqProp	  	:= {}
		nTotLiq		:= 0
		If mv_par13 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
			cLiquid := SE1->E1_NUMLIQ			
			cDocLiq := SE1->E1_NUMLIQ
			// Obtem os registros que deram origem ao titulo gerado pela liquidacao
			Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
			For ny := 1 to Len(aValLiq)
				nTotLiq += aValLiq[ny,2]
			Next
			For ny := 1 to Len(aValLiq)
				aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
			Next
		Endif
		/*
		Nas comissoes geradas por baixa pego a data da emissao da comissao que eh igual a data da baixa do titulo.
		Isto somente dara diferenca nas baixas parciais
		*/	 
		
		If SE3->E3_BAIEMI == "B"
			dBaixa     := SE3->E3_EMISSAO
    	Else
			dBaixa     := SE1->E1_BAIXA
		Endif
		
		If Eof()

			dbSelectArea("SF1")
			dbSetOrder(1)

			dbSelectArea("SF2")
			dbSetorder(1)
			
			If AllTrim(SE3->E3_TIPO) == "NCC"
				SF1->(dbSeek(xFilial("SF1")+SE3->E3_NUM+SE3->E3_PREFIXO+SE3->E3_CODCLI+SE3->E3_LOJA,.t.))
			    nVlrTitulo := Round(xMoeda(SF1->F1_VALMERC,SF1->F1_MOEDA,mv_par07,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA),nDecs)
			    dEmissao   := SF1->F1_DTDIGIT
			Else
				dbSeek(xFilial()+SE3->E3_NUM+SE3->E3_PREFIXO)       
			    nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par07,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			    dEmissao   := SF2->F2_EMISSAO
			EndIf
			
			dVencto    := " "
			dBaixa     := " "
			
			dEmissao   := SF2->F2_EMISSAO 
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+SE3->E3_PREFIXO+SE3->E3_NUM)
				While ( !Eof() .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
						SE3->E3_NUM == SE1->E1_NUM .And.;
						SE3->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == SE3->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == SE3->E3_CODCLI .And. ;
						SE1->E1_LOJA == SE3->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						dVencto    := " "
						dBaixa     := " "
						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif


		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		//Preciso destes valores para pasar como parametro na funcao TM(), e como 
		//usando a xmoeda direto na impressao afetaria a performance (deveria executar
		//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
		//ser inicializadas aqui. Bruno.

		nBasePrt:=	Round(xMoeda(SE3->E3_BASE ,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda(SE3->E3_COMIS,1,MV_PAR08,dEmissao,TamSx3("E3_COMIS")[2]+1),TamSx3("E3_COMIS")[2])

		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif	
		
		dbSelectArea("SE3")
		
		If mv_par12 == 1
			@ li,aColuna[6]  PSAY dVencto
			@ li,aColuna[7]  PSAY dBaixa
			@ li,aColuna[8]  PSAY SE3->E3_DATA
			@ li,aColuna[9]  PSAY SE3->E3_PEDIDO	Picture "@!"
			@ li,aColuna[10] PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
			@ li,aColuna[11] PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
			@ li,aColuna[12] PSAY SE3->E3_PORC		Picture PesqPict('SE3','E3_PORC')
			@ li,aColuna[13] PSAY nComPrt			Picture PesqPict('SE3','E3_COMIS')
			@ li,aColuna[14] PSAY SE3->E3_BAIEMI

			If ( SE3->E3_AJUSTE == "S" .And. MV_PAR07==1)
				@ li,aColuna[15] PSAY STR0018 //"AJUSTE "
			EndIf
			li++
			// Imprime titulos que deram origem ao titulo gerado por liquidacao
			If mv_par13 == 1
				For nI := 1 To Len(aLiquid)
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					EndIF
					If nI == 1
						@ ++li, 0 PSAY __PrtThinLine()
						@ ++li, 0 PSAY STR0023 +SE1->E1_NUMLIQ // "Detalhes : Titulos de origem da liquida��o "
						@ ++li,10 PSAY STR0024 // "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq."
//         Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq.
//         XXX        XXXXXXXXXXXX    XXX     XXXX    XXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999999999     99/99/9999          999999999999999      999999999999999 
   					@ ++li, 0 PSAY __PrtThinLine()
						li++
					Endif
					cDocLiq  := SE1->E1_NUMLIQ
					SE1->(MsGoto(aLiquid[nI]))
					SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
					@li,  10 PSAY SE1->E1_PREFIXO
					@li,  21 PSAY SE1->E1_NUM
					@li,  37 PSAY SE1->E1_PARCELA
					@li,  45 PSAY SE1->E1_TIPO
					@li,  53 PSAY SE1->E1_CLIENTE
					@li,  64 PSAY SE1->E1_LOJA
					@li,  71 PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
					@li, 111 PSAY SE1->E1_VALOR PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 132 PSAY aValLiq[nI,1] 
					@li, 151 PSAY aValLiq[nI,2] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 172 PSAY aLiqProp[nI] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					li++
				Next
				// Imprime o separador da ultima linha
				If Len(aLiquid) >= 1
					@ li++, 0 PSAY __PrtThinLine()
				Endif
			Endif	
		EndIf
		nAc1 += nBasePrt
		nAc2 += nComPrt
		nTotPerVen += (nBasePrt*SE3->E3_PORC)/100
		If cTitulo <> SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA  .And. Empty(cDocLiq)
			nAc3   += nVlrTitulo
			cTitulo:= SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA
			cDocLiq:= ""
			
		ElseIf !Empty(cDocLiq)
			nAc3   += nVlrTitulo
			
		EndIf
		
		dbSelectArea("SE3")
		dbSkip()
	EndDo
	
	If mv_par12 == 1
		li++
	
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li, 00  PSAY OemToAnsi(STR0013)+cDescVend  //"TOTAL DO VENDEDOR --> "
		@ li,aColuna[10]-1  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,aColuna[11]-1  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
	
		If nAc1 != 0
			If cPaisLoc=="BRA"
				//@ li, aColuna[12] PSAY NoRound((nAc2/nAc1)*100,2)   PicTure "999.99"
				@ li, aColuna[12] PSAY NoRound((nTotPerVen/nAc1)*100,TamSx3("E3_PORC")[2])   PicTure PesqPict('SE3','E3_PORC')
			Else
				@ li, aColuna[12] PSAY NoRound((nAc2/nAc1)*100)   PicTure PesqPict('SE3','E3_PORC')
			Endif
		Endif
	
		@ li, aColuna[13]  PSAY nAc2 PicTure PesqPict('SE3','E3_COMIS')
		li++
	
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			nAc4 += If(lRndIrrf,Round((nAc2 * mv_par10 / 100),TamSx3("E2_IRRF")[2]),NoRound((nAc2 * mv_par10 / 100),TamSx3("E2_IRRF")[2]))
			@ li, aColuna[13]  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR      --> "
			@ li, aColuna[13] PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
			li ++
		EndIf
	
		@ li, 00  PSAY __PrtThinLine()

		If mv_par11 == 1  // Quebra pagina por vendedor (padrao)
			li := 60  
		Else
		   li+= 2
		Endif
	Else
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li,048  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,065  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, 081 PSAY NoRound((nAc2/nAc1)*100,TamSx3("E3_PORC")[2])  PicTure PesqPict('SE3','E3_PORC')
			Else
				@ li, 081 PSAY NoRound((nAc2/nAc1)*100)   PicTure PesqPict('SE3','E3_PORC')
			Endif
		Endif
		@ li, 089  PSAY nAc2 PicTure PesqPict('SE3','E3_COMIS')
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			nAc4 += If(lRndIrrf,Round((nAc2 * mv_par10 / 100),TamSx3("E2_IRRF")[2]),NoRound((nAc2 * mv_par10 / 100),TamSx3("E2_IRRF")[2]))
			@ li, 105  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			@ li, 121 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
		EndIf
		li ++
	EndIf
	
	dbSelectArea("SE3")
	nAg1 += nAc1
	nAg2 += nAc2
 	nAg3 += nAc3
 	nAg4 += nAc4
 	nTotPerGer += nTotPerVen
EndDo

If (nAg1+nAg2+nAg3+nAg4) != 0
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif

	If mv_par12 == 1
		@li,  00 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
		@li, aColuna[10]-1 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li, aColuna[11]-1 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			//@li, aColuna[12] PSAY NoRound((nAg2/nAg1)*100,2) Picture "999.99"
			@li, aColuna[12] PSAY NoRound((nTotPerGer/nAg1)*100,TamSx3("E3_PORC")[2])   PicTure PesqPict('SE3','E3_PORC')
		Else
			@li, aColuna[12] PSAY NoRound((nAg2/nAg1)*100) Picture PesqPict('SE3','E3_PORC')
		Endif
		@li, aColuna[13] PSAY nAg2 PicTure PesqPict('SE3','E3_COMIS')
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			li ++
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			@ li, 175  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR       --> "
			@ li, 175  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	Else
		@li,000  PSAY __PrtThinLine()
		li ++
		@li,000 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
		@li,048 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li,065 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li,081 PSAY NoRound((nAg2/nAg1)*100,TamSx3("E3_PORC")[2])   PicTure PesqPict('SE3','E3_PORC')
		Else
			@li,081 PSAY NoRound((nAg2/nAg1)*100) Picture PesqPict('SE3','E3_PORC')
		Endif
		@li,089 PSAY nAg2 Picture PesqPict('SE3','E3_COMIS')
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			@ li,105  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			@ li,121  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF
    
#IFDEF TOP
	If TcSrvType() != "AS/400"
  		dbSelectArea("SE3")
		DbCloseArea()
		chkfile("SE3")
	Else	
#ENDIF
		fErase(cNomArq+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

//��������������������������������������������������������������Ŀ
//� Restaura a integridade dos dados                             �
//����������������������������������������������������������������
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
dbClearFilter()

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RodapeApr � Autor � Cleber Maldonado		� Data � 28.09.17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Define a impress�o do rodap� de impress�o das assinaturas  ���
���          � de aprova��o.                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR540			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RodapeApr(oReport)
Local cNome     := ""
Local cTel      := Space(10)
Local cFax      := ""
Local cEMail    := ""
    
//oReport:ThinLine()
//oReport:SkipLine(2)

oReport:SkipLine(12)
oReport:PrintText("               ________________________________________               ________________________________________               ________________________________________               ________________________________________") 
oReport:SkipLine(2)
oReport:PrintText("                           FINANCEIRO                                          ASSISTENTE COMERCIAL                                     GERENTE COMERCIAL                                        DIRETOR COMERCIAL          ") 
oReport:SkipLine(2)
oReport:PrintText("                      ______/______/______                                     ______/______/______                                    ______/______/______                                     ______/______/______        ") 

Return Nil 
