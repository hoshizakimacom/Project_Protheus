#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 29/01/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gest�o de Pedidos                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R09()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 29/01/19 ���
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
oReport := TReport():New("M10R09","Gestao de Pedidos","M10R09", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a vis�o geral dos pedidos de vendas" + " " + " em aberto da filial 01 para gest�o de processos de PCP.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SC6","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUMPED"		,/*Tabela*/	,"Pedido"	 		 ,PesqPict("SC6","C6_NUM")		,TamSx3("C6_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"CLIENTE"		,/*Tabela*/ ,"Cliente"			 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cCLiente})		// Cliente
TRCell():New(oVenProd,"UF"			,/*Tabela*/ ,"UF"			 	 ,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cUF		})		// UF do cliente
TRCell():New(oVenProd,"VALFAT"		,/*Tabela*/ ,"Valor a faturar"	 ,PesqPict("SC6","C6_VALOR")	,TamSx3("C6_VALOR")[1]		,/*lPixel*/,{|| nValFat	})		// Valor a faturar
TRCell():New(oVenProd,"DTENT"		,/*Tabela*/	,"Dt. Entrega"		 ,PesqPict("SC6","C6_ENTREG")	,TamSx3("C6_ENTREG")[1]		,/*lPixel*/,{|| dDtEntr	})		// Menor Data de Entrega
TRCell():New(oVenProd,"TPFRETE"		,/*Tabela*/ ,"Tipo de Frete"	 ,PesqPict("SC5","C5_TPFRETE")	,TamSx3("C5_TPFRETE")[1]+2	,/*lPixel*/,{|| cTpFrete})		// Tipo de Frete
TRCell():New(oVenProd,"CLASSE"		,/*Tabela*/	,"Classe"			 ,PesqPict("SB1","B1_COD")		,TamSX3("B1_COD")[1]		,/*lPixel*/,{|| cClasse	})		// Classe
TRCell():New(oVenProd,"REGIAO"		,/*Tabela*/	,"Regi�o"			 ,PesqPict("SA1","A1_DSCREG")	,TamSX3("A1_DSCREG")[1]		,/*lPixel*/,{|| cRegiao	})		// Regi�o
TRCell():New(oVenProd,"STATUS"		,/*Tabela*/ ,"Status"			 ,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cStatus	})		// Status
TRCell():New(oVenProd,"STATFIN"		,/*Tabela*/	,"Financeiro"		 ,PesqPict("SC5","C5_XSTSFIN")	,TamSx3("C5_XSTSFIN")[1]	,/*lPixel*/,{|| cStatFin})		// Status Financeiro
TRCell():New(oVenProd,"NOMTRANS"	,/*Tabela*/	,"Transportadora"	 ,PesqPict("SC5","C5_XTRANS")	,TamSx3("C5_XTRANS")[1]		,/*lPixel*/,{|| cTrans	})		// Nome da Transportadora

//TRCell():New(oVenProd,"TOTM3"		,/*Tabela*/ ,"Total M3"			 ,PesqPict("SC6","C6_PRCVEN")	,TamSx3("C6_PRCVEN")[1] 	,/*lPixel*/,{|| nTotM3	})		// Total M3 Cubagem
//TRCell():New(oVenProd,"TOTPESO"		,/*Tabela*/ ,"Total Peso"		 ,PesqPict("SB5","B5_PESO")		,TamSx3("B5_PESO")[1]		,/*lPixel*/,{|| nTotPeso})		// Total Peso do Produto

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

Local lPosA1	:= .F.
Private cLike		:= ' %'

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero

//oReport:Section(1):Cell("M3" ):SetBlock({|| nM3 })
//oReport:Section(1):Cell("PESO" ):SetBlock({|| nPeso })

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN C6_ENTREG AS DATE

		SELECT 
			C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_TPFRETE,C5_XSTSFIN,C5_TRANSP,C5_NOTA,C5_MSBLQL
		FROM 
			%Table:SC5% SC5
		WHERE 
			SC5.C5_FILIAL = '01' AND
			SC5.C5_MSBLQL = '2' AND
			SC5.C5_NOTA LIKE ' %' AND
			SC5.%NotDel%
		ORDER BY SC5.C5_NUM

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
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

//oReport:Section(1):Cell("M3"):Disable()
//oReport:Section(1):Cell("PESO"):Disable()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial("SA1")+(cAliasQry)->C5_CLIENTE+(cAliasQry)->C5_LOJACLI))

	cNum		:= (cAliasQry)->C5_NUM
	cTpFrete	:= (cAliasQry)->C5_TPFRETE
	cStatFin	:= (cAliasQry)->C5_XSTSFIN
	cUF			:= IIF(lPosA1,SA1->A1_EST," ")
	cCLiente	:= IIF(lPosA1,SA1->A1_NOME," ")	
	cRegiao		:= IIF(lPosA1,SA1->A1_DSCREG," ")
	nValFat		:= U_R09VALFAT((cAliasQry)->C5_NUM)[1]
	dDtEntr		:= U_MinData((cAliasQry)->C5_NUM)
	cClasse		:= U_R09Classe((cAliasQry)->C5_NUM)
	cStatus		:= U_R09VALFAT((cAliasQry)->C5_NUM)[2]
	cTrans		:= Posicione("SA4",1,xFilial("SA4")+(cAliasQry)->C5_TRANSP,"A4_NOME")

	If cTpFrete == "C"
		cTpFrete := "CIF"
	ElseIf cTpFrete == "F"
		cTpFrete := "FOB"
	Else
		cTpFrete := " "
	Endif

	If cStatFin == "1"
		cStatFin := "Bloqueado"
	ElseIf  cStatFin == "2"
		cStatFin := "Liberado"
	Else
		cStatFin := " "
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
���Programa  � RetClasse � Autor � Cleber Maldonado     � Data � 30/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a classe de acordo com os crit�ios estabelecidos   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function R09Classe(cNumPed)
Local cRet 		:= ""
Local cAliasTot := GetNextAlias()

DEFAULT cNumPed := ""

If !Empty(cNumPed) .And. Empty(cRet)

	BeginSql Alias cAliasTot
	
		SELECT 
			SUM(C6_VALOR) AS TOTAL
		FROM 
			%Table:SC6% SC6
		WHERE 
			SC6.C6_FILIAL = '01' AND
			SC6.C6_NUM = %Exp:cNumPed% AND
			SC6.%NotDel%
	EndSql
	
	If (cAliasTot)->TOTAL > 20000.00 .And. (cAliasTot)->TOTAL < 200000.00
		cRet	:= "Gastronomia"
	ElseIf (cAliasTot)->TOTAL < 20000.00
		cRet	:= "Pequeno"
	ElseIf (cAliasTot)->TOTAL > 200000.00
		cRet	:= "Grande"
	Endif
Endif

If Posicione("SC5",1,xFilial("SC5")+cNumPed,"C5_VEND1") == "000007"
	cRet := "Redes"
ElseIf Posicione("SC5",1,xFilial("SC5")+cNumPed,"C5_VEND1") == "000008"
	cRet := "Suporte Tecnico"
Endif
	
(cAliasTot)->(dbCloseArea())

Return cRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RetClasse � Autor � Cleber Maldonado     � Data � 30/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a classe de acordo com os crit�ios estabelecidos   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MinData(cNumPed)

// ***
Local dMinDat	:= CTOD("  /  /  ")
Local cAliasDat	:= GetNextAlias()
Private cStatus	:= ""

// Encontra a menor data de entrega do pedido
BeginSql Alias cAliasDat
	SELECT 
		MIN(C6_ENTREG) AS MINDATA
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_FILIAL = '01' AND
		SC6.C6_NUM = %Exp:cNumPed% AND
		SC6.C6_QTDENT <> SC6.C6_QTDVEN AND
		SC6.%NotDel%
EndSql

dMinDat := STOD((cAliasDat)->MINDATA)

(cAliasDat)->(dbCloseArea())

Return dMinDat

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RetClasse � Autor � Cleber Maldonado     � Data � 30/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a classe de acordo com os crit�ios estabelecidos   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function R09VALFAT(cNumPed)
Local nSaldo	:= 0
Local nValPed	:= 0
Local nSalEst	:= 0
Local cArmazem	:= ""
Local cStatus	:= "PRONTO"
Local cAliasVlr	:= GetNextAlias()

BeginSql Alias cAliasVlr
	SELECT 
		C6_PRODUTO,C6_QTDVEN,C6_QTDENT,C6_XVLTBRU
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_FILIAL = '01' AND
		SC6.C6_NUM = %Exp:cNumPed% AND
		SC6.%NotDel%
EndSql

While !(cAliasVlr)->(Eof())
	nSaldo := ( (cAliasVlr)->C6_QTDVEN - (cAliasVlr)->C6_QTDENT )
	
	If nSaldo > 0
		nValPed += ( (cAliasVlr)->C6_XVLTBRU / (cAliasVlr)->C6_QTDVEN ) * nSaldo
	Endif
	
	// Verifica status de saldo em estoque
	cArmazem	:= Posicione("SB1",1,xFilial("SB1")+(cAliasVlr)->C6_PRODUTO,"B1_LOCPAD") 
	nSalEst 	:= Posicione("SB2",1,xFilial("SB2")+(cAliasVlr)->C6_PRODUTO+cArmazem,"B2_QATU")
	
	If nSalEst < nSaldo
		cStatus	:= " "
	Endif
	
	(cAliasVlr)->(dbSkip())
End

(cAliasVlr)->(dbCloseArea())

Return {nValPed,cStatus} 	
