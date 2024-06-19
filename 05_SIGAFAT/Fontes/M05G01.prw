#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
//	Função chamada de gatilhos na SC6
//+------------------------------------------------------------------------------------------------
User Function M05G01(_cField)

	Local _aArea		:= GetArea()
	Local _xRet			:= Nil
	Private _nPrcVen	:= 0

	Do Case
		//+-------------------------------------------------------
		//	Produto
		//+-------------------------------------------------------
		Case _cField == 'C6_PRODUTO'
			_xRet	:= GdFieldGet(_cField,n)
			SetFldClr('PV')		 // Limpa campos de valores
			U_M05A01('PV')		 // Atualiza preço do produto
			SetTpProd('PV')      // Atualiza campo virtual com tipo do produto
			SetFCI('PV')         // Atualiza campo com FCI

		Case _cField == 'CK_PRODUTO'
			_xRet	:= TMP1->(FieldGet(FieldPos(_cField)))
			SetFldClr('OV')		// Limpa campos de valores
			U_M05A01('OV')		// Atualiza preço do produto
            SetFCI('OV')         // Atualiza campo com FCI

		//+------------------------------------------------------macom-
		//	Quantidade de Venda
		//+-------------------------------------------------------
		Case _cField == 'C6_QTDVEN'
			_xRet	:= GdFieldGet(_cField,n)
			GdFieldPut('C6_XACRESC'	,0				,n)
			GdFieldPut('C6_DESCONT'	,0				,n)
			U_M05A03('PV') // Atualiza totais

		Case _cField == 'CK_QTDVEN'
			_xRet	:= TMP1->(FieldGet(FieldPos(_cField)))
			TMP1->(FieldPut(FieldPos('CK_XACRESC')	,0))
			TMP1->(FieldPut(FieldPos('CK_DESCONT')	,0))
			TMP1->(FieldPut(FieldPos('CK_XDESCON')	,0))
			U_M05A03('OV') // Atualiza totais

		//+-------------------------------------------------------
		//	Tabela de Preços
		//+-------------------------------------------------------
		Case _cField == 'C5_TABELA'
			If M->C5_TABELA <> 'DEV'
				_xRet := M->C5_TABELA
				SetPrcTab('PV')		// Atualiza preço da nova tabela
			Endif

		Case _cField == 'CJ_TABELA'
			_xRet := M->CJ_TABELA
			SetPrcTab('OV')		// Atualiza preço da nova tabela

		//+-------------------------------------------------------
		//	Descontos Cabeçalho
		//+-------------------------------------------------------
		Case _cField $ '|C5_DESC1|C5_DESC2|C5_DESC3|C5_DESC4|C5_XACRESC|C5_XFRETE|C5_XINSTA|C5_CONDPAG|'
			_xRet := &('M->'+_cField)
			If Valtype(_xRet) == 'N'
				SetDescAcr('PV')
			Else
				If _xRet != '999'
					SetDescAcr('PV')
				Endif
			Endif

		Case _cField $ '|CJ_DESC1|CJ_DESC2|CJ_DESC3|CJ_DESC4|CJ_XACRESC|CJ_XFRETE|CJ_XINSTA|CJ_CONDPAG||'
			_xRet := &('M->'+_cField)
			TMP1->(FieldPut(FieldPos('CK_DESCONT')	, TMP1->(FieldGet(FieldPos('CK_XDESCON')))))
			SetDescAcr('OV')

		//+-------------------------------------------------------
		//	Descontos Item
		//+-------------------------------------------------------
		Case _cField $ 'C6_DESCONT'
			_xRet := &('M->'+_cField)

			If _xRet > 0
				GdFieldPut('C6_XACRESC'	,0				,n)
			EndIf

			U_M05A03('PV')

		Case _cField $ 'CK_DESCONT'
			_xRet := &('M->'+_cField)

			TMP1->(FieldPut(FieldPos('CK_XDESCON')	,_xRet))

			If _xRet > 0
				TMP1->(FieldPut(FieldPos('CK_XACRESC')	,0))
			EndIf

			U_M05A03('OV')

		//+-------------------------------------------------------
		//	Acrescimos
		//+-------------------------------------------------------
		Case _cField $ 'C6_XACRESC'
			_xRet := &('M->'+_cField)

			If _xRet > 0
				GdFieldPut('C6_DESCONT'	,0				,n)
			EndIf
			U_M05A03('PV')

		Case _cField $ 'CK_XACRESC'
			_xRet := &('M->'+_cField)

			If _xRet > 0
				TMP1->(FieldPut(FieldPos('CK_DESCONT')	,0))
				TMP1->(FieldPut(FieldPos('CK_XDESCON')	,0))
			EndIf
			U_M05A03('OV')

	   Case _cField $ 'C5_TPFRETE'
	       _xRet := &('M->'+_cField)

	       If _xRet $ 'C'
	           M->C5_FRETE     := 0
	       EndIf


	   Case _cField $ 'CJ_XTFRETE'
	       _xRet := &('M->'+_cField)

	       If _xRet $ 'C'
	           M->CJ_FRETE   := 0
	       EndIf


        //+-------------------------------------------------------
        //  Tabela de Preços
        //+-------------------------------------------------------
        Case _cField == 'C5_FECENT'
            _xRet := &('M->'+_cField)
            SetFecEnt('PV')

        Case _cField == 'CJ_XFECENT'
            _xRet := &('M->'+_cField)
            SetFecEnt('OV')

        //+-------------------------------------------------------
        //  Tabela de Preços
        //+-------------------------------------------------------
        Case _cField == 'C6_OPER'
            _xRet := &('M->'+_cField)
            GdFieldPut('C6_XOPER' ,_xRet              ,n)
            
            //+---------------------------------------------------------+
            //|  Ajuste efetuado atentendo solicitação da usuária       |
            //|  Cibele para ajuste automático do valor unitário        |
            //|  nas operações :                                        |
            //|  03 - Venda Entrega Futura                              |
            //|  04 - Revenda Entrega Futura                            |
            //|  27 - Lançamento a Título de Simples Faturamento        |
            //|  44 - Simples Faturamento - Operação Revenda            |
            //+---------------------------------------------------------+
//            If _xRet $ "03|04|27|44"
//            	GdFieldPut('C6_DESCONT', 0 , n)
//            	GdFieldPut('C6_XACRESC', 0 , n)
//            	U_M05A03('PV')
//            Endif  

			//+-----------------+
			//|  Fim do ajuste  |
			//+-----------------+ 

            Do Case
//            Case _xRet $ "03|04|36|"  // Retirado em 22/02/24 - Chamado Jardiel
  //              U_M05A01_A('PV')

            Case _xRet $ "|27|44|38"
                U_M05A01_B('PV')

            OtherWise
                SetFldClr('PV')     // Limpa campos de valores
                U_M05A01('PV',.F.)      // Atualiza preço do produto
            EndCase

        Case _cField == 'CK_OPER'
            _xRet := &('M->'+_cField)

            TMP1->(FieldPut(FieldPos('CK_XOPER')  ,_xRet))

            Do Case
            Case _xRet $ "03|04|36|"
                U_M05A01_A('OV')

            Case _xRet $ "|27|44"
                U_M05A01_B('OV')

            OtherWise
                SetFldClr('OV')     // Limpa campos de valores
                U_M05A01('OV',.F.)      // Atualiza preço do produto
            EndCase

        //+-------------------------------------------------------
        //  Instalacao
        //+-------------------------------------------------------
        Case _cField $ 'C5_XTPINST|C5_XVLINST|'
            _xRet := &('M->'+_cField)

            M->C5_DESPESA := IIF(M->C5_XTPINST == '3', M->C5_XVLINST,0)

        Case _cField $ 'CJ_XTPINST|CJ_XVLINST|'
            _xRet := &('M->'+_cField)

            M->CJ_DESPESA := IIF(M->CJ_XTPINST == '3', M->CJ_XVLINST,0)

        //+-------------------------------------------------------
        //  Nome do Cliente/Fornecedor
        //+-------------------------------------------------------
        Case _cField $ 'C5_CLIENTE|C5_LOJACLI|'
            _xRet := &('M->'+_cField)

            M->C5_XCLINOM := U_M05A32('NOME')

			// Caso o cliente for Arcos Dourados, efetua a liberação financeira.
			If M->C5_CLIENTE == AllTrim(GetMv("AM_CLIMCD"))   //'002953'
				M->C5_XSTSFIN := '2'
			Else
				M->C5_XSTSFIN := '1'
			Endif
	EndCase

	RestArea(_aArea)
Return _xRet

//+------------------------------------------------------------------------------------------------
// Aplica desconto de cabeçalho
//+------------------------------------------------------------------------------------------------
Static Function SetFecEnt(_cFunc)

    Local _nBkp  := 0

    Do Case
    Case _cFunc == 'PV'
        _nBkp       := N
        N           := 1

        If Len(aCols) > 0 .And. !Empty( GdFieldGet('C6_PRODUTO',n) )

            For n := 1 To Len(aCols)
                GdFieldPut('C6_ENTREG'  ,M->C5_FECENT       ,n)
            Next
            N := _nBkp
            oGetDad:oBrowse:Refresh()
        EndIf

    Case _cFunc == 'OV'
        TMP1->(DbGotop())

        If TMP1->(!EOF()) .And. !Empty( TMP1->(FieldGet(FieldPos('CK_PRODUTO'))) )

            While TMP1->(!EOF())

                TMP1->(FieldPut(FieldPos('CK_ENTREG')   ,M->CJ_XFECENT ))

                TMP1->(DbSkip())
            EndDo

            TMP1->(DbGotop())

            oGetDad:oBrowse:Refresh()
        EndIf
    EndCase

Return

//+------------------------------------------------------------------------------------------------
// Aplica desconto de cabeçalho
//+------------------------------------------------------------------------------------------------
Static Function SetDescAcr(_cFunc)
	Local _nBkp	 := 0

	Do Case
	Case _cFunc == 'PV'
		_nBkp		:= N
		N 			:= 1

		If Len(aCols) > 0 .And. !Empty( GdFieldGet('C6_PRODUTO',n) )
			For n := 1 To Len(aCols)
				U_M05A03(_cFunc)
			Next
			N := _nBkp
			oGetDad:oBrowse:Refresh()
		EndIf

	Case _cFunc == 'OV'
		TMP1->(DbGotop())

		If TMP1->(!EOF()) .And. !Empty( TMP1->(FieldGet(FieldPos('CK_PRODUTO'))) )

			While TMP1->(!EOF())
				U_M05A03(_cFunc)
				TMP1->(DbSkip())
			EndDo
			TMP1->(DbGotop())

			oGetDad:oBrowse:Refresh()
		EndIf
	EndCase

Return


//+------------------------------------------------------------------------------------------------
//	Responsável pela atualização dos preços e impostos de acordo com a nova tabela informada
//+------------------------------------------------------------------------------------------------
Static Function SetPrcTab(_cFunc)
	Local _nBkp			:= 0
	Local _nItem		:= 0

	Do Case
		//+-----------------------------------------------------------
		// Pedido de Venda
		//+-----------------------------------------------------------
		Case _cFunc == 'PV'
			_nBkp			:= 0

			If Len(aCols) > 0 .And. !Empty( GdFieldGet('C6_PRODUTO',n) )
				_nBkp  := N
				
				For n := 1 To Len(aCols)
					FWMsgRun(, {|| U_M05A01('PV',M->C5_TIPO == 'N') },,I18N('Calculando #1 de #2 ...',{n,Len(aCols)}))
				Next
			N := _nBkp

				oGetDad:oBrowse:Refresh()

			N := _nBkp
			EndIf

		//+-----------------------------------------------------------
		//	Orçamento de Vendas
		//+-----------------------------------------------------------
		Case _cFunc == 'OV'
			TMP1->(DbGotop())

			If TMP1->(!EOF()) .And. !Empty( TMP1->(FieldGet(FieldPos('CK_PRODUTO'))) )

				While TMP1->(!EOF())

					FWMsgRun(, {|| U_M05A01('OV') },,I18N('Calculando item #1 ...',{++_nItem}))

					TMP1->(DbSkip())
				EndDo

				TMP1->(DbGotop())

				oGetDad:oBrowse:Refresh()
			EndIf
	EndCase

Return

//+------------------------------------------------------------------------------------------------
//	Função responsável pela limpeza dos campos de valores
//+------------------------------------------------------------------------------------------------
Static Function SetFldClr(_cFunc,lQuant)
    Default lQuant := .T.

	Do Case
		Case _cFunc == 'PV'
			// padrao
			//GdFieldPut('C6_QTDVEN'	,1,n) // chamado #1116
			GdFieldPut('C6_PRCVEN'	,0,n)
			GdFieldPut('C6_VALOR'	,0,n)
			GdFieldPut('C6_DESCONT'	,0,n)
			GdFieldPut('C6_VALDESC'	,0,n)

			// Acrescimo
			GdFieldPut('C6_XACRESC'	,0,n)

			// valor unitario
			GdFieldPut('C6_XVLUTAB'	,0,n)
			GdFieldPut('C6_XVLULIQ'	,0,n)
			GdFieldPut('C6_XVLUBRU'	,0,n)
			GdFieldPut('C6_XVLUIPI'	,0,n)
			GdFieldPut('C6_XVLUICM'	,0,n)
			GdFieldPut('C6_XVLUICO'	,0,n)
			GdFieldPut('C6_XVLUICD'	,0,n)
			GdFieldPut('C6_XVLUSOL'	,0,n)
			GdFieldPut('C6_XVLUPS2'	,0,n)
			GdFieldPut('C6_XVLUCF2'	,0,n)
			GdFieldPut('C6_XVLUFCP'	,0,n)
			GdFieldPut('C6_XVLUIMP'	,0,n)

			// aliquota
			GdFieldPut('C6_XALQIPI'	,0,n)
			GdFieldPut('C6_XALQICM'	,0,n)
			GdFieldPut('C6_XALQICO'	,0,n)
			GdFieldPut('C6_XALQICD'	,0,n)
			GdFieldPut('C6_XALQSOL'	,0,n)
			GdFieldPut('C6_XALQPS2'	,0,n)
			GdFieldPut('C6_XALQCF2'	,0,n)
			GdFieldPut('C6_XALQFCP'	,0,n)
			GdFieldPut('C6_XALQIMP'	,0,n)

			// valor total
			GdFieldPut('C6_XVLTBRU'	,0,n)
			GdFieldPut('C6_XVLTIPI'	,0,n)
			GdFieldPut('C6_XVLTICM'	,0,n)
			GdFieldPut('C6_XVLTICO'	,0,n)
			GdFieldPut('C6_XVLTICD'	,0,n)
			GdFieldPut('C6_XVLTPS2'	,0,n)
			GdFieldPut('C6_XVLTSOL'	,0,n)
			GdFieldPut('C6_XVLTCF2'	,0,n)
			GdFieldPut('C6_XVLTFCP'	,0,n)
			GdFieldPut('C6_XVLTIMP'	,0,n)

			// Valor base
			GdFieldPut('C6_XBASICM'  ,0,n)
			GdFieldPut('C6_XFRETE'   ,0,n)
			GdFieldPut('C6_XINSTA'   ,0,n)


		Case _cFunc == 'OV'

			// padrao
			TMP1->(FieldPut(FieldPos('CK_QTDVEN')	,1))
			TMP1->(FieldPut(FieldPos('CK_PRCVEN')	,0))
			TMP1->(FieldPut(FieldPos('CK_VALOR')	,0))
			TMP1->(FieldPut(FieldPos('CK_DESCONT')	,0))
			TMP1->(FieldPut(FieldPos('CK_XDESCON')	,0))
			TMP1->(FieldPut(FieldPos('CK_VALDESC')	,0))

			// Acrescimo
			TMP1->(FieldPut(FieldPos('CK_XACRESC')	,0))

			// valor unitario
			TMP1->(FieldPut(FieldPos('CK_XVLUTAB')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLULIQ')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUBRU')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUIPI')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUICM')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUICO')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUICD')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUSOL')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUPS2')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUCF2')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUFCP')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLUIMP')	,0))

			// aliquota
			TMP1->(FieldPut(FieldPos('CK_XALQIPI')	,0))
			TMP1->(FieldPut(FieldPos('CK_XALQICM')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQICM')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQICO')	,0))
			TMP1->(FieldPut(FieldPos('CK_XALQICD')	,0))
			TMP1->(FieldPut(FieldPos('CK_XALQSOL')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQSOL')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQPS2')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQPS2')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQCF2')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQCF2')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQFCP')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQFCP')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQIMP')	,0)) // vda
			TMP1->(FieldPut(FieldPos('CK_XALQIMP')	,0)) // vda

			// valor total
			TMP1->(FieldPut(FieldPos('CK_XVLTBRU')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTIPI')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTICM')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTICO')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTICD')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTSOL')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTPS2')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTCF2')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTFCP')	,0))
			TMP1->(FieldPut(FieldPos('CK_XVLTIMP')	,0))
			TMP1->(FieldPut(FieldPos('CK_XFRETE')	,0))
			TMP1->(FieldPut(FieldPos('CK_XINSTA')	,0))

		EndCase
Return

//+------------------------------------------------------------------------------------------------
//	Função responsável pela inclusão do tipo do produto
//+------------------------------------------------------------------------------------------------
Static Function SetFCI(_cFunc)
    Local aAreaSB1  := SB1->(GetArea())
    Local cFCI      := ''

    Do Case
    Case _cFunc == 'PV'
    	cFCI    := POSICIONE("SB1",1,XFILIAL("SB1") + GdFieldGet('C6_PRODUTO',n)  ,"B1_XFCICOD")

    	If !Empty(cFCI)
    	   GdFieldPut('C6_FCICOD'	,cFCI ,n)
        EndIf
    Case _cFunc = 'OV'
        cFCI    := POSICIONE("SB1",1,XFILIAL("SB1") + TMP1->(FieldGet(FieldPos('CK_PRODUTO')))  ,"B1_XFCICOD")

        If !Empty(cFCI)
            TMP1->(FieldPut(FieldPos('CK_FCICOD')   ,cFCI))
        EndIf
    EndCase

    RestArea(aAreaSB1)
Return

//+------------------------------------------------------------------------------------------------
//	Função responsável pela inclusão do tipo do produto
//+------------------------------------------------------------------------------------------------
Static Function SetTpProd(_cFunc)
    Local cTipo := ''

	Do Case
		Case _cFunc == 'PV'
			cTipo    := POSICIONE("SB1",1,XFILIAL("SB1") + GdFieldGet('C6_PRODUTO',n)  ,"B1_TIPO")
			GdFieldPut('C6_XPRODTP'	,cTipo ,n)

//		Case _cFunc == 'OV'
//          cTipo   := TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
//			TMP1->(FieldPut(FieldPos('CK_XPRODTP')	, cTipo ))
		EndCase
Return
