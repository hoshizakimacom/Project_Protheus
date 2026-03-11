#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M10R03   � Autor � Cleber Maldonado      � Data � 21/06/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Instala��o                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M10R03()

Local oReport
Private nQTDx1   :=0
Private nQtdx2   :=0
Private cTexto   :=""
Private cxPesq01 :=""
Private cxOpcaox :=" 
Private cAliasQry:=""
Private cCampox  :=""
Private cxusrtecx:=GetMv("AM_XUSRTEC")
Private cxENVCLIx:=GetMv("AM_XENVCLI")

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
//#IFDEF TOP
	Local cAliasQry := GetNextAlias()
/*#ELSE	
	Local cAliasQry := "SC6"
#ENDIF	*/

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
oReport := TReport():New("M10R03","Instalacao X Pedido","M10R03", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio ira emitir a relacao de tipos de instacao por pedido." + " " + " Sera considerado somente dados da filial 01.")
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
oVenProd := TRSection():New(oReport,STR0023,{"SC6","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"CNUM"		,/*Tabela*/	,"N.Pedido"	 		 ,PesqPict("SC6","C6_NUM")		,TamSx3("C6_NUM")	 [1]  	,/*lPixel*/,{|| cNum		})			// Numero do Pedido
TRCell():New(oVenProd,"CITEM"		,/*Tabela*/ ,"Item"				 ,PesqPict("SC6","C6_ITEM")		,TamSx3("C6_ITEM")	 [1]	,/*lPixel*/,{|| cItem		})			// Item do Pedido
TRCell():New(oVenProd,"CPLANTA"		,/*Tabela*/ ,"Planta"			 ,PesqPict("SC6","C6_XITEMP")	,TamSx3("C6_XITEMP") [1]	,/*lPixel*/,{|| cXItemP		})			// Item Planta
TRCell():New(oVenProd,"QUANTIDADE"	,/*Tabela*/ ,"Quantidade"		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN") [1]	,/*lPixel*/,{|| nQtdVen		})			// Quantidade de venda
TRCell():New(oVenProd,"VALOR"		,/*Tabela*/ ,"Valor"			 ,PesqPict("SC6","C6_VALOR")	,TamSx3("C6_VALOR")  [1]	,/*lPixel*/,{|| nValor		})			// Quantidade de venda
TRCell():New(oVenProd,"CDESC"		,/*Tabela*/	,"Descricao"		 ,PesqPict("SB5","B5_CEME")		,TamSx3("B5_CEME")   [1]    ,/*lPixel*/,{|| cDesc	    })		    // Descrição
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Dt.Emissao"		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]  	,/*lPixel*/,{|| dEmissao	})			// Data de emissão
TRCell():New(oVenProd,"DATFAT"		,/*Tabela*/ ,"Dt.Ult.Fat."		 ,PesqPict("SC6","C6_DATFAT")	,TamSx3("C6_DATFAT") [1]  	,/*lPixel*/,{|| dDatFat		})			// Data do Ultimo Faturamento
TRCell():New(oVenProd,"ETAPA"       ,/*Tabela*/ ,"Etapa"             ,PesqPict("ZA3","ZA3_DESCRI")  ,TamSx3("ZA3_DESCRI")[1]    ,/*lPixel*/,{|| cXetapa     })          // Etapa
TRCell():New(oVenProd,"TPLIBTEC"    ,/*Tabela*/ ,"Tipo de Liberacao" ,PesqPict("SC5","C5_XTPLTEC")  ,TamSx3("C5_XTPLTEC")[1]    ,/*lPixel*/,{|| cXTpLib     })          // Tipo de Libera��o T�cnico Comercial
TRCell():New(oVenProd,"USRLIBTEC"   ,/*Tabela*/ ,"Usuario Liberacao" ,PesqPict("SC5","C5_XUSRLIB")  ,TamSx3("C5_XUSRLIB")[1]    ,/*lPixel*/,{|| cXUsrLib    })          // Usuario que efetuou a Libera��o T�cnico Comercial
TRCell():New(oVenProd,"DATLIBTEC"   ,/*Tabela*/ ,"Data Liberacao"    ,PesqPict("SC5","C5_XDATTEC")  ,TamSx3("C5_XDATTEC")[1]    ,/*lPixel*/,{|| cXDatLib    })          // Data de Libera��o T�cnico Comercial
TRCell():New(oVenProd,"TPINSTA"		,/*Tabela*/ ,"Tp.Instalacao"	 ,PesqPict("SC5","C5_XTPINST")	,TamSx3("C5_XTPINST")[1]	,/*lPixel*/,{|| cxTpInst	})			// Tipo de Instala��o
TRCell():New(oVenProd,"TPVEN"		,/*Tabela*/ ,"Tp.Venda"			 ,PesqPict("SC5","C5_XTPVEN")	,TamSx3("C5_XTPVEN") [1]  	,/*lPixel*/,{|| cxTpVen		})			// Tipo de Venda
TRCell():New(oVenProd,"NOMECLI"		,/*Tabela*/ ,"Cliente"			 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")	 [1]  	,/*lPixel*/,{|| cNomeCli	})			// Nome do Cliente
TRCell():New(oVenProd,"FATURADO"    ,/*Tabela*/ ,"Faturado?"         ,PesqPict("ZA3","ZA3_DESCRI")  ,TamSx3("ZA3_DESCRI")[1]    ,/*lPixel*/,{|| cFaturado   })          // Faturado
TRCell():New(oVenProd,"USRTECCOM"   ,/*Tabela*/ ,"Usr.Tec.Com."      ,PesqPict("SC5","C5_XUSRTEC")  ,TamSx3("C5_XUSRTEC")[1]    ,/*lPixel*/,{|| cXUsrTec	})          // Usuario Tec. Comercial
TRCell():New(oVenProd,"STATUSREC"   ,/*Tabela*/ ,"Sts.Recebimento"   ,PesqPict("SC5","C5_XSTSREC")  ,TamSx3("C5_XSTSREC")[1]    ,/*lPixel*/,{|| cXStsRec	})          // Status do Recebimento
TRCell():New(oVenProd,"DT.RECEB"	,/*Tabela*/ ,"Dt.Recebimento"	 ,PesqPict("SC5","C5_XDTRECB")  ,TamSx3("C5_XDTRECB")[1]    ,/*lPixel*/,{|| cXDtRecb	})          // Data do Recebimento 
TRCell():New(oVenProd,"ENV.CLIENT"	,/*Tabela*/ ,"Env.Cliente"		 ,PesqPict("SC5","C5_XENVCLI")  ,TamSx3("C5_XENVCLI")[1]    ,/*lPixel*/,{|| cXEnvCli	})          // Resp. Envio ao Cliente 
TRCell():New(oVenProd,"DT.ENV.CLI"	,/*Tabela*/ ,"Dt.Env.Cliente"	 ,PesqPict("SC5","C5_XDTENV")   ,TamSx3("C5_XDTENV")[1]     ,/*lPixel*/,{|| cXDtEnv		})          // Data de Envio ao Cliente 
TRCell():New(oVenProd,"USRLIBTECC"	,/*Tabela*/ ,"Usuario Lib.Tecc"	 ,PesqPict("SC6","C6_XGOPUS")   ,TamSx3("C6_XGOPUS")[1]     ,/*lPixel*/,{|| cXUsrLibT	})          // Usuario Lib.Tec. Com. 
TRCell():New(oVenProd,"DT.LIBTECC"	,/*Tabela*/ ,"Dt.Lib.TecC"		 ,PesqPict("SC6","C6_XGOPDT")   ,TamSx3("C6_XGOPDT")[1]     ,/*lPixel*/,{|| cXDtLibTeC	})          // Data de Lib.Tec.Com 

TRCell():New(oVenProd,"DT.MEDICAO"	,/*Tabela*/ ,"Dt.Medi��o"		 ,PesqPict("SC6","C6_XMEDDT")   ,TamSx3("C6_XMEDDT")[1]     ,/*lPixel*/,{|| cXDtMedica	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"USRMEDICAO"	,/*Tabela*/ ,"Usuario Medi��o"	 ,PesqPict("SC6","C6_XMEDUS")   ,TamSx3("C6_XMEDUS")[1]     ,/*lPixel*/,{|| cXUsMedica	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"DT.CANCELA"	,/*Tabela*/ ,"Dt.Cancelamento"	 ,PesqPict("SC6","C6_XCANDT")   ,TamSx3("C6_XCANDT")[1]     ,/*lPixel*/,{|| cXDtCancel	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"USRCANCELA"	,/*Tabela*/ ,"Usuario Cancela"	 ,PesqPict("SC6","C6_XCANUS")   ,TamSx3("C6_XCANUS")[1]     ,/*lPixel*/,{|| cXUSCancel	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"DT.REALOCA"	,/*Tabela*/ ,"Dt.Realoca��o"	 ,PesqPict("SC6","C6_XREADT")   ,TamSx3("C6_XREADT")[1]     ,/*lPixel*/,{|| cXDtRealoc	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"USRREALOCA"	,/*Tabela*/ ,"Usuario Realoca��o",PesqPict("SC6","C6_XREAUS")   ,TamSx3("C6_XREAUS")[1]     ,/*lPixel*/,{|| cXUsRealoc	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"DT.AGINFOR"	,/*Tabela*/ ,"Dt.Ag Infor"		 ,PesqPict("SC6","C6_XAINDT")   ,TamSx3("C6_XAINDT")[1]     ,/*lPixel*/,{|| cXDtAgInfo	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"USRAGINFOR"	,/*Tabela*/ ,"Usuario Ag Infor"	 ,PesqPict("SC6","C6_XAINUS")   ,TamSx3("C6_XAINUS")[1]     ,/*lPixel*/,{|| cXUsAgInfo	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"DT.SOLCOMP"	,/*Tabela*/ ,"Dt.Sol.Compra"	 ,PesqPict("SC6","C6_XSCODT")   ,TamSx3("C6_XSCODT")[1]     ,/*lPixel*/,{|| cXDtSolCom	})          // Data de Lib.Tec.Com 
TRCell():New(oVenProd,"USRSOLCOMP"	,/*Tabela*/ ,"Usuario Sol.Compra",PesqPict("SC6","C6_XSCOUS")   ,TamSx3("C6_XSCOUS")[1]     ,/*lPixel*/,{|| cXUSSolCom	})          // Data de Lib.Tec.Com 

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Cleber Maldonado      � Data � 21/06/17 ���
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

Local cFilLog		:= cFilAnt
Local x1			:= 0
Private cColaborador:=""

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)				// Produto,Numero
//#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	If MV_PAR06 == 1

		BeginSql Alias cAliasQry

			SELECT 
				C6_FILIAL,C6_ITEM,C6_XITEMP,C6_PRODUTO,C6_XGOPUS,C6_XGOPDT,C6_NUM,C6_DATFAT,C6_NOTA,C6_XETAPA,
				C6_QTDVEN,C6_QTDENT,C6_VALOR,C5_EMISSAO,C5_XUSRTEC,C5_XSTSREC,C5_XDTRECB,C5_XENVCLI,C5_XDTENV,
				C6_DESCRI,ZA3_DESCRI,C5_XDATTEC,C5_XTPVEN,A1_NOME,C6_XMEDDT,C6_XMEDUS,C6_XCANDT,C6_XCANUS,
				C6_XREADT,C6_XREAUS,C6_XAINDT,C6_XAINUS,C6_XSCODT,C6_XSCOUS,C5_XTPINST,C5_XTPLTEC,C5_XUSRLIB,
				B1_DESC,B5_CEME
			FROM 
				%Table:SC6% SC6
				      LEFT JOIN %Table:SC5% SC5 ON SC6.C6_NUM = SC5.C5_NUM AND SC5.%NotDel%
					  INNER JOIN %Table:SB5% SB5 ON SB5.B5_FILIAL = %Exp:cFilLog% AND SB5.B5_COD = SC6.C6_PRODUTO AND SB5.%NotDel%
					  INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = '  ' 		 AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SC5.%NotDel%
					  INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = '  ' 		 AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.%NotDel%
					  LEFT JOIN %Table:ZA3% ZA3 ON ZA3.ZA3_FILIAL = '  ' 		 AND ZA3.ZA3_CODIGO = SC6.C6_XETAPA AND ZA3.%NotDel%
					  INNER JOIN %Table:SF4% SF4 ON SF4.F4_FILIAL = '  ' 		 AND SF4.F4_CODIGO= SC6.C6_TES      AND SF4.F4_ESTOQUE = 'S' AND SF4.%NotDel%

			WHERE 
				SC6.C6_FILIAL = %Exp:cFilLog% AND
				SC6.C6_DATFAT >= %Exp:MV_PAR01% AND
				SC6.C6_DATFAT <= %Exp:MV_par02% AND
				SC6.C6_NOTA IS NOT NULL AND
				//SC5.C5_CONDPAG <> '035' AND
				SC6.%NotDel%
			ORDER BY SC6.C6_NUM
		EndSql 
	Else
		BeginSql Alias cAliasQry

			SELECT 
				C6_FILIAL,C6_ITEM,C6_XITEMP,C6_PRODUTO,C6_XGOPUS,C6_XGOPDT,C6_NUM,C6_DATFAT,C6_NOTA,C6_XETAPA,
				C6_QTDVEN,C6_VALOR,C6_QTDENT,C5_EMISSAO,C5_XUSRTEC,C5_XSTSREC,C5_XDTRECB,C5_XENVCLI,C5_XDTENV,
				C6_DESCRI,ZA3_DESCRI,C5_XDATTEC,C5_XTPVEN,A1_NOME,C6_XMEDDT,C6_XMEDUS,C6_XCANDT,C6_XCANUS,
				C6_XREADT,C6_XREAUS,C6_XAINDT,C6_XAINUS,C6_XSCODT,C6_XSCOUS,C5_XTPINST,C5_XTPLTEC,C5_XUSRLIB,
				B1_DESC,B5_CEME
			FROM 
				%Table:SC6% SC6
					  LEFT JOIN %Table:SC5% SC5 ON SC6.C6_NUM = SC5.C5_NUM AND SC5.%NotDel%
					  INNER JOIN %Table:SB5% SB5 ON SB5.B5_FILIAL = %Exp:cFilLog% AND SB5.B5_COD = SC6.C6_PRODUTO AND SB5.%NotDel%
					  INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = '  ' 		 AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SC5.%NotDel%
					  INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = '  ' 		 AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.%NotDel%
					  LEFT JOIN  %Table:ZA3% ZA3 ON ZA3.ZA3_FILIAL = '  ' 		 AND ZA3.ZA3_CODIGO = SC6.C6_XETAPA AND ZA3.%NotDel%
					  INNER JOIN %Table:SF4% SF4 ON SF4.F4_FILIAL = '  ' 		 AND SF4.F4_CODIGO= SC6.C6_TES      AND SF4.F4_ESTOQUE = 'S' AND SF4.%NotDel%
			WHERE 
				SC5.C5_FILIAL = %Exp:cFilLog% AND
				SC5.C5_EMISSAO >= %Exp:MV_PAR01% AND
				SC5.C5_EMISSAO <= %Exp:MV_PAR02% AND
				//SC5.C5_CONDPAG <> '035' AND
				SC6.%NotDel%
			ORDER BY SC5.C5_NUM
		EndSql 
	Endif

	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
//#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	IF MV_PAR06 == 1 .And.  (cAliasQry)->C6_QTDENT == 0
	      (cAliasQry)->(dbSkip())
	      Loop
	ElseIf MV_PAR06 == 2 .And. MV_PAR07 == 2 .And. (cAliasQry)->C6_QTDENT <> 0 .And. Empty((cAliasQry)->C6_DATFAT) 
	      (cAliasQry)->(dbSkip())
	      Loop
	Endif	

	If MV_PAR06 == 2 .And. !Empty((cAliasQry)->C6_DATFAT)
	      (cAliasQry)->(dbSkip())
	      Loop
	ENDIF	

	cNum		:= (cAliasQry)->C6_NUM
	cItem		:= (cAliasQry)->C6_ITEM
	cXItemP		:= (cAliasQry)->C6_XITEMP
	dDatFat 	:= (cAliasQry)->C6_DATFAT
	dEmissao    := (cAliasQry)->C5_EMISSAO
	nQtdVen     := (cAliasQry)->C6_QTDVEN
	nValor		:= (cAliasQry)->C6_VALOR
	cXetapa     := (cAliasQry)->ZA3_DESCRI
	cXUsrTec	:= (cAliasQry)->C5_XUSRTEC
	cXStsRec	:= (cAliasQry)->C5_XSTSREC
	cXDtRecb	:= (cAliasQry)->C5_XDTRECB
	cXEnvCli	:= (cAliasQry)->C5_XENVCLI
	cXDtEnv		:= (cAliasQry)->C5_XDTENV
	cXUsrLibT   := (cAliasQry)->C6_XGOPUS 
	cXDtLibTec  := (cAliasQry)->C6_XGOPDT
	cXDtMedica := (cAliasQry)->C6_XMEDDT
	cXUsMedica := (cAliasQry)->C6_XMEDUS
	cXDtCancel := (cAliasQry)->C6_XCANDT
	cXUSCancel := (cAliasQry)->C6_XCANUS
	cXDtRealoc := (cAliasQry)->C6_XREADT
	cXUsRealoc := (cAliasQry)->C6_XREAUS
	cXDtAgInfo := (cAliasQry)->C6_XAINDT
	cXUsAgInfo := (cAliasQry)->C6_XAINUS
	cXDtSolCom := (cAliasQry)->C6_XSCODT
	cXUSSolCom := (cAliasQry)->C6_XSCOUS
	
	If (cAliasQry)->C6_QTDENT >= (cAliasQry)->C6_QTDVEN
		cFaturado := "Total"
	ElseIf (cAliasQry)->C6_QTDENT == 0
	    cFaturado := "Nao Faturado"
	ElseIf (cAliasQry)->C6_QTDENT < (cAliasQry)->C6_QTDVEN .And. (cAliasQry)->C6_QTDENT <> 0 
	    cFaturado := "Parcial"
	Endif

	If (cAliasQry)->C5_XTPINST $ MV_PAR03
		Do Case
			Case (cAliasQry)->C5_XTPINST == '1'
				cxTpInst := "1 - Sem Instala�ao"
			Case (cAliasQry)->C5_XTPINST == '2'
				cxTpInst := "2 - Credenciada"
			Case (cAliasQry)->C5_XTPINST == '3'
				cxTpInst := "3 - Macom"
			Case (cAliasQry)->C5_XTPINST == '4'
				cxTpInst := "4 - Macom Rateio Produto"
		EndCase
	Else
		(cAliasQry)->(dbSkip())
		Loop
	Endif

		
	If Alltrim((cAliasQry)->C5_XTPVEN) $ MV_PAR05

//		U_BusTpVen(cTpVen) //Fun��o para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN

		Do Case
			Case Alltrim((cAliasQry)->C5_XTPVEN) == '1'
				cxTpVen := "1 - Projeto"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == '2'
				cxTpVen := "2 - Venda Unit�ria"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "3"
				cxTpVen := "3 - Dealer"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "4"
				cxTpVen	:= "4 - E-Commerce"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "5"
				cxTpVen := "5 - Pronta Entrega"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "6"
				cxTpVen := "6 - Projeto|Dealer"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "7"
				cXTpVen		:= "7 - Venda de Pe�as"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "8"
				cXTpVen		:= "8 - Suporte Tecnico"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "9"
				cXTpVen		:= "9 - ARE"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "10"
				cXTpVen		:= "10 - Servi�os"
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "11"
				cXTpVen		:= "11 - Itens Faltantes"	
			Case Alltrim((cAliasQry)->C5_XTPVEN) == "12"
				cXTpVen		:= "12 - SAC"	
			OTHERWISE
				cXTpVen		:= " "	
		EndCase
	Else
		(cAliasQry)->(dbSkip())
		Loop
	EndIf

	Do CASE	
		Case (cAliasQry)->C5_XTPLTEC == '1'
			cXTpLib := "1 - Planta"
		Case (cAliasQry)->C5_XTPLTEC == '2'
			cXTpLib := "2 - Planta e Des. Aprovado"
		Case (cAliasQry)->C5_XTPLTEC == '3'
			cXTpLib := "3 - Validacao"
		Case (cAliasQry)->C5_XTPLTEC == '4'
			cXTpLib := "4 - Validacao e Des. Aprovado"
		Case (cAliasQry)->C5_XTPLTEC == '5'
			cXTpLib := "5 - Des. Aprovado"
		Case (cAliasQry)->C5_XTPLTEC == '6'
			cXTpLib := "6 - Desenho Individual"
		Case (cAliasQry)->C5_XTPLTEC == '7'
			cXTpLib := "7 - ANSUL"
		OTHERWISE
			cXTpLib := " "
	ENDCASE

    // *** Pega o Nome do Colaborador - Valdemir - 24/02/2023 *** //
    cxPesq01:= "C5_XUSRTEC"
	cTexto  :=""
	cTextox :=""
	cXUsrTec:= " "
	x1		:=0
	cTextox :=alltrim(cxusrtecx)
	nQTDx1  :=len(alltrim(cTextox))
	nQtdx2  :=1
	cColaborador:=""
	cCampox     :=(cAliasQry)->C5_XUSRTEC 
	PegOpcaox(cTexto)
	cXUsrTec := cTexto
	
    // *** Pega Nome do Colaborador que enviou ao Cliente - Valdemir - 24/02/2023 *** //
    cxPesq01 	:= "C5_XENVCLI"
	cTexto   	:=""
	cTextox  	:=""
	cXEnvCli 	:= " "
	x1		 	:=0
	cTextox	 	:=alltrim(cxENVCLIx)
	nQTDx1	 	:=len(alltrim(cTextox))
	nQtdx2	 	:=1
	cColaborador:=""
	cCampox     :=(cAliasQry)->C5_XENVCLI
	PegOpcaox(cTexto)
	cXEnvCli    :=cTexto

	Do CASE	
		Case (cAliasQry)->C5_XSTSREC == '1'
			cXStsRec := "1 - Tec. Comercial"
		Case (cAliasQry)->C5_XSTSREC == '2'
			cXStsRec := "2 - Falta de Pre Requisitos"
		OTHERWISE
			cXStsRec := " "
	ENDCASE

    cXUsrLib   	:= (cAliasQry)->C5_XUSRLIB
   	cXDatLib	:= (cAliasQry)->C5_XDATTEC
		
	cNomeCli	:= SA1->A1_NOME
	
	If MV_PAR04 == 1
		cDesc := (cAliasQry)->B1_DESC
	Else
		cDesc := (cAliasQry)->B5_CEME
	Endif
	
	oReport:IncMeter()
       	
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

//oReport:SetLandScape()

oReport:Section(1):Finish()

Return

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |PegXEnvCli |Autor | VALDEMIR MIRANDA   | Data |  23/02/2023  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Pega Conte�do do Campo X3_BOX, da tabela SX3, de acordo com ||
||           | o Campo C5_XENVCLI, da tabela SC5                           ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Uso       | Controle de PCP / BackOffice                                ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function PegOpcaox(cColaborador)
Local x1:=0
nQtdx2:=1
for x1	 :=1 to nQTDx1
	if alltrim(cCampox)  == substr(cTextox,nQtdx2,1)
		cxOpcaox:=substr(cTextox,nQtdx2,1)
		cTexto:= PegXEnvCli(cTexto)
		exit 
	endif
	nQtdx2:=nQtdx2+2
	next x1
Return(cTexto)


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |PegXEnvCli |Autor | VALDEMIR MIRANDA   | Data |  22/02/2023  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Pega Conte�do do Campo X3_BOX, da tabela SX3, de acordo com ||
||           | o Campo C5_XENVCLI, da tabela SC5                           ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Uso       | Controle de PCP / BackOffice                                ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function PegXEnvCli(cTexto)
Local aAreax	:=""
Local x1    	:=""
Local cAlfabeto	:="a/A/b/B/c/C/d/D/e/E/f/F/g/G/h/H/i/I/j/J/k/K/l/L/m/M/n/N/o/O/p/P/q/Q/r/R/s/S/t/T/u/U/v/V/w/W/x/X/y/Y/z/Z"

// *** Pega conteudo do campo X3_CBOS, da tabela SX3 *** //
DBSELECTAREA("SX3")
aAreax:=GETAREA()
DBSETORDER(2)
DBSEEK(cxPesq01)  
if .not. eof()
   
   cTexto:=""
   nTam  :=len(alltrim(GetSX3Cache(cxPesq01, "X3_CBOX")))
   nQtdx := 0
   cProcessa:="N"
   if cxOpcaox $GetSX3Cache(cxPesq01, "X3_CBOX")
   		For x1:=1 to nTam
       		if substr(alltrim(GetSX3Cache(cxPesq01, "X3_CBOX")),x1,1) <> ";"

	      		if substr(alltrim(GetSX3Cache(cxPesq01, "X3_CBOX")),x1,1) = cxOpcaox
		     		cProcessa:="S"
		  		endif

          		if cProcessa = "S"
	      			if substr(alltrim(GetSX3Cache(cxPesq01, "X3_CBOX")),x1,1) $cAlfabeto
		    	 		cTexto:=cTexto+substr(alltrim(GetSX3Cache(cxPesq01, "X3_CBOX")),x1,1)
		  			endif
		  		endif
	   		else
		  		cProcessa:="N"
	   		endif
	
		Next x1
   endif
Endif
Restarea(aAreax)
Return(cTexto)
