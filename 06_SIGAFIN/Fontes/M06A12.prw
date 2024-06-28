#Include "TOTVS.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} ClassTituloCRA

Classe  para inclusão/exclusão de titulo de credito CRA quando da baixa/exclusao de baixa de um titulo PVA - (Recebimento Antecipado de Pedido de Venda)

@type class
@author Marcos Antonio Montes
@since 21/03/2024
/*/
Class ClassTituloCRA

    Data cMsgError As String
	Data lTransaction As Logic

    Method New() Constructor
    Method Inclui() 
    Method Exclui() 
    Method Compensa() 
    Method RetError() 

EndClass

/*/{Protheus.doc} newClassTituloCRA

Método Construtor

@type method
@author Marcos Antonio Montes
@since 21/03/2024
/*/
Method New() Class ClassTituloCRA

::cMsgError := ""
::lTransaction := .T.

Return Self


/*/{Protheus.doc} newClassTituloCRA

Inclui titulo CRA com base no titulo PVA posicionado

@type method
@author Marcos Antonio Montes
@since 21/03/2024
/*/
Method Inclui() Class ClassTituloCRA

Local lRet    := .F.
Local aFin040 := {}
Private lMsErroAuto := .F. // variavel interna da rotina automatica	   	
Private lMsHelpAuto := .F.

If SE1->E1_TIPO == "BOL" .And. SE1->E1_PREFIXO == "PVA" .And. SE5->E5_MOTBX $ "NOR/CAC/BND/FIN" .And. SE5->E5_TIPODOC $ "VL/V2/BA"

    dbSelectArea("SE1")
	dbSetOrder(1)
				
    aFin040 := { {"E1_PREFIXO"   ,"PVA"          ,nil},;
					{"E1_NUM"    ,SE1->E1_NUM    ,nil},;
					{"E1_PARCELA",SE1->E1_PARCELA,nil},;
					{"E1_TIPO"   ,"CRA"          ,nil},;
					{"E1_NATUREZ",SE1->E1_NATUREZ,nil},;
					{"E1_CLIENTE",SE1->E1_CLIENTE,nil},;
					{"E1_LOJA"   ,SE1->E1_LOJA   ,nil},;
					{"E1_PEDIDO" ,SE1->E1_PEDIDO ,nil},;
					{"E1_EMISSAO",SE5->E5_DATA   ,nil},;
					{"E1_VENCTO" ,SE5->E5_DATA   ,nil},;
					{"E1_VENCREA",SE5->E5_DATA   ,nil},;
					{"E1_VALOR"  ,SE1->E1_VALOR  ,nil} } //Considera valor do PVA na geração do CRA não considera desconto ou acréscimo

	lMsErroAuto := .F. // variavel interna da rotina automatica	   	
	lMsHelpAuto := .F.	
	If ::lTransaction
		Begintran()
	EndIf
		MSExecAuto({|x,y| FINA040(x,y)},aFIN040,3)
		If lMsErroAuto
			//MostraErro()
		    ::cMsgError := "Erro na Inclusão do Titulo do Contas a Receber -> "+aFIN040[1,2]+"-"+aFIN040[2,2]+"/"+aFIN040[3,2]+"-"+aFIN040[4,2]
            lRet := .F.
        Else
            lRet := .T.
		Endif
	If ::lTransaction
		If !lRet
			DisarmTransaction()
		Else
			Endtran()
		EndIf
	EndIf
EndIf

Return lRet

/*/{Protheus.doc} newClassTituloCRA

Exclui titulo CRA com base no titulo PVA posicionado

@type method
@author Marcos Antonio Montes
@since 21/03/2024
/*/
Method Exclui() Class ClassTituloCRA

Local lRet     := .F.
Local aFina040 := {}

Private lMsErroAuto := .F. // variavel interna da rotina automatica	   	
Private lMsHelpAuto := .F.	

If SE1->E1_TIPO == "BOL" .And. SE1->E1_PREFIXO == "PVA" .And. SE5->E5_MOTBX  $ "NOR/CAC/BND/FIN"

    dbSelectArea("SE1")
	dbSetOrder(1)
				
    aFina040 := {   {"E1_PREFIXO","PVA"          ,nil},;
					{"E1_NUM"    ,SE1->E1_NUM    ,nil},;
					{"E1_PARCELA",SE1->E1_PARCELA,nil},;
					{"E1_TIPO"   ,"CRA"          ,nil} }
                		
	lMsErroAuto := .F. // variavel interna da rotina automatica	   	
	lMsHelpAuto := .F.	
	If ::lTransaction
		BeginTran() 
	EndIf
    
		MSExecAuto({|x,y| FINA040(x,y)},aFina040,5)
	    If lMsErroAuto
		    ::cMsgError := "Erro na Exclusao do Titulo do Contas a Receber -> "+aFina040[1,2]+"-"+aFina040[2,2]+"/"+aFina040[3,2]+"-"+aFina040[4,2]
		    lRet := .F.
        Else
            lRet := .T.
	    EndIf

	If ::lTransaction
		If !lRet
			DisarmTransaction()
		Else
			Endtran()
		EndIf
	EndIf
EndIf

Return lRet

/*/{Protheus.doc} newClassTituloCRA

Verifica a existencia de titulo CRA com saldo e NF para compensação

@type method
@author Marcos Antonio Montes
@since 25/04/2024
/*/
Method Compensa(cPedido) Class ClassTituloCRA

Local lRet      := .T.
Local aArea     := GETAREA()
Local cAliasQry := GetNextAlias()
Local aTitDEB   := {}
Local aTitCRD   := {}
Local cLoteCTB	:= LoteCont("FIN")
Local lContabil := .F.
Local lComisNCC := .F.
Local nDEB      := 0
Local nCRD      := 0

If !EMPTY(cPedido)

	dbSelectArea("SE1")
	dbSetOrder(1)

	BeginSql Alias cAliasQry

		SELECT SE1.R_E_C_N_O_ RECSE1
		FROM %table:SE1% SE1
		WHERE   E1_FILIAL = %xfilial:SE1% AND
				E1_PEDIDO = %exp:cPedido% AND
				E1_TIPO IN ('NF ','CRA') AND
				E1_SALDO > 0 AND
				E1_EMISSAO <= %exp:DTOS(dDataBase)% AND
				%notDel%
				ORDER BY E1_EMISSAO, E1_VENCTO
	EndSql

	(cAliasQry)->(DbGoTop())
	While (cAliasQry)->(!Eof())

		SE1->(dbGoTo((cAliasQry)->RECSE1))
		
		aTitulo := {}

		If SE1->E1_TIPO == "NF "
			
			aAdd(aTitulo, SE1->(RECNO())    )	//Recno SE1 - TIPO NF

			aAdd(aTitDEB,ACLONE(aTitulo))

		ElseIf SE1->E1_TIPO == "CRA"

			nVlrAcmp  := SE1->E1_SALDO //Round(xMoeda(nVlrACmp,1,nMoeda,,3,,nTaxaCM),2)
			nVlAbat   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			nTxMoedNf := 1
			nTaxaRA   := 1

			aAdd(aTitulo, SE1->(RECNO())    )	//CMP_RECNO  1 - Recno SE1
			aAdd(aTitulo, nVlrAcmp          )	//CMP_VLRCMP 2 - Valor a Compensar
			aAdd(aTitulo, nVlAbat           )   //CMP_VLABAT 3
			aAdd(aTitulo, dDataBase         )   //CMP_DTREC  4
			aAdd(aTitulo, cLoteCtb          )   //CMP_LOTE   5
			aAdd(aTitulo, NIL               )   //CMP_DATAP  6
			aAdd(aTitulo, nTxMoedNf         )   //CMP_TAXAP  7
			aAdd(aTitulo, 2                 )   //CMP_NUMDEC 8
			aAdd(aTitulo, NIL               )   //CMP_GRCONT 9
			aAdd(aTitulo, nTaxaRA           )   //CMP_TAXAD  10
			aAdd(aTitulo, nVlrAcmp          )

			aAdd(aTitCRD,ACLONE(aTitulo))

		EndIf

		(cAliasQry)->(DbSkip())
	EndDo

	(cAliasQry)->(DbCloseArea())

	/*

		Efetua a Compensação dos titulos de Credito e Debito do Pedido

	*/
	If LEN(aTitDEB) > 0 .And. LEN(aTitCRD) > 0

		For nDEB := 1 To LEN(aTitDEB)

			SE1->(dbGoTo(aTitDEB[nDEB][1]))

			If SE1->E1_SALDO > 0

				nAbatm   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				
				For nCRD := 1 To LEN(aTitCRD) 				

					nRecRA   := aTitCRD[nCRD][1]
					nSaldoCR := aTitCRD[nCRD][2]
					If nSaldoCR > (SE1->E1_SALDO - nAbatm)
						nSaldoCR := (SE1->E1_SALDO - nAbatm)
					EndIf

					If nSaldoCR > 0
				
						aTitulo    := { nAbatm, 0, 0, 0 }
						aCompensar := { { nRecRA, nSaldoCR, 0, Nil, Nil, Nil, Nil, Nil,Nil, Nil, 0 /*Nil*/} }
						lRet := FaCmpCR(aTitulo,aCompensar,lContabil,lComisNCC,Nil,NIL/*bContabil*/,NIL/*bBlock*/,,NIL/*cProcComp*/)
						If !lRet
		    				::cMsgError := "Falha na compensação de titulos CRA para o pedido "+cPedido+"."
						Else
					 		aTitCRD[nCRD][2] -= nSaldoCR
						EndIf
					
					EndIf

				Next

			EndIf

		Next

	EndIf

EndIf

RESTAREA(aArea)

Return lRet

/*/{Protheus.doc} newClassTituloCRA

Retorna msg de erro na inclusao ou exclusão de um titulo CRA

@type method
@author Marcos Antonio Montes
@since 21/03/2024
/*/
Method RetError() Class ClassTituloCRA

Return ::cMsgError
