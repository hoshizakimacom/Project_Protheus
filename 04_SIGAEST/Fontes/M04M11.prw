#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

/*/{Protheus.doc} M04M11

Exportaçào de dados de corte para sistema Metalix

@author Marcos Antonio Montes
@since 25/10/2024
@return Nil Nulo
/*/
User Function M04M11()

Local aPergs     := {}
Local aObject    := {}
Local aSizBrw    := msAdvSize(.f.,.f.,Nil)

Private cTitulo   := "Exporta dados para corte no Metalix"
Private aRetPar   := {}
Private aOrdProd  := {}
Private aEmpenhos := {}
Private oDlgPro, oTGr1qd, oBrwOP, oBrwEmp
Private nAtAnt    := 0

Private cLocCQ    := GETMV("MV_CQ"     ,.F.,"98") //Armazem de CQ
Private cLocProc  := GETMV("MV_LOCPROC",.F.,"99") //Armazem de Processo Material Indireto
Private lDblClick := .F.

//coordenada do browse de trabalho
aAdd(aObject,{100,10,.t.,.t.})
aAdd(aObject,{100,45,.t.,.t.})
aAdd(aObject,{100,45,.t.,.t.})

aInfBrw := {aSizBrw[1],aSizBrw[2],aSizBrw[3],aSizBrw[4],3,3}
aPosObj := msobjsize(aInfBrw,aObject,.t.)

Aadd(aPergs, {2, "Tipo de Produto"        ,"1",{"1=Chapa","2=Tubo"},80,".T.",.F.})                          //1
Aadd(aPergs, {1, "OP De"                  ,REPLICATE(' ',TAMSX3("D3_OP")[1]),"@X","","SC2","",60,.F.})      //2
Aadd(aPergs, {1, "OP Ate"                 ,REPLICATE('Z',TAMSX3("D3_OP")[1]),"@X","","SC2","",60,.T.})      //3
Aadd(aPergs, {1, "Produto De"             ,REPLICATE(' ',TAMSX3("D3_COD")[1]),"@X","","SB1","",60,.F.})     //4
Aadd(aPergs, {1, "Produto Ate"            ,REPLICATE('Z',TAMSX3("D3_COD")[1]),"@X","","SB1","",60,.T.})     //5
Aadd(aPergs, {6, "Local arquivo CSV"      ,SPACE(100),"","","",100,.T.,"Todos os arquivos (*.*) |*.*",,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_NETWORKDRIVE}) //6
Aadd(aPergs, {1, "Emissão  De"            ,dDataBase ,"","","","",50,.F.}) //7
Aadd(aPergs,{ 1, "Emissão  Ate"           ,dDataBase,"","","","",50,.T.})  //8

If !ParamBox(aPergs, "Seleção para Exportação de dados para corte no Metalix", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)
    Return 
EndIf

LjMsgRun( "Carregando dados..." ,, {|| aOrdProd := U_M04M11D() } )

If LEN(aOrdProd) > 0

	oDlgPro := msDialog():New(aSizBrw[1],aSizBrw[2],aSizBrw[6],aSizBrw[5],cTitulo,,,,,,,,,.t.)
	oTGr1qd := TGroup():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],'[ Ações da tela de Exportação de dados para Metalix ]',oDlgPro,,,.t.,)

	oBtnExp := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+  3,'Exporta CSV'     ,oDlgPro,{|| LjMsgRun( "Aguarde, Exportando CSV...",, {|| U_M04M11Ger() } ) },45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
	oBtnCon := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+ 53,'Visualiza OP'    ,oDlgPro,{|| U_M04M11V() }                                                   ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
	oBtnLeg := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+103,'Legenda'         ,oDlgPro,{|| U_M04M11L() }                                                   ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)
	oBtnExi := TButton():New(aPosObj[1,1]+08,aPosObj[1,2]+153,'Sair'            ,oDlgPro,{|| (lExit := .T.,oDlgPro:End()) }                                  ,45,15,,,.f.,.t.,.f.,,.f.,,,.f.)

	//Quadro com as Ordens de Produção
	oTGr2qd := TGroup():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],'[ Ordens de Produção - Corte de '+IIF(aRetPar[1]="1","Chapas","Tubos")+' ]',oDlgPro,,,.t.,)
	oBrwOP  := MsBrGetDBase():New(aPosObj[2,1]+8,aPosObj[2,2]+1,aPosObj[2,4]-5,aPosObj[2,3]-aPosObj[2,1]-5/*25*/,,,,oDlgPro/*oWnd*/,,,,,,,,,,,,.f.,'',.t./*lPixel*/,,.f.,,,)
	oBrwOP:SetArray(aOrdProd)
	oBrwOP:bChange := { || CarregaOP() }
	//oBrwOP:bDrawSelect := { || CarregaOP() }
	oBrwOP:blDblClick := { || (lDblClick := .T.,aOrdProd[oBrwOP:nAt,1] := !aOrdProd[oBrwOP:nAt,1],oBrwOP:Refresh(),lDblClick := .F.) }

	oBrwOP:bHeaderClick := {|oObj,nCol| IIf( nCol==1 , ( AEVal(aOrdProd,{|x| x[1] := !x[1] }) , oObj:Refresh() ),) }

	If Len(oBrwOP:aColumns) == 0
		oBrwOP:AddColumn(TCColumn():New('  '   		,{|| (/*CarregaOP()*/,Iif(aOrdProd[oBrwOP:nAt,1],'LBOK',"LBNO"))},,,,'CENTER', 10,.t.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Status'   		,{|| Iif(aOrdProd[oBrwOP:nAt,11] = 0, IIF(aOrdProd[oBrwOP:nAt,21]>0,"BR_AMARELO",Iif(aOrdProd[oBrwOP:nAt,20]="S",'BR_AZUL',Iif(aOrdProd[oBrwOP:nAt,20]="P",'BR_VIOLETA','BR_VERDE'))),;
					(Iif(aOrdProd[oBrwOP:nAt,11] > 0 .And. EMPTY(aOrdProd[oBrwOP:nAt,12]), 'BR_AZUL',;
					(Iif(!EMPTY(aOrdProd[oBrwOP:nAt,12]), 'BR_VERMELHO',;
					)))))},,,,'CENTER', 25,.t.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Numero da OP',25),{|| aOrdProd[oBrwOP:nAt, 2]},,,,'LEFT'	, TAMSX3("C2_NUM")[1]+30       ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Item'   	   ,{|| aOrdProd[oBrwOP:nAt, 3]},,,,'LEFT'	, TAMSX3("C2_ITEM")[1]+10      ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Sequencia',15),{|| aOrdProd[oBrwOP:nAt, 4]},,,,'LEFT'	, TAMSX3("C2_SEQUEN")[1]+15    ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Item Grd.'    ,{|| aOrdProd[oBrwOP:nAt, 5]},,,,'LEFT'	, TAMSX3("C2_ITEMGRD")[1]+15   ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Produto'      ,{|| aOrdProd[oBrwOP:nAt, 6]},,,,'LEFT'	, TAMSX3("C2_PRODUTO")[1]+15   ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Descrição'    ,{|| aOrdProd[oBrwOP:nAt, 7]},,,,'LEFT'	, TAMSX3("B1_DESC")[1]+30      ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Emissão'      ,{|| aOrdProd[oBrwOP:nAt, 8]},,,,'LEFT'	, TAMSX3("C2_EMISSAO")[1]+10   ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Prv.Inicio'  ,{|| aOrdProd[oBrwOP:nAt, 24]},,,,'LEFT'	, TAMSX3("C2_DATPRI")[1]+10    ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Prv.Entrega'  ,{|| aOrdProd[oBrwOP:nAt, 9]},,,,'LEFT'	, TAMSX3("C2_DATPRF")[1]+10    ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Quantidade',25) ,{|| aOrdProd[oBrwOP:nAt, 10]},PesqPict("SC2","C2_QUANT"),,,'RIGHT', TAMSX3("C2_QUANT")[1]+15  ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Qt.Entregue',25),{|| aOrdProd[oBrwOP:nAt, 11]},PesqPict("SC2","C2_QUJE"),,,'RIGHT', TAMSX3("C2_QUJE")[1]+15  ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Encerramento',20) ,{|| aOrdProd[oBrwOP:nAt, 12]},,,,'LEFT'	, TAMSX3("C2_DATRF")[1]+20    ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(PADR('Sentido Pré',20) ,{|| aOrdProd[oBrwOP:nAt, 26]},,,,'LEFT'	, TAMSX3("B1_XSPRE")[1]+20    ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Prod.PAI'     ,{|| aOrdProd[oBrwOP:nAt,16]},,,,'LEFT'	, TAMSX3("C2_PRODUTO")[1]+15   ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New('Descr.PAI'    ,{|| aOrdProd[oBrwOP:nAt,17]},,,,'LEFT'	, TAMSX3("B1_DESC")[1]+30      ,.f.,.f.,,,,.f.,))
		oBrwOP:AddColumn(TCColumn():New(''   		   ,{|| ''},,,,'CENTER', 1,.f.,.f.,,,,.f.,)) //Melhorar distribuição dos campos na tela

		oBrwOP:SetHeaderImage(03,"COLDOWN")  //Numero da OP
	EndIf
	oBrwOP:CallRefresh()

	oTGr4qd := TGroup():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],'[ Empenho de Materiais ]',oDlgPro,,,.t.,)
	oBrwEmp := MsBrGetDBase():New(aPosObj[3,1]+8,aPosObj[3,2]+1,aPosObj[3,4]-5,aPosObj[3,3]-aPosObj[3,1]-5/*25*/,,,,oDlgPro,,,,,,,,,,,,.f.,'',.t.,,.f.,,,)
	oBrwEmp:SetArray(aEmpenhos)

	If Len(oBrwEmp:aColumns) == 0
		oBrwEmp:AddColumn(TCColumn():New('  '   		    ,{|| aEmpenhos[oBrwEmp:nAt,9]},,,,'CENTER', 10,.t.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Ordem de Produção',30),{|| aEmpenhos[oBrwEmp:nAt, 1]},,,,'LEFT'	, TAMSX3("D4_OP")[1]+15  ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('Componente'       ,{|| aEmpenhos[oBrwEmp:nAt, 2]},,,,'LEFT'	, TAMSX3("D4_COD")[1]+15  ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('Descrição'  	    ,{|| aEmpenhos[oBrwEmp:nAt, 3]},,,,'LEFT'	, TAMSX3("B1_DESC")[1]+30      ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('Local'            ,{|| aEmpenhos[oBrwEmp:nAt, 4]},,,,'LEFT'	, TAMSX3("D4_LOCAL")[1]+15,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('UM'               ,{|| aEmpenhos[oBrwEmp:nAt, 11]},,,,'LEFT'	, TAMSX3("B1_UM")[1]+15,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('Quantidade'       ,{|| aEmpenhos[oBrwEmp:nAt, 5]},PesqPict("SD4","D4_QUANT"),,,'RIGHT'	, TAMSX3("D4_QUANT")[1]+20 ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.Loc.Emp.',30),{|| aEmpenhos[oBrwEmp:nAt, 6]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.CQ',30)  ,{|| aEmpenhos[oBrwEmp:nAt, 7]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Sld.Processo',30)  ,{|| aEmpenhos[oBrwEmp:nAt, 12]},PesqPict("SB2","B2_QATU"),,,'RIGHT'	, TAMSX3("B2_QATU")[1]+20 ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Qtd.Prv.Entrada',30),{|| aEmpenhos[oBrwEmp:nAt, 8]},PesqPict("SD4","D4_QUANT"),,,'RIGHT'	, TAMSX3("D4_QUANT")[1]+20 ,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Data Prev.Entrega',30),{|| aEmpenhos[oBrwEmp:nAt, 13]},,,,'LEFT'	, TAMSX3("C7_DATPRF")[1]+15,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Espessura',30),{|| aEmpenhos[oBrwEmp:nAt, 15]},,,,'LEFT'	, TAMSX3("B1_XESPES")[1]+15,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New(PADR('Material',30),{|| aEmpenhos[oBrwEmp:nAt, 16]},,,,'LEFT'	, TAMSX3("B1_XMAT")[1]+15,.f.,.f.,,,,.f.,))
		oBrwEmp:AddColumn(TCColumn():New('  '   		    ,{|| ''},,,,'CENTER', 10,.t.,.f.,,,,.f.,)) //Melhorar distribuição dos campos na tela
	EndIf
	oBrwEmp:CallRefresh()

	oBrwOP:goTop() //Força ir para a primeira linha

	//CarregaOP() //Carrega a primeira OP

	lExit := .F.
	oDlgPro:Activate(,,,.t.,{|| .t. },,{|| .t.})

	//If lExit
	//	Exit
	//EndIf
Else
	MsgAlert("Não encontrado Ordens de Produção com o filtro informado! Revise o filtro")
EndIf

Return Nil


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M11D
Carrega dados conforme filtro
@author    Montes 
@version   12.1
@since     25.10.2024

@return NIL

TABELA ZV
MP01 - CHAPAS
MP02 - TUBOS

AM_SPDCATC
Spend Categorias para Chapa (B1_XSPDCAT)
Ex.: MP01;MP03;

AM_SPDCATT
Spend Categorias para Tubos (B1_XSPDCAT)
Ex.: MP02;MP04;

/*/
//------------------------------------------------------------------------------------------
User Function M04M11D()

	Local aOrdProd   := {}
	Local cSeparada  := "N"
	Local nQtdEmpOri := 0
	Local nQtdEmpSld := 0
    //Local cAMSPDCAT  := GetNewPar(IIF(aRetPar[1]=="1","AM_SPDCATC","AM_SPDCATT"),.F.,"") //Codigos SPEND para Chapas e Tubos .Ex.: MP01;MP02
    Local cAMFAMIL2  := GetNewPar(IIF(aRetPar[1]=="1","AM_FAMIL2C","AM_FAMIL2T"),.F.,"") //Codigos Familia de Compras para Chapas e Tubos .Ex.: 000005;000011
	Local aProdPAI   := {}

	CursorWait()

	cTitulo := "Todas"

	//+---------------------------------------------------------------+
	//| Carrega Ordens de Produção conforme os parametros informados  |
	//+---------------------------------------------------------------+
	cQuery := "SELECT SC2.R_E_C_N_O_ RECSC2,SB1.R_E_C_N_O_ RECSB1 "
	cQuery += "FROM "+RetSQLName("SC2")+" SC2 "
	cQuery += "INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
	cQuery += "SC2.C2_DATRF = '  ' AND " //Somente OP's em Aberto
	cQuery += "C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+aRetPar[2]+"' AND "
	cQuery += "C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+aRetPar[3]+"' AND "
	cQuery += "C2_PRODUTO >= '"+aRetPar[4]+"' AND "
	cQuery += "C2_PRODUTO <= '"+aRetPar[5]+"' AND "
	cQuery += "C2_EMISSAO >= '"+DTOS(aRetPar[7])+"' AND "
	cQuery += "C2_EMISSAO <= '"+DTOS(aRetPar[8])+"' AND "
	cQuery += "SC2.C2_TPOP = 'F' AND "
	cQuery += "SC2.D_E_L_E_T_ = ' ' "

    cQuery += "AND ( "
	cQuery += "(SELECT COUNT(*) "
	cQuery += "FROM "+RetSqlName('SD4')+" SD4 "
	cQuery += "INNER JOIN "+RetSqlName('SB1')+" SB1EMP ON SB1EMP.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EMP.B1_COD = D4_COD AND SB1EMP.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery += "AND SD4.D4_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD "
	cQuery += "AND SD4.D4_QUANT > 0 "
	cQuery += "AND SD4.D_E_L_E_T_ = ' ' "
    //cQuery += "AND SB1EMP.B1_XSPDCAT IN "+FormatIn(RTRIM(cAMSPDCAT),";")
	cQuery += "AND SB1EMP.B1_XFAMIL2 IN "+FormatIn(RTRIM(cAMFAMIL2),";")
	cQuery += ") > 0  "
	cQuery += ") "

    cQuery += "ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD "

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

		IncProc("Lendo OP " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+ "...")

		cSeparada := " "
        aRecSD4MP := {}
		dbSelectArea("SD4")
		dbSetOrder(2) //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		If dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
			nQtdEmpOri := 0
			nQtdEmpSld := 0
			While !EOF() .And. D4_FILIAL+D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD

                //If SD4->D4_QUANT > 0 .And. POSICIONE("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_XSPDCAT") $ RTRIM(cAMSPDCAT)
                If SD4->D4_QUANT > 0 .And. POSICIONE("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_XFAMIL2") $ RTRIM(cAMFAMIL2)
                    AADD(aRecSD4MP,SD4->(RECNO()))
                EndIf
            	
                nQtdEmpOri += SD4->D4_QTDEORI
				nQtdEmpSld += SD4->D4_QUANT

				dbSelectArea("SD4")
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

		aProdPAI := RetCodPai()

		SB1->(dbGoTo((cAliasTrb)->(RECSB1)))

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
                            aProdPai[1],;                               //16-Código Prod.PAI
                            aProdPai[2],;                               //17-Descr.Prod.PAI
                            aRecSD4MP,;                                 //18-Registros Empenho MP de Corte
                            .F.,;                                       //19-Tem Saldo
                            cSeparada,;                                 //20-Separada
                            0,;                                         //21-Iniciada
                            "",;                                        //22-
                            "",;                                        //23-
                            SC2->C2_DATPRI,;                            //24-Prv.Inicio
                            "",;                                        //25-
                            X3Combo("B1_XSPRE",SB1->B1_XSPRE)})         //26-Sentido Pré

		dbSelectArea(cAliasTrb)
		dbSkip()
	EndDo
	dbSelectArea(cAliasTrb)
	dbCloseArea()

	CursorArrow()

Return aOrdProd

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CarregaOP
Carrega informação da Ordem de Produção posicionada 

@author    Montes 
@version   12.1
@since     25.10.2024

@param -
@return NIL

/*/
//------------------------------------------------------------------------------------------
Static Function CarregaOP()
	Local aArea
	Local nSldEst   := 0
	Local nSldCQ    := 0
	Local nPrvEnt   := 0

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
			dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
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

			nSldLib := 0

			AADD(aEmpenhos, {SD4->D4_OP,SD4->D4_COD,SB1->B1_DESC,SD4->D4_LOCAL,SD4->D4_QUANT,nSldEst,nSldCQ,nPrvEnt,"BR_VERMELHO","Sim",SB1->B1_UM,nSldProc,dDatPRF,nSldLib,X3Combo("B1_XESPES",SB1->B1_XESPES),X3Combo("B1_XMAT",SB1->B1_XMAT)} )

			//Verifica se tem saldo para o componente em estoque no Armazem (Ex.01), caso Produto PI considera o saldo em Processo tambem (Ex.Arm.01 + Arm.03)
			If ( SD4->D4_QUANT ) > 0 .And. ( SD4->D4_QUANT ) > IIF(SB1->B1_TIPO="PI",nSldEst+nSldCQ,nSldEst)
				lTemSaldo := .F.
				If nSldEst > 0 //Saldo do armazem maior que zero - saldo para atendimento parcial
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
/*/{Protheus.doc} U_M04M11Ger

Gera arquivo CSV para sistema METALIX com base na selação das OP's

@author    Montes
@version   12.1
@since     25.10.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M11Ger()

Local aArea     := GETAREA()
Local nX        := 0
Local nY
Local nH
Local cArq      := ALLTRIM(aRetPar[6])+"\"+IIF(aRetPar[1]=="1","chapa","tubo")+"_"+DTOS(DATE())+"_"+STRTRAN(TIME(),":","")+".csv"
Local nDecimais := 1
Local nQuantMT  := 0

nH := fCreate(cArq)

If nH == -1
    MsgStop("Falha ao criar arquivo - Erro "+str(ferror()))
    Return
EndIf

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD4")
dbSetOrder(1)

dbSelectArea("SC2")
dbSetOrder(1)

ProcRegua(Len(aOrdProd))

/*
LayOut CHAPA:
"Codigo;Tipo_Cod;Componente;Tipo_Comp;Quant"


Layout TUBOS
CÓDIGO (PI)
DESCRIÇÃO (Com base no cadastro do PI)
QUANTIDADE UNITARIA (quantidade do PI com base na estrutura do PA de onde se extraiu o relatório)
MATERIAL (Descrição da matéria prima dentro da estrutura do PI em questão)
COMPRIMENTO CORTE (Quantidade da matéria prima com base na estrutura do PI)
TUBO0001
REFORÇO LATERAL
1
TUBO 304 A554 ESC #180 Ø 2 1/2"X1.50X6000
1200
TUBO0002
REFORÇO FRONTAL
2
TUBO 304 A554 ESC #180 Ø 4"X1.5X6000
700

OBS: A coluna COMPRIMENTO CORTE deverá ter a possibilidade de se inserir um fator de conversão.
*/


// Escreve o texto mais a quebra de linha CRLF
If aRetPar[1] == "1" //Chapa
	//fWrite(nH,"Codigo;Tipo_Cod;Componente;Tipo_Comp;Quant;OP" + chr(13)+chr(10) )        
	fWrite(nH,"CAMINHO;PROGRAMA;QUANTIDADE;ESPESSURA;MATERIAL;CLIENTE / OP;PROJ.;SEN.PRÉ" + chr(13)+chr(10) )        
ElseIf aRetPar[1] == "2" //Tubo
	fWrite(nH,"Codigo;Descricao;Quantidade;Material;Comprimento_Corte;OP" + chr(13)+chr(10) )        
EndIf

For nX := 1 To Len(aOrdProd)

	If aOrdProd[nX][1]

		SC2->(dbGoTo(aOrdProd[nX][13]))

		IncProc("Exportando dados da OP " + aOrdProd[nX][2]+aOrdProd[nX][3]+aOrdProd[nX][4])

		If SC2->(!EOF())

			For nY := 1 To Len(aOrdProd[nX][18])

				SD4->(dbGoTo(aOrdProd[nX][18][nY]))

				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
				cTipo_Cod := SB1->B1_TIPO
				cDesc_PI  := SB1->B1_DESC
				cSentidoPre:= X3Combo("B1_XSPRE",SB1->B1_XSPRE)

				SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
				cTipo_Comp := SB1->B1_TIPO
				cDesc_MP   := SB1->B1_DESC
				cUM_MP     := SB1->B1_UM
				cSEGUM_MP  := SB1->B1_SEGUM
				cEspessura := X3Combo("B1_XESPES",SB1->B1_XESPES)
				cMaterial  := X3Combo("B1_XMAT",SB1->B1_XMAT)

				//Dados do componente pra corte
				If  aRetPar[1] == "1" // Chapa

					cLocalDXF := "W:\Work\maquinas\dxf-prg" //"W:\Work\maquinas\dxf-prg\DXF-PDM"

					fWrite(nH,  cLocalDXF+";"+;
								Alltrim(SC2->C2_PRODUTO)+".DXF"+";"+;
								Alltrim(Transform(SC2->C2_QUANT/*SD4->D4_QUANT*/,"999999999.9"/*"999999999.999999"*/))+";"+;
								cEspessura+";"+;
								cMaterial+";"+;
								Alltrim(SD4->D4_OP)+";"+;
								Alltrim(aOrdProd[nX][16]/*SC2->C2_PRODUTO*/)+";"+;
								cSentidoPre + chr(13)+chr(10) )

				ElseIf aRetPar[1] == "2" //Tubo

					nQuantMT := 0
					If cUM_MP == "MT"
					 	nQuantMT := SD4->D4_QUANT
					ElseIf cSEGUM_MP == "MT"
						nQuantMT := SD4->D4_QTSEGUM
					EndIf
					nQuantMT   := ( nQuantMT / SC2->C2_QUANT ) //Converte para Unitário
					nQuantMM   := nQuantMT * 1000
					nQuantMM   := ROUND(nQuantMM,nDecimais)
					nPercPerda := 0
 
					dbSelectArea("SG1")
					dbSetOrder(1) // G1_FILIAL+G1_COD+G1_COMP+G1_TRT
					dbSeek(xFilial("SG1")+SD4->D4_PRODUTO+SD4->D4_COD+SD4->D4_TRT)
					While !EOF() .And. G1_FILIAL+G1_COD+G1_COMP+G1_TRT == xFilial("SG1")+SD4->D4_PRODUTO+SD4->D4_COD+SD4->D4_TRT

						If SC2->C2_REVISAO >= SG1->G1_REVINI .And. SC2->C2_REVISAO <= SG1->G1_REVFIM .And.;
						   SD4->D4_DATA >= SG1->G1_INI .And. SD4->D4_DATA <= SG1->G1_FIM
							nPercPerda := SG1->G1_PERDA
							Exit
						EndIf

						dbSkip()
					EndDo
					dbSelectArea("SD4")

					If nPercPerda > 0
						nQuantMM *= ((100-nPercPerda)/100)
					EndIf

					fWrite(nH,  Alltrim(SC2->C2_PRODUTO)+";"+;
								RTRIM(cDesc_PI)+";"+;
								Alltrim(Transform(SC2->C2_QUANT,"999999999.9"/*"999999999.999999"*/))+";"+;
								RTRIM(cDesc_MP)+";"+;
								Alltrim(Transform(nQuantMM,"999999999.9"/*"999999999.999999"*/))+";"+; 
								Alltrim(SD4->D4_OP) + chr(13)+chr(10) )

				EndIf
			Next
		EndIf

	EndIf
Next

fClose(nH)

RESTAREA(aArea)

FWAlertInfo("Arquivo gerado com Sucesso : " + cArq, "Geração de arquivos")

Return Nil

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M11V
Consulta Ordem de Produção
@author    Montes
@version   12.1
@since     25.10.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M11V()

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
/*/{Protheus.doc} U_M04M11L
Legenda dos Browses
@author    Montes 
@version   12.1
@since     25.11.2022

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M11L()

	Local aCores1  := {}
	Local aCores2  := {}
	Local nY       := 0
	Local nX       := 0
	Local aBmp     := {}
	Local aBmp2    := {}
	Local aSays    := {}
	Local aSays2   := {}
	Local oDlgLeg
	Local nXSize 	:= 14

// Cores do Status da OP
	Aadd(aCores1,{"BR_VERDE"     , "OP em aberto"             })
	Aadd(aCores1,{"BR_AZUL"      , "OP Separada total"        })
	Aadd(aCores1,{"BR_VIOLETA"   , "OP Seperada parcialmente" })
	Aadd(aCores1,{"BR_AMARELO"   , "OP Inicia"                })
	Aadd(aCores1,{"BR_VERMELHO"  , "OP Encerrada"             })

// Cores do Saldo do Empenho da OP
	Aadd(aCores2,{"BR_VERDE"      , "Empenho com estoque suficiente" })
	Aadd(aCores2,{"BR_AMARELO"    , "Empenho com estoque parcial"    })
	Aadd(aCores2,{"BR_VERMELHO"   , "Empenho sem saldo em estoque"   })

	aBmp  := ARRAY(Len(aCores1))
	aBmp2 := ARRAY(Len(aCores2))
	aSays := ARRAY(Len(aCores1))
	aSays2:= ARRAY(Len(aCores2))

	DEFINE MSDIALOG oDlgLeg FROM 0,0 TO ((Len(aCores1)+Len(aCores2))*25)+100,334 TITLE "Legenda da tela de Exportação"  PIXEL

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
	@ 73  ,37  SAY "Saldo em Estoque do Empenho da OP" Of oDlgLeg PIXEL SIZE 100,9 FONT oBold

	For nX := 1 to Len(aCores2)
		@ 89+((nx-1)*10),44 BITMAP aBmp2[nx] RESNAME aCores2[nx][1] of oDlgLeg SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ 89+((nx-1)*10),(nXSize/2) + 47 SAY If((nY+=1) == nY,aCores2[nY][2]+If(nY==Len(aCores2),If((nY:=0)==nY,"",""),""),"") of oDlgLeg PIXEL
	Next nX
	nY := 0

	ACTIVATE MSDIALOG oDlgLeg CENTERED

Return



//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RetCodPai
Retorna o Codigo e Descrição do Produto PAI
@author    Montes 
@version   12.1
@since     31.01.2024

@return NIL

/*/
//------------------------------------------------------------------------------------------
Static Function RetCodPai()

Local aProdPAI := {"",""}
Local aArea    := GetArea()
Local aAreaSC2 := SC2->(GetArea())
Local aAreaSB1 := SC2->(GetArea())
Local cNumOP   := SC2->C2_NUM
Local cItemOP  := SC2->C2_ITEM

dbSelectArea("SC2")
dbSetOrder(1)
While !EOF() .And. !(SC2->C2_SEQPAI="   ".OR.SC2->C2_SEQPAI="000")

	dbSeek(xFilial("SC2")+cNumOP+cItemOP+SC2->C2_SEQPAI)

EndDo

If !EOF()
   aProdPAI[1] := SC2->C2_PRODUTO
   aProdPAI[2] := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
EndIf

RestArea(aArea)
RestArea(aAreaSC2)
RestArea(aAreaSB1)

Return aProdPAI
