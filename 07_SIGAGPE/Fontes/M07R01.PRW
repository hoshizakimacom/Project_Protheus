#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#include "Fileio.ch"
 /*
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Programa  |M07R01      |Autor | VALDEMIR MIRANDA  | Data |  04/03/2023  ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Desc.     | Relatório de Absenteismo                                    ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Uso       | FOLHA DE PAGAMENTO / RECUSRSOS HUMANOS                      ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Será utilizado as Verbas 420-Horas de Faltas e 421-Horas de Atrasos     ||
//|| Criado por Valdemir M. Nascimento em 04/03/2023                         ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/    
USER Function M07R01() 

Private lEnd      := .F.
Private nLastKey  := 0
Private lPerg     := lTemreg :=.f.
Private cAliasSPH :=""
Private cAliasSPC :=""
Private cPlanilha := "Abssenteismo"  // *** Nome da Pasta que sera' criada no arquivo Excel               *** //
Private cTabela   := "Relatorio de Abssenteismo"  // *** Nome do Titulo do Relatorio que sera' criado no arquivo Excel *** //
Private aCabecEx  :={}             // *** Vetor que armazenara' o Cabecalho do Arquivo Excel            *** //
Private aLinha    :={}             // *** Vetor que armazenara' a Linha Delhalhe do arquivo Excel       *** //
Private aLinQtd   :={}
Private cAlfabeto :="a/A/b/B/c/C/d/D/e/E/f/F/g/G/h/H/i/I/j/J/k/K/l/L/m/M/n/N/o/O/p/P/q/Q/r/R/s/S/t/T/u/U/v/V/w/W/x/X/y/Y/z/Z"

// ... Inicializa Parametros ...     
If lPerg ==.F.
   PARGPER001()  
Endif        

// ...
lParametro:=Pergunte("M07R0001",.T.)

If !lParametro
	Return
EndIf
lPerg:=.t.

If nLastKey == 27
	Set Filter to
	Return
Endif   
             
Processa({||RELM07R01()}, "Relatório de Absenteísmo "+time() )   

Return 

/*
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Programa  |PARGPER001  |Autor | VALDEMIR MIRANDA  | Data |  12/04/2021  ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Desc.     | Parâmetros do Relatório de Absenteísmo                      ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/ 
Static Function  PARGPER001() 

Local _sAlias := Alias()
Local cPerg := PADR("M07R0001",10)
Local aRegs :={}                       
Local nX  

lPerg  :=lTemreg :=.t. 
aAdd(aRegs,{"Filial De ?"       ,"¨Forneced. De?","From Bank ?" ,"mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial Ate ?"      ,"¨Forneced.Ate?","From Bank ?" ,"mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"Dt. de Pagto De ?" ,"¨Dt. de Pagto?","Dt.de Pagto?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{"Dt. de Pagto Até?" ,"¨Dt. de Pagto?","Dt.de Pagto?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{"C.de Custo De ?"   ,"¨Forneced. De?","From Bank ?" ,"mv_ch5","C",9,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.de Custo Ate ?"  ,"¨Forneced.Ate?","From Bank ?" ,"mv_ch6","C",9,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Matricula De ?"    ,"¨Forneced. De?","From Bank ?" ,"mv_ch7","C",6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula Ate ?"   ,"¨Forneced.Ate?","From Bank ?" ,"mv_ch8","C",6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})   
aAdd(aRegs,{"Situação do Func ?","¨Categoria   ?","Categoria ?" ,"mv_ch9","C",30,0,0,"G","fSituacao","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})   
aAdd(aRegs,{"Categoria ?"       ,"¨Categoria   ?","Categoria ?" ,"mv_cha","C",30,0,0,"G","fCategoria","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})   

dbSelectArea("SX1")
dbSetOrder(1) 
For nX:=1 to Len(aRegs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO	   with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace x1_pergunt 	with aRegs[nx][01]
		Replace x1_perspa	   with aRegs[nx][02]
		Replace x1_pereng	   with aRegs[nx][03]
		Replace x1_variavl	with aRegs[nx][04]
		Replace x1_tipo		with aRegs[nx][05]
		Replace x1_tamanho	with aRegs[nx][06]
		Replace x1_decimal	with aRegs[nx][07]
		Replace x1_presel	   with aRegs[nx][08]
		Replace x1_gsc		   with aRegs[nx][09]
		Replace x1_valid	   with aRegs[nx][10]
		Replace x1_var01	   with aRegs[nx][11]
		Replace x1_def01	   with aRegs[nx][12]
		Replace x1_defspa1	with aRegs[nx][13]
		Replace x1_defeng1	with aRegs[nx][14]
		Replace x1_cnt01	   with aRegs[nx][15]
		Replace x1_var02	   with aRegs[nx][16]
		Replace x1_def02	   with aRegs[nx][17]
		Replace x1_defspa2	with aRegs[nx][18]
		Replace x1_defeng2	with aRegs[nx][19]
		Replace x1_cnt02  	with aRegs[nx][20]
		Replace x1_var03	   with aRegs[nx][21]
		Replace x1_def03	   with aRegs[nx][22]
		Replace x1_defspa3	with aRegs[nx][23]
		Replace x1_defeng3	with aRegs[nx][24]
		Replace x1_cnt03  	with aRegs[nx][25]
		Replace x1_var04	   with aRegs[nx][26]
		Replace x1_def04   	with aRegs[nx][27]
		Replace x1_defspa4	with aRegs[nx][28]
		Replace x1_defeng4	with aRegs[nx][29]
		Replace x1_cnt04  	with aRegs[nx][30]
		Replace x1_var05	   with aRegs[nx][31]
		Replace x1_def05   	with aRegs[nx][32]
		Replace x1_defspa5	with aRegs[nx][33]
		Replace x1_defeng5	with aRegs[nx][34]
		Replace x1_cnt05  	with aRegs[nx][35]
		Replace x1_f3     	with aRegs[nx][36]
		Replace x1_grpsxg 	with aRegs[nx][37]
		MsUnlock() 
		Dbunlock()
	Endif
Next nX
dbSelectArea(_sAlias)
   
Return 

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |NEOGPR001  |Autor | VALDEMIR MIRANDA  | Data |  12/04/2021  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Processo de Geração do Relatório de Absenteísmo             ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function RELM07R01()

// *** Definição de Variáveis *** //
Local ix1           :=0
Local wxprimvxyz    :=0
Local nCont         :=0
Local nDias         :=0
Private nQtdDUteis  :=0
Private dData       :=CTOD("")
Private csituacao1  :=""
Private cxcategoria :=""
Private XMES        :=MONTH(DDATABASE)
Private Meses       :={{"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}}
Private wxhorax     :=LEFT(TIME(),2)+"_"+SUBSTR(TIME(),4,2)+"_"+SUBSTR(TIME(),7,2) 
Private WDATAEXT    :=SUBSTR(DTOC(DDATABASE),1,2)+" DE "+MESES[1][XMES] +" DE "+SUBSTR(DTOS(DDATABASE),1,4)
Private cxEventos   :=GetMV("AM_EVEPONT")
Private cxVerbasx   :=""
Private wopx1       :=""
Private nQtdHoras   :=0
Private nQtdFunc    :=0
Private nqtdHsPre   :=0
Private nHsPerdidas :=0
Private nPercent1   :=0
Private nQtdNaoTr   :=0 
Private cQuebraMat  :=""
Private cMatx1      :=""
    
// *** Prepara Variavel com Situação do Funcionário *** //
for ix1:=1 to len(mv_par09)
    if substr(mv_par08,ix1,1)<>"*" 
       if wxprimvxyz = 0
          wopx1:=wopx1+substr(mv_par09,ix1,1)+"/" 
          wxprimvxyz:=1
       else
          if substr(mv_par08,ix1,1) <> " " .and. substr(mv_par09,ix1,1) <> "*" 
             wopx1:=wopx1+substr(mv_par09,ix1,1)+"/" 
          endif
       endif
    endif
next ix1                                                                 
wxsituacao:= wopx1   

// *** Prepara Variavel com Categoria do Funcionário *** //
wopx1:="" 
wxprimvxyz:=0
for ix1:=1 to len(mv_par10)
    if substr(mv_par10,ix1,1)<>"*" 
       if wxprimvxyz = 0
          wopx1:=wopx1+substr(mv_par10,ix1,1)+"/" 
          wxprimvxyz:=1
       else
          if substr(mv_par09,ix1,1) <> " " .and. substr(mv_par10,ix1,1) <> "*" 
             wopx1:=wopx1+substr(mv_par10,ix1,1)+"/" 
          endif
       endif
    endif
next ix1 
wxcategoria:=wopx1

// *** Prepara Lista de Campos do Relatorio *** //'      
aadd(aCabecEx,"Filial")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Matricula")
aadd(aCabecEx,"Nome")
aadd(aCabecEx,"Dt.Marcacao")
aadd(aCabecEx,"Centro de custo")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Turno Trab.")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Cod.Evento")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Codigo Verba")
aadd(aCabecEx,"Qtd.Calculada")
aadd(aCabecEx,"Qtd.Informada")
aadd(aCabecEx,"Motivo Abono")
aadd(aCabecEx,"Qtd.Abonada")

// *** Acessa função de Captura de Informações da Tabela de Histórico de Apontamentos *** //
MtQuerySPH()

// *** Acessa função de Captura de Informações da Tabela de Apontamentos *** //
MtQuerySPC()

// *** Calcula a Quantidade de Dias Uteis *** //
nDias      :=val(left(DTOC(LastDate(MV_PAR03)),2))
nQtdDUteis :=0
nQtdNaoTrab:=0 
dData     :=mv_par03
For nCont:=1 to nDias
     
   // ***  Sabado     -      Domingo  *** //
   If dow(dData)== 1 .or. dow(dData)== 7 
      nQtdDUteis+=1
   else
      nQtdNaoTrab+=1
   EndIf
   dData:=dData+1
Next

// *** Calcula quantidade de Funcionários que Tiveram Apontamntos *** //
nQtdFunc:=0
SQtdRgt()

// *** Monta Linha em Branco *** //
aadd(aLinha,{" "," "," "," " ,""," ",;
      " "," "," "," "," ",;
      " "," "," "," "," "}) 

// *** Monta Linha de Totalizações *** //
nHorasTrab:=8.45
nqtdHsPre := (((nHorasTrab * nQtdFunc) * nQtdNaoTrab))
nPercent1 := ROUND(((nHsPerdidas / nqtdHsPre)*100),2)
aadd(aLinha,{"Quantidade de Funcionários: ",nQtdFunc," ","Quabtidade de Dias Uteis:" ,nQtdNaoTrab," ",;
      "Horas Previstas:",nqtdHsPre," ","Horas Perdidas",nHsPerdidas,;
      " "," ","% Absenteismo: ",(alltrim(str(nPercent1)))," "}) 

// *** Imprime Documento em Planilha Excel *** //
if len(aLinha) > 0
  
   cTabela:=cTabela+" do Periodo de "+dtoc(mv_par03)+" à "+dtoc(mv_par04)
   cTipArq:="XML" // *** Tipo de Arquivo (XML, CSV ou TXT) *** //
   U_GERAEXCELN(cPlanilha,cTabela,aCabecEx,aLinha,cTipArq)

endif

Return(.T.)

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MontQrySPH  |Autor |Valdemir Miranda                  | Data | 03/03/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Geracao de Query de Processamento da tabela SPH-Historico de Apontamentos||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MtQuerySPH()

Local nTotal := 0

// ***
cQuery := "SELECT SPH.PH_FILIAL,SPH.PH_MAT,SPH.PH_DATA,SPH.PH_PD,SPH.PH_CC,SRA.RA_NOME,SPH.PH_TURNO,SPH.PH_QUANTC,SPH.PH_QUANTI,SPH.PH_QTABONO,SPH.PH_ABONO, "
cQuery += " SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_CC,SRA.RA_SITFOLH,SRA.RA_CATFUNC,CTT.CTT_CUSTO,CTT.CTT_DESC01,  SR6.R6_TURNO,SR6.R6_DESC "
cQuery += " FROM " + RetSqlName("SPH") + " SPH "

cQuery += " INNER JOIN "+ RetSqlName("SRA") + " SRA " 
cQuery += " ON SRA.D_E_L_E_T_ = ' '  AND SRA.RA_FILIAL = SPH.PH_FILIAL  AND SRA.RA_MAT = SPH.PH_MAT "

cQuery += " INNER JOIN "+ RetSqlName("CTT") + " CTT "
cQuery += " ON CTT.D_E_L_E_T_ = ' '  AND CTT.CTT_CUSTO = SPH.PH_CC "

cQuery += " INNER JOIN "+ RetSqlName("SR6") + " SR6 "
cQuery += " ON SR6.D_E_L_E_T_ = ' '  AND SR6.R6_TURNO = SPH.PH_TURNO  "

cQuery += " WHERE SPH.PH_FILIAL BETWEEN '"+left(mv_par01,2)+"' AND '"+left(MV_PAR02,2)+"' " 
cQuery += " AND SPH.PH_DATA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(MV_PAR04)+"' "
cQuery += " AND SPH.PH_CC BETWEEN '"+mv_par05+"' AND '"+MV_PAR06+"' "

cQuery += " AND SPH.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SPH.PH_FILIAL,SPH.PH_MAT,SPH.PH_DATA,SPH.PH_PD,SPH.PH_CC ASC "

// ***
cAliasSPH:= GetNextAlias() 
If Select(cAliasSPH) > 0
   dbSelectArea(cAliasSPH)
   dbCloseArea()
EndIf
 
// *** Abre Tabelas *** //
cQry3=ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry3), cAliasSPH, .F., .T.)

// *** Pega Quantidade de Registros para ProcRegua *** //
dbSelectArea(cAliasSPH) 
dbGotop()
While !Eof()
   nTotal := Recno()

   dbskip()
EndDo

// *** Captura Chave *** //
dbSelectArea(cAliasSPH)
ProcRegua(nTotal)
dbGoTop()   
   
// *** Prepara Vetor com Informações do Histórico de Apontamentos *** //
nQtdNaoTrab:=0 
nQtdHoras  :=0
nQtdFunc   :=0
cMatx1     :=""

// ***
While !Eof()

   // *** Verifica se a Matricula Existe *** //
   cProcessa:="S"
   If !Empty(mv_par07)
      cProcessa:="N"
   EndIf

   if substr(MV_PAR08,1,1) = "Z" .or. substr(MV_PAR08,1,1) ="z"
      cProcessa:="N"
   else 
      cProcessa:="S"
   endif

   // *** Situação do Colaborador *** //
    cAtualiza:="S"
   if (cAliasSPH)->RA_SITFOLH $wxsituacao
      cAtualiza:="S"
   else
      cAtualiza:="N"
   endif

   // *** Categoria do Colaborador *** //
   if (cAliasSPH)->RA_CATFUNC $wxcategoria .and. cAtualiza == "S"
      cAtualiza:="S"
   else
      cAtualiza:="N"
   endif

   // ***
   if cProcessa = "S"
      IF cAtualiza == "S"
         if (cAliasSPH)->PH_MAT >= mv_par07 .and. (cAliasSPH)->PH_MAT <= mv_par08  
            cAtualiza:="S"
         else
            cAtualiza:="N"
         endif
      ENDIF
   endif

   // *** 
   cMatx1:=""
   if cAtualiza == "S" .and. (cAliasSPH)->PH_PD $cxEventos
      dbSelectArea(cAliasSPH) 
      cFilName := FWFilialName()
      IncProc("Documento: " + (cAliasSPH)->PH_FILIAL+"-"+alltrim(cFilName)+" - "+(cAliasSPH)->PH_MAT+" - "+alltrim((cAliasSPH)->RA_NOME ))
  
      // ***
      cDatax:=DTOC(STOD((cAliasSPH)->PH_DATA))
      cDescEven:= Posicione("SP9",1,xFilial("SP9")+(cAliasSPH)->PH_PD,"P9_DESC") 
      cCodVerba:= Posicione("SP9",1,xFilial("SP9")+(cAliasSPH)->PH_PD,"P9_CODFOL") 
      nQtdHoras:=nQtdHoras+(cAliasSPH)->PH_QUANTC
      nQtdNaoTr:=nQtdNaoTr+(cAliasSPH)->PH_QUANTI
      nHsPerdidas:=nHsPerdidas+(cAliasSPH)->PH_QUANTC

      aadd(aLinha,{(cAliasSPH)->PH_FILIAL,cFilName,(cAliasSPH)->PH_MAT,(cAliasSPH)->RA_NOME,cDatax,(cAliasSPH)->RA_CC,;
      (cAliasSPH)->CTT_DESC01,(cAliasSPH)->R6_TURNO,(cAliasSPH)->R6_DESC,(cAliasSPH)->PH_PD,cDescEven,;
      cCodVerba,(cAliasSPH)->PH_QUANTC,(cAliasSPH)->PH_QUANTI,(cAliasSPH)->PH_ABONO,(cAliasSPH)->PH_QTABONO})    

      // *** Quantidade de Funcionários *** //
      cMatx1:=(cAliasSPH)->PH_FILIAL + (cAliasSPH)->PH_MAT
      
   endif

   // ***
   dbSelectArea(cAliasSPH) 
   dbSkip()
EndDo

// *** Fecha Query de Histórico de Apontamentos *** //
dbSelectArea(cAliasSPH) 
dbCloseArea()

Return(.T.)


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MontQrySPC  |Autor |Valdemir Miranda                  | Data | 04/03/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Geracao de Query de Processamento da tabela SPC-Apontamentos             ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MtQuerySPC()

Local nTotal := 0

cQuery := "SELECT SPC.PC_FILIAL,SPC.PC_MAT,SPC.PC_DATA,SRA.RA_NOME,SPC.PC_PD,SPC.PC_CC,SPC.PC_TURNO,SPC.PC_QUANTC,SPC.PC_QUANTI,SPC.PC_QTABONO,SPC.PC_ABONO,SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_CC,SRA.RA_SITFOLH,SRA.RA_CATFUNC,CTT.CTT_CUSTO,CTT.CTT_DESC01, "
cQuery += " SR6.R6_TURNO,SR6.R6_DESC "
cQuery += " FROM " + RetSqlName("SPC") + " SPC "

cQuery += " INNER JOIN "+ RetSqlName("SRA") + " SRA "
cQuery += " ON SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_FILIAL = SPC.PC_FILIAL "
cQuery += " AND SRA.RA_MAT = SPC.PC_MAT "

cQuery += " INNER JOIN "+ RetSqlName("CTT") + " CTT "
cQuery += " ON CTT.D_E_L_E_T_ = ' ' "
cQuery += " AND CTT.CTT_CUSTO = SPC.PC_CC "

cQuery += " INNER JOIN "+ RetSqlName("SR6") + " SR6 "
cQuery += " ON SR6.D_E_L_E_T_ = ' ' "
cQuery += " AND SR6.R6_TURNO = SPC.PC_TURNO "

cQuery += " WHERE SPC.PC_FILIAL BETWEEN '"+left(mv_par01,2)+"' AND '"+left(MV_PAR02,2)+"' " 
cQuery += " AND SPC.PC_DATA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(MV_PAR04)+"' "
cQuery += " AND SPC.PC_CC BETWEEN '"+mv_par05+"' AND '"+MV_PAR06+"' "
cQuery += " AND SPC.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SPC.PC_FILIAL,SPC.PC_MAT,SPC.PC_DATA,SPC.PC_PD,SPC.PC_CC ASC "

cAliasSPC:= GetNextAlias() 
If Select(cAliasSPC) > 0
   dbSelectArea(cAliasSPC)
   dbCloseArea()
EndIf
 
// *** Abre Tabelas *** //
cQry3=ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry3), cAliasSPC, .F., .T.)

// *** Pega Quantidade de Registros para ProcRegua *** //
dbSelectArea(cAliasSPC) 
dbGotop()
While !Eof()
   nTotal := Recno()
   dbskip()
enddo

nQtdNaoTrab:=0 
nQtdHoras  :=0
cMatx1     :=""

// *** Captura Chave *** //
dbSelectArea(cAliasSPC) 
ProcRegua(nTotal)
dbGoTop()   
   
// *** Prepara Vetor com Informações do Histórico de Apontamentos *** //
cMatx1:=""
While !Eof()

   // *** Verifica se a Matricula Existe *** //
   cProcessa:="S"
   if .not. empty(mv_par07)
      cProcessa:="N"
   endif

   if substr(MV_PAR08,1,1) = "Z" .or. substr(MV_PAR08,1,1) ="z"
      cProcessa:="N"
   else 
      cProcessa:="S"
   endif

   // ***
   cAtualiza:="S"

   // *** Situação do Colaborador *** //
   if (cAliasSPC)->RA_SITFOLH $wxsituacao
      cAtualiza:="S"
   else
      cAtualiza:="N"
   endif

   // *** Categoria do Colaborador *** //
   if (cAliasSPC)->RA_CATFUNC $wxcategoria
      cAtualiza:="S"
   else
      cAtualiza:="N"
   endif

   // ***
   if cProcessa = "S"
      if (cAliasSPC)->PC_MAT >= mv_par07 .and. (cAliasSPC)->PC_MAT <= mv_par08  
         cAtualiza:="S"
      else
         cAtualiza:="N"
      endif
   endif

   cMatx1:=""
   if cAtualiza == "S" .and. (cAliasSPC)->PC_PD $cxEventos

      // ***
      cFilName := FWFilialName()
      IncProc("Documento: " + (cAliasSPC)->PC_FILIAL+"-"+alltrim(cFilName)+" - "+(cAliasSPC)->PC_MAT+" - "+alltrim((cAliasSPC)->RA_NOME))
  
      // ***
      cDatax:=DTOC(STOD((cAliasSPC)->PC_DATA))
      cDescEven:= Posicione("SRV",1,xFilial("SRV")+(cAliasSPC)->PC_PD,"RV_DESC") 
      cDescEven:= Posicione("SP9",1,xFilial("SP9")+(cAliasSPC)->PC_PD,"P9_DESC") 
      cCodVerba:= Posicione("SP9",1,xFilial("SP9")+(cAliasSPC)->PC_PD,"P9_CODFOL")
      nHsPerdidas:=nHsPerdidas+(cAliasSPC)->PC_QUANTC
      nQtdHoras  :=nQtdHoras+(cAliasSPC)->PC_QUANTC
      nQtdNaoTr  :=nQtdNaoTr+(cAliasSPC)->PC_QUANTI
      nHsPerdidas:=nHsPerdidas+(cAliasSPC)->PC_QUANTC

      aadd(aLinha,{(cAliasSPC)->PC_FILIAL,cFilName,(cAliasSPC)->PC_MAT,(cAliasSPC)->RA_NOME,cDatax,(cAliasSPC)->RA_CC,;
      (cAliasSPC)->CTT_DESC01,(cAliasSPC)->R6_TURNO,(cAliasSPC)->R6_DESC,(cAliasSPC)->PC_PD,cDescEven,;
      cCodVerba,(cAliasSPC)->PC_QUANTC,(cAliasSPC)->PC_QUANTI,(cAliasSPC)->PC_ABONO,(cAliasSPC)->PC_QTABONO}) 

   Endif  

   // ***
   dbSelectArea(cAliasSPC) 
   dbSkip()
EndDo

// *** Fecha Query de Histórico de Apontamentos *** //
dbSelectArea(cAliasSPC) 
dbCloseArea()

Return(.T.)

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |SQtdRgt     |Autor |Valdemir Miranda                  | Data | 18/03/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Pega Somatória da Quantidade de Funcionários Ativos                      ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function SQtdRgt()

Local xf1Mat:=0
Local nPos  :=0

// *** Conta quantos Funcionários estão no Vetor *** //
for xf1Mat:=1 to len(alinha)
   cPesq01:=alinha[xf1Mat][1]+alinha[xf1Mat][3]
   nPos := Ascan( aLinQtd, {|d| d[3] == Upper(cPesq01) } )
   If nPos < 1
      nQtdFunc:=nQtdFunc+1
      aadd(aLinQtd,{alinha[xf1Mat][1],alinha[xf1Mat][3],alinha[xf1Mat][1]+alinha[xf1Mat][3]})
   EndIf
Next xf1Mat

Return
