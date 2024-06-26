#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M34R05   � Autor � Cleber Maldonado      � Data � 21/06/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Cubagem                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M34R05()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 21/06/19 ���
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
oReport := TReport():New("M34R05","VERBAS - FOLHA DE PAGAMENTO","M34R05", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de verbas da" + " folha de pagamento.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SRV","SRC"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SRC","RC_FILIAL")	,TamSx3("RC_FILIAL")[1]		,/*lPixel*/,{|| cXFilial})		// Filial
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/ ,"Cod. Verba"		 ,PesqPict("SRC","RC_PD")		,TamSx3("RC_PD")[1]		    ,/*lPixel*/,{|| cCodVerb})		// C�digo da Verba
TRCell():New(oVenProd,"DESCR"		,/*Tabela*/ ,"Descricao"		 ,PesqPict("SRV","RV_DESC")		,TamSx3("RV_DESC")[1]		,/*lPixel*/,{|| cDescri	})		// Descri��o da Verba
TRCell():New(oVenProd,"CDEBITO"		,/*Tabela*/	,"Conta Debitoo"	 ,PesqPict("SRV","RV_DEBITO")	,TamSx3("RV_DEBITO")[1]		,/*lPixel*/,{|| cContDeb})		// C�digo da Conta D�bito
TRCell():New(oVenProd,"CCREDITO"	,/*Tabela*/ ,"Conta Credito"	 ,PesqPict("SRV","RV_CREDITO")	,TamSx3("RV_CREDITO")[1]	,/*lPixel*/,{|| cContCre})		// C�digo da Conta Cr�dito
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"			 	 ,PesqPict("SRC","RC_TIPO1")	,TamSx3("RC_TIPO1")[1]	    ,/*lPixel*/,{|| cTipoCod})		// Tipo de C�digo - Valor / Horas
TRCell():New(oVenProd,"HORAS"		,/*Tabela*/ ,"Horas Lanc."		 ,PesqPict("SRC","RC_HORAS")  	,TamSx3("RC_HORAS")[1]		,/*lPixel*/,{|| nHoras	})		// Lan�amento em Horas
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/ ,"Vlr. Lanc."		 ,PesqPict("SRC","RC_VALOR")	,TamSx3("RC_VALOR")[1] 		,/*lPixel*/,{|| nValor	})		// Lan�amento em Valor 
TRCell():New(oVenProd,"DATAPGTO"	,/*Tabela*/ ,"Dt.Pgto."			 ,PesqPict("SRC","RC_DATA")		,TamSx3("RC_DATA")[1]		,/*lPixel*/,{|| dDatPgto})		// Data do Pagamento
TRCell():New(oVenProd,"DATAREF"		,/*Tabela*/ ,"Dt.Ref."			 ,PesqPict("SRC","RC_DTREF")	,TamSx3("RC_DTREF")[1]		,/*lPixel*/,{|| dDatRef	})		// Data de Refer�ncia
TRCell():New(oVenProd,"CCUSTO"		,/*Tabela*/ ,"Centro de Custo"	 ,PesqPict("SRC","RC_CC")	    ,TamSx3("RC_CC")[1] 		,/*lPixel*/,{|| cCenCu	})		// C�digo do Centro de Custo
TRCell():New(oVenProd,"PERIODO"		,/*Tabela*/ ,"Periodo"	         ,PesqPict("SRC","RC_PERIODO")  ,TamSx3("RC_PERIODO")[1] 	,/*lPixel*/,{|| cPeriodo})		// Per�odo ( Ano+Mes )

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

Private lPosB1	:= .F.
Private lPosB5	:= .F.

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SRC")		
dbSetOrder(1)

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			RC_FILIAL,RC_PD,RC_HORAS,RC_VALOR,RC_DATA,RC_DTREF,RC_CC,RC_PERIODO,RC_TIPO1
		FROM 
			%Table:SRC% SRC
		WHERE 
			SRC.RC_PERIODO >= %Exp:MV_PAR01% AND 
			SRC.%NotDel%
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
dbSelectArea("SRV")
dbSetOrder(1)
dbSelectArea("SRC")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cXFilial	:= (cAliasQry)->RC_FILIAL
	cCodVerb	:= (cAliasQry)->RC_PD
	cDescri     := Posicione("SRV",1,(cAliasQry)->RC_FILIAL+(cAliasQry)->RC_PD,"RV_DESC")	
	cContDeb	:= Posicione("SRV",1,(cAliasQry)->RC_FILIAL+(cAliasQry)->RC_PD,"RV_DEBITO")
	cContCre	:= Posicione("SRV",1,(cAliasQry)->RC_FILIAL+(cAliasQry)->RC_PD,"RV_CREDITO")
	cTipoCod	:= (cAliasQry)->RC_TIPO1
	nHoras		:= (cAliasQry)->RC_HORAS
	nValor      := (cAliasQry)->RC_VALOR
	dDatPgto    := (cAliasQry)->RC_DATA
    dDatRef     := (cAliasQry)->RC_DTREF
    cCenCu      := (cAliasQry)->RC_CC
    cPeriodo    := (cAliasQry)->RC_PERIODO
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return
