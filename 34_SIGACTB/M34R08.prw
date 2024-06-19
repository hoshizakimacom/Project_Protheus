#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M34R07   � Autor � Cleber Maldonado      � Data � 12/10/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de fechamento cont�bil                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M34R08()

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
oReport := TReport():New("M34R08","POSI��O DE TITULOS A PAGAR","M34R08", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a posi��o dos t�tulos a pagar para " + " " + "realiza��o do fechamento cont�bil.")
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
oVenProd := TRSection():New(oReport,"POSI��O DE TITULOS A PAGAR",{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oVenProd:SetTotalInLine(.F.) 
//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"	 		 ,PesqPict("SE2","E2_FILIAL")	,TamSx3("E2_FILIAL")[1]		,/*lPixel*/,{|| cNumFil	})		// Filial
TRCell():New(oVenProd,"PREFIXO"		,/*Tabela*/	,"Prefixo"	 		 ,PesqPict("SE2","E2_PREFIXO")	,TamSx3("E2_PREFIXO")[1]	,/*lPixel*/,{|| cPrefix	})		// Prefixo
TRCell():New(oVenProd,"NUMERO"		,/*Tabela*/	,"Num.Titulo" 		 ,PesqPict("SE2","E2_NUM")		,TamSx3("E2_NUM")[1]		,/*lPixel*/,{|| cNum	})		// Numero do T�tulo
TRCell():New(oVenProd,"PARCELA"		,/*Tabela*/ ,"Parcela"		 	 ,PesqPict("SE2","E2_PARCELA")	,TamSx3("E2_PARCELA")[1]	,/*lPixel*/,{|| cParcela})		// Parcela
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"				 ,PesqPict("SE2","E2_TIPO")		,TamSx3("E2_TIPO")[1]		,/*lPixel*/,{|| cTipo	})		// Tipo do T�tulo	
TRCell():New(oVenProd,"NATUREZA"	,/*Tabela*/ ,"Natureza"			 ,PesqPict("SE2","E2_NATUREZ")	,TamSx3("E2_NATUREZ")[1]	,/*lPixel*/,{|| cNaturez})		// Natureza Financeira	
TRCell():New(oVenProd,"FORNECEDOR"	,/*Tabela*/ ,"Cod.Fornecedor"	 ,PesqPict("SA2","A2_COD")		,TamSx3("A2_COD")[1]		,/*lPixel*/,{|| cCodCli })		// C�digo do Cliente
TRCell():New(oVenProd,"LOJA"		,/*Tabela*/ ,"Loja"				 ,PesqPict("SA2","A2_LOJA")		,TamSx3("A2_LOJA")[1]		,/*lPixel*/,{|| cCodLoj })		// Loja do Cliente
TRCell():New(oVenProd,"FORLOJ"		,/*Tabela*/ ,"Fornecedor/Loja"	 ,PesqPict("SA2","A2_BAIRRO")	,TamSx3("A2_BAIRRO")[1]		,/*lPixel*/,{|| cCliLoj })		// C�digo + Loja do Cliente
TRCell():New(oVenProd,"RAZAO"		,/*Tabela*/ ,"Raz�o Social"		 ,PesqPict("SA2","A2_NOME")		,TamSx3("A2_NOME")[1]		,/*lPixel*/,{|| cRazao	})		// Raz�o Social
TRCell():New(oVenProd,"FANTASIA"	,/*Tabela*/ ,"Nome Fornecedor"	 ,PesqPict("SA2","A2_NREDUZ")	,TamSx3("A2_NREDUZ")[1]		,/*lPixel*/,{|| cNomFan })		// Nome Fantasia
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/	,"Emiss�o"			 ,PesqPict("SE2","E2_EMISSAO")	,TamSx3("E2_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmiss})		// Data de Emissao
TRCell():New(oVenProd,"VENCTO"		,/*Tabela*/	,"Vencimento"		 ,PesqPict("SE2","E2_VENCTO")	,TamSx3("E2_VENCTO")[1]		,/*lPixel*/,{|| dDtVenc	})		// Data de Vencimento
TRCell():New(oVenProd,"VENCREAL"	,/*Tabela*/	,"Vencto.Real"		 ,PesqPict("SE2","E2_VENCREA")	,TamSx3("E2_VENCREA")[1]	,/*lPixel*/,{|| dVenReal})		// Data de Vencimento Real
TRCell():New(oVenProd,"TOTAL"		,/*Tabela*/	,"Vlr.Total"		 ,PesqPict("SE2","E2_VALOR")	,TamSx3("E2_VALOR")[1]		,/*lPixel*/,{|| nFatura	})		// Valor da Fatura
TRCell():New(oVenProd,"SALDO"		,/*Tabela*/	,"Saldo"			 ,PesqPict("SE2","E2_SALDO")	,TamSx3("E2_SALDO")[1]		,/*lPixel*/,{|| nSaldo	})		// Valor do Saldo
TRCell():New(oVenProd,"COFINS"		,/*Tabela*/ ,"Vlr.COFINS"		 ,PesqPict("SE2","E2_COFINS")	,TamSx3("E2_COFINS")[1]		,/*lPixel*/,{|| nCofins })		// Valor do COFINS
TRCell():New(oVenProd,"PIS"			,/*Tabela*/ ,"Vlr.PIS/PASEP"	 ,PesqPict("SE2","E2_PIS")		,TamSx3("E2_PIS")[1]		,/*lPixel*/,{|| nPIS	})		// Valor do PIS
TRCell():New(oVenProd,"CSLL"		,/*Tabela*/ ,"Vlr.CSLL"			 ,PesqPict("SE2","E2_CSLL")		,TamSx3("E2_CSLL")[1]		,/*lPixel*/,{|| nCSLL	})		// Valor do CSLL
TRCell():New(oVenProd,"DECRES"		,/*Tabela*/ ,"Vlr.Decrescimo"	 ,PesqPict("SE2","E2_DECRESC")	,TamSx3("E2_DECRESC")[1]	,/*lPixel*/,{|| nDecres })		// Valor do Decr�scimo	
TRCell():New(oVenProd,"ISS"			,/*Tabela*/ ,"Vlr. ISS"		 	 ,PesqPict("SE2","E2_ISS")		,TamSx3("E2_ISS")[1]		,/*lPixel*/,{|| nVlrISS })		// Valor do ISS
TRCell():New(oVenProd,"IRRF"		,/*Tabela*/ ,"Vlr. IRRF"		 ,PesqPict("SE2","E2_IRRF")		,TamSx3("E2_IRRF")[1]		,/*lPixel*/,{|| nVlrIRRF})		// Valor do IRRF
TRCell():New(oVenProd,"BAIXA"		,/*Tabela*/ ,"Dt.Baixa"			 ,PesqPict("SE2","E2_BAIXA")	,TamSx3("E2_BAIXA")[1]		,/*lPixel*/,{|| dDtBaixa})		// Data da Baixa do T�tulo
TRCell():New(oVenProd,"CONTAB"		,/*Tabela*/ ,"Dt.Contabiliza��o" ,PesqPict("SE2","E2_EMIS1")	,TamSx3("E2_EMIS1")[1]		,/*lPixel*/,{|| dDtCont })		// Data de Contabiliza��o	
TRCell():New(oVenProd,"HISTORICO"	,/*Tabela*/ ,"Hist�rico"		 ,PesqPict("SE2","E2_HIST")		,TamSx3("E2_HIST")[1]		,/*lPixel*/,{|| cHistor })		// Hist�rico

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
dbSelectArea("SE1")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
		COLUMN E2_VENCTO AS DATE
		COLUMN E2_VENCREA AS DATE			
		COLUMN E2_EMIS1  AS DATE
		COLUMN E2_EMISSAO AS DATE
		COLUMN E2_BAIXA AS DATE
		
		SELECT 
			E2_FILIAL,E2_NUM,E2_TIPO,E2_PREFIXO,E2_EMISSAO,E2_PARCELA,E2_NATUREZ,E2_VALOR,E2_PIS,E2_IRRF,E2_CSLL,
			E2_COFINS,E2_ISS,E2_SALDO,E2_FORNECE,E2_LOJA,E2_VENCTO,E2_VENCREA,E2_EMIS1,E2_BAIXA,E2_DECRESC,E2_HIST  
		FROM 
			%Table:SE2% SE2
		WHERE 
			SE2.E2_FILIAL IN ('01' , '02' ) AND
			SE2.E2_EMIS1 >= %Exp:MV_PAR01% AND
			SE2.E2_EMIS1 <= %Exp:MV_PAR02% AND
			SE2.%NotDel%
		ORDER BY SE2.E2_BAIXA
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
dbSelectArea("SE2")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA2 	:= SA2->(MsSeek(xFilial('SA2')+(cAliasQry)->E2_FORNECE+(cAliasQry)->E2_LOJA))

	cNumFil		:= (cAliasQry)->E2_FILIAL
	cNum		:= (cAliasQry)->E2_NUM
	cTipo		:= (cAliasQry)->E2_TIPO
	dDtEmiss	:= (cAliasQry)->E2_EMISSAO
	cParcela	:= (cAliasQry)->E2_PARCELA
	nFatura		:= (cAliasQry)->E2_VALOR
	dDtVenc		:= (cAliasQry)->E2_VENCTO			
	dVenReal	:= (cAliasQry)->E2_VENCREA
	dDtCont		:= (cAliasQry)->E2_EMIS1
	dDtBaixa	:= (cAliasQry)->E2_BAIXA
	cPrefix		:= (cAliasQry)->E2_PREFIXO
	nCofins		:= (cAliasQry)->E2_COFINS
	nPIS		:= (cAliasQry)->E2_PIS
	nCSLL		:= (cAliasQry)->E2_CSLL
	nVlrISS		:= (cAliasQry)->E2_ISS
	nVlrIRRF	:= (cAliasQry)->E2_IRRF
	nDecres		:= (cAliasQry)->E2_DECRESC
	cHistor		:= (cAliasQry)->E2_HIST
	cNaturez	:= (cAliasQry)->E2_NATUREZ

	If !Empty((cAliasQry)->E2_BAIXA) .And. (cAliasQry)->E2_BAIXA > (cAliasQry)->E2_EMIS1
		nSaldo		:= (cAliasQry)->E2_VALOR
	Else
		nSaldo		:= (cAliasQry)->E2_SALDO
	Endif
	
    If lPosA2
		cCodCli	:= SA2->A2_COD
		cCodLoj	:= SA2->A2_LOJA
		cCliLoj	:= cCodCli + cCodLoj  				    
		cCNPJ	:= SA2->A2_CGC
    	cRazao	:= SA2->A2_NOME
   		cNomFan := SA2->A2_NREDUZ
    Else
   		cCNPJ	:= " "
    	cRazao	:= " "
	    cCodCli	:= " "
		cCodLoj	:= " "
		cCliLoj	:= " "
		cNomFan	:= " "	    
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