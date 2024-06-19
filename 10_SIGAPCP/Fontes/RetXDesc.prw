#INCLUDE "PROTHEUS.CH"

User Function RetXDesc(cCampo)

Local cRet := ""

Default cCampo := ""
 
 Do Case
 	Case cCampo == 'B1_DESC'
       	cRet := POSICIONE("SB1", 1, xFilial("SB1") + SC6->C6_PRODUTO, "B1_DESC") 	 
    Case cCampo == 'B1_TIPO' 
        cRet := Posicione("SB1",1, xFilial("SB1") + SC6->C6_PRODUTO, "B1_TIPO")  
    Case cCampo == 'B1_XFABRIC'
        cRet := Posicione("SB1",1, xFilial("SB1") + SC6->C6_PRODUTO, "B1_XFABRIC")	
	Case cCampo == 'G1_XUM'
	    cRet := Posicione("SB1",1, xFilial("SB1") + SG1->G1_COMP, "B1_UM")
	Case cCampo == 'G1_XPICLIS'
	    cRet := Posicione("SB1",1, xFilial("SB1") + SG1->G1_COMP, "B1_XPICLIS")
	    
	    If cRet == '1'
	         cRet := "Sim"
	    Else
	         cRet := "Nao"
	    Endif
EndCase

If cRet=='1'
	cRet:="GUARULHOS"
ElseIf cRet == '2' 
	cRet:="PORTO FELIZ"
ElseIf cRet == '3'
	cRet := "MISTO"
Endif

Return cRet