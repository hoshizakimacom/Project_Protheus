#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Ponto de Entrada responsável pela validação das linhas no pedido de venda
// Bloqueio da utilização das operações 01, 02 e 38 em caso de utilização da
// Tabela de Preços GAR
// 
// *Autor: Wallace Manzini - 07/04/2025 (Chamado #8415)
//+------------------------------------------------------------------------------

User Function M410LIOK()

Local cCodOper      := BuscAcols('C6_OPER')
Local dEntrega      := BuscAcols('C6_ENTREG')
Local cCodTab       := SC5->C5_TABELA
Local cTipoVen      := Alltrim(SC5->C5_XTPVEN)
Local cCondPag      := SC5->C5_CONDPAG
Local lRet          := .T.

    
//+------------------------------------------------------------------------
// Verifique se a tabela de preços GAR com operações 01, 02 e 38.
//+------------------------------------------------------------------------
    
    If cCodOper $ "01|02|38" .and. cCodTab == "GAR"
            MsgStop('As operações 01, 02 e 38 estão indisponíveis para uso. Entre em contato com o departamento fiscal.','Atenção')
	    lRet := .F.
    EndIf

//+------------------------------------------------------------------------
// Verifique se o tipo de venda dealer + de 90 dias entrega. (Chamado #8431)
//+------------------------------------------------------------------------
If cTipoVen $ "3" .and. dEntrega > dDataBase + 90
    MsgStop('Tipo de Venda Dealer não pode ultrapassar o limite máximo de 90 dias. Entre em contato com a gerência comercial.','Atenção')
    lRet := .F.
EndIf

//+------------------------------------------------------------------------
// Verifique se a condição de pagamento 999 com operações 01, 02 e 38.
//+------------------------------------------------------------------------

    If AllTrim(cCodOper) $ "01|02|38" .and. cCondPag $ "999"
            MsgStop('As operações 01, 02 e 38 não podem ser usadas para condição de pagamento 999. Entre em contato com o departamento fiscal.','Atenção')
        lRet := .F.
    EndIf

//+------------------------------------------------------------------------------
// Verifique quais usuários podem usar as operações 07|08|09|10|E0|E1|03|04 e 36
//+------------------------------------------------------------------------------

    Do Case
        Case AllTrim(cCodOper) $ "07|08|09|10|E0|E1" .and. !RetCodUsr() $ "000000|000299|000080|000116|000012|000728|000695|000019|000379"
                MsgStop('As operações 07, 08, 09, 10, E0 e E1 é de uso exclusivo para transferências entre filiais. Obrigatório o uso da rotina de Solicit. Transf.','Atenção')
            lRet := .F.
        
        Case AllTrim(cCodOper) $ "03|04|36" .and. !RetCodUsr() $ "000000|000241|000131|000010|000773|000080|000116|000012|000670|000774|000728|000181|000175|000695|000019|000379|000513|000075|000328|000351|000278|000174|000113|000330|000090|000287|000028|000203|000150
            MsgStop('As operações 03, 04 e 36 estão indisponíveis para uso. Entre em contato com o departamento fiscal.','Atenção')
            lRet := .F.
    EndCase

Return lRet
