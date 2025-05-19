#Include "TOTVS.CH"
#Include "TOPCONN.CH"

/*Relaciona campos que não devem ser copiados na inclusão de um novo orçamento.
Wallace Manzini - 15/05/2025*/

User Function M415COPIA()

Local lRet := .T.

	If SCJ->CJ_CLIENTE <> 'XXXXXX'
   	    SCJ->CJ_CLIENTE := " "          
	Else   
		
		lRet := .F.     
	EndIf

    If SCJ->CJ_LOJA <> 'XX'
   	    SCJ->CJ_LOJA := " "          
	Else   
		
		lRet := .F.     
	EndIf

    If SCJ->CJ_TABELA <> 'XXX'
   	    SCJ->CJ_TABELA := " "          
	Else   
		
		lRet := .F.     
	EndIf

Return(lRet)
