//+------------------------------------------------------------------------------
// Ponto de Entrada responsável pela validação das linhas no pedido de venda
// Bloqueio da utilização das operações 01, 04, 08, 09, 10, 36, E0 e E1 em caso
// de utilização de pedidos de venda com transferência para filiais
// 
// *Autor: Wallace Manzini - 10/12/2025 (Chamado 9863)
//+------------------------------------------------------------------------------

User Function M410LIOK()

Local cCodOper              := BuscAcols('C6_XOPER')
Local lRet                  := .T.
//Local cPadrao  	            := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XPADRAO")		//1=Sim 2=Não - #10303
//Local cItDesv  	            := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XITDESE")		//S=Sim N=Não - #10303

    Do Case
    Case AllTrim(cCodOper) $ "07|08|09|10|E0|E1" .and. !RetCodUsr() $ "000000|000299|000080|000116|000012|000728|000695|000019|000379"
            MsgStop('As operações 07, 08, 09, 10, E0 e E1 é de uso exclusivo para transferências entre filiais. Obrigatório o uso da rotina de Solicit. Transf.','Atenção')
        lRet := .F.
    
    Case AllTrim(cCodOper) $ "03|04|36" .and. !RetCodUsr() $ "000000|000241|000131|000010|000773|000080|000116|000012|000670|000774|000728|000181|000175|000695|000019|000379|000513|000075|000328|000351|000278|000174|000113|000330|000090|000287|000028|000203|000150
           MsgStop('As operações 03, 04 e 36 estão indisponíveis para uso. Entre em contato com o departamento fiscal.','Atenção')
        lRet := .F.
    
    EndCase


   /* If  cPadrao == "2" .and. cItDesv == "S"
        Reclock("SB1",.F.)
        SB1->B1_XESPLIB := "1"
        MsUnlock()
    EndIf */
    
Return lRet
