#Include "PROTHEUS.Ch"
                  
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06R09   � Autor � Montes - MooveGest�o  � Data � 22/11/24 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Provis�o do Contas a Receber / Pagar          ���
���          �                                                   		  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06R09()

Local oReport

//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Montes - MooveGest�o  � Data � 22/11/24 ���
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
Local oRelProd
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
oReport := TReport():New("M06R09","Provis�o Contas a Receber/Pagar","M06R09", {|oReport| ReportPrint(oReport,cAliasQry,oRelProd)},"Este relatorio emite os provis�o do contas a receber/pagar com base no pedidos de vendas e compras colocados.")
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
oRelProd := TRSection():New(oReport,"Provis�o C.Receber/Pagar",/*{"SC5","SC6"}*/,/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		
oRelProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oRelProd,"CARTEIRA"	,/*Tabela*/ ,"Carteira"		    	  ,"@!"                    		,1	                    	,/*lPixel*/,{|| cCarteira})		// Numero do Pedido
TRCell():New(oRelProd,"EMISSAO"		,/*Tabela*/ ,"Emiss�o"			      ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao })		// Emissao do Pedido
TRCell():New(oRelProd,"ORCTO"		,/*Tabela*/ ,"Num.SC/Or�to"			  ,PesqPict("SC6","C6_NUMORC")	,TamSx3("C6_NUMORC")[1]	    ,/*lPixel*/,{|| cNumOrc  })		// Num.SC / Or�amento
TRCell():New(oRelProd,"PEDIDO"		,/*Tabela*/ ,"Num. Pedido"			  ,PesqPict("SC5","C5_NUM")		,TamSx3("C5_NUM")[1]		,/*lPixel*/,{|| cNumPed	 })		// Numero do Pedido
TRCell():New(oRelProd,"CODCLIFOR"	,/*Tabela*/ ,"Cod.Cliente/Fornecedor" ,PesqPict("SA1","A1_COD")		,TamSx3("A1_COD")[1]		,/*lPixel*/,{|| cCodCli	 })		// C�digo do Cliente
TRCell():New(oRelProd,"LOJCLIFOR"	,/*Tabela*/ ,"Loja Cliente/Fornecedor",PesqPict("SA1","A1_LOJA")	,TamSx3("A1_LOJA")[1]		,/*lPixel*/,{|| cLojCli	 })		// Loja do Cliente
TRCell():New(oRelProd,"RAZAOS"	    ,/*Tabela*/ ,"Razao Social Cli/Forn." ,PesqPict("SA1","A1_NOME")	,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cRazao	 })		// Raz�o Social do Fornecedor
TRCell():New(oRelProd,"UF"	        ,/*Tabela*/ ,"Estado"                 ,PesqPict("SA1","A1_EST")	    ,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cEstado	 })		// Estado do Fornecedor
TRCell():New(oRelProd,"CODPGTO"	    ,/*Tabela*/	,"Cond.Pagto"	      	  ,PesqPict("SE4","E4_CODIGO")	,TamSx3("E4_CODIGO")[1]		,/*lPixel*/,{|| cCodPgto })		// Codigo da condi��o de pagamento
TRCell():New(oRelProd,"DESCPGTO"	,/*Tabela*/	,"Descri��o Cond.Pgto"	  ,PesqPict("SE4","E4_DESCRI")	,TamSx3("E4_DESCRI")[1]		,/*lPixel*/,{|| cDescPgto})		// Descri��o da condi��o de pagamento
TRCell():New(oRelProd,"XDESPAG"	    ,/*Tabela*/	,"Desc. Com Pag"	      ,PesqPict("SE4","E4_DESCRI")	,TamSx3("E4_DESCRI")[1]		,/*lPixel*/,{|| cXDESPAG })		// Descri��o Comercial Pagamento
TRCell():New(oRelProd,"CTACONTABIL"	,/*Tabela*/	,"Cta Contabil"	          ,PesqPict("CT1","CT1_CONTA")	,TamSx3("CT1_CONTA")[1]		,/*lPixel*/,{|| cContaCTB})		// Codigo Conta Contabil
TRCell():New(oRelProd,"DESCCC"	    ,/*Tabela*/	,"Descri��o CC"	          ,PesqPict("CT1","CT1_DESC01")	,TamSx3("CT1_DESC01")[1]	,/*lPixel*/,{|| cDescCC  })		// Descri��o CC
TRCell():New(oRelProd,"TOTAL"		,/*Tabela*/	,"Total do Pedido"	 	  ,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT")[1]	,/*lPixel*/,{|| nVlrPedt })		// Valor total do pedido
TRCell():New(oRelProd,"SALDO"		,/*Tabela*/	,"Saldo do Pedido"	 	  ,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT")[1]	,/*lPixel*/,{|| nSldPedt })		// Saldo do pedido
TRCell():New(oRelProd,"ENTREGA"		,/*Tabela*/ ,"Data de Entrega"		  ,PesqPict("SC5","C5_FECENT")	,TamSx3("C5_FECENT")[1]		,/*lPixel*/,{|| dDataEnt })		// Data de embarque
TRCell():New(oRelProd,"STATUS"		,/*Tabela*/ ,"Status"			 	  ,PesqPict("SC5","C5_XSTSFIN")	,TamSx3("C5_XSTSFIN")[1]	,/*lPixel*/,{|| cStatus  })		// Status de Pagamento
TRCell():New(oRelProd,"PARCELA"		,/*Tabela*/ ,"Parcela"			 	  ,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cParcela })		// Parcela
TRCell():New(oRelProd,"VENCTO"		,/*Tabela*/ ,"Vencimento"			  ,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]	    ,/*lPixel*/,{|| dVencto  })		// Vencimento da Parcela
TRCell():New(oRelProd,"VALPARC"		,/*Tabela*/ ,"Vlr.Parcela"			  ,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]	    ,/*lPixel*/,{|| nValParc })		// Valor da Parcela
TRCell():New(oRelProd,"CODVEND"	    ,/*Tabela*/ ,"Cod.Representante"      ,PesqPict("SA3","A3_COD")	    ,TamSx3("A3_COD")[1]		,/*lPixel*/,{|| cCodVend })		// Codigo do Vendedor
TRCell():New(oRelProd,"NOMEVEND"    ,/*Tabela*/ ,"Nome Representante"     ,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomVend })		// Nome do Vendedor
TRCell():New(oRelProd,"GERENCIA"    ,/*Tabela*/ ,"Gerencia"               ,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cNomGer  })		// Nome do Gerente
TRCell():New(oRelProd,"PCONDPAG"	,/*Tabela*/ ,"% Cond.Pag."			  ,PesqPict("SC5","C5_XPCONPG")	,TamSx3("C5_XPCONPG")[1]	,/*lPixel*/,{|| nPerConPg})		// % de CondPag at� a entrega

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Montes - MooveGest�o  � Data � 22/11/24 ���
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
Static Function ReportPrint(oReport,cAliasQry,oRelProd)

Local _nTotal	:= 0
Local _nFrete	:= 0
Local _nSeguro	:= 0
Local _nDesp	:= 0
Local _nFreteA	:= 0
Local _nAcrFin	:= 0
Local nX
Local cVarMV_1DUP:=GetMv("MV_1DUP")

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC5")		// Pedido de Venda
dbSetOrder(1)			// Filial+Numero

dbSelectArea("SC7")		// Pedido de Compra
dbSetOrder(1)			// Filial+Numero

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		SELECT DISTINCT
			'R' CARTEIRA, C5_FILIAL FILIAL,C5_NUM PEDIDO,C5_CLIENTE CLIFOR,C5_LOJACLI LOJA,C5_FECENT ENTREGA,C5_EMISSAO EMISSAO,
			C5_CONDPAG CONDPAG,C5_XSTSFIN /*C5_LIBEROK*/ LIBEROK,  C5_ACRSFIN ACRSFIN, C5_VEND1 VEND1, C5_XPCONPG XPCONPG, C5_XDESPAG XDESPAG
 		FROM 
			%Table:SC5% SC5
		WHERE 
			SC5.C5_EMISSAO >= %Exp:MV_PAR01% AND
			SC5.C5_EMISSAO <= %Exp:MV_PAR02% AND
			SC5.C5_NUM >= %Exp:MV_PAR03% AND
			SC5.C5_NUM <= %Exp:MV_PAR04% AND
			SC5.C5_FECENT >= %Exp:MV_PAR09% AND
			SC5.C5_FECENT <= %Exp:MV_PAR10% AND
			SC5.C5_BLQ = ' '       AND 
			SC5.C5_TIPO = 'N'      AND 
			SC5.C5_NOTA = ' '      AND
			SC5.C5_LIBEROK <> 'E' AND  
			SC5.C5_MSBLQL <> "1"   AND
			SC5.D_E_L_E_T_ = ' ' AND
			%Exp:MV_PAR07%  IN (1,3) AND 
			( (SC5.C5_XSTSFIN = "1" AND %Exp:MV_PAR08% = 1) OR (SC5.C5_XSTSFIN = "2" AND %Exp:MV_PAR08% = 2) OR %Exp:MV_PAR08% = 3 )

		UNION ALL 
		
		SELECT DISTINCT 
			'P' CARTEIRA, C7_FILIAL FILIAL,C7_NUM PEDIDO,C7_FORNECE CLIFOR,C7_LOJA LOJA,C7_DATPRF ENTREGA,C7_EMISSAO EMISSAO,
			C7_COND CONDPAG,C7_CONAPRO LIBEROK,  0 ACRSFIN, '' VEND1, 0 XPCONPG, '' XDESPAG
		FROM 
			%Table:SC7% SC7
		WHERE 
			SC7.C7_EMISSAO >= %Exp:MV_PAR01% AND
			SC7.C7_EMISSAO <= %Exp:MV_PAR02% AND
			SC7.C7_NUM >= %Exp:MV_PAR05% AND
			SC7.C7_NUM <= %Exp:MV_PAR06% AND
			SC7.C7_DATPRF >= %Exp:MV_PAR09% AND
			SC7.C7_DATPRF <= %Exp:MV_PAR10% AND
			SC7.C7_RESIDUO = ' ' AND
			SC7.C7_QUJE < SC7.C7_QUANT AND
			SC7.D_E_L_E_T_ = ' ' AND
			%Exp:MV_PAR07%  IN (2,3) AND
			( (SC7.C7_CONAPRO = "L" AND %Exp:MV_PAR08% = 1) OR (SC7.C7_CONAPRO = "B" AND %Exp:MV_PAR08% = 2) OR %Exp:MV_PAR08% = 3 )

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
cMvDup := GetMv("MV_1DUP")
While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cCarteira   := (cAliasQry)->CARTEIRA
	_nAcrFin	:= (cAliasQry)->ACRSFIN /*SC5->C5_ACRSFIN*/
	cNumPed 	:= (cAliasQry)->PEDIDO
	dEmissao    := STOD((cAliasQry)->EMISSAO)
	cCodCli		:= (cAliasQry)->CLIFOR
	cLojCli		:= (cAliasQry)->LOJA
	dDataEnt	:= STOD((cAliasQry)->ENTREGA)
	cCodPgto    := (cAliasQry)->CONDPAG
	cDescPgto	:= Posicione('SE4',1,xFilial('SE4')+cCodPgto,'E4_DESCRI')
	cCodVend	:= Posicione('SA3',1,xFilial('SA3')+(cAliasQry)->VEND1,'A3_COD')
	cNomVend 	:= Posicione('SA3',1,xFilial('SA3')+(cAliasQry)->VEND1,'A3_NOME')
	cCodGer     := Posicione('SA3',1,xFilial('SA3')+(cAliasQry)->VEND1,'A3_GEREN')
	cNomGer     := Posicione('SA3',1,xFilial('SA3')+cCodGer,'A3_NOME')
	nPerConPg	:= (cAliasQry)->XPCONPG
	cXDESPAG    := (cAliasQry)->XDESPAG
	cNumOrc     := ""
	cContaCTB   := ""
	cDescCC     := ""
    nVlrPedt    := 0
	nSldPedt    := 0
	nPercSald   := 0

	If (cAliasQry)->LIBEROK $ '2/L' ////C5_XSTSFIN
		cStatus := "LIBERADO"
	Else
		cStatus := "BLOQUEADO"
	EndIf

	If (cAliasQry)->CARTEIRA = "R"
		SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->CLIFOR+(cAliasQry)->LOJA))
		cRazao		:= SA1->A1_NOME   
		cEstado		:= SA1->A1_EST
	Else
		SA2->(MsSeek(xFilial('SA2')+(cAliasQry)->CLIFOR+(cAliasQry)->LOJA))
		cRazao		:= SA2->A2_NOME
		cEstado		:= SA2->A2_EST
	Endif
	
	If (cAliasQry)->CARTEIRA == "R" .And. SC5->(MsSeek(xFilial('SC5')+(cAliasQry)->PEDIDO))
		// Calcula o valor total do pedido considerando os impostos
		M6R9TOT("R",SC5->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@cCodPgto,@cNumOrc,@cContaCTB,@cDescCC,@nPercSald,dDataEnt)
		
		nVlrPedt	:= ( _nTotal + _nFrete + _nSeguro + _nDesp + _nFreteA + _nAcrFin )
		
		nSldPedt    := (nVlrPedt) * nPercSald

		// Calcula o valor pago do t�tulo
		nVlrPago	:= M6R9PAG((cAliasQry)->PEDIDO)

	ElseIf (cAliasQry)->CARTEIRA == "P" .And. SC7->(MsSeek(xFilial('SC7')+(cAliasQry)->PEDIDO))
		// Calcula o valor total do pedido considerando os impostos
		M6R9TOT("P",SC7->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@cCodPgto,@cNumOrc,@cContaCTB,@cDescCC,@nPercSald,dDataEnt)
		
		nVlrPedt	:= ( _nTotal + _nFrete + _nSeguro + _nDesp + _nFreteA + _nAcrFin )

		nSldPedt    := (nVlrPedt) * nPercSald

		nVlrPago	:= 0

	Else

		nVlrPedt	:= 0
		nSldPedt    := 0
		nVlrPago	:= 0
	EndIf

	//Deduz valor pago para o pedido via Adiantamento PVA
	nVlrPedt := nVlrPedt 
	nSldPedt := nSldPedt - nVlrPago

	dDataIni := IIF(dDataEnt < dDataBase,dDataBase,dDataEnt)
    aVenc    := Condicao ( nSldPedt /*nVlrPedt*/, cCodPgto, 0, dDataIni )
	cParcela := cMvDup
    
	For nX := 1 to Len(aVenc)

		//cParcela  := STRZERO(nX,TAMSX3("E1_PARCELA")[1])
		nValParc  := aVenc[nX][2] //xMoeda(aVenc[nX][2],SC5->C5_MOEDA,1)
		dVencto   := DataValida(aVenc[nX][1],.T.)

		oReport:IncMeter()
		oReport:Section(1):PrintLine()

		cParcela  := Soma1(cParcela,Len(SE1->E1_PARCELA))

    Next

	(cAliasQry)->(dbSkip())
EndDo
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M6R9TOT   � Autor � Montes - MooveGest�o � Data � 22/11/24 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina respons�vel pelo c�lculo do total do pedido		  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � M06R09 - Relat�rio CondPag                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M6R9TOT(cCarteira,_nRecnoSC5,_nTotal,_nFrete,_nSeguro,_nDesp,_nFreteA,_nAcrFin,_cCondPag,cNumOrc,cContaCTB,cDescCC,nPercSald,dDataEnt)
	Local _aAreaSC5		:= SC5->(GetArea())
	Local _aAreaSC7		:= SC7->(GetArea())
	Local _aArea		:= GetArea()

	Local aRelImp    	:= IIF(cCarteira="R",MaFisRelImp("MT100",{"SF2","SD2"}),MaFisRelImp("MT100",{"SF1","SD1"}))
	Local aFisGet    	:= Nil
	Local aFisGetCAB 	:= Nil
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
	Local nSaldoMerc    := 0
	Local nTotalMerc    := 0
	Local nTotalPedido  := 0
	Local nProp         := 0

	MA6R9FisIni(cCarteira,@aFisGet,@aFisGetCAB)

	If cCarteira = "R"
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

		For nY := 1 to Len(aFisGetCAB)
			If !Empty(&(aFisGetCAB[ny][2]))
				If aFisGetCAB[ny][1] == "NF_SUFRAMA"
					MaFisAlt(aFisGetCAB[ny][1],Iif(&(aFisGetCAB[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
				Else
					MaFisAlt(aFisGetCAB[ny][1],&(aFisGetCAB[ny][2]),Len(aItemPed),.T.)
				Endif
			EndIf
		Next nY


		SC6->(DbSetOrder(1))

		If SC6->(DbSeek( SC5->C5_FILIAL + SC5->C5_NUM ))

			cNumOrc   := SC6->C6_NUMORC
			cContaCTB := SC6->C6_CONTA
			cDescCC   := POSICIONE("CT1",1,xFILIAL("CT1")+SC6->C6_CONTA,"CT1_DESC01")

			//+------------------------------------
			// Percorre itens do pedido
			//+------------------------------------
			While SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM ) == SC5->C5_FILIAL + SC5->C5_NUM
				cNfOri     := Nil
				cSeriOri   := Nil
				nRecnoSD1  := Nil
				nDesconto  := 0

				nTotalPedido += SC7->C7_QUANT*SC7->C7_PRECO

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
				nValMerc   := SC6->C6_VALOR
				nPrcLista  := SC6->C6_PRUNIT

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

				nTotalMerc += SC6->C6_QTDVEN*SC6->C6_PRCVEN
	 			nSaldoMerc += (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN

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

	Else

		cFilSC7     := SC7->C7_FILIAL
		cPedido     := SC7->C7_NUM
		cCliEnt 	:= SC7->C7_FORNECE
		_nAcrFin	:= Posicione('SE4',1,xFilial('SE4') + _cCondPag ,'E4_ACRSFIN')

		MaFisIni(	cCliEnt,;								// 1-Codigo Cliente/Fornecedor
					SC7->C7_LOJA,;			    			// 2-Loja do Cliente/Fornecedor
					"F",;		                          	// 3-C:Cliente , F:Fornecedor
					"N",;        							// 4-Tipo da NF
					"R",;	            					// 5-Tipo do Cliente/Fornecedor
					aRelImp,;								// 6-Relacao de Impostos que suportados no arquivo
					,;						   				// 7-Tipo de complemento
					,;										// 8-Permite Incluir Impostos no Rodape .T./.F.
					"SB1",;									// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA100")								// 10-Nome da rotina que esta utilizando a funcao

		nFrete		:= SC7->C7_FRETE
		nSeguro		:= SC7->C7_SEGURO
		nFretAut	:= 0
		nDespesa	:= SC7->C7_DESPESA
		nDescCab	:= SC7->C7_DESC1
		nPDesCab	:= 0
		aItemPed	:= {}
		nPesBru		:= 0

		DbSelectArea('SC7')

		For nY := 1 to Len(aFisGetCAB)
			If FIELDPOS(aFisGetCAB[ny][2]) > 0 .And. !Empty(&(aFisGetCAB[ny][2]))
				If aFisGetCAB[ny][1] == "NF_SUFRAMA"
					MaFisAlt(aFisGetCAB[ny][1],Iif(&(aFisGetCAB[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
				Else
					MaFisAlt(aFisGetCAB[ny][1],&(aFisGetCAB[ny][2]),Len(aItemPed),.T.)
				Endif
			EndIf
		Next nY

		cNumOrc   := SC7->C7_NUMSC
		cContaCTB := SC7->C7_CONTA
		cDescCC   := POSICIONE("CT1",1,xFILIAL("CT1")+SC7->C7_CONTA,"CT1_DESC01")

		//+------------------------------------
		// Percorre itens do pedido
		//+------------------------------------
		While SC7->(!EOF()) .And. SC7->(C7_FILIAL + C7_NUM ) == cFilSC7 + cPedido

			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0

			nTotalPedido += SC7->C7_QUANT*SC7->C7_PRECO

			DbSelectArea('SC7')
		
			IF SC7->C7_DATPRF == dDataEnt //Tratamento por data de entrega por item #MONTES20250331
					//+------------------------------------
					//Calcula o preco de lista
					//+------------------------------------
					nValMerc  := SC7->C7_TOTAL
					nPrcLista := SC7->C7_PRECO

					If ( nPrcLista == 0 )
						nPrcLista := NoRound(nValMerc/SC7->C7_QUANT,TamSX3("C7_PRECO")[2])
					EndIf

					nAcresFin := A410Arred(SC7->C7_PRECO*_nAcrFin/100,"D2_PRCVEN")
					nValMerc  += A410Arred(SC7->C7_QUANT*nAcresFin,"D2_TOTAL")
					nDesconto := a410Arred(nPrcLista*SC7->C7_QUANT,"D2_DESCON")-nValMerc
					nDesconto := Max(0,nDesconto)
					nPrcLista += nAcresFin
					nValMerc  += nDesconto

					nTotalMerc += SC7->C7_QUANT*SC7->C7_PRECO
					nSaldoMerc += (SC7->C7_QUANT-SC7->C7_QUJE)*SC7->C7_PRECO

					MaFisAdd(	SC7->C7_PRODUTO				,;	// 1-Codigo do Produto ( Obrigatorio )
								SC7->C7_TES					,;	// 2-Codigo do TES ( Opcional )
								SC7->C7_QUANT   			,;	// 3-Quantidade ( Obrigatorio )
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

					aadd(aItemPed,	{	SC7->C7_ITEM					,;
											SC7->C7_PRODUTO				,;
											SC7->C7_DESCRI				,;
											SC7->C7_TES					,;
											''/*SC7->C7_CF*/			,;
											SC7->C7_UM					,;
											SC7->C7_QUANT				,;
											SC7->C7_PRECO				,;
											''/*SC7->C7_NOTA*/			,;
											''/*SC7->C7_SERIE*/			,;
											SC7->C7_FORNECE				,;
											SC7->C7_LOJA				,;
											SC7->C7_TOTAL				,;
											SC7->C7_DATPRF				,;
											SC7->C7_DESC1				,;
											SC7->C7_LOCAL				,;
											SC7->C7_QUANT				,;
											SC7->C7_QUANT				,;
											SC7->C7_QUJE				,;
										})

					//+------------------------------------
					//Forca os valores de impostos que foram
					//	informados no SC7.
					//+------------------------------------
					DbSelectArea('SC7')
					For nY := 1 to Len(aFisGet)
						If FIELDPOS(aFisGet[ny][2]) > 0 .And. !Empty(&(aFisGet[ny][2]))
							MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
						EndIf
					Next nY

					//+------------------------------------
					//Altera peso para calcular frete
					//+------------------------------------
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1")+SC7->C7_PRODUTO))
					MaFisAlt("IT_PESO",SC7->C7_QUANT*SB1->B1_PESO,Len(aItemPed))
					MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))

			EndIf	

			SC7->(DbSkip())
		EndDo

	EndIf

	nProp := (nTotalMerc/nTotalPedido)

	MaFisAlt("NF_FRETE"   ,nFrete*nProp)
	MaFisAlt("NF_SEGURO"  ,nSeguro*nProp)
	MaFisAlt("NF_AUTONOMO",nFretAut*nProp)
	MaFisAlt("NF_DESPESA" ,nDespesa*nProp)

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
	RestArea(_aAreaSC7)

	/*
	
	Calcula a propor��o do saldo do pedido em aberto

	*/
	nPercSald := ( nSaldoMerc / nTotalMerc )
	If nPercSald > 1
		nPercSald := 1
	EndIf
	
Return

//+----------------------------------------------------------------------------------------
//|	Rotina respons�vel pela inicializa��o das referencias utilizadas no calculo do total
//+----------------------------------------------------------------------------------------
Static Function MA6R9FisIni(cCarteira,aFisGet,aFisGetCAB)
	Local _aAreaSX3		:= SX3->(GetArea())
	Local cValid      	:= ''
	Local cReferencia 	:= ''
	Local nPosIni     	:= 0
	Local nLen        	:= 0
	Local cAliasCAB     := IIF(cCarteira=="R","SC5","SC7")
	Local cAliasITEM    := IIF(cCarteira=="R","SC6","SC7")

	If aFisGet == Nil
		aFisGet	:= {}

//		DbSelectArea('SX3')
//
//		SX3->(DbGoTop())
//		SX3->(dbSetOrder(1))
//		SX3->(DbSeek(cAliasItem))

aCmp:= FWSX3Util():GetAllFields( cAliasItem , .T. )

	For nCont := 1 to Len(aCmp)




//		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == cAliasItem
			cValid := UPPER(getsx3cache(aCmp[nCont],"X3_VALID") + UPPER(getsx3cache(aCmp[nCont],"X3_VLDUSER")))

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				AAdd(aFisGet,{cReferencia,getsx3cache(aCmp[nCont],"X3_CAMPO"),MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni		:= AT('MAFISREF("',cValid) + 10
				cReferencia	:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				AAdd(aFisGet,{cReferencia,getsx3cache(aCmp[nCont],"X3_CAMPO"),MaFisOrdem(cReferencia)})
			EndIf

//			SX3->(DbSkip())
//		EndDo
next

		ASort(aFisGet,,,{|x,y| x[3]<y[3]})
	EndIf

	If aFisGetCAB == Nil
		aFisGetCAB	:= {}

//		DbSelectArea('SX3')
//		SX3->(DbGoTop())
//		SX3->(dbSetOrder(1))
//		SX3->(DbSeek(cAliasCAB))
		
		aCmp:= FWSX3Util():GetAllFields( cAliasCAB , .T. )
		//While !Eof() .And. SX3->X3_ARQUIVO=="CNF"
	For nCont := 1 to Len(aCmp)
		

//		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == cAliasCAB
			cValid := UPPER(getsx3cache(aCmp[nCont],"X3_VALID")) + UPPER(getsx3cache(aCmp[nCont],"X3_VLDUSER"))

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				aAdd(aFisGetCAB,{cReferencia,getsx3cache(cAliasItem,"X3_CAMPO"),MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni			:= AT('MAFISREF("',cValid) + 10
				cReferencia		:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				aAdd(aFisGetCAB,{cReferencia,getsx3cache(aCmp[nCont],"X3_CAMPO"),MaFisOrdem(cReferencia)})
			EndIf

//			SX3->(DbSkip())
//		EndDo
next

		ASort(aFisGetCAB,,,{|x,y| x[3]<y[3]})
	EndIf

	MaFisEnd()
	RestArea(_aAreaSX3)
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M6R9PAG   � Autor � Montes - MooveGest�o � Data � 22/11/24 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor pago de um pedido de venda				  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � M06R09 - Relat�rio CondPag                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M6R9PAG(_nNumPed)

Local nValPago	 := 0 
Local cAliasQry2 := GetNextAlias()

BeginSql Alias cAliasQry2

	SELECT 
		SUM(E1_VALOR) AS VALOR,
		SUM(E1_SALDO) AS SALDO		
	FROM 
		%Table:SE1% SE1
	WHERE
		SE1.E1_PEDIDO = %Exp:_nNumPed% AND
		SE1.E1_PREFIXO = 'PVA' AND
		SE1.E1_TIPO <> 'CRA' AND
		SE1.%NotDel%
EndSql 

While !(cAliasQry2)->(Eof())
	
	nValPago	+= (cAliasQry2)->VALOR - (cAliasQry2)->SALDO
	
	(cAliasQry2)->(dbSkip())	
End 

(cAliasQry2)->(DbCloseArea())

Return nValPago
