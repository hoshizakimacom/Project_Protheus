#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M05R19   � Autor � Cleber Maldonado      � Data � 23/09/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Contatos X Clientes                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R19()

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
oReport := TReport():New("M05R19","Contatos X Clientes","M05R19", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de contatos" + " " + "por cliente.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SA1","SU5"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/	,"C�digo"	 		 ,PesqPict("SA1","A1_COD")		,TamSx3("A1_COD")[1]		,/*lPixel*/,{|| cCodCli	})		// C�digo do cliente
TRCell():New(oVenProd,"LOJA"		,/*Tabela*/ ,"Loja"				 ,PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA")[1]		,/*lPixel*/,{|| cCodLoj	})		// Loja do cliente
TRCell():New(oVenProd,"RAZAO"		,/*Tabela*/ ,"Razao Social"		 ,PesqPict("SA1","A1_NOME")	    ,TamSx3("A1_NOME")[1]   	,/*lPixel*/,{|| cNome	})		// Item Planta
TRCell():New(oVenProd,"FANTASIA"	,/*Tabela*/	,"Nome Fantasia"	 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]	    ,/*lPixel*/,{|| cNReduz	})		// Nome Fantasia
TRCell():New(oVenProd,"CONTATO"		,/*Tabela*/ ,"Nome Contato"		 ,PesqPict("SU5","U5_CONTAT")	,TamSx3("U5_CONTAT")[1]		,/*lPixel*/,{|| cNomCont})		// Nome do Contato
TRCell():New(oVenProd,"TELEFONE"	,/*Tabela*/ ,"Telefone"			 ,PesqPict("SU5","U5_FCOM1")	,TamSx3("U5_FCOM1")[1]		,/*lPixel*/,{|| cFone	})		// Telefone Comercial
TRCell():New(oVenProd,"EMAIL"		,/*Tabela*/ ,"E-mail"			 ,PesqPict("SU5","U5_EMAIL")    ,TamSx3("U5_EMAIL")[1]	    ,/*lPixel*/,{|| cEmail	})		// Email do contato

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
dbSelectArea("AC8")		// Amarra��o Contatos X Entidade
dbSetOrder(1)			// Filial+Codigo+Loja

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			AC8_FILIAL,AC8_ENTIDA,AC8_CODENT,AC8_CODCON
		FROM 
			%Table:AC8% AC8
		WHERE 
			AC8.%NotDel%
		ORDER BY AC8.AC8_CODENT
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

    cCodCli  := Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->AC8_CODENT,"A1_COD")
    cCodLoj  := Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->AC8_CODENT,"A1_LOJA") 
    cNome    := Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->AC8_CODENT,"A1_NOME")
    cNReduz  := Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->AC8_CODENT,"A1_NREDUZ")
    cNomCont := Posicione("SU5",1,xFilial("SU5")+(cAliasQry)->AC8_CODCON,"U5_CONTAT")
    cFone    := Posicione("SU5",1,xFilial("SU5")+(cAliasQry)->AC8_CODCON,"U5_FCOM1")
    cEmail   := Posicione("SU5",1,xFilial("SU5")+(cAliasQry)->AC8_CODCON,"U5_EMAIL")
    
    oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
	oReport:IncMeter()
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return