#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06R06   � Autor � Cleber Maldonado      � Data � 01/06/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Faturas                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06R06()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 01/06/18 ���
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
oReport := TReport():New("M06R06","Rela��o de Faturas","M06R06", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de faturas de venda " + " " + ".")
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
oVenProd := TRSection():New(oReport,"RELA��O DE FATURAS",{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Faturas"
oVenProd:SetTotalInLine(.F.) 

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SE1","E1_FILIAL")	,TamSx3("E1_FILIAL")[1]		,/*lPixel*/,{|| cNumFil	})		// Filial
TRCell():New(oVenProd,"PEDIDO"		,/*Tabela*/ ,"Pedido"			 ,PesqPict("SE1","E1_PEDIDO")	,TamSx3("E1_PEDIDO")[1]		,/*lPixel*/,{|| cNumPed	})		// Numero do Pedido
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/	,"Emiss�o"			 ,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmiss})		// Data de Emissao
TRCell():New(oVenProd,"CNPJ"		,/*Tabela*/ ,"CNPJ"				 ,PesqPict("SA1","A1_CGC")		,TamSx3("A1_CGC")[1]		,/*lPixel*/,{|| cCNPJ	})		// CNPJ do cliente
TRCell():New(oVenProd,"RAZAO"		,/*Tabela*/ ,"Raz�o Social"		 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cRazao	})		// Raz�o Social
TRCell():New(oVenProd,"NOTA"		,/*Tabela*/ ,"Nota Fiscal"		 ,PesqPict("SE1","E1_NUM")		,TamSx3("E1_NUM")[1]		,/*lPixel*/,{|| cNumNota})		// Numero da Nota Fiscal
TRCell():New(oVenProd,"PARCELA"		,/*Tabela*/ ,"Parcela"		 	 ,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cParcela})		// Parcela
TRCell():New(oVenProd,"VENCTO"		,/*Tabela*/	,"Vencimento"		 ,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dDtVenc	})		// Data de Vencimento
TRCell():New(oVenProd,"VENCREAL"	,/*Tabela*/	,"Vencto.Real"		 ,PesqPict("SE1","E1_VENCREA")	,TamSx3("E1_VENCREA")[1]	,/*lPixel*/,{|| dVenReal})		// Data de Vencimento Real
TRCell():New(oVenProd,"FATURA"		,/*Tabela*/	,"Fatura"			 ,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nFatura	})		// Valor da Fatura
TRCell():New(oVenProd,"VALTOTAL"	,/*Tabela*/	,"Valor Total"		 ,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nFatura })		// Valor Total
TRCell():New(oVenProd,"VENDEDOR"	,/*Tabela*/	,"Vendedor"			 ,PesqPict("SC5","C5_VEND1")	,TamSx3("C5_VEND1")[1]		,/*lPixel*/,{|| cVend	})		// C�digo do Vendedor
TRCell():New(oVenProd,"NOMEVEN"		,/*Tabela*/	,"Nome Vendedor"	 ,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomVen })		// Nome do Vendedor
TRCell():New(oVenProd,"GERENTE"		,/*Tabela*/	,"Gerente"			 ,PesqPict("SA3","A3_GEREN")	,TamSx3("A3_GEREN")[1]		,/*lPixel*/,{|| cGeren	})		// C�digo do Gerente
TRCell():New(oVenProd,"NOMEGER"		,/*Tabela*/	,"Nome Gerente"		 ,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomGer })		// Nome do Gerente
TRCell():New(oVenProd,"CONDPAG"		,/*Tabela*/ ,"Cond.Pagto"		 ,PesqPict("SC5","C5_CONDPAG")	,TamSx3("C5_CONDPAG")[1]	,/*lPixel*/,{|| cCondPgt})		// Condi��o de Pagamento
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descri��o"		 ,PesqPict("SE4","E4_DESCRI")	,TamSx3("E4_DESCRI")[1]		,/*lPixel*/,{|| cDescPgt})		// Descri��o da condi��o de pagamento
TRCell():New(oVenProd,"CONTAB"		,/*Tabela*/ ,"Dt.Contabiliza��o" ,PesqPict("SE1","E1_EMIS1")	,TamSx3("E1_EMIS1")[1]		,/*lPixel*/,{|| dDtCont })		// Data de Contabiliza��o

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
dbSelectArea("SE1")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN E1_VENCTO AS DATE
		COLUMN E1_VENCREA AS DATE			
		COLUMN E1_EMIS1  AS DATE
		COLUMN E1_EMISSAO AS DATE
		
		SELECT 
			E1_FILIAL,E1_PEDIDO,E1_NUM,E1_EMISSAO,E1_PARCELA,E1_VALOR,E1_VENCTO,E1_VENCREA,E1_VEND1,E1_CLIENTE,E1_LOJA,E1_EMIS1  
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL >= %Exp:MV_PAR01% AND
			SE1.E1_FILIAL <= %Exp:MV_PAR02% AND
			SE1.E1_EMIS1 >= %Exp:MV_PAR03% AND
			SE1.E1_EMIS1 <= %Exp:MV_PAR04% AND
			SE1.E1_TIPO = 'NF' AND
			SE1.%NotDel%
		ORDER BY SE1.E1_EMISSAO
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
dbSelectArea("SE1")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosC5	:= SC5->(MsSeek(xFilial('SC5')+(cAliasQry)->E1_PEDIDO))
	
	cNumFil		:= (cAliasQry)->E1_FILIAL
	cNumPed		:= (cAliasQry)->E1_PEDIDO
	cNumNota	:= (cAliasQry)->E1_NUM
	dDtEmiss	:= (cAliasQry)->E1_EMISSAO
	cParcela	:= (cAliasQry)->E1_PARCELA
	nFatura		:= (cAliasQry)->E1_VALOR
	dDtVenc		:= (cAliasQry)->E1_VENCTO			
	dVenReal	:= (cAliasQry)->E1_VENCREA
	cVend		:= (cAliasQry)->E1_VEND1
	dDtCont		:= (cAliasQry)->E1_EMIS1
	cNomVen		:= Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->E1_VEND1,"A3_NOME")
	cGeren		:= SA3->A3_GEREN
	cNomGer		:= Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_NOME")

    If lPosA1
		cCNPJ	:= SA1->A1_CGC
    	cRazao	:= SA1->A1_NOME
    Else
    	cCNPJ	:= " "
	    cRazao	:= " "
    Endif
    
	If lPosC5
		cCondPgt	:= SC5->C5_CONDPAG
		cDescPgt	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
	Else
		cCondPgt	:= " "
		cDescPgt	:= " "
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M5R10TOT � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor total dos itens do pedido de venda         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M6R06TOT(cNumPed)

Local nTotPed	:= 0
Local nTotDesc	:= 0
Local cAliasTot := GetNextAlias()
Local cAliasAvg := GetNextAlias()

BeginSql Alias cAliasTot

	SELECT 
		SUM(C6_XVLTBRU) AS TOTAL
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_NUM = %Exp:cNumPed% AND
		SC6.%NotDel%
EndSql

BeginSql Alias cAliasAvg

	SELECT 
		AVG(C6_DESCONT) AS PERDESC
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_NUM = %Exp:cNumPed% AND
		SC6.C6_DESCONT <> 0 AND
		SC6.%NotDel%
EndSql

nTotPed		:= (cAliasTot)->TOTAL
nTotDesc	:= (cAliasAvg)->PERDESC

(cAliasTot)->(DbCloseArea())
(cAliasAvg)->(DbCloseArea())

Return {nTotPed,nTotDesc}
