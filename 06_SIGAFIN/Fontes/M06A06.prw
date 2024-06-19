#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06A03   ³ Autor ³ Cleber Maldonado      ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera o histórico dos títulos PVA de acordo com o numero  ³±±
±±³          ³ do pedido.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M06A06()

Local _nOpc			:= 0
Local _cHist		:= Space(20)
Local _oDlg			:= Nil
Local _aArea		:= GetArea()
Local _cPicVal		:= '@!'
Local _cTitle		:= 'Altera Histórico'
Local _cPedido		:= SE1->E1_PEDIDO

Define Dialog _oDlg From 000,000 To 155,350 Title _cTitle Pixel
	@015,020 Say  'Numero do pedido : ' Of _oDlg Colors CLR_GRAY Pixel
	@015,115 Say  _cPedido Of _oDlg Colors CLR_GRAY Pixel

	@033,020 Say  'Novo Histórico : ' Of _oDlg Pixel
	@030,100 MsGet _cHist Size 055,011 Of _oDlg Pixel Picture _cPicVal

	@057,050 BUTTON "Aplicar" SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(!Empty(_cHist),(_nOpc := 1,_oDlg:End()), ))
	@057,095 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
Activate MsDialog _oDlg Centered

If _nOpc > 0
	FWMsgRun(, {|| U_MA06Hist(_cHist,_cPedido) },,'Atualizando Histórico ...')
EndIf

RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06PROC   ³ Autor ³ Cleber Maldonado     ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa alteração do histórico dos títulos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06Hist(_cHist,_cPedido)


Local cAliasQry	:= GetNextAlias()
Private lRet		:= .T.

DEFAULT _cHist	:= ''
DEFAULT _cPedido:= ''

If !Empty(_cHist) .And. !Empty(_cPedido) 
	BeginSql Alias cAliasQry

		SELECT 
			E1_FILIAL,E1_NUM,E1_PEDIDO,E1_HIST,R_E_C_N_O_
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL = '01' AND
			SE1.E1_PEDIDO = %Exp:_cPedido% AND
			SE1.%NotDel%
		ORDER BY SE1.E1_PEDIDO
	EndSql 

	dbSelectArea("SE1")
	dbSetOrder(1)

	While (cAliasQry)->(!Eof())
		SE1->(dbGoto((cAliasQry)->R_E_C_N_O_))
		If Empty(SE1->E1_HIST)
			Reclock("SE1",.F.)
			SE1->E1_HIST := _cHist
			MsUnlock()
		Endif
		(cAliasQry)->(dbSkip())
	End
Endif

(cAliasQry)->(dbCloseArea())

Return
