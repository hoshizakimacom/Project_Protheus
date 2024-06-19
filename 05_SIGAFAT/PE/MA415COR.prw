#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// PE Altera Textos e Cores da Legenda do Or�amento
//+------------------------------------------------------------------------------
User Function MA415COR()
    Local aCores    := {}
    Local aBkp     := ParamIXB
    Local nX       := 0

    If SCJ->(FieldPos('CJ_XCRED')) > 0
        AAdd(aCores, {"CJ_XCRED =='1'", 'BR_MARRON_OCEAN'}) // Or�amento Bloqueado por Cr�dito
        AAdd(aCores, {"CJ_XCRED =='2'", 'BR_VIOLETA'})      // Or�amento Desbloqueado por Cr�dito
    EndIf
    
    If SCJ->(FieldPos('CJ_XFWUST')) > 0
    	AADD(aCores, {"CJ_XFWUST == '1' .And. CJ_STATUS == 'A'", 'PMSEDT4'})		// Follow Up: Projeto Cancelado
    	AADD(aCores, {"CJ_XFWUST == '2' .And. CJ_STATUS == 'A'", 'PMSEDT1'})		// Follow Up: Perdido 
    	AADD(aCores, {"CJ_XFWUST == '3' .And. CJ_STATUS == 'A'", 'PMSEDT3'})		// Follow Up: Em Andamento    	
		AADD(aCores, {"CJ_XFWUST == '4' .And. CJ_STATUS == 'A'", 'PMSEDT2'})		// Follow Up: Substitu�do
    Endif
    
    For nX := 1 To Len(aBkp)
        AAdd(aCores    ,aBkp[nX])
    Next

Return AClone(aCores)