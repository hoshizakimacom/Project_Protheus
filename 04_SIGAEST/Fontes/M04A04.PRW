
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � RM04A04  � Autor � MooveGest緌           � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Rotina de reempenho                                        陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Especifico Macom                                           陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                                �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Local aCores         := {}
//Local aEstru         := {}
//Local aCampos        := {}
//Local cPerg          := "M04A04"
Local lInverte 	:= .F.

Private aIndexSC2    := {}
Private cQuerySC2    := ""
Private cFilMarkbSC2 := ""
Private bFiltraSC2
Private cCadastro    := "Reempenho das Ordens de Producao"
Private cMarca 	:= GetMark()

aRotina   := {  { AnsiToOem("Pesquisar" )    ,'AxPesqui'       ,0 , 1 },;
                { AnsiToOem("Visualizar")    ,'U_M04A04VIS()'  ,0 , 2 },;
                { AnsiToOem("Estrutura")     ,'U_M04A04EST()'  ,0 ,3 },;    
                { AnsiToOem("Reempenhar")    ,'U_M04A04EMP()'  ,0 , 3 },;
                { AnsiToOem("Legenda")			,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","O.P. em aberto"},{"BR_VERMELHO","O.P. Produzida ou Encerrada"}})'	,0 , 3 }}

// { AnsiToOem("Empenhos")      ,'U_RESTA01()'    ,0 ,3 },;    

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a tela de parametros da rotina                         �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//ValidPerg(cPerg)
//If !Pergunte(cPerg,.T.)    
//   Return
//Endif
      
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Filtra os registros das OP's de acordo com parametros        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
cQuerySC2    := "C2_FILIAL = '"+xFilial("SC2")+"' "
//If MV_PAR01 == 1
   cQuerySC2 += "AND C2_QUANT > C2_QUJE AND Empty(C2_DATRF)"
//Endif
	
cFilMarkbSC2 := "C2_FILIAL == '"+xFilial("SC2")+"'"
//If MV_PAR01 == 1
   cFilMarkbSC2 += " .AND. C2_QUANT > C2_QUJE .AND. Empty(C2_DATRF)"
//Endif

bFiltraSC2 := {|x| If(x==Nil,FilBrowse("SC2",@aIndexSC2,@cFilMarkbSC2),If(x==1,cFilMarkbSC2,cQuerySC2))}
Eval(bFiltraSC2)
               
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Monta os leds de cores do browse                                       �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Aadd( aCores, { "SC2->C2_QUJE == 0 .AND. Empty(SC2->C2_DATRF)"								, "BR_VERDE"  	})
Aadd( aCores, { "SC2->C2_QUJE > 0 .AND. C2_QUANT > C2_QUJE .AND. Empty(SC2->C2_DATRF)"    	, "BR_AMARELO"	})
Aadd( aCores, { "C2_QUANT <= C2_QUJE .OR. !Empty(SC2->C2_DATRF)"    						, "BR_VERMELHO"	})

DbSelectArea("SC2")
DbSetOrder(1)
                
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Endereca a funcao de BROWSE                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
MarkBrow("SC2","C2_OK",'C2_QUANT - C2_QUJE = 0',,@lInverte,@cMarca)
//mBrowse(6, 1, 22, 75, "SC2",,,,,3,aCores)

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Retorna indices do SC2                                       �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SC2")
RetIndex("SC2")
dbClearFilter()
aEval(aIndexSC2,{|x| Ferase(x[1]+OrdBagExt())})

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04VIS � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Visualizacao da OP x Empenho                               陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04VIS()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Declaracao de variaveis                                             �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
Local   nOpcE         := 2    //visualizar
Local   nOpcG         := 2    //visualizar
Local _lRet := .F.
Local _ni

Private cOpcao               
Private aHeader       := {}
Private aCols         := {}
Private aCpoEnchoice  := {}

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Monta o array com os campos da Enchoice                             �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC2")
While !Eof() .and. (SX3->X3_ARQUIVO == "SC2")
   If X3USO(x3_usado) .and. cNivel >= x3_nivel
      AADD(aCpoEnchoice, SX3->X3_CAMPO)
   Endif
   DbSelectArea("SX3")
   dbSkip()
Enddo

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Cria variaveis M->????? da Enchoice                                 �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
RegToMemory("SC2",(cOpcao=="VISUALIZAR"))

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Cria aHeader e aCols da GetDados                                    �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
dbSelectArea("SX3")
dbSeek("SD4")
While !Eof().And.(x3_arquivo=="SD4")
   If X3USO(x3_usado) .and. cNivel >= x3_nivel
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                      x3_tamanho, x3_decimal,"AllwaysTrue()",;
                      x3_usado, x3_tipo, x3_arquivo, x3_context} )
      If Alltrim(X3_CAMPO) == "D4_COD"
		 Aadd(aHeader,{ "Descricao", "B1_DESC"/*"B1_CEME"*/, "@!",;
                         50, 0,"AllwaysTrue()",;
                         x3_usado, "C", "SB1", x3_context} )
      Endif                  
   Endif                   
   DbSkip()
Enddo

aCols := {}
DbSelectArea("SD4")
DbSetOrder(2)
If DbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,.F.)
   While !eof() .and. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
      AADD(aCols,Array(Len(aHeader)+1))
      For _ni := 1 to Len(aHeader)
          If aHeader[_ni,2] == "B1_DESC" //"B1_CEME"
             aCols[Len(aCols),_ni] := Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC"/*"B5_CEME"*/)
          Else
             aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
          Endif
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.
      DbSelectArea("SD4")
      DbSkip()
   Enddo
Else   
   If Len(aCols) <= 0
	  aCols := {Array(Len(aHeader)+1)}
	  For _ni:=1 to Len(aHeader)
		  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	  Next
	  aCols[1,Len(aHeader)+1] := .F.
   Endif	  
Endif

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Executa a Modelo 3                                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
cTitulo        := "Empenhos da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN
cAliasEnchoice := "SC2"
cAliasGetD     := "SD4"
cLinOk         := "AllwaysTrue()"
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a rotina de Modelo 3                                   �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,999,,1)

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04EST � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Visualizacao da estrutura do produto                       陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04EST()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Private ldbTree    := .F.
Private cInd5      := ''
Private nOpcx := 2
Private l200auto := .F.

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a rotina de visualizacao da estrutura                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SG1")
DbSetOrder(1)
DbSeek(xFilial("SG1")+SC2->C2_PRODUTO)

Pergunte('MTA200', .F.)
a200Proc("SG1",SG1->(RECNO()),2)

DbSelectArea("SC2")

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04EMP � Autor � Marcos Rocha         � Data � 13/01/25  陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Executa o reempenho dos produtos sem lote                  陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04EMP()

Local lEnd := .F.
Local nOps := 0
Local ni
Local aFilial  := {}

Private aSav650 := Array(20)
Private lConsTerc
Private lConsNPT
Private lProj711  := .F.
Private lMata712  := .F.
Private lPCPA107  := .F.
Private lPCPA113  := .F.
Private lGerouOP  := .T.
Private l650Auto  := .F.
Private lZrHeader := If(l650Auto,.T.,.F.)

If Aviso("Atencao !","Deseja processar o reempenho das OP's marcadas ?",{"Sim","Nao"}) <> 1
	Return
EndIf

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Seleciona as OP's marcadas                                     �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SC2")
_cSelec := "SELECT SC2.R_E_C_N_O_ AS REGISTRO"
_cQuery := " FROM "
_cQuery += RetSqlName("SC2")+" SC2 "
_cQuery += " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"'"
_cQuery += "   AND SC2.C2_OK = '"+cMarca+"'"
_cQuery += "   AND SC2.D_E_L_E_T_ <> '*'"
_cOrder := " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN"

If Select("TRBSC2") > 0
	DbSelectArea("TRBSC2")
	DbCloseArea()
Endif

TCQUERY _cSelec+_cQuery+_cOrder NEW ALIAS "TRBSC2"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Processa as OP's selecionadas                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("TRBSC2")
DbGoTop()
While !EOF()

    DbSelectArea("SC2")
    DbGoTo(TRBSC2->REGISTRO)

	If ValExclOP()[1]
    
		//If Aviso("Atencao !","Deseja processar o reempenho da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN+" ?",{"Sim","Nao"}) == 1
		Processa({|| ReempOp()}, "Processando o reempenho da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN+" ...")
		//EndIf

		nOps += 1

		DbSelectArea("SC2")
		RecLock("SC2",.F.)
		SC2->C2_OK     := Space(2)
		SC2->C2_BATCH  := ""  // "S"
		SC2->C2_BATROT := FunName() // With FunName()
		SC2->C2_BATUSR := ""
		MsUnLock()

	EndIf

	DbSelectArea("TRBSC2")
	DbSkip()
EndDo

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Finaliza o arquivo temporario                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
If Select("TRBSC2") > 0
	DbSelectArea("TRBSC2")
	DbCloseArea()
Endif

If nOps > 0 //Gera Explos緌 das OP's

	aAdd(aFilial,{cFilAnt,0,xFilial("SC2")})
	Pergunte("MTA650",.F.)
	For ni := 1 to 20
			aSav650[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	lConsNPT  := (aSav650[14] == 1)
	lConsTerc := !(aSav650[15] == 1)

	Processa({|lEnd| MA650Process(@lEnd,nOps)},"Gera誽o de OPs Intermediarias e SCs",OemToAnsi("Gerando OPs Intermediarias e SCs..."),.F.) 	
	lGerouOP  := .F.

	// Criar funcao ou pegar da que usei pra explodir estrutura
	// Ver os casos de Ops com apontamento parcial
	//GeraEmpenho()
EndIf

DbSelectArea("SC2")
Return                                         

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � ValExclOP� Autor � Montes                � Data � 07/02/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Valida se pode ou n緌 excluir a OP                         陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
Static Function ValExclOP()

Local lOk      := .T.
Local cError   := ""
Local aArea    := GetArea()
Local aAreaSD4 := SD4->(GetArea())

dbSelectArea("SD4")
dbSetOrder(1)
dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
While !EOF()

	If SD4->D4_QTDEORI <> SD4->D4_QUANT

		lOk    := .F.
		cError := "Existe requisi誽o apontadas para a OP !("+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+")"

	ElseIf !EMPTY(SD4->D4_OPORIG)

		dbSelectArea("SC2")
		dbSetOrder(1)
		If dbSeek(xFilial("SC2")+SD4->D4_OPORIG)
			
			If !EMPTY(SC2->C2_DATRF) .Or. SC2->C2_QUJE <> 0
				
				lOk    := .F.
				cError := "Existem OP intermediaria apontadas parcialmente !("+SD4->D4_OPORIG+")"

			Else

				aRet := ValExclOP()
				lOk    := aRet[1]
				cError := aRet[2]

			EndIf

		EndIf
	EndIf

	If !lOk
		Exit
	EndIf

	dbSelectArea("SD4")
	dbSkip()
EndDo

dbSelectArea("SC2")

RestArea(aAreaSD4)
RestArea(aArea)

Return {lOk,cError}

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � REEMPOP  � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Executa o reempenho dos produtos sem lote                  陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
Static Function REEMPOP()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//Local nOpca			:= 0
//Local nSomaSD4		:= 0
//Local aTravas		:= {}
//Local aArray		:= {}
//Local lLocaliza		:= .F.
//Local lConsVenc 	:= GetMV('MV_LOTVENC') == "S"
//Local lVenc			:= GETMV("MV_LOTVENC") == "S"
//Local cOp       	:= ""

//Local cLocalLote	:= ""
//Local cLocPI 		:= GetMV("MV_LOCPI")
//Local cLocKT 		:= GetMV("MV_LOCKT")
//Local cLoteAnt		:= Criavar("D4_NUMLOTE")
//Local cLotCtlAnt	:= Criavar("D4_LOTECTL")
//Local nQtdAnt		:= 0
//Local cLocal		:= Criavar("D4_LOCAL")

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Salva a area dos arquivos utilizados                           �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Local aSavArea := GetArea()
Local aSavDC   := SDC->(GetArea())
Local aSavD4   := SD4->(GetArea())
Local aSavB1   := SB1->(GetArea())
Local aSavC2   := SC2->(GetArea())
Local nTotRegs := 0

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Localiza os empenhos da OP                                     �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SD4")
_cSelec := "SELECT SD4.R_E_C_N_O_ AS REGISTRO, SD4.D4_COD "
_cCount := "SELECT COUNT(*) AS TOTREGS "
_cQuery := " FROM "
_cQuery += RetSqlName("SD4")+" SD4 "
_cQuery += " WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "
_cQuery += "   AND SD4.D4_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "
_cQuery += "   AND SD4.D4_LOTECTL = '' "
_cQuery += "   AND ( SD4.D4_QUANT > 0 OR SD4.D4_QUANT = 0 ) "
_cQuery += "   AND SD4.D_E_L_E_T_ <> '*' "
_cOrder := " ORDER BY SD4.D4_COD"

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY _cCount+_cQuery NEW ALIAS "TRB"

nTotRegs := TRB->TOTREGS

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY _cSelec+_cQuery+_cOrder NEW ALIAS "TRB"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Processa os empenhos sem lote                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("TRB")
DbGotop()                       
ProcRegua(nTotRegs)
While !Eof()

    IncProc("Reempenhando produto "+Alltrim(SD4->D4_COD)+" ...")

	DbSelectArea("SD4")
	DbGoto(TRB->REGISTRO)

	If SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)) .AND. SD4->D4_QUANT > 0
        //矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
        //� Exclui quantidade no Empenho Firme no Local Anterior         �
        //斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
        GravaB2Emp("-",SD4->D4_QUANT,"F")
    EndIf

	RecLock("SD4",.F.)
	DbDelete()
	MsUnlock()

	If !EMPTY(SD4->D4_OPORIG)
		
		dbSelectArea("SC2")
		dbSetOrder(1)
		If dbSeek(xFilial("SC2")+SD4->D4_OPORIG)
			//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
			//� Exclui OP intermediaria                                      �
			//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
			ExcluiOP()
		EndIf
    
	EndIf

	dbSelectArea("TRB")
	dbSkip()
EndDo

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Restaura a area dos arquivos utilizados                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
RestArea(aSavArea)
RestArea(aSavDC)
RestArea(aSavD4)
RestArea(aSavB1)
RestArea(aSavC2)

Return


/*/
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
控奼迋迋迋迋迕迋迋迋迋迋豖迋迋迋迕迋迋迋迋迋迋迋迋迋迋冞迋迋迕迋迋迋迋迋迋芼控
控慚un�o    蛄eraEmpenho� Autor � 				      � Data �  13/01/25   滷�
控昅迋迋迋迋阹迋迋迋迋迋虮迋迋迋迍迋迋迋迋迋迋迋迋迋迋庋迋迋迍迋迋迋迋迋迋芧控
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔
/*/
Static Function GeraEmpenho()

Local cProduto  	:= ""
Local nProc

// Usar a Funcao que explode a extrutura
aEstrutura  := {}
BuscaEstru(SC2->C2_PRODUTO,1)

// Ordena por produto para tratar o TRT
aEstrutura := aSort(aEstrutura  ,,, { |x,y| y[1] > x[1]} )

// Grava SD4
cProdAnt := ""
cTRT     := ""
For nProc := 1 To Len(aEstrutura)

	cProduto := aEstrutura[nProc,1]
	nQtd     := aEstrutura[nProc,2]
//		nQtdPerd := aProdChapa[nProc,3]

	If cProdAnt == cProduto
		cTrt  := If(Empty(cTrt),"001",StrZero(Val(cTrt)+1,3))
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)

	dbSelectArea("SD4")
	RecLock("SD4",.T.)
	SD4->D4_FILIAL   := xFilial("SD4")
	SD4->D4_COD      := cProduto
	SD4->D4_LOCAL	:= "99"  //SB1->B1_LOCPAD
	SD4->D4_OP		:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	SD4->D4_DATA 	:= SC2->C2_EMISSAO

	nQtd  :=  nQtd * SC2->C2_QUANT // Confirmar a conta de apontamento parcial
	SD4->D4_QUANT    := nQtd
	SD4->D4_QTDEORI  := nQtd
	SD4->D4_TRT      := cTrt
	SD4->D4_PRODUTO  := SC2->C2_PRODUTO
	MsUnLock()
	
	//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
	//彪ria o SB2 se ele nao existir                                             �
	//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
	CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD) //U_CriaSB2Esp(SB1->B1_COD,SB1->B1_LOCPAD)

	cProdAnt := cProduto
Next

return

/*/
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控奼迋迋迋迋迕迋迋迋迋迋冞迋迋迋敊迋迋迋迋迋迋迋迋迋豖迋迋迋敊迋迋迋迋迋迋跼�
控慚un�o    處uscaEStru� Autor � 				     � Data �  13/01/25   滷�
控昅迋迋迋迋阹迋迋迋迋迋庋迋迋迋玵迋迋迋迋迋迋迋迋迋虮迋迋迋玵迋迋迋迋迋迋僚�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
/*/
Static Function BuscaEStru(cProduto,nQtdBase)

Local aArea   := GetArea()
Local nRecSG1 := 0

//	aProdutos  := {}

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)
While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

	//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
	//� Desconsidera somente itens vencidos , sem opcionais ou fora  �
	//� da revisao atual.                                            �
	//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
	//If QtdComp(nQuantItem) != QtdComp(0)
	//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
	//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
	//	nCusTot := nCusTot + (nQuantItem * nCusto)
	//EndIf

	// Tratar a Validade da Estrutura
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

	//dbSelectArea("SB1")
	//dbSeek(xFilial("SB1")+SG1->G1_COD)
//		nQuant := SG1->G1_QUANT

	nQuant :=  (SG1->G1_QUANT / (100 - SG1->G1_PERDA )) * 100 
	nQuant :=  nQuant * nQtdBase 

	Aadd(aEstrutura,{SG1->G1_COMP,nQuant,cNivel})

	nRecSG1 := SG1->(Recno())
	cComp := SG1->G1_COMP
	If dbSeek(xFilial("SG1")+cComp)
		BuscaEstru(cComp,nQuant)
	EndIf
	dbGoto(nRecSG1)

	dbSelectArea("SG1")	
	dbSkip()
EndDo

RestArea(aArea)

Return



/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � M04A04DEL� Autor � Montes                � Data � 07/02/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Exclui OP intermediaria em duplicidadde                    陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04DEL()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Salva a area dos arquivos utilizados                           �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//Local aSavArea := GetArea()
Local cQuery   := ""

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "PCP" TABLES "SC2"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Localiza os empenhos da OP                                     �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
dbSelectArea("SD4")

cQuery  := "SELECT SC2.R_E_C_N_O_ RECSC2 "
cQuery  += "FROM "+RetSqlName("SC2")+" SC2 "
cQuery  += "INNER JOIN "+RetSqlName("SD4")+" SD4 ON D4_FILIAL = C2_FILIAL AND D4_OPORIG = C2_NUM+C2_ITEM+C2_SEQUEN+C2_GRADE AND SD4.D_E_L_E_T_ = '*' AND D4_OPORIG <> ' ' "
cQuery  += "WHERE SC2.D_E_L_E_T_ = ' ' "
cQuery  += "AND C2_QUJE = 0 "
cQuery  += "AND C2_DATRF = ' ' "
cQuery  += "AND C2_SEQPAI <> ' ' "
//cQuery  += "AND C2_NUM IN ('169282','170541') "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Processa os empenhos sem lote                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
dbSelectArea("TRB")
dbGoTop()                       

While !Eof()

	dbSelectArea("SC2")
	dbGoTo(TRB->RECSC2)

	If !EOF() 

		If ValExclOP()[1]

			//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
			//� Exclui OP intermediaria                                      �
			//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
			ExcluiOP()
		EndIf

    EndIf

	dbSelectArea("TRB")
	dbSkip()
EndDo

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Restaura a area dos arquivos utilizados                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//RestArea(aSavArea)

RESET ENVIRONMENT

Return

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Exclui OP intermediaria                                      �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Static Function ExcluiOP()

Local aSavArea := GetArea()
Local lRet     := .T.
Local aEsta650 := {}
Local i    

	  	aAdd(aEsta650,  {	{'C2_NUM'		, SC2->C2_NUM		  , Nil},;
                        	{'C2_ITEM'		, SC2->C2_ITEM	      , Nil},;
                        	{'C2_SEQUEN'	, SC2->C2_SEQUEN	  , Nil},;
                        	{'C2_PRODUTO'	, SC2->C2_PRODUTO	  , Nil},;
                        	{'C2_LOCAL'		, SC2->C2_LOCAL	      , Nil},;
                        	{'C2_QUANT'		, SC2->C2_QUANT		  , Nil},;
                        	{'C2_UM'		, SC2->C2_UM		  , Nil},;
                        	{'C2_DATPRI'	, SC2->C2_DATPRI	  , Nil},;
                        	{'C2_DATPRF'	, SC2->C2_DATPRF	  , Nil},;
                        	{'C2_EMISSAO'	, SC2->C2_EMISSAO	  , Nil},;
                        	{'C2_PRIOR'		, SC2->C2_PRIOR	      , Nil},;
                        	{'C2_TPOP'		, SC2->C2_TPOP	      , Nil},;
                        	{'C2_CC'		, SC2->C2_CC		  , Nil},;
                        	{'C2_REVISAO'	, SC2->C2_REVISAO	  , Nil},;
                        	{'C2_ITEMCTA'	, SC2->C2_ITEMCTA	  , Nil},;
                        	{'C2_CLVL'		, SC2->C2_CLVL	      , Nil},;
                        	{'C2_SEQMRP'	, SC2->C2_SEQMRP	  , Nil},;
                        	{'C2_LINHA'		, SC2->C2_LINHA	      , Nil},;
                        	{'C2_MOPC'		, SC2->C2_MOPC	      , Nil},;
                        	{'C2_PMACNUT'	, SC2->C2_PMACNUT	  , Nil},;
                        	{'C2_PMICNUT'	, SC2->C2_PMICNUT	  , Nil},;
                        	{'C2_OBS'		, SC2->C2_OBS		  , Nil},;
                        	{'C2_STATUS'	, SC2->C2_STATUS	  , Nil},;
                        	{'C2_SEGUM'		, SC2->C2_SEGUM	      , Nil},;
                        	{'C2_OPC'		, SC2->C2_OPC		  , Nil},;
                        	{'C2_QTSEGUM'	, SC2->C2_QTSEGUM	  , Nil},;
                        	{'C2_BATORCA'	, "N"		 	      , Nil},;
                        	{'C2_PERDA'		, SC2->C2_PERDA	      , Nil}})

		For i = 1 to len(aEsta650)
			lMsErroAuto    := .F.
			lMsHelpAuto 	:= .T.
			aAreaSC2	   	:= SC2->(GetArea())
			MsExecAuto({|x,y| MATA650(x,y)},aEsta650[i],5/*nOpcX*/)
			RestArea(aAreaSC2)
			lMsHelpAuto	:= .F.
			If lMsErroAuto
				//MostraErro()
				lRet := .F.
			EndIf
		Next

RestArea(aSavArea)

Return lRet
=======
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TOPCONN.CH"
/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � RM04A04  � Autor � MooveGest緌           � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Rotina de reempenho                                        陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Especifico Macom                                           陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                                �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Local aCores         := {}
//Local aEstru         := {}
//Local aCampos        := {}
//Local cPerg          := "M04A04"
Local lInverte 	:= .F.

Private aIndexSC2    := {}
Private cQuerySC2    := ""
Private cFilMarkbSC2 := ""
Private bFiltraSC2
Private cCadastro    := "Reempenho das Ordens de Producao"
Private cMarca 	:= GetMark()

aRotina   := {  { AnsiToOem("Pesquisar" )    ,'AxPesqui'       ,0 , 1 },;
                { AnsiToOem("Visualizar")    ,'U_M04A04VIS()'  ,0 , 2 },;
                { AnsiToOem("Estrutura")     ,'U_M04A04EST()'  ,0 ,3 },;    
                { AnsiToOem("Reempenhar")    ,'U_M04A04EMP()'  ,0 , 3 },;
                { AnsiToOem("Legenda")			,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","O.P. em aberto"},{"BR_VERMELHO","O.P. Produzida ou Encerrada"}})'	,0 , 3 }}

// { AnsiToOem("Empenhos")      ,'U_RESTA01()'    ,0 ,3 },;    

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a tela de parametros da rotina                         �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//ValidPerg(cPerg)
//If !Pergunte(cPerg,.T.)    
//   Return
//Endif
      
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Filtra os registros das OP's de acordo com parametros        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
cQuerySC2    := "C2_FILIAL = '"+xFilial("SC2")+"' "
//If MV_PAR01 == 1
   cQuerySC2 += "AND C2_QUANT > C2_QUJE AND Empty(C2_DATRF)"
//Endif
	
cFilMarkbSC2 := "C2_FILIAL == '"+xFilial("SC2")+"'"
//If MV_PAR01 == 1
   cFilMarkbSC2 += " .AND. C2_QUANT > C2_QUJE .AND. Empty(C2_DATRF)"
//Endif

bFiltraSC2 := {|x| If(x==Nil,FilBrowse("SC2",@aIndexSC2,@cFilMarkbSC2),If(x==1,cFilMarkbSC2,cQuerySC2))}
Eval(bFiltraSC2)
               
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Monta os leds de cores do browse                                       �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Aadd( aCores, { "SC2->C2_QUJE == 0 .AND. Empty(SC2->C2_DATRF)"								, "BR_VERDE"  	})
Aadd( aCores, { "SC2->C2_QUJE > 0 .AND. C2_QUANT > C2_QUJE .AND. Empty(SC2->C2_DATRF)"    	, "BR_AMARELO"	})
Aadd( aCores, { "C2_QUANT <= C2_QUJE .OR. !Empty(SC2->C2_DATRF)"    						, "BR_VERMELHO"	})

DbSelectArea("SC2")
DbSetOrder(1)
                
//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Endereca a funcao de BROWSE                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
MarkBrow("SC2","C2_OK",'C2_QUANT - C2_QUJE = 0',,@lInverte,@cMarca)
//mBrowse(6, 1, 22, 75, "SC2",,,,,3,aCores)

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Retorna indices do SC2                                       �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SC2")
RetIndex("SC2")
dbClearFilter()
aEval(aIndexSC2,{|x| Ferase(x[1]+OrdBagExt())})

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04VIS � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Visualizacao da OP x Empenho                               陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04VIS()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Declaracao de variaveis                                             �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
Local   nOpcE         := 2    //visualizar
Local   nOpcG         := 2    //visualizar
Local _lRet := .F.
Local _ni

Private cOpcao               
Private aHeader       := {}
Private aCols         := {}
Private aCpoEnchoice  := {}

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Monta o array com os campos da Enchoice                             �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC2")
While !Eof() .and. (SX3->X3_ARQUIVO == "SC2")
   If X3USO(x3_usado) .and. cNivel >= x3_nivel
      AADD(aCpoEnchoice, SX3->X3_CAMPO)
   Endif
   DbSelectArea("SX3")
   dbSkip()
Enddo

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Cria variaveis M->????? da Enchoice                                 �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
RegToMemory("SC2",(cOpcao=="VISUALIZAR"))

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Cria aHeader e aCols da GetDados                                    �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
dbSelectArea("SX3")
dbSeek("SD4")
While !Eof().And.(x3_arquivo=="SD4")
   If X3USO(x3_usado) .and. cNivel >= x3_nivel
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                      x3_tamanho, x3_decimal,"AllwaysTrue()",;
                      x3_usado, x3_tipo, x3_arquivo, x3_context} )
      If Alltrim(X3_CAMPO) == "D4_COD"
		 Aadd(aHeader,{ "Descricao", "B1_DESC"/*"B1_CEME"*/, "@!",;
                         50, 0,"AllwaysTrue()",;
                         x3_usado, "C", "SB1", x3_context} )
      Endif                  
   Endif                   
   DbSkip()
Enddo

aCols := {}
DbSelectArea("SD4")
DbSetOrder(2)
If DbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,.F.)
   While !eof() .and. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
      AADD(aCols,Array(Len(aHeader)+1))
      For _ni := 1 to Len(aHeader)
          If aHeader[_ni,2] == "B1_DESC" //"B1_CEME"
             aCols[Len(aCols),_ni] := Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC"/*"B5_CEME"*/)
          Else
             aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
          Endif
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.
      DbSelectArea("SD4")
      DbSkip()
   Enddo
Else   
   If Len(aCols) <= 0
	  aCols := {Array(Len(aHeader)+1)}
	  For _ni:=1 to Len(aHeader)
		  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	  Next
	  aCols[1,Len(aHeader)+1] := .F.
   Endif	  
Endif

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
//� Executa a Modelo 3                                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡�
cTitulo        := "Empenhos da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN
cAliasEnchoice := "SC2"
cAliasGetD     := "SD4"
cLinOk         := "AllwaysTrue()"
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a rotina de Modelo 3                                   �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,999,,1)

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04EST � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Visualizacao da estrutura do produto                       陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04EST()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Private ldbTree    := .F.
Private cInd5      := ''
Private nOpcx := 2
Private l200auto := .F.

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Executa a rotina de visualizacao da estrutura                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SG1")
DbSetOrder(1)
DbSeek(xFilial("SG1")+SC2->C2_PRODUTO)

Pergunte('MTA200', .F.)
a200Proc("SG1",SG1->(RECNO()),2)

DbSelectArea("SC2")

Return

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    蛉04A04EMP � Autor � Marcos Rocha         � Data � 13/01/25  陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Executa o reempenho dos produtos sem lote                  陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
User Function M04A04EMP()

Local lEnd := .F.
Local nOps := 0
Local ni
Local aFilial  := {}

Private aSav650 := Array(20)
Private lConsTerc
Private lConsNPT
Private lProj711  := .F.
Private lMata712  := .F.
Private lPCPA107  := .F.
Private lPCPA113  := .F.
Private lGerouOP  := .T.
Private l650Auto  := .F.
Private lZrHeader := If(l650Auto,.T.,.F.)

If Aviso("Atencao !","Deseja processar o reempenho das OP's marcadas ?",{"Sim","Nao"}) <> 1
	Return
EndIf

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Seleciona as OP's marcadas                                     �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SC2")
_cSelec := "SELECT SC2.R_E_C_N_O_ AS REGISTRO"
_cQuery := " FROM "
_cQuery += RetSqlName("SC2")+" SC2 "
_cQuery += " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"'"
_cQuery += "   AND SC2.C2_OK = '"+cMarca+"'"
_cQuery += "   AND SC2.D_E_L_E_T_ <> '*'"
_cOrder := " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN"

If Select("TRBSC2") > 0
	DbSelectArea("TRBSC2")
	DbCloseArea()
Endif

TCQUERY _cSelec+_cQuery+_cOrder NEW ALIAS "TRBSC2"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Processa as OP's selecionadas                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("TRBSC2")
DbGoTop()
While !EOF()

    DbSelectArea("SC2")
    DbGoTo(TRBSC2->REGISTRO)
    
    //If Aviso("Atencao !","Deseja processar o reempenho da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN+" ?",{"Sim","Nao"}) == 1
    Processa({|| ReempOp()}, "Processando o reempenho da O.P. "+SC2->C2_NUM+"-"+SC2->C2_ITEM+"-"+SC2->C2_SEQUEN+" ...")
    //EndIf

	nOps += 1

	DbSelectArea("SC2")
	RecLock("SC2",.F.)
	SC2->C2_OK     := Space(2)
	SC2->C2_BATCH  := ""  // "S"
	SC2->C2_BATROT := FunName() // With FunName()
	SC2->C2_BATUSR := ""
	MsUnLock()
	
	DbSelectArea("TRBSC2")
	DbSkip()
EndDo

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Finaliza o arquivo temporario                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
If Select("TRBSC2") > 0
	DbSelectArea("TRBSC2")
	DbCloseArea()
Endif

If nOps > 0 //Gera Explos緌 das OP's

	aAdd(aFilial,{cFilAnt,0,xFilial("SC2")})
	Pergunte("MTA650",.F.)
	For ni := 1 to 20
			aSav650[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	lConsNPT  := (aSav650[14] == 1)
	lConsTerc := !(aSav650[15] == 1)

	Processa({|lEnd| MA650Process(@lEnd,nOps)},"Gera誽o de OPs Intermediarias e SCs",OemToAnsi("Gerando OPs Intermediarias e SCs..."),.F.) 	
	lGerouOP  := .F.

	// Criar funcao ou pegar da que usei pra explodir estrutura
	// Ver os casos de Ops com apontamento parcial
	//GeraEmpenho()
EndIf

DbSelectArea("SC2")
Return                                         

/*
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡薩闡闡鐃闡闡闡闡闡膨�
控蚶uno    � REEMPOP  � Autor � Marcos Rocha          � Data � 13/01/25 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡謐闡闡鐘闡闡闡闡闡敢�
控蛇escrio � Executa o reempenho dos produtos sem lote                  陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡敢�
控� Uso      � Macom                                                      陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡棱�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
*/
Static Function REEMPOP()

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Declaracao de variaveis                                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
//Local nOpca			:= 0
//Local nSomaSD4		:= 0
//Local aTravas		:= {}
//Local aArray		:= {}
//Local lLocaliza		:= .F.
//Local lConsVenc 	:= GetMV('MV_LOTVENC') == "S"
//Local lVenc			:= GETMV("MV_LOTVENC") == "S"
//Local cOp       	:= ""

//Local cLocalLote	:= ""
//Local cLocPI 		:= GetMV("MV_LOCPI")
//Local cLocKT 		:= GetMV("MV_LOCKT")
//Local cLoteAnt		:= Criavar("D4_NUMLOTE")
//Local cLotCtlAnt	:= Criavar("D4_LOTECTL")
//Local nQtdAnt		:= 0
//Local cLocal		:= Criavar("D4_LOCAL")

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Salva a area dos arquivos utilizados                           �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
Local aSavArea := GetArea()
Local aSavDC   := SDC->(GetArea())
Local aSavD4   := SD4->(GetArea())
Local aSavB1   := SB1->(GetArea())
Local aSavC2   := SC2->(GetArea())
Local nTotRegs := 0

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Localiza os empenhos da OP                                     �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("SD4")
_cSelec := "SELECT SD4.R_E_C_N_O_ AS REGISTRO, SD4.D4_COD "
_cCount := "SELECT COUNT(*) AS TOTREGS "
_cQuery := " FROM "
_cQuery += RetSqlName("SD4")+" SD4 "
_cQuery += " WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "
_cQuery += "   AND SD4.D4_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "
_cQuery += "   AND SD4.D4_LOTECTL = '' "
_cQuery += "   AND ( SD4.D4_QUANT > 0 OR SD4.D4_QUANT = 0 ) "
_cQuery += "   AND SD4.D_E_L_E_T_ <> '*' "
_cOrder := " ORDER BY SD4.D4_COD"

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY _cCount+_cQuery NEW ALIAS "TRB"

nTotRegs := TRB->TOTREGS

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY _cSelec+_cQuery+_cOrder NEW ALIAS "TRB"

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Processa os empenhos sem lote                                  �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
DbSelectArea("TRB")
DbGotop()                       
ProcRegua(nTotRegs)
While !Eof()

    IncProc("Reempenhando produto "+Alltrim(SD4->D4_COD)+" ...")

	DbSelectArea("SD4")
	DbGoto(TRB->REGISTRO)

	If SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)) .AND. SD4->D4_QUANT > 0
        //矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
        //� Exclui quantidade no Empenho Firme no Local Anterior         �
        //斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
        GravaB2Emp("-",SD4->D4_QUANT,"F")
    EndIf

	RecLock("SD4",.F.)
	DbDelete()
	MsUnlock()

	dbSelectArea("TRB")
	dbSkip()
EndDo

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
//� Restaura a area dos arquivos utilizados                        �
//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
RestArea(aSavArea)
RestArea(aSavDC)
RestArea(aSavD4)
RestArea(aSavB1)
RestArea(aSavC2)

Return


/*/
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
控奼迋迋迋迋迕迋迋迋迋迋豖迋迋迋迕迋迋迋迋迋迋迋迋迋迋冞迋迋迕迋迋迋迋迋迋芼控
控慚un�o    蛄eraEmpenho� Autor � 				      � Data �  13/01/25   滷�
控昅迋迋迋迋阹迋迋迋迋迋虮迋迋迋迍迋迋迋迋迋迋迋迋迋迋庋迋迋迍迋迋迋迋迋迋芧控
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔
/*/
Static Function GeraEmpenho()

Local cProduto  	:= ""
Local nProc

// Usar a Funcao que explode a extrutura
aEstrutura  := {}
BuscaEstru(SC2->C2_PRODUTO,1)

// Ordena por produto para tratar o TRT
aEstrutura := aSort(aEstrutura  ,,, { |x,y| y[1] > x[1]} )

// Grava SD4
cProdAnt := ""
cTRT     := ""
For nProc := 1 To Len(aEstrutura)

	cProduto := aEstrutura[nProc,1]
	nQtd     := aEstrutura[nProc,2]
//		nQtdPerd := aProdChapa[nProc,3]

	If cProdAnt == cProduto
		cTrt  := If(Empty(cTrt),"001",StrZero(Val(cTrt)+1,3))
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)

	dbSelectArea("SD4")
	RecLock("SD4",.T.)
	SD4->D4_FILIAL   := xFilial("SD4")
	SD4->D4_COD      := cProduto
	SD4->D4_LOCAL	:= "99"  //SB1->B1_LOCPAD
	SD4->D4_OP		:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	SD4->D4_DATA 	:= SC2->C2_EMISSAO

	nQtd  :=  nQtd * SC2->C2_QUANT // Confirmar a conta de apontamento parcial
	SD4->D4_QUANT    := nQtd
	SD4->D4_QTDEORI  := nQtd
	SD4->D4_TRT      := cTrt
	SD4->D4_PRODUTO  := SC2->C2_PRODUTO
	MsUnLock()
	
	//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
	//彪ria o SB2 se ele nao existir                                             �
	//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
	CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD) //U_CriaSB2Esp(SB1->B1_COD,SB1->B1_LOCPAD)

	cProdAnt := cProduto
Next

return

/*/
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
控奼迋迋迋迋迕迋迋迋迋迋冞迋迋迋敊迋迋迋迋迋迋迋迋迋豖迋迋迋敊迋迋迋迋迋迋跼�
控慚un�o    處uscaEStru� Autor � 				     � Data �  13/01/25   滷�
控昅迋迋迋迋阹迋迋迋迋迋庋迋迋迋玵迋迋迋迋迋迋迋迋迋虮迋迋迋玵迋迋迋迋迋迋僚�
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控�
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔�
/*/
Static Function BuscaEStru(cProduto,nQtdBase)

Local aArea   := GetArea()
Local nRecSG1 := 0

//	aProdutos  := {}

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)
While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

	//矬闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡醴
	//� Desconsidera somente itens vencidos , sem opcionais ou fora  �
	//� da revisao atual.                                            �
	//斂闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁
	//If QtdComp(nQuantItem) != QtdComp(0)
	//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
	//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
	//	nCusTot := nCusTot + (nQuantItem * nCusto)
	//EndIf

	// Tratar a Validade da Estrutura
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

	//dbSelectArea("SB1")
	//dbSeek(xFilial("SB1")+SG1->G1_COD)
//		nQuant := SG1->G1_QUANT

	nQuant :=  (SG1->G1_QUANT / (100 - SG1->G1_PERDA )) * 100 
	nQuant :=  nQuant * nQtdBase 

	Aadd(aEstrutura,{SG1->G1_COMP,nQuant,cNivel})

	nRecSG1 := SG1->(Recno())
	cComp := SG1->G1_COMP
	If dbSeek(xFilial("SG1")+cComp)
		BuscaEstru(cComp,nQuant)
	EndIf
	dbGoto(nRecSG1)

	dbSelectArea("SG1")	
	dbSkip()
EndDo

RestArea(aArea)

Return
