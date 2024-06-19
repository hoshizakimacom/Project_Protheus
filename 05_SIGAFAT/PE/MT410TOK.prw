#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------
//| PE executado ao clicar no botão OK do pedido de venda
//+---------------------------------------------------------------------------------------------------------------------------------
User Function MT410TOK()

Local _aArea        := GetArea()
Local _nOpc         := ParamIxb[1]
Local _lRet         := .T.

FwMsgRun(,{|| _lRet := U_M05A11(_nOpc) },,'Aguarde...' )

RestArea(_aArea)
    
// +------------------------------------------------------------+
// | Verifica o usuário responsável pelo faturamento e o alerta |
// | Caso a condição de pagamento seja do tipo 9 e as datas e   |
// | parcelas estejam em branco.                                |
// +------------------------------------------------------------+
If RetCodUsr() $ '000010|000151|000217|000225'
	dbSelectArea("SE4")
	dbSetOrder(1)
	If MsSeek(xFilial("SE4")+M->C5_CONDPAG)
		If SE4->E4_TIPO == "9"
			If Empty(M->C5_PARC1) .Or. Empty(M->C5_DATA1)
                _lRet := .F.
   	            MsgStop('É obrigatório informar ao menos 1 data de vencimento e parcela para condição de pagamentco do tipo 9 ! (Pré-fixadas)','Atenção')
			Endif
		Endif
	Endif
Endif

// Verifica data de entrega anterior a emissão do pedido.
If M->C5_FECENT < M->C5_EMISSAO
	MsgAlert("Data de entrega retroativa a emissão do pedido !","ATENÇÃO")
	_lRet := .F.
Endif

// Verifica se o pedido está em modo de alteração e caso possua financiamento do tipo FINAME
// bloqueia a operação.  
If ALTERA
	If M->C5_XFINAME == '1' .And. ! RetCodUsr() $ '000080|000116|000131|000151' 
		MsgStop('Este pedido possui financiamento do tipo FINAME, o que impede sua alteração. Entre em contato com o departamento financeiro.','Atenção')
		_lRet := .F.				
	Endif
Endif

// Verifica se o cliente/loja de entrega é igual ao cliente/loja principal
If M->C5_CLIENTE <> M->C5_CLIENT .Or. M->C5_LOJACLI <> M->C5_LOJAENT
	MsgAlert("Cliente ou loja de entrega diferem do cliente/loja principal. Verifique !","ATENÇÃO")
	_lRet := .F.
Endif

// *** Verifica Campos que Foram Alterados e envia E-Mail aos usuários específicos *** //
//If _lRet
//	EnvEmail01()
//EndIf
   
Return _lRet

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |EnvEmail01 |Autor |Valdemir Miranda          | Data | 05/05/2023 ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Verifica Campos que Foram Alterados e envia E-Mail os usuários   ||
||           |especificados no parâmetro AM_CAMPALT                            ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function EnvEmail01()

Local aDifSC6 := {}
Local aArea    := GetArea()
Local nProc    :=0
Local aAreaSC6 := SC6->(GetArea())
Local nPosItem		:= ASCan( aHeader, {|aCol| AllTrim(aCol[2])=='C6_ITEM' })
Local nPosProd		:= ASCan( aHeader, {|aCol| AllTrim(aCol[2])=='C6_PRODUTO' })
Local nPosQuant		:= ASCan( aHeader, {|aCol| AllTrim(aCol[2])=='C6_QTDVEN' })
pRIVATE nPosEnt		:= ASCan( aHeader, {|aCol| AllTrim(aCol[2])=='C6_ENTREG' })

// *** Alteração do Pedido de Vendas *** //
dbSelectArea("SC6")
dbSetOrder(1)
If ALTERA

	For nProc := 1 To Len(Acols)

		cItem := Acols[nProc,nPosItem]
		If !SC6->(dbSeek(xFilial("SC6")+M->C5_NUM+cItem))  // Linha Incluída
			Aadd(aDifSC6,"Item Incluído "+cItem+ " - Produto : "+Acols[nProc,nPosProd])
			cxAssuntox :="Item Incluído "+cItem+  " - Produto : "+Acols[nProc,nPosProd] + CRLF
		EndIf

		If Acols[nProc,nPosProd] <> SC6->C6_PRODUTO
			Aadd(aDifSC6,"Item : "+cItem+ " - Produto de : "+SC6->C6_PRODUTO+" Para : "+Acols[nProc,nPosProd])
			cxAssuntox :="Item :"+cItem+  " - Produto de : "+SC6->C6_PRODUTO+" Para : "+Acols[nProc,nPosProd] + CRLF
		EndIf

		If Acols[nProc,nPosQuant] <> SC6->C6_QTDVEN
			Aadd(aDifSC6,"Item : "+cItem+ " - Qtd de : "+Transform(SC6->C6_QTDVEN,"@ 9999999")+" Para : "+Transform(Acols[nProc,nPosProd],"@ 9999999"))
			cxAssuntox :="Item :" +cItem+  "Alterado a Qtd.Vendida de "+Transform(SC6->C6_QTDVEN,"@ 9999999")+" Para : "+ Transform(Acols[nProc,nPosProd],"@ 9999999") + CRLF
		EndIf

//		If Acols[nProc,nPosQuant]  <> SC6->C6_QENTREG   // trocar por entraga
//			Aadd(aDifSC6,"Item : "+cItem+ " - Alterado a Dt. Entrega de : "+Dtoc*(SC6->C6_ENTREG)+" Para : "+Acols[nProc,nPosProd] )
//			cxAssuntox :="Item :" +cItem+  "Alterado a Dt. Entrega de "+Dtoc*(SC6->C6_ENTREG)+" Para : "+ Acols[nProc,nPosProd] + CRLF
//		EndIf

//		If Aadd(nProc,Len(aHeader)+1)   // Linha Excluída
//			Aadd(aDifSC6,"Item Excluido : "+cItem+ " - Produto : "+Acols[nProc,nPosProd])
//			cxAssuntox :="Item Excluido :" +cItem+  " - Produto : "+Acols[nProc,nPosProd]+ CRLF
//		EndIf
	Next

EndIf

RestArea(aAreaSC6)
RestArea(aArea)

Return
