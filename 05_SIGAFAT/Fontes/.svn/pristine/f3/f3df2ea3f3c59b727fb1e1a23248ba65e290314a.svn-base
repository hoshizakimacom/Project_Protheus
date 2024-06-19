#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//  rotina chamada do SX3 campo C5_XNDEXUZ
//+---------------------------------------------------------------------------------------------------------
User Function M05A32(cTipo)
Local aArea     := GetArea()
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSA2  := SA2->(GetArea())
Local aAreaSX3  := SX3->(GetArea())
Local aAreaSX2  := SX2->(GetArea())
Local cRet      := ''
Local cTipoPV   := ''

Default cTipo   := ''

Do Case
	Case cTipo = 'NOME'

		If Type('M->C5_TIPO') == 'C'
			cTipoPV   := M->C5_TIPO   // N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=Utiliza Fornecedor

       	    If cTipoPV $ 'D-B'
           	    cRet    := Posicione('SA2',1,XFILIAL('SA2')+M->C5_CLIENTE+M->C5_LOJACLI,'A2_NOME')
			Else
    	        cRet    := Posicione('SA1',1,XFILIAL('SA1')+M->C5_CLIENTE+M->C5_LOJACLI,'A1_NOME')
        	EndIf
        EndIf

        If Type('SC5->C5_TIPO') == 'C'
   	        cTipoPV   := SC5->C5_TIPO   // N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=Utiliza Fornecedor

       	    If cTipoPV $ 'D-B'
           	    cRet    := Posicione('SA2',1,XFILIAL('SA2')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A2_NOME')
            Else
            	If Empty(M->C5_CLIENTE)
   	            	cRet    := Posicione('SA1',1,XFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')
   	            Endif
       	    EndIf
        EndIf

   	Case cTipo = 'X3_RELACAO'
        cTipoPV   := M->C5_TIPO   // N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=Utiliza Fornecedor

   	    If cTipoPV $ 'D-B'
       	    cRet    := Posicione('SA2',1,XFILIAL('SA2')+M->C5_CLIENTE+M->C5_LOJACLI,'A2_NREDUZ')
        Else
   	        cRet    := Posicione('SA1',1,XFILIAL('SA1')+M->C5_CLIENTE+M->C5_LOJACLI,'A1_NREDUZ')
        EndIf

    Case cTipo = 'X3_INIBRW'
   	    cTipoPV   := SC5->C5_TIPO   // N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Cocmpras;B=Utiliza Fornecedor

        If cTipoPV $ 'D-B'
            cRet    := Posicione('SA2',1,xfilial('SA2')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A2_NREDUZ')
   	    Else
       	    cRet    := Posicione('SA1',1,xfilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')
        EndIf
EndCase

RestArea(aAreaSX2)
RestArea(aAreaSX3)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aArea)

If IsInCallStack('A410INCLUI') .And. Empty(M->C5_CLIENTE) 
	cRet :=""
Endif

Return cRet