#include "topconn.ch" 
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M04M08   �Autor  �Marcos Rocha        � Data �  22/06/23   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Alteracao de Unidade de Medida                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Macom                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M04M08()

//���������������������������������������������������������������������������Ŀ
//�Declaracao de variaveis                                                    �
//�����������������������������������������������������������������������������
Local aCores		:= {{"B1_MSBLQL == '1'", "BR_VERMELHO"},;
						{"B1_MSBLQL = '2'", "BR_VERDE"}}

Private aRotina	:= {}
Private cString	:= "SB1"
Private cDelFunc	:= ".T."											// na fun��o AxDeleta se a vari�vel existir executa
Private aLegenda	:= {{"BR_VERDE",  "Ativo" },;
                       {"BR_VERMELHO","Bloqueado"}}

Private cCadastro	:= OemToAnsi("Altera��o de Unidade de Medida")

aAdd( aRotina, { 'Pesquisar'    ,'AxPesqui'     ,	0, 1})
aAdd( aRotina, { 'Visualizar'   ,'AxVisual'     ,	0, 2})
aAdd( aRotina, { 'Altera UM'    ,'U_M04A08ALT()' ,	0, 4})
aAdd( aRotina, { 'Legenda'      ,'U_M04A08LEG()'   ,	0, 4})

DbSelectArea(cString)
DbSetOrder(1)
mBrowse(,,,,cString,,,,,,aCores)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M04A08ALT �Autor  � Marcos Rocha      � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Alteracao de Unidade de Medida Produto e Estrutura���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Macom                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M04A08ALT()

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis               									           �
//�������������������������������������������������������������������������������
Local aArea			:= GetArea()
//Local aRegs			:= {}
//Local cPerg			:= "M04A08"
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aButtons		:= {}
Local oFldPed		:= Nil
Local oFldEstr		:= Nil
Local cListBox		:= ""
Local cLBoxSld		:= ""
//Local cLBoxDisp	:= ""
Local aTitulo		:= {"","Produto","Tipo","Descricao","Unid.Atu","Unid.Nova","2Unid.Nova","Fator","Tp.Conv","Fator Conv.Estr.","Tp.Conv.Est","Qtd.Estr."}
Local aTitEstr		:= {"","Componente","Prod.Pai","Fator","Qtd.","Qtd.Nova","Tp.Conv.Est"}

//Local aTitDisp		:= {"Produto","Descri��o","Almox","Sld Atual","Reserva","Sld Disponivel"}
Private oOk      	:= LoadBitMap(GetResources(),"LBOK")
Private oNo      	:= LoadBitMap(GetResources(),"LBNO")
Private oVermelho	:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde   	:= LoadBitMap(GetResources(),"BR_VERDE")
Private oListBox	:= Nil
Private oLBoxEstr	:= Nil
//Private oLBoxDisp	:= Nil
Private aDados		:= {}
Private aEstruc	    := {}
Private aOrdem    := {3,7,4,5} // Default

//�����������������������������������������������������������������������������Ŀ
//� Monta os dados do listbox                									�
//�������������������������������������������������������������������������������
//LjMsgRun(OemToAnsi("Aguarde, analisando pedidos de venda para libera��o..."),,{|| MontaDados(1),CLR_HRED } )

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
cType    := "Arquivos nao Processados | *.CSV | Arquivos ja Processados | *.PRC "

//���������������������������������������������������������������������Ŀ
//� Seleciona o arquivo                                                 �
//�����������������������������������������������������������������������
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo de interface"),1,"",.F.,GETF_LOCALHARD + GETF_NETWORKDRIVE)

//���������������������������������������������������������������������Ŀ
//� Valida se o arquivo existe                                          �
//�����������������������������������������������������������������������
If !File(cArq)
	Aviso("Aten��o !","Arquivo selecionado nao Localizado !",{"Ok"})
	Return
EndIf

Processa({|| U_M04M08I(cArq) },"Processando Leitura...")

//�����������������������������������������������������������������������������Ŀ
//� Verifica se existem dados                									�
//�������������������������������������������������������������������������������
//If Len(aDados) == 0
//	Aviso("Aviso","N�o existem pedidos de venda bloqueados em estoque.",{"Sair"},,"Aten��o:")
//	RestArea(aArea)
//	Return
//EndIf

//�����������������������������������������������������������������������������Ŀ
//� Cria os botoes da tela                   									�
//�������������������������������������������������������������������������������
aAdd(aButtons, {'PESQUISA'	,{||PesqPed()}	   		,"Pesquisar"		     ,OemToAnsi("Pesquisar")} )
aAdd(aButtons, {'PENDENTE'	,{||MarcaPed(.T.,.T.)}	,"Marc.Todos [F4]"		 ,OemToAnsi("Mar.Tod.")} )
aAdd(aButtons, {'LBNO'		,{||MarcaPed(.F.,.F.)}	,"Desm.Todos [F5]"		 ,OemToAnsi("Des.Tod.")} )

//������������������������������������������������������Ŀ
//�Define os botoes de acesso rapido                     �
//��������������������������������������������������������
SetKey (VK_F4,{|a,b| MarcaPed(.T.,.T.)})
SetKey (VK_F5,{|a,b| MarcaPed(.F.,.F.)})

//������������������������������������������������������Ŀ
//�Define a area dos objetos                             �
//��������������������������������������������������������
aObjects := {} 
//AAdd( aObjects, { 100, 100, .t., .t. } )
//AAdd( aObjects, { 100, 070, .t., .f. } )

AAdd( aObjects, { 080, 080, .t., .t. } )
AAdd( aObjects, { 100, 080, .t., .t. } )

AAdd( aObjects, { 020, 020, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 
	
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],OemToAnsi("Altera Unidade de Medida"),,,,,,,,oMainWnd,.T.)

	//�����������������������������������������������������������������������������Ŀ
	//� Monta os Folders                      									    �
	//�������������������������������������������������������������������������������
	oFldPed := TFolder():New(aPosObj[1,1],aPosObj[1,2],{OemToAnsi("Produtos")},{},oDlgMain,,,,.T.,.T.,(aPosObj[1,4]-aPosObj[1,2]),(aPosObj[1,3]-aPosObj[1,1]))
//	oFldEstr := TFolder():New(aPosObj[2,1],aPosObj[2,2],{OemToAnsi("Estruturas"),"Saldos Disponiveis"},{},oDlgMain,,,,.T.,.T.,(aPosObj[2,4]-aPosObj[2,2]),(aPosObj[2,3]-aPosObj[2,1])+10)
	oFldEstr := TFolder():New(aPosObj[2,1],aPosObj[2,2],{OemToAnsi("Estruturas")},{},oDlgMain,,,,.T.,.T.,(aPosObj[2,4]-aPosObj[2,2]),(aPosObj[2,3]-aPosObj[2,1])+10)

	//�����������������������������������������������������������������������������Ŀ
	//� Monta o listbox de pedidos            									    �
	//�������������������������������������������������������������������������������
	@ 000,000 LISTBOX oListBox VAR cListBox Fields HEADER ;
											aTitulo[1],;
											aTitulo[2],;
											aTitulo[3],;
											aTitulo[4],;
											aTitulo[5],;
											aTitulo[6],;
											aTitulo[7],;
											aTitulo[8],;
											aTitulo[9],;
											aTitulo[10],;
											aTitulo[11],;
											aTitulo[12];
	OF oFldPed:aDialogs[1] PIXEL SIZE  (oFldPed:aDialogs[1]:nClientWidth/2),(oFldPed:aDialogs[1]:nClientHeight/2) ;
	ON DBLCLICK (MarcaItem()) //NOSCROLL

	oListBox:SetArray(aDados)
	oListBox:bLine 		:= { || {	Iif(aDados[oListBox:nAt,1],oOk,oNo),;
		   							aDados[oListBox:nAt,2],;
		   							aDados[oListBox:nAt,3],;
		   							aDados[oListBox:nAt,4],;
		   							aDados[oListBox:nAt,5],;
		   							aDados[oListBox:nAt,6],;
		   							aDados[oListBox:nAt,7],;
		   							Transform(aDados[oListBox:nAt,8],"@E 99,999.9999"),;
		   							aDados[oListBox:nAt,9],;
		   							Transform(aDados[oListBox:nAt,10],"@E 99,999.9999"),;
		   							aDados[oListBox:nAt,11],;
		   							Transform(aDados[oListBox:nAt,12],"@E 9,999,999")}}


	oListBox:bChange	:= {|| PosicEstru() }

	//�����������������������������������������������������������������������������Ŀ
	//� Monta o ListBox de Saldos             									    �
	//�������������������������������������������������������������������������������
	@ 000,000 ListBox oLBoxEstr VAR cLBoxSld Fields HEADER ;
											aTitEstr[1],;
											aTitEstr[2],;
											aTitEstr[3],;
											aTitEstr[4],;
											aTitEstr[5],;
											aTitEstr[6],;
											aTitEstr[7];
	OF oFldEstr:aDialogs[1] PIXEL SIZE  (oFldEstr:aDialogs[1]:nClientWidth/2),(oFldEstr:aDialogs[1]:nClientHeight/2)
	oLBoxEstr:SetArray(aEstruc)

	oLBoxEstr:bLine := { || {	aEstruc[oLBoxEstr:nAt,1],;
	   							aEstruc[oLBoxEstr:nAt,2],;
	   							aEstruc[oLBoxEstr:nAt,3],;
	   							Transform(aEstruc[oLBoxEstr:nAt,4],"@E 99,999.9999"),;
	   							Transform(aEstruc[oLBoxEstr:nAt,5],"@E 9,999,999.9999"),;
	   							Transform(aEstruc[oLBoxEstr:nAt,6],"@E 9,999,999.9999"),;
	   							aEstruc[oLBoxEstr:nAt,7]}}

//oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(ValidSaldo(),(nOpcA := 1,oDlgMain:End()),)},{||(nOpcA := 0,oDlgMain:End())},,aButtons)})
oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(.T.,(nOpcA := 1,oDlgMain:End()),)},{||(nOpcA := 0,oDlgMain:End())},,aButtons)})

//������������������������������������������������������Ŀ
//�Define os botoes de acesso rapido                     �
//��������������������������������������������������������
Set Key VK_F2 To
Set Key VK_F3 To
Set Key VK_F4 To
Set Key VK_F5 To
Set Key VK_F6 To
Set Key VK_F7 To
Set Key VK_F8 To

//������������������������������������������������������Ŀ
//�Libera o Pedido de Venda                              �
//��������������������������������������������������������
If nOpcA == 1
	GravaAlt()
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaItem �Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de marcacao do itens posicionado                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaItem()

//�����������������������������������������������������������������������������Ŀ
//� Marca/Desmarca item                   									    �
//�������������������������������������������������������������������������������
aDados[oListBox:nAt,1] := !aDados[oListBox:nAt,1]

oListBox:Refresh()
oLBoxEstr:Refresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaPed  �Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de marcacao dos itens do pedido                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaPed(lMarcaPV,lTodos)

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis               									           �
//�������������������������������������������������������������������������������
//Local nPosSld		:= 0
//Local cPedido		:= aDados[oListBox:nAt,3]
Local nLoop			:= 0

//�����������������������������������������������������������������������������Ŀ
//� Verifica o saldo em estoque           									           �
//�������������������������������������������������������������������������������
For nLoop := 1 to Len(aDados)

//	If !lTodos  //.And. aDados[nLoop,3] <> cPedido
//		Loop
//	Endif

	//�����������������������������������������������������������������������������Ŀ
	//� Marca/Desmarca item                   									    �
	//�������������������������������������������������������������������������������
	If lTodos
		aDados[nLoop,1] := .T.
	Else
		aDados[nLoop,1] := .F.
	Endif

Next nLoop

oListBox:Refresh()
oLBoxEstr:Refresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PosicEstru�Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Posiciona o listbox de saldos                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PosicEstru()

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis               									           �
//�������������������������������������������������������������������������������
//Local nPosSld	:= 0

//�����������������������������������������������������������������������������Ŀ
//� Posiciona no array de saldos          									           �
//�������������������������������������������������������������������������������
nPosSld := AScan(aEstruc,{|x| Alltrim(x[2]) == Alltrim(aDados[oListBox:nAt,2]) })
If nPosSld > 0
	oLBoxEstr:nAt := nPosSld
Endif
oLBoxEstr:Refresh()	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PesqPed   �Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para pesquisar no array                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PesqPed()

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis               									           �
//�������������������������������������������������������������������������������
Local cCampo	:= Space(40)
Local aItens	:= {}
Local aChave	:= {}
Local cCombo 	:= ""
Local lSeek		:= .F.
//Local nX		:= 0
Local nPosArr	:= 0
Local nOrd		:= 1

//���������������������������������������������������������Ŀ
//�Monta o combo com os itens a serem exibidos        		�
//�����������������������������������������������������������
Aadd(aItens,"Produto")
Aadd(aChave,{1})

//��������������������������Ŀ
//� Monta a tela de pesquisa �
//����������������������������
DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE "Pesquisa"

@05,05 COMBOBOX oCBX VAR cCombo ITEMS aItens SIZE 206,36 PIXEL OF oDlg FONT oDlg:oFont
oCbx:bChange := {|| (nOrd := oCbx:nAt,cCampo := Space(40))}

@22,05 MSGET oPesqGet VAR cCampo SIZE 206,10 PIXEL

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlg ENABLE ACTION (lSeek := .T.,oDlg:End())
DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlg ENABLE ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

//��������������������������������������������Ŀ
//� Pesquisa o registro se clicado no botao Ok �
//����������������������������������������������
If lSeek
	
//	aOrdem := {3,7,4,5} // Default
	aOrdem := {aChave[nOrd,1],aChave[nOrd,2],aChave[nOrd,3],aChave[nOrd,4]}
	
	aDados 	:= aSort(aDados,,, { |x,y| X[aChave[nOrd,1]]+X[aChave[nOrd,2]]+X[aChave[nOrd,3]]+X[aChave[nOrd,4]] < Y[aChave[nOrd,1]]+Y[aChave[nOrd,2]]+Y[aChave[nOrd,3]]+Y[aChave[nOrd,4]] })
	If !Empty(cCampo)
		nPosArr := AScan(aDados,{|X| Alltrim(Upper(Substr(X[aChave[nOrd,1]]+X[aChave[nOrd,2]]+X[aChave[nOrd,3]]+X[aChave[nOrd,4]],1,Len(Alltrim(cCampo))))) == Alltrim(Upper(cCampo))})
		If nPosArr == 0
			Aviso("Aviso","Item n�o localizado. Informe outra chave de busca",{"Ok"},,"Aten��o:")		
		Else
			oListBox:nAt := nPosArr		
		Endif
	Endif
	oListBox:Refresh()
Endif

Return

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSx1  � Verifica e cria um novo grupo de perguntas com base nos      ���
���             �          � par�metros fornecidos                                        ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function CriaSx1(aRegs)

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                  									�
//�������������������������������������������������������������������������������
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidSaldo�Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de validacao dos saldos em estoque                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function ValidSaldo()
//Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GravaAlt  �Autor  � Marcos Rocha      � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de gravacao das alteracoes                           ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaAlt()

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis               									    �
//�������������������������������������������������������������������������������
Local nLoop		:= 0
Local nQtdGrav  := 0
Local nProc1
Local nPosSG1

//�����������������������������������������������������������������������������Ŀ
//� Libera o Pedido de Venda              									    �
//�������������������������������������������������������������������������������
For nLoop := 1 to Len(aDados)

	//�����������������������������������������������������������������������������Ŀ
	//� Verifica se o item esta selecionado                      				    �
	//�������������������������������������������������������������������������������
	If !aDados[nLoop,1]
		Loop
	Endif

	//�����������������������������������������������������������������������������Ŀ
	//� Verifica o saldo em estoque           									    �
	//�������������������������������������������������������������������������������
	nPosSG1 := AScan(aEstruc,{|x| Alltrim(x[2]) == Alltrim(aDados[nLoop,2]) })
	If nPosSG1 <> 0

		For nProc1 := nPosSG1  To Len(aEstruc)

			If AllTrim(aEstruc[nProc1,2]) <> Alltrim(aDados[nLoop,2])
				Exit
			EndIf

			SG1->(dbGoto(aEstruc[nProc1,8]))
			RecLock("SG1",.F.)
			SG1->G1_QUANT := aEstruc[nProc1,6]
			MsUnLock()

			nQtdGrav ++

		Next

	EndIf

	SB1->(dbGoto(aDados[nLoop,13]))
	RecLock("SB1",.F.)
	SB1->B1_UM      := aDados[nLoop,6]
	SB1->B1_SEGUM   := aDados[nLoop,7]
	SB1->B1_CONV    := aDados[nLoop,8]
	SB1->B1_TIPCONV := aDados[nLoop,9]
	MsUnLock()

Next nLoop

If nQtdGrav == 0
	Aviso("Inconsist�ncia","Produtos e Estruturas n�o foram alterados ",{"Ok"},3,"Aten��o:")
Else
	Aviso("OK","Produtos e Estruturas alteradas : "+StrZero(nQtdGrav,4),{"Ok"},3,"Aten��o:")
EndIf

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �M05A39LEG �Autor � Marcos Eduardo Rocha  � Data �17/05/2007 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Demonstra a legenda das cores da mbrowse                    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Esta rotina monta uma dialog com a descricao das cores da   ���
���          � Mbrowse.                                                    ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Macom                                            ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function M04A08LEG()

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaItEst�Autor  � Marcos Rocha       � Data �  08/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de marcacao do itens posicionado                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaItEst()

//�����������������������������������������������������������������������������Ŀ
//� Marca/Desmarca item                   									           �
//�������������������������������������������������������������������������������
aDados[oListBox:nAt,1] := !aDados[oListBox:nAt,1]
	
oListBox:Refresh()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M04M08I � Autor � Marcos Eduardo Rocha  � Data �24/04/2023���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M08I(cArq)

Local lContinua := .T.
Local nProc
Local cCodProd   := ""
Private nHdl	:= 0
Private aStruct := {}
Private aLog	:= {}

//���������������������������������������������������������������������Ŀ
//� Abre o arquivo texto                                                �
//�����������������������������������������������������������������������
nHdl := FT_FUSE(cArq)

//���������������������������������������������������������������������Ŀ
//� Valida se conseguiu abrir o arquivo texto                           �
//�����������������������������������������������������������������������
If nHdl <> Nil .and. nHdl <= 0
	
	Aviso("Aten��o !","N�o foi poss�vel a abertura do arquivo "+Alltrim(cArq)+" !",{"Ok"})
	
	//���������������������������������������������������������������������Ŀ
	//� Fecha o arquivo texto                                               �
	//�����������������������������������������������������������������������
	FT_FUSE()
	
	Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Executa a leitura sequencial do arquivo                             �
//�����������������������������������������������������������������������
ProcRegua(FT_FLASTREC())

FT_FGOTOP()
lPrimLinha := .T.

While !FT_FEOF()
	
	IncProc("Analisando arquivo...")
	
	//���������������������������������������������������������������������Ŀ
	//� Armazena na variavel cBuffer a linha do arquivo texto               �
	//�����������������������������������������������������������������������
	cBuffer := Alltrim(FT_FREADLN())
	cBuffer := Upper(cBuffer)
	
	//���������������������������������������������������������������������Ŀ
	//� Alimenta variaveis de controle                                      �
	//�����������������������������������������������������������������������
	cBuffer := StrTran(cBuffer,'"','')
	
	aCampos := {}
	For nProc := 1 To 9

		nPos := At(";",cBuffer)

		// Quando a primeira coluna n�o for uma letra
		If lPrimLinha .And. nProc == 1 .And. !Left(Alltrim(Left(cBuffer,nPos-1)),1)$"ABCDEFGHI" 
			MsgStop(OemToAnsi("Diverg�ncia de LayOut na primeira coluna ! Favor Verificar ! "))
			lContinua := .F.
			Exit
		EndIf

		// Quando a primeira coluna n�o for uma letra
		If nPos == 0 .And. nProc <> 9
			MsgStop(nProc)
			MsgStop(OemToAnsi("Erro na importa��o do arquivo ! Diverg�ncia de quantidade de colunas !"))
			lContinua := .F.
			Exit
		ElseIf nPos == 0
			nPos := 100
		EndIf

		Aadd(aCampos,Left(cBuffer,nPos-1))
		cBuffer := SubStr(cBuffer,nPos+1)
	Next

	If !lContinua
		Exit
	EndIf
	
	//�����������������������������Ŀ
	//� Busca e Valida produto PAI. �
	//�������������������������������
	cCodProd   := AllTrim(aCampos[01])
	cUmAtu     := AllTrim(aCampos[02])
	cUmNova    := AllTrim(aCampos[03])
	
	c2UmNova   := AllTrim(aCampos[05])
	nFator     := Val(StrTran(aCampos[06],",","."))
	cTpConv    := AllTrim(aCampos[07])
	nFtrEstr   := Val(StrTran(aCampos[08],",","."))
	cTpConvE   := AllTrim(aCampos[09])

	//����������������������������Ŀ
	//� Busca e Valida produto MP. �
	//������������������������������
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodProd) .And.  !lPrimLinha
		MsgStop(OemToAnsi("C�digo de Produto em Branco ! C�digo : ")+cCodProd)
		Aadd(aLog,"C�digo de Produto em Branco. C�digo : "+cCodProd)
		FT_FSKIP()
		Loop
	ElseIf !lPrimLinha .And. !dbSeek(xFilial("SB1")+cCodProd)
		MsgStop(OemToAnsi("C�digo de Produto n�o encontrado... C�digo : ")+cCodProd)
		Aadd(aLog,"Codigo da Produto n�o encontrado .. C�digo : "+cCodProd)
		FT_FSKIP()
		Loop
	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Alimenta a Matri	z com a Estrutura.                                  �
	//�����������������������������������������������������������������������
	If !lPrimLinha

		//�����������������������������Ŀ
		//� Busca e Valida produto PAI. �
		//�������������������������������
		Aadd(aDados,{	.F.,;
   						SB1->B1_COD,;
   						SB1->B1_TIPO,;
   						Left(SB1->B1_DESC,40),;
   						SB1->B1_UM,;
   						Upper(cUmNova),;
						Upper(c2UmNova),;			
   						nFator,;
						Upper(cTpConv),;
   						nFtrEstr,;
						Upper(cTpConvE),;
   						0,;
						SB1->(Recno())})
		nQtdSG1 := 0

		dbSelectArea("SG1")
		dbSetOrder(2)
		dbSeek(xFilial("SG1")+SB1->B1_COD)
		While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COMP == xFilial("SG1")+SB1->B1_COD

			mQtdNova := If(cTpConvE == "M",SG1->G1_QUANT*nFtrEstr,SG1->G1_QUANT/nFtrEstr)

			Aadd(aEstruc,{' ',SG1->G1_COMP,;
								SG1->G1_COD,;
								nFtrEstr,;
								SG1->G1_QUANT,;
								mQtdNova,;
								Upper(cTpConvE),;
								SG1->(Recno())})
			nQtdSG1 ++

			dbSkip()
		EndDo

		aDados[Len(aDados),12] := nQtdSG1		

	EndIf
	lPrimLinha := .F.

	//���������������������������������������������������������������������Ŀ
	//� Posiciona na proxima linha                                          �
	//�����������������������������������������������������������������������
	FT_FSKIP()
EndDo

If Len(aEstruc) == 0
	Aadd(aEstruc,{' ',Space(15),;
								Space(15),;
								0,;
								0,;
								0,;
								"M",;
								0})
EndIf

//���������������������������������������������������������������������Ŀ
//� Fecha o arquivo texto                                               �
//�����������������������������������������������������������������������
FT_FUSE()

If !lContinua
	Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Ordenando por c�digo                                                �
//�����������������������������������������������������������������������
aDados := aSort(aDados,,, { |x,y| x[2] < y[2] }) // Ordem de Codigo

aEstruc := aSort(aEstruc,,, { |x,y| x[2]+x[3] < y[2]+y[3] }) // Ordem de Componente + Pai

Return
