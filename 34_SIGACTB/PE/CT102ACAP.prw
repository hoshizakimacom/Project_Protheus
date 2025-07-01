#INCLUDE "PROTHEUS.CH"

//+-------------------------------------------------------------------------------------------------------------
//| PE para inclusao automática do Lote e SubLote quando inserido Lançamento Contábil Manualmente
//+-------------------------------------------------------------------------------------------------------------

User Function CT102ACAP()
 
    Local aRet := {}   
    Local cLote := ' '
    Local cSublote := ' '
     
    
    Do Case
        Case RetCodUsr() == "000131"    //usuário: Wallace Manzini
        cLote := "002900"               //matrícula: 002900

        Case RetCodUsr() == "000508"    //usuáiro: Henrique Borges
        cLote := "002724"               //matrícula: 002724

        Case RetCodUsr() == "000766"    //usuário: Ana Paula Martins Pimentel
        cLote := "003045"               //matrícula: 003045

        Case RetCodUsr() == "000014"    //usuário: Bárbara Sobreira Campos
        cLote := "002219"               //matrícula: 002219

        Case RetCodUsr() == "000010"    //usuário: Cibele Coladello Moraes
        cLote := "001923"               //matrícula: 001923
    EndCase
    
    aAdd(  aRet ,  cLote )
    aAdd(  aRet , cSublote )
        
 
Return aRet
