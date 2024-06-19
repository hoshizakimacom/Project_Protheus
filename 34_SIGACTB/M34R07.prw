#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M34R07   � Autor � Cleber Maldonado      � Data � 12/10/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio Financeiro a Receber para fechamento cont�bil    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M34R07()

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
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 01/06/18 ���
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
oReport := TReport():New("M34R07","POSI��O DE TITULOS PARA FECHAMENTO","M34R07", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a posi��o dos t�tulos a receber para " + " " + "realiza��o do fechamento cont�bil.")
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
//�	       Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oReceber := TRSection():New(oReport,"TITULOS A RECEBER",{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oReceber:SetTotalInLine(.F.) 
//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oReceber,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SE1","E1_FILIAL")	,TamSx3("E1_FILIAL")[1]		,/*lPixel*/,{|| cE1Fil	})		// Filial
TRCell():New(oReceber,"PREFIXO"		,/*Tabela*/	,"Prefixo"	 		 ,PesqPict("SE1","E1_PREFIXO")	,TamSx3("E1_PREFIXO")[1]	,/*lPixel*/,{|| cE1Pref	})		// Prefixo
TRCell():New(oReceber,"NUMERO"		,/*Tabela*/	,"Num.Titulo" 		 ,PesqPict("SE1","E1_NUM")		,TamSx3("E1_NUM")[1]		,/*lPixel*/,{|| cE1Num	})		// Numero do T�tulo
TRCell():New(oReceber,"PEDIDO"		,/*Tabela*/ ,"Pedido"			 ,PesqPict("SE1","E1_PEDIDO")	,TamSx3("E1_PEDIDO")[1]		,/*lPixel*/,{|| cE1Ped	})		// Numero do Pedido
TRCell():New(oReceber,"PARCELA"		,/*Tabela*/ ,"Parcela"		 	 ,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cE1Parc })		// Parcela
TRCell():New(oReceber,"TIPO"		,/*Tabela*/ ,"Tipo"				 ,PesqPict("SE1","E1_TIPO")		,TamSx3("E1_TIPO")[1]		,/*lPixel*/,{|| cE1Tipo	})		// Tipo do T�tulo
TRCell():New(oReceber,"NATUREZA"	,/*Tabela*/ ,"Natureza"			 ,PesqPict("SE1","E1_NATUREZ")	,TamSx3("E1_NATUREZ")[1]	,/*lPixel*/,{|| cE1Natur})		// Natureza Financeira
TRCell():New(oReceber,"CLIENTE"		,/*Tabela*/ ,"Cod.Cliente"		 ,PesqPict("SA1","A1_COD")		,TamSx3("A1_COD")[1]		,/*lPixel*/,{|| cE1Clien})		// C�digo do Cliente
TRCell():New(oReceber,"LOJA"		,/*Tabela*/ ,"Loja"				 ,PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA")[1]		,/*lPixel*/,{|| cE1Loj  })		// Loja do Cliente
TRCell():New(oReceber,"CLILOJ"		,/*Tabela*/ ,"Cliente/Loja"		 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cE1CliLj})		// C�digo + Loja do Cliente
TRCell():New(oReceber,"RAZAO"		,/*Tabela*/ ,"Raz�o Social"		 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cE1Razao})		// Raz�o Social
TRCell():New(oReceber,"FANTASIA"	,/*Tabela*/ ,"Nome Cliente"		 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]		,/*lPixel*/,{|| cE1Fanta})		// Nome Fantasia
TRCell():New(oReceber,"EMISSAO"		,/*Tabela*/	,"Emiss�o"			 ,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dE1Emiss})		// Data de Emissao
TRCell():New(oReceber,"VENCTO"		,/*Tabela*/	,"Vencimento"		 ,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dE1Venc	})		// Data de Vencimento
TRCell():New(oReceber,"VENCREAL"	,/*Tabela*/	,"Vencto.Real"		 ,PesqPict("SE1","E1_VENCREA")	,TamSx3("E1_VENCREA")[1]	,/*lPixel*/,{|| dE1VReal})		// Data de Vencimento Real
TRCell():New(oReceber,"BAIXA"		,/*Tabela*/ ,"Dt.Baixa"			 ,PesqPict("SE1","E1_BAIXA")	,TamSx3("E1_BAIXA")[1]		,/*lPixel*/,{|| dE1Baixa})		// Data da Baixa do T�tulo
TRCell():New(oReceber,"TOTAL"		,/*Tabela*/	,"Vlr.Total"		 ,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nE1VlTot})		// Valor da Fatura
TRCell():New(oReceber,"SALDO"		,/*Tabela*/	,"Saldo"			 ,PesqPict("SE1","E1_SALDO")	,TamSx3("E1_SALDO")[1]		,/*lPixel*/,{|| nE1Saldo})		// Valor do Saldo
TRCell():New(oReceber,"XSALDO"		,/*Tabela*/ ,"Saldo a Comp."	 ,PesqPict("SE1","E1_XSALDO")	,TamSx3("E1_XSALDO")[1]		,/*lPixel*/,{|| nE1XSald})		// Valor do saldo a compensar (PVA)
TRCell():New(oReceber,"INSS"		,/*Tabela*/ ,"Vlr. INSS"		 ,PesqPict("SE1","E1_INSS")		,TamSx3("E1_INSS")[1]		,/*lPixel*/,{|| nE1VINSS})		// Valor do INSS
TRCell():New(oReceber,"CONTAB"		,/*Tabela*/ ,"Dt.Contabiliza��o" ,PesqPict("SE1","E1_EMIS1")	,TamSx3("E1_EMIS1")[1]		,/*lPixel*/,{|| dE1DCont})		// Data de Contabiliza��o
TRCell():New(oReceber,"HISTORICO"	,/*Tabela*/ ,"Hist�rico"		 ,PesqPict("SE1","E1_HIST")		,TamSx3("E1_HIST")[1]		,/*lPixel*/,{|| cE1Hist })		// Hist�rico

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
Static Function ReportPrint(oReport,cAliasQry,oReceber)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SE1")
dbSetOrder(1)		

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

		COLUMN E1_VENCTO AS DATE
		COLUMN E1_VENCREA AS DATE			
		COLUMN E1_EMIS1  AS DATE
		COLUMN E1_EMISSAO AS DATE

		SELECT 
			E1_FILIAL,E1_PEDIDO,E1_NUM,E1_TIPO,E1_PREFIXO,E1_EMISSAO,E1_PARCELA,E1_NATUREZ,E1_VALOR,E1_INSS,
			E1_SALDO,E1_XSALDO,E1_VEND1,E1_CLIENTE,E1_LOJA,E1_VENCTO,E1_VENCREA,E1_EMIS1,E1_BAIXA,E1_HIST
		FROM 
			%Table:SE1% SE1   
		WHERE 
			SE1.E1_FILIAL IN ( '01' , '02' ) AND
			SE1.E1_EMIS1 >= %Exp:MV_PAR01% AND
			SE1.E1_EMIS1 <= %Exp:MV_PAR02% AND
			SE1.%NotDel%
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
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
	
	//��������������������������������������������������������������Ŀ
	//� C O N T A S    A   R E C E B E R                             �
	//����������������������������������������������������������������
	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosC5	:= SC5->(MsSeek(xFilial('SC5')+(cAliasQry)->E1_PEDIDO))

	cE1Fil		:= (cAliasQry)->E1_FILIAL
	cE1Pref		:= (cAliasQry)->E1_PREFIXO
	cE1Num		:= (cAliasQry)->E1_NUM
	cE1Tipo		:= (cAliasQry)->E1_TIPO
	cE1Ped		:= (cAliasQry)->E1_PEDIDO
	dE1Emiss	:= (cAliasQry)->E1_EMISSAO
	cE1Parc		:= (cAliasQry)->E1_PARCELA
	nE1VlTot	:= (cAliasQry)->E1_VALOR
	dE1Venc		:= (cAliasQry)->E1_VENCTO			
	dE1VReal	:= (cAliasQry)->E1_VENCREA
	dE1DCont	:= (cAliasQry)->E1_EMIS1
	dE1Baixa	:= (cAliasQry)->E1_BAIXA
	cE1Pref		:= (cAliasQry)->E1_PREFIXO
	nE1VINSS	:= (cAliasQry)->E1_INSS
	nE1XSald	:= (cAliasQry)->E1_XSALDO
	cE1Hist		:= (cAliasQry)->E1_HIST
	cE1Natur	:= (cAliasQry)->E1_NATUREZ

	If !Empty((cAliasQry)->E1_BAIXA) .And. (cAliasQry)->E1_BAIXA > (cAliasQry)->E1_EMIS1 .And. (cAliasQry)->E1_SALDO == 0 
		nE1Saldo	:= (cAliasQry)->E1_VALOR
	ElseIf !Empty((cAliasQry)->E1_BAIXA) .And. (cAliasQry)->E1_SALDO <> 0 .And. (cAliasQry)->E1_SALDO <> (cAliasQry)->E1_VALOR  
		nE1Saldo	:= (cAliasQry)->E1_SALDO
	Else
		nE1Saldo	:= (cAliasQry)->E1_SALDO
	Endif

    If lPosA1
		cE1Clien	:= SA1->A1_COD
		cE1Loj		:= SA1->A1_LOJA
    	cE1Razao	:= SA1->A1_NOME
   		cE1Fanta	:= SA1->A1_NREDUZ
   		cE1CliLj	:= cE1Clien + cE1Loj  
    Else
		cE1Clien	:= " "
		cE1Loj		:= " "
    	cE1Razao	:= " "
   		cE1Fanta	:= " "
   		cE1CliLj	:= " "  
    Endif
    
	If lPosC5
		cCondPgt	:= SC5->C5_CONDPAG
		cDescPgt	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
	Else
		cCondPgt	:= " "
		cDescPgt	:= " "
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