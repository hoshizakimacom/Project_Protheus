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
Local cCodTab       := SC5->C5_TABELA
Local lRet          := .T.

    If cCodOper $ "01|02|38" .and. cCodTab == "GAR"
            MsgStop('As operações 01, 02 e 38 estão indisponíveis para uso. Entre em contato com o departamento fiscal.','Atenção')
	    lRet := .F.
    EndIf

Return lRet
