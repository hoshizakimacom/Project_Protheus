#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// PE Altera Textos e Cores da Legenda do Orçamento
//+------------------------------------------------------------------------------
User Function MA415LEG()
    Local aCores := PARAMIXB

    aAdd(aCores, {'BR_MARRON_OCEAN' ,'Orçamento Bloqueado por Crédito'})
    aAdd(aCores, {'BR_VIOLETA'      ,'Orçamento Desbloqueado por Crédito'})
    aAdd(aCores, {'PMSEDT4'			,'Follow Up: Projeto Cancelado'})	// 1 Vermelho 
    aAdd(aCores, {'PMSEDT1'			,'Follow Up: Perdido'})				// 4 Cinza
    aAdd(aCores, {'PMSEDT3'			,'Follow Up: Em Andamento'})		// 3 Verde
    aAdd(aCores, {'PMSEDT2'     	,'Follow Up: Substituído'})			// 2 Amarelo ??

Return AClone(aCores)