#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06R01   � Autor � Cleber Maldonado      � Data � 07/07/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confer�ncia de Comiss�es                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06R04()

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
oReport := TReport():New("M06R04","Confer�ncia Comiss�es","M06R04", {|oReport| ReportPrint(oReport,cAliasQry,oTitulos)},"Este relatorio emite a relacao de titulos de comiss�es " + " " + " de acordo com os par�metros informados.")
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
TRCell():New(oTitulos,"FILIAL"		,/*Tabela*/ ,"Filial"			,PesqPict("SE1","E1_FILIAL")	,TamSx3("E1_FILIAL")[1]		,/*lPixel*/,{|| cxFilial })		// Filial
TRCell():New(oTitulos,"EMISSAO"		,/*Tabela*/ ,"Dt.Movimento"		,PesqPict("SE1","E1_EMISSAO")	,TamSx3("E1_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao })		// Data de Emiss�o do Pedido
TRCell():New(oTitulos,"TIPO"		,/*Tabela*/ ,"Tipo"				,PesqPict("SE1","E1_TIPO")		,TamSx3("E1_TIPO")[1]		,/*lPixel*/,{|| cTipo	 })		// Tipo do t�tulo
TRCell():New(oTitulos,"VALTIT"		,/*Tabela*/ ,"Vlr.Movimento"	,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,{|| nValor	 })		// Valor do Titulo
TRCell():New(oTitulos,"VENCTO"		,/*Tabela*/ ,"Dt. Vencimento"	,PesqPict("SE1","E1_VENCTO")	,TamSx3("E1_VENCTO")[1]		,/*lPixel*/,{|| dVencto	 })		// Data de Vencimento
TRCell():New(oTitulos,"BENEF"		,/*Tabela*/ ,"Beneficiario"		,PesqPict("SE1","E1_NOMCLI")	,TamSx3("E1_NOMCLI")[1]		,/*lPixel*/,{|| cBenef	 })		// Benefici�rio
TRCell():New(oTitulos,"RAZAO"		,/*Tabela*/ ,"Razao Social"		,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1] 		,/*lPixel*/,{|| cNomCli	 })		// Raz�o Social do Cliente
TRCell():New(oTitulos,"PREFIXO"		,/*Tabela*/ ,"Prefixo"			,PesqPict("SE1","E1_PREFIXO")	,TamSx3("E1_PREFIXO")[1]	,/*lPixel*/,{|| cPrefixo })		// Prefixo do T�tulo
TRCell():New(oTitulos,"NUMTIT"		,/*Tabela*/ ,"Num.Titulo"		,PesqPict("SE1","E1_NUM")		,TamSx3("E1_NUM")[1]		,/*lPixel*/,{|| cNumTit	 })		// Numero do T�tulo
TRCell():New(oTitulos,"NUMPED"		,/*Tabela*/	,"Num.Pedido"		,PesqPict("SE1","E1_PEDIDO")	,TamSx3("E1_PEDIDO")[1]		,/*lPixel*/,{|| cNumPed	 })		// Numero do Pedido
TRCell():New(oTitulos,"PARCELA"		,/*Tabela*/ ,"Parcela"			,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,{|| cParcela })		// Parcela do T�tulo
TRCell():New(oTitulos,"CLIENTE"		,/*Tabela*/ ,"Cliente"			,PesqPict("SA1","E1_CLIENTE")   ,TamSx3("E1_CLIENTE")[1]	,/*lPixel*/,{|| cCodCli  })		// C�digo do Cliente
TRCell():New(oTitulos,"LOJA"		,/*Tabela*/ ,"Loja"				,PesqPict("SE1","E1_LOJA")		,TamSx3("E1_LOJA")[1]	 	,/*lPixel*/,{|| cLoja	 })		// Loja do Cliente
TRCell():New(oTitulos,"PAGTO"		,/*Tabela*/	,"Dt. Baixa"	 	,PesqPict("SE1","E1_BAIXA")		,TamSx3("E1_BAIXA")[1]		,/*lPixel*/,{|| dBaixa	 })		// Data da baixa - Pagamento
TRCell():New(oTitulos,"CODVEND1"	,/*Tabela*/ ,"Vendedor 1"		,PesqPict("SE1","E1_VEND1")		,TamSx3("E1_VEND1")[1]		,/*lPixel*/,{|| cCodVen1 })		// C�digo do Vendedor 1
TRCell():New(oTitulos,"CODVEND2"	,/*Tabela*/ ,"Vendedor 2"		,PesqPict("SE1","E1_VEND2")		,TamSx3("E1_VEND2")[1]		,/*lPixel*/,{|| cCodVen2 })		// C�digo do Vendedor 2
TRCell():New(oTitulos,"CODVEND3"	,/*Tabela*/ ,"Vendedor 3"		,PesqPict("SE1","E1_VEND3")		,TamSx3("E1_VEND3")[1]		,/*lPixel*/,{|| cCodVen3 })		// C�digo do Vendedor 3
TRCell():New(oTitulos,"CODVEND4"	,/*Tabela*/ ,"Vendedor 4"		,PesqPict("SE1","E1_VEND4")		,TamSx3("E1_VEND4")[1]		,/*lPixel*/,{|| cCodVen4 })		// C�digo do Vendedor 4
TRCell():New(oTitulos,"CODVEND5"	,/*Tabela*/ ,"Vendedor 5"		,PesqPict("SE1","E1_VEND5")		,TamSx3("E1_VEND5")[1]		,/*lPixel*/,{|| cCodVen5 })		// C�digo do Vendedor 5
TRCell():New(oTitulos,"COMISS1"		,/*Tabela*/	,"% Comissao 1"		,PesqPict("SE1","E1_COMIS1")	,TamSx3("E1_COMIS1")[1]		,/*lPixel*/,{|| nComis1  })		// % de Comiss�o Vendedor 1
TRCell():New(oTitulos,"COMISS2"		,/*Tabela*/ ,"% Comissao 2"		,PesqPict("SE1","E1_COMIS2")	,TamSx3("E1_COMIS2")[1]		,/*lPixel*/,{|| nComis2  })		// % de Comiss�o Vendedor 2
TRCell():New(oTitulos,"COMISS3"		,/*Tabela*/ ,"% Comissao 3"		,PesqPict("SE1","E1_COMIS3")	,TamSx3("E1_COMIS3")[1]		,/*lPixel*/,{|| nComis3  })		// % de Comiss�o Vendedor 3
TRcell():New(oTitulos,"COMISS4"		,/*Tabela*/ ,"% Comissao 4"		,PesqPict("SE1","E1_COMIS4")	,TamSx3("E1_COMIS4")[1]		,/*lPixel*/,{|| nComis4  })		// % de Comiss�o Vendedor 4
TRCell():New(oTitulos,"COMISS5"		,/*Tabela*/ ,"% Comissao 5"		,PesqPict("SE1","E1_COMIS5")	,TamSx3("E1_COMIS5")[1]		,/*lPixel*/,{|| nComis5	 })		// % de Comiss�o Vendedor 5
TRCell():New(oTitulos,"DESCONT"		,/*Tabela*/ ,"Desconto"			,PesqPict("SE1","E1_DESCON1")	,TamSx3("E1_DESCON1")[1]	,/*lPixel*/,{|| nDesc	 })		// Valor do Desconto
TRCell():New(oTitulos,"HISTOR"		,/*Tabela*/ ,"Historico"		,PesqPict("SE1","E1_HIST")		,TamSx3("E1_HIST")[1]		,/*lPixel*/,{|| cHist	 })		// Hist�rico

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

Local lPosA1	:= .F.

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
	
		SELECT 
				E1_FILIAL,E1_PEDIDO,E1_TIPO,E1_EMISSAO,E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA,E1_VENCTO,E1_PREFIXO,
				E1_BAIXA,E1_PORTADO,E1_VALLIQ,E1_ACRESC,E1_DECRESC,E1_DESCON1,E1_VALOR,E1_HIST,E1_VEND1,E1_NOMCLI,
				E1_VEND1,E1_VEND2,E1_VEND3,E1_VEND4,E1_VEND5,E1_COMIS1,E1_COMIS2,E1_COMIS3,E1_COMIS4,E1_COMIS5 
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL IN ("01", "03") AND
			SE1.E1_BAIXA >= %Exp:MV_PAR01% AND
			SE1.E1_BAIXA <= %Exp:MV_PAR02% AND
			SE1.E1_VEND1 >= %Exp:MV_PAR03% AND
			SE1.E1_VEND1 <= %Exp:MV_PAR04% AND
			SE1.E1_TIPO NOT IN ( 'RA' , 'NCC' , 'IN-' ) AND
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
dbSelectArea("SE5")
dbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ                                                                                      
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA))
	lPosE5 	:= SE5->(MsSeek(xFilial('SE5')+(cAliasQry)->E1_PREFIXO+(cAliasQry)->E1_NUM+(cAliasQry)->E1_PARCELA))
	
	If lPosE5
		If SE5->E5_MOTBX <> "NOR"
			(cAliasQry)->(dbSkip())
			Loop
		Endif
	Else
		(cAliasQry)->(dbSkip())
		Loop		
	Endif		
	
	cNumPed		:= (cAliasQry)->E1_PEDIDO
	cTipo		:= (cAliasQry)->E1_TIPO
	cxFilial	:= (cAliasQry)-> E1_FILIAL
	dEmissao	:= (cAliasQry)->E1_EMISSAO
	cNumTit		:= (cAliasQry)->E1_NUM
	cParcela	:= (cAliasQry)->E1_PARCELA
	dVencto		:= (cAliasQry)->E1_VENCTO
	dBaixa		:= (cAliasQry)->E1_BAIXA
	nDesc		:= (cAliasQry)->E1_DESCON1
	nValor		:= SE5->E5_VALOR
	cBenef		:= (cAliasQry)->E1_NOMCLI
	cPrefixo	:= (cAliasQry)->E1_PREFIXO
	cCodVen1	:= (cAliasQry)->E1_VEND1
	cCodVen2	:= (cAliasQry)->E1_VEND2
	cCodVen3	:= (cAliasQry)->E1_VEND3
	cCodVen4	:= (cAliasQry)->E1_VEND4
	cCodVen5	:= (cAliasQry)->E1_VEND5		
	nComis1		:= (cAliasQry)->E1_COMIS1
	nComis2		:= (cAliasQry)->E1_COMIS2
	nComis3		:= (cAliasQry)->E1_COMIS3
	nComis4		:= (cAliasQry)->E1_COMIS4
	nComis5		:= (cAliasQry)->E1_COMIS5	
	cHist		:= (cAliasQry)->E1_HIST
	
	If lPosA1
		cCodCli		:= SA1->A1_COD
		cLoja		:= SA1->A1_LOJA
		cNomCli		:= SA1->A1_NOME
	Endif
		
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return