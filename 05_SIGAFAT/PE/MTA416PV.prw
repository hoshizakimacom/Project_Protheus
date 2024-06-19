#Include 'Protheus.ch'


//+----------------------------------------------------------------------------------
//	Executado apos o preenchimento do aCols na Baixa do Orcamento de Vendas.
//+----------------------------------------------------------------------------------
User Function MTA416PV()
	Local _aArea	:= GetArea()

	//+------------------------------------------------------------
	//	Respons�vel pelo preenchimento dos campos customizados
	//	do or�amento para o pedido de venda ao "Aprovar Venda"
	//+------------------------------------------------------------
	U_M05A05(PARAMIXB)

	RestArea(_aArea)
Return

