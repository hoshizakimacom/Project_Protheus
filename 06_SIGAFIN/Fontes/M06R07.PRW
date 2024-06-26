#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06R03   � Autor � Cleber Maldonado      � Data � 28/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � EDI - MC Donalds       			                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06R07()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 28/08/17 ���
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
oReport := TReport():New("M06R07","EDI - MC Donalds","M06R07", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de t�tulos conforme " + " " + "EDI do cliente Arcos Dourados. (McDonalds)")
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
oVenProd := TRSection():New(oReport,"EDI - MC DONALDS",{"SC5","SC6"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"RAZAOSM0"	,/*Tabela*/ ,"Razao Social Forn."	,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cRazaoSM0})		// Raz�o Social do Fornecedor
TRCell():New(oVenProd,"CNPJSM0"		,/*Tabela*/ ,"CNPJ Forn."			,PesqPict("SA1","A1_CGC")		,TamSx3("A1_CGC")[1]		,/*lPixel*/,{|| cCnpjSM0 })		// CNPJ do Fornecedor
TRCell():New(oVenProd,"NOTA"		,/*Tabela*/	,"Nota Fiscal"		 	,PesqPict("SE1","E1_NUMNOTA")	,TamSx3("E1_NUMNOTA")[1]	,/*lPixel*/,{|| cNumNota })		// Numero da Nota
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Emissao"			 	,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao })		// Data de Emissao
TRCell():New(oVenProd,"VENCTO"		,/*Tabela*/	,"Vencimento"	 	 	,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dVencto	 })		// Data de Vencimento
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/	,"Valor"			 	,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nVlraPgt })		// Valor a Pagar
TRCell():New(oVenProd,"CNPJ"		,/*Tabela*/	,"CNPJ Arcos Dourados" 	,PesqPict("SA1","A1_CGC")		,TamSx3("A1_CGC")[1]		,/*lPixel*/,{|| cCnpj	 })		// CNPJ do Cliente
TRCell():New(oVenProd,"IDLOJA"		,/*Tabela*/ ,"Sigla"				,PesqPict("SA1","A1_XIDLOJA")	,TamSx3("A1_XIDLOJA")[1]	,/*lPixel*/,{|| cXIDLoja })		// Sigla da Loja
TRCell():New(oVenProd,"PEDCEN"		,/*Tabela*/ ,"Pedido Central"		,PesqPict("SC5","C5_XPEDCEN")	,TamSx3("C5_XPEDCEN")[1]	,/*lPixel*/,{|| cXPedCen })		// Pedido Central
TRCell():New(oVenProd,"ORDCOMP"		,/*Tabela*/ ,"Ordem de Compra"		,PesqPict("SC5","C5_XCOTCLI")	,TamSx3("C5_XCOTCLI")[1]	,/*lPixel*/,{|| cOrdCom })		// Ordem de Compra
TRCell():New(oVenProd,"STATUS"		,/*Tabela*/ ,"Status"			 	,PesqPict("SE1","E1_NATUREZ")	,TamSx3("E1_NATUREZ")[1]	,/*lPixel*/,{|| cStatus	})		// Status de Pagamento
TRCell():New(oVenProd,"DESCPAG"		,/*Tabela*/ ,"Desc. Con. Pag."	    ,PesqPict("SC5","C5_XDESPAG")	,TamSx3("C5_XDESPAG")[1]	,/*lPixel*/,{|| cDescPag})      // Descri��o da Condi��o de Pagamento
TRCell():New(oVenProd,"RESPONSA"	,/*Tabela*/ ,"Responsavel"          ,PesqPict("SU5","U5_CONTAT")	,TamSx3("U5_CONTAT")[1]     ,/*lPixel*/,{|| cContat  })     // Nome do contato
TRCell():New(oVenProd,"EMAIL"       ,/*Tabela*/ ,"E-mail"               ,PesqPict("SU5","U5_EMAIL")     ,TamSx3("U5_EMAIL")[1]      ,/*lPixel*/,{|| cEmail   })     // Endere�o de Email
TRCell():New(oVenProd,"DESCDEPTO"	,/*Tabela*/ ,"Departamento"	        ,PesqPict("SUM","UM_DESC")      ,TamSx3("UM_DESC")[1]       ,/*lPixel*/,{|| cDescDpto})     // Descri��o do Departamento.


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
dbSelectArea("SCJ")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN E1_VENCTO AS DATE
		COLUMN E1_EMISSAO AS DATE
		COLUMN E1_BAIXA AS DATE

		SELECT 
			E1_FILIAL,E1_CLIENTE,E1_NOMCLI,E1_LOJA,E1_PEDIDO,E1_NUMNOTA,E1_EMISSAO,E1_NUM,E1_HIST,
			E1_VENCTO,E1_PARCELA,E1_VALOR,E1_BAIXA,E1_VALOR,E1_CHAVENF,E1_SALDO,E1_TIPO,E1_SALDO,E1_PEDIDO
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_CLIENTE = '002953' AND
			SE1.E1_FILIAL >= %Exp:MV_PAR01% AND
			SE1.E1_FILIAL <= %Exp:MV_PAR02% AND
			SE1.E1_PEDIDO >= %Exp:MV_PAR03% AND
			SE1.E1_PEDIDO <= %Exp:MV_PAR04% AND
			SE1.E1_EMISSAO >= %Exp:MV_PAR05% AND
			SE1.E1_EMISSAO <= %Exp:MV_PAR06% AND
			SE1.E1_TIPO NOT IN ('RA' , 'NCC' , 'PVA') AND			
			SE1.%NotDel%
		ORDER BY SE1.E1_NUM
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
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SE1")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SF2")
dbSetOrder(2)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosC5	:= SC5->(MsSeek(xFilial('SC5')+(cAliasQry)->E1_PEDIDO))
	
	If lPosA1
		cCnpj		:= SA1->A1_CGC
		cXIDLoja	:= SA1->A1_XIDLOJA 
	Else
		cCnpj		:= ""
		cXIDLoja	:= ""
	Endif

	If (cAliasQry)->E1_VENCTO < ddatabase
		cStatus	:= "ATRASADO"
	Else
		cStatus := "A VENCER"
	Endif

	cCnpjSM0	:= "43553668000179"
	cRazaoSM0	:= "ACOS MACOM IND. E COM. LTDA."	
	cNumNota	:= (cAliasQry)->E1_NUM
	dEmissao	:= (cAliasQry)->E1_EMISSAO
	dVencto		:= (cAliasQry)->E1_VENCTO
	nVlraPgt	:= (cAliasQry)->E1_VALOR
	
	If lPosC5
		cOrdCom		:= SC5->C5_XCOTCLI
		cXPedCen	:= SC5->C5_XPEDCEN
		cDescPag	:= SC5->C5_XDESPAG
		cCodFun		:= Posicione("SU5",1,xFilial("SU5")+SC5->C5_XCONT,"U5_FUNCAO")
		cDescDpto	:= Posicione("SUM",1,xFilial("SUM")+cCodFun,"UM_DESC")
		cContat 	:= Posicione("SU5",1,xFilial("SU5")+SC5->C5_XCONT,"U5_CONTAT")
		cEmail  	:= Posicione("SU5",1,xFilial("SU5")+SC5->C5_XCONT,"U5_EMAIL")
	Else
		cOrdCom		:= ""
		cXPedCen	:= ""
		cDescPag	:= ""
		cDescDpto   := ""
		cContat     := ""
		cEmail  	:= ""
	Endif
	
	If (cAliasQry)->E1_SALDO == 0
		nVlrPgto	:= (cAliasQry)->E1_VALOR
		cStatus		:= "BAIXADO"
	ElseIf (cAliasQry)->E1_SALDO == (cAliasQry)->E1_VALOR
		nVlrPgto	:= 0
	Else
		nVlrPgto	:= ((cAliasQry)->E1_VALOR - (cAliasQry)->E1_SALDO)
	Endif
			
	Do Case
		Case MV_PAR07 == 1 .And. cStatus == 'BAIXADO'
			oReport:IncMeter()
			oReport:Section(1):PrintLine()
		Case MV_PAR07 == 2 .And. cStatus == 'A VENCER'
			oReport:IncMeter()
			oReport:Section(1):PrintLine()
		Case MV_PAR07 == 3 .And. cStatus == 'ATRASADO'
			oReport:IncMeter()
			oReport:Section(1):PrintLine()
		Case MV_PAR07 == 4
			oReport:IncMeter()
			oReport:Section(1):PrintLine()
	EndCase
         
	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return