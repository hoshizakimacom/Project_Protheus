#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝ
»±±±±ºPrograma  ³M28A01  ºAutor  ³Vendas Clientes     º Data ³  20/01/11  º±±±±
ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹
±±±±ºDesc.     ³ Cria a base instalada atraves de rotina automatica         º
±±±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹
±±±±ºUso       ³ Field Service                                              º
±±±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M28A01(_cFilial,_cCodCli,_cLoja,_cCodPro,_cNumSer,_dEmissao,_dNota,_dNumPV)
Local aCab040   := {}    // Cabecalho do AA3
Local aItens040 := {}    // Itens AA4
Local lRet      := .T.   
Private nRegs     := 0
Private dData     := DDATABASE

PRIVATE lMsErroAuto := .F.


Aadd(aCab040, { "AA3_FILIAL",   _cFilial,   NIL } )                
Aadd(aCab040, { "AA3_CODCLI",   _cCodCli,   NIL } )                
Aadd(aCab040, { "AA3_LOJA",     _cLoja,     NIL } )                
Aadd(aCab040, { "AA3_CODPRO",   _cCodPro,   NIL } )                
Aadd(aCab040, { "AA3_NUMSER",   _cNumSer,   NIL } )                 
Aadd(aCab040, { "AA3_DTVEN",    _dEmissao,  NIL } )
Aadd(aCab040, { "AA3_XNOTA",    _dNota,     NIL } )
Aadd(aCab040, { "AA3_XNUMPV",   _dNumPV,    NIL } )
TECA040(,aCab040,aItens040,3)                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                
//³VerIfica se houveram erros durante a geracao da base   ³                
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
    
//If lMsErroAuto                               
//   lRet := !lMsErroAuto                
//Endif                                                                               
aCab040 := {}
Return lRet
