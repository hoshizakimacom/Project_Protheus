#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"

//+----------------------------------------------------------------------------------------
User Function TCDadBco(aDadEmp, aDadBco)
	Local aAreaAtu	:= GetArea()
	Local lRet			:= .T.

	//+----------------------------------------------------------
	// Verifica se passou os parâmetros para a função
	//+----------------------------------------------------------
	If (aDadEmp == Nil .Or. ValType(aDadEmp) <> "A") .Or. (aDadBco == Nil .Or. ValType(aDadBco) <> "A")
		Aviso(	'Atenção',"Os parâmetros passados por referência estão fora dos padrões."+Chr(13)+Chr(10)+"Verifique a chamada da função no programa de origem.",{"&Continua"},2,"Chamada Inválida" )
		lRet	:= .F.
	EndIf

	// Verifica se os arquivos estão posicionados
	If SM0->(Eof()) .Or. SM0->(Bof())
		Aviso('Atenção',"O arquivo de Empresas não esta posicionado.",{"&Continua"},,"Registro Inválido" )
		lRet	:= .F.
	EndIf

	If SA6->(Eof()) .Or. SA6->(Bof())
		Aviso('Atenção',"O arquivo de Bancos não esta posicionado.",{"&Continua"},,"Registro Inválido" )
		lRet	:= .F.
	EndIf

	// Cria array vazio para que não dê erro se não encontrar dados
	aDadEmp	:= {	"",;	// [1] Nome da Empresa
						"",;	// [2] Endereço
						"",;	// [3] Bairro
						"",;	// [4] Cidade
						"",;	// [5] Estado
						"",;	// [6] Cep
						"",;	// [7] Telefone
						"",;	// [8] Fax
						"",;	// [9] CNPJ
						"" ;	// [10]Inscrição Estadual
						}

	aDadBco	:= {	"",;	// [1] Código do Banco
						"",;	// [2] Dígito do Banco
						"",;	// [3] Código da Agência
						"",;	// [4] Dígito da Agência
						"",;	// [5] Número da Conta Corrente
						"",;	// [6] Dígito da Conta Corrente
						"",;	// [7] Nome Completo do Banco
						"",;	// [8] Nome Reduzido do Banco
						"",;	// [9] Nome do Arquivo com o Logotipo do Banco
						0,;		// [10]Taxa de juros a ser utilizado no cálculo de juros de mora
						0,;		// [11]Taxa de multa a ser impressa no boleto
						0,;		// [12]Número de dias para envio do título ao cartório
						"",;	// [13]Dado para o campo "Uso do Banco"
						"",;	// [14]Dado para o campo "Espécie do Documento"
						"" ;	// [15]Código do Cedente
						}

	If lRet
		// Alimenta array com os dados da Empresa
		aDadEmp[1]	:= SM0->M0_NOMECOM

		If !Empty(SM0->M0_ENDCOB)
			aDadEmp[2]	:= SM0->M0_ENDCOB
			aDadEmp[3]	:= SM0->M0_BAIRCOB
			aDadEmp[4]	:= SM0->M0_CIDCOB
			aDadEmp[5]	:= SM0->M0_ESTCOB
			aDadEmp[6]	:= SM0->M0_CEPCOB
		Else
			aDadEmp[2]	:= SM0->M0_ENDENT
			aDadEmp[3]	:= SM0->M0_BAIRENT
			aDadEmp[4]	:= SM0->M0_CIDENT
			aDadEmp[5]	:= SM0->M0_ESTENT
			aDadEmp[6]	:= SM0->M0_CEPENT
		EndIf

		aDadEmp[7]	:= SM0->M0_TEL
		aDadEmp[8]	:= SM0->M0_FAX
		aDadEmp[9]	:= SM0->M0_CGC
		aDadEmp[10]	:= SM0->M0_INSC

		// Alimenta array com os dados do Banco
		If SA6->(FieldPos("A6_DIGBCO")) > 0
			aDadBco[1]	:= SA6->A6_COD
			aDadBco[2]	:= SA6->A6_DIGBCO
		Else
			aDadBco[1]	:= SA6->A6_COD
			aDadBco[2]	:= Space(1)
		EndIf

		If SA6->(FieldPos("A6_DVAGE")) > 0
			aDadBco[3]	:= SA6->A6_AGENCIA
			aDadBco[4]	:= SA6->A6_DVAGE
		Else
			If At( "-", SA6->A6_AGENCIA ) > 1
				aDadBco[3]	:= SubStr( SA6->A6_AGENCIA, 1, At( "-", SA6->A6_AGENCIA ) - 1 )
				aDadBco[4]	:= SubStr( SA6->A6_AGENCIA, At( "-", SA6->A6_AGENCIA ) + 1, 1 )
			Else
				aDadBco[3]	:= Alltrim(	SA6->A6_AGENCIA	)
				aDadBco[4]	:= ""
			EndIf
		EndIf

		If SA6->(FieldPos("A6_DVCTA")) > 0
			aDadBco[5]	:= SA6->A6_NUMCON
			aDadBco[6]	:= SA6->A6_DVCTA
		Else
			If At( "-", SA6->A6_NUMCON ) > 1
				aDadBco[5]	:= SubStr( SA6->A6_NUMCON, 1, At( "-", SA6->A6_NUMCON ) - 1)
				aDadBco[6]	:= SubStr( SA6->A6_NUMCON, At( "-", SA6->A6_NUMCON ) + 1, 1)
			Else
				aDadBco[5]	:= AllTrim( SA6->A6_NUMCON )
				aDadBco[6]	:= ""
			EndIf
		EndIf

		aDadBco[7]	:= SA6->A6_NOME
		aDadBco[8]	:= SA6->A6_NREDUZ

		If SA6->(FieldPos("A6_ARQLOG")) > 0
			aDadBco[9]	:= SA6->A6_ARQLOG
		Else
			aDadBco[9]	:= ""
		EndIf

		// Define as taxas a serem utilizadas nos cálculos das mensagens
		aDadBco[10]	:= SuperGetMv("TC_TXJBOL", .F., 0.00)
		aDadBco[11]	:= SuperGetMv("TC_TXMBOL", .F., 0.00)
		aDadBco[12]	:= SuperGetMv("TC_DIABOL", .F., 0)

		// Define o campo Para Uso do Banco do boleto
		If SA6->A6_COD $ "745#"
			aDadBco[13]	:= "CLIENTE"
		EndIf

		// Define o campo Espécio do Documento do boleto
		If SA6->A6_COD $ "745#"
			aDadBco[14]	:= "DMI"
		Else
			aDadBco[14]	:= "NF"
		EndIf

		// Define o campo da Conta/Cedente do boleto
		If SA6->A6_COD $ "745#"

			// Agência + Conta Cosmos (Código Empresa)
			aDadBco[15]	:= AllTrim(aDadBco[3])

			If !Empty(aDadBco[4])
				aDadBco[15]	+= "-"+Alltrim(aDadBco[4])
			EndIf

			If !Empty(SEE->EE_CODEMP)
				aDadBco[15]	+= "/"+StrZero(Val(EE_CODEMP),10)
			EndIf
		Else
			// Agência + Conta Corrente
			aDadBco[15]	:= AllTrim(aDadBco[3])

			If !Empty(aDadBco[4])
				If SA6->A6_COD $ "341"
	   				If SA6->A6_COD $ "422"
	      				aDadBco[15] += "-"+Alltrim(aDadBco[4])//Safra
	   				Else
				  		aDadBco[15]	+= "-"+Alltrim(aDadBco[4]) //Bradesco
		 	   		EndIf
				EndIf
		 	Endif

			If !Empty(aDadBco[5])
				aDadBco[15] += "/"+AllTrim(aDadBco[5])

				If !Empty(aDadBco[6])
					aDadBco[15] += "-"+AllTrim(aDadBco[6])
				EndIf
			EndIf
		EndIf

	EndIf

	RestArea(aAreaAtu)
Return(lRet)

//+----------------------------------------------------------------------------------------
//	Retorna array com os dados do título e do cliente
//+----------------------------------------------------------------------------------------
User Function TCDadTit(aDadTit, aDadCli, aBarra, aDadBco)
	Local aAreaAtu	:= GetArea()
	Local lRet			:= .T.
	Local nSaldo		:= 0
	Local cNumDoc		:= ""
	Local cCarteira	:= ""
	Local cMensag1	:= ""
	Local cMensag2	:= ""
	Local cMensag3	:= ""
	Local cMensag4	:= ""
	Local cMensag5	:= ""
	Local cMensag6	:= ""
	Local lSaldo		:= SuperGetMV( "TC_VLRBOL", .F., .T. )
	Local cQry			:= ""
	Local cCarga		:= ""
	Local cPedid		:= ""
	Local cVende		:= ""
	Local cNotas		:= ""
	Local cHist		:= SE1->E1_HIST
	Local __nValMult	:= 0

	Private __lMult	:= .f.

	// Função que efetua o calculo referente a Datas para processamento
	// de Títulos específicos
	__nValMult := _fnDataMult(SE1->E1_VENCTO,dDataBase,SE1->E1_VALOR)

	// Verifica se passou os parâmetros para a função
	If (aDadTit == Nil .Or. ValType(aDadTit) <> "A") .Or. (aDadCli == Nil .Or. ValType(aDadCli) <> "A") .Or. (aBarra == Nil .Or. ValType(aBarra) <> "A")
		Aviso('Atenção', "Os parâmetros passados por referência estão fora dos padrões."+Chr(13)+Chr(10)+ "Verifique a chamada da função no programa de origem.", {"&Continua"},2, "Chamada Inválida" )
		lRet	:= .F.
	EndIf

	// Verifica se os arquivos estão posicionados
	If SE1->(Eof()) .Or. SE1->(Bof())
		Aviso('Atenção', "O arquivo de Títulos a Receber não esta posicionado.", {"&Continua"},, "Registro Inválido" )
		lRet	:= .F.
	EndIf

	If SA1->(Eof()) .Or. SA1->(Bof())
		Aviso('Atenção', "O arquivo de Clientes não esta posicionado.", {"&Continua"},, "Registro Inválido" )
		lRet	:= .F.
	EndIf

	aDadTit	:= {	"",;	// [1] Prefixo do Título
						"",;					// [2] Número do Título
						"",;					// [3] Parcela do Título
						"",;					// [4] Tipo do título
						CToD("  /  /  "),;		// [5] Data de Emissão do título
						CToD("  /  /  "),;		// [6] Data de Vencimento do Título
						CToD("  /  /  "),;		// [7] Data de Vencimento Real
						0,;						// [8] Valor Líquido do Título
						"",;					// [9] Código do Barras Formatado
						"",;					// [10]Carteira de Cobrança
						"",;					// [11]1.a Linha de Mensagens Diversas
						"",;					// [12]2.a Linha de Mensagens Diversas
						"",;					// [13]3.a Linha de Mensagens Diversas
						"",;					// [14]4.a Linha de Mensagens Diversas
						"",;					// [15]5.a Linha de Mensagens Diversas
						"",;					// [16]6.a Linha de Mensagens Diversas
						"",;					// [17]Número das Cargas
						"",;					// [18]Número dos Pedidos
						"",;					// [19]Número das Notas
						"",;					// [20]Código dos Vendedores
						"",;					// [21]Desconto
						"",;					// [22]Mora/Multa
						"",;					// [23]Acrescimo
						"";						// [24]Saldo
						}

	aDadCli	:= {	"",;					// [1] Código do cliente
						"",;					// [2] Loja do Cliente
						"",;					// [3] Nome Completo do Cliente
						"",;					// [4] CNPJ do Cliente
						"",;					// [5] Inscrição Estadual do cliente
						"",;					// [6] Tipo de Pessoa do Cliente
						"",;					// [7] Endereço
						"",;					// [8] Bairro
						"",;					// [9] Município
						"",;					// [10] Estado
						"" ;					// [11] Cep
						}

	aBarra	:= {		"",;					// [1] Código de barras (Banco+"9"+Dígito+Fator+Valor+Campo Livre
						"",;					// [2] Linha Digitável
						"",;					// [3] Nosso Número sem formatação
						"" ;
						}   	// [4] Nosso Número Formatado

	If lRet

		// Alimenta array com os dados do cliente
		aDadCli[1]	:= SA1->A1_COD
		aDadCli[2]	:= SA1->A1_LOJA
		aDadCli[3]	:= SA1->A1_NOME
		aDadCli[4]	:= SA1->A1_CGC
		aDadCli[5]	:= SA1->A1_INSCR
		aDadCli[6]	:= SA1->A1_PESSOA

		If !Empty(SA1->A1_ENDCOB) //.And. !( "MESMO" $ UPPER( SA1->A1_ENDCOB ) )
			aDadCli[7]		:= SA1->A1_ENDCOB
			aDadCli[8]		:= SA1->A1_BAIRROC
			aDadCli[9]		:= SA1->A1_MUNC
			aDadCli[10]	:= SA1->A1_ESTC
			aDadCli[11]	:= SA1->A1_CEPC
		Else
			aDadCli[7]		:= SA1->A1_END
			aDadCli[8]		:= SA1->A1_BAIRRO
			aDadCli[9]		:= SA1->A1_MUN
			aDadCli[10]	:= SA1->A1_EST
			aDadCli[11]	:= SA1->A1_CEP
		Endif

		// Monta o saldo do título
		If lSaldo
			nSaldo	:= SE1->E1_SALDO
		Else
			nSaldo	:= SE1->E1_VALOR
		EndIf

		nSaldo	-= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nSaldo	-= Iif( SE1->E1_EMISSAO == SE1->E1_VENCTO,0,( SE1->E1_DECRESC+SE1->E1_DESCONT ) )
		nSaldo	+= Iif( SE1->E1_EMISSAO == SE1->E1_VENCTO,0,( __nValMult+SE1->E1_SDACRES ) )

		// Pega ou monta o nosso número
		If !Empty(SE1->E1_NUMBCO)
			cNumDoc	:= AllTrim(SE1->E1_NUMBCO)
		Else
			dbSelectArea("SEE")
			RecLock("SEE",.F.)

			nTamFax			:= Len(AllTrim(SEE->EE_FAXATU))
			cNumDoc			:= StrZero(Val(Alltrim(SEE->EE_FAXATU)),nTamFax)
			SEE->EE_FAXATU	:= Soma1(cNumDoc,nTamFax)

			MsUnLock()
		EndIf

		// Define a carteira de cobrança
		If Empty(SEE->EE_SUBCTA)
			cCarteira	:= "109"
		Else
			If SEE->EE_CODIGO == "237"//Tratamento feito para o Bradesco ja que a carteira usa 2 digitos.
			 	cCarteira		:= SEE->EE_SUBCTA
			Else
				cCarteira	:= SEE->EE_SUBCTA
			EndIf
		EndIf

		// Monta o Código de Barras e Linha Digitável
		aBarra	:= GetBarra(	aDadBco[1],;
								aDadBco[3],;
								aDadBco[4],;
								aDadBco[5],;
								aDadBco[6],;
								cCarteira,;
								cNumDoc,;
								nSaldo,;
								SE1->E1_VENCTO,;
								SEE->EE_CODEMP;
		)

		// Taxa de juros a ser utilizado no cálculo de juros de mora
		If !Empty(aDadBco[10])
			cMensag1	:= "Juros de " + AllTrim(Transform( aDadBco[10], "@E 999.99%" )) + " A.M."
		Endif

		// Taxa de multa a ser impressa no boleto
		//If !Empty(aDadBco[11])
		//	cMensag2	:= "Mora de " + AllTrim(Transform( aDadBco[11], "@E 999.99%" ))
		//EndIf

		// Mensagens Adicionais                            ³
		If aDadBco[01] == "341" .Or. aDadBco[01] == "237"
			cMensag3	:= "Título sujeito a protesto após o vencimento."
	    	cMensag5	:= "Referente a: "+cHist
		Else
		   If aDadBco[01] == "237"
				cMensag3	:= "Após o venc. pagar nas Agencias do Bradesco."
		    	cMensag5	:= "Referente a: "+cHist
			Else
		   		If aDadBco[01] == "422"
					cMensag3	:= "Após o venc. pagar nas Agencias do Safra."
		    		cMensag5	:= "Referente a: "+cHist
		  		EndIf
			EndIf
	  	EndIf

		// Número de dias para envio do título ao cartório
		If SE1->E1_PREFIXO <> "GNR" //Tratamento colocado para nao ter mensagem de protesto nos titulos de GNRE.
			If !Empty(aDadBco[12])
				cMensag4	:= "Protestar " + StrZero(aDadBco[12], 2) + " (" + AllTrim(Extenso(aDadBco[12],.T.)) + ") dias do vencimento."
			EndIf
		EndIf

		// Alimenta array com os dados do título
		aDadTit[1]		:= SE1->E1_PREFIXO			// [1] Prefixo do Título
		aDadTit[2]		:= SE1->E1_NUM				// [2] Número do Título
		aDadTit[3]		:= SE1->E1_PARCELA			// [3] Parcela do Título
		aDadTit[4]		:= SE1->E1_TIPO				// [4] Tipo do título
		aDadTit[5]		:= SE1->E1_EMISSAO			// [5] Data de Emissão do título
		aDadTit[6]		:= SE1->E1_VENCTO			// [6] Data de Vencimento do Título
		aDadTit[7]		:= SE1->E1_VENCREA			// [7] Data de Vencimento Real
		aDadTit[8]		:= SE1->E1_VALOR        	//nSaldo				// [8] Valor Líquido do Título
		aDadTit[9]		:= aBarra[4]				// [9] Código do Barras Formatado
		aDadTit[10]		:= cCarteira				// [10]Carteira de Cobrança
		aDadTit[11]		:= cMensag1					// [11]1a. Linha de Mensagem diversas
		aDadTit[12]		:= cMensag2					// [11]2a. Linha de Mensagem diversas
		aDadTit[13]		:= cMensag3					// [11]3a. Linha de Mensagem diversas
		aDadTit[14]		:= cMensag4					// [11]4a. Linha de Mensagem diversas
		aDadTit[15]		:= cMensag5					// [11]5a. Linha de Mensagem diversas
		aDadTit[16]		:= cMensag6					// [11]6a. Linha de Mensagem diversas
		__lMult 		:= ( aDadTit[5] == aDadTit[6] ) 	//Mesma Data para Vencimento / Emissao do Titulo (Calcula Valor de Multa)
		aDadTit[21]		:= (SE1->E1_SDDECRE+SE1->E1_DESCONT)		// [21]Desconto
		aDadTit[24]		:= nSaldo									// [24]Saldo
		aDadTit[23]		:= Iif(!__lMult,SE1->E1_SDACRES,0)			// [23]Acrescimo
		aDadTit[22]		:= Iif(!__lMult,(__nValMult),0)				// [22]Juros
		
		If !Empty(SE1->E1_XRENEG)
			aDadTit[6]		:= SE1->E1_XRENEG			// [6] Data de Vencimento do Título - (Renegociado)
		Endif
			
		If !Empty(SE1->E1_TITPED) .AND. Alltrim(SE1->E1_ORIGEM) $ "FINA040"
			cQry	:= " SELECT SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_EMISSAO,SE1.E1_XRENEG"
			cQry	+= " SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_NUMBCO,SE1.E1_PEDIDO,F2_DOC,F2_SERIE,SF2.F2_CARGA,SF2.F2_VEND1,' ' F2_VEND6,SD2.D2_PEDIDO "
			cQry	+= " FROM " + RetsqlName( "SE1" ) + " SE1 Left Join "+RetSqlName("SF2")+ " SF2 On SF2.F2_DOC = SE1.E1_NUM "
			cQry	+= " And SF2.F2_PREFIXO = SE1.E1_PREFIXO AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "'" + " AND SF2.D_E_L_E_T_ = ' '"
			cQry	+= " Left Join " +RetSqlName("SD2")+ " SD2 On SD2.D2_DOC = SF2.F2_DOC And SD2.D2_SERIE = SF2.F2_SERIE "
			cQry	+= " AND SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "'" +" AND SD2.D_E_L_E_T_ = ' '"
			cQry	+= " WHERE SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "'"
			cQry	+= " AND SE1.E1_NUM = '" + SE1->E1_NUM + "'"
			cQry	+= " AND SE1.E1_PREFIXO = '" + SE1->E1_PREFIXO + "'"
			cQry	+= " AND SE1.D_E_L_E_T_ = ' '"
		Else
		   cQry	:= " SELECT F2_DOC,F2_SERIE,SF2.F2_CARGA,SF2.F2_VEND1,' ' F2_VEND6,SD2.D2_PEDIDO"
			cQry	+= " FROM " + RetSqlName( "SE1" ) + " SE1,"
			cQry	+= " " + RetSqlName( "SF2" ) + " SF2,"
			cQry	+= " " + RetSqlName( "SD2" ) + " SD2"
			cQry	+= " WHERE SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "'"
			cQry	+= " AND SE1.E1_NUM = '" + SE1->E1_NUM + "'"
			cQry	+= " AND SE1.E1_PREFIXO = '" + SE1->E1_PREFIXO + "'"
			cQry	+= " AND SE1.D_E_L_E_T_ = ' '"
			cQry	+= " AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "'"
			cQry	+= " AND SF2.F2_DOC = SE1.E1_NUM"
			cQry	+= " AND SF2.F2_PREFIXO = SE1.E1_PREFIXO"
			cQry	+= " AND SF2.D_E_L_E_T_ = ' '"
			cQry	+= " AND SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "'"
			cQry	+= " AND SD2.D2_DOC = SF2.F2_DOC"
			cQry	+= " AND SD2.D2_SERIE = SF2.F2_SERIE"
			cQry	+= " AND SD2.D_E_L_E_T_ = ' '"
		EndIf

		// Se existir o alias temporário, fecha para não dar erro
		If Select("TRBDAD") > 0
			dbSelectArea("TRBDAD")
			dbCloseArea()
		EndIf

		// Executa a select no banco para pegar os registros a processar
		TCQUERY cQry NEW ALIAS "TRBDAD"
		dbSelectArea("TRBDAD")
		dbGoTop()

		While !Eof()
			If !Empty(SE1->E1_TITPED) .AND. Alltrim(SE1->E1_ORIGEM) $ "FINA040"
				cPedid	+= If( !Empty( cPedid ), "/", "" ) + TRBDAD->E1_PEDIDO
			Else
				cCarga	+= If( !Empty( cCarga ), "/", "" ) + TRBDAD->F2_CARGA
				cPedid	+= If( !Empty( cPedid ), "/", "" ) + TRBDAD->D2_PEDIDO
			EndIf

			If !Empty( TRBDAD->F2_VEND1 )
				cVende	+= If( !Empty( cVende ), "/", "" ) + TRBDAD->F2_VEND1
			EndIf

			If !Empty( TRBDAD->F2_VEND6 )
				cVende	+= If( !Empty( cVende ), "/", "" ) + TRBDAD->F2_VEND6
			EndIf

			cNotas	+= If( !Empty( cNotas ), "/", "" ) + TRBDAD->F2_DOC
			dbSkip()
		EndDo

        If Empty(cPedid)
            cPedid := SE1->E1_PEDIDO
        EndIf

		dbSelectArea( "TRBDAD" )
		dbCloseArea()
		dbSelectArea( "SE1" )

	 	aDadTit[17]	:= cCarga				// [17]Número das Cargas
		aDadTit[18]	:= cPedid				// [18]Número dos Pedidos
		aDadTit[19]	:= cNotas				// [19]Número das Notas
		aDadTit[20]	:= cVende				// [20]Código dos Vendedores
	EndIf

	RestArea(aAreaAtu)
Return(lRet)

//+----------------------------------------------------------------------------------------
//	Cálcula o código de barras, linha digitável e dígito do nosso número
//+----------------------------------------------------------------------------------------
Static Function GetBarra(cBanco,cAgencia,cDigAgencia,cConta,cDigConta,cCarteira,cNNum,nValor,dVencto,cContrato)
	Local cValorFinal		:= StrZero(Int(NoRound(nValor*100)),10)
	Local cDvCB			:= 0
	Local cDv				:= 0
	Local cNN				:= ""
	Local cNNForm			:= ""
	Local cRN				:= ""
	Local cCB				:= ""
	Local cS				:= ""
	Local cDvNN			:= ""
	Local cCpoLivre		:= Space(25)
	Local cFator			:= " "

	// Definicao do Fator de Vencimento
	If cBanco $ "341" .AND. SE1->E1_EMISSAO == SE1->E1_VENCTO
		cFator		:= Strzero(Val(StrZero(SE1->E1_EMISSAO - CToD("07/10/97"),4)) + 15,4)
	Else
		cFator		:= StrZero(dVencto - CToD("07/10/97"),4)
	EndIf

	// Definicao do NOSSO NÚMERO E CAMPO LIVRE
	// BRASIL
	If cBanco $ "001"
		// Composicao do Campo Livre (25 posições)
		//
		// SOMENTE PARA AS CARTEIRAS 16/18 (com convênios de 6 posições)
		//	 	20 a 25 - (06) - Número do Convênio
		// 		26 a 42 - (17) - Nosso Número
		// 		43 a 44 - (02) - Carteira de cobrança
		//
		// SOMENTE PARA AS CARTEIRAS 17/18
		// 		20 a 25 - (06) - Fixo 0
		// 		26 a 32 - (07) - Número do convênio
		// 		33 a 42 - (10) - Nosso Numero (sem o digito verificador)
		// 		43 a 44 - (02) - Carteira de cobrança
		//
		// Composicao do Nosso Número
		// 		01 a 06 - (06) - Número do Convênio (SEE->EE_CODEMP)
		// 		07 a 11 - (05) - Nosso Número (SEE->EE_FAXATU)
		// 		12 a 12 - (01) - Dígito do Nosso Número (Modulo 11)

		//³= Carteira 16/18 - Convênio com 6 posiçoes
		If Len(AllTrim(cContrato)) = 6
			Cs	:= AllTrim(cContrato) + cNNum + cCarteira

		// Carteira 17/18 - Convênio com mais de 6 posiçoes
		Else
			Cs	  := "000000" + AllTrim(cContrato) + cNNum + cCarteira
		EndIf

		cDvNN	  	:= U_TCCalcDV( cBanco, cS )		//Modulo11(cS)
		cNN		  	:= AllTrim(cContrato) + cNNum + cDvNN
		cNNForm	:= AllTrim(cContrato) + cNNum + "-" + cDvNN
		cCpoLivre 	:= cNNum + cAgencia + cConta + cCarteira

	// CAIXA ECONOMICA FEDERAL
	ElseIf 	cBanco $ "104"

		//Composicao do Campo Livre (25 posições)
		//		20 a 21 - (02) - Fixo 82
		//		22 a 29 - (08) - Nosso Número
		//		30 a 33 - (04) - CNPJ da agência cedente (Agência)
		//		34 a 36 - (03) - Operação Código (Carteira)
		//		37 a 44 - (08) - Código fornecido pela agência (Contrato)

		//Composicao do Nosso Número
		//		01 a 10 - (10) - Nosso Número (SEE->EE_FAXATU)
		//		11 a 11 - (01) - Dígito do Nosso Número (Modulo 11)
		cS		    	:= cNNum
		cDvNN	    	:= U_TCCalcDV( cBanco, cS )			//Mod11(cS)
		cNN				:= AllTrim(cCarteira) + cNNum + cDvNN
		cNNForm		:= cNNum + "-" + cDvnn
		cCpoLivre		:= cNNum + cAgencia + cCarteira + cContrato

	// BRADESCO
	ElseIf 	cBanco $ "237"
		// Composicao do Campo Livre (25 posições)
		// 		20 a 23 - (04) - Agencia cedente (sem o digito), completar com zeros a esquerda se necessario	                        ³
		// 		24 a 25 - (02) - Carteira
		// 		26 a 36 - (11) - Nosso Numero (sem o digito verificador)
		// 		37 a 43 - (07) - Conta do cedente, sem o digito verificador, complete com zeros a esquerda, se necessario                 ³
		// 		44 a 44 - (01) - Fixo "0"

		// Composicao do Nosso Número
		// 		01 a 02 - (02) - Número da Carteira (SEE->EE_SUBCTA) 06 para Sem Registro 19 para Com Registro
		// 		03 a 13 - (11) - Nosso Número (SEE->EE_FAXATU)
		// 		04 a 14 - (01) - Dígito do Nosso Número (Modulo 11)
		cS		    	:= AllTrim(cCarteira) + cNNum
		cDvNN	    	:= U_TCCalcDV( cBanco, cS )			//Mod11237(cS)
	    cNN			:= AllTrim(cCarteira) + cNNum + cDvNN
		cNNForm		:= AllTrim(cCarteira) + "/"+ Substr(cNNum,1,11) + "-" + cDvnn
		cCpoLivre		:= StrZero(Val(AllTrim(cAgencia)),4)+StrZero(Val(AllTrim(cCarteira)),2)+cNNum+StrZero(Val(AllTrim(cConta)),7)+"0"

	// SAFRA                                                                                                         ³
	ElseIf 	cBanco $ "422"
		// Composicao do Campo Livre (25 posições)
		// 		06 a 09 - (04) - Agencia cedente (sem o digito), completar com zeros  a esquerda se necessario	                        ³
		// 		11 a 20 - (10) - Conta do cedente, com o digito verificador, complete com zeros a esquerda, se necessario                 ³

		// Composicao do Nosso Número
		// 		01 a 02 - (02) - Número da Carteira (SEE->EE_SUBCTA) 06 para Sem Registro 19 para Com Registro           ³
		// 		03 a 13 - (11) - Nosso Número (SEE->EE_FAXATU)
		// 		04 a 14 - (01) - Dígito do Nosso Número (Modulo 11)
	   	cS		   	:= cNNum
		cDvNN	 	:= U_TCCalcDV( cBanco, cS )
		cNN			:= cNNum + cDvNN
		cNNForm	:=  cNNum+ "-" + cDvnn
	   	cCpoLivre	:= "7"+StrZero(Val(AllTrim(cAgencia)),5)+StrZero(Val(AllTrim(cConta)),8)+Alltrim(cDigConta)+cNNum+cDvNN+"2"

	// ITAÚ
	ElseIf cBanco $ "341"
		// Composicao do Campo Livre (25 posições)
		// 		20 a 22 - (03) - Carteira
		// 		23 a 30 - (08) - Nosso Número (sem o dígito verificador)
		// 		31 a 31 - (01) - Digito verificador
		// 		32 a 35 - (04) - Agência
		// 		36 a 40 - (05) - Conta (sem o dígito verificador
		// 		41 a 41 - (01) - Dígito verificador da conta
		// 		42 a 44 - (03) - Fixo "000"

		//Composicao do Nosso Número Se carteira for 126/131/146/150/168
		// 		01 a 03 - (03) - Carteira
		// 		04 a 11 - (08) - Nosso Número (EE_FAXATU)

		// Demais carteiras
		// 		01 a 04 - (04) - Agência sem dígito verificador
		// 		05 a 09 - (05) - Conta Corrente sem dígito verificador
		// 		10 a 12 - (03) - Carteira
		// 		13 a 20 - (08) - Nosso Número (EE_FAXATU)
		If cCarteira $ "126/131/146/150/168"
			cS			:=  AllTrim(cCarteira) + cNNum
		Else
			cS			:=  AllTrim(cAgencia) + AllTrim(cConta) + AllTrim(cCarteira) + cNNum
		EndIf

		cDvNN		:= U_TCCalcDV( cBanco, cS )			//Modulo10(cS)
		cNN			:= AllTrim(cCarteira) + cNNum + cDvNN
		cNNForm	:= AllTrim(cCarteira) + "/"+ cNNum + "-" + cDvNN
		cCpoLivre	:= StrZero(Val(AllTrim(cCarteira)),3)+cNNum+cDvNN+StrZero(Val(Alltrim(cAgencia)),4)+StrZero(Val(AllTrim(cConta)),5)+Alltrim(cDigConta)+"000"

	// CITIBANK
	ElseIf cBanco $ "745"
		// Composicao do Campo Livre (25 posições)
		// 		20 a 20 - (01) - Código do Produto (3=Cobrança com/sem registro
		//                  4=Cobrança de seguro sem registro)
		//		21 a 23 - (03) - Portifólio 3 últimos dígitos do campo código Empresa
		//                  Segundo Douglas (Citigroup) enviar neste campo o
		//                  número da carteira.
		//                  O número do contrato é chamado de Conta Cosmos e é
		//                  formado por 10 posições com A.BBBBBB.CC.D, onde
		//                  A      = Não utilizado
		//                  BBBBBB = Base
		//                  CC     = Sequencia
		//                  D      = Dígito
		// 		24 a 29 - (06) - Base (Contrato)
		// 		30 a 31 - (02) - Sequencia (Contrato)
		// 		32 a 32 - (01) - Dígito da conta Cosmos (Contrato)
		// 		33 a 44 - (12) - Nosso Número com dígito verificador

		// Composicao do Nosso Número
		// 		01 a 11 - (11) - Nosso Número (EE_FAXATU)
		cS			:= cNNum
		cDvNN		:= U_TCCalcDV( cBanco, cS )			//modulo11(cS)
		cNN			:= cNNum + cDvNN
		cNNForm	:= cNNum + "-" + cDvNN
		cCpoLivre	:= "3" + StrZero(Val(cCarteira),3) + SubStr(AllTrim(cContrato), 2, 9) + cNN
	EndIf

	// Definicao do DÍGITO CODIGO DE BARRAS
	cS		:= cBanco+"9"+cFator+cValorFinal+cCpoLivre
	cDvCB	:= Modulo11(cS)
	cCB		:= cBanco+"9"+cDVCB+cFator+cValorFinal+cCpoLivre

	//                  Definicao da LINHA DIGITÁVEL
	// Campo 1       Campo 2        Campo 3        Campo 4   Campo 5
	// AAABC.CCCCX   CCCCC.CCCCCY   CCCCC.CCCCCZ   W	      UUUUVVVVVVVVVV
	// AAA                       = Código do Banco na Câmara de Compensação
	// B                         = Código da Moeda, sempre 9
	// CCCCCCCCCCCCCCCCCCCCCCCCC = Campo Livre
	// X                         = Digito Verificador do Campo 1
	// Y                         = Digito Verificador do Campo 2
	// Z                         = Digito Verificador do Campo 3
	// W                         = Digito Verificador do Codigo de Barras
	// UUUU                      = Fator de Vencimento
	// VVVVVVVVVV                = Valor do Título

	// CALCULO DO DÍGITO VERIFICADOR DO CAMPO 1
	cS		:= cBanco + "9" +Substr(cCpoLivre,1,5)
	cDv		:= modulo10(cS)
	cRN1	:= SubStr(cS, 1, 5) + "." + SubStr(cS, 6, 4) + cDv

	// CALCULO DO DÍGITO VERIFICADOR DO CAMPO 2
	cS		:= Substr(cCpoLivre,6,10)
	cDv		:= modulo10(cS)
	cRN2	:= cS + cDv
	cRN2	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv

	// CALCULO DO DÍGITO VERIFICADOR DO CAMPO 3
	cS		:= Substr(cCpoLivre,16,10)
	cDv		:= modulo10(cS)
	cRN3	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv

	// CALCULO DO CAMPO 4
	cRN4	:= cDvCB

	// CALCULO DO CAMPO 5
	cRN5	:= cFator + cValorFinal
	cRN		:= cRN1 + " " + cRN2 + ' '+ cRN3 + ' ' + cRN4 + ' ' + cRN5
Return({cCB,cRN,cNNum,cNNForm,cDvNN})

//+----------------------------------------------------------------------------------------
//	Efetua o cálculo do dígito verificador do nosso número
//+----------------------------------------------------------------------------------------
User Function TCCalcDV( cBanco, cNNum )
	cRetorno	:= ""

	If cBanco $ "001#745#104"
		cRetorno	:= Modulo11( cNNum )
	ElseIf cBanco $ "237#"
		cRetorno	:= Mod11237( cNNum )
	ElseIf cBanco $ "341"
		cRetorno	:= Modulo10( cNNum )
	Elseif Alltrim(cBanco)	 $ "422"
		cRetorno	:= Mod11422(cNnum)
	EndIf
Return( cRetorno )

//+----------------------------------------------------------------------------------------
//	Efetua o cálculo do dígito veririficador com base 10
//+----------------------------------------------------------------------------------------
Static Function Modulo10(cData)
	Local L	:= Len(cData)
	Local D	:= 0
	Local P 	:= 0
	Local B	:= .T.

	While L > 0
		P := Val(SubStr(cData, L, 1))

		If (B)
			P := P * 2

			If P > 9
				P := P - 9
			EndIf
		EndIf

		D := D + P
		L := L - 1
		B := !B
	EndDo

	D := 10 - (Mod(D,10))

	If D = 10
		D := 0
	EndIf
Return(AllTrim(Str(D,1)))

//+----------------------------------------------------------------------------------------
//	Efetua o cálculo do dígito veririficador com base 11
//+----------------------------------------------------------------------------------------
Static Function Modulo11(cData)
	Local L	:= Len(cData)
	Local D	:= 0
	Local P	:= 1

	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)

		If P = 9
			P := 1
		EndIf

		L := L - 1
	EndDo

	D := 11 - (mod(D,11))

	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	EndIf
Return(AllTrim(Str(D,1)))

//+----------------------------------------------------------------------------------------
//	Efetua o cálculo do dígito veririficador com base 7 Bradesco
//+----------------------------------------------------------------------------------------
Static Function Mod11237(cData)
	Local nResult		:= 0
	Local nSoma		:= 0
	Local i			:= 0
	Local nTam			:= 13
	Local nDc			:= 0
	Local nAlg			:= 2
	Local nCalNum		:= space(13)

	nCalNum:= cData

	For i  := nTam To 1 Step -1
		nSoma   	:= Val(Substr(nCalNum,i,1))*nAlg
		nResult 	:= nResult + nSoma
		nAlg    	:= nAlg + 1

		If nAlg > 7
			nAlg 	:= 2
		Endif

	Next i

	nDC  := MOD(nResult,11)
	cDig := 11 - nDc

	IF nDC == 1
		cDig := "P"
	ElseIf nDC == 0
		cDig := 0
		cDig := STR(cDig,1)
	Else
		cDig := STR(cDig,1)
	EndIF */
Return(Alltrim(cDig))

//+----------------------------------------------------------------------------------------
//	Efetua a impressão do boleto bancário
//+----------------------------------------------------------------------------------------
User Function TCImpBol(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)
	Local oFont8
	Local oFont9
	Local oFont10
	Local oFont11

	Local oFont11c
	Local oFont14
	Local oFont14n
	Local oFont15
	Local oFont15n
	Local oFont16n
	Local oFont20
	Local oFont19n
	Local oFont21
	Local oFont24
	Local nLin				:= 0
	Local nLoop			:= 0
	Local cBmp				:= ""
	Local cStartPath		:= AllTrim(GetSrvProfString("StartPath",""))
	Local cHist			:= SE1->E1_HIST
	
	Local _cSacado		:= ''
	Private __nMult       	:= 0

	// Monta informação exibida do Sacado
	If Len(aDaDCli) > 2
		_cSacado	:= '(' + AllTrim(aDaDCli[1]) + '-' + AllTrim(aDadCli[2]) + ') ' + AllTrim(aDadCli[3])
	EndIf

	// Verifica se existe a barra final no StartPath
	If Right(cStartPath,1) <> "\"
		cStartPath+= "\"
	EndIf

	// Monta string com o caminho do logotipo do banco
	// O Tamanho da figura tem que ser 381 x 68 pixel
	// para que a impressãi sai correta
	cBmp	:= cStartPath+aDadBco[9]

	// Define as fontes a serem utilizadas
	oFont8		:= TFont():New("Arial",			9,08,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9		:= TFont():New("Arial",			9,09,.T.,.F.,5,.T.,5,.T.,.F.)

//	oFont10		:= TFont():New("Arial",			9,09,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10		:= TFont():New("Arial",			9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11		:= TFont():New("Arial",			9,11,.T.,.T.,5,.T.,5,.T.,.F.)

	oFont11c	:= TFont():New("Courier New",	9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14		:= TFont():New("Arial",			9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n	:= TFont():New("Arial",			9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15		:= TFont():New("Arial",			9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n	:= TFont():New("Arial",			9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont16n	:= TFont():New("Arial",			9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont20		:= TFont():New("Arial",			9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont19n	:= TFont():New("Arial",			9,19,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont21		:= TFont():New("Arial",			9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24		:= TFont():New("Arial",			9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	// Inicia uma nova página
	oPrint:StartPage()

	nAjuste := 30

	// Define o Primeiro Bloco - Recibo de Entrega
	oPrint:Line(nLin+0150-nAjuste,0500,nLin+0070-nAjuste,0500)															// Quadro
	oPrint:Line(nLin+0150-nAjuste,0710,nLin+0070-nAjuste,0710)												   			// Quadro

	If !Empty(aDadBco[9])
		oPrint:SayBitMap(nLin+0084,0100,cBmp,350,060)													// Logotipo do Banco
	Else
		oPrint:Say	(nLin+0084,0100,	aDadBco[8],											oFont19n)	// Nome do Banco
	EndIf

	oPrint:Say(nLin+0085,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// Número do Banco + Dígito
	oPrint:Say(nLin+0042,1940,	"Comprovante de Entrega",								oFont10)	// Texto Fixo

//	oPrint:Say(nLin+0085,0755,	aBarra[2],								oFont19n)	// Linha Digitavel do Codigo de Barras
	oPrint:Say(nLin+0090,0755,	aBarra[2],								oFont19n)	// Linha Digitavel do Codigo de Barras

	oPrint:Line(nLin+0150-nAjuste,0100,nLin+0150-nAjuste,2300)															// Quadro

	oPrint:Say(nLin+0150,0100,	"Beneficiário",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+0200,0100,	aDadEmp[1],												oFont10)	// Nome da Empresa

	oPrint:Say(nLin+0150,1060,	"Agência/Código Beneficiário",								oFont9)		// Texto Fixo

	If aDadBco[01] == "341"
		oPrint:Say(nLin+0200,1110,	Alltrim(aDadBco[3]) +"-"+ Alltrim(aDadBco[4])+"/"+Alltrim(aDadBco[5])+"-"+Alltrim(aDadBco[6]),	oFont10)	// Agencia + Cód.Cedente
	Else
		oPrint:Say(nLin+0200,1110,	AllTrim(aDadBco[15]),									oFont10)	// Agencia + Cód.Cedente
	EndIf

	oPrint:Say(nLin+0150,1510,	"Nro.Documento",										oFont9)		// Texto fixo
	oPrint:Say(nLin+0200,1560,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

	oPrint:Say(nLin+0250,0100,	"Pagador",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+0300,0100,	SubStr(_cSacado,1,IIf( Len(_cSacado) > 40,40,Len(_cSacado) )),		oFont10)	// Nome do Cliente

	oPrint:Say(nLin+0250,1060,	"Vencimento",											oFont9)		// Texto Fixo

	If aDadBco[01] == "341" .AND. DToC(aDadTit[5]) $ DToC(aDadTit[6])
		oPrint:Say(nLin+0300,1110,	"A VISTA",										oFont10)	// Data de Vencimento
	Else
		oPrint:Say(nLin+0300,1110,	DToC(aDadTit[6]),										oFont10)	// Data de Vencimento
	Endif

	oPrint:Say(nLin+0250,1510,	"Valor do Documento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+0300,1560,	Transform(aDadTit[8],"@E 9999,999,999.99"),				oFont10)	// Valor do Título

	oPrint:Say(nLin+0400,0100,	"Recebi(emos) o bloqueto/título",						oFont10)	// Texto Fixo
	oPrint:Say(nLin+0450,0100,	"com as características acima.",						oFont10)	// Texto Fixo
	oPrint:Say(nLin+0350,1060,	"Data",													oFont9)		// Texto Fixo
	oPrint:Say(nLin+0350,1410,	"Assinatura",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+0450,1060,	"Data",													oFont9)		// Texto Fixo
	oPrint:Say(nLin+0450,1410,	"Entregador",											oFont9)		// Texto Fixo

	oPrint:Line(nLin+0250-nAjuste,0100,nLin+0250-nAjuste,1900 )														// Quadro
	oPrint:Line(nLin+0350-nAjuste,0100,nLin+0350-nAjuste,1900 )														// Quadro
	oPrint:Line(nLin+0450-nAjuste,1050,nLin+0450-nAjuste,1900 )														// Quadro
	oPrint:Line(nLin+0550-nAjuste,0100,nLin+0550-nAjuste,2300 )														// Quadro

	oPrint:Line(nLin+0550-nAjuste,1050,nLin+0150-nAjuste,1050 )														// Quadro
	oPrint:Line(nLin+0550-nAjuste,1400,nLin+0350-nAjuste,1400 )														// Quadro
	oPrint:Line(nLin+0350-nAjuste,1500,nLin+0150-nAjuste,1500 )														// Quadro
	oPrint:Line(nLin+0550-nAjuste,1900,nLin+0150-nAjuste,1900 )														// Quadro

	oPrint:Say(nLin+0165,1910,	"(  ) Mudou-se",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+0205,1910,	"(  ) Ausente",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+0245,1910,	"(  ) Não existe nº indicado",							oFont9)		// Texto Fixo
	oPrint:Say(nLin+0285,1910,	"(  ) Recusado",			 							oFont9)		// Texto Fixo
	oPrint:Say(nLin+0325,1910,	"(  ) Não procurado",		 							oFont9)		// Texto Fixo
	oPrint:Say(nLin+0365,1910,	"(  ) Endereço insuficiente",							oFont9)		// Texto Fixo
	oPrint:Say(nLin+0405,1910,	"(  ) Desconhecido",		 							oFont9)		// Texto Fixo
	oPrint:Say(nLin+0445,1910,	"(  ) Falecido",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+0485,1910,	"(  ) Outros(anotar no verso)",							oFont9)		// Texto Fixo

	oPrint:Say(nLin+0570,0100,   "Pedido: " + Padr( aDadTit[18], 30 ),		 			oFont10)	// Número dos Pedidos
	oPrint:Say(nLin+0610,0100,   "Referente a : " + cHist,					oFont10)	// Número dos Vendedores

	// Pontilhado separador
	nLin+= 0200

	For nLoop := 100 to 2300 Step 50
		oPrint:Line(nLin+0580-nAjuste, nLoop,nLin+0580-nAjuste, nLoop+30)												// Linha pontilhada
	Next nI

	// Define o Segundo Bloco - Recibo do Sacado
	oPrint:Line (nLin+0710-nAjuste,0100,nLin+0710-nAjuste,2300)														// Quadro
	oPrint:Line (nLin+0710-nAjuste,0500,nLin+0630-nAjuste,0500)														// Quadro
	oPrint:Line (nLin+0710-nAjuste,0710,nLin+0630-nAjuste,0710)														// Quadro

	If !Empty(aDadBco[9])
		oPrint:SayBitMap(nLin+0644,0100,cBmp,350,060)													// Logotipo do Banco
	Else
		oPrint:Say(nLin+0644,0100,	aDadBco[8],											oFont19n)	// Nome do Banco
	EndIf

	oPrint:Say(nLin+0650,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// Numero do Banco + Dígito
	oPrint:Say(nLin+0607,1940,	"Recibo do Sacado",										oFont10)	// Texto Fixo
	oPrint:Say(nLin+0655,0755,	aBarra[2],												oFont19n)	// Linha Digitavel do Codigo de Barras

	oPrint:Line(nLin+0810-nAjuste,0100,nLin+0810-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+0910-nAjuste,0100,nLin+0910-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+0980-nAjuste,0100,nLin+0980-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1050-nAjuste,0100,nLin+1050-nAjuste,2300)														// Quadro

	oPrint:Line(nLin+0910-nAjuste,0500,nLin+1050-nAjuste,0500)														// Quadro
	oPrint:Line(nLin+0980-nAjuste,0750,nLin+1050-nAjuste,0750)														// Quadro
	oPrint:Line(nLin+0910-nAjuste,1000,nLin+1050-nAjuste,1000)														// Quadro
	oPrint:Line(nLin+0910-nAjuste,1300,nLin+0980-nAjuste,1300)														// Quadro
	oPrint:Line(nLin+0910-nAjuste,1480,nLin+1050-nAjuste,1480)														// Quadro

	oPrint:Say(nLin+0710,0100 ,	"Local de Pagamento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+0725,0400 ,	"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+Upper(aDadBco[8]),oFont10)	// 1a. Linha de Local Pagamento
	oPrint:Say(nLin+0765,0400 ,	"APÓS O VENCIMENTO, SOMENTE NO "+Upper(aDadBco[8]),oFont10)	// 2a. Linha de Local Pagamento
	oPrint:Say(nLin+0710,1810,	"Vencimento",											oFont9)		// Texto Fixo

	If aDadBco[01] == "341" .AND. DToC(aDadTit[5]) $ DToC(aDadTit[6])
		oPrint:Say  (nLin+0750,2000,	"A VISTA",										oFont11c)	// Data de Vencimento
	Else
		oPrint:Say(nLin+0750,2000,	StrZero(Day(aDadTit[6]),2) +"/"+ StrZero(Month(aDadTit[6]),2) +"/"+ StrZero(Year(aDadTit[6]),4),					 		oFont11c)	// Vencimento
	Endif

	oPrint:Say(nLin+0810,0100,	"Beneficiário",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+0850,0100,	AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99"), oFont10)	// Nome + CNPJ
	oPrint:Say(nLin+0810,1810,	"Agência/Código Beneficiário",								oFont9)		// Texto Fixo

	If aDadBco[01] == "341"
		oPrint:Say(nLin+0850,1900,	Alltrim(aDadBco[3]) +"-"+ Alltrim(aDadBco[4])+"/"+Alltrim(aDadBco[5])+"-"+Alltrim(aDadBco[6]),	oFont11c)	// Agencia + Cód.Cedente + Dígito
	Else
		oPrint:Say(nLin+0850,1900,	AllTrim(aDadBco[15]),									oFont11c)	// Agencia + Cód.Cedente + Dígito
	EndIf

	oPrint:Say(nLin+0910,0100,	"Data do Documento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+0940,0150,	StrZero(Day(aDadTit[5]),2)+"/"+ StrZero(Month(aDadTit[5]),2)+"/"+ Right(Str(Year(aDadTit[5])),4),						oFont10)	// Data do Documento

	oPrint:Say(nLin+0910,0505,	"Nro.Documento",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+0940,0605,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

	oPrint:Say(nLin+0910,1005,	"Espécie Doc.",											oFont9)		// Texto Fixo

	If aDadBco[01] $ "422"
	   oPrint:Say(nLin+0940,1055,	"DM",											oFont10)	// Tipo do Titulo
	Else
	   oPrint:Say(nLin+0940,1055,	aDadBco[14],											oFont10)	// Tipo do Titulo
	Endif

	oPrint:Say(nLin+0910,1305,	"Aceite",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+0940,1400,	"N",													oFont10)	// Texto Fixo

	oPrint:Say(nLin+0910,1485,	"Data do Processamento",								oFont9)		// Texto Fixo
	oPrint:Say(nLin+0940,1550,	StrZero(Day(dDataBase),2)+"/"+ StrZero(Month(dDataBase),2)+"/"+ StrZero(Year(dDataBase),4),								oFont10)	// Data impressao

	oPrint:Say(nLin+0910,1810,	"Nosso Número",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+0940,1900,	aBarra[4],												oFont11c)	// Nosso Número

	oPrint:Say(nLin+0980,0100,	"Uso do Banco",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+1010,0150,	aDadBco[13],											oFont10)	// Texto Fixo

	oPrint:Say(nLin+0980,0505,	"Carteira",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+1010,0555,	aDadTit[10],											oFont10)	// Carteira

	oPrint:Say(nLin+0980,0755,	"Espécie",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+1010,0805,	"R$",													oFont10)	// Texto Fixo

	oPrint:Say(nLin+0980,1005,	"Quantidade",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+0980,1485,	"Valor",												oFont9)		// Texto Fixo

	oPrint:Say(nLin+0980,1810,	"Valor do Documento",								oFont9)		// Texto Fixo
	oPrint:Say(nLin+1010,1900,	Transform(aDadTit[8],"@E 9999,999,999.99"),		oFont11c)	// Valor do Título

	oPrint:Say(nLin+1050,0100,	"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont9)		// Texto Fixo

	oPrint:Say(nLin+1100,0100,	"Após Vencimento: ",									oFont10)	// 1a Linha Instrução
	oPrint:Say(nLin+1100,0405,	aDadTit[11],											oFont10)	// 1a Linha Instrução
	oPrint:Say(nLin+1150,0405,	aDadTit[12],											oFont10)	// 2a. Linha Instrução

	oPrint:Say(nLin+1200,0100,	aDadTit[13],											oFont10)	// 3a. Linha Instrução
	oPrint:Say(nLin+1250,0100,	aDadTit[14],											oFont10)	// 4a. Linha Instrução
	oPrint:Say(nLin+1300,0100,	aDadTit[15],											oFont10)	// 5a. Linha Instrução
	oPrint:Say(nLin+1350,0100,	aDadTit[16],											oFont10)	// 6a. Linha Instrução

	oPrint:Say(nLin+1050,1810,	"(-)Desconto/Abatimento",								oFont9)		// Texto Fixo
	oPrint:Say(nLin+1074,1900,	Transform(aDadTit[21],"@E 9999,999,999.99"),		    oFont11c)	// Desconto
	oPrint:Say(nLin+1120,1810,	"(-)Outras Deduções",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+1190,1810,	"(+)Mora/Multa",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+1218,1900,	Transform(aDadTit[22],"@E 9999,999,999.99"),		    oFont11c)	// Juros
	oPrint:Say(nLin+1260,1810,	"(+)Outros Acréscimos",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+1285,1900,	Transform(aDadTit[23],"@E 9999,999,999.99"),		    oFont11c)	// Acrescimo
	oPrint:Say(nLin+1330,1810,	"(=)Valor Cobrado",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+1354,1900,	Transform(aDadTit[24],"@E 9999,999,999.99"),		    oFont11c)	// Valor Cobrado

	oPrint:Say(nLin+1350,0100,   "Pedido: " + Padr( aDadTit[18], 30 ),		 			oFont10)	// Número dos Pedidos

	oPrint:Say(nLin+1400,0100,	"Pagador",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+1430,0200,	SubStr(_cSacado,1,IIf( Len(_cSacado) > 80,80,Len(_cSacado) )),		oFont10)	// Código + Nome do Cliente

	If aDadCli[6] = "J"
		oPrint:Say(nLin+1430,1850,"CNPJ: "+Transform(aDadCli[4],"@R 99.999.999/9999-99"),oFont10)	// CGC
	Else
		oPrint:Say(nLin+1430,1850,"CPF: "+Transform(aDadCli[4],"@R 999.999.999-99"),oFont10)	// CPF
	EndIf

	oPrint:Say(nLin+1483,0200,	AllTrim(aDadCli[7])+" "+AllTrim(aDadCli[8]),			oFont10)	// Endereço + Bairro
	oPrint:Say(nLin+1536,0200,	Transform(aDadCli[11],"@R 99999-999")+" - "+ AllTrim(aDadCli[9])+" - "+ AllTrim(aDadCli[10]),							oFont10)	// CEP + Cidade + Estado
	oPrint:Say(nLin+1589,1850,	aBarra[4],												oFont10)	// Nosso Número

	If aDadBco[1] == "422"
	   oPrint:Say(nLin+1605,0100,	"Pagador/Avalista: " + SPACE(30) + " - CNPJ: " + SPACE(14),oFont9)//Sacador
	Else
	   oPrint:Say(nLin+1605,0100,	"Pagador/Avalista: " + SM0->M0_NOMECOM + " - CNPJ: " + SM0->M0_CGC, oFont9) //Sacador
	EndIf

	oPrint:Say(nLin+1645,1500,	"Autenticação Mecânica",								oFont9)		// Texto Fixo

	oPrint:Line(nLin+0710-nAjuste,1800,nLin+1400-nAjuste,1800)														// Quadro
	oPrint:Line(nLin+1120-nAjuste,1800,nLin+1120-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1190-nAjuste,1800,nLin+1190-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1260-nAjuste,1800,nLin+1260-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1330-nAjuste,1800,nLin+1330-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1400-nAjuste,0100,nLin+1400-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+1640-nAjuste,0100,nLin+1640-nAjuste,2300)														// Quadro

	// Pontilhado separador
	nLin	:= 100

	For nLoop := 100 To 2300 Step 50
		oPrint:Line(nLin+1880-nAjuste, nLoop, nLin+1880-nAjuste, nLoop+30)												// Linha Pontilhada
	Next nI

	// Define o Terceiro Bloco - Ficha de Compensação
	oPrint:Line(nLin+2000-nAjuste,0100,nLin+2000-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2000-nAjuste,0500,nLin+1920-nAjuste,0500)														// Quadro
	oPrint:Line(nLin+2000-nAjuste,0710,nLin+1920-nAjuste,0710)														// Quadro

	If !Empty(aDadBco[9])
		oPrint:SayBitMap(nLin+1934,0100,cBmp,350,060)													// Logotipo do Banco
	Else
		oPrint:Say(nLin+1934,100,	aDadBco[8],												oFont19n)	// Nome do Banco
	EndIf

	oPrint:Say(nLin+1934,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// Numero do Banco + Dígito
	oPrint:Say(nLin+1939,0755,	aBarra[2],												oFont19n)	// Linha Digitavel do Codigo de Barras

	oPrint:Line(nLin+2100-nAjuste,100,nLin+2100-nAjuste,2300 )														// Quadro
	oPrint:Line(nLin+2200-nAjuste,100,nLin+2200-nAjuste,2300 )														// Quadro
	oPrint:Line(nLin+2270-nAjuste,100,nLin+2270-nAjuste,2300 )														// Quadro
	oPrint:Line(nLin+2340-nAjuste,100,nLin+2340-nAjuste,2300 )														// Quadro

	oPrint:Line(nLin+2200-nAjuste,0500,nLin+2340-nAjuste,0500)														// Quadro
	oPrint:Line(nLin+2270-nAjuste,0750,nLin+2340-nAjuste,0750)														// Quadro
	oPrint:Line(nLin+2200-nAjuste,1000,nLin+2340-nAjuste,1000)														// Quadro
	oPrint:Line(nLin+2200-nAjuste,1300,nLin+2270-nAjuste,1300)														// Quadro
	oPrint:Line(nLin+2200-nAjuste,1480,nLin+2340-nAjuste,1480)														// Quadro

	oPrint:Say(nLin+2000,0100,	"Local de Pagamento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+2015,0400,	"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+aDadBco[8],	oFont10)	// Texto Fixo
	oPrint:Say(nLin+2055,0400 ,	"APÓS O VENCIMENTO, SOMENTE NO "+aDadBco[8],			oFont10)	// Texto Fixo

	oPrint:Say(nLin+2000,1810,	"Vencimento",											oFont9)		// Texto Fixo

	If aDadBco[01] == "341" .AND. DToC(aDadTit[5]) $ DToC(aDadTit[6])
		oPrint:Say(nLin+2040,1900,	"A VISTA",										oFont11c)	// Data de Vencimento
	Else
		oPrint:Say(nLin+2040,1900,	StrZero(Day(aDadTit[6]),2)+"/"+ StrZero(Month(aDadTit[6]),2)+"/"+ StrZero(Year(aDadTit[6]),4),							oFont11c)	// Vencimento
	Endif

	oPrint:Say(nLin+2100,0100,	"Beneficiário",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+2140,0100,	AllTrim(aDadEmp[1])+" - "+Transform(aDadEmp[9],"@R 99.999.999/9999-99"), oFont10)	// Nome + CNPJ

	oPrint:Say(nLin+2100,1810,	"Agência/Código Beneficiário",								oFont9)		// Texto Fixo

	If aDadBco[01] == "341"
		oPrint:Say(nLin+2140,1900,	Alltrim(aDadBco[3]) +"-"+ Alltrim(aDadBco[4])+"/"+Alltrim(aDadBco[5])+"-"+Alltrim(aDadBco[6]),	oFont11c)	// Agencia + Cód.Cedente + Dígito
	Else
		oPrint:Say(nLin+2140,1900,	AllTrim(aDadBco[15]),									oFont11c)	// Agencia + Cód.Cedente + Dígito
	EndIf

	oPrint:Say(nLin+2200,0100,	"Data do Documento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+2230,0100, 	StrZero(Day(aDadTit[5]),2)+"/"+ StrZero(Month(aDadTit[5]),2)+"/"+ StrZero(Year(aDadTit[5]),4),		 					oFont10)	// Vencimento

	oPrint:Say(nLin+2200,0505,	"Nro.Documento",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+2230,0605,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

	oPrint:Say(nLin+2200,1005,	"Espécie Doc.",						   					oFont9)		// Texto Fixo

	If aDadBco[01] == "422"
	   oPrint:Say(nLin+2230,1050,	"DM",											oFont10)	//Tipo do Titulo
	Else
	   oPrint:Say(nLin+2230,1050,	aDadBco[14],											oFont10)	//Tipo do Titulo
	Endif

	oPrint:Say(nLin+2200,1305,	"Aceite",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+2230,1400,	"N",													oFont10)	// Texto Fixo

	oPrint:Say(nLin+2200,1485,	"Data do Processamento",								oFont9)		// Texto Fixo
	oPrint:Say(nLin+2230,1550,	StrZero(Day(dDataBase),2)+"/"+ StrZero(Month(dDataBase),2)+"/"+ StrZero(Year(dDataBase),4),								oFont10)	// Data impressao

	oPrint:Say(nLin+2200,1810,	"Nosso Número",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+2230,1900,	aBarra[4],												oFont11c)	// Nosso Número

	oPrint:Say(nLin+2270,0100,	"Uso do Banco",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+2300,0150,	aDadBco[13],											oFont10)	// Texto Fixo

	oPrint:Say(nLin+2270,0505,	"Carteira",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+2300,0555,	aDadTit[10],											oFont10)

	oPrint:Say(nLin+2270,0755,	"Espécie",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+2300,0805,	"R$",													oFont10)	// Texto Fixo

	oPrint:Say(nLin+2270,1005,	"Quantidade",											oFont9)		// Texto Fixo
	oPrint:Say(nLin+2270,1485,	"Valor",												oFont9)		// Texto Fixo

	oPrint:Say(nLin+2270,1810,	"Valor do Documento",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+2300,1900,	Transform(aDadTit[8], "@E 9999,999,999.99"),			oFont11c)	// Valor do Documento

	oPrint:Say(nLin+2340,0100,	"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont9)		// Texto Fixo
	oPrint:Say(nLin+2400,0100,	'Após vencimento:',									oFont10)	// 1a Linha Instrução
	oPrint:Say(nLin+2400,0405,	aDadTit[11],											oFont10)	// 1a Linha Instrução
	oPrint:Say(nLin+2450,0405,	aDadTit[12],											oFont10)	// 2a. Linha Instrução

	oPrint:Say(nLin+2500,0100,	aDadTit[13],											oFont10)	// 3a. Linha Instrução
	oPrint:Say(nLin+2550,0100,	aDadTit[14],											oFont10)	// 4a. Linha Instrução
	oPrint:Say(nLin+2600,0100,	aDadTit[15],											oFont10)	// 5a. Linha Instrução
	oPrint:Say(nLin+2650,0100,	aDadTit[16],											oFont10)	// 6a. Linha Instrução

	oPrint:Say(nLin+2340,1810,	"(-)Desconto/Abatimento",								oFont9)		// Texto Fixo
	oPrint:Say(nLin+2365,1900,	Transform(aDadTit[21],"@E 9999,999,999.99"),		    oFont11c)	// Desconto
	oPrint:Say(nLin+2410,1810,	"(-)Outras Deduções",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+2480,1810,	"(+)Mora/Multa",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+2508,1900,	Transform(aDadTit[22],"@E 9999,999,999.99"),		    oFont11c)	// Juros
	oPrint:Say(nLin+2550,1810,	"(+)Outros Acréscimos",									oFont9)		// Texto Fixo
	oPrint:Say(nLin+2578,1900,	Transform(aDadTit[23],"@E 9999,999,999.99"),		    oFont11c)	// Acrescimo
	oPrint:Say(nLin+2620,1810,	"(=)Valor Cobrado",										oFont9)		// Texto Fixo
	oPrint:Say(nLin+2644,1900,	Transform(aDadTit[24],"@E 9999,999,999.99"),		    oFont11c)	// Valor Cobrado

	oPrint:Say(nLin+2650,0100,   "Pedido: " + Padr( aDadTit[18], 30 ),		 			oFont10)	// Número dos Pedidos

	oPrint:Say(nLin+2690,0100,	"Pagador",												oFont9)		// Texto Fixo
	oPrint:Say(nLin+2700,0200,	SubStr(_cSacado,1,IIf( Len(_cSacado) > 80,80,Len(_cSacado) )),		oFont10)	// Nome Cliente + Código

	If aDadCli[6] = "J"
		oPrint:Say(nLin+2700,1850,	"CNPJ: "+Transform(aDadCli[4],"@R 99.999.999/9999-99"), oFont10)	// CGC
	Else
		oPrint:Say(nLin+2700,1850,	"CPF: "+Transform(aDadCli[4],"@R 999.999.999-99"), oFont10)	// CPF
	EndIf

	oPrint:Say(nLin+2753,0200,	Alltrim(aDadCli[7])+" "+AllTrim(aDadCli[8]),			oFont10)	// Endereço
	oPrint:Say(nLin+2806,0200,	Transform(aDadCli[11],"@R 99999-999")+" - "+ AllTrim(aDadCli[9])+" - "+AllTrim(aDadCli[10]),		oFont10)	// CEP + Cidade + Estado

	oPrint:Say(nLin+2806,1850,	aBarra[4],												oFont10)	// Carteira + Nosso Número

	If aDadBco[1] == "422"
	   oPrint:Say(nLin+2855,0100,	"Pagador/Avalista: " + SPACE(30) + " - CNPJ: " + SPACE(14),oFont9)//Sacador
	Else
	   oPrint:Say(nLin+2855,0100,	"Pagador/Avalista: " + SM0->M0_NOMECOM + " - CNPJ: " + SM0->M0_CGC, oFont9) //Sacador
	EndIf

	oPrint:Say(nLin+2895,1500,	"Autenticação Mecânica - Ficha de Compensação",			oFont9)		// Texto Fixo

	oPrint:Line(nLin+2000-nAjuste,1800,nLin+2690-nAjuste,1800)														// Quadro
	oPrint:Line(nLin+2410-nAjuste,1800,nLin+2410-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2480-nAjuste,1800,nLin+2480-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2550-nAjuste,1800,nLin+2550-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2620-nAjuste,1800,nLin+2620-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2690-nAjuste,0100,nLin+2690-nAjuste,2300)														// Quadro
	oPrint:Line(nLin+2890-nAjuste,0100,nLin+2890-nAjuste,2300)														// Quadro

	// Se Impressão em polegadas
	// Guarabira
	/*
	If nTpImp == 1
		MSBAR(	"INT25",;
				13.7,;
				0.8,;
				aBarra[1],;
				oPrint,;
				.F.,;
				Nil,;
				Nil,;
				0.013,;
				0.7,;
				Nil,;
				Nil,;
				"A",;
				.F.)

		// Se Impressão em centímetros Campinas
	Else
		MSBAR(	"INT25",;			// Tipo do código (EAN13,EAN8,UPCA,SUP5,CODE128,INT25,MAT25,IND25,CODABAR,CODE3_9,EAN128)
				26.0,;				// Número da linha em centímetros
				0.8,;				// Número da coluna em centímetros 0.8
				aBarra[1],;			// String com o conteúdo do código
				oPrint,;			// Objeto printer
				.F.,;				// Se calcula o dígito de controle
				Nil,;				// Número da Cor (utilizar a Common.ch)
				Nil,;				// Se imprime na horizontal
				0.025,;				// Número do tamanho da barra em centímetros 0.025
				1.5,;				// Número da altura da barra em milímetros
				Nil,;				// Imprime linha embaixo do código
				Nil,;				// String com o tipo de fonte
				"A",;				// String com o modo do código de barras
				.F.)				// ??
	EndIf
	*/
//	oPrint:FWMSBAR("INT25",72.8/*66.8*/,1.8/*2.0*/,aBarra[1],oPrint,.F.,,,,1.0,,,,.F.)
//	oPrint:FWMSBAR("INT25",70/*66.8*/,1.8/*2.0*/,aBarra[1],oPrint,.F.,,,,1.0,,,,.F.)
	oPrint:FWMSBAR("INT25",71/*66.8*/,1.8/*2.0*/,aBarra[1],oPrint,.F.,,,,1.0,,,,.F.)

	oPrint:EndPage() // Finaliza a página
Return(Nil)

//+----------------------------------------------------------------------------------------
//	Retorna conteúdos para o arquivo de remessa dos bancos
//+----------------------------------------------------------------------------------------
User Function TCCobRem( cBanco, cCampo, nTamanho )
	Local cRetorno	:= Space(nTamanho)
	Local nAbatim		:= 0
	Local nValLiq		:= 0

	Do Case
		Case cCampo == "IDEMPRESA"
			If cBanco == "745"
				cRetorno	:= SubStr(SEE->EE_CODEMP,2,7)
				cRetorno	+= SubStr(SEE->EE_CODEMP,3,6)
				cRetorno	+= SubStr(SEE->EE_CODEMP,8,3)
				cRetorno	+= "0"
				cRetorno	+= SEE->EE_SUBCTA
			EndIf
		Case cCampo == "VLRLIQ"
			nAbatim		:= SomaAbat(	SE1->E1_PREFIXO,;
											SE1->E1_NUM,;
											SE1->E1_PARCELA,;
											"R",;
											SE1->E1_MOEDA,;
											dDataBase,;
											SE1->E1_CLIENTE,;
											SE1->E1_LOJA )

			nValLiq		:= SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE - nAbatim
			cRetorno		:= StrZero( ( nValLiq * 100 ), nTamanho )
		Case cCampo == "NNUMERO"
			cRetorno	:= AllTrim(SE1->E1_NUMBCO)
			cRetorno	+= U_TCCalcDV( cBanco, AllTrim( SE1->E1_NUMBCO ) )

		OtherWise
			cRetorno	:= Space(nTamanho)
	EndCase

Return( cRetorno )

//+----------------------------------------------------------------------------------------
//	Efetua o cálculo do dígito veririficador com base 11
//+----------------------------------------------------------------------------------------
Static Function Mod11422(cVariavel)
	Local Auxi := 0, sumdig := 0, nBase := 0

	cbase		:= cVariavel
	lbase 		:= LEN(cBase)
	nBase 		:= 2
	sumdig 	:= 0
	Auxi 		:= 0
	iDig 		:= lBase

	While iDig >= 1
		auxi 	:= Val(SubStr(cBase, idig, 1)) * nBase
		sumdig += auxi
		nBase 	:= nBase + 1
		iDig	:= iDig-1
	EndDo

	auxi := mod(sumdig,11)

	If auxi == 0
		auxi 	:= 1
	ElseIf auxi == 1
		auxi 	:= 0
	Else
		auxi 	:= 11 - auxi
	EndIf
Return(str(auxi,1,0))

//+----------------------------------------------------------------------------------------
//	Calculo de Data conforme passagem de parametros no sistema
//+----------------------------------------------------------------------------------------
Static Function _fnDataMult(__dt1,__dt2,__nVal)
	Local nDiffDay 	:= Iif(__dt2 < __dt1,0,(DateDiffMonth( __dt1 , __dt2 )+1))
	Local __mv_txper	:= GetNewPar("MV_TXPER","1.5")
	Local __ncalcDay	:= 0

	If( __dt2 = __dt1 )
		nDiffDay := 0 // A Vista
	EndIf

	// Efetua processamento referente aos dias de atraso
	// para pagamento de Multa/Mora nos dias subsequentes
	__ncalcDay := ( (( __mv_txper*nDiffDay )/100)*__nVal )
Return( __ncalcDay )

//+----------------------------------------------------------------------------------------
//	Calculo de Data conforme passagem de parametros no sistema 	   										   |
//+----------------------------------------------------------------------------------------
User Function fnCnabMult(__nTp)
	Local nDiffDay 		:= 30
	Local __mv_txper		:= GetNewPar("MV_TXPER","1.5")
	Local __ncalcDay		:= 0

	Default __nTp 		:= 0

	If( SE1->E1_EMISSAO = SE1->E1_VENCTO )
		nDiffDay := 0
	EndIf

	// Efetua processamento referente aos dias de atraso
	// para pagamento de Multa/Mora nos dias subsequentes
	__ncalcDay := ( (( __mv_txper*nDiffDay )/100) )
Return( __ncalcDay )
