#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 31/02/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de valoriza��o da produ��o                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R10()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 31/02/19 ���
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
oReport := TReport():New("M10R10","Valor X Produ��o","M10R10", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao do valor de VENDA em rela��o " + " " + " aos movimentos de ordem de produ��o.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SD3","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SD3","D3_FILIAL")	,TamSx3("D3_FILIAL")[1]			,/*lPixel*/,{|| cFilia	})		// Filial
TRCell():New(oVenProd,"TPMOVI"		,/*Tabela*/ ,"Tip. Movimento"	 ,PesqPict("SD3","D3_TM")		,TamSx3("D3_TM")[1]				,/*lPixel*/,{|| cTpMov	})		// Tipo de Movimento
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"			 ,PesqPict("SD3","D3_COD")		,TamSx3("D3_COD")[1]			,/*lPixel*/,{|| cCod	})		// Item Planta
TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descricao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]			,/*lPixel*/,{|| cDesc	})		// Descri��o do Produto
TRCell():New(oVenProd,"FAMILIA"		,/*Tabela*/ ,"Familia"			 ,PesqPict("SB1","B1_XDSCFAM")	,TamSx3("B1_XDSCFAM")[1]-140	,/*lPixel*/,{|| cFamilia})		// Familia
TRCell():New(oVenProd,"QUANT"		,/*Tabela*/ ,"Quantidade"		 ,PesqPict("SD3","D3_QUANT")  	,TamSx3("D3_QUANT")[1]			,/*lPixel*/,{|| nQuant	})		// Quantidade
TRCell():New(oVenProd,"NUMOP"		,/*Tabela*/ ,"Nr. O.P."			 ,PesqPict("SD3","D3_DOC")		,TamSx3("D3_DOC")[1] 			,/*lPixel*/,{|| cNumOP	})		// Numero da Ordem de Produ��o
TRCell():New(oVenProd,"LOCAL"		,/*Tabela*/ ,"Armazem"			 ,PesqPict("SD3","D3_LOCAL")	,TamSx3("D3_LOCAL")[1]			,/*lPixel*/,{|| cLocal	})		// Local do Armazem
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Dt.Emissao"		 ,PesqPict("SD3","D3_EMISSAO")	,TamSx3("D3_EMISSAO")[1]		,/*lPixel*/,{|| dDtEmiss})		// Data de Emiss�o
TRCell():New(oVenProd,"PARCTOT"		,/*Tabela*/ ,"Parcial/Total"	 ,PesqPict("SD3","D3_PARCTOT")	,TamSx3("D3_PARCTOT")[1] 		,/*lPixel*/,{|| cParcTot})		// Parcial/Total
TRCell():New(oVenProd,"VLUNIBRU"	,/*Tabela*/ ,"Vlr.Unit.Bruto"	 ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1] 		,/*lPixel*/,{|| nVlrUniB})		// Valor unit�rio bruto
TRCell():New(oVenProd,"VLRTOTAL"	,/*Tabela*/ ,"Vlr.Total"	 	 ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1] 		,/*lPixel*/,{|| nVlrTot })		// Valor Total

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 31/02/19 ���
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
Local lPosC6	:= .F.
Local cChavOP	:= ""

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SD3")		// Movimentos Internos
dbSetOrder(1)			// Ord Producao + Produto + Armazem
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(7)			// Numero OP + Item da OP

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			D3_FILIAL,D3_TM,D3_CF,D3_COD,D3_QUANT,D3_DOC,D3_LOCAL,D3_EMISSAO,D3_PARCTOT
		FROM 
			%Table:SD3% SD3
		WHERE 
			SD3.D3_FILIAL >= %Exp:MV_PAR01% AND
			SD3.D3_FILIAL <= %Exp:MV_PAR02% AND
			SD3.D3_EMISSAO >= %Exp:MV_PAR03% AND
			SD3.D3_EMISSAO <= %Exp:MV_PAR04% AND
			SD3.D3_CF = 'PR0' AND 
			SD3.%NotDel%
		ORDER BY SD3.D3_EMISSAO
	EndSql 
	//  AND CW8_CAMPO NOT IN ( %exp:cpart% )
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
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cChavOP		:= Substr((cAliasQry)->D3_DOC,1,8)

	lPosB1 		:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->D3_COD))
	lPosC6		:= SC6->(MsSeek(xFilial("SC6")+Alltrim(cChavOP)))

	cFilia		:= (cAliasQry)->D3_FILIAL
	cTpMov		:= (cAliasQry)->D3_TM
	cCod		:= (cAliasQry)->D3_COD
	nQuant		:= (cAliasQry)->D3_QUANT
	cNumOP		:= (cAliasQry)->D3_DOC
	cLocal		:= (cAliasQry)->D3_LOCAL
	dDtEmiss	:= (cAliasQry)->D3_EMISSAO
	cParcTot	:= (cAliasQry)->D3_PARCTOT
	
	// Busca valor unit�rio bruto do produto no pedido de venda que originou a Ordem de Produ��o
	// Caso n�o encontre o item do pedido, buscar o ultimo valor unit�rio bruto praticado
	If lPosC6
		nVlrUniB	:= ( SC6->C6_XVLTBRU / SC6->C6_QTDVEN ) 
	Else
		nVlrUniB	:= U_R10VTOT( cCod )
	Endif
	
	nVlrTot		:= ( nVlrUniB * nQuant ) 

    If lPosB1
    	cDesc 		:= SB1->B1_DESC
    	cFamilia	:= SB1->B1_XDSCFAM 	
	Else
		cDesc 		:= "PRODUTO N�O CADASTRADO."
		cFamilia	:= "PRODUTO N�O CADASTRADO."
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 31/02/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisa atrav�s do c�digo do produto qual o ultimo pedido ���
���          � de venda do mesmo e retorna o pre�o de venda praticado     ���
���          � com impostos.                                              ���
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
User Function R10VTOT(cCodProd)

Local	nValRet 	:= 0
Local 	cAliasTot	:= GetNextAlias()	

BeginSql Alias cAliasTot

	SELECT 
		C6_FILIAL, C6_NUM,C6_PRODUTO, C6_QTDVEN, C6_XVLUBRU 
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_FILIAL = '01' AND 
		SC6.C6_PRODUTO = %Exp:cCodProd% AND
		SC6.C6_XVLUBRU > 0 AND  
		SC6.%NotDel%
	ORDER BY 
		SC6.C6_NUM
EndSql

(cAliasTot)->(dbGoBottom())
(cAliasTot)->(dbSkip(-1))
nValRet := (cAliasTot)->C6_XVLUBRU

(cAliasTot)->(dbCloseArea())

Return nValRet 