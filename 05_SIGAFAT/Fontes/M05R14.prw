#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Pedidos Suporte T�cnico                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R14()

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
oReport := TReport():New("M05R14","Relacao de Pedidos Suporte Tecnico","M05R14", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de pedidos de venda relacionados " + " " + "ao suporte t�cnico para os vendedores WALBER e ISABELA.")
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
oVenProd := TRSection():New(oReport,"PEDIDOS SUPORTTE TECNICO",{"SC5","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUM"			,/*Tabela*/	,"Pedido"	 		 ,PesqPict("SC5","C5_NUM")		,TamSx3("C5_NUM")[1]-60		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/	,"Pedido"	 		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_NUM")[1]		,/*lPixel*/,{|| dDtEmiss})		// Data de emiss�o
TRCell():New(oVenProd,"USUARIO"		,/*Tabela*/ ,"Usu�rio"			 ,PesqPict("SC5","C5_XNDEXUZ")	,TamSx3("C5_XNDEXUZ")[1]	,/*lPixel*/,{|| nUserPed})		// Usu�rio
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/ ,"Valor"			 ,PesqPict("SC6","C6_VALOR")	,TamSx3("C6_VALOR")[1]		,/*lPixel*/,{|| nValPed	})		// Valor
TRCell():New(oVenProd,"CODCLI"		,/*Tabela*/	,"Cod.Cliente"		 ,PesqPict("SA1","A1_COD")		,TamSx3("A1_COD")[1]		,/*lPixel*/,{|| cCodCli	})		// C�digo do Cliente
TRCell():New(oVenProd,"LOJA"		,/*Tabela*/ ,"Loja"				 ,PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA")[1]		,/*lPixel*/,{|| cLojCli	})		// Loja do Cliente
TRCell():New(oVenProd,"NOMECLI"		,/*Tabela*/	,"Raz�o Social"		 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNomCli	})		// Raz�o Social do Cliente
TRCell():New(oVenProd,"FANTASIA"	,/*Tabela*/	,"Nome Fantasia"	 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]		,/*lPixel*/,{|| cNomRed	})		// Nome Fantasia do Cliente

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
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN C5_EMISSAO AS DATE	

		SELECT 
			C5_FILIAL,C5_NUM,C5_XINCLUI,C5_CLIENTE,C5_LOJACLI,C5_DESPESA,C5_EMISSAO  
		FROM 
			%Table:SC5% SC5
		WHERE
			SC5.C5_FILIAL = '01' AND
			SC5.C5_TIPO = 'N' AND
			SC5.C5_EMISSAO >= %Exp:MV_PAR01% AND
			SC5.C5_EMISSAO <= %Exp:MV_PAR02% AND
			SC5.C5_VEND1 = '000008' AND
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
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SB5")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	If ! "SARAN" $ (cAliasQry)->C5_XINCLUI .And. ! "WALBER" $ (cAliasQry)->C5_XINCLUI 
		(cAliasQry)->(dbSkip())
		Loop
	Endif 

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->C5_CLIENTE))
	
	cNum		:= (cAliasQry)->C5_NUM
	dDtEmiss	:= (cAliasQry)->C5_EMISSAO 
	nUserPed	:= IIF("SARAN" $ (cAliasQry)->C5_XINCLUI,"ISABELA RODRIGUES SARAN","WALBER CANDIDO DE MOURA SILVA")

    If lPosA1
		cCodCli := SA1->A1_COD
		cLojCli := SA1->A1_LOJA
    	cNomCli := SA1->A1_NOME
    	cNomRed	:= SA1->A1_NREDUZ
    Else
		cCodCli := " "
		cLojCli := " "
    	cNomCli := " "
    	cNomRed	:= " "
    Endif
    
    nValPed	:= U_M5R14TOT((cAliasQry)->C5_NUM)[1] + (cAliasQry)->C5_DESPESA
        		
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
User Function M5R14TOT(cNumPed)

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
