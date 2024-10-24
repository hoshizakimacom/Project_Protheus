#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R08   � Autor � Cleber Maldonado      � Data � 02/11/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Saldos                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R08()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 02/11/18 ���
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
oReport := TReport():New("M10R08","Saldos","M10R08", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de cubagem por pedido." + " " + " Ser� considerado somente dados da filial 01 e itens com saldo maior que zero.")
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
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SB2","B2_FILIAL")	,TamSx3("B2_FILIAL")[1]		,/*lPixel*/,{|| cFilB2	})		// Filial
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/ ,"C�digo do Produto" ,PesqPict("SB2","B2_COD")		,TamSx3("B2_COD")[1]		,/*lPixel*/,{|| cCodProd})		// C�digo do Produto
TRCell():New(oVenProd,"LOCALFAB"	,/*Tabela*/ ,"Local Fabrica��o"	 ,PesqPict("SB1","B1_XFABRIC")	,TamSx3("B1_XFABRIC")[1]	,/*lPixel*/,{|| cLocFabr})		// Local de fabrica��o do produto
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/	,"Tipo"			 	 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{|| cTipo	})		// Tipo do Produto
TRCell():New(oVenProd,"DESCRI"		,/*Tabela*/ ,"Descri�ao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDescri	})		// Descri��o do Produto
TRCell():New(oVenProd,"LOCPAD"		,/*Tabela*/ ,"Armazem Padr�o"	 ,PesqPict("SB1","B1_LOCPAD")	,TamSx3("B1_LOCPAD")[1]		,/*lPixel*/,{|| cLocPad	})		// Armazem padr�o do produto
TRCell():New(oVenProd,"SALDOATU"	,/*Tabela*/ ,"Saldo Atual"		 ,PesqPict("SB2","B2_QATU")  	,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldAtu })		// Saldo Atual do Produto
TRCell():New(oVenProd,"QTDEMP"		,/*Tabela*/ ,"Qtd.Empenhada"	 ,PesqPict("SB2","B2_QEMP")		,TamSx3("B2_QEMP")[1] 		,/*lPixel*/,{|| nQtdEmp	})		// Quantidade Empenhada
TRCell():New(oVenProd,"QTDPEDVEN"	,/*Tabela*/ ,"Qtd.Em Ped.Vendas" ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQtdPVen})		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTDPREV"		,/*Tabela*/ ,"Qtd.Entr.Prevista" ,PesqPict("SB2","B2_SALPEDI")	,TamSx3("B2_SALPEDI")[1]	,/*lPixel*/,{|| nQtdPrev})		// Quantidade de entrada prevista
TRCell():New(oVenProd,"QTDFATMES"	,/*Tabela*/ ,"Qtd.Faturada/Mes"	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nQtdFat })		// Quantidade Faturada no m�s
TRCell():New(oVenProd,"QTDVENMES"	,/*Tabela*/ ,"Tot.Faturado Vlr"	 ,PesqPict("SB2","B2_VATU1")	,TamSx3("B2_VATU1")[1]		,/*lPixel*/,{|| nValFat	})		// Valot total faturado no m�s
TRCell():New(oVenProd,"OPAPONT"		,/*Tabela*/ ,"Op. Apontadas"	 ,PesqPict("SC2","C2_QUANT")	,TamSx3("C2_QUANT")[1]		,/*lPixel*/,{|| nQtdApon})		// Quantidade apontada em ordem de produ��o
TRCell():New(oVenProd,"OPABERTA"	,/*Tabela*/	,"Op. Em Aberto"	 ,PesqPict("SC2","C2_QUANT")	,TamSx3("C2_QUANT")[1]		,/*lPixel*/,{|| nQtdOpen})		// Quantidade em ordem de produ��o n�o apontada
TRCell():New(oVenProd,"TRANSFER"	,/*Tabela*/ ,"Qtd. Transferida"	 ,PesqPict("SD1","D1_QUANT")	,TamSx3("D1_QUANT")[1]		,/*lPixel*/,{|| nQtdTran})		// Quantidade transferida de filial

//TRCell():New(oVenProd,"M3"		,/*Tabela*/ ,"M3"				 ,PesqPict("SB2","C6_PRCVEN")	,TamSx3("C6_PRCVEN")[1] 	,/*lPixel*/,{|| nM3		})		// M3 Cubagem
//TRCell():New(oVenProd,"TOTM3"		,/*Tabela*/ ,"Total M3"			 ,PesqPict("SC6","C6_PRCVEN")	,TamSx3("C6_PRCVEN")[1] 	,/*lPixel*/,{|| nTotM3	})		// Total M3 Cubagem
//TRCell():New(oVenProd,"TOTPESO"	,/*Tabela*/ ,"Total Peso"		 ,PesqPict("SB5","B5_PESO")		,TamSx3("B5_PESO")[1]		,/*lPixel*/,{|| nTotPeso})		// Total Peso do Produto

//TRFunction():New(oVenProd:Cell("PESO")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//TRFunction():New(oVenProd:Cell("M3")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 02/11/18 ���
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
Private lPosC2	:= .F.

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SB2")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero

//oReport:Section(1):Cell("M3" ):SetBlock({|| nM3 })
//oReport:Section(1):Cell("PESO" ):SetBlock({|| nPeso })

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_QEMP,B2_QPEDVEN,B2_SALPEDI,B1_FILIAL,B1_COD,B1_LOCPAD,B1_XFABRIC,B1_TIPO,B1_DESC 
		FROM 
			SB2010 SB2 , SB1010 SB1 
		WHERE 
			B2_FILIAL = '01' AND
			B2_COD = B1_COD AND 
			B1_LOCPAD = B2_LOCAL AND
			B1_TIPO IN ('PA','PI','ME') AND 
			SB2.%NotDel% AND
			SB1.%NotDel% 

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
	cFilB2		:= (cAliasQry)->B2_FILIAL
	cCodProd	:= (cAliasQry)->B2_COD
	cLocFabr	:= IIF((cAliasQry)->B1_XFABRIC == '1','1-MATRIZ','2-PORTO FELIZ')
	cTipo		:= (cAliasQry)->B1_TIPO   
	cDescri		:= (cAliasQry)->B1_DESC
	cLocPad		:= (cAliasQry)->B1_LOCPAD
	nSldAtu		:= (cAliasQry)->B2_QATU
	nQtdEmp		:= (cAliasQry)->B2_QEMP
	nQtdPVen	:= (cAliasQry)->B2_QPEDVEN
	nQtdPrev	:= (cAliasQry)->B2_SALPEDI
	nQtdFat		:= M10R8FAT((cAliasQry)->B2_COD)[1]
	nValFat		:= M10R8FAT((cAliasQry)->B2_COD)[2]
	nQtdApon	:= M10R8PR0((cAliasQry)->B2_COD,"E")  
	nQtdOpen	:= M10R8PR0((cAliasQry)->B2_COD,"A")
	nQtdTran	:= M10R8TRF((cAliasQry)->B2_COD)
		
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
���Programa  � M10R8FAT � Autor � Cleber Maldonado      � Data � 02/11/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a quantidade e o valor faturado no m�s.            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M10R8FAT(cCodProd) 

Local cAliasTot := GetNextAlias()

BeginSql Alias cAliasTot

	COLUMN D2_EMISSAO AS DATE

	SELECT 
		D2_COD,SUM(D2_QUANT) AS QUANTIDADE, SUM(D2_TOTAL) AS VALOR
	FROM 
		%Table:SD2% SD2
	WHERE 
		SD2.D2_FILIAL = '01' AND
		SD2.D2_COD = %Exp:cCodProd% AND
		SD2.D2_EMISSAO >= %Exp:MV_PAR01% AND
		SD2.D2_EMISSAO <= %Exp:MV_PAR02% AND
		SD2.%NotDel%
	GROUP BY 
		SD2.D2_FILIAL,SD2.D2_COD
EndSql

nQtdFat := (cAliasTot)->QUANTIDADE
nQtdVlr := (cAliasTot)->VALOR

(cAliasTot)->(DbCloseArea())

Return {nQtdFat,nQtdVlr}

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R8PR0 � Autor � Cleber Maldonado      � Data � 02/11/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a quantidade apontada de um produto ou o saldo em  ���
���          � aberto em ordens de produ��o.                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M10R8PR0(cCodProd,cTipoApur)

Local nRet		 := 0
Local cAliasPR0 := GetNextAlias()

//+-------------------------------------------------------+
//| Verifica qual tipo de retorno deve ser apresentado :  |
//| E - Encerradas                                        |
//| A - Abertas                                           |
//+-------------------------------------------------------+ 
If cTipoApur == "E"
	BeginSql Alias cAliasPR0

		SELECT 
			C2_FILIAL,SUM(C2_QUJE) AS TOTAL_PRODUZIDO 
		FROM 
			SC2010 SC2 
		WHERE
			SC2.C2_FILIAL = '01' AND 
			SC2.C2_DATRF >= %Exp:MV_PAR01% AND 
			SC2.C2_DATRF <= %Exp:MV_PAR02% AND 
			SC2.C2_PRODUTO = %Exp:cCodProd% 
		GROUP BY 
			SC2.C2_FILIAL
	EndSql
Else
 	BeginSql Alias cAliasPR0
 
	 	SELECT 
	 		C2_FILIAL,SUM(C2_QUJE) AS TOTAL_PRODUZIDO,SUM(C2_QUANT) AS TOTAL_OP 
	 	FROM 
	 		SC2010 SC2 
	 	WHERE 
	 		SC2.C2_FILIAL = '01' AND
	 		SC2.C2_PRODUTO = %Exp:cCodProd%  
	 	GROUP BY SC2.C2_FILIAL
 
 	EndSql
Endif

dbSelectArea(cAliasPR0)
dbGoTop()
 
While !(cAliasPR0)->(Eof())
 	If cTipoApur == "E"
		nRet += (cAliasPR0)->TOTAL_PRODUZIDO
 	Else
		nRet += ( (cAliasPR0)->TOTAL_OP - (cAliasPR0)->TOTAL_PRODUZIDO ) 
	Endif
	(cAliasPR0)->(dbSkip())
End

(cAliasPR0)->(DbCloseArea())

Return nRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R8TRF � Autor � Cleber Maldonado      � Data � 02/11/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a quantidade transferida de um produto da filial   ���
���          � Porto Feliz para a Matriz.                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M10R8TRF(cCodProd)

Local nRet		:= 0
Local cAliasTRF := GetNextAlias()

BeginSql Alias cAliasTRF
	SELECT 
		D1_FILIAL,D1_COD,SUM(D1_QUANT) AS TOTAL_TRANSF 
	FROM 
		SD1010 SD1
	WHERE 
		SD1.D1_FILIAL = '01' AND 
		SD1.D1_COD = %Exp:cCodProd% AND 
		SD1.D1_CF = '1151' AND 
		SD1.D1_FORNECE = '002370' AND 
		SD1.D1_LOJA = '0006' AND 
		SD1.D1_DTDIGIT >= %Exp:MV_PAR01% AND 
		SD1.D1_DTDIGIT <= %Exp:MV_PAR02% 
	GROUP BY 
		SD1.D1_FILIAL,SD1.D1_COD
EndSql

dbSelectArea(cAliasTRF)
dbGoTop()
 
While !(cAliasTRF)->(Eof())
	nRet += (cAliasTRF)->TOTAL_TRANSF
	(cAliasTRF)->(dbSkip())
End

(cAliasTRF)->(DbCloseArea())

Return nRet
