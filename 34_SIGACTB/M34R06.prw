#INCLUDE "MATR620.ch"
#INCLUDE "PROTHEUS.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 31/06/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Apura��o Custo Standard                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M34R06()

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
oReport := TReport():New("M34R06","Apura��o Custos","M34R06", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de produtos do tipo PA " + " " + "da matriz e filial apurando seu custo de m�o de obra e insumos.")
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
oVenProd := TRSection():New(oReport,"APURA��O CUSTOS",{"SB1","SG1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Apura��o do custo standard"

oVenProd:SetTotalInLine(.F.) 
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SB1","B1_FILIAL")	,TamSx3("B1_FILIAL")[1]		,/*lPixel*/,{|| cXFilial})		// C�digo da Filial 
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/ ,"C�digo do Produto" ,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| cCodPro	})		// C�digo do Produto
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/	,"Tipo"				 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{||	cTpProd })		// Tipo do Produto
TRCell():New(oVenProd,"LOCAL"       ,/*Tabela*/ ,"Armazem Padrao"    ,PesqPict("SB1","B1_LOCPAD")   ,TamSx3("B1_LOCPAD")[1]     ,/*lPixel*/,{|| cLocPad })      // Armazem Padr�o
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descri��o"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})		// Descri��o do produto
TRCell():New(oVenProd,"INSUMOS"		,/*Tabela*/	,"Insumos"			 ,PesqPict("SB1","B1_CUSTD")	,TamSx3("B1_CUSTD")[1]		,/*lPixel*/,{|| nCustIns})		// Custo de Insumos
TRCell():New(oVenProd,"MAODEOBRA"	,/*Tabela*/ ,"M�o de Obra"		 ,PesqPict("SB1","B1_CUSTD")	,TamSx3("B1_CUSTD")[1]		,/*lPixel*/,{|| nCustMO })		// Custo de m�o de obra
TRCell():New(oVenProd,"QTMAODEOBR"	,/*Tabela*/ ,"Qtd M�o de Obra"   ,PesqPict("SB2","B2_QATU")	    ,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nQtdMO })		// Custo de m�o de obra
TRCell():New(oVenProd,"CUSTAND"	    ,/*Tabela*/ ,"Custo Standard"	 ,PesqPict("SB1","B1_CUSTD")	,TamSx3("B2_VATU1")[1]		,/*lPixel*/,{|| nCustSTD})		// Custo Standard
TRCell():New(oVenProd,"CUMEDIO"	    ,/*Tabela*/ ,"Custo Medio"		 ,PesqPict("SB2","B2_VATU1")	,TamSx3("B2_VATU1")[1]		,/*lPixel*/,{|| nCustMED})		// Custo M�dio

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

Local aModInf    := {}
Local dDtUltFech := MV_PAR01-1 

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
			B1_FILIAL,B1_COD,B1_DESC,B1_TIPO,B1_CUSTD,B1_MSBLQL,B1_LOCPAD
		FROM 
			%Table:SB1% SB1
		WHERE
			SB1.B1_TIPO IN ( 'PA' , 'PI' ) AND
			SB1.B1_FILIAL = %xFilial:SB1% AND
			SB1.B1_MSBLQL <> '1' AND
			SB1.%NotDel% AND
		(
		(SELECT COUNT(*) FROM %Table:SD1% SD1 (NOLOCK)
			WHERE D1_FILIAL = %xFilial:SD1%
			AND D1_COD = B1_COD
			AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND SD1.D_E_L_E_T_ <> '*' ) > 0 OR
		(SELECT COUNT(*) FROM %Table:SD2%  SD2 (NOLOCK)
			WHERE D2_FILIAL = %xFilial:SD2%
			AND D2_COD = B1_COD
			AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND SD2.D_E_L_E_T_ <> '*') > 0 OR
		(SELECT COUNT(*) FROM %Table:SD3%  SD3 (NOLOCK)
		WHERE D3_FILIAL = %xFilial:SD3%
		AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D3_COD = B1_COD
		AND D3_ESTORNO = ' '
		AND SD3.D_E_L_E_T_ <> '*') > 0 OR
		(SELECT COUNT(*) FROM %Table:SB9% SB9 (NOLOCK)
		WHERE B9_FILIAL = %xFilial:SB9%
		AND B9_DATA = %Exp:dDtUltFech%
		AND B9_COD = B1_COD
		AND B9_QINI <> 0
		AND (B9_QINI <> 0 OR B9_VINI1 <> 0)
		AND SB9.D_E_L_E_T_ <> '*') > 0)
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

	If (cAliasQry)->B1_MSBLQL == "1"
		(cAliasQry)->(dbSkip())
		Loop
	EndIf

	nCustSTD	:= Posicione("SB1",1,xFilial("SB1")+Alltrim((cAliasQry)->B1_COD),"B1_CUSTD")
	cLocPad     := SB1->B1_LOCPAD
//	nCustMED    := Posicione("SB2",1,xFilial("SB2")+Alltrim((cAliasQry)->B1_COD+(cAliasQry)->B1_LOCPAD),"B2_VATU1")
	nCustMED    := Posicione("SB2",1,xFilial("SB2")+Alltrim((cAliasQry)->B1_COD+(cAliasQry)->B1_LOCPAD),"B2_CM1")

	aModInf     := U_M34R6MOD((cAliasQry)->B1_COD)

	If Valtype(aModInf)=="A"
		cXfilial := aModInf[1]
	Else
		cXFilial := "SEM ESTRUTURA"
	Endif 

	cCodPro		:= (cAliasQry)->B1_COD
	cDesc		:= (cAliasQry)->B1_DESC
	cTpProd		:= (cAliasQry)->B1_TIPO
	nCustMO		:= aModInf[2]
	nQtdMO      := aModInf[3]
	nCustMED    := nCustMED * nQtdMO    // B2_CM1 * QTD

	nCustIns	:= ( nCustSTD - nCustMO )

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
���Programa  � M34R6MOD � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor da m�o de obra dos itens da estrutura.     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M34R6MOD(_cCodPro)

Local _aEstru     := {}
Local _cTpProd    := ""
Local _cRetFil	  := ""
Local _nX         := 0
Local _nValMO	  := 0
Local _nQtdMO     := 0
//Local cAliasStr  := GetNextAlias()

Private nEstru     := 0
//Private aEstrutura := {}

dbSelectArea("SG1") 
dbSetOrder(1)

SG1->(MsSeek(xFilial("SG1")+Alltrim(_cCodPro)))

_aEstru := Estrut(_cCodPro,1)

If !Empty(_aEstru)
	For _nX := 1 To Len(_aEstru)
		_cTpProd := Posicione("SB1",1,xFilial("SB1")+AllTrim(_aEstru[_nX,2]),"B1_TIPO")
		_cTpComp := Posicione("SB1",1,xFilial("SB1")+AllTrim(_aEstru[_nX,3]),"B1_TIPO")

		If _cTpProd == "MO" .Or. _cTpComp == "MO"
			_nValMO += _aEstru[_nX,4] * SB1->B1_CUSTD 
			_nQtdMO += _aEstru[_nX,4] 
		Endif
	Next
	_cRetFil := '01'
Else 
	_cRetFil := 'Sem Estrutura'
Endif

/*
cCodPro	:= Alltrim(cCodPro)

BeginSql Alias cAliasStr

	SELECT 
		G1_FILIAL,G1_COD,G1_COMP,G1_QUANT
	FROM 
		%Table:SG1% SG1
	WHERE 
		SG1.G1_FILIAL = %xFilial:SG1% AND
		SG1.G1_COD = %Exp:cCodPro% AND
		SG1.%NotDel%
EndSql

(cAliasStr)->(dbGoTop())

While !(cAliasStr)->(Eof())

	cProdTipo	:= Posicione("SB1",1,xFilial("SB1")+Alltrim((cAliasStr)->G1_COMP),"B1_TIPO")
	
	If cProdTipo == "MO" .And. nValMO == 0  
		nValMO		+= (cAliasStr)->G1_QUANT * 1
	Endif
	
	cRetFil		:= (cAliasStr)->G1_FILIAL	

	(cAliasStr)->(dbSkip())
End

(cAliasStr)->(DbCloseArea())
*/
Return {_cRetFil,_nValMO,_nQtdMO}
