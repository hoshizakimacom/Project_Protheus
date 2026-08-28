#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'Topconn.ch'
#Include 'TbiConn.ch'
#INCLUDE "Rwmake.ch"

/*/{Protheus.doc} M04M12

CENTRAL DE PRODUÇÃO

@author Marcos Antonio Montes
@since 13/12/2024
@return Nil Nulo
/*/

/*

C2_XLIBSEP,C,40 CONTEUDO: DTOC(DATE())+" "+TIME()+" "+cUserName //99/99/9999 99:99:99 xxxxxxxxxxxxxxxxxxxx
C2_XIMPOPE,C,40 

*/
User Function M04M12(aAutoPar)

	Local aPergs       := {}
	Local aSizBrw      := msAdvSize(.f.,.f.,Nil)
	Local aObject      := {}
	Local lFiltro      := .T.

	Private cMonitor   := 'C E N T R A L        D E        P R O D U Ç Ã O'
	Private cTitulo    := ""
	Private aRetPar    := {}
	Private oDlgMon
	Private cCADASTRO  := "Central de Produção"
	Private aRotina    := {}
	Private cAliasTrb
	Private oBrwOP
	Private oBrwEmp
	Private nAtAnt     := 0
	Private cLocArm    := GETMV("ES_LOCARM",.F.,"01") //Armazem de Compra
	Private cLocCQ     := GETMV("MV_CQ",.F.,"98") //Armazem de CQ
	Private cLocProc   := GETMV("MV_LOCPROC",.F.,"99") //Armazem de Processo
	Private lDblClick  := .F.

	Private aOrdProd   := {}
	Private aRoteiros  := {}
	Private aEmpenhos  := {}
	Private dPrvDe
	Private dPrvAte
	Private dIniDe
	Private dIniAte

	//coordenada do browse de trabalho
	aAdd(aObject,{100,10,.t.,.t.})
	aAdd(aObject,{100,45,.t.,.t.})
	aAdd(aObject,{100,45,.t.,.t.})

	aInfBrw := {aSizBrw[1],aSizBrw[2],aSizBrw[3],aSizBrw[4],3,3}
	aPosObj := msobjsize(aInfBrw,aObject,.t.)

	Aadd(aPergs, {1, "Previsao Entrega De"    ,FirstDay(dDataBase)   ,"@D","","   ","",60,.T.}) //1
	Aadd(aPergs, {1, "Previsão Entrega Ate"   ,LastDay(dDataBase+180),"@D","","   ","",60,.T.}) //2
	Aadd(aPergs, {2, "Situação OP"            ,"1",{"1=Em aberto/Iniciada","2=Em aberto Somente","3=Iniciada Somente","4=Encerrada","5=Todas"},80,".T.",.F.}) //3
	Aadd(aPergs, {2, "Separação"              ,"1",{"1=Todos","2=Não liberados","3=Liberados","4=Separados","5=Separados Parciais","6=Não separados"},80,".T.",.F.})  //4
	Aadd(aPergs, {1, "Produto De"             ,REPLICATE(' ',TAMSX3("B1_COD")[1]),"@X","","SB1","",60,.F.})  //5
	Aadd(aPergs, {1, "Produto Ate"            ,REPLICATE('Z',TAMSX3("B1_COD")[1]),"@X","","SB1","",60,.T.})  //6
	Aadd(aPergs, {1, "OP De"                  ,REPLICATE(' ',TAMSX3("D3_OP")[1]),"@X","","SC2","",60,.F.})   //7
	Aadd(aPergs, {1, "OP Ate"                 ,REPLICATE('Z',TAMSX3("D3_OP")[1]),"@X","","SC2","",60,.T.})   //8
	Aadd(aPergs, {2, "Considera PI?"          ,"1",{"1=Sim","2=Não"},80,".T.",.F.})  //9
	Aadd(aPergs, {1, "Previsao Inicio De"     ,FirstDay(dDataBase)   ,"@D","","   ","",60,.T.}) //10
	Aadd(aPergs, {1, "Previsão Inicio Ate"    ,LastDay(dDataBase+180),"@D","","   ","",60,.T.}) //11
	Aadd(aPergs, {1, "Pedido De"              ,REPLICATE(' ',TAMSX3("C5_NUM")[1]),"@X","","SC5","",60,.F.})  //12
	Aadd(aPergs, {1, "Pedido Ate"             ,REPLICATE('Z',TAMSX3("C5_NUM")[1]),"@X","","SC5","",60,.T.})  //13
	Aadd(aPergs, {1, "Item PV De"             ,REPLICATE(' ',TAMSX3("C6_ITEM")[1]),"@X","","SC6XXX","",60,.F.})  //14
	Aadd(aPergs, {1, "Item PV Ate"            ,REPLICATE('Z',TAMSX3("C6_ITEM")[1]),"@X","","SC6XXX","",60,.T.})  //15
	Aadd(aPergs, {2, "Ordem de visualização"  ,"1",{"1=Numero da OP","2=Previsão de Inicio"},80,".T.",.F.}) //16
	Aadd(aPergs, {2, "Situação Empenhos"      ,"1",{"1=Todos","2=Com estoque Suficiente","3=Com estoque parcial","4=Sem saldo em estoque"},80,".T.",.F.})  //17

	While .T.

		If aAutoPar <> Nil
			aRetPar := aAutoPar
			cMonitor := "M O N I T O R  D E  P R O D U Ç Ã O - DRILL DROWN - PRODUTO "+aRetPar[6]
		Else
			If lFiltro
				If !ParamBox(aPergs, "Monitor de Produção", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)

					Exit
				EndIf
				lFiltro := .F.
			EndIf
		EndIf

		aOrdProd    := {}
		aRoteiros   := {}
		aEmpenhos   := {}
		nAtAnt      := 0

		dPrvDe      := aRetPar[1]
		dPrvAte     := aRetPar[2]
		dIniDe      := aRetPar[10]
		dIniAte     := aRetPar[11]

		LjMsgRun( "Carregando dados..." ,, {|| aOrdProd := U_M04M12D() } )

		If LEN(aOrdProd) > 0

			oDlgMon := msDialog():New(aSizBrw[1],aSizBrw[2],aSizBrw[6],aSizBrw[5],cMonitor,,,,,,,,,.t.)
			oTGr1qd := TGroup():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],'[ Ações da Central de Produção ]',oDlgMon,,,.t.,)

			oBtnCon := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+003,'Visualiza OP'    ,oDlgMon,{|| U_M04M12C() }                                                                ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnEmp := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+053,'Empenho OP'      ,oDlgMon,{|| U_M04M12E() }                                                                   ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnApo := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+103,'Apontamento OP'  ,oDlgMon,{|| U_M04M12O() }                                                                   ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnMet := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+153,'Importa Metalix' ,oDlgMon,{|| U_M04M12M() }                                                                   ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			//oBtnImp := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+  3,'Imprime OP'      ,oDlgMon,{|| LjMsgRun( "Aguarde, Imprimindo OP's..."              ,, {|| U_M04M12R() } ) },45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnExp := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+203,'Exporta Excel'   ,oDlgMon,{|| U_M04M12X(1) }                                                                 ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnDes := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+253,'Vis.Anexo Eng.'  ,oDlgMon,{|| U_M04M12A() }                                                                 ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnRef := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+303,'Refresh'         ,oDlgMon,{|| oDlgMon:End() }                                                               ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnFil := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+353,'Filtro'          ,oDlgMon,{|| (lFiltro:=.T.,oDlgMon:End()) }                                                ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnLeg := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+403,'Legenda'         ,oDlgMon,{|| U_M04M12B() }                                                                  ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
			oBtnExi := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+453,'Sair'            ,oDlgMon,{|| (lExit := .T.,oDlgMon:End()) }                                                ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)

			//If !MPUserHasAccess("MATR820", 3 /*OP_INCLUIR*/)
			//	oBtnImp:lActive   := .F.
			//EndIf
			If !MPUserHasAccess("MATA381", 4 /*OP_ALTERAR*/)
				oBtnEmp:lActive   := .F.
			EndIf
			If !MPUserHasAccess("MATA250", 3 /*OP_INCLUIR*/)
				oBtnApo:lActive   := .F.
				oBtnMet:lActive   := .F.
			EndIf

			//Quadro com as Ordens de Produção
			oTGr2qd := TGroup():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],'[ '+cTitulo+' ]',oDlgMon,,,.t.,)
			oBrwOP  := MsBrGetDBase():New(aPosObj[2,1]+8,aPosObj[2,2]+1,aPosObj[2,4]-5,aPosObj[2,3]-aPosObj[2,1]-5/*25*/,,,,oDlgMon/*oWnd*/,,,,,,,,,,,,.f.,'',.t./*lPixel*/,,.f.,,,)
			oBrwOP:SetArray(aOrdProd)
			oBrwOP:bChange := { || CarregaOP() }
			//oBrwOP:bGotFocus := { || CarregaOP() }
			oBrwOP:blDblClick := { || (lDblClick := .T.,aOrdProd[oBrwOP:nAt,1] := !aOrdProd[oBrwOP:nAt,1],oBrwOP:Refresh(),lDblClick := .F.) }

			//oBrwOP:bCustomEditCol := { | nCol, cEdit, nKey, oSelf, oMother | conOut( "bCustomEditCol" ) }
			//oBrwOP:BSUPERDEL := { || .F. }
			//oBrwOP:BDELOK    := { || .F. }
			oBrwOP:bHeaderClick := {|oObj,nCol| IIf( nCol==1 , ( AEVal(aOrdProd,{|x| x[1] := !x[1] }) , oObj:Refresh() ),) }

			If Len(oBrwOP:aColumns) == 0
				oBrwOP:AddColumn(TCColumn():New('  '   		,{|| (/*CarregaOP()*/,Iif(aOrdProd[oBrwOP:nAt,1],'LBOK',"LBNO"))},,,,'CENTER', 10,.t.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Status'   		,{|| Iif(aOrdProd[oBrwOP:nAt,11] = 0, IIF(aOrdProd[oBrwOP:nAt,21]>0,"BR_AMARELO",Iif(aOrdProd[oBrwOP:nAt,20]="S",'BR_AZUL',Iif(aOrdProd[oBrwOP:nAt,20]="P",'BR_VIOLETA','BR_VERDE'))),;
					(Iif(aOrdProd[oBrwOP:nAt,11] > 0 .And. EMPTY(aOrdProd[oBrwOP:nAt,12]), 'BR_AZUL',;
					(Iif(!EMPTY(aOrdProd[oBrwOP:nAt,12]), 'BR_VERMELHO',;
					)))))},,,,'CENTER', 25,.t.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Lib.Sep.'   	,{|| Iif(aOrdProd[oBrwOP:nAt,16] = ' ', IIF(aOrdProd[oBrwOP:nAt,19],'BR_VERDE','BR_VERMELHO'),;
					'BR_AMARELO') },,,,'CENTER', 25,.t.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New(PADR('Numero da OP',25),{|| aOrdProd[oBrwOP:nAt, 2]},,,,'LEFT'	, TAMSX3("C2_NUM")[1]+30       ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Item'   	   ,{|| aOrdProd[oBrwOP:nAt, 3]},,,,'LEFT'	, TAMSX3("C2_ITEM")[1]+10      ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New(PADR('Sequencia',15),{|| aOrdProd[oBrwOP:nAt, 4]},,,,'LEFT'	, TAMSX3("C2_SEQUEN")[1]+15    ,.f.,.f.,,,,.f.,))
				//oBrwOP:AddColumn(TCColumn():New('Item Grd.'    ,{|| aOrdProd[oBrwOP:nAt, 5]},,,,'LEFT'	, TAMSX3("C2_ITEMGRD")[1]+15   ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Produto'      ,{|| aOrdProd[oBrwOP:nAt, 6]},,,,'LEFT'	, TAMSX3("C2_PRODUTO")[1]+15   ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Descrição'    ,{|| aOrdProd[oBrwOP:nAt, 7]},,,,'LEFT'	, TAMSX3("B1_DESC")[1]+30      ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Emissão'      ,{|| aOrdProd[oBrwOP:nAt, 8]},,,,'LEFT'	, TAMSX3("C2_EMISSAO")[1]+10   ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Prv.Inicio'  ,{|| aOrdProd[oBrwOP:nAt, 24]},,,,'LEFT'	, TAMSX3("C2_DATPRI")[1]+10    ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New('Prv.Entrega'  ,{|| aOrdProd[oBrwOP:nAt, 9]},,,,'LEFT'	, TAMSX3("C2_DATPRF")[1]+10    ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New(PADR('Quantidade',25) ,{|| aOrdProd[oBrwOP:nAt, 10]},PesqPict("SC2","C2_QUANT"),,,'RIGHT', TAMSX3("C2_QUANT")[1]+15  ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New(PADR('Qt.Entregue',25),{|| aOrdProd[oBrwOP:nAt, 11]},PesqPict("SC2","C2_QUJE"),,,'RIGHT', TAMSX3("C2_QUJE")[1]+15  ,.f.,.f.,,,,.f.,))
				oBrwOP:AddColumn(TCColumn():New(PADR('Encerramento',20) ,{|| aOrdProd[oBrwOP:nAt, 12]},,,,'LEFT'	, TAMSX3("C2_DATRF")[1]+20    ,.f.,.f.,,,,.f.,))
				//oBrwOP:AddColumn(TCColumn():New('Lib.Separacao',{|| aOrdProd[oBrwOP:nAt, 16]},,,,'LEFT'	, TAMSX3("C2_XLIBSEP")[1]+25    ,.f.,.f.,,,,.f.,))
				//oBrwOP:AddColumn(TCColumn():New('Impressão OP' ,{|| aOrdProd[oBrwOP:nAt, 17]},,,,'LEFT'	, TAMSX3("C2_XIMPOPE")[1]+25    ,.f.,.f.,,,,.f.,))
				//oBrwOP:AddColumn(TCColumn():New('Cliente'      ,{|| aOrdProd[oBrwOP:nAt, 25]},,,,'LEFT'	, TAMSX3("A1_NOME")[1]+30      ,.f.,.f.,,,,.f.,))
				//oBrwOP:AddColumn(TCColumn():New('Vendedor'     ,{|| aOrdProd[oBrwOP:nAt, 26]},,,,'LEFT'	, TAMSX3("A3_NOME")[1]+30      ,.f.,.f.,,,,.f.,))

				oBrwOP:AddColumn(TCColumn():New(''   		   ,{|| ''},,,,'CENTER', 1,.f.,.f.,,,,.f.,)) //Melhorar distribuição dos campos na tela

				oBrwOP:SetHeaderImage(04 /*nPosCol*/,Iif(aRetPar[16]="1","COLDOWN",""/*"COLRIGHT"*/)/*cRes*/)  //Numero da OP
				oBrwOP:SetHeaderImage(11 /*nPosCol*/,Iif(aRetPar[16]="2","COLDOWN",""/*"COLRIGHT"*/)/*cRes*/) //Prv.Inicio
			EndIf
			oBrwOP:CallRefresh()

			oTGr4qd := TGroup():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],'[ Empenho de Materiais ] *** Double Click = Drill Down de Produtos PI ***',oDlgMon,,,.t.,)
			oBrwEmp := MsBrGetDBase():New(aPosObj[3,1]+8,aPosObj[3,2]+1,aPosObj[3,4]-5,aPosObj[3,3]-aPosObj[3,1]-5/*25*/,,,,oDlgMon,,,,,,,,,,,,.f.,'',.t.,,.f.,,,)
			oBrwEmp:SetArray(aEmpenhos)
			oBrwEmp:blDblClick := { || (fDrillDown() /*,aEmpenhos[oBrwEmp:nAt,1] := !aEmpenhos[oBrwEmp:nAt,1],oBrwEmp:Refresh()*/) }
			//oBrwEmp:bHeaderClick := {|oObj,nCol| IIf( nCol==1 , ( AEVal(aEmpenhos,{|x| x[1] := !x[1] }) , oObj:Refresh() ),) }

			If Len(oBrwEmp:aColumns) == 0
				oBrwEmp:AddColumn(TCColumn():New('  '   		    ,{|| aEmpenhos[oBrwEmp:nAt,9]},,,,'CENTER', 10,.t.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Ordem de Produção',30),{|| aEmpenhos[oBrwEmp:nAt, 1]},,,,'LEFT'	, TAMSX3("D4_OP")[1]+15  ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New('Componente'       ,{|| aEmpenhos[oBrwEmp:nAt, 2]},,,,'LEFT'	, TAMSX3("D4_COD")[1]+15  ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New('Descrição'  	    ,{|| aEmpenhos[oBrwEmp:nAt, 3]},,,,'LEFT'	, TAMSX3("B1_DESC")[1]+30      ,.f.,.f.,,,,.f.,))
				//oBrwEmp:AddColumn(TCColumn():New('Local'            ,{|| aEmpenhos[oBrwEmp:nAt, 4]},,,,'LEFT'	, TAMSX3("D4_LOCAL")[1]+15,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New('UM'               ,{|| aEmpenhos[oBrwEmp:nAt, 11]},,,,'LEFT'	, TAMSX3("B1_UM")[1]+15,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New('Quantidade'       ,{|| aEmpenhos[oBrwEmp:nAt, 5]},PesqPict("SD4","D4_QUANT"),,,'RIGHT'	, TAMSX3("D4_QUANT")[1]+20 ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.'+cLocArm,30),{|| aEmpenhos[oBrwEmp:nAt, 6]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
				//oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.CQ',30)  ,{|| aEmpenhos[oBrwEmp:nAt, 7]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.'+cLocProc,30)  ,{|| aEmpenhos[oBrwEmp:nAt, 12]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Qtd.Prv.Entrada',30),{|| aEmpenhos[oBrwEmp:nAt, 8]},PesqPict("SD4","D4_QUANT"),,,'RIGHT'	, TAMSX3("D4_QUANT")[1]+20 ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Data Prev.Entrega',30),{|| aEmpenhos[oBrwEmp:nAt, 13]},,,,'LEFT'	, TAMSX3("C7_DATPRF")[1]+15,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New(PADR('Qtd.Lib.Sep.',30),{|| aEmpenhos[oBrwEmp:nAt,14]},PesqPict("SD4","D4_QUANT"),,,'RIGHT'	, TAMSX3("D4_QUANT")[1]+20 ,.f.,.f.,,,,.f.,))
				oBrwEmp:AddColumn(TCColumn():New('  '   		    ,{|| ''},,,,'CENTER', 10,.t.,.f.,,,,.f.,)) //Melhorar distribuição dos campos na tela
			EndIf
			oBrwEmp:CallRefresh()

			oBrwOP:goTop() //Força ir para a primeira linha

			lExit := .F.
			oDlgMon:Activate(,,,.t.,{|| .t. },,{|| .t.})

			If lExit
				Exit
			EndIf
		Else
			MsgAlert("Não encontrado Ordens de Produção com o filtro informado! Revise o filtro")
			lFiltro := .T.
		EndIf

	EndDo


Return Nil

/*

DRILL DOWN - CHAMA A ROTINA PARA FAZER O DRILL DOWN

*/
Static Function fDrillDown()

	Local aArea    := GETAREA()
	Local aAutoRet := AClone(aRetPar)

	If POSICIONE("SB1",1,xFilial("SB1")+aEmpenhos[oBrwEmp:nAt,2],"B1_TIPO") == "PI"

		aAutoRet[1] := CTOD("  /  /    ")
		aAutoRet[2] := aOrdProd[oBrwOP:nAt, 9] //CTOD("31/12/2049")
		//aAutoRet[3] := "5" //Todas
		aAutoRet[5] := ""
		aAutoRet[6] := aEmpenhos[oBrwEmp:nAt,2]
		aAutoRet[7] := aEmpenhos[oBrwEmp:nAt,2]
		aAutoRet[8] := REPLICATE(' ',TAMSX3("D3_OP")[1])
		aAutoRet[9] := REPLICATE('Z',TAMSX3("D3_OP")[1])
		aAutoRet[10] := "1" //Considerar PI

		U_M04M12(aAutoRet)
	EndIf

	RESTAREA(aArea)

Return Nil

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CarregaOP
Carrega informação da Ordem de Produção posicionada 

@author    Montes 
@version   12.1
@since     13.12.2024

@param -
@return NIL

/*/
//------------------------------------------------------------------------------------------
Static Function CarregaOP()
	Local aArea
	Local nSldEst   := 0
	Local nSldCQ    := 0
	Local nPrvEnt   := 0
	Local nSldProc  := 0

	If nAtAnt <> oBrwOP:nAt .And. !lDblClick

		aArea     := GETAREA()
		aEmpenhos := {}
		aRoteiros := {}
		lTemSaldo := .T.

		dbSelectArea("SC2")
		dbGoTo(aOrdProd[oBrwOP:nAt][13]) //RECSC2

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTo(aOrdProd[oBrwOP:nAt][14]) //RECSB1

		dbSelectArea("SB2")
		dbSetOrder(1)

		dbSelectArea("SD4")
		dbSetOrder(2) //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
		While !EOF() .And. D4_FILIAL == xFilial("SD4") .And. D4_OP == SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD

			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SD4->D4_COD)

			dbSelectArea("SB2")
			dbSeek(xFilial("SB2")+SD4->D4_COD+cLocArm/*SD4->D4_LOCAL*/)
			nSldEst := SB2->B2_QATU //Verificar necessidade de usar função CALCEST()
			nPrvEnt := SB2->B2_SALPEDI
 
			dbSelectArea("SB2")
			dbSeek(xFilial("SB2")+SD4->D4_COD+cLocCQ)
			nSldCQ := SB2->B2_QATU //Verificar necessidade de usar função CALCEST()
			dbSelectArea("SD4")

			dbSelectArea("SB2")
			dbSeek(xFilial("SB2")+SD4->D4_COD+cLocProc)
			nSldProc := SB2->B2_QATU //Verificar necessidade de usar função CALCEST()
			dbSelectArea("SD4")

			dDatPrf := CTOD("  /  /  ") //Carregar a data de previsão de entrega do primeiro pedido de compra em aberto
			dbSelectArea("SC7")
			dbSetOrder(7) //C7_FILIAL+C7_PRODUTO+DTOS(C7_DATPRF)
			dbSeek(xFilial("SC7")+SD4->D4_COD)
			While !EOF() .And. C7_FILIAL+C7_PRODUTO == xFilial("SC7")+SD4->D4_COD

				If SC7->C7_RESIDUO <> 'R' .And. SC7->C7_ENCER <> 'E' .And. SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA) > 0
					dDatPrf := SC7->C7_DATPRF
					Exit
				EndIf

				dbSelectArea("SC7")
				dbSkip()
			EndDo
			dbSelectArea("SD4")

			//Carrega Saldo do Produto Liberado para Separação
			nSldLib := CarSldLib(SD4->D4_COD) 

			AADD(aEmpenhos, {SD4->D4_OP,SD4->D4_COD,SB1->B1_DESC,SD4->D4_LOCAL,SD4->D4_QUANT,nSldEst,nSldCQ,nPrvEnt,"BR_VERMELHO","Sim",SB1->B1_UM,nSldProc,dDatPRF,nSldLib} )

			//Verifica se tem saldo para o componente em estoque no Armazem (Ex.01), caso Produto PI considera o saldo em Processo tambem (Ex.Arm.01 + Arm.03)
			//Abate o saldo liberado para separação anteriormente #MONTES20241205
			//Se já liberado para separação considera como VERDE #MONTES20241205
			If .F. //EMPTY(SC2->C2_XLIBSEP) .And. ( SD4->D4_QUANT ) > 0 .And. ( SD4->D4_QUANT ) > IIF(SB1->B1_TIPO="PI",nSldEst+nSldCQ,nSldEst) - nSldLib
				lTemSaldo := .F.
				If (nSldEst - nSldLib) > 0 //Saldo do armazem maior que zero - saldo para atendimento parcial
					aEmpenhos[Len(aEmpenhos),9] := 'BR_AMARELO'
				Else
					aEmpenhos[Len(aEmpenhos),9] := 'BR_VERMELHO'
				EndIf
			Else
				aEmpenhos[Len(aEmpenhos),9] := 'BR_VERDE'
			EndIf

			dbSelectArea("SD4")
			dbSkip()
		EndDo

		dbSelectArea("SH1")
		dbSetOrder(1)

		aOrdProd[oBrwOP:nAt][19] := lTemSaldo

		nAtAnt := oBrwOP:nAt

		oBrwEmp:SetArray(aEmpenhos)
		oBrwEmp:Refresh()
		oBrwEmp:GoTop()

		RESTAREA(aArea)
	EndIf

Return .T. //Permite ou não movimentar a linha para cima ou para baixo

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12D
Carrega dados conforme filtro
@author    Montes - MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12D()

	Local aOrdProd   := {}
	Local cSeparada  := "N"
	Local nQtdEmpOri := 0
	Local nQtdEmpSld := 0

	CursorWait()

	//+---------------------------------------------------------------+
	//| Carrega Ordens de Produção conforme os parametros informados  |
	//+---------------------------------------------------------------+
	cQuery := "SELECT SC2.R_E_C_N_O_ RECSC2,SB1.R_E_C_N_O_ RECSB1 " 
	cQuery += "FROM "+RetSQLName("SC2")+" SC2 "
	cQuery += "INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
	cQuery += "SC2.C2_DATPRI BETWEEN '"+DTOS(dIniDe)+"' AND '"+DTOS(dIniAte)+"' AND "
	cQuery += "SC2.C2_DATPRF BETWEEN '"+DTOS(dPrvDe)+"' AND '"+DTOS(dPrvAte)+"' AND "
	If aRetPar[3] = "1" //Em aberto/Iniciada
		cQuery += "SC2.C2_DATRF = '  ' AND " //"SC2.C2_QUJE = 0 AND SC2.C2_DATRF = '  ' AND "
		cTitulo := "Em aberto/Iniciada"
	ElseIf aRetPar[3] = "2" //Em aberto somente
		cQuery += "SC2.C2_QUJE = 0 AND SC2.C2_DATRF = '  ' AND "
		cTitulo := "Em aberto somente"
	ElseIf aRetPar[3] = "3" //Iniciada Somente
		cQuery += "SC2.C2_DATRF = '  ' AND " 
		cTitulo := "Iniciadas Somente"
	ElseIf aRetPar[3] = "4" //Encerrado
		cQuery += "SC2.C2_DATRF <> '  ' AND "
		cTitulo := "Encerradas"
	Else
		cTitulo := "Todas"
	EndIf
	cQuery += "SB1.B1_COD >= '"+aRetPar[5]+"' AND "
	cQuery += "SB1.B1_COD <= '"+aRetPar[6]+"' AND "
	cQuery += "C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+aRetPar[7]+"' AND "
	cQuery += "C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+aRetPar[8]+"' AND "
	If aRetPar[9] = "2" //Não considerar produtos PI
		cQuery += "SB1.B1_TIPO <> 'PI' AND "
	EndIf

	//Considerar somente OP's Firmes
	cQuery += "SC2.C2_TPOP = 'F' AND "

	//Filtra pelo Pedido de Venda
	cQuery += "( "
	cQuery += "(SC2.C2_PEDIDO BETWEEN '"+aRetPar[12]+"' AND '"+aRetPar[13]+"' AND SC2.C2_ITEMPV BETWEEN '"+aRetPar[14]+"' AND '"+aRetPar[15]+"' ) OR "
	cQuery += "(SELECT COUNT(*) FROM "+ RetSqlName('SC2')+" SC2X WHERE SC2X.C2_FILIAL = '"+xFilial("SC2")+"' AND SC2X.C2_NUM = SC2.C2_NUM AND SC2X.C2_ITEM = SC2.C2_ITEM AND SC2X.C2_SEQUEN = '001' AND SC2X.C2_PEDIDO BETWEEN '"+aRetPar[12]+"' AND '"+aRetPar[13]+"' AND SC2X.C2_ITEMPV BETWEEN '"+aRetPar[14]+"' AND '"+aRetPar[15]+"' AND SC2X.D_E_L_E_T_ = ' ') > 0 "
	cQuery += ") AND "

	//Filtra status do saldo dos componentes (Empenhos) - filtro conforme Legenda
	// Agrega Saldo do CQ somente para PI
	If aRetPar[17] <> "1" //Todos
		cQuery += "( "
		cQuery += "(SELECT TOP 1 1 " //SOMENTE UM REGISTROS CASO TIVER MAIS DE UM PARA EVITAR ERRO EM QUERY
		cQuery += "FROM "+RetSqlName('SD4')+" SD4 "
		cQuery += "INNER JOIN "+RetSqlName('SB1')+" SB1EMP ON SB1EMP.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EMP.B1_COD = D4_COD AND SB1EMP.D_E_L_E_T_ = ' ' "
		cQuery += "LEFT OUTER JOIN "+RetSqlName('SB2')+" SB2   ON B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = D4_COD AND B2_LOCAL = '"+cLocArm+"' AND SB2.D_E_L_E_T_ = ' ' "
		cQuery += "LEFT OUTER JOIN "+RetSqlName('SB2')+" SB2CQ ON SB2CQ.B2_FILIAL = '"+xFilial("SB2")+"' AND SB2CQ.B2_COD = D4_COD AND SB2CQ.B2_LOCAL = '"+cLocCQ+"' AND SB1EMP.B1_TIPO = 'PI' AND SB2CQ.D_E_L_E_T_ = ' ' "
		cQuery += "WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "
		cQuery += "AND SD4.D4_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD "
		cQuery += "AND SD4.D4_QUANT > 0 "
		cQuery += "AND SD4.D_E_L_E_T_ = ' ' "
		cQuery += "HAVING "
		If aRetPar[17] = "2" //Empenho com estoque suficiente - Total de Registros de Empenho = Quantidade de Itens com quantidade suficiente em estoque
			cQuery += "COUNT(*) = SUM(CASE WHEN (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) > 0 AND D4_QUANT <= (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) THEN 1 ELSE 0 END) "
		ElseIf aRetPar[17] = "3" //Empenho com estoque parcial - Tem itens com Saldo Suficiente mas não é todos os registros de empenho
			cQuery += "SUM(CASE WHEN (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) > 0 AND D4_QUANT <= (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) THEN 1 ELSE 0 END) > 0 AND "
			cQuery += "COUNT(*) > SUM(CASE WHEN (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) > 0 AND D4_QUANT <= (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) THEN 1 ELSE 0 END) "
		ElseIf aRetPar[17] = "4" //Empenho sem saldo em estoque - Nenhum Item de Empenho Tem Saldo Suficiente
			cQuery += "SUM(CASE WHEN (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) > 0 AND D4_QUANT <= (ISNULL(SB2.B2_QATU,0)+ISNULL(SB2CQ.B2_QATU,0)) THEN 1 ELSE 0 END) = 0 "
		EndIf
		cQuery += ") = 1 "
		cQuery += ") AND "
	EndIf

	cQuery += "SC2.D_E_L_E_T_ = ' ' "

	//Ordem de VIsualização	
	If aRetPar[16] = "1" //Numero da OP
		cQuery += "ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD "
	Else //Previsão de Inicio
		cQuery += "ORDER BY C2_DATPRI,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o tratamento/compatibilidade com o Top Connect    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := ChangeQuery(cQuery)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega uma sequencia de alias para o temporario.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasTrb := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o ALIAS do arquivo temporario                     		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasTrb, .F., .T.)

	dbSelectArea(cAliasTrb)
	dbGoTop()

	ProcRegua(Lastrec())

	While (cAliasTrb)->(!EOF())

		SC2->(dbGoTo((cAliasTrb)->(RECSC2)))
		SB1->(dbGoTo((cAliasTrb)->(RECSB1)))

		IncProc("Lendo OP " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+ "...")

		cSeparada := " "
		dbSelectArea("SD4")
		dbSetOrder(2) //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		If dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
			nQtdEmpOri := 0
			nQtdEmpSld := 0
			While !EOF() .And. D4_FILIAL+D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
				nQtdEmpOri += SD4->D4_QTDEORI
				nQtdEmpSld += SD4->D4_QUANT
				dbSkip()
			EndDo
			If nQtdEmpOri > 0
				If nQtdEmpSld = 0
					cSeparada := "S"
				ElseIf nQtdEmpSld < nQtdEmpOri
					cSeparada := "P"
				Else
					cSeparada := "N"
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAliasTrb)

		If aRetPar[4] = "4" .And. !(SC2->C2_QUJE = 0 .And. !(cSeparada $ " |N")) //Somente considerar separados total ou parcial - Legenda Azul e Violeta
			dbSelectArea(cAliasTrb)
			dbSkip()
			Loop
		ElseIf aRetPar[4] = "5" .And. !(SC2->C2_QUJE = 0 .And. cSeparada <> "P") //Somente considerar separados parciais - Legenda Violeta
			dbSelectArea(cAliasTrb)
			dbSkip()
			Loop
		ElseIf aRetPar[4] = "6" .And. !(SC2->C2_QUJE = 0 .And. (cSeparada $ " |N")) //Somente considerar não Separados - Legenda Verde
			dbSelectArea(cAliasTrb)
			dbSkip()
			Loop
		EndIf

		AADD(aOrdProd,{.F.,;                                            //1-Mark
							SC2->C2_NUM,;                               //2-OP
							SC2->C2_ITEM,;                              //3-Item
							SC2->C2_SEQUEN,;                            //4-Sequencia
							SC2->C2_ITEMGRD,;                           //5-Item Grd.
							SC2->C2_PRODUTO,;                           //6-Produto
							SB1->B1_DESC,;                              //7-Descrição
							SC2->C2_EMISSAO,;                           //8-Emissao
							SC2->C2_DATPRF,;                            //9-Prv.Entrega
							SC2->C2_QUANT,;                             //10-Quantidade
							SC2->C2_QUJE,;                              //11-Qt.Entregue
							SC2->C2_DATRF,;                             //12-Encerramento
							(cAliasTrb)->RECSC2,;                       //13-RECSC2
							(cAliasTrb)->RECSB1,;                       //14-RECPA1
							{},;                                        //15-Array com as Operações
							"",;                                        //16-Liberação para Separação
							"",;                                        //17-Impressao da OP
							"",;                                        //18-RECSCJ
							.F.,;                                       //19-Tem Saldo
							cSeparada,;                                 //20-Separada
							0,;                                         //21-Iniciada
							"",;                                        //22-
							"",;                                        //23-Fase do Pedido
							SC2->C2_DATPRI,;                            //24-Prv.Inicio
							"",;                                        //25-Nome do Cliente
							""})                                        //26-Nome do Vendedor

		dbSelectArea(cAliasTrb)
		dbSkip()
	EndDo
	dbSelectArea(cAliasTrb)
	dbCloseArea()

	CursorArrow()
//ApMsgInfo("Carga finalizada !","Atenção!")

Return aOrdProd

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12C
Consulta Ordem de Produção
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12C()

	Local aArea     := GETAREA()

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTo(aOrdProd[oBrwOP:nAt][13])
	If !EOF()

		MATA650(,2)

	EndIf

	RESTAREA(aArea)

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12E
Altera Empenho da OP
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12E()

	Local aArea      := GETAREA()
	Local lA381Manut := .T.

	Private INCLUI := .F.
	Private ALTERA := .T.

	dbSelectArea("SD4")
	dbSetOrder(2)
	If dbSeek(xFilial("SD4")+aOrdProd[oBrwOP:nAt][2]+aOrdProd[oBrwOP:nAt][3]+aOrdProd[oBrwOP:nAt][4]+aOrdProd[oBrwOP:nAt][5])

		MATA381(,,4,lA381Manut)

	EndIf

	RESTAREA(aArea)

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12O
Apontamento de Ordem de Produção Simples
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12O()

	Local aArea     := GETAREA()

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTo(aOrdProd[oBrwOP:nAt][13])
	If !EOF()

		MATA250(,3)

	EndIf

	RESTAREA(aArea)

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12A
Visualiza Anexo Engenharia
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12A()

	Local aArea     := GETAREA()

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTo(aOrdProd[oBrwOP:nAt][14]) //RECSB1
	If !EOF()

		U_M04M10(2)

	EndIf

	RESTAREA(aArea)

Return

																		  

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12M
Importa arquivo retorno METALIX

@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12M()

	Local aArea     := GETAREA()
	Local aPergs    := {}
	Local aRetPar   := {}
	//Local nHandle   := 0
	Local nP        := 0
	Local nPos      := 0
	Local aPecasAUX := {}
	Local aPecas    := {}
	Local nRecno
	Local nOp
	Local nPeca
	Local cAviso    := ""
	Local cPastaIni := "c:\metalix\"

	PRIVATE aOps  := {}
	PRIVATE aEmp  := {}
	PRIVATE aRefs := {}
	PRIVATE cLote := ""
	PRIVATE lApontaRef  := GETMV("ES_APOREF",.F.,.F.) //Aponta Refugo ou considera o custo pro produto final
	PRIVATE cFileName := ""
	
	Aadd(aPergs, {6, "Arquivo CSV para Importação",SPACE(200),"","","",100,.T.,"Todos os arquivos (*.CSV) |*.CSV",cPastaIni,GETF_LOCALHARD+GETF_NETWORKDRIVE}) //1

	If !ParamBox(aPergs, "Importação do arquivo de retorno de apontamento do METALIX", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)
		Return 
	EndIf

	CursorWait()

	cFileName := aRetPar[1]

	/*
	nHandle := FT_FUse(cFileName)
  
	If nHandle = -1 // Se houver erro de abertura abandona processamento
		Aviso("Erro","Erro na abertura do arquivo:"+cFileName,{"Fechar"})
    	return
  	EndIf

  	FT_FGoTop() // Posiciona na primeria linha
  	
  	nLast := FT_FLastRec() // Retorna o número de linhas do arquivo
	*/
	oFile := FwFileReader():New(cFileName)
	If !(oFile:Open())
		Aviso("Erro","Erro na abertura do arquivo:"+cFileName,{"Fechar"})
    	return
	EndIf

	aLinhas := oFile:GetAllLines() // ACESSA TODAS AS LINHAS

	oFile:Close() // Fecha o Arquivo

	nLast := LEN(aLinhas)

	lCabec := .T.

	/*
	Pedido:;CSV-PROTHEUS.Dsp;Date: 11.12.2024, 14:07:03;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;
	Programador:;;PEDRO;;;;Maquina:;;LC3015F;;;;;;;;;;;;;;
	Núm. Total de Chapas:;;;3;;Número Total de Sub-Nest:;;;;3;;;;;;;;;;;;;
	Total de Peças Colocadas:;;;44;;Total de Peças Solicitadas:;;;;44;;;;;;;;;;;;;
	Obs.:;;;;;;;Eficiência:;;;82,31%;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;
	SubNests no Pedido;;;;;;;;;;;;;;;;;;;;;;
	No.;Vista;Tam. X (mm);Tam. Y (mm);Material;Esp. (mm);QTD;PESO CHAPA;AREA DA CHAPA;Eff. %;% DE SUCATA;Peças no Pedido;;;;;;;;;;;
	1;;3000;1240;INOX304PEL;1,5;1;43,524;3,72;85,74;14,26;1A24552-01, 1A12292-01, 1A12293-01, 1A12291-01(x3), 1A12292-01, 3A02796-01(x2), 3A02796-01, 1A12291-01, 3A02796-01(x8), 1A02717-01, 3A02796-01(x5), 1A12292-01(x2), 1A12277-01, 1A23613-01, 1A02717-01(x3), 1A12293-01, 1A02717-01, 1A12278-01, 1A12303-01, 1A12280-013;;;;;;;;;;;
	2;;3000;1200;CHAPA PRETA;2;1;56,16;3,6;80,92;19,08;BR2521A, TAINF(x5);;;;;;;;;;;
	3;;500;1200;CHAPA PRETA;2;1;9,36;0,6;84,05;15,95;BR2521A;;;;;;;;;;;
	Peças no SubNests;;;;;;;;;;;;;;;;;;;;;;
	No.;Nome da Paça;Vista;Esp.;Material;Qtd. Solicitada;Qtd. Alocada;Tam. X;Tam. Y;Peso;Abastecido;Op / Familia;Peso Tot.;;;;;;;;;;
	1;1A02717-01.dft;;1,5;INOX304PEL;5;5;324,8;176,4;0,67;;TWP03001001;3,35;;;;;;;;;;
	2;1A12277-01.dft;;1,5;INOX304PEL;1;1;237,93;170,25;0,43;;TWP03201001;0,43;;;;;;;;;;
	3;1A12278-01.dft;;1,5;INOX304PEL;1;1;430,9;190,16;0,84;;TWP05801001;0,84;;;;;;;;;;
	4;1A12280-013.dft;;1,5;INOX304PEL;1;1;567,97;536,03;2,97;;TWP06101001;2,97;;;;;;;;;;
	5;1A12291-01.dft;;1,5;INOX304PEL;4;4;75;24,99;0,02;;TWP04801001;0,08;;;;;;;;;;
	6;1A12292-01.dft;;1,5;INOX304PEL;4;4;90;13,8;0,01;;TWP04901001;0,04;;;;;;;;;;
	7;1A12293-01.dft;;1,5;INOX304PEL;2;2;214;25,99;0,05;;TWP05001001;0,1;;;;;;;;;;
	8;1A12303-01.dft;;1,5;INOX304PEL;1;1;904,48;362,39;3,83;;TWP04001001;3,83;;;;;;;;;;
	9;1A23613-01.dft;;1,5;INOX304PEL;1;1;184,52;104,12;0,22;;TWP05901001;0,22;;;;;;;;;;
	10;1A24552-01.dft;;1,5;INOX304PEL;1;1;92,2;53;0,05;;TWP06001001;0,05;;;;;;;;;;
	11;3A02796-01.dft;;1,5;INOX304PEL;1;1;15;15;0,00;;TWP05701001;0;;;;;;;;;;
	12;3A02796-01.dft;;1,5;INOX304PEL;15;15;15;15;0,00;;TWP05701001;0;;;;;;;;;;
	13;BR2521A.dft;;2;CHAPA PRETA;2;2;626,49;449,49;4,36;;;8,72;;;;;;;;;;
	14;TAINF.DFT;;2;CHAPA PRETA;5;5;1016,88;484,88;7,57;;;37,85;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;
	*/

	lSubNests    := .F.
	lPecSubNests := .F.
	lOps         := .F.
	lEmps        := .F.

 	/*
	While !FT_FEOF()

    	cLine  := FT_FReadLn() // Retorna a linha corrente
    	nRecno := FT_FRecno() // Retorna o recno da Linha
	*/	
	For nRecno := 1 To nLast

		cLine := aLinhas[nRecno]

		aDados := StrTokArr2(Upper(cLine),";",.T.)	

		If "Pedido:" $ cLine
			cLote := UPPER(aDados[2])
		ElseIf "SubNests no Pedido" $ cLine
			lSubNests := .T.
		ElseIf "Peças no SubNests" $ cLine .Or. "Pe‡as no SubNests" $ cLine
			lPecSubNests := .T.
			lSubNests := .F.
			lEmps := .F.
		ElseIf lSubNests .And. "No." $ cLine
			
			lEmps := .T.

		ElseIf lSubNests .And. lEmps

			If LEN(aDados) >= 27 .And. !EMPTY(aDados[5]) .And. !EMPTY(aDados[15]) 
				
				cMP       := aDados[5] //PADR(aDados[5],TAMSX3("B1_XMAT")[1])
				nEspess   := VAL(STRTRAN(STRTRAN(aDados[6],".",""),",","."))
				nTamX     := VAL(aDados[3])
				nTamY     := VAL(aDados[4])
				nQtdChapa := VAL(aDados[7])
				nPesoCHAP := VAL(STRTRAN(STRTRAN(aDados[8],".",""),",","."))
				nAreaChap := VAL(STRTRAN(STRTRAN(aDados[11],".",""),",","."))
				nAreaEff  := VAL(STRTRAN(STRTRAN(aDados[12],".",""),",","."))
				nPercEff  := VAL(STRTRAN(STRTRAN(aDados[13],".",""),",","."))
				nPercSuc  := VAL(STRTRAN(STRTRAN(aDados[14],".",""),",","."))
				nSobra    := VAL(STRTRAN(STRTRAN(aDados[27],".",""),",","."))

				// Peso Effetivo
				nPesoEff := ( nQtdChapa * nPesoCHAP ) * ( nAreaEff / nAreaChap )

				// (Qtd. * Peso Chapa) * Perc.Sucata
				nQtdScrap := nPesoEff * ( nPercSuc / 100 )

				aPecasAux  := StrTokArr2(aDados[15],",")
				aPecas     := {}
				For nP := 1 To LEN(aPecasAux)
					
					aPecasAux[nP] := ALLTRIM(aPecasAux[nP])

					nPos := AT("(",aPecasAux[nP])
					If nPos > 0
						cQtd          := SUBSTR(aPecasAux[nP],nPos+1,(AT(")",aPecasAux[nP])-nPos)-1)
						cQtd          := STRTRAN(cQtd,"x","")
						cQtd          := STRTRAN(cQtd,"X","")
						aPecasAux[nP] := LEFT(aPecasAux[nP],nPos-1)
						aPecasAux[nP] := ALLTRIM(aPecasAux[nP])
					Else
					    cQtd       := "1"
					EndIf
					
					If LEFT(RIGHT(aPecasAux[nP],5),3) == "DXF"
						aPecasAux[nP] := LEFT(aPecasAux[nP],LEN(aPecasAux[nP])-5) //RETIRAR SUFIXO DFX99
					EndIf

					cCodPeca := UPPER(ALLTRIM(aPecasAux[nP]))

					nPeca := ASCAN(aPecas,{|x|x[1]==cCodPeca})
					If nPeca = 0
						AADD(aPecas,{cCodPeca,( VAL(cQtd) * nQtdChapa ),0/*Empenhada*/,0/*Peso Peça*/})
					Else
						aPecas[nPeca][2] += ( VAL(cQtd) * nQtdChapa )
					EndIf
				Next

				cEspecChapa := cMP+","+CVALTOCHAR(nTamX)+"x"+CVALTOCHAR(nTamY)+"x"+CVALTOCHAR(nEspess)+"mm"
				cComp  := ""
				cScrap := ""
				VerComp(cMP,nTamX,nTamY,nEspess,@cComp,@cScrap,nPesoEff)
								
				//nPosRef := ASCAN(aRefs,{|x|x[1]==cScrap.And.x[2]==cComp})
				//If nPosRef > 0
				//	aRefs[nPosRef][3] += nQtdScrap
				//Else
					AADD(aRefs,{cScrap,cComp,nQtdScrap,0,aPecas,nPercSuc,nPesoEff,0 /*Calculo Peso total das Peças*/,cEspecChapa}) //Adicionar Referencia de Scrap para controle de perdas e apontamento de refugo
				//EndIf
			Else

				cMsgErro := "Estrutura do arquivo inválida ! Revise."
				If !(cMsgErro $ cAviso)
					cAviso += cMsgErro+CHR(13)+CHR(10) 
				EndIf
				aOps := {} //Limpa array de OP's para não processar dados inconsistentes
			    Exit

			EndIf

		ElseIf lPecSubNests .And. "No." $ cLine
			lOps := .T.
		ElseIf lPecSubNests .And. lOps

			If LEN(aDados) >= 12 .And. !EMPTY(aDados[12])

				cOP       := PADR(aDados[12],TAMSX3("D4_OP")[1])
				cMP       := aDados[5] //PADR(aDados[5],TAMSX3("B1_XMAT")[1])
				cProdPI   := SPACE(TAMSX3("C2_PRODUTO")[1])
				cCodMPEst := SPACE(TAMSX3("D4_COD")[1])
				nQtPeca   := VAL(STRTRAN(STRTRAN(aDados[7],".",""),",","."))
				nPesoPC   := VAL(STRTRAN(STRTRAN(aDados[10],".",""),",","."))

				If EMPTY(nPesoPC)

					nComprimento := (VAL(STRTRAN(STRTRAN(aDados[8],".",""),",","."))/1000)
					nLargura     := (VAL(STRTRAN(STRTRAN(aDados[9],".",""),",","."))/1000)
					nEspessura   := (VAL(STRTRAN(STRTRAN(aDados[4],".",""),",",".")))

					/*
					Verificar densidade conforme chapa

					Ex.: INOX304PEL = 7.80
					     ALUMINIUM-5052 = 2.70
					*/
					nDensidade := VerDensid(cMP,nEspessura)

					nPesoPC := ROUND(nComprimento * nLargura * nEspessura * nDensidade,3) //Peso em KG da peça no corte considerando as medidas e densidade do material, multiplicado por 1000 para converter de toneladas para kg

				EndIf

				nQtNest   := nPesoPC * VAL(STRTRAN(STRTRAN(aDados[7],".",""),",",".")) //( VAL(STRTRAN(STRTRAN(aDados[9],".",""),",",".")) * VAL(STRTRAN(STRTRAN(aDados[10],".",""),",",".")) ) //Tam.X * Tam.Y
				nQtReq    := nPesoPC * VAL(STRTRAN(STRTRAN(aDados[7],".",""),",",".")) //( VAL(STRTRAN(STRTRAN(aDados[9],".",""),",",".")) * VAL(STRTRAN(STRTRAN(aDados[10],".",""),",",".")) ) //Tam.X * Tam.Y
				nQtEstr   := 0
				nQtEmp    := 0
				cCodMPUsa := SPACE(TAMSX3("D4_COD")[1])
				nPerda    := 0
				cObserv   := ""
				cCodRef   := SPACE(TAMSX3("D4_COD")[1])
				nQtdRef   := 0
				cLinha    := aDados[1]

				If nQtPeca > 0 // Só considera itens com quantidade alocada
					VerOP(cOp,@cProdPI,cMP,@cCodMPEst,@nQtEstr,@nQtEmp,@nPerda,@cCodMPUsa,@cObserv,nQtPeca,@cCodRef,@nQtdRef,nPesoPC,nQtReq,cLinha) //Posiciona na OP, Estrutura e Empenho
				EndIf
			
			Else

				cMsgErro := "Estrutura do arquivo inválida ! Revise."
				If !(cMsgErro $ cAviso)
					cAviso += cMsgErro+CHR(13)+CHR(10)
				EndIf
				aOps := {} //Limpa array de OP's para não processar dados inconsistentes
				Exit
			EndIf

		EndIf

	Next

	/*

	Recalculo da Quantidade da Requisição da Chapa com base no Peso Efetivo x Peso total da peca no corte

	*/
	For nOp := 1 To Len(aOPs)

		nPesoTotalPecas := 0
		nQtReqChapa := 0
		If aOPS[nOp][15] > 0
			For nPeca := 1 To Len(aRefs[aOPS[nOp][15]][5])
				If EMPTY(aRefs[aOPS[nOp][15]][5][nPeca][4]) //Se tiver sem peso na peça    
					nPesoTotalPecas := 0
					aOPS[nOp][11] += IIF(EMPTY(aOPS[nOp][11]),"","|") + "SubNests No."+cValToChar(aOPS[nOp][15])+" com produtos sem peso ("+ALLTRIM(aRefs[aOPS[nOp][15]][5][nPeca][1])+"), verifique pois compromete rateio para requisição do KG de CHAPA !!! "
					Exit
				EndIf
				nPesoTotalPecas += ( aRefs[aOPS[nOp][15]][5][nPeca][2] * aRefs[aOPS[nOp][15]][5][nPeca][4] ) //Quantidade x Peso Peça
			Next

			If nPesoTotalPecas > 0
				nQtReqChapa := ( (aOPs[nOp][5] * aOPs[nOp][16]) / nPesoTotalPecas ) * aRefs[aOPS[nOp][15]][7] //Proporção do Peso Efetivo da Chapa com o Peso Total das Peças vezes a Quantidade Requerida da Chapa
				aOPs[nOp][9] := nQtReqChapa
				If aOPS[nOp][15] > 0
					aOPs[nOp][6] := aRefs[aOPS[nOp][15]][6]
					aOPs[nOp][13] := ( nQtReqChapa * aRefs[aOPS[nOp][15]][6] ) / 100    //Qtd.Refugo
				Else
					aOPs[nOp][13] := 0
				EndIf
			EndIf
		EndIf

	Next

	CursorArrow()

	//Abre tela para confirmar os dados das OP's, Empenho e Perdas (REFUGO)
	/*

	Simulação Tela Importação de Arquivo Metalix, Ajustes e Apontamento OP de Corte							
							
	OP	PI(CORTE)	COMP	QTD ESTRUT.	PERDA	QTD.EMP.	PESO PC	QTD. REQ.
	0000101001	PC_001_PORTA	CHAPA LIGA 304	20	10%	22	20	20
	0000201001	PC_002_LATERAL	CHAPA LIGA 304	10	10%	11	10	10
	0000301001	PC_003_LATERAL	CHAPA LIGA 306	30	10%	33	31	31
	0000301001	PC_004_GRELHA	CHAPA LIGA 309	5	10%	5,5	6	7
								
								
	COD. SCRAP	LIGA	QTD	AJUSTE CASO TENHA PESAGEM (AJUSTE RATEADO NA QTD REQ.)				
	SCRAP LIGA	304	3	5				
	SCRAP LIGA	306	3	5				
	SCRAP LIGA	309	0,5	3												
								
	O IDEAL SERIA PESAR OS SCRAP							

	*/
	
	cLote  := PADR(cLote,TAMSX3("ZAJ_LOTE")[1])
	
	dbSelectArea("ZAJ")
	dbSetOrder(1)
	If !dbSeek(xFilial("ZAJ")+cLote)

		If LEN(aOPs) > 0

			TelaAjuste(aOPs,aRefs,cFileName)

		Else

			If !EMPTY(cAviso)
				Aviso("Aviso",cAviso,{"Fechar"})
			Else
				Aviso("Aviso","Não encontrado nenhuma OP para importação!! Revise o arquivo gerado.",{"Fechar"})
			EndIf

		EndIf

	Else

		If Aviso("Aviso","JOB já integrado anteriormente !! "+CHR(13)+CHR(10)+"Lote:"+cLote,{"Fechar","Visualizar LOG"}) = 2
			VerLog(cLote)
		EndIf

	EndIf

	RESTAREA(aArea)

Return

Static Function RetXMAT(cMP)

Local aArea := GETAREA()
Local aOpcoes    := {} 
//Local nPosMat    := 0
Local cOPMat     := " "

/*
dbSelectArea('SX3')
SX3->( dbSetOrder(2) )
SX3->( dbSeek( "B1_XMAT" ) )
aOpcoes := RetSx3Box( X3CBox(),,, 1 )
nPosMat := aScan(aOpcoes,{|x|UPPER(RTRIM(x[3]))==UPPER(RTRIM(cMP))})
If nPosMat > 0
   cOPMat := aOpcoes[nPosMat][2]
EndIf
*/
dbSelectArea("ZAK")
dbSetOrder(1)
dbGoTop()
While !EOF()
	AADD(aOpcoes,{ZAK->ZAK_COD,ZAK->ZAK_DESC})
	dbSkip()
EndDo
nPosMat := aScan(aOpcoes,{|x|UPPER(RTRIM(x[2]))==UPPER(RTRIM(cMP))})
If nPosMat > 0
   cOPMat := aOpcoes[nPosMat][1]
EndIf

RestArea(aArea)

Return cOPMAT

Static Function VerComp(cMP,nTamX,nTamY,nEspess,cComp,cScrap,nPesoEff)

Local aArea      := GETAREA()
Local cQuery     := ""
Local cAliasComp := GETNEXTALIAS()
//Local cOPMat     := " " 
Local cAMFAMIL2C := RTRIM(GetMV("AM_FAMIL2C",.F.,"000011;"))
Local cLocProc   := GETMV("MV_LOCPROC",.F.,"99") //Armazem de Processo

Default cComp  := SPACE(TAMSX3("B1_COD")[1])
Default cScrap := SPACE(TAMSX3("B1_XCODREF")[1])
Default nPesoEff := 0

//cOPMAT := RetXMAT(cMP)

cQuery := " SELECT B1_COD,B1_XCODREF,(B2_QATU-B2_RESERVA) QTDDISP "
cQuery += " ,(CASE WHEN ( "
cQuery += "  ( B5_COMPR = "+STR(nTamX,TAMSX3("B5_COMPR")[1])+" AND B5_LARG = "+STR(nTamY,TAMSX3("B5_LARG")[1]) + ") "
cQuery += " OR "
cQuery += "  ( B5_COMPR = "+STR(nTamY,TAMSX3("B5_COMPR")[1])+" AND B5_LARG = "+STR(nTamX,TAMSX3("B5_LARG")[1]) + ") "
cQuery += " ) THEN '1' ELSE '2'+RTRIM(B5_DES) END ) AS TAMORI "
cQuery += " FROM " + RetSQLName('SB1') + " SB1 "
cQuery += " INNER JOIN " + RetSQLName('SB5') + " SB5 ON B5_FILIAL = '" + xFilial("SB5") + "' AND B5_COD = B1_COD AND SB5.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN " + RetSQLName('SB2') + " SB2 ON B2_FILIAL = '" + xFilial("SB2") + "' AND B2_COD = B1_COD AND B2_LOCAL = '"+cLocProc+"' AND SB2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
//cQuery += " AND B1_XMAT = '"+cOPMAT+"' "
cQuery += " AND B1_XMAT2 = '"+cMP+"' "
cQuery += " AND B1_XFAMIL2 IN "+FormatIn(cAMFAMIL2C,";")
cQuery += " AND B5_ESPESS = "+STR(nEspess,TAMSX3("B5_ESPESS")[1],TAMSX3("B5_ESPESS")[2])
/*
cQuery += " AND ( "
cQuery += "  ( B5_COMPR = "+STR(nTamX,TAMSX3("B5_COMPR")[1])+" AND B5_LARG = "+STR(nTamY,TAMSX3("B5_LARG")[1]) + ") "
cQuery += " OR "
cQuery += "  ( B5_COMPR = "+STR(nTamY,TAMSX3("B5_COMPR")[1])+" AND B5_LARG = "+STR(nTamX,TAMSX3("B5_LARG")[1]) + ") "
cQuery += " ) "
*/
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY TAMORI, QTDDISP DESC " //Prioriza Material com quantidade atual maior e reserva maior para não alocar material que já tem baixa disponibilidade

TCQUERY cQuery NEW ALIAS (cAliasComp)

(cAliasComp)->(dbGoTop())

If (cAliasComp)->(!EOF())
	cComp  := (cAliasComp)->B1_COD
	cScrap := (cAliasComp)->B1_XCODREF
EndIf

//If EMPTY(cComp)
//	cComp := PADR(cMP,TAMSX3("B1_COD")[1])
//EndIf

If EMPTY(cScrap)
	cScrap := "SEM CODIGO"
EndIf

(cAliasComp)->(dbCloseArea())

RESTAREA(aArea)

Return 


Static Function VerDensid(cMP,nEspess)

Local aArea      := GETAREA()
Local cQuery     := ""
Local cAliasComp := GETNEXTALIAS()
//Local cOPMat     := " "
Local cAMFAMIL2C := RTRIM(GetMV("AM_FAMIL2C",.F.,"000011;"))
Local nDensidade := 0

//cOPMAT := RetXMAT(cMP)

cQuery := " SELECT TOP 1 B5_DENSID "
cQuery += " FROM " + RetSQLName('SB1') + " SB1 "
cQuery += " INNER JOIN " + RetSQLName('SB5') + " SB5 ON B5_FILIAL = '" + xFilial("SB5") + "' AND B5_COD = B1_COD AND SB5.D_E_L_E_T_ = ' ' "
cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
//cQuery += " AND B1_XMAT = '"+cOPMAT+"' "
cQuery += " AND B1_XMAT2 = '"+cMP+"' "
cQuery += " AND B1_XFAMIL2 IN "+FormatIn(cAMFAMIL2C,";")
cQuery += " AND B5_ESPESS = "+STR(nEspess,TAMSX3("B5_ESPESS")[1],TAMSX3("B5_ESPESS")[2])
cQuery += " AND B5_DENSID > 0"
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "

TCQUERY cQuery NEW ALIAS (cAliasComp)

(cAliasComp)->(dbGoTop())

If (cAliasComp)->(!EOF())
	nDensidade  := (cAliasComp)->B5_DENSID
EndIf

(cAliasComp)->(dbCloseArea())

RESTAREA(aArea)

Return nDensidade


/*

Posiciona na OP, Estrutura e Empenho

*/
Static Function VerOP(cOP,cProd,cMP,cCompEst,nQtEstr,nQtEmp,nPerda,cCompUsa,cObserv,nQtPeca,cCodRef,nQtdRef,nPesoPC,nQtReq,cLinha)

Local aArea := GETAREA()
Local cRev  := ""
Local cTRT  := ""
Local lOk   := .T.
Local cAMFAMIL2C := RTRIM(GetMV("AM_FAMIL2C",.F.,"000011;"))
Local lPlanilha := .T. //.T.=Considera Perda Planilha, .F.=Considera Perda Estrutura Engenharia
Local nQtdReq := 0
Local nRecSD4 := 0

Default cCompEst := SPACE(TAMSX3("D4_COD")[1])
Default cCompUsa := SPACE(TAMSX3("D3_COD")[1])

dbSelectArea("SC2")
dbSetOrder(1)
If !dbSeek(xFilial("SC2")+cOP)
	cObserv += IIF(!EMPTY(cObserv),"|","")+"OP não encontrada!"
	//lOk  := .F.
Else
	If !EMPTY(SC2->C2_DATRF)
		cObserv += IIF(!EMPTY(cObserv),"|","")+"OP encerrada anteriormente!"
		//lOk  := .F.
	ElseIf !EMPTY(SC2->C2_QUJE)
		cObserv += IIF(!EMPTY(cObserv),"|","")+"OP com apontamento parcial!"
		//lOk  := .F.
	EndIf
EndIf

If lOk
	cRev  := SC2->C2_REVISAO
	cProd := SC2->C2_PRODUTO

	dbSelectArea("SB1")
	dbSetOrder(1)

	dbSelectArea("SD4")
	dbSetOrder(2) //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	dbSeek(xFilial("SD4")+cOP)

	While !EOF() .And. D4_FILIAL+D4_OP == xFilial("SD4")+cOP

		SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))

		If /*UPPER(RTRIM(X3Combo("B1_XMAT",SB1->B1_XMAT)))*/UPPER(TRIM(SB1->B1_XMAT2)) == UPPER(RTRIM(cMP)) .And.;
			SB1->B1_XFAMIL2 $ cAMFAMIL2C
			cCompEst := SD4->D4_COD
			cTRT     := SD4->D4_TRT
			nQtEmp   := SD4->D4_QUANT
			nRecSD4  := SD4->(RECNO())
			Exit
		EndIf

		dbSelectArea("SD4")
		dbSkip()
	EndDo

	If EMPTY(cCompEst)
		cObserv += IIF(!EMPTY(cObserv),"|","")+"Componente Empenho/Estrutura não encontrado! ("+cMP+")"
	EndIf

	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+cCompEst+cTRT)

	nQtEstr := SG1->G1_QUANT
	nPerda  := SG1->G1_PERDA

	nQtPecaAux := nQtPeca
	
	While nQtPecaAux > 0

		nQtApon := nQtPecaAux
		cCompUsa := SPACE(TAMSX3("D3_COD")[1])

		nPosPc  := 0
		nPosMP  := ASCAN(aRefs,{|x| (nPosPc:=ASCAN(x[5],{|w| w[1]==ALLTRIM(cProd) .And. (w[2]-w[3])>0 })) > 0})
		If nPosMP > 0
			cCompUsa := aRefs[nPosMP,2]
			If lPlanilha
				nPerda := aRefs[nPosMP,6] //Percentual de Sucata da Chapa
			EndIf

			If (aRefs[nPosMP,5][nPosPc][2]-aRefs[nPosMP,5][nPosPc][3]) >= nQtApon
				aRefs[nPosMP,5][nPosPc][3] += nQtApon //Marca que já foi empenhado a quantidade para esta PC/OP
			Else
				nQtApon := (aRefs[nPosMP,5][nPosPc][2]-aRefs[nPosMP,5][nPosPc][3])
				aRefs[nPosMP,5][nPosPc][3] += nQtApon
			EndIf

			aRefs[nPosMP,5][nPosPc][4] := nPesoPC //Peso da Peça

			If EMPTY(cCompUsa)
				cObserv += IIF(!EMPTY(cObserv),"|","")+"Componente Usado não encontrado! ("+aRefs[nPosMP,9]+")"
			EndIf
			cCodRef := aRefs[nPosMP,1]
			nQtdRef := (nQtReq*nPerda)/100
		Else
			cObserv += IIF(!EMPTY(cObserv),"|","")+"Prod.Sem saldo ou não encontrado no Subnests do Pedido! ("+ALLTRIM(cProd)+")"
		    cCodRef := ""
			nQtdRef := 0
		EndIf

		nQtdReq := nQtReq
		If !lApontaRef //Se não aponta Refugo, considera o custo para o produto final, requisitando mais material
			nQtdReq += nQtdRef
			nQtdReq := ROUND(nQtdReq,TAMSX3("D3_QUANT")[2])
		EndIf

        //          1	 2       3       4           5            6       7       8       9       10       11      12      13      14      15    16      17        18
		AADD(aOPs,{cOP,cProdPI,cMP,cCodMPEst,nQtApon/*nQtPeca*/,nPerda,nQtEmp,nQtNest,nQtdReq,cCodMPUsa,cObserv,cCodRef,nQtdRef,nRecSD4,nPosMP,nPesoPC,cLinha,SC2->C2_DATRF})
	
		nQtPecaAux -= nQtApon
	EndDo

EndIf

RESTAREA(aArea)

Return Nil

//////////////////////////////////////////////////////
// Tela ajuste dos empenhos na importação METALIX   //
//////////////////////////////////////////////////////
Static Function TelaAjuste(aOPs,aRefs,cFileName)

	Local aArea := GetArea()
	Local aAlter:= {} //{"COMPONENTE","QTDREF"}
	Local aAlterREF:= {}
	Local lOk := .F.
	Local nX
	Local lDiverg := .F.
	Local nRecSD4 := 0
	Local cMsgErro := ""
	Local dDatRF := "" //Data apontamento anterior da OP, caso exista, para não permitir apontamento de OP já encerrada

    //Objetos da Janela
    Private oDlgMet
    Private oMsGetAPO
    Private aHeadAPO := {}
    Private aColsAPO := {}
    Private oMsGetREF
    Private aHeadREF := {}
    Private aColsREF := {}
    Private oBtnSalv
    Private oBtnFech
    Private oBtnLege
    //Tamanho da Janela
    Private    nJanLarg    := 1600
    Private    nJanAltu    := 700
    //Fontes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)

	For nX := 1 To LEN(aOPs)

		Aadd(aColsAPO, {IIF(!EMPTY(aOPs[nX, 11]),"BR_PRETO","BR_VERDE") /*BR_VERMELO,BR_VERDE*/,;
						aOPs[nX, 17],;
						aOPs[nX, 1],;
						aOPs[nX, 2],;
						aOPs[nX, 5],;
						aOPs[nX, 3],;
						aOPs[nX, 4],;
						aOPs[nX, 10],;
						aOPs[nX, 5],;
						aOPs[nX, 6],;
						aOPs[nX, 7],;
						aOPs[nX, 8],;
						aOPs[nX, 9],;
						aOPs[nX, 11],;
						.F.;
						})

		If aOPs[nX,6] > 0

			cCodREF := POSICIONE("SB1",1,xFilial("SB1")+aOPs[nX, 4],"B1_XCODREF")
			If EMPTY(cCodREF)
				cCodREF := "SEM CODIGO"
			EndIf

		EndIf

		If !EMPTY(aOPs[nX, 11])
			lDiverg := .T.
		EndIf
	Next

	For nX := 1 To LEN(aRefs)

		Aadd(aColsREF, {;
						aRefs[nX, 2],;
						aRefs[nX, 1],;
						aRefs[nX, 3],;
						.F.;
						})

	Next

	If LEN(aColsREF) = 0
	   AADD(aColsREF,{"","",0,.T.})
	EndIf
     
    //Criando o cabeçalho da Grid do apontamento
    //              Título               Campo        Máscara                        Tamanho                   Decimal                   Valid      Usado  Tipo F3     Combo
    aAdd(aHeadAPO, {"",                  "XX_COR"    , "@BMP",                        002,                       0,                        ".F.",     "   ", "C", "",    "V",     "",      "",        "", "V"})
    //aAdd(aHeadAPO, {"Filial",            "D4_FILIAL" , "",                            TamSX3("D4_FILIAL")[01],   0,                        "",        ".T.", "C", "",    ""} )    
    aAdd(aHeadAPO, {"Linha",             "LINHA"     , "",                            3,   0,                        "",        ".T.", "C", "",    ""} )    
    aAdd(aHeadAPO, {"O.P",               "D4_OP"     , "",                            TamSX3("D4_OP")[01],       0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadAPO, {"PI Corte",          "XPICORTE"  , "",                            TamSX3("C2_PRODUTO")[01],  0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadAPO, {"Qtd.Pecas",         "C2_QUANT"  , PesqPict("SC2","C2_QUANT"),    TamSX3("C2_QUANT")[01],    0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadAPO, {"Material",          "XMATERIAL" , "",                            TamSX3("C2_PRODUTO")[01],  0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadAPO, {"Componente Estr.",  "COMPESTRU", "",                             TamSX3("D4_COD")[01],      0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadAPO, {"Componente Usado",  "COMPONENTE" , "",                           TamSX3("D4_COD")[01],      0,                        "",        ".T.", "C", "SB1MET", ""} )
    //aAdd(aHeadAPO, {"Descrição",         "B1_DESC"   , "",                            TamSX3("B1_DESC")[01],     0,                        "",        ".T.", "C", "",    ""} )
    //aAdd(aHeadAPO, {"U.M.",              "B1_UM"     , "",                            TamSX3("B1_UM")[01],       0,                        "",        ".T.", "C", "",    ""} )
    aAdd(aHeadAPO, {"Qtd.Estrut.",       "G1_QUANT"  , PesqPict("SG1","G1_QUANT"),    TamSX3("G1_QUANT")[01],    0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadAPO, {"% Perda",           "G1_PERDA"  , PesqPict("SG1","G1_PERDA"),    TamSX3("G1_PERDA")[01],    0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadAPO, {"Qtd.Emp.",          "D4_QTDEORI", PesqPict("SD4","D4_QTDEORI"),  TamSX3("D4_QTDEORI")[01],    0,                        "",        ".T.", "N", "",   ""} )
    aAdd(aHeadAPO, {"Peso PC",           "D4_QUANT"  , PesqPict("SD4","D4_QUANT"),    TamSX3("D4_QUANT")[01],    0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadAPO, {"Qtd.Req.",          "QTDREF"    , PesqPict("SD3","D3_QUANT"),    TamSX3("D3_QUANT")[01],    0,                        "",        ".T.", "N", "",    ""} )
    aAdd(aHeadAPO, {"Observação",        "OBSERV"    , "@X",                            80,    0,                        "",        ".T.", "C", "",    ""} )

	If lApontaRef
		//Criando o cabeçalho da Grid do refugo
		//              Título               Campo        Máscara                        Tamanho                   Decimal                   Valid      Usado  Tipo F3     Combo
		aAdd(aHeadREF, {"Componente",        "D4_COD"    , "",                            TamSX3("D4_COD")[01],      0,                        "",        ".T.", "C", "",    ""} )
		aAdd(aHeadREF, {"Refugo",            "D3_COD"    , "",                            TamSX3("D3_COD")[01],      0,                        "",        ".T.", "C", "",    ""} )
		aAdd(aHeadREF, {"Qtd.Perda",         "D3_QUANT"  , PesqPict("SD3","D3_QUANT"),    TamSX3("D3_QUANT")[01],    0,                        "",        ".T.", "N", "",    ""} )
	EndIf

	//Criação da tela com os dados que serem ajustados
	DEFINE MSDIALOG oDlgMet TITLE "Apontamento de produção - Metalix" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
			
			//Labels gerais
			//@ 004, 033 SAY "Apontamento de Produção - Metalix"  SIZE 250, 030 FONT oFontSubN  OF oDlgMet /*COLORS RGB(031,073,125)*/ PIXEL
			@ 004, 033 /*263*/ SAY "Lote: "+cLote  SIZE 250, 030 FONT oFontBtn /*oFontSubN*/  OF oDlgMet /*COLORS RGB(031,073,125)*/ PIXEL

			@ 006, 415 BUTTON oBtnFech   PROMPT "Anterior"   SIZE 065, 018 OF oDlgMet ACTION PesqErro("<",oMsGetAPO) FONT oFontBtn PIXEL
			@ 006, 505 BUTTON oBtnFech   PROMPT "Proximo"    SIZE 065, 018 OF oDlgMet ACTION PesqErro(">",oMsGetAPO) FONT oFontBtn PIXEL
			@ 006, 595 BUTTON oBtnFech   PROMPT "Excel"      SIZE 065, 018 OF oDlgMet ACTION U_M04M12X(3,aColsAPO,cLote) FONT oFontBtn PIXEL

			//Botões
			//If !lDiverg
				@ 006, 665 BUTTON oBtnFech                          PROMPT "Salvar"        SIZE 065, 018 OF oDlgMet ACTION (lOk:=.T.,oDlgMet:End())  FONT oFontBtn PIXEL 
			//EndIf
			@ 006, (nJanLarg/2-001)-(0067*01) BUTTON oBtnFech   PROMPT "Fechar"        SIZE 065, 018 OF oDlgMet ACTION (oDlgMet:End())           FONT oFontBtn PIXEL
				

			If lApontaRef
				aPosicao1 := {029,003,(nJanAltu/2)-3-120,(nJanLarg/2)-3}

				aPosicao2 := {(nJanAltu/2)-120,003,(nJanAltu/2)-3,(nJanLarg/2)-3}
			Else
				aPosicao1 := {029,003,(nJanAltu/2)-3,(nJanLarg/2)-3}
			EndIf

			//Grid das OP's/PI's
			oMsGetAPO := MsNewGetDados():New(   aPosicao1[1],;          //nTop      - Linha Inicial
												aPosicao1[2],;          //nLeft     - Coluna Inicial
												aPosicao1[3],;          //nBottom   - Linha Final
												aPosicao1[4],;          //nRight    - Coluna Final
												GD_UPDATE /*+ GD_DELETE*/,; //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
												"AllwaysTrue()",;       //cLinhaOk  - Validação da linha
												,;                      //cTudoOk   - Validação de todas as linhas
												"",;                    //cIniCpos  - Função para inicialização de campos
												aAlter,;                //aAlter    - Colunas que podem ser alteradas
												0,;                     //nFreeze   - Número da coluna que será congelada
												LEN(aColsAPO),;         //nMax      - Máximo de Linhas
												"U_M04M12V",;           //cFieldOK  - Validação da coluna
												,;                      //cSuperDel - Validação ao apertar '+'
												,;                      //cDelOk    - Validação na exclusão da linha
												oDlgMet,;               //oWnd      - Janela que é a dona da grid
												aHeadAPO,;              //aHeader   - Cabeçalho da Grid
												aColsAPO)               //aCols     - Dados da Grid
			
			If lApontaRef

				//Grid das Perdas/Refugo
				oMsGetREF := MsNewGetDados():New(   aPosicao2[1],;                   //nTop      - Linha Inicial
													aPosicao2[2],;                   //nLeft     - Coluna Inicial
													aPosicao2[3],;    //nBottom   - Linha Final
													aPosicao2[4],;        //nRight    - Coluna Final
													GD_UPDATE /*+ GD_DELETE*/,; //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
													"AllwaysTrue()",;       //cLinhaOk  - Validação da linha
													,;                      //cTudoOk   - Validação de todas as linhas
													"",;                    //cIniCpos  - Função para inicialização de campos
													aAlterREF,;            //aAlter    - Colunas que podem ser alteradas
													0,;                     //nFreeze   - Número da coluna que será congelada
													LEN(aColsREF),;         //nMax      - Máximo de Linhas
													,;                      //cFieldOK  - Validação da coluna
													,;                      //cSuperDel - Validação ao apertar '+'
													,;                      //cDelOk    - Validação na exclusão da linha
													oDlgMet,;               //oWnd      - Janela que é a dona da grid
													aHeadREF,;              //aHeader   - Cabeçalho da Grid
													aColsREF)               //aCols     - Dados da Grid
			EndIf

	ACTIVATE MSDIALOG oDlgMet CENTERED

	//Grava os empenhos / apontamentos e perdas
	If lOk

		lRet     := .F.
		lTemErro := .F.
		cDrive   := ""
		cPath    := ""
		cName    := ""
		cExt     := ""

		SplitPath(cFileName,@cDrive,@cPath,@cName,@cExt)

		For nX := 1 To Len(aOPs)

			cNumOp    := aOPs[nX,1]
			nQuant    := aOPs[nX,5]
			cCodMP    := aOPs[nX,10]
			cCodEstru := aOPs[nX,4]
			nQtdEstr  := aOPs[nX,7]
			nQtdMP    := aOPs[nX,9]
			cxMat     := RetXMAT(aOPs[nX, 3])
			nRecSD4   := aOPs[nX,14]
			cMsgErro  := aOPs[nX,11]
			dDatRF    := aOPs[nX,18]
			aRet      := {.F.,"",""}

			MsgRun("Processando.....", "Apontamento produção Metalix",{|| aRet :=  Aponta(cLote,cNumOP,nQuant,cCodMP,cCodEstru,nQtdMp,nQtdEstr,cxMat,cCodRef,nQtdRef,lApontaRef,nRecSD4,cMsgErro,dDatRF) })

			If !aRet[1] .And. aRet[3] <> "I" //Tem Erro, não considera como erro os registros IGNORADOS
				lTemErro := .T.
			EndIf
		Next

		If lTemErro 

			FwMakeDir(cDrive+cPath+"processado_erro\")

			FRENAME(cFileName,cDrive+cPath+"processado_erro\"+cName+cExt)

		Else
		
			FwMakeDir(cDrive+cPath+"processado_ok\")

			FRENAME(cFileName,cDrive+cPath+"processado_ok\"+cName+cExt)

		EndIf

		VerLog(cLote)

	EndIf

	RestArea(aArea)

Return Nil
 
Static Function PesqErro(cOper,oMsBrowse)

Local nCont := 0

If cOper == "<"

	If oMsBrowse:nAt > 0
		For nCont := oMsBrowse:nAt-1 To 1 Step -1

			If oMsBrowse:aCols[nCont][1] == "BR_PRETO"
				oMsBrowse:nAt := nCont
				Exit
			EndIf

		Next nCont
	EndIf

Else

	If oMsBrowse:nAt < LEN(oMsBrowse:aCols)
		For nCont := oMsBrowse:nAt+1 To LEN(oMsBrowse:aCols) Step 1

			If oMsBrowse:aCols[nCont][1] == "BR_PRETO"
				oMsBrowse:nAt := nCont
				Exit
			EndIf

		Next nCont
	EndIf

EndIf

//oMsBrowse:SetBlkBackColor({|oMsBrowse| IIf(oMsBrowse:nAt, CLR_HMAGENTA , Nil )})
oMsBrowse:Refresh(.T.)
//oMsBrowse:SetFocus()

Return 

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ M04M12X   ³ Autor ³ Montes               ³ Data ³ 16.12.24 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Rotina para exportacao de dados para Excel                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nenhum                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 : Alias                                              ³±±
	±±³          ³ ExpA2 : Array com as Descricoes do Cabecalho               ³±±
	±±³          ³ ExpA3 : Array com os parametros (perguntes) da rotina      ³±±
	±±³          ³ ExpN4 : Opcao executada                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ M04M12                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M04M12X(nTela,aCols,cLote)

	Local aCabXcel      := {}
	Local aItenXcel     := {}
	Local aArea			:= GetArea()
	Local nX			:= 0
	Local nY            := 0
	Local cTexto		:= ""
	Local cDescPA       := ""
	Local cLib

	Default nTela := 1 

	If nTela == 1

		If Len(aOrdProd) > 0

			If GetRemoteType(@cLib) == 5

				MsgInfo("Rotina não pode ser executada em Smartclient Web.","Atenção")

				Return

			Else

				AADD(aCabXcel,{"  ","C",2,0})
				AADD(aCabXcel,{"Status","C",11,0})
				AADD(aCabXcel,{"Lib.Sep.","C",11,0})
				AADD(aCabXcel,{"OP","C",TAMSX3("C2_NUM")[1]+TAMSX3("C2_ITEM")[1]+TAMSX3("C2_SEQUEN")[1]+TAMSX3("C2_ITEMGRD")[1],TAMSX3("C2_NUM")[2]})
				AADD(aCabXcel,{"FASE","C",TAMSX3("CJ_XSITUAC")[1],TAMSX3("CJ_XSITUAC")[2]})
				AADD(aCabXcel,{"Descrição PA","C",TAMSX3("B1_DESC")[1],TAMSX3("B1_DESC")[2]})
				AADD(aCabXcel,{"Produto","C",TAMSX3("C2_PRODUTO")[1],TAMSX3("C2_PRODUTO")[2]})
				AADD(aCabXcel,{"Descricao","C",TAMSX3("B1_DESC")[1],TAMSX3("B1_DESC")[2]})
				AADD(aCabXcel,{"Emissao","C",TAMSX3("C2_EMISSAO")[1],TAMSX3("C2_EMISSAO")[2]})
				AADD(aCabXcel,{"Prv.Inicio","D",TAMSX3("C2_DATPRI")[1],TAMSX3("C2_DATPRI")[2]})
				AADD(aCabXcel,{"Prv.Entrega","D",TAMSX3("C2_DATPRF")[1],TAMSX3("C2_DATPRF")[2]})
				AADD(aCabXcel,{"Quantidade","N",TAMSX3("C2_QUANT")[1],TAMSX3("C2_QUANT")[2]})
				AADD(aCabXcel,{"Qt.Entregue","N",TAMSX3("C2_QUJE")[1],TAMSX3("C2_QUJE")[2]})
				AADD(aCabXcel,{"Encerramento","D",TAMSX3("C2_DATRF")[1],TAMSX3("C2_DATRF")[2]})
				//AADD(aCabXcel,{"Cliente","C",TAMSX3("A1_NOME")[1],TAMSX3("A1_NOME")[2]})
				//AADD(aCabXcel,{"Vendedor","C",TAMSX3("A3_NOME")[1],TAMSX3("A3_NOME")[2]})

				AADD(aItenXcel,{" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" "})

				//	" ",;
				//	" ",;
				//	" ",;
				//	" ",;

				For nX := 1 to Len(aOrdProd)

					cDescPA := aPRODPA( (aOrdProd[nX][2]+aOrdProd[nX][3]+aOrdProd[nX][4]+aOrdProd[nX][5]), aOrdProd[nX][7] )

					AADD(aItenXcel,{IIF(aOrdProd[nX][1],'OK','NO'),;
						STRTRAN(IIF(aOrdProd[nX][11]=0,;
						IIF(aOrdProd[nX][21]>0  ,'BR_AMARELO',;
						IIF(aOrdProd[nX][20]="S",'BR_AZUL',;
						IIF(aOrdProd[nX][20]="P",'BR_VIOLETA','BR_VERDE'))),;
						(IIF(aOrdProd[nX][11]>0.And.EMPTY(aOrdProd[nX][12]), 'BR_AZUL',;
						(IIF(!EMPTY(aOrdProd[nX][12]),'BR_VERMELHO',""))))),"BR_",""),;
						STRTRAN(IIF(aOrdProd[nX][16]=' ',IIF(aOrdProd[nX][19],'BR_VERDE','BR_VERMELHO'),'BR_AMARELO'),"BR_",""),;
						aOrdProd[nX][2]+aOrdProd[nX][3]+aOrdProd[nX][4]+aOrdProd[nX][5],;
						aOrdProd[nX][23],;
						cDescPA,;
						aOrdProd[nX][6],;
						aOrdProd[nX][7],;
						aOrdProd[nX][8],;
						aOrdProd[nX][24],;
						aOrdProd[nX][9],;
						aOrdProd[nX][10],;
						aOrdProd[nX][11],;
						aOrdProd[nX][12],;
						""})

						//aOrdProd[nX][16],;
						//aOrdProd[nX][17],;
						//aOrdProd[nX][25],;
						//aOrdProd[nX][26],;

				Next nX

				cTexto := OemToAnsi("Central de Producao ")

				MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS",cTexto,aCabXcel,aItenXcel}})})

			EndIf

		EndIf
	
	ElseIf nTela == 2 // LOG Importação Metalix

		If Len(aCols) > 0

			If GetRemoteType(@cLib) == 5

				MsgInfo("Rotina não pode ser executada em Smartclient Web.","Atenção")

				Return

			Else

				AADD(aCabXcel,{"  ","C",2,0})
				AADD(aCabXcel,{"OP","C",TAMSX3("ZAJ_OP")[1],TAMSX3("ZAJ_OP")[2]})
				AADD(aCabXcel,{"Seq.Apto.","C",TAMSX3("ZAJ_SEQAPO")[1],TAMSX3("ZAJ_SEQAPO")[2]})
				AADD(aCabXcel,{"Produto","C",TAMSX3("ZAJ_PROD")[1],TAMSX3("ZAJ_PROD")[2]})
				AADD(aCabXcel,{"Qtd.Peças","N",TAMSX3("ZAJ_QTDPRO")[1],TAMSX3("ZAJ_QTDPRO")[2]})
				AADD(aCabXcel,{"Material","C",TAMSX3("ZAJ_XMAT")[1],TAMSX3("ZAJ_XMAT")[2]})
				AADD(aCabXcel,{"Componente","C",TAMSX3("ZAJ_COMP")[1],TAMSX3("ZAJ_COMP")[2]})
				AADD(aCabXcel,{"Qtd.Req.","N",TAMSX3("ZAJ_QTDREQ")[1],TAMSX3("ZAJ_QTDREQ")[2]})
				AADD(aCabXcel,{"Cod.Refugo","C",TAMSX3("ZAJ_CODREF")[1],TAMSX3("ZAJ_CODREF")[2]})
				AADD(aCabXcel,{"Qtd.Ref.","C",TAMSX3("ZAJ_QTDREF")[1],TAMSX3("ZAJ_QTDREF")[2]})
				AADD(aCabXcel,{"Status","C",TAMSX3("ZAJ_STATUS")[1],TAMSX3("ZAJ_STATUS")[2]})
				AADD(aCabXcel,{"Msg.Erro","C",500,0})

				AADD(aItenXcel,{" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" ",;
					" "})

				For nX := 1 to Len(aCols)

					AADD(aItenXcel,{IIF(aCols[nX][1]=="BR_VERDE",'OK','NO'),;
						aCols[nX][2],;
						aCols[nX][3],;
						aCols[nX][4],;
						aCols[nX][5],;
						aCols[nX][6],;
						aCols[nX][7],;
						aCols[nX][8],;
						aCols[nX][9],;
						aCols[nX][10],;
						aCols[nX][11],;
						aCols[nX][12],;
						""})

				Next nX

				cTexto := OemToAnsi("LOG Importação Metalix - Lote "+cLote)

				MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS",cTexto,aCabXcel,aItenXcel}})})

			EndIf

		EndIf


	ElseIf nTela == 3 // Tela de Importação Metalix

		If Len(aColsAPO) > 0

			If GetRemoteType(@cLib) == 5

				MsgInfo("Rotina não pode ser executada em Smartclient Web.","Atenção")

				Return

			Else
	
				For nY := 1 To Len(aHeadAPO)

					AADD(aCabXcel,{aHeadAPO[ny][1],aHeadAPO[ny][8],aHeadAPO[ny][4],aHeadAPO[ny][5]})

				Next


				AADD(aItenXcel,{})
				For nY := 1 To Len(aHeadAPO)

					AADD(aItenXcel[LEN(aItenXcel)],"")

				Next
				AADD(aItenXcel[LEN(aItenXcel)],"")
	

				For nX := 1 to Len(aColsAPO)

					AADD(aItenXcel,{})
					For nY := 1 To Len(aHeadAPO)
	
						AADD(aItenXcel[LEN(aItenXcel)],aColsAPO[nX][nY])

					Next
					AADD(aItenXcel[LEN(aItenXcel)],"")
	
				Next nX

				cTexto := OemToAnsi("Importação Metalix - Lote "+cLote)

				MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS",cTexto,aCabXcel,aItenXcel}})})

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12R
Impressão de OP
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12R()

	Local aArea     := GETAREA()
	Local nX        := 0
	Local lContinua := .F.
	Local aPergs    := {}

	Private cFiltroOP := DTOC(DATE())+" "+TIME()+" "+cUserName //UsrRetName() 99/99/9999 99:99:99 xxxxxxxxxxxxxxxxxxxx
	Private aRetPar := {}

	dbSelectArea("SB1")
	dbSetOrder(1)

	Aadd(aPergs, {2, "Impr. por Ordem de?"    ,"1",{"1=Produto","2=Endereço"},80,".T.",.F.})  //2

	If ParamBox(aPergs, "Impressão da OP", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)

		CursorWait()

		ProcRegua(Len(aOrdProd))

		For nX := 1 To Len(aOrdProd)

			If aOrdProd[nX][1]

				dbSelectArea("SC2")
				dbGoTo(aOrdProd[nX][13])

				IncProc("Imprimindo OP " + aOrdProd[nX][2]+aOrdProd[nX][3]+aOrdProd[nX][4])

				If SC2->(!EOF())

					SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

					lContinua := .T.

					//RecLock("SC2",.F.)
					//SC2->C2_XIMPOPE := cFiltroOP
					//MsUnLock()

					aOrdProd[nX][17] := SC2->C2_XIMPOPE

				EndIf

			EndIf
		Next

		nOrdSep := VAL(aRetPar[1])

		If lContinua
			U_MATR820() //SUBSTITUIÇÃO DA ROTINA PARA FWMSPRINTER
		EndIf

		CursorArrow()

		oDlgMon:End()

	EndIf

	RESTAREA(aArea)

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M12B
Legenda dos Browses
@author    Montes MooveGestão
@version   12.1
@since     13.12.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M12B()

	Local aCores1  := {}
	Local aCores2  := {}
	Local aCores3  := {}
	Local nY       := 0
	Local nX       := 0
	Local aBmp     := {}
	Local aBmp2    := {}
	Local aBmp3    := {}
	Local aSays    := {}
	Local aSays2   := {}
	Local aSays3   := {}
	Local oDlgLeg
	Local nXSize 	:= 14

// Cores do Status da OP
	Aadd(aCores1,{"BR_VERDE"     , "OP em aberto"             })
	Aadd(aCores1,{"BR_AZUL"      , "OP Separada total"        })
	Aadd(aCores1,{"BR_VIOLETA"   , "OP Seperada parcialmente" })
	Aadd(aCores1,{"BR_AMARELO"   , "OP Inicia"                })
	Aadd(aCores1,{"BR_VERMELHO"  , "OP Encerrada"             })

// Cores de Liberação/Separação da OP
	Aadd(aCores2,{"BR_VERMELHO"   , "OP não liberada para separação"         })
	Aadd(aCores2,{"BR_AMARELO"    , "OP Liberada para Separação"             })
	Aadd(aCores2,{"BR_VERDE"      , "OP com saldo em estoque para Separação" })

// Cores do Saldo do Empenho da OP
	Aadd(aCores3,{"BR_VERDE"      , "Empenho com estoque suficiente" })
	Aadd(aCores3,{"BR_AMARELO"    , "Empenho com estoque parcial"    })
	Aadd(aCores3,{"BR_VERMELHO"   , "Empenho sem saldo em estoque"   })

	aBmp  := ARRAY(Len(aCores1))
	aBmp2 := ARRAY(Len(aCores2))
	aBmp3 := ARRAY(Len(aCores3))
	aSays := ARRAY(Len(aCores1))
	aSays2:= ARRAY(Len(aCores2))
	aSays3:= ARRAY(Len(aCores3))

	DEFINE MSDIALOG oDlgLeg FROM 0,0 TO ((Len(aCores1)+Len(aCores2)+Len(aCores3))*25)+100,334 TITLE "Legenda do Monitor de Produção"  PIXEL

	oDlgLeg:bLClicked:= {||oDlgLeg:End()}

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

	@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgLeg SIZE 55,155 NOBORDER WHEN .F. PIXEL

	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgLeg PIXEL
	@ 3  ,37  SAY "Status da OP" Of oDlgLeg PIXEL SIZE 100,9 FONT oBold

	For nX := 1 to Len(aCores1)
		@ 19+((nX-1)*10),44 BITMAP aBmp[nX] RESNAME aCores1[nX][1] of oDlgLeg SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ 19+((nX-1)*10),(nXSize/2) + 47 SAY If((nY+=1) == nY,aCores1[nY][2]+If(nY==Len(aCores1),If((nY:=0)==nY,"",""),""),"") of oDlgLeg PIXEL
	Next nX
	nY := 0

	@ 81 ,35  TO 83 ,400 LABEL '' OF oDlgLeg PIXEL
	@ 73  ,37  SAY "Liberação/Separação da OP" Of oDlgLeg PIXEL SIZE 100,9 FONT oBold

	For nX := 1 to Len(aCores2)
		@ 89+((nx-1)*10),44 BITMAP aBmp2[nx] RESNAME aCores2[nx][1] of oDlgLeg SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ 89+((nx-1)*10),(nXSize/2) + 47 SAY If((nY+=1) == nY,aCores2[nY][2]+If(nY==Len(aCores2),If((nY:=0)==nY,"",""),""),"") of oDlgLeg PIXEL
	Next nX
	nY := 0

	@ 141 ,35  TO 143 ,400 LABEL '' OF oDlgLeg PIXEL
	@ 133  ,37  SAY "Saldo em Estoque do Empenho da OP" Of oDlgLeg PIXEL SIZE 100,9 FONT oBold

	For nX := 1 to Len(aCores3)
		@ 149+((nx-1)*10),44 BITMAP aBmp3[nx] RESNAME aCores3[nx][1] of oDlgLeg SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ 149+((nx-1)*10),(nXSize/2) + 47 SAY If((nY+=1) == nY,aCores3[nY][2]+If(nY==Len(aCores3),If((nY:=0)==nY,"",""),""),"") of oDlgLeg PIXEL
	Next nX
	nY := 0

	ACTIVATE MSDIALOG oDlgLeg CENTERED

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³MenuDef   ³ Autor ³ Marcos Antonio Montes ³ Data ³01/11/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
	±±³          ³                                                            ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Parametros do array a Rotina:                               ³±±
	±±³          ³1. Nome a aparecer no cabecalho                             ³±±
	±±³          ³2. Nome da Rotina associada                                 ³±±
	±±³          ³3. Reservado                                                ³±±
	±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
	±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
	±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
	±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
	±±³          ³    4 - Altera o registro corrente                          ³±±
	±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
	±±³          ³5. Nivel de acesso                                          ³±±
	±±³          ³6. Habilita Menu Funcional                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

	PRIVATE aRotina	:= {}
	If IsInCallStack("MATA010")
		aRotina	:= { 	{ OemToAnsi("Pesquisar") ,"AxPesqui"		, 0 , 1, 0, .F.}}
		If MPUserHasAccess("MATA010", OP_VISUALIZAR )
			aAdd(aRotina, { OemtoAnsi("Visualizar") ,"A010Visul"	  		, 0 , 2, 0, nil} )
		EndIf
		If MPUserHasAccess("MATA010", OP_INCLUIR )
			aAdd(aRotina, { OemtoAnsi("Incluir") ,"A010Inclui"		, 0 , 3, 0, nil} )
		EndIf
		If MPUserHasAccess("MATA010", OP_ALTERAR )
			aAdd(aRotina, { OemtoAnsi("Alterar") ,"A010Altera"		, 0 , 4, 2, nil} )
		EndIf
		If MPUserHasAccess("MATA010", OP_EXCLUIR )
			aAdd(aRotina, { OemtoAnsi("Excluir") ,"Mata010Deleta"	, 0 , 5, 1, nil} )
		EndIf
		/*
		If MPUserHasAccess("MATA010", OP_COPIA )
			aAdd(aRotina, { OemtoAnsi("Copia") ,"A010Copia"		, 0 , 9, 0, nil} )
		EndIf
		*/
	EndIf
Return(aRotina)

////////////////////////////////////////
// Retorna Produto PA                 //
////////////////////////////////////////
Static Function aPRODPA(cNumOP,cDescSB1)

	Local aArea    := GETAREA()
	Local aAreaSC2 := SC2->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	Local cDescPA  := ""
	Local cOPORIG  := ""

	If SUBSTRING(cNumOP,9,3) > "001"
		cOPORIG := STUFF(cNumOP,9,3,"001")
	EndIf

	If !EMPTY(cOPORIG)
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial("SC2")+cOPORIG))
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)) .And. SB1->B1_TIPO == "PA" .And. cDescSB1 <> SB1->B1_DESC
				cDescPA := SB1->B1_DESC
			EndIf
		Else
			cDescPA := aPRODPA(cOPORIG,cDescSB1)
		EndIf
	EndIf

	SC2->(RestArea(aAreaSC2))
	SB1->(RestArea(aAreaSB1))
	RestArea(aArea)

Return cDescPA


//////////////////////////////////////////////////////
// Carrega Saldo dos itens liberados para separação //
//////////////////////////////////////////////////////
Static Function CarSldLib(cProdEmp)

Local aArea     := GETAREA()
Local cQuery    := ""
Local cAliasEmp := GETNEXTALIAS()
Local nSaldoLib := 0

cQuery := " SELECT SUM(D4_QUANT) SALDOLIB "
cQuery += " FROM " + RetSQLName('SD4') + " SD4 "
cQuery += " LEFT OUTER JOIN "+RetSQLName("SC2")+" SC2 ON SC2.C2_FILIAL = D4_FILIAL "
cQuery += " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD = SD4.D4_OP AND SC2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D4_FILIAL = '" + xFilial("SD4") + "' "
cQuery += " AND D4_COD = '"+cProdEmp+"' "
cQuery += " AND D4_QUANT > 0 "
//cQuery += " AND SC2.C2_XLIBSEP <> ' ' " //Considera somnete as OP's liberadas para Separação
cQuery += " AND SC2.C2_TPOP = 'F' " //Considerar somente OP's Firmes
cQuery += " AND SD4.D_E_L_E_T_ = ' ' "

TCQUERY cQuery NEW ALIAS (cAliasEmp)

nSaldoLib := (cAliasEmp)->SALDOLIB

(cAliasEmp)->(dbCloseArea())

RESTAREA(aArea)

Return nSaldoLib

//////////////////////////////////////////////////////
// Validação GETDADOS  - IMPORTAÇÃO METALIX         //
//////////////////////////////////////////////////////
User Function M04M12V()

Local cField := READVAR()

If cField == "M->COMPONENTE"

	cCodOld := aColsAPO[oMsGetAPO:nAt,5]
	cCodNew := M->COMPONENTE
	nQtRef  := aColsAPO[oMsGetAPO:nAt,10]

	nPosOld := ASCAN(aColsREF,{|x|x[1]==cCodOld})
	If nPosOld > 0
		aColsREF[nPosOld,3] -= nQtRef
	EndIf

	nPosNew := ASCAN(aColsREF,{|x|x[1]==cCodNew})
	If nPosNew > 0
		aColsREF[nPosNew,3] += nQtRef
	Else

		cCodREF := POSICIONE("SB1",1,xFilial("SB1")+cCodNew,"B1_XCODREF")
		If EMPTY(cCodREF)
			cCodREF := "SEM CODIGO"
		EndIf

		Aadd(aColsREF, {;
						cCodNew,;
						cCodREF,;
						nQtRef,;
						.F.;
						})

	EndIf

ElseIf cField == "M->QTDREF"

	cCodOld := aColsAPO[oMsGetAPO:nAt,5]
	nQtRef  := aColsAPO[oMsGetAPO:nAt,10]

	nPosOld := ASCAN(aColsREF,{|x|x[1]==cCodOld})
	If nPosOld > 0
		aColsREF[nPosOld,3] -= nQtRef
		aColsREF[nPosOld,3] += M->D3_QUANT
	EndIf

EndIf

Return .T.

/*

Função para gravação do apontamento via SigaAuto do Mata250

*/
Static Function Aponta(cLote,cNumOP,nQuant,cCodMP,cCodEstru,nQtdMp,nQtdEstr,cxMat,cCodRef,nQtdRef,lApontaRef,nRecSD4,cMsgErro,dDatRF)

Local nX

Private lMsErroAuto := .F.
Private lAutoErrNoFile := .T.
Private lMsHelpAuto := .T.
//Private cMsgErro    := ""
Private aMata250    := {}
Private lRet        := .T.		
Private aErro       := {}
Private cTM         := GETMV("ES_TMPROD",.F.,"002")
Private cLocProc    := GETMV("MV_LOCPROC",.F.,"99") //Armazem de Processo
Private l381        := .F.
Private L380        := .T.
Private aINFLT      := {}
Private aSDC        := {}
Private aSavMvPar   := { MV_PAR01 }

Default lApontaRef  := .F.
Default cMsgErro    := ""

If EMPTY(cMsgErro)
	dbSelectArea("SC2")
	dbSetOrder(1) //C2_FILIAL+C2_NUM
	dbSeek(xFilial("SC2")+cNumOP)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajuste os empenhos da Ordem de Producao                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCodMP <> cCodEstru .Or. nQtdMP <> nQtdEstr
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reinicializa as variáveis³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aEsta380	:= {}
		nQtdAnt	   	:= 0
		nQtdAnt2UM 	:= 0
		nQtdOriAnt 	:= 0
		cLoteAnt   	:= ""
		cLotCtlAnt 	:= ""
		cLocal	   	:= cLocProc
		dDataSD4    := dDataBase
		cTRT        := "" 
		cRoteiro    := ""
		cxAnsul     := ""
		mv_par01    := 2 //Não digita lote

		lNovoSD4    := .F.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no arquivo de saldos e cria se necessario          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB2")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB2")+cCodMP+cLocProc )
			CriaSB2(cCodMP,cLocProc)
			MsUnLock()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verificar se o armazém do empenho³
		//³foi alterado na rotina.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD4")
		SD4->( dbSetOrder(1) )//D4_FILIAL+D4_OP
		SD4->( dbGoTo(nRECSD4) )
		If SD4->(!EOF())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alteração: armazena as informações    ³
			//³anteriores dos campos para a gravação.³
			//³(a380grava())                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nQtdAnt	   := SD4->D4_QUANT
			nQtdAnt2UM := SD4->D4_QTSEGUM
			nQtdOriAnt := SD4->D4_QTDEORI
			cLoteAnt   := SD4->D4_NUMLOTE
			cLotCtlAnt := SD4->D4_LOTECTL
			cLocal	   := SD4->D4_LOCAL
			dDataSD4   := SD4->D4_DATA
			cTRT       := SD4->D4_TRT 
			cRoteiro   := SD4->D4_ROTEIRO
			cxAnsul    := SD4->D4_XANSUL

			RecLock("SD4",.F.)
		Else
			lNovoSD4 := .T.
			RecLock("SD4",.T.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava SD4		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD4->D4_FILIAL	:= 	xFilial("SD4")
		SD4->D4_OP		:=  cNumOP
		SD4->D4_COD     :=  cCodMP
		SD4->D4_PRODUTO :=  SC2->C2_PRODUTO
		SD4->D4_QTDEORI :=  nQtdMp //Quantidade Original do Empenho
		SD4->D4_QUANT   :=  ( ( nQtdMp / SC2->C2_QUANT ) * ( SC2->C2_QUANT - SC2->C2_QUJE) ) //Saldo do Empenho
		SD4->D4_QTSEGUM := ConvUM(SC2->C2_PRODUTO,SD4->D4_QUANT,0,2) // 2UM
		SD4->D4_LOCAL   :=  cLocal
		SD4->D4_DATA    :=  dDataSD4
		SD4->D4_TRT     :=	cTRT  
		SD4->D4_ROTEIRO :=  cRoteiro 
		SD4->D4_XANSUL  :=  cxAnsul

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga o D4_NUMLOTE caso o controle de Rastro seja "L". ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		a380NumLot()

		//If nOpcX==4
		A380Grava(nQtdAnt,cLoteAnt,cLotCtlAnt,cLocal,nQtdAnt2UM) //Atualiza os Empenhos
		//Endif

		MsUnlock()

		MV_PAR01 := aSavMvPar[1] //Restaura MV_PAR01

	EndIf

	aAdd(aMata250, {})
	aAdd(aMata250[1], {'D3_TM'     ,cTM                              ,Nil})
	aAdd(aMata250[1], {'D3_OP'     ,cNumOP                           ,Nil})
	aAdd(aMata250[1], {'D3_USUARIO',cUserName                        ,Nil})
	aAdd(aMata250[1], {'D3_QUANT'  ,nQuant                           ,Nil})
	//aAdd(aMata250[1], {'D3_PARCTOT','T'                              ,Nil})
	aAdd(aMata250[1], {'D3_PERDA'  ,0                                ,Nil})
	aAdd(aMata250[1], {'D3_OBSERVA','METALIX - LOTE:' + cLote        ,Nil})

	MSExecAuto({|x,y| mata250(x,y)},aMata250[1],3)
				
	If lMsErroAuto

		lRet := .F.

		aErro := GetAutoGRLog()
		If Len(aErro) > 0
			For nX := 1 To Len(aErro)
					cMsgErro += aErro[nX] + CRLF
			Next nX
			//cFileLog := NomeAutoLog()
			//MemoWrite( cFileLog, cMsgErro )
		EndIf
		If EMPTY(cMsgErro)
			cMsgErro := "Não foi possivel recuperar LOG de Erro!"
		EndIf

	Else

		If lApontaRef
			lRet := ApontaRef(cNumOp,cCodRef,cCodMp,nQtdRef)
			If !lRet
				cMsgErro := "Erro apontamento de perda!"
			EndIf
		EndIf

	EndIf

Else

	lRet := .F.

EndIf

dbSelectArea("ZAJ")
dbSetOrder(1)
cSeqApo := "01"
While dbSeek(xFilial("ZAJ")+PADR(cLote,TAMSX3("ZAJ_LOTE")[1])+PADR(cNumOp,TAMSX3("ZAJ_OP")[1])+cSeqApo)
	cSeqApo := Soma1(cSeqApo)
EndDo

Reclock("ZAJ",.T.)
ZAJ->ZAJ_FILIAL := xFilial("ZAJ")
ZAJ->ZAJ_LOTE   := cLote
ZAJ->ZAJ_OP     := cNumOp
ZAJ->ZAJ_SEQAPO := cSeqApo
ZAJ->ZAJ_PROD   := SC2->C2_PRODUTO
ZAJ->ZAJ_QTDPRO := nQuant
ZAJ->ZAJ_XMAT   := cxMat
ZAJ->ZAJ_COMP   := cCodMP
ZAJ->ZAJ_QTDREQ := nQtdMp
ZAJ->ZAJ_CODREF := cCodRef
ZAJ->ZAJ_QTDREF := nQtdRef
ZAJ->ZAJ_STATUS := IIF(!EMPTY(cMsgErro),IIF(EMPTY(dDatRF),"E","I"),"A") //A=APONTADO;E=ERRO,I=IGNORADO (se apontado anterior grava como "I")
ZAJ->ZAJ_MSGERR := cMsgErro
ZAJ->ZAJ_USRINC := cUserName
ZAJ->ZAJ_DATINC := dDataBase
ZAJ->ZAJ_HORINC := Time()
MsuNLock()

Return { lRet, cMsgErro, ZAJ->ZAJ_STATUS }

/*

   Apontameto de perda
	
*/
Static Function ApontaRef(cNumOP,cCodRef,cCodMP,nQtRef)

Local lRet := .F.
Local nX

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+cNumOP)

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cCodRef)

	cRecurso  := CriaVar('BC_RECURSO')
	cOperacao := CriaVar('BC_OPERAC')

	//INICIO:Verifica tratamento do Roteiro de Operação para evitar erro de validação quando habilitado o paramtro MV_QIPMAT
	If !Empty(SC2->C2_ROTEIRO)
		cRoteiro := SC2->C2_ROTEIRO
	Else
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		cRoteiro := If(Empty(SB1->B1_OPERPAD),"01",SB1->B1_OPERPAD)
	EndIf
	If !EMPTY(cRoteiro)
		dbSelectArea("SG2")
		dbSetORder(1)
		If dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro)
			cOperacao := SG2->G2_OPERAC
			cRecurso  := SG2->G2_RECURSO
		EndIf
		dbSelectArea("SBC")
	EndIf
	//FIM:

	aItens := {}
	aCab	  := {  {'BC_OP'     ,cNumOP,Nil},;
					{'BC_PRODUTO',SC2->C2_PRODUTO,Nil},;
					{'BC_RECURSO',cRecurso,Nil},;
					{'BC_OPERAC' ,cOperacao,Nil}}

    cTipo     := "R"  //R-Refugo ou S=Scrap
	cMotivo   := "RB" //FH-Falha Humana, FM-Falha Mecanica, FP-Falha Materia Prima ou RB-Rebarba
					
	Aadd(aItens,{   {'BC_PRODUTO' ,cCodMP      ,Nil},;
					{'BC_LOCORIG' ,cLocalProc  ,Nil},;
					{'BC_TIPO'    ,cTipo       ,Nil},;
					{'BC_MOTIVO'  ,cMotivo     ,Nil},;
					{'BC_QUANT'   ,nQtRef      ,Nil},;
					{'BC_CODDEST' ,cCodRef     ,Nil},;
					{'BC_LOCAL'   ,M->C2_LOCAL ,Nil},;
					{'BC_QTDDEST' ,nQtRef      ,Nil},;
					{'BC_DATA'    ,dDataBase   ,Nil},;
					{'BC_CC'      ,SD3->D3_CC  ,Nil}})

					//{'BC_LOTECTL' ,SD3->D3_LOTECTL,".T."},;
					//{'BC_NUMLOTE' ,SD3->D3_NUMLOTE,".T."},;
					//{'BC_DTVALID' ,SD3->D3_DTVALID,".T."},;
					//{'BC_LOCALIZ' ,SD3->D3_LOCALIZ,".T."},;
					//{'BC_NUMSERI' ,SD3->D3_NUMSERI,".T."},;
					//{'BC_LOCDEST' ,SD3->D3_LOCALIZ,".T."},;
					//{'BC_NSEDEST' ,SD3->D3_NUMSERI,".T."},;
					//{'BC_OPERADO' ,Nil            ,Nil},;

	// ATENÇÃO: Parâmetro mv_par01 do	MTA685 tem influência direta na geração da movimentação da perda.
	aSaveSX1 := {MV_PAR01,MV_PAR02,MV_PAR03}
	Pergunte("MTA685",.F.)
	mv_par01 := 2 //Requisita Produto de Origem ? 1-Sim, 2-Nao

	lMSErroAuto := .F.
	MSExecAuto({|x,y,z| Mata685(x,y,z)},aCab,aItens,3)
						
	If lMSErroAuto
		//MostraErro()

		aErro := GetAutoGRLog()
		If Len(aErro) > 0
			For nX := 1 To Len(aErro)
					cMsgErro += aErro[nX] + CRLF
			Next nX
			//cFileLog := NomeAutoLog()
			//MemoWrite( cFileLog, cMsgErro )
		EndIf

		DisarmTransaction()
		lRet := !lMSErroAuto


	EndIf
	MV_PAR01 := aSaveSX1[1]
	MV_PAR02 := aSaveSX1[2]
	MV_PAR03 := aSaveSX1[3]
EndIf

Return lRet


Static Function VerLog(cLote)

Local oDlgLog
Local oLinhas
Local oBtnExp
Local oBtnExi
Local cMsgError := ""

Private aHeader  := {}
Private aCols    := {}
 
dbSelectArea("ZAJ")
dbSetOrder(1)
If dbSeek(xFilial("ZAJ")+cLote)

	aHeader:={}
	Aadd(aHeader,{ ""          ,       "Legenda"   , "@BMP"                      ,01                     , 00                     ,".F.","???????????????", "C"                    ,"ZAJ"})
	Aadd(aHeader,{ "OP"        ,       "ZAJ_OP"    , PesqPict("ZAJ","ZAJ_OP")    ,TAMSX3("ZAJ_OP")[1]    , TAMSX3("ZAJ_OP")[2]    ,".F.","???????????????", TAMSX3("ZAJ_OP")[3]    ,"ZAJ"})
	Aadd(aHeader,{ "Seq.Apto." ,       "ZAJ_SEQAPO", PesqPict("ZAJ","ZAJ_SEQAPO"),TAMSX3("ZAJ_SEQAPO")[1], TAMSX3("ZAJ_SEQAPO")[2],".F.","???????????????", TAMSX3("ZAJ_SEQAPO")[3],"ZAJ"})
	Aadd(aHeader,{ "Produto"   ,       "ZAJ_PROD"  , PesqPict("ZAJ","ZAJ_PROD")  ,TAMSX3("ZAJ_PROD")[1]  , TAMSX3("ZAJ_PROD")[2]  ,".F.","???????????????", TAMSX3("ZAJ_PROD")[3]  ,"ZAJ"})
	Aadd(aHeader,{ "Qtd.Peças" ,       "ZAJ_QTDPRO", PesqPict("ZAJ","ZAJ_QTDPRO"),TAMSX3("ZAJ_QTDPRO")[1], TAMSX3("ZAJ_QTDPRO")[2],".F.","???????????????", TAMSX3("ZAJ_QTDPRO")[3],"ZAJ"})
	Aadd(aHeader,{ "Material"  ,       "ZAJ_XMAT"  , PesqPict("ZAJ","ZAJ_XMAT")  ,TAMSX3("ZAJ_XMAT")[1]  , TAMSX3("ZAJ_XMAT")[2]  ,".F.","???????????????", TAMSX3("ZAJ_XMAT")[3]  ,"ZAJ"})
	Aadd(aHeader,{ "Componente",       "ZAJ_COMP"  , PesqPict("ZAJ","ZAJ_COMP")  ,TAMSX3("ZAJ_COMP")[1]  , TAMSX3("ZAJ_COMP")[2]  ,".F.","???????????????", TAMSX3("ZAJ_COMP")[3]  ,"ZAJ"})
	Aadd(aHeader,{ "Qtd.Req."  ,       "ZAJ_QTDREQ", PesqPict("ZAJ","ZAJ_QTDREQ"),TAMSX3("ZAJ_QTDREQ")[1], TAMSX3("ZAJ_QTDREQ")[2],".F.","???????????????", TAMSX3("ZAJ_QTDREQ")[3],"ZAJ"})
	Aadd(aHeader,{ "Cod.Refugo",       "ZAJ_CODREF", PesqPict("ZAJ","ZAJ_CODREF"),TAMSX3("ZAJ_CODREF")[1], TAMSX3("ZAJ_CODREF")[2],".F.","???????????????", TAMSX3("ZAJ_CODREF")[3],"ZAJ"})
	Aadd(aHeader,{ "Qtd.Ref."  ,       "ZAJ_QTDREF", PesqPict("ZAJ","ZAJ_QTDREF"),TAMSX3("ZAJ_QTDREF")[1], TAMSX3("ZAJ_QTDREF")[2],".F.","???????????????", TAMSX3("ZAJ_QTDREF")[3],"ZAJ"})
	Aadd(aHeader,{ "Status"    ,       "ZAJ_STATUS", PesqPict("ZAJ","ZAJ_STATUS"),TAMSX3("ZAJ_STATUS")[1], TAMSX3("ZAJ_STATUS")[2],".F.","???????????????", TAMSX3("ZAJ_STATUS")[3],"ZAJ"})
	Aadd(aHeader,{ "Msg.Erro"  ,       "ZAJ_MSGERR", PesqPict("ZAJ","ZAJ_MSGERR"),TAMSX3("ZAJ_MSGERR")[1], TAMSX3("ZAJ_MSGERR")[2],".F.","???????????????", TAMSX3("ZAJ_MSGERR")[3],"ZAJ"})

	aCols:={}
	While !EOF() .And. ZAJ_FILIAL+ZAJ_LOTE == xFilial("ZAJ")+cLote

		Aadd(aCols,{IIF(ZAJ->ZAJ_STATUS="A","BR_VERDE",IIF(ZAJ->ZAJ_STATUS="I","BR_AMARELO","BR_VERMELHO")),;
		             ZAJ->ZAJ_OP,ZAJ->ZAJ_SEQAPO,ZAJ->ZAJ_PROD,ZAJ->ZAJ_QTDPRO,ZAJ->ZAJ_XMAT,ZAJ->ZAJ_COMP,;
					 ZAJ->ZAJ_QTDREQ,ZAJ->ZAJ_CODREF,ZAJ->ZAJ_QTDREF,ZAJ->ZAJ_STATUS,ZAJ->ZAJ_MSGERRO,.F.})

		If ZAJ->ZAJ_STATUS == "E"
			If EMPTY(cMsgError)
				cMsgError += '<html>'
				cMsgError += '<head>'
				cMsgError += '  <meta content="text/html; charset=ISO-8859-1'
				cMsgError += ' http-equiv="content-type">'
				cMsgError += '  <title></title>'
				cMsgError += '</head>' 
				cMsgError += '<body>'
				cMsgError += 'Lote: '+cLote+'<br>'
				cMsgError += '<br>'
				cMsgError += 'Segue rela&ccedil;&atilde;o das Ordens de '
				cMsgError += 'Produ&ccedil;&atilde;o que geraram problema no apontamento:<br>'
				cMsgError += '<br>'
				cMsgError += '<table style="text-align: left; width: 100%;" border="1"'
				cMsgError += ' cellpadding="2" cellspacing="2">'
				cMsgError += '  <tbody>'
				cMsgError += '    <tr>'
				cMsgError += '      <th>OP</th>'
				cMsgError += '      <th>Produto</th>'
				cMsgError += '      <th>Material</th>'
				cMsgError += '      <th>Componente</th>'
				cMsgError += '      <th>Qtd.Req.</th>'
				cMsgError += '      <th>Mensagem de Erro</th>'
				cMsgError += '    </tr>'
			EndIf

            cMsgError += '    <tr>'
            cMsgError += '      <td>'+ZAJ->ZAJ_OP+'</td>'
            cMsgError += '      <td>'+ZAJ->ZAJ_PROD+'</td>'
            cMsgError += '      <td>'+Posicione("ZAK",1,xFilial("ZAK")+ZAJ->ZAJ_XMAT,"ZAK_DESC")+'</td>'
            cMsgError += '      <td>'+ZAJ->ZAJ_COMP+'</td>'
            cMsgError += '      <td>'+TRANSFORM(ZAJ->ZAJ_QTDREQ,PesqPict("ZAJ","ZAJ_QTDREQ"))+'</td>'
            cMsgError += '      <td>'+ZAJ->ZAJ_MSGERR+'</td>'
            cMsgError += '    </tr>'
		EndIf

		dbSkip()
	EndDo

	If !EMPTY(cMsgError)
		cMsgError += '  </tbody>'
		cMsgError += '</table>'
		cMsgError += '</body>'
		cMsgError += '</html>'
	EndIf

	If Len(aCols) == 0
		Aadd(aCols,{"","","","","","","","","","","","",.F.})
	EndIf

	If !EMPTY(cMsgError)

		cMailDestino := GetMV("MA_M04M12",.F.,"marcos.montes@moovegestao.com.br;sferreira@hoshizakimacom.com.br;wmanzini@hoshizakimacom.com.br")
		cAssunto     := "Importacao Metalix - Erro no Apontamento - Lote: "+cLote
		cTexto       := cMsgError
		cAnexos      := ""
		lMensagem    := .T. //Apresenta mensagem de eventual erro de conexào com o servidor de e-mail
		cMensQdoErro := ""

		lReturn := U_SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)

	EndIf

	@ 150,1 TO 720,1220 Dialog oDlgLog Title "LOG do processamento - Lote: "+cLote

	@ 010,010 TO 255,600 Multiline Object oLinhas

	oBtnExp := TButton():New(265,500,'Excel'   ,oDlgLog,{|| U_M04M12X(2,aCols,cLote) } ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
	oBtnExi := TButton():New(265,550,'OK'      ,oDlgLog,{|| Close(oDlgLog)           } ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)

	Activate Dialog oDlgLog Centered

EndIf

Return Nil

/*

Utilizado na consulta do produto na SXB = SB1MAT

Filtra somente os codigos de chapas - B1_XFAMIL2 contido no parametro MV_

*/
User Function M04M12F()

Local cFilSXB := ""

cFilSXB := "@B1_XFAMIL2 IN "+FormatIn(RTRIM(GetMV("AM_FAMIL2C",.F.,"000011;")),";")

Return cFilSXB
