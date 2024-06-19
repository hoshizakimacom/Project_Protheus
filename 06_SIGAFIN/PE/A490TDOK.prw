#Include 'Protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A490TDOK � Autor � Cleber Maldonado      � Data � 01/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a altera��o do vendedor da comiss�o                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Acionado por gatilho no campo E3_PORC                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A490TDOK()

Local lOpc 	:= .F.
Local lErro	:= .F.
Local aArea	:= GetArea()

dbSelectArea('SC5')
dbSetOrder(1)

If ALTERA
	lOpc	:=	MsgYesNo('Deseja atualizar o percentual de comiss�o no pedido de venda?','Atualiza Percentual')

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
			MsgInfo('N�o foi poss�vel atualizar o percentual de comiss�o no pedido de vendas. Pedido n�o encontrado!','Aten��o')
			lErro	:= .T.
		Endif

	    // Altera percentual de comiss�o no t�tulo
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
			MsgAlert("Erro ao localizar o t�tulo original para troca do vendedor.","Aten��o!")
			lErro	:= .T.		
	    Endif
	Endif

	If lErro
		MsgStop("Ocorreram erros de localiza��o do c�digo do vendedor nas tabelas de T�tulos e/ou Pedidos.","Aten��o!")	 
	Else
		MsgInfo("Altera��o efetuada com sucesso!","Aten��o!")	 	
	Endif
Endif

RestArea(aArea)

Return .T.