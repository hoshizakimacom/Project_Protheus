#INCLUDE "MATR620.ch"
#INCLUDE "PROTHEUS.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R14   � Autor � Cleber Maldonado      � Data � 27/05/21 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Analise de Custos                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R14()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 31/06/18 ���
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
oReport := TReport():New("M10R14","CUSTOS X MAO DE OBRA","M10R14", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de produtos do tipo PA " + " " + "analisando a estrutura de produtos.")
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
oVenProd := TRSection():New(oReport,"ANALISE DE CUSTOS",{"SB1","SG1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Apura��o do custo standard"
oVenProd:SetTotalInLine(.F.) 
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SB1","B1_FILIAL")	,TamSx3("B1_FILIAL")[1]		,/*lPixel*/,{|| cXFilial})		// C�digo da Filial 
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/ ,"C�digo do Produto" ,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| cCodPro	})		// C�digo do Produto
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/	,"Tipo"				 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{||	cTpProd })		// Tipo do Produto
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descri��o"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})		// Descri��o do produto
TRCell():New(oVenProd,"INSUMOS"		,/*Tabela*/	,"Insumos R$"		 ,PesqPict("SB1","B1_CUSTD")	,TamSx3("B1_CUSTD")[1]		,/*lPixel*/,{|| nCustIns})		// Custo de Insumos
TRCell():New(oVenProd,"MAODEOBRA"	,/*Tabela*/ ,"M�o de Obra R$"	 ,PesqPict("SB1","B1_CUSTD")	,TamSx3("B1_CUSTD")[1]		,/*lPixel*/,{|| nCustMO })		// Custo de m�o de obra
TRCell():New(oVenProd,"COCCAO"		,/*Tabela*/ ,"Hora Coc��o - Qtd" ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdCoc })		// Quantidade em Horas - Coc��o
TRCell():New(oVenProd,"CPC"			,/*Tabela*/ ,"Hora C.P.C. - Qtd" ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdCPC })		// Quantidade em Horas - CPC
TRCell():New(oVenProd,"ICE"			,/*Tabela*/ ,"Hora ICE    - Qtd" ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdICE })		// Quantidade em Horas - ICE
TRCell():New(oVenProd,"MOBILIARIO"	,/*Tabela*/ ,"Hora MOB    - Qtd" ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdMOB })		// Quantidade em Horas - MOBILIARIO
TRCell():New(oVenProd,"REFRIGERA"	,/*Tabela*/ ,"Hora Refrig.- Qtd" ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdREFR})		// Quantidade em Horas - REFRIGERA��O

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
Local aModInf   := {}

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SB1")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		SELECT 
			B1_FILIAL,B1_COD,B1_DESC,B1_TIPO,B1_CUSTD
		FROM 
			%Table:SB1% SB1
		WHERE
			SB1.B1_TIPO IN ( 'PA' ) AND
			SB1.B1_FILIAL = %xFilial:SB1% AND
			SB1.B1_MSBLQL = '2' AND
			SB1.%NotDel%
		ORDER BY SB1.B1_COD
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
dbSelectArea("SG1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	nCustSTD	:= Posicione("SB1",1,xFilial("SB1")+Alltrim((cAliasQry)->B1_COD),"B1_CUSTD")
	
	aModInf     := U_M10R14MOD((cAliasQry)->B1_COD)

	If Valtype(aModInf)=="A"
		cXfilial := aModInf[1]
	Else
		cXFilial := "SEM ESTRUTURA"
	Endif 
	cCodPro		:= (cAliasQry)->B1_COD
	cDesc		:= (cAliasQry)->B1_DESC
	cTpProd		:= (cAliasQry)->B1_TIPO
	nCustMO		:= aModInf[2]
	nQtdCoc		:= aModInf[3]
	nQtdCPC		:= aModInf[4]
	nQtdICE		:= aModInf[5]
	nQtdMOB		:= aModInf[6]
	nQtdREFR	:= aModInf[7]

	nCustIns	:= ( nCustSTD - nCustMO )

	oReport:IncMeter(1)
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
���Programa  � M34R6MOD � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor da m�o de obra dos itens da estrutura.     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R14MOD(_cCodPro)

Local _aEstru     := {}
Local _cTpProd    := ""
Local _cRetFil	  := ""
Local _nX         := 0
Local _nValMO	  := 0
Local _nQtdCoc    := 0
Local _nQtdCPC    := 0
Local _nQtdICE    := 0
Local _nQtdMOB    := 0
Local _nQtdREFR   := 0

Private nEstru     := 0

dbSelectArea("SG1") 
dbSetOrder(1)

SG1->(MsSeek(xFilial("SG1")+Alltrim(_cCodPro)))

_aEstru := Estrut(_cCodPro,1)

If ! Empty(_aEstru)
	For _nX := 1 To Len(_aEstru)
		_cTpProd := Posicione("SB1",1,xFilial("SB1")+AllTrim(_aEstru[_nX,2]),"B1_TIPO")
		_cTpComp := Posicione("SB1",1,xFilial("SB1")+AllTrim(_aEstru[_nX,3]),"B1_TIPO")

		If _cTpProd == "MO" .Or. _cTpComp == "MO"
			_nValMO  += _aEstru[_nX,4] * SB1->B1_CUSTD 
		Endif

		Do Case
			Case Alltrim(_aEstru[_nX,3]) == "MO-COC"
				_nQtdCOC += _aEstru[_nX,4]

			Case Alltrim(_aEstru[_nX,3]) == "MO-CPC"
				_nQtdCPC += _aEstru[_nX,4]

			Case Alltrim(_aEstru[_nX,3]) == "MO-ICE"
				_nQtdICE += _aEstru[_nX,4]

			Case Alltrim(_aEstru[_nX,3]) == "MO-MOB"
				_nQtdMOB += _aEstru[_nX,4]

			Case Alltrim(_aEstru[_nX,3]) == "MO-REF"
				_nQtdREFR += _aEstru[_nX,4]
		EndCase
	Next
	_cRetFil := '01'
Else 
	_cRetFil := 'Sem Estrutura'
Endif

Return {_cRetFil,_nValMO,_nQtdCOC,_nQtdCPC,_nQtdICE,_nQtdMOB,_nQtdREFR}
