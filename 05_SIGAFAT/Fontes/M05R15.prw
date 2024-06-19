#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M05R15   � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Or�amentos Suporte T�cnico                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R15()

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
oReport := TReport():New("M05R15","Relacao de Or�amentos Suporte T�cnico","M05R15", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a rela�ao de or�amentos de venda " + " " + "relacionados ao suporte t�cnico.")
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
oVenProd := TRSection():New(oReport,"PEDIDOS SUPORTTE TECNICO",{"SCJ","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"NUM"			,/*Tabela*/	,"Num.Or�amento"	 ,PesqPict("SC5","C5_NUM")		,TamSx3("CJ_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do Pedido
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/	,"Emiss�o"	 		 ,PesqPict("SC5","CJ_EMISSAO")	,TamSx3("CJ_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmiss})		// Data de emiss�o
TRCell():New(oVenProd,"USUARIO"		,/*Tabela*/ ,"Usu�rio"			 ,PesqPict("SC5","CJ_COTCLI")	,TamSx3("CJ_COTCLI")[1]		,/*lPixel*/,{|| cUserOrc})		// Usu�rio
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/ ,"Valor"			 ,PesqPict("SCK","CK_VALOR")	,TamSx3("CK_VALOR")[1]		,/*lPixel*/,{|| nValPed	})		// Valor
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

		COLUMN CJ_EMISSAO AS DATE	

		SELECT 
			CJ_FILIAL,CJ_NUM,CJ_CLIENTE,CJ_LOJA,CJ_DESPESA,CJ_EMISSAO,CJ_USERLGI  
		FROM 
			%Table:SCJ% SCJ
		WHERE
			SCJ.CJ_FILIAL = '01' AND
			SCJ.CJ_STATUS = 'B' AND
			SCJ.CJ_EMISSAO >= %Exp:MV_PAR01% AND
			SCJ.CJ_EMISSAO <= %Exp:MV_PAR02% AND
			SCJ.%NotDel%			 
		ORDER BY SCJ.CJ_NUM
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

	cUserLgi := (cAliasQry)->CJ_USERLGI
	
//	If cUserLgi <> "0#  1@  20� 40o" .Or. cUserLgi <> " 0#  1@  00� 40n "
//		(cAliasQry)->(dbSkip())
//		Loop
//	Endif 

	If cUserLgi == "0#  1@  20� 40o"
		cUserOrc := "WALBER CANDIDO"
	ElseIf 	cUserLgi == " 0#  1@  00� 40n "
		cUserOrc := "RAUL FEITOSA"
	Else
		cUserOrc := " "
	Endif
	
	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->CJ_CLIENTE))
	
	cNum		:= (cAliasQry)->CJ_NUM
	dDtEmiss	:= (cAliasQry)->CJ_EMISSAO 
	//nUserPed	:= IIF("RAUL" $ (cAliasQry)->CJ_XINCLUI,"RAUL FEITOSA DA SILVA","WALBER CANDIDO DE MOURA SILVA")

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
    
    nValPed	:= U_M5R15TOT((cAliasQry)->CJ_NUM)[1] + (cAliasQry)->CJ_DESPESA
        		
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
���Programa  � M5R15TOT � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor total dos itens do pedido de venda         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M5R15TOT(cNumOrc)

Local nTotOrc	:= 0
Local nTotDesc	:= 0
Local cAliasTot := GetNextAlias()
Local cAliasAvg := GetNextAlias()

BeginSql Alias cAliasTot

	SELECT 
		SUM(CK_XVLTBRU) AS TOTAL
	FROM 
		%Table:SCK% SCK
	WHERE 
		SCK.CK_NUM = %Exp:cNumOrc% AND
		SCK.%NotDel%
EndSql

BeginSql Alias cAliasAvg

	SELECT 
		AVG(CK_DESCONT) AS PERDESC
	FROM 
		%Table:SCK% SCK
	WHERE 
		SCK.CK_NUM = %Exp:cNumOrc% AND
		SCK.CK_DESCONT <> 0 AND
		SCK.%NotDel%
EndSql

nTotOrc		:= (cAliasTot)->TOTAL
nTotDesc	:= (cAliasAvg)->PERDESC

(cAliasTot)->(DbCloseArea())
(cAliasAvg)->(DbCloseArea())

Return {nTotOrc,nTotDesc}
