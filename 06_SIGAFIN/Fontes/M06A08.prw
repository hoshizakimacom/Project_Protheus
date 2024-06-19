#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06A08   ³ Autor ³ Cleber Maldonado      ³ Data ³ 07/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera o código de autenticação nos títulos PVA            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M06A08()

Local _nOpc			:= 0
Local _cCodAut		:= Space(6)
Local _oDlg			:= Nil
Local _aArea		:= GetArea()
Local _cPicVal		:= '@!'
Local _cTitle		:= 'Insere Código de Autenticação'
Local _cCodPVA		:= SE1->E1_NUM

Define Dialog _oDlg From 000,000 To 155,350 Title _cTitle Pixel
	@015,020 Say  'Numero do PVA : ' Of _oDlg Colors CLR_GRAY Pixel
	@015,115 Say  _cCodPVA Of _oDlg Colors CLR_GRAY Pixel

	@033,020 Say  'Código de Autenticação : ' Of _oDlg Pixel
	@030,100 MsGet _cCodAut Size 055,011 Of _oDlg Pixel Picture _cPicVal

	@057,050 BUTTON "Aplicar" SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(!Empty(_cCodAut),(_nOpc := 1,_oDlg:End()), ))
	@057,095 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
Activate MsDialog _oDlg Centered

If _nOpc > 0
	FWMsgRun(, {|| U_MA06AUT(_cCodAut,_cCodPVA) },,'Inserindo código de autenticação ...')
EndIf

RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA06AUT   ³ Autor ³ Cleber Maldonado     ³ Data ³ 07/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa gravação do código do código de autenticação.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06AUT(_cCodAut,_cCodPVA)


Local cAliasQry		:= GetNextAlias()
Private lRet			:= .T.

DEFAULT _cCodAut	:= ''
DEFAULT _cCodPVA	:= ''

If !Empty(_cCodAut) .And. !Empty(_cCodPVA) 
	BeginSql Alias cAliasQry

		SELECT 
			E1_FILIAL,E1_NUM,E1_PEDIDO,E1_XCODAUT,R_E_C_N_O_
		FROM 
			%Table:SE1% SE1
		WHERE 
			SE1.E1_FILIAL = '01' AND
			SE1.E1_NUM = %Exp:_cCodPVA% AND
			SE1.%NotDel%
		ORDER BY SE1.E1_NUM
	EndSql 

	dbSelectArea("SE1")
	dbSetOrder(1)

	While (cAliasQry)->(!Eof())
		SE1->(dbGoto((cAliasQry)->R_E_C_N_O_))
		If Empty(SE1->E1_XCODAUT)
			Reclock("SE1",.F.)
			SE1->E1_XCODAUT := _cCodAut
			MsUnlock()
			Sleep(150)
		Endif
		(cAliasQry)->(dbSkip())
	End
Endif

(cAliasQry)->(dbCloseArea())

Return
