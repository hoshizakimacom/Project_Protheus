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
//|| Desc.     | Relação de Demitidos                                        ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Uso       | FOLHA DE PAGAMENTO / RECUSRSOS HUMANOS                      ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/    
USER Function M07R02()   
Private lEnd      := .F.
Private nLastKey  := 0
Private lPerg     := lTemreg :=.f.
Private cAliasSRG :=""
Private cPlanilha := "Rescisões"  // *** Nome da Pasta que sera' criada no arquivo Excel               *** //
Private cTabela   := "Relatorio de Funcionários Demitidos"  // *** Nome do Titulo do Relatorio que sera' criado no arquivo Excel *** //
Private aCabecEx  :={}             // *** Vetor que armazenara' o Cabecalho do Arquivo Excel            *** //
Private aLinha    :={}             // *** Vetor que armazenara' a Linha Delhalhe do arquivo Excel       *** //
Private cAlfabeto :="a/A/b/B/c/C/d/D/e/E/f/F/g/G/h/H/i/I/j/J/k/K/l/L/m/M/n/N/o/O/p/P/q/Q/r/R/s/S/t/T/u/U/v/V/w/W/x/X/y/Y/z/Z"

// ... Inicializa Parametros ...     
If lPerg ==.F.
   PARGPER002()  
Endif        

// ...
lParametro:=Pergunte("M07R0002",.T.)

If !lParametro
	Return
EndIf
lPerg:=.t.

If nLastKey == 27
	Set Filter to
	Return
Endif   
             
Processa({||RELM07R02()}, "Relatório de Demitidos "+time() )   

Return 

/*
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Programa  |PARGPER002  |Autor | VALDEMIR MIRANDA  | Data |   13/03/202  ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Desc.     | Parâmetros do Relatório de Demitidos                        ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/ 
Static Function  PARGPER002() 
Local _sAlias := Alias()
Local cPerg := PADR("M07R0002",10)
Local aRegs :={}                       
Local nX  

lPerg  :=lTemreg :=.t. 
aAdd(aRegs,{"Filial       De ?","¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial       Ate?","¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"Dt. Demissao De ?","¨Dt. de Pagto?","Dt.de Pagto ?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{"Dt. Demissao Até?","¨Dt. de Pagto?","Dt.de Pagto ?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{"C.de Custo   De ?","¨Forneced. De?","From Bank ?","mv_ch5","C",9,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.de Custo   Ate?","¨Forneced.Ate?","From Bank ?","mv_ch6","C",9,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Matricula    De ?","¨Forneced. De?","From Bank ?","mv_ch7","C",6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula    Ate?","¨Forneced.Ate?","From Bank ?","mv_ch8","C",6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})   

dbSelectArea("SX1")
dbSetOrder(1) 

For nX:=1 to Len(aRegs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO	with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace x1_pergunt 	with aRegs[nx][01]
		Replace x1_perspa	with aRegs[nx][02]
		Replace x1_pereng	with aRegs[nx][03]
		Replace x1_variavl	with aRegs[nx][04]
		Replace x1_tipo		with aRegs[nx][05]
		Replace x1_tamanho	with aRegs[nx][06]
		Replace x1_decimal	with aRegs[nx][07]
		Replace x1_presel	with aRegs[nx][08]
		Replace x1_gsc		with aRegs[nx][09]
		Replace x1_valid	with aRegs[nx][10]
		Replace x1_var01	with aRegs[nx][11]
		Replace x1_def01	with aRegs[nx][12]
		Replace x1_defspa1	with aRegs[nx][13]
		Replace x1_defeng1	with aRegs[nx][14]
		Replace x1_cnt01	with aRegs[nx][15]
		Replace x1_var02	with aRegs[nx][16]
		Replace x1_def02	with aRegs[nx][17]
		Replace x1_defspa2	with aRegs[nx][18]
		Replace x1_defeng2	with aRegs[nx][19]
		//-
		Replace x1_cnt02  	with aRegs[nx][20]
		Replace x1_var03	with aRegs[nx][21]
		Replace x1_def03	with aRegs[nx][22]
		Replace x1_defspa3	with aRegs[nx][23]
		Replace x1_defeng3	with aRegs[nx][24]
		Replace x1_cnt03  	with aRegs[nx][25]
		Replace x1_var04	with aRegs[nx][26]
		Replace x1_def04	with aRegs[nx][27]
		Replace x1_defspa4	with aRegs[nx][28]
		Replace x1_defeng4	with aRegs[nx][29]
		Replace x1_cnt04  	with aRegs[nx][30]
		Replace x1_var05	with aRegs[nx][31]
		Replace x1_def05	with aRegs[nx][32]
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
|| Programa  |NEOGPR002  |Autor | VALDEMIR MIRANDA  | Data |   13/03/2023  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Processo de Geração do Relatório de Demitidos               ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function RELM07R02()

// *** Definição de Variáveis *** //

Private dData       :=CTOD("")
Private csituacao1  :=""
Private cxcategoria :=""
Private XMES        :=MONTH(DDATABASE)
Private Meses       :={{"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}}
Private wxhorax     :=LEFT(TIME(),2)+"_"+SUBSTR(TIME(),4,2)+"_"+SUBSTR(TIME(),7,2) 
Private WDATAEXT    :=SUBSTR(DTOC(DDATABASE),1,2)+" DE "+MESES[1][XMES] +" DE "+SUBSTR(DTOS(DDATABASE),1,4)
Private cDescResc01 :=""
    
// *** Prepara Lista de Campos do Relatorio *** //'      
aadd(aCabecEx,"Filial")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Matricula")
aadd(aCabecEx,"Nome")
aadd(aCabecEx,"Dt.Demissao")
aadd(aCabecEx,"Dt.Admissao")
aadd(aCabecEx,"Centro de custo")
aadd(aCabecEx,"Descricao C.Custo")
aadd(aCabecEx,"Cod.Deslig.")
aadd(aCabecEx,"Motivo Desligamento")

// *** Acessa função de Captura de Informações da Tabela de Funcionários Demitidos *** //
MtQrySRAD()

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
|| Programa  |MtQrySRAD   |Autor |Valdemir Miranda                  | Data | 03/03/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Geracao de Query de Processamento da tabela SRG-Demitidos                ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MtQrySRAD()

// ***
cQuery := "SELECT *, SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_NOME,SRA.RA_ADMISSA,SRA.RA_CC,SRA.RA_SITFOLH,SRA.RA_CATFUNC "
cQuery += " FROM " + RetSqlName("SRG") + " SRG "

cQuery += " INNER JOIN "+ RetSqlName("SRA") + " SRA "
cQuery += " ON SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_FILIAL = SRG.RG_FILIAL "
cQuery += " AND SRA.RA_MAT = SRG.RG_MAT "

cQuery += " WHERE SRG.RG_FILIAL BETWEEN '"+left(mv_par01,2)+"' AND '"+left(MV_PAR02,2)+"' " 
cQuery += " AND SRG.RG_DATADEM BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(MV_PAR04)+"' "
cQuery += " AND SRA.RA_CC BETWEEN '"+mv_par05+"' AND '"+MV_PAR06+"' "
cQuery += " AND SRG.RG_MAT   BETWEEN '"+mv_par07+"' AND '"+MV_PAR08+"' "

cQuery += " AND SRG.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SRG.RG_FILIAL,SRG.RG_DATADEM,SRG.RG_MAT,SRA.RA_CC ASC "

// ***
cAliasSRG:= GetNextAlias() 
If Select(cAliasSRG) > 0
   dbSelectArea(cAliasSRG)
   dbCloseArea()
EndIf
 
// *** Abre Tabelas *** //
cQry3=ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry3), cAliasSRG, .F., .T.)

// *** Pega Quantidade de Registros para ProcRegua *** //
dbSelectArea(cAliasSRG) 
dbGotop()
do while .not. eof()
   nTotal:= Recno()
   dbskip()
enddo

// *** Captura Chave *** //
dbSelectArea(cAliasSRG) 
ProcRegua(nTotal)
dbGoTop()   
   
// *** Prepara Vetor com Informações do Relatório de Rescisão Contratual *** //
Do While .not. eof()
  
   // *** Prepara Dados do Vetor *** //
   dbSelectArea(cAliasSRG)
   cRANOME	 := (cAliasSRG)->RA_NOME
   cADemissax:= (cAliasSRG)->RA_ADMISSA
   cRACC     := (cAliasSRG)->RA_CC
   cDESCcc   := Posicione("CTT",1,xFilial("CTT")+cRACC,"CTT_DESC01")

   cDemissax:=DTOC(STOD((cAliasSRG)->RG_DATADEM))
   cADemissax:=DTOC(STOD(cADemissax))

   // *** Pega Descricao do Tipo de Rescisao *** //
   cDescResc01 :=""
   PgDescResc()

   cFilName := FWFilialName()
   IncProc("Documento: " + (cAliasSRG)->RG_FILIAL+"-"+cFilName+" - "+(cAliasSRG)->RG_MAT+" - "+cRANOME )
  
   // ***
   aadd(aLinha,{(cAliasSRG)->RG_FILIAL,cFilName,(cAliasSRG)->RG_MAT,cRANOME,cDemissax,cADemissax,cRACC,cDESCcc,(cAliasSRG)->RG_TIPORES,cDescResc01 })
  
   // ***
   dbSelectArea(cAliasSRG) 
   DBSKIP()
Enddo

// *** Fecha Query de Histórico de Apontamentos *** //
dbSelectArea(cAliasSRG) 
dbCloseArea()
return(.T.)


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MontQrySPC  |Autor |Valdemir Miranda                  | Data | 04/03/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Pega Somatória de Quantidade de Funcionários Ativos         			   ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function PgDescResc()
Local cAliasRCC:=""

cQuery := "SELECT * From" + RetSqlName("RCC") + " RCC "
cQuery += " where RCC.D_E_L_E_T_ = ' ' "
cQuery += " AND RCC.RCC_CODIGO = 'S043' "
cQuery += " AND substring(RCC.RCC_CONTEU,1,2) = '"+(cAliasSRG)->RG_TIPORES +"' "

// ***
cAliasRCC:= GetNextAlias() 
If Select(cAliasRCC) > 0
   dbSelectArea(cAliasRCC)
   dbCloseArea()
EndIf
 
// *** Abre Tabelas *** //
cQry3=ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry3), cAliasRCC, .F., .T.)

// *** Captura Quantidade de Funcionarios Ativos *** //
dbSelectArea(cAliasRCC) 
dbGoTop() 
if .not. eof()
   cDescResc01:=SUBSTR((cAliasRCC)->RCC_CONTEU,3,30)
endif

// *** Fecha Query de Histórico de Apontamentos *** //
dbSelectArea(cAliasRCC) 
dbCloseArea()

Return(.T.)


