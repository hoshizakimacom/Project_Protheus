#Include 'Protheus.ch'

User Function PE01NFESEFAZ()
    Local aRet      := ParamIXB
    Local cTipo     := If(aRet[5][4] = "1", "S", "E") //Tipo de Nota: 1 – Saída, 2 – Entrada
    Local aArea     := GetArea()
    Local aAreaSC5  := SC5->(GetArea())
    Local cCodFun   := ""
    Local cDescDpto := ""

//    ParamIXB[01] aProd
//    ParamIXB[02] cMensCli
//    ParamIXB[03] cMensFis
//    ParamIXB[04] aDest
//    ParamIXB[05] aNota
//    ParamIXB[06] aInfoItem
//    ParamIXB[07] aDupl
//    ParamIXB[08] aTransp
//    ParamIXB[09] aEntrega
//    ParamIXB[10] aRetirada
//    ParamIXB[11] aVeiculo
//    ParamIXB[12] aReboque

    If cTipo == 'S'
        aRet[02] :=  aRet[02] + ' Pedido de Venda: ' + SC6->C6_NUM + '. '

        SC5->(DbSetOrder(1))
        SC5->(DbGoTop())

        If  SC5->(DbSeek( xFilial('SC5')  + SC6->C6_NUM )) .And.  !Empty(SC5->C5_XCOTCLI)
            aRet[02] :=  aRet[02] + ' Ordem de Compra: ' + AllTrim(SC5->C5_XCOTCLI) + '. '
             
            If !Empty(SC5->C5_XPEDCEN) 
            	aRet[02] :=  aRet[02] + ' Pedido Central : ' + AllTrim(SC5->C5_XPEDCEN) + '. '
            Endif
            
			If SC5->C5_CLIENTE == AllTrim(GetMv("AM_CLIMCD"))  // '002953'
	            // Altero o e-mail de destino para o cliente Arcos Dourados de acordo com o departamento
    	        // do contato.
			    cCodFun		:= Posicione("SU5",1,xFilial("SU5")+SC5->C5_XCONT,"U5_FUNCAO")
			    cDescDpto	:= Posicione("SUM",1,xFilial("SUM")+cCodFun,"UM_DESC") 
		
	            If !Empty(cDescDpto)
    	        	If Substr(cDescDpto,1,3) $ "ENG"
        	    		aRet[4,16] := "ENG_RECEBIMENTO.NOTAS.FISCAIS@BR.MCD.COM"
	            	Else
    	        		aRet[4,16] := "NFE.CAPEX@BR.MCD.COM"
        	    	Endif
            	Endif
        	EndIf
	    EndIf
	Endif

RestArea(aAreaSC5)
RestArea(aArea)

Return aClone(aRet)
