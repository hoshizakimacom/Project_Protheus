#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
                
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M04R05   � Autor � Marcos Rocha          � Data � 30/10/23 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Invent�rio - ACD                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Macom - Temporario devido a erros monitor ACD   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M04R05()

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
���Programa  �ReportDef � Autor � Marcos Rocha          � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
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
oReport := TReport():New("M04R05","An�lise Inventario ACD","M04R05", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite divergencias de inventario !")
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
oVenProd := TRSection():New(oReport,"Analise Inventario ACD",{"CBA","CBC"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"CODINV"		,/*Tabela*/	,"Cod.Inv."	 		 ,PesqPict("SB2","B2_COD")		,TamSx3("B2_COD")[1]		,/*lPixel*/,{|| cCodInv})		// C�digo do Produto
TRCell():New(oVenProd,"LOCEST"		,/*Tabela*/ ,"Armazem"			 ,PesqPict("SB2","B2_LOCAL")	,TamSx3("B2_LOCAL")[1]		,/*lPixel*/,{|| cLocal	})		// Armazem de estoque
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"		     ,PesqPict("SB1","B1_COD")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cProduto})		// Descri��o do Produto
TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descri�ao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})		// Descri��o do Produto
TRCell():New(oVenProd,"QTD_PRIM"	,/*Tabela*/ ,"Prim.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQPrim   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_SEGUM"	,/*Tabela*/ ,"Segum.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQSegum })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_TERC"	,/*Tabela*/ ,"terc.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQTerc  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"SLDEST"	    ,/*Tabela*/ ,"Sld.Est. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQEst   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"OBSERVACAI"  ,/*Tabela*/ ,"Observacao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cObserva})		// Descri��o do Produto

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �                  	    � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SB1")		// Cadastro do produto
dbSetOrder(1)			// Produto,Local

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

	SELECT CODINV, PRODUTO, LOCEST, 
	QTD_PRIM,
	QTD_SEGUM,
	QTD_TERC, 
	SLDEST,
	(CASE WHEN SLDEST > 0  AND QTD_PRIM = 0  THEN '1A CONTAGEM PENDENTE' 
	  	WHEN SLDEST > 0  AND QTD_SEGUM = 0 THEN '2A CONTAGEM PENDENTE' 
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM = QTD_SEGUM AND QTD_PRIM = SLDEST  THEN 'CONTAGEM COMPLETA - OK COM SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM = QTD_SEGUM AND QTD_PRIM <> SLDEST THEN 'CONTAGEM COMPLETA - DIF SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC = 0      THEN 'FAZER 3A CONTAGEM' 
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC <> 0 AND QTD_TERC = SLDEST  THEN '3A CONTAGEM OK - OK COM SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC <> 0 AND QTD_TERC <> SLDEST THEN '3A CONTAGEM OK - DIF SLD'
	  	ELSE 'ANALISAR' END ) OBSERVACAO
		  FROM (
	SELECT CODINV, PRODUTO, LOCEST, 
	SUM(QTD_PRIM) QTD_PRIM,
	SUM(QTD_SEGUM) QTD_SEGUM,
	SUM(QTD_TERC) QTD_TERC, 
	SUM(SLDEST) SLDEST
	FROM (

	SELECT CBG_CODINV CODINV, CBG_CODPRO PRODUTO, CBG_ARM LOCEST, 
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '1' THEN CBG_QTDE ELSE 0 END ) QTD_PRIM,
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '2' THEN CBG_QTDE ELSE 0 END ) QTD_SEGUM,
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '3' THEN CBG_QTDE ELSE 0 END ) QTD_TERC,
	(SELECT B2_QATU FROM SB2010 SB2 WHERE B2_FILIAL = '01' 
    	AND B2_COD = CBG_CODPRO
     	AND B2_LOCAL = CBG_ARM
	  	AND D_E_L_E_T_ <> '*' )  SLDEST

	FROM %Table:CBG% CBG
	WHERE CBG_FILIAL = '01' 
	AND CBG_CODINV  %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
	AND CBG_CODPRO  %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND 
	AND CBG_QTDE <> 0
	AND CBG.%NotDel% ) TAB 
	GROUP BY CODINV, PRODUTO, LOCEST ) TAB2

	EndSql 

	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cCodiInv  := (cAliasQry)->CODINV
	cLocal	  := (cAliasQry)->LOCEST
	cOperador := (cAliasQry)->OPERAD

	cProduto  := (cAliasQry)->PRODUTO
	cDesc     := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->PRODUTO,"B1_DESC"),30)
	nQPrim    := (cAliasQry)->QTD_PRIM
	nQSegum   := (cAliasQry)->QTD_SEGUM
	nQTerc    := (cAliasQry)->QTD_TERC
	nQEst     := (cAliasQry)->SLDEST
	cObserva  := (cAliasQry)->OBSERVACAO



	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	nComp	:= 0
	nLarg	:= 0
	nAlt	:= 0
	nPeso	:= 0
	nM3		:= 0

	(cAliasQry)->(dbSkip())
EndDo
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()


Return(oReport)
