#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//+--------------------------------------------------------------------------------------------
//| Validação do processo de orçamento de venda
//+--------------------------------------------------------------------------------------------

User function A415LIOK()

Local lRet := .T.                                                          //Variável utilizada para controle e validação do item do orçamento

Local cVende  	:= SA3->A3_COD
Local cCodProd  := SB1->B1_COD
Local cRepre    := Posicione("SB1",1,xFilial("SB1")+cCodProd, "B1_XREP")    // Produto pode ou não ser vendido por Representante
Local cVend1    := Posicione("SCJ",1,xFilial("SCJ")+cVende  , "CJ_XVEND1")  // Vendor 1 no Orçamento
Local cCargo	:= Posicione("SA3",1,xFilial("SA3")+cVend1  , "A3_CARGO")   // Cargo do Vendedor no Cadastro de Vendedores

If cCargo == "000091" .And. cRepre == '1'

    lRet := .F.

    MsgInfo('Produto não localizado.Verifique!','Atenção')

EndIf

Return(lRet)
