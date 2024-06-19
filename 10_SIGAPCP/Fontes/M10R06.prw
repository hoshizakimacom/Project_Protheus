#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R06   � Autor � Cleber Maldonado      � Data � 27/03/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Itens para Qualidade                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R06()

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
oReport := TReport():New("M10R06","ITENS FATURADOS X QUALIDADE","M10R06", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de itens dos pedidos " + " " + "de venda para acompanhamento da qualidade.")
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
oVenProd := TRSection():New(oReport,"ITENS FATURADOS X QUALIDADE",{"SC5","SC6"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"

oVenProd:SetTotalInLine(.F.) 

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/	,"Produto"	 		 ,PesqPict("SC6","C6_PRODUTO")	,TamSx3("C6_PRODUTO")[1]	,/*lPixel*/,{|| cProduto})		// C�digo do Produto
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descri��o"		 ,PesqPict("SC6","C6_DESCRI")	,TamSx3("C6_DESCRI")[1]		,/*lPixel*/,{|| cDescri	})		// Descri��o do Produto
TRCell():New(oVenProd,"QUANTIDADE"	,/*Tabela*/ ,"Quantidade"		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_VALOR")[1]		,/*lPixel*/,{|| nQuant	})		// Quantidade
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/	,"Valor"			 ,PesqPict("SC6","C6_VALOR")	,TamSx3("C6_VALOR")[1]		,/*lPixel*/,{|| nValor	})		// Valor
TRCell():New(oVenProd,"PEDIDO"		,/*Tabela*/ ,"Num.Pedido"		 ,PesqPict("SC6","C6_NUM")		,TamSx3("C6_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"EMISSAO"		,/*Tabebla*/,"Emiss�o"			 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]+2	,/*lPixel*/,{|| dDatEmis})		// Data de emiss�o

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

Local	cVend1	:= ''
Local	cTipo	:= ''
Private	lPosB1	:= .F.
Private	lPosC5	:= .F.

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN D2_EMISSAO AS DATE	

		SELECT 
			SD2.D2_FILIAL,SD2.D2_EMISSAO,SD2.D2_PEDIDO,SD2.D2_EMISSAO,SD2.D2_COD,SD2.D2_QUANT,SD2.D2_TOTAL
		FROM 
			%Table:SD2% SD2
		WHERE 
			SD2.D2_FILIAL = '01' AND
			SD2.D2_EMISSAO >= %Exp:MV_PAR01% AND
			SD2.D2_EMISSAO <= %Exp:MV_PAR02% AND
			SD2.%NotDel%
		ORDER BY SD2.D2_EMISSAO
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
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cVend1	:= Posicione("SC5",1,xFilial("SC5")+(cAliasQry)->D2_PEDIDO,"C5_VEND1")
	cTipo	:= Posicione("SC5",1,xFilial("SC5")+(cAliasQry)->D2_PEDIDO,"C5_TIPO") 		
	// +----------------------------------------------+
	// | Desconsidero pedidos de venda gerados pelo   |
	// | suporte t�cnico.                             |
	// +----------------------------------------------+
	
	If cVend1 == "000008" .Or. cVend1 == "000007" .Or. cTipo <> "N" 
    	(cAliasQry)->(dbSkip())
    	Loop		
	Endif

	cProduto	:= (cAliasQry)->D2_COD
	cDescri		:= Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D2_COD,"B1_DESC") 
	nQuant		:= (cAliasQry)->D2_QUANT
	nValor		:= (cAliasQry)->D2_TOTAL
	cNum		:= (cAliasQry)->D2_PEDIDO
	dDatEmis	:= (cAliasQry)->D2_EMISSAO
    		
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return
