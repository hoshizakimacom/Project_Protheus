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
Local lRet          := .T.

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

Return lRet
