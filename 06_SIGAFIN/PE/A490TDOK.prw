#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A490TDOK ³ Autor ³ Cleber Maldonado      ³ Data ³ 01/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a alteração do vendedor da comissão                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Acionado por gatilho no campo E3_PORC                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A490TDOK()

Local lOpc 	:= .F.
Local lErro	:= .F.
Local aArea	:= GetArea()

dbSelectArea('SC5')
dbSetOrder(1)

If ALTERA
	lOpc	:=	MsgYesNo('Deseja atualizar o percentual de comissão no pedido de venda?','Atualiza Percentual')

	If lOpc
		If MsSeek(xFilial('SC5')+SE3->E3_PEDIDO)
			RecLock('SC5',.F.)
		   	Do Case
   				Case SC5->C5_VEND1 == SE3->E3_VEND
   					 SC5->C5_COMIS1 := M->E3_PORC
  			
		   		Case SC5->C5_VEND2 == SE3->E3_VEND
   					 SC5->C5_COMIS2 := M->E3_PORC
   			
   				Case SC5->C5_VEND3 == SE3->E3_VEND
   					 SC5->C5_COMIS3 := M->E3_PORC
   			
		   		Case SC5->C5_VEND4 == SE3->E3_VEND
   					 SC5->C5_COMIS4 := M->E3_PORC
   			 
	   			Case SC5->C5_VEND5 == SE3->E3_VEND
					 SC5->C5_COMIS5 := M->E3_PORC
			EndCase
   			MsUnlock()
		Else
			MsgInfo('Não foi possível atualizar o percentual de comissão no pedido de vendas. Pedido não encontrado!','Atenção')
			lErro	:= .T.
		Endif

	    // Altera percentual de comissão no título
    	dbSelectArea('SE1')
	    dbSetOrder(1)  // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
    
	    If MsSeek(xFilial('SE1')+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
    		RecLock('SE1',.F.)
	    	Do Case
   				Case SE1->E1_VEND1 == SE3->E3_VEND
   					 SE1->E1_COMIS1 := M->E3_PORC
  			
		   		Case SE1->E1_VEND2 == SE3->E3_VEND
   					 SE1->E1_COMIS2 := M->E3_PORC
   			
	   			Case SE1->E1_VEND3 == SE3->E3_VEND
   					 SE1->E1_COMIS3 := M->E3_PORC
   			
		   		Case SE1->E1_VEND4 == SE3->E3_VEND
   					 SE1->E1_COMIS4 := M->E3_PORC
   			 
	   			Case SE1->E1_VEND5 == SE3->E3_VEND
					 SE1->E1_COMIS5 := M->E3_PORC
			EndCase
    		MsUnlock()
		Else
			MsgAlert("Erro ao localizar o título original para troca do vendedor.","Atenção!")
			lErro	:= .T.		
	    Endif
	Endif

	If lErro
		MsgStop("Ocorreram erros de localização do código do vendedor nas tabelas de Títulos e/ou Pedidos.","Atenção!")	 
	Else
		MsgInfo("Alteração efetuada com sucesso!","Atenção!")	 	
	Endif
Endif

RestArea(aArea)

Return .T.