#include "topconn.ch" 
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M05A39   ºAutor  ³Marcos Rocha        º Data ³  22/06/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de liberacao de pedidos de venda bloqueados em       º±±
±±º          ³estoque                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M05A39()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores		:= {{"C9_BLEST == '10'", "BR_PRETO"},;
							  {"C9_BLEST == '02'", "BR_VERMELHO"},;
							  {"C9_BLEST == '  '", "BR_VERDE"}}

Private aRotina	:= {}
Private cString	:= "SC9"
Private cDelFunc	:= ".T."											// na função AxDeleta se a variável existir executa
Private aLegenda	:= {{"BR_VERDE",		"Liberado" },;
                       {"BR_VERMELHO",	"Bloqueado"},;
                       {"BR_PRETO",	"Faturado"}}

Private cCadastro	:= OemToAnsi("Liberação de Estoque por Lista")

aAdd( aRotina, { 'Pesquisar'    ,'AxPesqui'     ,	0, 1})
aAdd( aRotina, { 'Visualizar'   ,'AxVisual'     ,	0, 2})
aAdd( aRotina, { 'Libera Estoq.','U_M05A39LIB()' ,	0, 4})
aAdd( aRotina, { 'Estorna Lib.' ,'U_M05A39EST()' ,	0, 4})
aAdd( aRotina, { 'Legenda'      ,'U_M05A39LEG()'   ,	0, 4})

DbSelectArea(cString)
DbSetOrder(1)
mBrowse(,,,,cString,,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M05A39LIBºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de liberacao de pedidos de venda bloqueados em       º±±
±±º          ³estoque                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M05A39LIB()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			:= GetArea()
Local aRegs			:= {}
Local cPerg			:= "M05A39"
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aButtons		:= {}
Local oFldPed		:= Nil
Local oFldSld		:= Nil
Local cListBox		:= ""
Local cLBoxSld		:= ""
Local cLBoxDisp	:= ""
Local aTitulo		:= {"","Canal","Pedido","Cliente","Loja","Nome","Item","Produto","Descrição","Quantidade","Total Pedido","Almox","Data Emissao","Data Entrega","Data Emissão","Operação"}
Local aTitSld		:= {"","Produto","Descrição","Almox","Sld Atual","Reserva","Sld Disponivel","Qtd. Selecionada","Sld Disp. Selec."}
Local aTitDisp		:= {"Produto","Descrição","Almox","Sld Atual","Reserva","Sld Disponivel"}
Private oOk      	:= LoadBitMap(GetResources(),"LBOK")
Private oNo      	:= LoadBitMap(GetResources(),"LBNO")
Private oVermelho	:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde   	:= LoadBitMap(GetResources(),"BR_VERDE")
Private oListBox	:= Nil
Private oLBoxSld	:= Nil
Private oLBoxDisp	:= Nil
Private aDados		:= {}
Private aSaldos	:= {}
Private aDisp  	:= {}
Private aOrdem    := {3,7,4,5} // Default

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os parametros da rotina            									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg  := Padr(cPerg,Len(SX1->X1_GRUPO))
Aadd(aRegs,{cPerg,"01","Do Produto ?"	      ,"","","mv_ch1","C",15,0,0,"G","",	"MV_PAR01","",	"","","",			"","",					"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{cPerg,"02","Ate o Produto ?"      ,"","","mv_ch2","C",15,0,0,"G","",	"MV_PAR02","",	"","","",			"","",					"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{cPerg,"03","Do Pedido ?"		  ,"","","mv_ch3","C",06,0,0,"G","",	"MV_PAR03","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SC5","","","","" })
Aadd(aRegs,{cPerg,"04","Ate o Pedido ?"		  ,"","","mv_ch4","C",06,0,0,"G","",	"MV_PAR04","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SC5","","","","" })
Aadd(aRegs,{cPerg,"05","Do Cliente ?"		  ,"","","mv_ch5","C",06,0,0,"G","",	"MV_PAR05","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SA1","","","","" })
Aadd(aRegs,{cPerg,"06","Da Loja ?"			  ,"","","mv_ch6","C",02,0,0,"G","",	"MV_PAR06","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"07","Ate o Cliente ?"	  ,"","","mv_ch7","C",06,0,0,"G","",	"MV_PAR07","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SA1","","","","" })
Aadd(aRegs,{cPerg,"08","Ate a Loja ?"		  ,"","","mv_ch8","C",02,0,0,"G","",	"MV_PAR08","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"09","Filtra Data por  ?"   ,"","","mv_ch9","N",01,0,0,"C","", "MV_PAR09","Dt.Emissao","","","","","Dt.Entrega" ,"","","","","Ambas","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"10","Da Data Emissao ?"    ,"","","mv_chA","D",08,0,1,"G","", "MV_PAR10","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"11","Ate Data Emissao  ?"  ,"","","mv_chB","D",08,0,1,"G","", "MV_PAR11","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"12","Da Entrega ?"         ,"","","mv_chC","D",08,0,1,"G","", "MV_PAR12","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"13","Ate a Entrega ? "     ,"","","mv_chD","D",08,0,1,"G","", "MV_PAR13","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})

CriaSx1(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os dados do listbox                									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LjMsgRun(OemToAnsi("Aguarde, analisando pedidos de venda para liberação..."),,{|| MontaDados(1),CLR_HRED } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem dados                									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDados) == 0
	Aviso("Aviso","Não existem pedidos de venda bloqueados em estoque.",{"Sair"},,"Atenção:")
	RestArea(aArea)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os botoes da tela                   									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aButtons, {'PESQUISA'	,{||PesqPed()}	   		,"Pesquisar"			   ,OemToAnsi("Pesquisar")} )
aAdd(aButtons, {'LBOK'		,{||MarcaPed(.T.,.F.)}	,"Marcar Pedido [F2]"	,OemToAnsi("Marcar")} )
aAdd(aButtons, {'LBNO'		,{||MarcaPed(.F.,.F.)}	,"Desmarcar Pedido [F3]",OemToAnsi("Desm.")} )
aAdd(aButtons, {'PENDENTE'	,{||MarcaPed(.T.,.T.)}	,"Marc.Todos [F4]"		,OemToAnsi("Mar.Tod.")} )
aAdd(aButtons, {'LBNO'		,{||MarcaPed(.F.,.T.)}	,"Desm.Todos [F5]"		,OemToAnsi("Des.Tod.")} )
aAdd(aButtons, {'EDIT'	    ,{||AltEntreg(.T.)}	   ,"Alt.Entr.Ped [F6]"		,OemToAnsi("Entr.Ped")} )
aAdd(aButtons, {'EDITABLE'	,{||AltEntreg(.F.)}	   ,"Alt.Entr.Item [F7]"	,OemToAnsi("Entr.It")})
aAdd(aButtons,{ "OMSDIVIDE",{||FATA27DivSC9()}    ,"Divide item de pedido de venda liberado","Div.Item"})

//aAdd(aButtons, {'S4WB008N'	,{||AltEntreg()}	      ,"Alt.Dt.Entr.[F6]"		,OemToAnsi("Alt.Ent.")} )
//aAdd(aButtons, {'S4WB004N'	,{||AltEntreg()}	      ,"Alt.Dt.Entr.[F6]"		,OemToAnsi("Alt.Ent.")} )
//aAdd(aButtons, {'EDITABLE' ,{||AltEntreg()}	      ,"Alt.Dt.Entr.[F6]"		,OemToAnsi("Alt.Ent.")} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes de acesso rapido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F2,{|a,b| MarcaPed(.T.,.F.)})
SetKey (VK_F3,{|a,b| MarcaPed(.F.,.F.)})
SetKey (VK_F4,{|a,b| MarcaPed(.T.,.T.)})
SetKey (VK_F5,{|a,b| MarcaPed(.F.,.T.)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 070, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 
	
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],OemToAnsi("Liberação de Estoque"),,,,,,,,oMainWnd,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Folders                      									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFldPed := TFolder():New(aPosObj[1,1],aPosObj[1,2],{OemToAnsi("Pedidos")},{},oDlgMain,,,,.T.,.T.,(aPosObj[1,4]-aPosObj[1,2]),(aPosObj[1,3]-aPosObj[1,1]))
	oFldSld := TFolder():New(aPosObj[2,1],aPosObj[2,2],{OemToAnsi("Saldos e Reservas"),"Saldos Disponiveis"},{},oDlgMain,,,,.T.,.T.,(aPosObj[2,4]-aPosObj[2,2]),(aPosObj[2,3]-aPosObj[2,1])+10)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o listbox de pedidos            									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
											aTitulo[12],;
											aTitulo[13],;
											aTitulo[14],;
											aTitulo[15],;
											aTitulo[16] ;
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
		   							aDados[oListBox:nAt,8],;
		   							aDados[oListBox:nAt,9],;
		   							Transform(aDados[oListBox:nAt,10],"@E 9,999,999.99"),;
		   							Transform(aDados[oListBox:nAt,11],"@E 9,999,999.99"),;
		   							aDados[oListBox:nAt,16],;
		   							aDados[oListBox:nAt,12],;
		   							aDados[oListBox:nAt,13],;
		   							aDados[oListBox:nAt,14],;
		   							aDados[oListBox:nAt,15]}}
	oListBox:bChange	:= {|| PosicSaldo() }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o ListBox de Saldos             									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 000,000 ListBox oLBoxSld VAR cLBoxSld Fields HEADER ;
											aTitSld[1],;
											aTitSld[2],;
											aTitSld[3],;
											aTitSld[4],;
											aTitSld[5],;
											aTitSld[6],;
											aTitSld[7],;
											aTitSld[8],;
											aTitSld[9] ;
	OF oFldSld:aDialogs[1] PIXEL SIZE  (oFldSld:aDialogs[1]:nClientWidth/2),(oFldSld:aDialogs[1]:nClientHeight/2)

	oLBoxSld:SetArray(aSaldos)
	oLBoxSld:bLine := { || {	Iif(aSaldos[oLBoxSld:nAt,8] <= 0,oVermelho,oVerde),;
	   							aSaldos[oLBoxSld:nAt,1],;
	   							aSaldos[oLBoxSld:nAt,2],;
	   							aSaldos[oLBoxSld:nAt,3],;
	   							Transform(aSaldos[oLBoxSld:nAt,4],"@E 9,999,999.99"),;
	   							Transform(aSaldos[oLBoxSld:nAt,5],"@E 9,999,999.99"),;
	   							Transform(aSaldos[oLBoxSld:nAt,6],"@E 9,999,999.99"),;
	   							Transform(aSaldos[oLBoxSld:nAt,7],"@E 9,999,999.99"),;
	   							Transform(aSaldos[oLBoxSld:nAt,8],"@E 9,999,999.99")}}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o ListBox de Saldos Disponiveis 									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 000,000 ListBox oLBoxDisp VAR cLBoxDisp Fields HEADER ;
											aTitDisp[1],;
											aTitDisp[2],;
											aTitDisp[3],;
											aTitDisp[4],;
											aTitDisp[5],;
											aTitDisp[6] ;
	OF oFldSld:aDialogs[2] PIXEL SIZE  (oFldSld:aDialogs[2]:nClientWidth/2),(oFldSld:aDialogs[2]:nClientHeight/2)

	oLBoxDisp:SetArray(aDisp)
	oLBoxDisp:bLine := { || {	aDisp[oLBoxDisp:nAt,1],;
	   							aDisp[oLBoxDisp:nAt,2],;
	   							aDisp[oLBoxDisp:nAt,3],;
	   							Transform(aDisp[oLBoxDisp:nAt,4],"@E 9,999,999.99"),;
	   							Transform(aDisp[oLBoxDisp:nAt,5],"@E 9,999,999.99"),;
	   							Transform(aDisp[oLBoxDisp:nAt,6],"@E 9,999,999.99")}}

oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(ValidSaldo(),(nOpcA := 1,oDlgMain:End()),)},{||(nOpcA := 0,oDlgMain:End())},,aButtons)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes de acesso rapido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F2 To
Set Key VK_F3 To
Set Key VK_F4 To
Set Key VK_F5 To

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera o Pedido de Venda                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
	LiberaPV()
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaItem ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de marcacao do itens posicionado                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaItem()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSld		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o saldo em estoque           									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosSld := AScan(aSaldos,{|x| Alltrim(x[1]) == Alltrim(aDados[oListBox:nAt,8]) .and. Alltrim(x[3]) == Alltrim(aDados[oListBox:nAt,16])})
If nPosSld == 0
	Aviso("Inconsistência","Saldo disponivel insuficiente para a liberação desse item do pedido de venda. Seleção não permitida.",{"Retornar"},,"Atenção")

Else

//	If !aDados[oListBox:nAt,1] .and. aSaldos[nPosSld,8] < aDados[oListBox:nAt,10]
//		Aviso("Inconsistência","Saldo disponivel insuficiente para a liberação desse item do pedido de venda. Seleção não permitida.",{"Retornar"},,"Atenção")
//		Return
//	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Marca/Desmarca item                   									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDados[oListBox:nAt,1] := !aDados[oListBox:nAt,1]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o saldo                      									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aDados[oListBox:nAt,1]
		aSaldos[nPosSld,8] -= aDados[oListBox:nAt,10]
		aSaldos[nPosSld,7] += aDados[oListBox:nAt,10]
	Else
		aSaldos[nPosSld,8] += aDados[oListBox:nAt,10]
		aSaldos[nPosSld,7] -= aDados[oListBox:nAt,10]
	Endif
Endif

aSaldos := aSort(aSaldos,,, { |x,y| x[8] < y[8] }) // Ordem de Saldo

oListBox:Refresh()
oLBoxSld:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaPed  ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de marcacao dos itens do pedido                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaPed(lMarcaPV,lTodos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSld		:= 0
Local cPedido		:= aDados[oListBox:nAt,3]
Local nLoop			:= 0
Local aProdutos		:= {}
Local cMsg			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o saldo em estoque           									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDados)

	If !lTodos .And. aDados[nLoop,3] <> cPedido
		Loop
	Endif

	If !lMarcaPV
		If !aDados[nLoop,1]
			Loop
		Endif
		
		aDados[nLoop,1] := .F.
		nPosSld := AScan(aSaldos,{|x| Alltrim(x[1]) == Alltrim(aDados[nLoop,8]) .and. Alltrim(x[3]) == Alltrim(aDados[nLoop,16])})
		If nPosSld > 0
			aSaldos[nPosSld,8] += aDados[nLoop,10]
			aSaldos[nPosSld,7] -= aDados[nLoop,10]
		Endif

	Else
		If aDados[nLoop,1]
			Loop
		Endif

		nPosSld := AScan(aSaldos,{|x| Alltrim(x[1]) == Alltrim(aDados[nLoop,8]) .and. Alltrim(x[3]) == Alltrim(aDados[nLoop,16])})
		If nPosSld == 0
//			Aadd(aProdutos,{aDados[nLoop,8],aDados[nLoop,16],aDados[nLoop,9]})

		Else
//			If aSaldos[nPosSld,8] < aDados[nLoop,10]
//				Aadd(aProdutos,{aDados[nLoop,8],aDados[nLoop,16],aDados[nLoop,9]})
//				Loop
//			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Marca/Desmarca item                   									    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDados[nLoop,1] := !aDados[nLoop,1]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o saldo                      									    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aDados[nLoop,1]
				aSaldos[nPosSld,8] -= aDados[nLoop,10]
				aSaldos[nPosSld,7] += aDados[nLoop,10]
			Else
				aSaldos[nPosSld,8] += aDados[nLoop,10]
				aSaldos[nPosSld,7] -= aDados[nLoop,10]
			Endif
		Endif
	Endif
Next nLoop

If Len(aProdutos) > 0
	For nLoop := 1 to Len(aProdutos)
		cMsg += "Produto: "+aProdutos[nLoop,1]+" - Almox: "+aProdutos[nLoop,2]+Chr(13)+Chr(10)
	Next nLoop
	Aviso("Inconsistência","Saldo disponivel insuficiente para a liberação dos item do pedido de venda abaixo. Seleção não permitida."+Chr(13)+Chr(10)+cMsg,{"Retornar"},3,"Atenção")

Endif

//aSaldos := aSort(aSaldos,,, { |x,y| Str(x[8])+x[3] < Str(y[8])+y[3] }) // Ordem de Saldo
//aSaldos := aSort(aSaldos,,, { |x,y| StrZero(x[8],10,2)+x[3] < StrZero(y[8],10,2)+y[3] }) // Ordem de Saldo
aSaldos := aSort(aSaldos,,, { |x,y| x[8] < y[8] }) // Ordem de Saldo

oListBox:Refresh()
oLBoxSld:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PosicSaldoºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Posiciona o listbox de saldos                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PosicSaldo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSld	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no array de saldos          									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosSld := AScan(aSaldos,{|x| Alltrim(x[1]) == Alltrim(aDados[oListBox:nAt,8]) .and. Alltrim(x[3]) == Alltrim(aDados[oListBox:nAt,16])})
If nPosSld > 0
	oLBoxSld:nAt := nPosSld
Endif
oLBoxSld:Refresh()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesqPed   ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para pesquisar no array                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesqPed()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCampo	:= Space(40)
Local aItens	:= {}
Local aChave	:= {}
Local cCombo 	:= ""
Local lSeek		:= .F.
Local nX		:= 0
Local nPosArr	:= 0
Local nOrd		:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o combo com os itens a serem exibidos        		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aItens,"Canal+Pedido+Item+Cliente")
Aadd(aItens,"Pedido+Item+Cliente+Loja")
Aadd(aItens,"Produto+Pedido+Item+Cliente")
Aadd(aItens,"Cliente+Loja+Pedido+Item")
Aadd(aItens,"Data Entrega+Pedido+Item+Cliente")

Aadd(aChave,{2,3,7,4})
Aadd(aChave,{3,7,4,5})
Aadd(aChave,{8,3,7,4})
Aadd(aChave,{4,5,3,7})
Aadd(aChave,{12,3,7,4})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela de pesquisa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE "Pesquisa"

@05,05 COMBOBOX oCBX VAR cCombo ITEMS aItens SIZE 206,36 PIXEL OF oDlg FONT oDlg:oFont
oCbx:bChange := {|| (nOrd := oCbx:nAt,cCampo := Space(40))}

@22,05 MSGET oPesqGet VAR cCampo SIZE 206,10 PIXEL

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlg ENABLE ACTION (lSeek := .T.,oDlg:End())
DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlg ENABLE ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o registro se clicado no botao Ok ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSeek
	
//	aOrdem := {3,7,4,5} // Default
	aOrdem := {aChave[nOrd,1],aChave[nOrd,2],aChave[nOrd,3],aChave[nOrd,4]}
	
	aDados 	:= aSort( aDados,,, { |x,y| X[aChave[nOrd,1]]+X[aChave[nOrd,2]]+X[aChave[nOrd,3]]+X[aChave[nOrd,4]] < Y[aChave[nOrd,1]]+Y[aChave[nOrd,2]]+Y[aChave[nOrd,3]]+Y[aChave[nOrd,4]] })
	If !Empty(cCampo)
		nPosArr := AScan(aDados,{|X| Alltrim(Upper(Substr(X[aChave[nOrd,1]]+X[aChave[nOrd,2]]+X[aChave[nOrd,3]]+X[aChave[nOrd,4]],1,Len(Alltrim(cCampo))))) == Alltrim(Upper(cCampo))})
		If nPosArr == 0
			Aviso("Aviso","Item não localizado. Informe outra chave de busca",{"Ok"},,"Atenção:")		
		Else
			oListBox:nAt := nPosArr		
		Endif
	Endif
	oListBox:Refresh()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaDadosºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para montar os dados de exibicao do listbox          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaDados(nOpcMonta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea		:= GetArea()
Local cQuery	:= ""
Local nPosSld	:= 0
Local nSldEst	:= 0
Local nEmpenho	:= 0
Local nLoop		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a query retornando os registros 									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery	:= " SELECT SC9.R_E_C_N_O_ AS RECSC9, SC6.R_E_C_N_O_ AS RECSC6, SC5.R_E_C_N_O_ AS RECSC5, SF4.R_E_C_N_O_ AS RECSF4"
cQuery	+= " FROM "+RetSqlName("SC9")+" SC9 (NOLOCK), "+RetSqlName("SF4")+" SF4 (NOLOCK), "+RetSqlName("SC6")+" SC6 (NOLOCK), "+RetSqlName("SC5")+" SC5 (NOLOCK)"
cQuery	+= " WHERE C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery	+= " AND C9_PEDIDO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery	+= " AND C9_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"'"
cQuery	+= " AND C9_LOJA BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"'"
cQuery	+= " AND C9_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
//cQuery	+= " AND C9_BLCRED IN ('  ')"
If nOpcMonta == 1
	cQuery	+= " AND C9_BLEST NOT IN ('  ','10')"
Else
	cQuery	+= " AND C9_BLEST = '  '"
	cQuery	+= " AND C9_CARGA = '      '"
EndIf	
cQuery	+= " AND SC9.D_E_L_E_T_ <> '*'
cQuery	+= " AND C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery	+= " AND C6_NUM = C9_PEDIDO"
cQuery	+= " AND C6_ITEM = C9_ITEM"
cQuery	+= " AND C6_PRODUTO = C9_PRODUTO"

If mv_par09 <> 2
   cQuery   += " AND C5_EMISSAO BETWEEN '"+Dtos(MV_PAR10)+"' AND '"+Dtos(MV_PAR11)+"'"
EndIf

If mv_par09 <> 1
   cQuery   += " AND C6_ENTREG BETWEEN '"+Dtos(MV_PAR12)+"' AND '"+Dtos(MV_PAR13)+"'"
EndIf
cQuery	+= " AND SC6.D_E_L_E_T_ <> '*'"
cQuery	+= " AND F4_FILIAL = '"+xFilial("SF4")+"'"
cQuery	+= " AND F4_CODIGO = C6_TES"
cQuery	+= " AND F4_ESTOQUE = 'S'"
cQuery	+= " AND SF4.D_E_L_E_T_ <> '*'"
cQuery	+= " AND C5_FILIAL = '"+xFilial("SC5")+"'"
cQuery	+= " AND C5_NUM = C9_PEDIDO"
cQuery	+= " AND SC5.D_E_L_E_T_ <> '*'"
cQuery	+= " ORDER BY C9_PEDIDO, C9_ITEM"
cQuery	:= ChangeQuery(cQuery)

MemoWrite("M05A39.SQL",cQuery)

If Select("PEDTRB") > 0
	DbSelectArea("PEDTRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "PEDTRB"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array de listbox                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("PEDTRB")
DbGoTop()
While !EOF()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona as tabelas                   									           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC9")
	DbGoTo(PEDTRB->RECSC9)

	DbSelectArea("SC6")
	DbGoTo(PEDTRB->RECSC6)

	DbSelectArea("SC5")
	DbGoTo(PEDTRB->RECSC5)

	DbSelectArea("SF4")
	DbGoTo(PEDTRB->RECSF4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o item no array               									           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aDados,{	.F.,;
   					Space(6),;
   					SC9->C9_PEDIDO,;
   					SC9->C9_CLIENTE,;
					SC9->C9_LOJA,;
					Iif(!SC5->C5_TIPO $ "B/D",Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NREDUZ"),Posicione("SA2",1,xFilial("SA2")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A2_NREDUZ")),;
					SC9->C9_ITEM,;
					SC9->C9_PRODUTO,;
					Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC"),;
					SC9->C9_QTDLIB,;
					RetTotPV(SC9->C9_PEDIDO),;
					Dtoc(SC5->C5_EMISSAO),;
					Dtoc(SC6->C6_ENTREG),;
					Dtoc(SC5->C5_EMISSAO),;
					SF4->F4_TEXTO,;
					SC6->C6_LOCAL,;
					PEDTRB->RECSC9,;
					PEDTRB->RECSC6,;
					PEDTRB->RECSC5,;
					PEDTRB->RECSF4})

	// Atualiza Reservas
        cQuery := " UPDATE " + RetSqlName("SB2") + " "
		cQuery += " SET B2_RESERVA = ISNULL((SELECT SUM(C9_QTDLIB) FROM " + RetSqlName("SC9") + " SC9, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SF4") + " SF4 "
		cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
		cQuery += "	AND C9_PRODUTO = B2_COD "
		cQuery += " AND C9_LOCAL = '"+SC9->C9_LOCAL+"' "
		cQuery += " AND C9_BLCRED = '  ' "
		cQuery += " AND C9_BLEST = '  ' "
		cQuery += " AND SC9.D_E_L_E_T_ <> '*' "
		cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' "
		cQuery += " AND C6_NUM = C9_PEDIDO "
		cQuery += " AND C6_PRODUTO = C9_PRODUTO "
		cQuery += " AND C6_ITEM = C9_ITEM "
		cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
		cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "' "
		cQuery += " AND F4_CODIGO = C6_TES "
		cQuery += " AND F4_ESTOQUE = 'S' "
		cQuery += " AND SF4.D_E_L_E_T_ <> '*'),0) "
		cQuery += " WHERE B2_FILIAL = '" + xFilial("SB2") + "' "
		cQuery += " AND B2_COD = '"+SC9->C9_PRODUTO+"' "
		cQuery += " AND B2_LOCAL = '"+SC9->C9_LOCAL+"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
      //Tenta executar o update
        nErro := TcSqlExec(cQuery)

//		MsgStop(cQuery)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o item no array de saldos     									           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcMonta == 1
	  	nPosSld := AScan(aSaldos,{|aDados| Alltrim(aDados[1]) == Alltrim(SC9->C9_PRODUTO) .and. Alltrim(aDados[3]) == Alltrim(SC6->C6_LOCAL)})
  		If nPosSld == 0
			nSldEst 	:= 0
			nEmpenho	:= 0

			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC6->C6_LOCAL,.F.)
				nSldEst		:= SaldoSB2(,.F.,,,,,,,.F.)
//				nEmpenho    := SaldoSB2(,.F.,,,,,,,.F.) - SaldoSB2(,.T.,,,,,,,.T.)
				nEmpenho    := SaldoSB2(,.F.,,,,,,,.F.) - SaldoSB2(,.F.,,,,,,,.T.)   // Empenho Não / Reserva Sim

			Endif
			Aadd(aSaldos,{	SC9->C9_PRODUTO,;                                         
							Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC"),;
							SC6->C6_LOCAL,;
							nSldEst,;
							nEmpenho,;
							nSldEst - nEmpenho,;
							0.00,;
							nSldEst - nEmpenho})
	  	Endif
	EndIf

	DbSelectArea("PEDTRB")
	DbSkip()
EndDo

If nOpcMonta == 1
	//aSaldos := aSort(aSaldos,,, { |x,y| x[1]+x[3] < y[1]+y[3] })
	//aSaldos := aSort(aSaldos,,, { |x,y| Str(x[8])+x[3] < Str(y[8])+y[3] }) // Ordem de Saldo
	//aSaldos := aSort(aSaldos,,, { |x,y| StrZero(x[8],10,2)+x[3] < StrZero(y[8],10,2)+y[3] }) // Ordem de Saldo
	aSaldos := aSort(aSaldos,,, { |x,y| x[8] < y[8] }) // Ordem de Saldo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array de saldos disponiveis    									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoop := 1 to Len(aSaldos)
//		If aSaldos[nLoop,6] > 0
			Aadd(aDisp,{	aSaldos[nLoop,1],;
							aSaldos[nLoop,2],;
							aSaldos[nLoop,3],;
							aSaldos[nLoop,4],;
							aSaldos[nLoop,5],;
							aSaldos[nLoop,6]})
//		Endif
	Next nLoop
EndIf

If Select("PEDTRB") > 0
	DbSelectArea("PEDTRB")
	DbCloseArea()
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidSaldoºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de validacao dos saldos em estoque                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidSaldo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSld		:= 0
Local nLoop			:= 0
Local aProdutos		:= {}
Local cMsg			:= ""
Local nSldEst		:= 0
Local nEmpenho		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Refaz o saldo em estoque              									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aSaldos)                                              
	nSldEst 	:= 0
	nEmpenho	:= 0

	DbSelectArea("SB2")
	DbSetOrder(1)
	If DbSeek(xFilial("SB2")+aSaldos[nLoop,1]+aSaldos[nLoop,3],.f.)
		nSldEst		:= SaldoSB2(,.F.,,,,,,,.F.)
//		nEmpenho    := SaldoSB2(,.F.,,,,,,,.F.) - SaldoSB2(,.T.,,,,,,,.T.)
		nEmpenho    := SaldoSB2(,.F.,,,,,,,.F.) - SaldoSB2(,.F.,,,,,,,.T.)
	Endif

	aSaldos[nLoop,4] := nSldEst
	aSaldos[nLoop,5] := nEmpenho
	aSaldos[nLoop,6] := nSldEst - nEmpenho
	aSaldos[nLoop,7] := 0.00
	aSaldos[nLoop,8] := nSldEst - nEmpenho
Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o saldo em estoque           									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDados)                                              

	If !aDados[nLoop,1]
		Loop
	Endif

	nPosSld := AScan(aSaldos,{|x| Alltrim(x[1]) == Alltrim(aDados[nLoop,8]) .and. Alltrim(x[3]) == Alltrim(aDados[nLoop,16])})

	If nPosSld == 0
		Aadd(aProdutos,{aDados[nLoop,8],aDados[nLoop,16],aDados[nLoop,3]})
	Else
		If aSaldos[nPosSld,8] < aDados[nLoop,10]
			Aadd(aProdutos,{aDados[nLoop,8],aDados[nLoop,16],aDados[nLoop,3]})
			aDados[nLoop,1] := .F.
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo                      									    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aDados[nLoop,1]
			aSaldos[nPosSld,8] -= aDados[nLoop,10]
			aSaldos[nPosSld,7] += aDados[nLoop,10]
		Endif
	Endif
Next nLoop

If Len(aProdutos) > 0
	For nLoop := 1 to Len(aProdutos)
		cMsg += "Pedido: "+aProdutos[nLoop,3]+" - Produto: "+aProdutos[nLoop,1]+" - Almox: "+aProdutos[nLoop,2]+Chr(13)+Chr(10)
	Next nLoop
	Aviso("Inconsistência","Saldo disponivel insuficiente para a liberação dos item do pedido de venda abaixo. Seleção não permitida."+Chr(13)+Chr(10)+cMsg,{"Retornar"},3,"Atenção")
Endif

oListBox:Refresh()
oLBoxSld:Refresh()

Return(Len(aProdutos) == 0)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LiberaPV  ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de liberacao dos pedidos de venda                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LiberaPV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLoop			:= 0
Local aPedidos		:= {}
Local cMsg			:= ""
Private FATA24REC   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera o Pedido de Venda              									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDados)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o item esta selecionado                      				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aDados[nLoop,1]
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no SC9 e SC6                                   				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC9")
	DbGoTo(aDados[nLoop,17])

	DbSelectArea("SC6")
	DbGoTo(aDados[nLoop,18])

	DbSelectArea("SC5")
	DbGoTo(aDados[nLoop,19])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Redefine os parametros utilizados na rotina automatica					        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MV_PAR01		:= SC9->C9_PEDIDO
	MV_PAR02		:= SC9->C9_PEDIDO
	MV_PAR03		:= SC9->C9_CLIENTE
	MV_PAR04		:= SC9->C9_CLIENTE
	MV_PAR05		:= SC6->C6_ENTREG
	MV_PAR06		:= SC6->C6_ENTREG 
	MV_PAR07		:= 1
	MV_PAR08		:= Ctod("  /  /  ")
	MV_PAR09		:= dDataBase+1000
	MV_PAR10		:= Space(6)
	MV_PAR11		:= "ZZZZZZ"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera o Pedido de Venda em estoque                     				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FATA24REC := aDados[nLoop,17]

	Processa({|lEnd| Ma450Processa("SC9",.F.,.T.,@lEnd,Nil,MV_PAR07==2)},,,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no SC9 e SC6                                   				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC9")
	dbGoTo(aDados[nLoop,17])

	dbSelectArea("SC6")
	dbGoTo(aDados[nLoop,18])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o pedido foi liberado                        				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC9->C9_BLEST)
		RecLock("SC9",.F.)
		SC9->C9_BLEST  := "  "
		SC9->C9_BLCRED := "  "
		MsUnLock()

		// Ajusta Empenhos
		// Updade SB2
		// TcSqlExec

        cQuery := " UPDATE " + RetSqlName("SB2") + " "
		cQuery += " SET B2_RESERVA = ISNULL((SELECT SUM(C9_QTDLIB) FROM" + RetSqlName("SC9") + " SC9, " + RetSqlName("SC6") + "SC6, " + RetSqlName("SF4") + " SF4 "
		cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' "
		cQuery += "	AND C9_PRODUTO = B2_COD "
		cQuery += " AND C9_LOCAL = '"+SC9->C9_LOCAL+"' "
		cQuery += " AND C9_BLCRED = '  ' "
		cQuery += " AND C9_BLEST = '  ' "
		cQuery += " AND SC9.D_E_L_E_T_ <> '*' "
		cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' "
		cQuery += " AND C6_NUM = C9_PEDIDO "
		cQuery += " AND C6_PRODUTO = C9_PRODUTO "
		cQuery += " AND C6_ITEM = C9_ITEM "
		cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
		cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "' "
		cQuery += " AND F4_CODIGO = C6_TES "
		cQuery += " AND F4_ESTOQUE = 'S' "
		cQuery += " AND SF4.D_E_L_E_T_ <> '*'),0) "
		cQuery += " WHERE B2_FILIAL = '" + xFilial("SB2") + "' "
		cQuery += " AND B2_COD = '"+SC9->C9_PRODUTO+"' "
		cQuery += " AND B2_LOCAL = '"+SC9->C9_LOCAL+"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
      //Tenta executar o update
        nErro := TcSqlExec(cQuery)

//		Aadd(aPedidos,{SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_QTDLIB})
	EndIf

Next nLoop

FATA24REC := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe a mensagem dos pedidos que nao foram liberados     				        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aPedidos) > 0

	For nLoop := 1 to Len(aPedidos)
	 	cMsg += "Pedido: "+aPedidos[nLoop,1]+"-"+aPedidos[nLoop,2]+" - Prod: "+aPedidos[nLoop,3]+" - Qtd: "+Transform(aPedidos[nLoop,4],"@E 9,999,999.99")+Chr(13)+Chr(10)
	Next nLoop
	Aviso("Inconsistência","Os pedidos abaixo não foram liberados. Verifique o saldo em estoque:"+Chr(13)+Chr(10)+cMsg,{"Ok"},3,"Atenção:")

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTotPV  ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de retorno do total em quantidade de pedido de       º±±
±±º          ³venda                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetTotPV(cPedido)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			:= GetArea()
Local nReturn		:= 0
Local cQuery		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a query retornando o total do Pedido								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery	:= " SELECT SUM(C6_QTDVEN) AS C6_QTDVEN"
cQuery	+= " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK), "+RetSqlName("SF4")+" SF4 (NOLOCK)"
cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery	+= " AND C6_NUM = '"+cPedido+"'"
cQuery	+= " AND SC6.D_E_L_E_T_ <> '*'"
cQuery	+= " AND F4_FILIAL = '"+xFilial("SF4")+"'"
cQuery	+= " AND F4_CODIGO = C6_TES"  
cQuery	+= " AND F4_ESTOQUE = 'S'"
cQuery	+= " AND SF4.D_E_L_E_T_ <> '*'"

If Select("TOTPED") > 0
	DbSelectArea("TOTPED")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TOTPED"

DbSelectArea("TOTPED")
DbGoTop()
If !EOF()
	nReturn := TOTPED->C6_QTDVEN
Endif

If Select("TOTPED") > 0
	DbSelectArea("TOTPED")
	DbCloseArea()
Endif

RestArea(aArea)

Return(nReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltEntreg ºAutor  ³Marcos Eduardo Rochaº Data ³  26/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para alteração da Data de Entrega do Pedido          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AltEntreg(lPedido)

Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSA1 := SA1->(GetArea())
Local cPedido  := aDados[oListBox:nAt,3]
Local cItem    := aDados[oListBox:nAt,7]
Local dDtEnt   := Ctod(aDados[oListBox:nAt,13])
Local nOpca    := 0
Local oDlg

cDesc := If(lPedido,"Por Pedido","Por Item")
	
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alteração da Data de Entrega : "+cPedido+" - "+cDesc) FROM 200,001 TO 300,450 PIXEL
	
@ 016,007 SAY OEMTOANSI("Data Entrega : ") SIZE 050,07 OF oDlg PIXEL
@ 016,077 MSGET dDtEnt WHEN .T.            SIZE 050,10 OF oDlg PIXEL

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava a Nova Data de Entrega. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lProcessou := .F.

If nOpca == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula e Valida Data de Embarque. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	cCepEnt  := If(Empty(SA1->A1_CEPE),SA1->A1_CEP,SA1->A1_CEPE)
	
	For nProc := 1 To Len(aDados)
	
		If lPedido  // Por Pedido
			If aDados[nProc,3] <> cPedido
				Loop
			EndIf
			nRecSC6 := aDados[nProc,18]
			aDados[nProc,13] := Dtoc(dDtEnt)
			//aDados[nProc,12] := Dtoc(dDtEmbarque)

		Else  // Por Item
			nRecSC6 := aDados[oListBox:nAt,18]
			aDados[oListBox:nAt,13] := Dtoc(dDtEnt)
			//aDados[oListBox:nAt,12] := Dtoc(dDtEmbarque)

		EndIf	
		
		lProcessou := .T.

		dbSelectArea("SC6")
		dbGoto(nRecSC6)
		RecLock("SC6",.F.)
		If Empty(SC6->C6_ENTORI)
			SC6->C6_ENTORI := SC6->C6_ENTREG
		EndIf
		SC6->C6_ENTREG  := dDtEnt
	//	SC6->C6_DTEMBAR := dDtEmbarque
		MsUnLock()
		
		If !lPedido
			Exit
		EndIf
	Next

EndIf

If lProcessou
	Aviso("Aviso","Data de Entrega Atualizada !",{"Ok"})
EndIf

RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M05A39TT ºAutor  ³Marcos Eduardo Rochaº Data ³  26/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca Transit Time no DA6                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*/
User Function M05A39TT(cCepEnt,dDtEnt,cCodCli,cLojCli)

Local aArea := GetArea()
Local nDiasTrans := 0
Local dDtEmbarque := dDtEnt

// Alterado Anderson Goncalves -> 23/10/08
dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+cCodCli+cLojCli))

//If !(SA1->A1_NATUREZ $ '10730/10740') //Canal de vendas diretas
//If !(AllTrim(SA1->A1_NATUREZ) $ '10730/10740') //Canal de vendas diretas

	cQuery := "SELECT ISNULL(MAX(DA6_TTIME),0) TTIME"
	cQuery += " FROM "+RetSqlName("DA7")+" DA7, "+RetSqlName("DA6")+" DA6"
	cQuery += " WHERE DA7_FILIAL = '"+xFilial("DA7")+"'"
	//cQuery += " AND '"+cCepEnt+"' BETWEEN DA7_CEPDE AND DA7_CEPATE"
	cQuery += " AND (('"+cCepEnt+"' BETWEEN DA7_CEPDE AND DA7_CEPATE) OR (DA7_CLIENT = '"+cCodCli+"' AND DA7_LOJA = '"+cLojCli+"') OR (DA7_CLIENT = '"+cCodCli+"' AND DA7_LOJA = '  '))"
	cQuery += " AND DA7.D_E_L_E_T_ <> '*'"
	cQuery += " AND DA6_FILIAL = '"+xFilial("DA6")+"'"
	cQuery += " AND DA6_ROTA = DA7_ROTA"
	cQuery += " AND DA6_PERCUR = DA7_PERCUR "
	cQuery += " AND DA6.D_E_L_E_T_ <> '*'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYSC6LOK', .T., .T.)
	
	dbSelectArea("QRYSC6LOK")
	dbGotop()
	While !Eof()
		nDiasTrans := QRYSC6LOK->TTIME
		dbSkip()
	EndDo
	dbCloseArea() 
//Else
//	nDiasTrans := 1
//EndIf

If nDiasTrans > 0

   For nDias := 1 To nDiasTrans

      dDtEmbarque := DataValida(dDtEmbarque-1,.F.)

   Next

EndIf

RestArea(aArea)

Return(dDtEmbarque)
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATA27DivSC9ºAutor  ³Marcos Eduardo Rochaº Data ³ 26/12/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Divide Item SC9                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FATA27DivSC9

// VER CORRECAO DO ROTEIRO

Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local aAreaSC9  := SC9->(GetArea())
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSA2  := SA2->(GetArea())
Local aAreaSB1  := SB1->(GetArea())
Local aSaldos   := {}
Local aOldSC6   := Array(6)
Local aClone    := {}
Local nX        := 0
Local nQtdNew   := 0
Local nOpcA     := 0
Local nPesoNew  := 0
Local nVolNew   := 0
Local cPedido   := aDados[oListBox:nAt,3]
Local cItem     := aDados[oListBox:nAt,7]
Local cLiberOk  := ""
Local cCpoPeso  := IIf(SuperGetMV("MV_PESOCAR") == "L","B1_PESO","B1_PESBRU")
Local oDlg
Local cProduto := aDados[oListBox:nAt,8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o registro no SC9                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
//dbSetOrder(1)
//	If MsSeek(xFilial("SC9")+cPedido+cItem+(cAliasTRB)->PED_SEQLIB+cProduto) .And. SoftLock("SC9")
dbGoto(aDados[oListBox:nAt,17]) // RecSC9

DbSelectArea("SB1")
DbSetOrder(1)
MsSeek(xFilial("SB1") + SC9->C9_PRODUTO)
		
dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5")+cPedido)
		
dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6")+cPedido+cItem)
		
If SC5->C5_TIPO$"BD"
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)		

Else
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)	

EndIf
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela para exibicao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM  177,001 TO 450,600 TITLE OemToAnsi("Divisão dos itens de pedido de venda liberado") PIXEL
@ 005,011 TO 045,295 LABEL "" OF oDlg  PIXEL
@ 048,144 TO 110,295 LABEL "" OF oDlg  PIXEL
@ 048,011 TO 110,138 LABEL "" OF oDlg  PIXEL

DEFINE SBUTTON FROM 122,230 TYPE 1 ACTION (If(nQtdNew>0,Eval({||nOpca := 1,oDlg:End()}),Eval({||nOpca := 2,oDlg:End()}))) ENABLE OF oDlg
DEFINE SBUTTON FROM 122,263 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
@ 012,015 SAY RetTitle("C9_PEDIDO")             SIZE 23,7 OF oDlg PIXEL
@ 012,044 SAY SC9->C9_PEDIDO                    SIZE 26,7 OF oDlg PIXEL
@ 023,015 SAY RetTitle("C5_CLIENTE")            SIZE 23,7 OF oDlg PIXEL
@ 023,044 SAY IIf(SC5->C5_TIPO$"BD",Substr(SA2->A2_NOME,1,35),Substr(SA1->A1_NOME,1,35))	SIZE 114,7 OF oDlg PIXEL
@ 034,015 SAY RetTitle("C6_PRODUTO")            SIZE 25,7 OF oDlg PIXEL
@ 034,044 SAY Substr(SB1->B1_DESC,1,30)         SIZE 58,7 OF oDlg PIXEL
@ 034,109 SAY RetTitle("C6_LOCAL")              SIZE 27,7 OF oDlg PIXEL
@ 034,150 SAY SC9->C9_LOCAL                     SIZE 15,7 OF oDlg PIXEL
@ 056,016 SAY RetTitle("C6_LOTECTL")            SIZE 38, 7 OF oDlg PIXEL
@ 056,072 SAY SC9->C9_LOTECTL                   SIZE 27, 7 OF oDlg PIXEL
@ 067,016 SAY RetTitle("C6_NUMLOTE")            SIZE 37, 7 OF oDlg PIXEL
@ 067,072 SAY SC9->C9_NUMLOTE                   SIZE 23, 7 OF oDlg PIXEL
@ 056,151 SAY RetTitle("C9_QTDLIB")             SIZE 53, 7 OF oDlg PIXEL
@ 056,203 GET oGet3 VAR SC9->C9_QTDLIB          PICTURE PesqPictQt("C6_QTDVEN",14) SIZE 53,7 OF oDlg PIXEL

oGet3:lReadOnly := .T.
nQtdNew  := SC9->C9_QTDLIB
nVolNew  := 0
nPesoNew := 0
@ 067,151 SAY "Qtd.p/Quebra"                     SIZE 46, 7 OF oDlg PIXEL
@ 067,203 MSGET nQtdNew                         PICTURE PesqPictQt("C9_QTDLIB",14) Valid nQtdNew > 0 .And. nQtdNew < SC9->C9_QTDLIB .And. Os200VlDiv(nQtdNew,@nPesoNew,@nVolNew)SIZE 53,7 OF oDlg PIXEL
@ 078,151 SAY OemtoAnsi("Volume")                SIZE 53, 7 OF oDlg PIXEL
@ 078,203 MSGET oGet1 VAR  nVolNew              PICTURE "99999999."+Replicate("9",TamSx3("DAK_CAPVOL")[2]) SIZE 53,7 OF oDlg PIXEL
oGet1:lReadOnly := .T.
@ 089,151 SAY OemtoAnsi("Peso")                SIZE 53, 7 OF oDlg PIXEL
@ 089,203 MSGET oGet2 VAR nPesoNew             PICTURE "99999999."+Replicate("9",TamSx3("DAK_PESO")[2])   SIZE 53,7 OF oDlg PIXEL
oGet2:lReadOnly := .T.	

ACTIVATE MSDIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento da divisao do item de pedido de venda liberado           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1 .And. nQtdNew <> SC9->C9_QTDLIB

	aAreaSC9 := SC9->(GetArea())
	aSC9Ignorar := {}
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek(xFilial("SC9")+cPedido+cItem)
	While !Eof() .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+cPedido+cItem

//		If SC9->C9_PRODUTO <> cProduto .Or. !Empty(SC9->C9_BLCRED) .Or. SC9->C9_BLEST $ '  /10'
		If SC9->C9_PRODUTO <> cProduto .Or. SC9->C9_BLEST $ '  /10'
			dbSkip()
			Loop
		EndIf

		Aadd(aSC9Ignorar,Recno())

		dbSkip()
	EndDo	
	RestArea(aAreaSC9)

	aadd(aSaldos,{})
	aadd(aSaldos[1],SC9->C9_LOTECTL)
	aadd(aSaldos[1],SC9->C9_NUMLOTE)
	aadd(aSaldos[1],SC6->C6_LOCALIZ)
	aadd(aSaldos[1],SC6->C6_NUMSERI)
	aadd(aSaldos[1],nQtdNew)		
	aadd(aSaldos[1],SC9->C9_POTENCI)		
	aadd(aSaldos[1],SC9->C9_DTVALID)

	aadd(aSaldos,{})
	aadd(aSaldos[2],SC9->C9_LOTECTL)
	aadd(aSaldos[2],SC9->C9_NUMLOTE)
	aadd(aSaldos[2],SC6->C6_LOCALIZ)
	aadd(aSaldos[2],SC6->C6_NUMSERI)
	aadd(aSaldos[2],SC9->C9_QTDLIB-nQtdNew)
	aadd(aSaldos[2],SC9->C9_POTENCI)
	aadd(aSaldos[2],SC9->C9_DTVALID)		
			
	Begin Transaction

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trava registro para atualizacao do pedido de venda                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SC5")
	RecLock("SC6")
	RecLock("SC9")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o status do pedido quanto a liberacao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLiberOk := SC5->C5_LIBEROK		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Divide o SC9 pela quantidades informadas                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC9->(a460Estorna())
	For nX := 1 To Len(aSaldos)
		aOldSC6[1] := SC6->C6_LOTECTL
		aOldSC6[2] := SC6->C6_NUMLOTE
		aOldSC6[3] := SC6->C6_LOCALIZ
		aOldSC6[4] := SC6->C6_NUMSERI
		aOldSC6[5] := SC6->C6_DTVALID
		aOldSC6[6] := SC6->C6_POTENCI
				
		SC6->C6_LOTECTL := aSaldos[nX][1]
		SC6->C6_NUMLOTE := aSaldos[nX][2]
		SC6->C6_LOCALIZ := aSaldos[nX][3]
		SC6->C6_NUMSERI := aSaldos[nX][4]
		SC6->C6_POTENCI := aSaldos[nX][6]
		SC6->C6_DTVALID := aSaldos[nX][7]
							
//		MaLibDoFat(SC6->(RecNo()),aSaldos[nX][5],.T.,.T.,.F.,.F.,.F.,.F.)
		MaLibDoFat(SC6->(RecNo()),aSaldos[nX][5],.T.,.F.,.F.,.F.,.F.,.F.) // Bloqueado de Estoque
							
		SC6->C6_LOTECTL := aOldSC6[1]
		SC6->C6_NUMLOTE := aOldSC6[2]
		SC6->C6_LOCALIZ := aOldSC6[3]
		SC6->C6_NUMSERI := aOldSC6[4]
		SC6->C6_DTVALID := aOldSC6[5]
		SC6->C6_POTENCI := aOldSC6[6]
											
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna o status do pedido de venda quanto a liberacao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SC5")
	SC5->C5_LIBEROK := 	cLiberOk

	End Transaction 
	
   // Excluir item da Matriz e recarregar para o pedido e produto
   nElemAtu := oListBox:nAt
   nElemAdd := Len(aDados) + 1
	Aadd(aDados,{aDados[oListBox:nAt,1],;
  					aDados[oListBox:nAt,2],;
  					aDados[oListBox:nAt,3],;
  					aDados[oListBox:nAt,4],;
  					aDados[oListBox:nAt,5],;
  					aDados[oListBox:nAt,6],;
  					aDados[oListBox:nAt,7],;
  					aDados[oListBox:nAt,8],;
  					aDados[oListBox:nAt,9],;
  					aDados[oListBox:nAt,10],;
  					aDados[oListBox:nAt,11],;
  					aDados[oListBox:nAt,12],;
  					aDados[oListBox:nAt,13],;
  					aDados[oListBox:nAt,14],;
  					aDados[oListBox:nAt,15],;
  					aDados[oListBox:nAt,16],;
  					aDados[oListBox:nAt,17],;
  					aDados[oListBox:nAt,18],;
  					aDados[oListBox:nAt,19],;
  					aDados[oListBox:nAt,20]})
  					
	aAltSC9 := {}
  					
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek(xFilial("SC9")+cPedido+cItem)
	While !Eof() .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+cPedido+cItem

	//	If SC9->C9_PRODUTO <> cProduto .Or. !Empty(SC9->C9_BLCRED) .Or. SC9->C9_BLEST $ '  /10'
		If SC9->C9_PRODUTO <> cProduto .Or. SC9->C9_BLEST $ '  /10'
			dbSkip()
			Loop
		EndIf

		If Ascan(aSC9Ignorar,Recno()) == 0
			Aadd(aAltSC9,{SC9->C9_QTDLIB,Recno()})
		EndIf

		dbSkip()
	EndDo	
	
	If Len(aAltSC9) <> 2
	   MsgStop("Problemas com a Atualizacao da quebra !")
	   // Montar Matriz antes com os registros do SC9 que deverao ser ignorados para os casos que ja tenha quebra do item

	Else
		aDados[nElemAtu,10] := aAltSC9[1,1]
		aDados[nElemAtu,17] := aAltSC9[1,2]

		aDados[nElemAdd,10] := aAltSC9[2,1]
		aDados[nElemAdd,17] := aAltSC9[2,2]
	EndIf	

	aDados 	:= aSort( aDados,,, { |x,y| X[aOrdem[1]]+X[aOrdem[2]]+X[aOrdem[3]]+X[aOrdem[4]] < Y[aOrdem[1]]+Y[aOrdem[2]]+Y[aOrdem[3]]+Y[aOrdem[4]] })
	oListBox:Refresh()

EndIf

RestArea(aAreaSB1)
RestArea(aAreaSC9)
RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Os200VlDiv³ Autor ³Eduardo Riera          ³ Data ³03.02.2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da quantidade informada na rotina OS200DivSC9       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Quantidade Informada                                   ³±±
±±³          ³ExpN2: Peso do item                                           ³±±
±±³          ³ExpN3: Volume do item                                         ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Os200VlDiv(nQtdNew,nPesoNew,nVolNew)

Local cCpoPeso  := IIf(SuperGetMV("MV_PESOCAR") == "L","B1_PESO","B1_PESBRU")

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)
nPesoNew := SB1->(FieldGet(FieldPos(cCpoPeso))) * nQtdNew
nVolNew  := OsPrCapArm(SC9->C9_PRODUTO,SC9->C9_FILIAL) * nQtdNew

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³M05A39LEG ³Autor ³ Marcos Eduardo Rocha  ³ Data ³17/05/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Demonstra a legenda das cores da mbrowse                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Esta rotina monta uma dialog com a descricao das cores da   ³±±
±±³          ³ Mbrowse.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Macom                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M05A39LEG()

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M05A39EST ºAutor  ³Marcos Eduardo Rochaº Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de estorno de liberacao de pedidos de venda liberadosº±±
±±º          ³ de estoque                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M05A39EST()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			:= GetArea()
Local aRegs			:= {}
Local cPerg			:= "M05A39"
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aButtons		:= {}
Local oFldPed		:= Nil
Local oFldSld		:= Nil
Local cListBox		:= ""
Local cLBoxSld		:= ""
Local cLBoxDisp	:= ""
Local aTitulo		:= {"","Canal","Pedido","Cliente","Loja","Nome","Item","Produto","Descrição","Quantidade","Total Pedido","Almox","Data Emissao","Data Entrega","Data Emissão","Operação"}
Local aTitSld		:= {"","Produto","Descrição","Almox","Sld Atual","Empenho","Sld Disponivel","Qtd. Selecionada","Sld Disp. Selec."}
Local aTitDisp		:= {"Produto","Descrição","Almox","Sld Atual","Empenho","Sld Disponivel"}
Private oOk      	:= LoadBitMap(GetResources(),"LBOK")
Private oNo      	:= LoadBitMap(GetResources(),"LBNO")
Private oVermelho	:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde   	:= LoadBitMap(GetResources(),"BR_VERDE")
Private oListBox	:= Nil
Private oLBoxSld	:= Nil
Private oLBoxDisp	:= Nil
Private aDados		:= {}
//Private aSaldos	:= {}
//Private aDisp  	:= {}
Private aOrdem    := {3,7,4,5} // Default

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os parametros da rotina            									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg  := Padr(cPerg,Len(SX1->X1_GRUPO))
Aadd(aRegs,{cPerg,"01","Do Produto ?"	      ,"","","mv_ch1","C",15,0,0,"G","",	"MV_PAR01","",	"","","",			"","",					"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{cPerg,"02","Ate o Produto ?"      ,"","","mv_ch2","C",15,0,0,"G","",	"MV_PAR02","",	"","","",			"","",					"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{cPerg,"03","Do Pedido ?"			 ,"","","mv_ch3","C",06,0,0,"G","",	"MV_PAR03","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SC5","","","","" })
Aadd(aRegs,{cPerg,"04","Ate o Pedido ?"		 ,"","","mv_ch4","C",06,0,0,"G","",	"MV_PAR04","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SC5","","","","" })
Aadd(aRegs,{cPerg,"05","Do Cliente ?"			 ,"","","mv_ch5","C",06,0,0,"G","",	"MV_PAR05","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SA1","","","","" })
Aadd(aRegs,{cPerg,"06","Da Loja ?"			    ,"","","mv_ch6","C",02,0,0,"G","",	"MV_PAR06","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"07","Ate o Cliente ?"		 ,"","","mv_ch7","C",06,0,0,"G","",	"MV_PAR07","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","SA1","","","","" })
Aadd(aRegs,{cPerg,"08","Ate a Loja ?"		    ,"","","mv_ch8","C",02,0,0,"G","",	"MV_PAR08","",		"","","",			"","",					"","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"09","Filtra Data por  ?"   ,"","","mv_ch9","N",01,0,0,"C","", "MV_PAR09","Dt.Emissao","","","","","Dt.Entrega" ,"","","","","Ambas","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"10","Da Data Emissao ?"   ,"","","mv_chA","D",08,0,1,"G","", "MV_PAR10","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"11","Ate Data Emissao ?"  ,"","","mv_chB","D",08,0,1,"G","", "MV_PAR11","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"12","Da Entrega ?"         ,"","","mv_chC","D",08,0,1,"G","", "MV_PAR12","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})
Aadd(aRegs,{cPerg,"13","Ate a Entrega ? "     ,"","","mv_chD","D",08,0,1,"G","", "MV_PAR13","",    "","","",         "","",               "","","","","","","","","","","","","","","","","","","",   "","","",""})

CriaSx1(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os dados do listbox                									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LjMsgRun(OemToAnsi("Aguarde, analisando pedidos de venda para estorno..."),,{|| MontaDados(2),CLR_HRED } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem dados                									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDados) == 0
	Aviso("Aviso","Não existem pedidos de venda Liberados em estoque.",{"Sair"},,"Atenção:")
	RestArea(aArea)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os botoes da tela                   									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aButtons, {'PESQUISA'	,{||PesqPed()}	   		,"Pesquisar"			   ,OemToAnsi("Pesquisar")} )
aAdd(aButtons, {'LBOK'		,{||MarcaPedE(.T.,.F.)}	,"Marcar Pedido [F2]"	,OemToAnsi("Marcar")} )
aAdd(aButtons, {'LBNO'		,{||MarcaPedE(.F.,.F.)}	,"Desmarcar Pedido [F3]",OemToAnsi("Desm.")} )
aAdd(aButtons, {'PENDENTE'	,{||MarcaPedE(.T.,.T.)}	,"Marc.Todos [F4]"		,OemToAnsi("Mar.Tod.")} )
aAdd(aButtons, {'LBNO'		,{||MarcaPedE(.F.,.T.)}	,"Desm.Todos [F5]"		,OemToAnsi("Des.Tod.")} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes de acesso rapido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F2,{|a,b| MarcaPedE(.T.,.F.)})
SetKey (VK_F3,{|a,b| MarcaPedE(.F.,.F.)})
SetKey (VK_F4,{|a,b| MarcaPedE(.T.,.T.)})
SetKey (VK_F5,{|a,b| MarcaPedE(.F.,.T.)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )
//AAdd( aObjects, { 100, 070, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 
	
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],OemToAnsi("Estorno de Liberação de Estoque"),,,,,,,,oMainWnd,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Folders                      									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFldPed := TFolder():New(aPosObj[1,1],aPosObj[1,2],{OemToAnsi("Pedidos")},{},oDlgMain,,,,.T.,.T.,(aPosObj[1,4]-aPosObj[1,2]),(aPosObj[1,3]-aPosObj[1,1]))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o listbox de pedidos            									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
											aTitulo[12],;
											aTitulo[13],;
											aTitulo[14],;
											aTitulo[15],;
											aTitulo[16] ;
	OF oFldPed:aDialogs[1] PIXEL SIZE  (oFldPed:aDialogs[1]:nClientWidth/2),(oFldPed:aDialogs[1]:nClientHeight/2) ;
    ON DBLCLICK (MarcaItEst()) //NOSCROLL

	oListBox:SetArray(aDados)
	oListBox:bLine 		:= { || {	Iif(aDados[oListBox:nAt,1],oOk,oNo),;
		   							aDados[oListBox:nAt,2],;
		   							aDados[oListBox:nAt,3],;
		   							aDados[oListBox:nAt,4],;
		   							aDados[oListBox:nAt,5],;
		   							aDados[oListBox:nAt,6],;
		   							aDados[oListBox:nAt,7],;
		   							aDados[oListBox:nAt,8],;
		   							aDados[oListBox:nAt,9],;
		   							Transform(aDados[oListBox:nAt,10],"@E 9,999,999.99"),;
		   							Transform(aDados[oListBox:nAt,11],"@E 9,999,999.99"),;
		   							aDados[oListBox:nAt,16],;
		   							aDados[oListBox:nAt,12],;
		   							aDados[oListBox:nAt,13],;
		   							aDados[oListBox:nAt,14],;
		   							aDados[oListBox:nAt,15]}}
//	oListBox:bChange	:= {|| PosicSaldo() }
	
oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(.T.,(nOpcA := 1,oDlgMain:End()),)},{||(nOpcA := 0,oDlgMain:End())},,aButtons)})
//oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(ValidSaldo(),(nOpcA := 1,oDlgMain:End()),)},{||(nOpcA := 0,oDlgMain:End())},,aButtons)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes de acesso rapido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F2 To
Set Key VK_F3 To
Set Key VK_F4 To
Set Key VK_F5 To

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera o Pedido de Venda                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
	EstornaLibPV()

Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaPed  ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de marcacao dos itens do pedido                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaPedE(lMarcaPV,lTodos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSld		:= 0
Local cPedido		:= aDados[oListBox:nAt,3]
Local nLoop			:= 0
Local aProdutos		:= {}
Local cMsg			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o saldo em estoque           									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDados)

	If !lTodos .And. aDados[nLoop,3] <> cPedido
		Loop
	Endif

	If !lMarcaPV
		If !aDados[nLoop,1]
			Loop
		Endif
		
		aDados[nLoop,1] := .F.

	Else
		If aDados[nLoop,1]
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Marca/Desmarca item                   									    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDados[nLoop,1] := !aDados[nLoop,1]
			
	Endif

Next nLoop

oListBox:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LiberaPV  ºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de liberacao dos pedidos de venda                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EstornaLibPV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis               									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLoop			:= 0
Local aPedidos		:= {}
Local cMsg			:= ""

nQtdBlq := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera o Pedido de Venda              									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDados)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o item esta selecionado                      				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aDados[nLoop,1]
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no SC9 e SC6                                   				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC9")
	DbGoTo(aDados[nLoop,17])

	DbSelectArea("SC6")
	DbGoTo(aDados[nLoop,18])

	DbSelectArea("SC5")
	DbGoTo(aDados[nLoop,19])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloqueia o Pedido de Venda em estoque                     				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSC9("SC9",6)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no SC9 e SC6                                   				        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC9")
	dbGoTo(aDados[nLoop,17])

	dbSelectArea("SC6")
	dbGoTo(aDados[nLoop,18])

	If !Empty(SC9->C9_BLEST)

		If SC9->C9_BLEST == "03"
			RecLock("SC9",.F.)
			SC9->C9_BLEST := "02"
			MsUnLock()
		EndIf
		nQtdBlq ++ 
	EndIf

Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe a mensagem dos pedidos que nao foram liberados     				        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aviso("Atenção","Estornada a liberação de estoque de "+AllTrim(Str(nQtdBlq))+" item(s) !",{"Ok"},3,"Atenção:")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaItEstºAutor  ³ Marcos Rocha       º Data ³  08/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de marcacao do itens posicionado                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaItEst()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca/Desmarca item                   									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados[oListBox:nAt,1] := !aDados[oListBox:nAt,1]
	
oListBox:Refresh()

Return
