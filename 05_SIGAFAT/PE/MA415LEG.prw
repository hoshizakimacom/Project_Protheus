#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// PE Altera Textos e Cores da Legenda do Or�amento
//+------------------------------------------------------------------------------
User Function MA415LEG()
    Local aCores := PARAMIXB

    aAdd(aCores, {'BR_MARRON_OCEAN' ,'Or�amento Bloqueado por Cr�dito'})
    aAdd(aCores, {'BR_VIOLETA'      ,'Or�amento Desbloqueado por Cr�dito'})
    aAdd(aCores, {'PMSEDT4'			,'Follow Up: Projeto Cancelado'})	// 1 Vermelho 
    aAdd(aCores, {'PMSEDT1'			,'Follow Up: Perdido'})				// 4 Cinza
    aAdd(aCores, {'PMSEDT3'			,'Follow Up: Em Andamento'})		// 3 Verde
    aAdd(aCores, {'PMSEDT2'     	,'Follow Up: Substitu�do'})			// 2 Amarelo ??

Return AClone(aCores)