#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M05R13   � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Cubagem X Or�amentos                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R13()

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
oReport := TReport():New("M05R13","Cubagem x Or�amento","M05R13", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de cubagem por or�amento." + " " + " Ser� considerado somente dados da filial 01 e itens com saldo maior que zero.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SCK","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUM"			,/*Tabela*/ ,"Pedido"			,PesqPict("SCK","CK_NUM")		,TamSx3("CK_NUM")[1]+5		,/*lPixel*/,{|| cNum	})	// Numero do Or�amento
TRCell():New(oVenProd,"ITEM"		,/*Tabela*/ ,"Item"			 	,PesqPict("SCK","CK_ITEM")		,TamSx3("CK_ITEM")[1]		,/*lPixel*/,{|| cItem	})	// Item do Or�amento
TRCell():New(oVenProd,"PLANTA"		,/*Tabela*/ ,"Planta"			,PesqPict("SCK","CK_XITEMP")	,TamSx3("CK_XITEMP")[1]-10	,/*lPixel*/,{|| cPlanta	})	// Item Planta
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/ ,"C�digo"			,PesqPict("SC6","CK_PRODUTO")	,TamSx3("CK_PRODUTO")[1]	,/*lPixel*/,{|| cCodigo	})	// C�digo do Produto
TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descri�ao"		,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})	// Descri��o do Produto
//TRCell():New(oVenProd,"SALDO"		,/*Tabela*/ ,"Saldo"			,PesqPict("SC6","C6_VALOR")		,TamSx3("C6_VALOR")[1]		,/*lPixel*/,{|| nSaldo	})	// Saldo
TRCell():New(oVenProd,"COMP"		,/*Tabela*/ ,"Comp."			,PesqPict("SB5","B5_COMPRLC")	,TamSx3("B5_COMPRLC")[1]+5	,/*lPixel*/,{|| nComp	})	// Comprimento Armazem
TRCell():New(oVenProd,"LARG"		,/*Tabela*/ ,"Larg."			,PesqPict("SB5","B5_LARGLC")	,TamSx3("B5_LARGLC")[1] 	,/*lPixel*/,{|| nLarg	})	// Largura Armazem
TRCell():New(oVenProd,"ALT"			,/*Tabela*/ ,"Alt."			 	,PesqPict("SB5","B5_LARGLC")	,TamSx3("B5_LARGLC")[1]		,/*lPixel*/,{|| nAlt	})	// Altura Armazem
TRCell():New(oVenProd,"PESO"		,/*Tabela*/ ,"Peso"			 	,PesqPict("SB5","B5_PESO")		,TamSx3("B5_PESO")[1]		,/*lPixel*/,{|| nPeso	})	// Peso do Produto
TRCell():New(oVenProd,"M3"			,/*Tabela*/ ,"M3"			 	,PesqPict("SC6","C6_PRCVEN")	,TamSx3("C6_PRCVEN")[1] 	,/*lPixel*/,{|| nM3	})		// M3 Cubagem
//TRCell():New(oVenProd,"TOTM3"		,/*Tabela*/ ,"Total M3"			,PesqPict("SC6","C6_PRCVEN")	,TamSx3("C6_PRCVEN")[1] 	,/*lPixel*/,{|| nTotM3	})	// Total M3 Cubagem
//TRCell():New(oVenProd,"TOTPESO"	,/*Tabela*/ ,"Total Peso"		,PesqPict("SB5","B5_PESO")		,TamSx3("B5_PESO")[1]		,/*lPixel*/,{|| nTotPeso})	// Total Peso do Produto

TRFunction():New(oVenProd:Cell("PESO")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("M3")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

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

Local lPosB1	:= .F.
Local lPosB5	:= .F.

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SCK")		// Itens do Or�amento
dbSetOrder(2)			// Produto,Numero

oReport:Section(1):Cell("M3" ):SetBlock({|| nM3 })
oReport:Section(1):Cell("PESO" ):SetBlock({|| nPeso })

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			CK_FILIAL,CK_NUM,CK_ITEM,CK_XITEMP,CK_PRODUTO,CK_QTDVEN
		FROM 
			%Table:SCK% SCK
		WHERE 
			SCK.CK_FILIAL = '01' AND
			SCK.CK_NUM >= %Exp:MV_PAR01% AND
			SCK.CK_NUM <= %Exp:MV_PAR02% AND
			SCK.%NotDel%
		ORDER BY SCK.CK_NUM
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

//oReport:Section(1):Cell("M3"):Disable()
//oReport:Section(1):Cell("PESO"):Disable()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosB1 	:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->CK_PRODUTO))
	lPosB5	:= SB5->(MsSeek(xFilial("SB5")+(cAliasQry)->CK_PRODUTO))

	cNum		:= (cAliasQry)->CK_NUM
	cItem		:= (cAliasQry)->CK_ITEM
	cPlanta		:= (cAliasQry)->CK_XITEMP
	cCodigo		:= (cAliasQry)->CK_PRODUTO
	nQuant		:= (cAliasQry)->CK_QTDVEN
//	nQuje		:= (cAliasQry)->CK_QTDENT
//	nSaldo		:= (nQuant - nQuje)

    If lPosB1
    	cDesc := SB1->B1_DESC
	Else
		cDesc := ""
    Endif

	If lPosB5
		nComp		:= SB5->B5_COMPRLC
		nLarg		:= SB5->B5_LARGLC 
		nAlt		:= SB5->B5_ALTURLC
		nPeso		:= SB5->B5_PESO
		nM3			:= (nComp * nLarg * nAlt * nQuant /*nSaldo*/) / 1000000000
		nTotM3		:= nM3
		nTotPeso	:= nPeso
	Else
		nComp		:= 0
		nLarg		:= 0
		nAlt		:= 0
		nPeso		:= 0
		nM3		:= 0
		nTotM3		:= 0
		nTotPeso	:= 0
	Endif
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	nComp	:= 0
	nLarg	:= 0
	nAlt	:= 0
	nPeso	:= 0
	nM3	:= 0

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return