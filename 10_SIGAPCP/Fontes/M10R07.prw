#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 04/04/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Numeros de S�rie dos Itens do Pedido de Vendas  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R07()

Local oReport

cUsuario := RetCodUsr()

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
oReport := TReport():New("M10R07","Numeros de S�rie dos Itens do Pedido","M10R07", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de numeros de s�rie " + " " + "dos itens do pedido de vendas.")
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
oVenProd := TRSection():New(oReport,"NUMEROS DE S�RIE X PEDIDO",{"ZA0","SC1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de numeros de s�rie"
oVenProd:SetTotalInLine(.F.) 

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/	,"Cod.Produto" 		 ,PesqPict("ZAB","ZAB_CODPRO")	,TamSx3("ZAB_CODPRO")[1]	,/*lPixel*/,{|| cProd	})		// Numero do Pedido
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descri��o Produto" ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})		// Numero de s�rie
TRCell():New(oVenProd,"NUM SERIE"	,/*Tabela*/ ,"Num.S�rie"		 ,PesqPict("ZAB","ZAB_NUMSER")	,TamSx3("ZAB_NUMSER")[1]	,/*lPixel*/,{|| cNumSer	})		// Numero de s�rie
TRCell():New(oVenProd,"NUM PEDIDO"	,/*Tabela*/	,"Num.Pedido"		 ,PesqPict("SC5","ZAB_NUMPV")	,TamSx3("ZAB_NUMPV")[1]		,/*lPixel*/,{|| cNum	})		// Quantidade Impressa
TRCell():New(oVenProd,"ITEM PEDIDO"	,/*Tabela*/	,"Item Pedido"		 ,PesqPict("ZAB","ZAB_ITEMPV")	,TamSx3("ZAB_ITEMPV")[1]	,/*lPixel*/,{|| cItem 	})		// C�digo do Produto
TRCell():New(oVenProd,"EMISSAO PED"	,/*Tabela*/ ,"Emiss�o Pedido"	 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]	,/*lPixel*/,{|| dData	})		// Data
TRCell():New(oVenProd,"NUM OP"		,/*Tabela*/ ,"Num.OP"			 ,PesqPict("ZAB","ZAB_NUMOP")	,TamSx3("ZAB_NUMOP")[1]		,/*lPixel*/,{|| cOP		})		// Numero de s�rie


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
dbSelectArea("ZAB")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN C5_EMISSAO AS DATE		
		
		SELECT 
			ZAB_CODPRO, ZAB_NUMSER, ZAB_NUMOP, ZAB_NUMPV, ZAB_ITEMPV, ZAB_NOTA, C5_EMISSAO
		FROM 
			%Table:ZAB% ZAB010

		INNER JOIN %Table:SC5% SC5010 ON C5_FILIAL = '01' AND C5_NUM = ZAB_NUMPV AND SC5010.D_E_L_E_T_ = ''
		INNER JOIN %Table:SC2% SC2010 ON C2_FILIAL = '01' AND C2_NUM = ZAB_NUMOP AND C2_PRODUTO = ZAB_CODPRO AND SC2010.D_E_L_E_T_ = ''

		WHERE 
			ZAB_FILIAL = '  ' 
		AND ZAB_NUMOP <> '' 
		AND ZAB_NUMPV >= %Exp:MV_PAR01% 
		AND ZAB_NUMPV <= %Exp:MV_PAR02%
		AND C5_EMISSAO>= %Exp:MV_PAR03% 
		AND C5_EMISSAO<= %Exp:MV_PAR04%
		AND ZAB010.D_E_L_E_T_ = ''

		GROUP BY ZAB_CODPRO, ZAB_NUMSER, ZAB_NUMOP, ZAB_NUMPV, ZAB_ITEMPV, ZAB_NOTA, C5_EMISSAO
		ORDER BY ZAB_NUMPV, ZAB_NOTA 
		
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
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
	
	cNum		:= (cAliasQry)->ZAB_NUMPV
	cItem		:= (cAliasQry)->ZAB_ITEMPV
	cNumSer		:= (cAliasQry)->ZAB_NUMSER
	dData		:= (cAliasQry)->C5_EMISSAO
	cProd		:= (cAliasQry)->ZAB_CODPRO
	cDesc		:= Posicione("SB1",1,xFilial("SB1")+AllTrim((cAliasQry)->ZAB_CODPRO),"B1_DESC")
	cOP		    := (cAliasQry)->ZAB_NUMOP
				
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return
