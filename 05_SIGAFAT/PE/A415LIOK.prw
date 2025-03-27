#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//+--------------------------------------------------------------------------------------------
//| Validação do processo de orçamento de venda
//+--------------------------------------------------------------------------------------------

User Function A415LIOK()

Local lRet := .T.                                                                       //Variável utilizada para controle e validação do item do orçamento

Local cUser     := RetCodUsr()                                                          // Usuário Logado
Local cCargo  	:= Posicione("SA3",7,xFilial("SA3")+ cUser              , "A3_CARGO")
Local cCodProd  := TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
Local cRepre    := Posicione("SB1",1,xFilial("SB1")+ cCodProd           , "B1_XREP")   // Produto pode ou não ser vendido por Representante (B1_XREP = 1-Sim 2-Não)

    If cCargo == "000100" .And. cRepre == '2'       // Validação de Representante Comercial #7534 (000100 = Produção/ 000091 = Teste)

        lRet := .F.
        MsgInfo(I18N('Produto não permitido.' + CRLF + 'Verifique!',{cCodProd},'Atenção'))
    
    EndIf

Return(lRet)
