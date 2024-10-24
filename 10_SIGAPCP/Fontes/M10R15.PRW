#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R15   � Autor � Cleber Maldonado      � Data � 16/10/21 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Dias Em Estoque                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R15()

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
oReport := TReport():New("M10R15","DIAS EM ESTOQUE" + Alltrim(DTOC(ddatabase)) ,"M10R15", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de dias em estoque por produto," + " " + " de acordo com seu numero de s�rie.")
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
oVenProd := TRSection():New(oReport,"DIAS EM ESTOQUE",{"SCK","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/ ,"Filial"			,PesqPict("SB1","B1_FILIAL")	,TamSx3("B1_FILIAL")[1]		,/*lPixel*/,{|| _cFilial })	// Filial
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"		 	,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| _cCodPrd })	// Codigo do produto
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descricao"		,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| _cDesc	 })	// Descri��o do produto
TRCell():New(oVenProd,"FAMILIA"		,/*Tabela*/ ,"Familia"			,PesqPict("SB1","B1_CODITE")	,TamSx3("B1_CODITE")[1]		,/*lPixel*/,{|| _cDescFam})	// Familia de produto
TRCell():New(oVenProd,"NUMSER"		,/*Tabela*/ ,"Numero de Serie"	,PesqPict("ZAB","ZAB_NUMSER")	,TamSx3("ZAB_NUMSER")[1]	,/*lPixel*/,{|| _cNumSer })	// Numero de S�rie do Produto
TRCell():New(oVenProd,"DIASEST"		,/*Tabela*/ ,"Dias Estoque"		,PesqPict("SB1","B1_NUMCQPR")	,TamSx3("B1_NUMCQPR")[1]	,/*lPixel*/,{|| _nDiasEst})	// Numero de dias em estoque

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
dbSelectArea("ZAB")		// Itens do Or�amento
dbSetOrder(1)			// Produto,Numero

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			ZAB_FILIAL,ZAB_CODPRO,ZAB_NUMSER,ZAB_NOTA,ZAB_APONTA  
		FROM 
			%Table:ZAB% ZAB
		WHERE 
			ZAB.ZAB_FILIAL = '  ' AND
			ZAB.ZAB_APONTA <> ' ' AND
			ZAB.ZAB_NOTA = '      ' AND 
			ZAB.ZAB_OPTRAN = '      ' AND
			ZAB.%NotDel%
		ORDER BY ZAB.ZAB_NUMSER
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
dbSelectArea("SD3")
dbSetOrder(18)

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init() 

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosD3 	:= SD3->(MsSeek(xFilial("SD3")+(cAliasQry)->ZAB_NUMSER))

	If lPosD3 
		_dDatProd := SD3->D3_EMISSAO
	Else
		_dDatProd := ddatabase
	EndIf

	_cFilial  := "01"
	_cCodPrd  := (cAliasQry)->ZAB_CODPRO
	_cDesc    := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->ZAB_CODPRO,"B1_DESC")
	_cDescFam := AllTrim(Posicione("ZA1",1,xFilial("ZA1")+SB1->B1_XFAMILI,"ZA1_DESC"))
	_cNumSer  := (cAliasQry)->ZAB_NUMSER
	_nDiasEst := ( ddatabase - _dDatProd )
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return
