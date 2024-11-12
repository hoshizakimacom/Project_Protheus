#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//+--------------------------------------------------------------------------------------------
//| Validação do processo de orçamento de venda
//+--------------------------------------------------------------------------------------------

User Function A415LIOK()

Local lRet := .T.                                                               //Variável utilizada para controle e validação do item do orçamento

Local cUser     := RetCodUsr()                                                 // Usuário Logado
//Local cVende  	:= SA3->A3_COD
Local cVende  	:= SA3->A3_CODUSR
Local cCodProd  := SB1->B1_COD
Local cRepre    := Posicione("SB1",1,xFilial("SB1")+cCodProd    , "B1_XREP")   // Produto pode ou não ser vendido por Representante (B1_XREP = 1-Sim 2-Não)
//Local cCargo	:= Posicione("SA3",1,xFilial("SA3")+M->cVende   , "A3_CARGO")  // Cargo do Vendedor no Cadastro de Vendedores (000100 - Representante)
Local cCargo	:= Posicione("SA3",1,xFilial("SA3")+cVende      , "A3_CARGO")  // Cargo do Vendedor no Cadastro de Vendedores (000100 - Representante)

If cUser == cVende

    If cCargo == "000100" .And. cRepre == '2'       // Validação de Representante Comercial #7534

        lRet := .F.
        MsgInfo('Produtonão localizado.' + CRLF + 'Verifique!',{cCodProd},'Atenção')
    
    EndIf

EndIf

Return(lRet)
 