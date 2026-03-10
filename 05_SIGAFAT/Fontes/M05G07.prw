#include "Totvs.ch"

/*/{Protheus.doc} M05G07
Gatilhos no pedido de Venda

@type function
@author	Jorge Heitor T. de Oliveira
@since 06/06/2023
@version P12
@database MSSQL

/*/
User Function M05G07(cField, cCDom)
    Local cTipoVen
    Local xReturn

    cTipoVen := AllTrim(cValToChar(M->C5_XTPVEN))

    If cField == "C6_PRODUTO" .And. cCDom == "C6_LOCAL" .And. !Empty(cTipoVen)
        If cTipoVen $ "7/8" //Caso seja pedido de venda de Peças ou Suporte
            xReturn := "36" //Futuramente trocar para parâmetro

        Else //Para os demais casos, utiliza o Armazém Padrão do próprio Produto
            xReturn := Posicione("SB1", 1, FWxFilial("SB1") + M->C6_PRODUTO, "B1_LOCPAD")

        EndIf

    EndIf

Return xReturn
