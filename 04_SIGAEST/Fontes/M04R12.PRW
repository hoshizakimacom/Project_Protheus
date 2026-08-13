#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "AP5MAIL.CH"

/*
=====================================================================================
|Programa: M04R12      |Autor: MONTES - MOOVEGESTÃO            |Data: 03/10/2024    |
=====================================================================================
|Descrição: Resumo de Estrutura por Custo Standard                                  |
|                                                                                   |
=====================================================================================
|CONTROLE DE ALTERACOES:                                                            |
=====================================================================================
|Programador          |Data       |DescriÃ§Ã£o                                      |
=====================================================================================
|                     |           |                                                 |
|                     |           |                                                 |
=====================================================================================
*/
User Function M04R12()

Private aPergs     := {}
Private cTitulo    := "Resumo Estrutura por Custo Standard"
Private aRetPar    := {}

Aadd(aPergs, {1, "Produto De"             ,REPLICATE(' ',TAMSX3("B1_COD")[1]) ,"@X","","SB1","",60,.F.})      //1
Aadd(aPergs, {1, "Produto Ate"            ,REPLICATE('Z',TAMSX3("B1_COD")[1]) ,"@X","","SB1","",60,.T.})      //2
Aadd(aPergs, {1, "Tipo De"                ,REPLICATE(' ',TAMSX3("B1_TIPO")[1]),"@X","","02 ","",60,.F.})      //3
Aadd(aPergs, {1, "Tipo Ate  "             ,REPLICATE('Z',TAMSX3("B1_TIPO")[1]),"@X","","02 ","",60,.T.})      //4
Aadd(aPergs, {2, "Tipo de Relatorio"      ,"1",{"1=Sintetico","2=Analitico"},80,".T.",.F.})                   //5
Aadd(aPergs, {2, "Considera Bloqueados ?" ,"2",{"1=Sim","2=Não"},80,".T.",.F.})                               //6

If ParamBox(aPergs, cTitulo, @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)
   Processa( {|| GeraExcel() }, "Gerando Extração dos dados.." )
EndIf

Return Nil

///////////////////////////////////////////////////////////
Static Function GeraExcel(dDataIni,dDataFim,cPathUser)

Local aArea     := GetArea()
Local cPath     := AllTrim(GetTempPath())
Local cArquivo  := "ESTRUTURA_CSTSTD"
Local cQuery   := "" 

Private oExcel     := Nil
Private cSheet     := ""
Private cTable     := ""
Private oExcelView := Nil

cSheet   := "Produtos"
cTable   := "Resumo Estrutura por Custo Std - "+IIF(aRetPar[5]=="1","Sintetico","Analitico")

cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, NIVEL ) AS "+CRLF
cQuery += "( "+CRLF

	cQuery += "SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, 1 AS NIVEL "+CRLF
	cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = G1_COMP AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "WHERE SG1.D_E_L_E_T_ = '' "+CRLF
	cQuery += "AND SG1.G1_FILIAL      = '"+xFilial("SG1")+"' " +CRLF
   If aRetPar[6]=="2" //Não Considera Produtos Bloqueados
      cQuery += "AND SB1.B1_MSBLQL <> '1' "+CRLF
   EndIf
   cQuery += "AND SB1.B1_REVATU BETWEEN G1_REVINI AND G1_REVFIM "+CRLF

	cQuery += "UNION ALL "+CRLF

	cQuery += "SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1 "+CRLF
	cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = G1_COD AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "INNER JOIN ESTRUT EST "+CRLF
	cQuery += "ON SG1.G1_COD = COD_COMP "+CRLF
	cQuery += "WHERE SG1.D_E_L_E_T_ = '' "+CRLF
	cQuery += "AND SG1.G1_FILIAL = '"+xFilial("SG1")+"' "+CRLF
   If aRetPar[6]=="2" //Não Considera Produtos Bloqueados
      cQuery += "AND SB1.B1_MSBLQL <> '1' "+CRLF
   EndIf
   cQuery += "AND SB1.B1_REVATU BETWEEN G1_REVINI AND G1_REVFIM "+CRLF

cQuery += ") "+CRLF

cQuery += "SELECT CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, NIVEL, SB1COMP.B1_TIPO TIPO_COMP, SB1COMP.B1_CUSTD CUSTD, SB1.B1_DESC, SB1COMP.B1_DESC DESCCOMP "+CRLF
cQuery += "FROM ESTRUT G1 "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = G1.CODIGO AND SB1.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1COMP ON SB1COMP.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1COMP.B1_COD = G1.COD_COMP AND SB1COMP.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "WHERE G1.CODIGO BETWEEN '"+aRetPar[1]+"' AND '"+aRetPar[2]+"' "+CRLF
cQuery += "AND SB1.B1_TIPO BETWEEN '"+aRetPar[3]+"' AND '"+aRetPar[4]+"' "+CRLF
//cQuery += "AND G1.DT_FIM >= '20471231' "+CRLF
cQuery += "ORDER BY SB1.B1_TIPO,G1.CODIGO,G1.COD_COMP "+CRLF

If Select("QRYTMP") > 0
	dbSelectArea("QRYTMP")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "QRYTMP"

dbSelectarea("QRYTMP")
dbGoTop()
nLastRec := 0
nRecTot := 0
dbEval({||nLastRec+=1})
dbGoTop()

ProcRegua(nLastRec)

oExcel := FwMsExcelXlsx():New()

oExcel:AddworkSheet(cSheet)
oExcel:AddTable(cSheet,cTable)

//nAlign	Numï¿½rico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )
//nFormat	Numï¿½rico	Codigo de formataï¿½ï¿½o ( 1-General,2-Number,3-Monetï¿½rio,4-DateTime )
//lTotal	LÃ³gico	    Indica se a coluna deve ser totalizada
oExcel:AddColumn(cSheet,cTable,"PRODUTO",1,1)                       //1-PRODUTO
oExcel:AddColumn(cSheet,cTable,"DESCRICÃO",1,1)                     //2-DESCRIÇÃO
oExcel:AddColumn(cSheet,cTable,"CUSTO TOTAL",3,2)                   //3-CUSTO TOTAL
oExcel:AddColumn(cSheet,cTable,"VALOR MP",3,2)                      //4-VALOR MP
oExcel:AddColumn(cSheet,cTable,"VALOR M.O.TOTAL",3,2,.T.)           //5-VALOR M.O.	
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.CPC",3,2,.T.)               //6-VLR.M.O.CPC	
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.CPC",3,2,.T.)               //7-HOR.M.O.CPC	
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.MOB",3,2,.T.)               //8-VLR.M.O.MOB	
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.MOB",3,2,.T.)               //9-HOR.M.O.MOB	
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.REF",3,2,.T.)               //10-VLR.M.O.REF	
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.REF",3,2,.T.)               //11-HOR.M.O.REF	
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.COC",3,2,.T.)               //12-VLR.M.O.COC
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.COC",3,2,.T.)               //13-HOR.M.O.COC
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.EMB",3,2,.T.)               //14-VLR.M.O.EMB
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.EMB",3,2,.T.)               //15-HOR.M.O.EMB
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.SUB-COC",3,2,.T.)           //16-VLR.M.O.SUB-COC
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.SUB-COC",3,2,.T.)           //17-HOR.M.O.SUB-COC
oExcel:AddColumn(cSheet,cTable,"VLR.M.O.SUB-REF",3,2,.T.)           //18-VLR.M.O.SUB-REF
oExcel:AddColumn(cSheet,cTable,"HOR.M.O.SUB-REF",3,2,.T.)           //19-HOR.M.O.SUB-REF
If aRetPar[5] == "2" //Analitico
   oExcel:AddColumn(cSheet,cTable,"COMPONENTE",1,1)                    //20-COMPONENTE
   oExcel:AddColumn(cSheet,cTable,"DESC.COMP.",1,1)                    //21-DESCRIÇÃO DO COMPONENTE
   oExcel:AddColumn(cSheet,cTable,"TIPO COMPONENTE",1,1)               //22-TIPO DO COMPONENTE
   oExcel:AddColumn(cSheet,cTable,"VALOR COMP",3,2)                    //23-VALOR COMPONENTE
   oExcel:AddColumn(cSheet,cTable,"HORAS COMP",3,2)                    //24-HORAS COMPONENTE
EndIf

nReg := 0

While !EOF()

   cProduto := QRYTMP->CODIGO
   aValores := {QRYTMP->CODIGO,QRYTMP->B1_DESC,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

   While !EOF() .And. QRYTMP->CODIGO == cProduto

      nReg += 1
      nRecTot +=  1
      IncProc("Processando registros..."+ALLTRIM(STR(nRecTot)))

      nQuant := QRYTMP->(QTD/(1-(PERDA/100)))

      If QRYTMP->TIPO_COMP $ "MP|MI|EM|SB|MF|MC"

         aValores[3] += ROUND( nQuant * QRYTMP->CUSTD ,2)

      ElseIf QRYTMP->TIPO_COMP == "MO"

         aValores[4] += ROUND( nQuant * QRYTMP->CUSTD ,2)

         If QRYTMP->COD_COMP == "MO-CPC         "

            aValores[5] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[6] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP = "MO-MOB         "

            aValores[7] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[8] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP == "MO-REF         "

            aValores[9] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[10] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP == "MO-COC         "

            aValores[11] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[12] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP == "MO-EMB         "

            aValores[13] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[14] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP == "MO-SUB-COC     "

            aValores[15] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[16] += ROUND( nQuant ,2)

         ElseIf QRYTMP->COD_COMP == "MO-SUB-REF     "

            aValores[17] += ROUND( nQuant * QRYTMP->CUSTD ,2)
            aValores[18] += ROUND( nQuant ,2)

         EndIf

      EndIf

      If aRetPar[5] == "2" //Analitico
         aColuna := {;
            aValores[1],;                                        //1
            aValores[2],;                                        //2
            '',;                                                 //3
            '',;                                                 //4
            '',;                                                 //5
            '',;                                                 //6
            '',;                                                 //7
            '',;                                                 //8
            '',;                                                 //9
            '',;                                                 //10
            '',;                                                 //11
            '',;                                                //12
            '',;                                                //13
            '',;                                                //14
            '',;                                                //15
            '',;                                                //16
            '',;                                                //17
            '',;                                                //18
            '';                                                 //19
            }
         AADD(aColuna, QRYTMP->COD_COMP)                     //20
         AADD(aColuna, QRYTMP->DESCCOMP)              //21
         AADD(aColuna, QRYTMP->TIPO_COMP)                    //22
         AADD(aColuna, ROUND( nQuant * QRYTMP->CUSTD ,2))                    //23
         AADD(aColuna, ROUND( nQuant ,2))                    //24

         oExcel:AddRow(cSheet,cTable,aColuna)
      EndIf

      dbSkip()
   EndDo

   aColuna := {;
            aValores[1],;                                                 //1
            aValores[2],;                                                 //2
            (aValores[3]+aValores[4]),;                                   //3
            aValores[3],;                                                 //4
            aValores[4],;                                                 //5
            aValores[5],;                                                 //6
            aValores[6],;                                                 //7
            aValores[7],;                                                 //8
            aValores[8],;                                                 //9
            aValores[9],;                                                 //10
            aValores[10],;                                                //11
            aValores[11],;                                                //12
            aValores[12],;                                                //13
            aValores[13],;                                                //14
            aValores[14],;                                                //15
            aValores[15],;                                                //16
            aValores[16],;                                                //17
            aValores[17],;                                                //18
            aValores[18];                                                 //19
            }
   If aRetPar[5] == "2" //Analitico
      AADD(aColuna, 'TOTAL')               //20
      AADD(aColuna, '')                    //21
      AADD(aColuna, '')                    //22
      AADD(aColuna, '')                    //23
      AADD(aColuna, '')                    //24
   EndIf

   oExcel:AddRow(cSheet,cTable,aColuna)

EndDo

dbSelectArea("QRYTMP")
dbCloseArea()

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo+".XLSX")
oExcel:DeActivate()

//Abrindo o excel e abrindo o arquivo xml
If GetRemoteType() == 1
   oExcelView := MsExcel():New() //Abre uma nova conexão com Excel
   oExcelView:WorkBooks:Open(cPath+cArquivo+".XLSX") //Abre uma planilha
   oExcelView:SetVisible(.T.) //Visualiza a planilha
   oExcelView:Destroy() //Encerra o processo do gerenciador de tarefas
EndIf

RestArea(aArea)

Return Nil
