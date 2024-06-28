#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
// Função chamada de gatilho no campo de Cliente para preencher Dados do Pedido De Transferencia
// entre filiais - Acos Macom - 21/06/24 - Marcos Rocha   
//+------------------------------------------------------------------------------------------------
User Function M05G06(cField)

// Transferência Entre Unidades
If Left(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CGC"),8) == Left(SM0->M0_CGC,8)
    M->C5_XTPINST :=  "1"       // Sem Instalacao
    M->C5_XCOTCLI := "TRANSF. ENTRE FILIAIS"  // Ordem Compra
    M->C5_FECENT  := dDataBase  // Dt. Entrega
    M->C5_XTPVEN  := "1"        // Projeto
    M->C5_XFINAME := "2"        // Não
    M->C5_CLIENT  := M->C5_CLIENTE       // Não
EndIf

Return(cField)
