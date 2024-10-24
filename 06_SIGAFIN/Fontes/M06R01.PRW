#INCLUDE "MATR620.ch"
#INCLUDE "PROTHEUS.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06R01   � Autor � Cleber Maldonado      � Data � 07/07/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Titulos                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06R01()

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
Local oTitulos
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
oReport := TReport():New("M06R01","Rela�ao de Titulos","M06R01", {|oReport| ReportPrint(oReport,cAliasQry,oTitulos)},"Este relatorio emite a relacao de titulos de acordo " + " " + " com os par�metros informados.")
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
oTitulos := TRSection():New(oReport,STR0023,{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oTitulos:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oTitulos,"FILIAL"      ,/*Tabela*/ ,"Filial"                       ,PesqPict("SE1","E1_FILIAL")    ,TamSx3("E1_FILIAL")[1]     ,/*lPixel*/,{|| cXFilial })     // C�digo da Filial
TRCell():New(oTitulos,"NUMPED"		,/*Tabela*/	,"Num.Pedido"					,PesqPict("SE1","E1_PEDIDO")	,TamSx3("E1_PEDIDO")[1]		,/*lPixel*/,{|| cNumPed	 })		// Numero do Pedido
TRCell():New(oTitulos,"ORIGEM"		,/*Tabela*/ ,"Origem"						,PesqPict("SE1","E1_CCC")		,TamSx3("E1_CCC")[1]		,/*lPixel*/,{|| cOrigem	 })		// Origem do T�tulo (BOL=PEDIDO / NF=NOTAFISCAL)
TRCell():New(oTitulos,"EMISSAO"		,/*Tabela*/ ,"Emissao"						,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao })		// Data de Emiss�o do Pedido
TRCell():New(oTitulos,"CLIENTE"		,/*Tabela*/ ,"Cod.Cliente"					,PesqPict("SA1","E1_CLIENTE")   ,TamSx3("E1_CLIENTE")[1]	,/*lPixel*/,{|| cCodCli  })		// C�digo do Cliente
TRCell():New(oTitulos,"LOJA"		,/*Tabela*/ ,"Loja"							,PesqPict("SE1","E1_LOJA")		,TamSx3("E1_LOJA")[1]	 	,/*lPixel*/,{|| cLoja	 })		// Loja do Cliente
TRCell():New(oTitulos,"RAZAO"		,/*Tabela*/ ,"Razao Social"					,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1] 		,/*lPixel*/,{|| cNome	 })		// Raz�o Social do Cliente
TRCell():New(oTitulos,"CNPJ"		,/*Tabela*/ ,"CNPJ"							,PesqPict("SA1","A1_CGC")		,TamSx3("A1_CGC")[1]		,/*lPixel*/,{|| cCGC	 })		// CNPJ do Cliente
TRCell():New(oTitulos,"UF"			,/*Tabela*/ ,"UF"							,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cUF		 })		// UF do Cliente
TRCell():New(oTitulos,"NUMTIT"		,/*Tabela*/ ,"Num.Titulo"					,PesqPict("SE1","E1_NUM")		,TamSx3("E1_NUM")[1]		,/*lPixel*/,{|| cNumTit	 })		// Numero do T�tulo
TRCell():New(oTitulos,"PARCELA"		,/*Tabela*/ ,"Parcela"						,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cParcela })		// Parcela do T�tulo
TRCell():New(oTitulos,"CONDPGTO"	,/*Tabela*/ ,"Cond.Pgto"					,PesqPict("SC5","C5_CONDPAG")	,TamSx3("C5_CONDPAG")[1]	,/*lPixel*/,{|| cCodPgto })		// C�digo da Condi��o de Pagamento
TRCell():New(oTitulos,"DESCRICAO"	,/*Tabela*/ ,"Descri�ao"					,PesqPict("SE4","E4_DESCRI")	,TamSx3("E4_DESCRI")[1]		,/*lPixel*/,{|| cDesPgto })		// Descri��o da Condi��o de Pagamento
TRCell():New(oTitulos,"HISTORICO"	,/*Tabela*/ ,"Historico"					,PesqPict("SE1","E1_HIST")		,TamSx3("E1_HIST")[1]		,/*lPixel*/,{|| cHist	 })		// Hist�rico
TRCell():New(oTitulos,"PGTCARTAO"	,/*Tabela*/ ,"Dt.Pagto.Cartao"				,PesqPict("SE1","E1_XCARTAO")	,TamSx3("E1_XCARTAO")[1]	,/*lPixel*/,{|| dPgCartao})		// Data de Pagamento do Cart�o de Cr�dito
TRCell():New(oTitulos,"CODAUT"		,/*Tabela*/ ,"Cod.Autenticacao"				,PesqPict("SE1","E1_XCODAUT")	,TamSx3("E1_XCODAUT")[1]	,/*lPixel*/,{|| cCodAut	 })		// Codigo de autentica��o do Cart�o de Cr�dito
TRCell():New(oTitulos,"VENCTO"		,/*Tabela*/ ,"Vencimento"					,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dVencto	 })		// Data de Vencimento
TRCell():New(oTitulos,"RENEG"		,/*Tabela*/ ,"Renegocia�ao" 				,PesqPict("SE1","E1_VENCORI")	,TamSx3("E1_VENCORI")[1]	,/*lPixel*/,{|| dDatReneg})		// Data de Renegocia��o
TRCell():New(oTitulos,"PAGTO"		,/*Tabela*/	,"Dt.Pagamento" 				,PesqPict("SE1","E1_BAIXA")		,TamSx3("E1_BAIXA")[1]		,/*lPixel*/,{|| dBaixa	 })		// Data da baixa - Pagamento
TRCell():New(oTitulos,"VLRPGTO"		,/*Tabela*/	,"Vlr.Pagamento"				,PesqPict("SE1","E1_VALLIQ")	,TamSX3("E1_VALLIQ")[1]		,/*lPixel*/,{|| nVlPgto	 })		// Valor Pagamento
TRCell():New(oTitulos,"ACRE"		,/*Tabela*/ ,"Acrescimo"					,PesqPict("SE1","E1_ACRESC")	,TamSx3("E1_ACRESC")[1]		,/*lPixel*/,{|| nAcre	 })		// Valor de Acr�scimo
TRCell():New(oTitulos,"DECRE"		,/*Tabela*/ ,"Decrescimo"					,PesqPict("SE1","E1_DECRESC")	,TamSx3("E1_DECRESC")[1]	,/*lPixel*/,{|| nDecre	 })		// Valor de Decr�scimo
TRCell():New(oTitulos,"VALTIT"		,/*Tabela*/ ,"Vlr.Titulo"					,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nValor	 })		// Valor do Titulo
TRCell():New(oTitulos,"SALDO"		,/*Tabela*/ ,"Saldo"         				,PesqPict("SE1","E1_SALDO")	    ,TamSx3("E1_SALDO")[1]		,/*lPixel*/,{|| nSaldo	 })		// Saldo do t�tulo
TRCell():New(oTitulos,"XSALDO"		,/*Tabela*/ ,"Saldo a Comp."				,PesqPict("SE1","E1_XSALDO")	,TamSx3("E1_XSALDO")[1]		,/*lPixel*/,{|| nXSaldo	 })		// Saldo do t�tulo
TRCell():New(oTitulos,"VALTPED"		,/*Tabela*/ ,"Vlr.Tot.Ped."					,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nValTPed })		// Valor Total do Pedido
TRCell():New(oTitulos,"AGING"		,/*Tabela*/ ,"AGING"						,PesqPict("SB1","B1_NUMCOP")	,TamSx3("B1_NUMCOP")[1]		,/*lPixel*/,{|| nAging	 })		// Numero de dias de atraso
TRCell():New(oTitulos,"STATUS"		,/*Tabela*/ ,"Status"						,PesqPict("SE1","E1_ORIGEM")	,TamSx3("E1_ORIGEM ")[1]	,/*lPixel*/,{|| cStatus	 })		// Status do Pedido De Venda
TRCell():New(oTitulos,"PDD"			,/*Tabela*/	,"PDD"							,PesqPict("SE1","E1_ORIGEM")	,TamSx3("E1_XPDD")[1]		,/*lPixel*/,{|| dPDD	 })		// PDD - Provis�o de Devedores Duvidosos
TRCell():New(oTitulos,"PROTESTO"	,/*Tabela*/ ,"Protesto"						,PesqPict("SE1","E1_XPROTES")	,TamSx3("E1_XPROTES")[1]	,/*lPixel*/,{|| dProtest })		// Data de Protesto do T�tulo
TRCell():New(oTitulos,"WAYBACK"		,/*Tabela*/	,"Assessoria de Cobran�a"		,PesqPict("SE1","E1_XWAYBAK")	,TamSx3("E1_XWAYBAK")[1]	,/*lPixel*/,{|| cXWayBak })		// Data de envio a WayBack
TRCell():New(oTitulos,"CODVEND"		,/*Tabela*/ ,"Cod.Vend."					,PesqPict("SE1","E1_VEND1")		,TamSx3("E1_VEND1")[1]		,/*lPixel*/,{|| cCodVen	 })		// C�digo do Vendedor
TRCell():New(oTitulos,"NOME"		,/*Tabela*/	,"Nome"							,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomVen	 })		// Nome do Vendedor
TRCell():New(oTitulos,"GERENTE"		,/*Tabela*/	,"Gerente"						,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomGer	 })		// Nome do Gerente
TRCell():New(oTitulos,"CONDPAG"		,/*Tabela*/	,"% CONDPAG"					,PesqPict("SC5","C5_XPCONPG")	,TamSx3("C5_XPCONPG")[1]	,/*lPixel*/,{|| nPerCond })		// Percentual negociado para pagamento antecipado

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 07/07/17 ���
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
Static Function ReportPrint(oReport,cAliasQry,oTitulos)

Private _nTotal	:= 0
Private _nFrete	:= 0
Private _nSeguro	:= 0 
Private _nDesp	:= 0
Private _nFreteA	:= 0
Private _nAcrFin	:= 0
Private _cCondPag	:= ""
Private lPosA1	:= .F.
Private lPosC5	:= .F.

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

		COLUMN E1_XCARTAO AS DATE
		
		SELECT 
			E1_FILIAL,E1_PEDIDO,E1_TIPO,E1_PREFIXO,E1_EMISSAO,E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA,E1_VENCTO,
			E1_BAIXA,E1_PORTADO,E1_VALLIQ,E1_ACRESC,E1_DECRESC,E1_DESCON1,E1_VALOR,E1_HIST,E1_VEND1,E1_SALDO,
			E1_HIST,E1_PREFIXO,E1_XRENEG,E1_XPROTES,E1_XPDD,E1_XWAYBAK,E1_XCODAUT,E1_XCARTAO,E1_XSALDO,E1_XRAORI 
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL >= %Exp:MV_PAR01% AND
			SE1.E1_FILIAL <= %Exp:MV_PAR02% AND
			SE1.E1_EMISSAO >= %Exp:MV_PAR03% AND
			SE1.E1_EMISSAO <= %Exp:MV_PAR04% AND
			SE1.E1_VENCTO >= %Exp:MV_PAR05% AND
			SE1.E1_VENCTO <= %Exp:MV_PAR06% AND
			SE1.E1_CLIENTE <> '002953' AND
			SE1.E1_TIPO NOT IN ( 'IN-' , 'NCC' , 'RA' ) AND
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
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SE1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	If !Empty((cAliasQry)->E1_XRAORI)
		(cAliasQry)->(dbSkip())
		Loop
	Endif		 

	lPosA1 	:= SA1->(MsSeek(xFilial("SA1")+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosC5	:= SC5->(MsSeek((cAliasQry)->E1_FILIAL+(cAliasQry)->E1_PEDIDO))
	lPosE1	:= SE1->(MsSeek((cAliasQry)->E1_FILIAL+(cAliasQry)->E1_PREFIXO+(cAliasQry)->E1_NUM+(cAliasQry)->E1_PARCELA+(cAliasQry)->E1_TIPO))
	
	If lPosC5
		// Calcula o valor total do pedido considerando os impostos
		//U_M6R1TOT(SC5->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@_cCondPag)
		//nValTPed	:=	( _nTotal + _nFrete + _nSeguro + _nDesp + _nFreteA + _nAcrFin )
		nValTPed	:= U_M6R1VPED(SC5->C5_NUM)
	Else
		(cAliasQry)->(dbSkip())
		Loop		
	Endif

    If lPosC5
    	cCodPgto	:= SC5->C5_CONDPAG
    	cDesPgto	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
    	nPerCond	:= SC5->C5_XPCONPG
    Else
    	cCodPgto	:= " "
    	cDesPgto	:= " "
    	nPerCond	:= 0
    Endif	

    cXFilial    := (cAliasQry)->E1_FILIAL
	cNumPed		:= (cAliasQry)->E1_PEDIDO
	cOrigem		:= IIF(ALLTRIM((cAliasQry)->E1_TIPO) == "BOL","PEDIDO","NOTA FISCAL")
	dEmissao	:= (cAliasQry)->E1_EMISSAO
	cNumTit		:= (cAliasQry)->E1_NUM
	cParcela	:= (cAliasQry)->E1_PARCELA
	dVencto		:= (cAliasQry)->E1_VENCTO
	dBaixa		:= (cAliasQry)->E1_BAIXA
	nVlPgto		:= (cAliasQry)->E1_VALLIQ
	nAcre		:= (cAliasQry)->E1_ACRESC
	nDecre		:= (cAliasQry)->E1_DECRESC
	nValor		:= (cAliasQry)->E1_VALOR
	cCodAut		:= (cAliasQry)->E1_XCODAUT
	dPgCartao	:= (cAliasQry)->E1_XCARTAO
	nXSaldo		:= (cAliasQry)->E1_XSALDO
	nSaldo		:= (cAliasQry)->E1_SALDO
	dDatReneg	:= (cAliasQry)->E1_XRENEG


	nAging		:= IIF(Empty(dBaixa),dVencto-DDATABASE," ")
//	dAgPgto		:= IIF(Empty(dBaixa)," ",(dBaixa - dVencto))
	dPDD		:= (cAliasQry)->E1_XPDD
	dProtest	:= (cAliasQry)->E1_XPROTES
	cCodVen		:= (cAliasQry)->E1_VEND1
	cNomVen		:= Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->E1_VEND1,"A3_NOME")
	cNomGer		:= Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_NOME")
	cXWayBak	:= (cAliasQry)->E1_XWAYBAK
	cHist		:= (cAliasQry)->E1_HIST

	// Define status do t�tulo
	If !Empty(dBaixa) .And. nSaldo == 0 
			cStatus		:= "PAGO"
	Else
		If 	dVencto < DDATABASE
			cStatus		:= "ATRASADO"
		Else
			cStatus		:= "A VENCER"
		Endif
	Endif

	If MV_PAR07 <> 4
		Do Case
			Case MV_PAR07 = 1 .And. cStatus <> "PAGO"
				(cAliasQry)->(dbSkip())
				Loop
			Case MV_PAR07 = 2 .And. cStatus <> "A VENCER"
				(cAliasQry)->(dbSkip())
				Loop
			Case MV_PAR07 = 3 .And. cStatus <> "ATRASADO"
				(cAliasQry)->(dbSkip())
				Loop		
		EndCase
	Endif

	If lPosA1
		cCodCli		:= SA1->A1_COD
		cLoja		:= SA1->A1_LOJA
		cUF			:= SA1->A1_EST
		cCGC		:= SA1->A1_CGC
		cNome		:= SA1->A1_NOME
	Endif
		
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 07/07/17 ���
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
User Function M6R1TOT(_nRecnoSC5,_nTotal,_nFrete,_nSeguro,_nDesp,_nFreteA,_nAcrFin,_cCondPag)

	Local _aAreaSC5		:= SC5->(GetArea())
	Local _aArea		:= GetArea()

	Local aRelImp    	:= MaFisRelImp("MT100",{"SF2","SD2"})
	Local aFisGet    	:= Nil
	Local aFisGetSC5 	:= Nil
	Local cCliEnt	 	:= ""
	Local cNfOri     	:= Nil
	Local cSeriOri   	:= Nil
	Local nDesconto  	:= 0
	Local nRecnoSD1  	:= Nil
	Local nFrete	 	:= 0
	Local nSeguro	 	:= 0
	Local nFretAut		:= 0
	Local nDespesa		:= 0
	Local nDescCab		:= 0
	Local nPDesCab		:= 0
	Local nY         	:= 0
	Local nValMerc   	:= 0
	Local nPrcLista  	:= 0
	Local nAcresFin  	:= 0

	MA6R1FisIni(@aFisGet,@aFisGetSC5)

	cCliEnt 	:= IIf(!Empty(SC5->(FieldGet(FieldPos("C5_CLIENT")))),SC5->C5_CLIENT,SC5->C5_CLIENTE)
	_nAcrFin	:= Posicione('SE4',1,xFilial('SE4') + _cCondPag ,'E4_ACRSFIN')

	MaFisIni(	cCliEnt,;								// 1-Codigo Cliente/Fornecedor
				SC5->C5_LOJACLI,;						// 2-Loja do Cliente/Fornecedor
				If(SC5->C5_TIPO$'DB',"F","C"),;			// 3-C:Cliente , F:Fornecedor
				SC5->C5_TIPO,;							// 4-Tipo da NF
				SC5->C5_TIPOCLI,;						// 5-Tipo do Cliente/Fornecedor
				aRelImp,;								// 6-Relacao de Impostos que suportados no arquivo
				,;						   				// 7-Tipo de complemento
				,;										// 8-Permite Incluir Impostos no Rodape .T./.F.
				"SB1",;									// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				"MATA461")								// 10-Nome da rotina que esta utilizando a funcao

	nFrete		:= SC5->C5_FRETE
	nSeguro		:= SC5->C5_SEGURO
	nFretAut	:= SC5->C5_FRETAUT
	nDespesa	:= SC5->C5_DESPESA
	nDescCab	:= SC5->C5_DESCONT
	nPDesCab	:= SC5->C5_PDESCAB
	aItemPed	:= {}
	nPesBru		:= 0

	DbSelectArea('SC5')

	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&(aFisGetSC5[ny][2]))
			If aFisGetSC5[ny][1] == "NF_SUFRAMA"
				MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
			Else
				MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
			Endif
		EndIf
	Next nY

	SC6->(DbGoTop())
	SC6->(DbSetOrder(1))

	If SC6->(DbSeek( SC5->C5_FILIAL + SC5->C5_NUM ))

		//+------------------------------------
		// Percorre itens do pedido
		//+------------------------------------
		While SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM ) == SC5->C5_FILIAL + SC5->C5_NUM
			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0

			//+------------------------------------
			// Verifica se Possui NF Origem
			//+------------------------------------
			If !Empty(SC6->C6_NFORI)
				DbSelectArea("SD1")
				SD1->(dbSetOrder(1))
				SD1->(dbSeek(xFilial("SC6")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_ITEMORI))

				cNfOri     := SC6->C6_NFORI
				cSeriOri   := SC6->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
			EndIf

			DbSelectArea('SC6')

			//+------------------------------------
			//Calcula o preco de lista
			//+------------------------------------
			nValMerc  := SC6->C6_VALOR
			nPrcLista := SC6->C6_PRUNIT

			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/SC6->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
			EndIf

			nAcresFin := A410Arred(SC6->C6_PRCVEN*_nAcrFin/100,"D2_PRCVEN")
			nValMerc  += A410Arred(SC6->C6_QTDVEN*nAcresFin,"D2_TOTAL")
			nDesconto := a410Arred(nPrcLista*SC6->C6_QTDVEN,"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,SC6->C6_VALDESC,nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresFin
			nValMerc  += nDesconto

			MaFisAdd(	SC6->C6_PRODUTO				,;	// 1-Codigo do Produto ( Obrigatorio )
						SC6->C6_TES					,;	// 2-Codigo do TES ( Opcional )
						SC6->C6_QTDVEN				,;	// 3-Quantidade ( Obrigatorio )
						nPrcLista					,;	// 4-Preco Unitario ( Obrigatorio )
						nDesconto					,;	// 5-Valor do Desconto ( Opcional )
						cNfOri						,;	// 6-Numero da NF Original ( Devolucao/Benef )
						cSeriOri					,;	// 7-Serie da NF Original ( Devolucao/Benef )
						nRecnoSD1					,;	// 8-RecNo da NF Original no arq SD1/SD2
						0							,;	// 9-Valor do Frete do Item ( Opcional )
						0							,;	// 10-Valor da Despesa do item ( Opcional )
						0							,;	// 11-Valor do Seguro do item ( Opcional )
						0							,;	// 12-Valor do Frete Autonomo ( Opcional )
						nValMerc					,;	// 13-Valor da Mercadoria ( Obrigatorio )
						0							,;	// 14-Valor da Embalagem ( Opiconal )
						0							,;	// 15-RecNo do SB1
						0							)	// 16-RecNo do SF4

			aadd(aItemPed,	{	SC6->C6_ITEM					,;
									SC6->C6_PRODUTO				,;
									SC6->C6_DESCRI				,;
									SC6->C6_TES					,;
									SC6->C6_CF					,;
									SC6->C6_UM					,;
									SC6->C6_QTDVEN				,;
									SC6->C6_PRCVEN				,;
									SC6->C6_NOTA				,;
									SC6->C6_SERIE				,;
									SC6->C6_CLI					,;
									SC6->C6_LOJA				,;
									SC6->C6_VALOR				,;
									SC6->C6_ENTREG				,;
									SC6->C6_DESCONT				,;
									SC6->C6_LOCAL				,;
									SC6->C6_QTDEMP				,;
									SC6->C6_QTDLIB				,;
									SC6->C6_QTDENT				,;
								})

			//+------------------------------------
			//Forca os valores de impostos que foram
			//	informados no SC6.
			//+------------------------------------
			DbSelectArea('SC6')
			For nY := 1 to Len(aFisGet)
				If !Empty(&(aFisGet[ny][2]))
					MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
				EndIf
			Next nY

			//+------------------------------------
			//Calculo do ISS
			//+------------------------------------
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
			If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
				EndIf
			EndIf

			//+------------------------------------
			//Altera peso para calcular frete
			//+------------------------------------
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			MaFisAlt("IT_PESO",SC6->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
			MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
			MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))

			SC6->(DbSkip())
		EndDo
	EndIf

	MaFisAlt("NF_FRETE"   ,nFrete)
	MaFisAlt("NF_SEGURO"  ,nSeguro)
	MaFisAlt("NF_AUTONOMO",nFretAut)
	MaFisAlt("NF_DESPESA" ,nDespesa)

	If nDescCab > 0
		MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
	EndIf

	If nPDesCab > 0
		MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
	EndIf

	_nTotal 	:= MaFisRet(,"NF_TOTAL")
	_nFrete		:= MaFisRet(,"NF_FRETE")
	_nSeguro	:= MaFisRet(,"NF_SEGURO")
	_nDesp		:= MaFisRet(,"NF_DESPESA")
	_nFreteA	:= MaFisRet(,"NF_AUTONOMO")

	MaFisEnd()

	RestArea(_aArea)
	RestArea(_aAreaSC5)
Return

//+----------------------------------------------------------------------------------------
//|	Rotina respons�vel pela inicializa��o das referencias utilizadas no calculo do total
//+----------------------------------------------------------------------------------------
Static Function MA6R1FisIni(aFisGet,aFisGetSC5)
	Local _aAreaSX3		:= SX3->(GetArea())
	Local cValid      	:= ''
	Local cReferencia 	:= ''
	Local nPosIni     	:= 0
	Local nLen        	:= 0

	If aFisGet == Nil
		aFisGet	:= {}

		DbSelectArea('SX3')

		SX3->(DbGoTop())
		SX3->(dbSetOrder(1))
		SX3->(DbSeek('SC6'))

		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == 'SC6'
			cValid := UPPER(SX3->X3_VALID) + UPPER(SX3->X3_VLDUSER)

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				AAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni		:= AT('MAFISREF("',cValid) + 10
				cReferencia	:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				AAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			SX3->(DbSkip())
		EndDo

		ASort(aFisGet,,,{|x,y| x[3]<y[3]})
	EndIf

	If aFisGetSC5 == Nil
		aFisGetSC5	:= {}

		DbSelectArea('SX3')
		SX3->(DbGoTop())
		SX3->(dbSetOrder(1))
		SX3->(DbSeek('SC5'))

		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == 'SC5'
			cValid := UPPER(SX3->X3_VALID) + UPPER(SX3->X3_VLDUSER)

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni			:= AT('MAFISREF("',cValid) + 10
				cReferencia		:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			SX3->(DbSkip())
		EndDo

		ASort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
	EndIf

	MaFisEnd()
	RestArea(_aAreaSX3)
Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado	    � Data � 07/07/17 ���
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
User Function M6R1VPED(cNumPed)

Local nAcreFin	:= 0
Local nVlTotPed	:= 0
Local cAliasSum := GetNextAlias()

BeginSql Alias cAliasSum

	SELECT 
		SUM(C6_XVLTBRU) AS TOTALPED 
	FROM 
		%Table:SC6% SC6
	WHERE 
		SC6.C6_NUM = %Exp:cNumPed% AND
		SC6.%NotDel%
EndSql

nVlTotPed := (cAliasSum)->TOTALPED

(cAliasSum)->(dbCloseArea())
// +---------------------------------------------------------------------+
// | Verifica se o pedido possui percentual de acr�scimo financeiro      |
// | Se possuir percentual de acr�scimo financeiro, calcula o percentual |
// | em rela��o ao valor total encontrado nos itens do pedido e soma.    |
// +---------------------------------------------------------------------+
If !Empty(SC5->C5_ACRSFIN)
	nAcreFin := (nVlTotPed * SC5->C5_ACRSFIN ) / 100 
Endif  

Return nVlTotPed + nAcreFin 
