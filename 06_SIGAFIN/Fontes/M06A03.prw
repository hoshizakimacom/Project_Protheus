#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06A03   ³ Autor ³ Cleber Maldonado      ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera o vendedor da comissão                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M06A03()

Local _nOpc			:= 0
Local _cValor		:= Space(6)
Local _oDlg			:= Nil
Local _aArea		:= GetArea()
Local _cPicVal		:= '@E 999999'
Local _cTitle		:= 'Altera Vendedor'

If !Empty(Dtos(SE3->E3_DATA))
	MsgAlert('Não é possível alterar o vendedor para uma comissão baixada!','Atenção')
Else
	Define Dialog _oDlg From 000,000 To 155,350 Title _cTitle Pixel
		@015,020 Say  'Código de Vendedor Atual : ' Of _oDlg Colors CLR_GRAY Pixel
		@015,115 Say  SE3->E3_VEND Of _oDlg Colors CLR_GRAY Pixel

		@033,020 Say  'Novo Código de Vendedor : ' Of _oDlg Pixel
		@030,100 MsGet _cValor Size 055,011 Of _oDlg Pixel Valid U_ValidVen(_cValor) F3 'SA3' Picture _cPicVal

		@057,050 BUTTON "Aplicar" SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(!Empty(_cValor),(_nOpc := 1,_oDlg:End()), ))
		@057,095 BUTTON "Cancelar" 	SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
	Activate MsDialog _oDlg Centered

	If _nOpc > 0
		U_MA06Proc(_cValor)
	EndIf

	RestArea(_aArea)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06PROC   ³ Autor ³ Cleber Maldonado     ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa alteração do vendedor da comissão                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06Proc(cCodVen)


Local lErro		:= .F.
Local cCodOld	:= SE3->E3_VEND
Private lRet		:= .T.

If !Empty(cCodVen)
	// Altera o código do vendedor na comissão
	Reclock('SE3',.F.)
    SE3->E3_VEND := cCodVen
    MsUnlock()
    
    // Altera o código do vendedor no título
    dbSelectArea('SE1')
    dbSetOrder(1)  // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
    
    If MsSeek(xFilial('SE1')+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
    	RecLock('SE1',.F.)
    	Do Case
    		Case SE1->E1_VEND1 == cCodOld
    			 SE1->E1_VEND1 := cCodVen
    			
    		Case SE1->E1_VEND2 == cCodOld
    			 SE1->E1_VEND2 := cCodVen 
    			
    		Case SE1->E1_VEND3 == cCodOld
    			 SE1->E1_VEND3 := cCodVen
    			
    		Case SE1->E1_VEND4 == cCodOld
    			 SE1->E1_VEND4 := cCodVen
    			 
    		Case SE1->E1_VEND5 == cCodOld
				 SE1->E1_VEND5 := cCodVen
		EndCase
    	MsUnlock()
	Else
		MsgAlert("Erro ao localizar o título original para troca do vendedor.","Atenção!")
		lErro	:= .T.		
    Endif
    
	// Altera o código do vendedor no pedido de vendas
    dbSelectArea('SC5')
	dbSetOrder(1)
	
    If MsSeek(xFilial('SC5')+SE3->E3_PEDIDO)
    	RecLock('SC5',.F.)	
    	Do Case
    		Case SC5->C5_VEND1 == cCodOld
    			 SC5->C5_VEND1 := cCodVen
    			
    		Case SC5->C5_VEND2 == cCodOld
    			 SC5->C5_VEND2 := cCodVen 
    			
    		Case SC5->C5_VEND3 == cCodOld
    			 SC5->C5_VEND3 := cCodVen
    			
    		Case SC5->C5_VEND4 == cCodOld
    			 SC5->C5_VEND4 := cCodVen
    			 
    		Case SC5->C5_VEND5 == cCodOld
				 SC5->C5_VEND5 := cCodVen
		EndCase
    	MsUnlock()
	Else
		MsgAlert("Erro ao localizar o pedido de vendas para troca do vendedor.","Atenção!")
		lErro	:= .T.
    Endif
Endif

If lErro
	MsgStop("Ocorreram erros de localização do código do vendedor nas tabelas de Títulos e/ou Pedidos.","Atenção!")	 
Else
	MsgInfo("Alteração efetuada com sucesso!","Atenção!")	 	
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06A03   ³ Autor ³ Cleber Maldonado      ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera o vendedor da comissão                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ValidVen(cVend)

Local lRet	:= ExistCpo('SA3',cVend)

If Empty(cVend)
	MsgStop("O Código do vendedor deve ser informado","Atenção!")
Endif

Return lRet
