#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M05R11   � Autor � Cleber Maldonado      � Data � 08/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Acompanhamento Follow-Up                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M05R11()

Local oReport

cUsuario := RetCodUsr()

If U_M05G05() //cUsuario $ '000048|000056|000151|000131|000089|000064|000028|000168|000027|000160|000040|000253||000227'
	If FindFunction("TRepInUse") .And. TRepInUse()
		//-- Interface de impressao
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Else
	MsgStop("Usu�rio n�o autorizado a emitir o relat�rio. Entre em contato com o departamento de T.I.","N�o Autorizado!")	
Endif

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Cleber Maldonado      � Data � 08/08/17 ���
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
oReport := TReport():New("M05R11","Follow Up","M05R11", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de acompanhamento " + " " + " dos registros de follow up dos or�amentos.")
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
oVenProd := TRSection():New(oReport,"REGISTRO FOLLOW UP",{"ZA9","SCJ"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/ ,"Filial"			 ,PesqPict("ZA9","ZA9_FILIAL")	,TamSx3("ZA9_FILIAL")[1]	,/*lPixel*/,{|| cXFilial})		// Filial
TRCell():New(oVenProd,"NUMORC"		,/*Tabela*/	,"N.Or�amento" 		 ,PesqPict("ZA9","ZA9_XNUMOR")	,TamSx3("ZA9_XNUMOR")[1]	,/*lPixel*/,{|| cNumOr	})		// Numero do Or�amento
TrCell():New(oVenProd,"TOTAL"		,/*Tabela*/ ,"Vlr. Total"		 ,PesqPict("SCK","CK_VALOR")	,TamSx3("CK_VALOR")[1]		,/*lPixel*/,{|| nValTot })		// Valor Total do Or�amento
TRCell():New(oVenProd,"STATUS"		,/*Tabela*/ ,"Status"			 ,PesqPict("ZA9","ZA9_XFUST")	,TamSx3("A1_NREDUZ")[1]-15	,/*lPixel*/,{|| cStatus	})		// Status do Follow Up
TRCell():New(oVenProd,"CODCLI"		,/*Tabela*/	,"Codigo"		 	 ,PesqPict("SA1","A1_COD")		,TamSx3("A1_COD")[1]		,/*lPixel*/,{|| cCodCli	})		// Codigo Cliente
TRCell():New(oVenProd,"CODLOJ"		,/*Tabela*/	,"Loja"				 ,PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA")[1]		,/*lPixel*/,{|| cCodLoj	})		// Loja do Cliente
TRCell():New(oVenProd,"NOME"		,/*Tabela*/	,"Nome Cliente"		 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNome	})		// Nome do Cliente
TRCell():New(oVenProd,"REGIAO"		,/*Tabela*/ ,"Regiao"			 ,PesqPict("SA1","A1_DSCREG")	,TamSx3("A1_DSCREG")[1]		,/*lPixel*/,{|| cRegiao })		// Regi�o do Cliente
TRCell():New(oVenProd,"ESTADO"		,/*Tabela*/ ,"Estado"			 ,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cUF		})		// UF do Cliente
TRCell():New(oVenProd,"VENDEDOR"	,/*Tabela*/	,"Vendedor"			 ,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cVend	})		// Vendedor
TRCell():New(oVenProd,"TIPOVEN"		,/*Tabela*/ ,"Tipo Venda"		 ,PesqPict("SCJ","CJ_XTPVEN")	,TamSx3("CJ_XTPVEN")[1]		,/*lPixel*/,{|| cXTpVen })		// Tipo de Venda
TRCell():New(oVenProd,"FECHAMENTO"	,/*Tabela*/ ,"Prev.Fechamento"	 ,PesqPict("ZA9","ZA9_XFUFEC")	,TamSx3("ZA9_XFUFEC")[1]	,/*lPixel*/,{|| dDtFec	})		// Data prevista para fechamento
TRCell():New(oVenProd,"PRXCONT"		,/*Tabela*/ ,"Prox.Contato"		 ,PesqPict("ZA9","ZA9_XFUPRX")	,TamSx3("ZA9_XFUPRX")[1]	,/*lPixel*/,{|| dDtPrx	})		// Data prevista para pr�ximo contato
TRCell():New(oVenProd,"ULTCOM"		,/*Tabela*/	,"Ult.Contato"		 ,PesqPict("ZA9","ZA9_XFUULT")	,TamSx3("ZA9_XFUULT")[1]	,/*lPixel*/,{|| dDtUlt	})		// Data do ultimo contato
TRCell():New(oVenProd,"MOTIVO"		,/*Tabela*/ ,"Motivo"			 ,PesqPict("ZA9","ZA9_XFUMOT")	,TamSx3("ZA9_XFUMOT")[1]	,/*lPixel*/,{|| cMotivo })		// Motivo de Perda do Or�amento
TRCell():New(oVenProd,"CONCOR"		,/*Tabela*/ ,"Concorrente"		 ,PesqPict("ZA9","ZA9_XFUCON")	,TamSx3("ZA9_XFUCON")[1]	,/*lPixel*/,{|| cConcor })		// Concorrente para o qual o or�amento foi perdido
TRCell():New(oVenProd,"USUARIO"		,/*Tabela*/ ,"Usuario"			 ,PesqPict("ZA9","ZA9_XFUUSR")	,TamSx3("ZA9_XFUUSR")[1]	,/*lPixel*/,{|| cNomUsr })		// Nome do usu�rio que efetuou o Follow Up

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

		COLUMN ZA9_XFUFEC AS DATE
		COLUMN ZA9_XFUPRX AS DATE
		COLUMN ZA9_XFUULT AS DATE

		SELECT 
			ZA9_FILIAL,ZA9_XFUST,ZA9_XFUMOT,ZA9_XNUMOR,ZA9_XFUCON,ZA9_XFUFEC,ZA9_XFUPRX,ZA9_XFUULT,ZA9_XFUUSR
		FROM 
			%Table:ZA9% ZA9
		WHERE 
			ZA9.ZA9_FILIAL = %xfilial:ZA9% AND
			ZA9.ZA9_XNUMOR >= %Exp:MV_PAR01% AND
			ZA9.ZA9_XNUMOR <= %Exp:MV_PAR02% AND
			ZA9.ZA9_XFUPRX >= %Exp:MV_PAR03% AND
			ZA9.ZA9_XFUPRX <= %Exp:MV_PAR04% OR
			ZA9.ZA9_XFUULT >= %Exp:MV_PAR05% AND
			ZA9.ZA9_XFUULT <= %Exp:MV_PAR06% AND
			ZA9.%NotDel%
//		ORDER BY ZA9.C5_NUM
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
dbSelectArea("SCJ")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	lPosCJ	:= SCJ->(MsSeek(xFilial('SCJ')+(cAliasQry)->ZA9_XNUMOR))
	lPosA1 	:= SA1->(MsSeek(xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
	
	cNumOr	:= (cAliasQry)->ZA9_XNUMOR

	If lPosA1
		cCodCli := SA1->A1_COD
		cCodLoj	:= SA1->A1_LOJA
		cNome	:= SA1->A1_NOME
		cRegiao	:= SA1->A1_DSCREG
		cUF		:= SA1->A1_EST
	Else
		cCodCli	:= ""
		cCodLoj	:= ""
		cNome	:= ""
		cRegiao	:= ""
		cUF		:= ""
	Endif
	
	If lPosCJ
		cVend		:= Posicione('SA3',1,XFILIAL('SA3')+SCJ->CJ_XVEND1,'A3_NOME')
		cXFilial	:= SCJ->CJ_FILIAL

		cXTpVenCod := AllTrim(SCJ->CJ_XTPVEN)
		If cXTpVenCod == "1"
			cXTpVen		:= "1 - Projeto"
		ElseIf cXTpVenCod == "2"
			cXTpVen		:= "2 - Venda Unitaria"
		ElseIf cXTpVenCod  == "3"
			cXTpVen		:= "3 - Dealer"
		ElseIf cXTpVenCod == "4"
			cXTpVen		:= "4 - E-Commerce"
		ElseIf cXTpVenCod == "5"
			cXTpVen		:= "5 - Pronta Entrega"
		ElseIf cXTpVenCod == "6"
			cXTpVen		:= "6 - Projeto-Dealer"
		ElseIf cXTpVenCod == "7"
			cXTpVen		:= "7 - Venda Pecas"
		ElseIf cXTpVenCod == "8"
			cXTpVen		:= "8 - Sup.Tecnico"
		ElseIf cXTpVenCod == "9"
			cXTpVen		:= "9 - ARE"
		ElseIf cXTpVenCod == "10"
			cXTpVen		:= "10 - Serv"
		ElseIf cXTpVenCod == "11"
			cXTpVen		:= "11 - Itens Falta"
		ElseIf cXTpVenCod == "12"
			cXTpVen		:= "12 - SAC"
		ElseIf cXTpVenCod == ""
			cXTpVen		:= ""
		Endif	

	Else
		cVend		:= " "
		cXFilial	:= " "
		cXTpVen		:= " "
	Endif
	
	dDtFec	    := (cAliasQry)->ZA9_XFUFEC
	
	Do Case
		Case (cAliasQry)->ZA9_XFUMOT == '1'
			cMotivo	:= "1=Preco"
		Case (cAliasQry)->ZA9_XFUMOT == '2'
			cMotivo	:= "2=Prazo"
		Case (cAliasQry)->ZA9_XFUMOT == '3'
			cMotivo	:= "3=Qualidade"
		Case (cAliasQry)->ZA9_XFUMOT == '4'
			cMotivo	:= "4=Condicao de Pagamento"
		Case (cAliasQry)->ZA9_XFUMOT == '5'
			cMotivo	:= "5=Mau Atendimento"
		Case (cAliasQry)->ZA9_XFUMOT == '6'
			cMotivo	:= "6=Prorrogado"
		Otherwise
			cMotivo	:= " "
	EndCase	

	dDtPrx		:= (cAliasQry)->ZA9_XFUPRX

	Do Case
		Case (cAliasQry)->ZA9_XFUCON == '1'
			cConcor	:= "1=Cozil"
		Case (cAliasQry)->ZA9_XFUCON == '2'
			cConcor	:= "2=Alfatec"
		Case (cAliasQry)->ZA9_XFUCON == '3'
			cConcor	:= "3=Berta"
		Case (cAliasQry)->ZA9_XFUCON == '4'
			cConcor	:= "4=Elvi"
		Case (cAliasQry)->ZA9_XFUCON == '5'
			cConcor	:= "5=PPienk"
		Case (cAliasQry)->ZA9_XFUCON == '6'
			cConcor	:= "6=Topema"
		Case (cAliasQry)->ZA9_XFUCON == '7'
			cConcor	:= "7=Tramontina/Eletrolux"
		Case (cAliasQry)->ZA9_XFUCON == '8'		
			cConcor	:= "8=Local"
		Case (cAliasQry)->ZA9_XFUCON == '9'		
			cConcor	:= "9=Everest"			
		Otherwise
			cConcor	:= " "
	EndCase	

	dDtUlt		:= (cAliasQry)->ZA9_XFUULT

	Do Case
		Case (cAliasQry)->ZA9_XFUST == '1'
			cStatus	:= "1-Projeto Cancelado"
		Case (cAliasQry)->ZA9_XFUST == '2'
			cStatus	:= "2-Perdido"
		Case (cAliasQry)->ZA9_XFUST == '3'
			cStatus	:= "3-Em Andamento"
		Case (cAliasQry)->ZA9_XFUST == '4'
			cStatus	:= "4-Substituido"
		Otherwise
			cStatus	:= " "
	EndCase
	
	//Retorna o valor total do Or�amento
	nValTot := U_M5R11TOT(cNumOr)
	
	cNomUsr := UsrFullName ( (cAliasQry)->ZA9_XFUUSR )
	
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
���Programa  � M05R11   � Autor � Cleber Maldonado      � Data � 08/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Acompanhamento Follow-Up                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M5R11TOT(cNum)

Local nValFre	:= 0
Local nValSeg	:= 0
Local nValDes	:= 0
Local nValFret	:= 0
Local nValTot	:= 0
Local cAliasTot := GetNextAlias() 
 
BeginSql Alias cAliasTot

	SELECT 
		CK_NUM,SUM(CK_VALOR) AS TOTAL 
	FROM 
		%Table:SCK% SCK
	WHERE 
		SCK.CK_FILIAL = %xfilial:SCK% AND
		SCK.CK_NUM = %Exp:cNum% AND
		SCK.%NotDel%
	GROUP BY
		SCK.CK_NUM
EndSql 

//Busca valores do cabe�alho do Or�amento
nValFre  := POSICIONE("SCJ",1,xFilial("SCJ")+cNum,"CJ_FRETE")
nValSeg  := POSICIONE("SCJ",1,xFilial("SCJ")+cNum,"CJ_SEGURO")
nValDes  := POSICIONE("SCJ",1,xFilial("SCJ")+cNum,"CJ_DESPESA")
nValFret := POSICIONE("SCJ",1,xFilial("SCJ")+cNum,"CJ_FRETAUT")

nValTot  := (cAliasTot)->TOTAL + ( nValFre + nValSeg + nValDes + nValFret )

(cAliasTot)->(DbCloseArea())

Return nValTot   
