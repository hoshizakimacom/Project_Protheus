#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------------------
// Valida total de desconto do item do orçamento/pedido de venda
//+---------------------------------------------------------------------------------------------------------------------------------------------
User Function M05A28(cFunc,lItem,nvalor)
    Local lRet      := .T.
    Local aArea     := GetArea()
    Local nItens    := 0
    Local nDescCab  := 1
    
    Local cMsg      := ''
    Local cGrpApr   := GetMv('AM_05A28_A',,'')
    Local lAprov    := U_M00A01(cGrpApr)
    Local cCodUsr	:= RetCodUsr()
    Private cNomUsr	:= UsrFullName(cCodUsr)
    Private nDescIte  := 1
    
    DEFAULT nValor := 0

    // Busca Desconto no cabeçalho
    nDescCab    := MA05GetDeC(cFunc)

    lRet := MA05GetTot(cFunc,nDescCab,@cMsg,lItem,@nItens,nvalor)

    If !(lRet := Empty(cMsg))

        If lAprov
            lRet := MsgYesNo(I18N('Desconto concedido é maior que o permitido para os #1 itens abaixo.' + CRLF + '#2' + CRLF + CRLF + 'Deseja aprovar todos os descontos?',{nItens,cMsg}))
			If lRet
				M->C5_XAPROV := UsrFullName(RetCodUsr())
			Else
				M->C5_DESC1 := 0
				M->C5_DESC2 := 0
			Endif
        Else
            Aviso('Atenção',I18N('Desconto concedido é maior que o permitido para os #1 itens abaixo:' + CRLF + '#2', {nItens,cMsg}),{'OK'},3)
        EndIf
    EndIf

    RestArea(aArea)
Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MA05GetDeC(cFunc)
    Local aDesc     := {}
    Local _nX       := 0
    Local nPerDesc  := 1

    Do Case
    Case cFunc == 'PV'
        AAdd(aDesc, 1 - (M->C5_DESC1 / 100))
        AAdd(aDesc, 1 - (M->C5_DESC2 / 100))
        AAdd(aDesc, 1 - (M->C5_DESC3 / 100))
        AAdd(aDesc, 1 - (M->C5_DESC4 / 100))

    Case cFunc == 'OV'

        AAdd(aDesc, 1 - (M->CJ_DESC1 / 100))
        AAdd(aDesc, 1 - (M->CJ_DESC2 / 100))
        AAdd(aDesc, 1 - (M->CJ_DESC3 / 100))
        AAdd(aDesc, 1 - (M->CJ_DESC4 / 100))
    EndCase

    For _nX := 1 to Len(aDesc)
        nPerDesc := nPerDesc * aDesc[_nX]
    Next _nX

Return nPerDesc

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MA05GetTot(cFunc,nPerDesc,cMsg,lItem,nItens,nValor)

    Local aArea         := GetArea()
    Local nBkp
    Local nItem  := 0
    Local aDesc         := {}
    Local lRet          := .T.
 //   Default N
 
    Do Case
    Case cFunc == 'PV'
        If lItem
            aAux    := MA05DescPV(nPerDesc,nValor)
            AAdd(aDesc,aAux)

        Else
            nBkp    := N
            N       := 1
           If Len(aCols) > 0 .And. !Empty( GdFieldGet('C6_PRODUTO',n) )
                For n := 1 To Len(aCols)
                    aAux    := {}
                    aAux    := MA05DescPV(nPerDesc)
                    AAdd(aDesc,aAux)
                Next
                 N := nBkp
                oGetDad:oBrowse:Refresh()
            EndIf
        EndIf

    Case cFunc == 'OV'
        If lItem
            aAux    := MA05DescOV(nPerDesc,nValor)
            AAdd(aDesc,aAux)
        Else

            TMP1->(DbGotop())

            If TMP1->(!EOF()) .And. !Empty( TMP1->(FieldGet(FieldPos('CK_PRODUTO'))) )
                While TMP1->(!EOF())
                    aAux    := {}
                    aAux    := MA05DescOV(nPerDesc,nValor)
                    AAdd(aDesc,aAux)

                    TMP1->(DbSkip())
                EndDo
                TMP1->(DbGotop())

                oGetDad:oBrowse:Refresh()
            EndIf
        EndIf
    EndCase

    For nItem := 1 To Len(aDesc)
        If aDesc[nItem][4] > 0 .And. aDesc[nItem][4] < aDesc[nItem][3]
            cMsg += CRLF + I18N('Seq.: #1 |Prod.: #2 |Desc. Aplicado: #3 % |Máximo: #4 %',{aDesc[nItem][5],aDesc[nItem][1],aDesc[nItem][3],aDesc[nItem][4]})
            lRet := .F.
            nItens++
        EndIf
    Next

    RestArea(aArea)
Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MA05DescPV(nPerDesc,nValor)

    Local cProd         := ''
    Local cFamilia      := ''
    Local cItem         := ''
    Local nDescFam      := 0
    Local nDescTot      := 1
   
    Local nDescI        := 0
    Local aRet          := {}
    Local cCodUser		:= RetCodUsr()
    Private nItem         := 1

	DEFAULT nValor := 0
 	
    If Type('M->C6_DESCONT') == 'N'
        nDescI      := 1 - (M->C6_DESCONT / 100)
    Else
        nDescI      := 1 - ( GdFieldGet('C6_DESCONT',n) / 100)
    EndIf

	If Type('M->C6_DESCONT') == 'U'
		nDescI      := (nValor / GDFieldGet('C6_XVLTBRU',n)) * 100
		nDescI		:= 100 - nDescI
		
		If ReadVar() == "M->C5_DESC1" .Or. ReadVar() == "M->C5_DESC2"
			nDescTot    := 100 - (nPerDesc * nDescI)
		Else
			nDescTot    := nPerDesc * nDescI
		Endif
	Else
	    nDescTot    := nPerDesc * nDescI
	    nDescTot    := 100 - (nDescTot * 100)		
	Endif

	If ReadVar() == "M->C5_DESC1" .And. M->C5_DESC1 == 0 
		nDescTot    := 0 
	Endif

    cProd       := GdFieldGet('C6_PRODUTO',n)
    cFamilia    := Posicione('SB1',1,xFilial('SB1') + cProd,'B1_XFAMILI' )
    nDescFam    := Posicione('ZA1',1,xFilial('ZA1') + cFamilia,'ZA1_DESCON')
    cItem       := GdFieldGet('C6_ITEM',n)

	// Independente do desconto máximo no cadastro de familia de produtos
	// Os usuários : Celso|Cleyton|Sardinha|Silvia 
	// podem aplicar desconto máximo de 20%. 
	// Dessa forma altero o percentual de desconto abaixo

	If cCodUser $ '000036|000078|000113|000190'
		nDescFam	:= 30
	Endif
		
	If cCodUser == '000034'
		nDescFam	:= 40
	Endif
	
    AAdd(aRet,cProd)
    AAdd(aRet,cFamilia)
    AAdd(aRet,nDescTot)
    AAdd(aRet,nDescFam)
    AAdd(aRet,cItem)
Return AClone(aRet)

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MA05DescOV(nPerDesc,nValor)
    Local cProd         := ''
    Local cFamilia      := ''
    Local cItem         := ''
    Local nDescFam      := 0
    Local nDescTot      := 1
    Local nDescI        := 0
    Local aRet          := {}
    Local cUsuario		:= RetCodUsr()
    Private nItem         := 1
    DEFAULT nValor := 0
 
	If ReadVar() $ 'M->CJ_DESC1'
		nPerDesc := 1 - nPerDesc
		nDescTot := M->CJ_DESC1 
	Else
		nPerDesc := 1 - nPerDesc
		nDescTot := M->CJ_DESC1 + M->CJ_DESC2  		
	    If Type('M->CK_DESCONT') == 'N'
    	    nDescI      := ( M->CK_DESCONT / 100)
    	Else
        	nDescI      := 1 - ( TMP1->(FieldGet(FieldPos('CK_DESCONT')))/ 100)
    	EndIf

		If Type('M->CK_DESCONT') == 'U'
			nDescI      := (nValor / TMP1->(FieldGet(FieldPos('CK_XVLTBRU')))) * 100
			nDescI		:= 100 - nDescI
			nDescTot    := nPerDesc * nDescI
		Else
	    	nDescTot    := nPerDesc + nDescI
	    	nDescTot    := (nDescTot * 100)		
		Endif

		If ReadVar() == "M->CJ_DESC1" .And. M->CJ_DESC1 == 0 
			nDescTot    := 100 - (nDescTot * 100)
		Endif

	    // nDescTot    := nPerDesc * nDescI
	Endif
	
    cProd       := TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
    cFamilia    := Posicione('SB1',1,xFilial('SB1') + cProd,'B1_XFAMILI' )
    nDescFam    := Posicione('ZA1',1,xFilial('ZA1') + cFamilia,'ZA1_DESCON')
    cItem       := TMP1->(FieldGet(FieldPos('CK_ITEM')))
    
	// Independente do desconto máximo no cadastro de familia de produtos
	// Os usuários : Celso|Sardinha|Silvia 
	// podem aplicar desconto máximo de 30%. 
	// Dessa forma altero o percentual de desconto abaixo
    If cUsuario $ '000036|000078|000113'
    	nDescFam	:= 30
    Endif
    
    If cUsuario == '000034'
    	nDescFam	:= 40
    Endif    

    AAdd(aRet,cProd)
    AAdd(aRet,cFamilia)
    AAdd(aRet,nDescTot)
    AAdd(aRet,nDescFam)
    AAdd(aRet,cItem)

Return AClone(aRet)
