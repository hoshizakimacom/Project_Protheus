#INCLUDE "totvs.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  | M07R03       |Autor |Valdemir Miranda                | Data | 19/04/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Geração de Relatório de Relação DE Funcionários                         ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function M07R04()

Private lEnd      := .F.
Private nLastKey  := 0
Private lPerg     := lTemreg :=.f.
Private cAliasSRG :=""
Private cPlanilha := "Funcionarios"  // *** Nome da Pasta que sera' criada no arquivo Excel               *** //
Private cTabela   := "Relacao de Funcionarios "  // *** Nome do Titulo do Relatorio que sera' criado no arquivo Excel *** //
Private aCabecEx  :={}             // *** Vetor que armazenara' o Cabecalho do Arquivo Excel            *** //
Private aLinha    :={}             // *** Vetor que armazenara' a Linha Delhalhe do arquivo Excel       *** //
Private cAlfabeto :="a/A/b/B/c/C/d/D/e/E/f/F/g/G/h/H/i/I/j/J/k/K/l/L/m/M/n/N/o/O/p/P/q/Q/r/R/s/S/t/T/u/U/v/V/w/W/x/X/y/Y/z/Z"

// ... Inicializa Parametros ...     
If lPerg ==.F.
   PARGPER004()  
Endif        

// ...
lParametro:=Pergunte("M07R0004",.T.)

If !lParametro
	Return
EndIf
lPerg:=.t.

If nLastKey == 27
	Set Filter to
	Return
Endif   

Processa({||RELM07R04()}, "Relacao de Funcionarios "+time() )   

Return

/*
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Programa  |PARGPER001  |Autor | VALDEMIR MIRANDA  | Data |  19/04/2023  ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|| Desc.     | Parâmetros da Relação de Funcionarios                       ||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/ 
Static Function  PARGPER004() 
Local _sAlias := Alias()
Local cPerg := PADR("M07R0004",10)
Local aRegs :={}                       
Local nX  

lPerg  :=lTemreg :=.t. 
aAdd(aRegs,{"Filial       De ?","¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial       Ate?","¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"Matricula    De ?","¨Forneced. De?","From Bank ?","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula    Ate?","¨Forneced.Ate?","From Bank ?","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})   
aAdd(aRegs,{"C.de Custo   De ?","¨Forneced. De?","From Bank ?","mv_ch5","C",9,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.de Custo   Ate?","¨Forneced.Ate?","From Bank ?","mv_ch6","C",9,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Situação do Func?","¨Categoria   ?","Categoria ?","mv_ch7","C",30,0,0,"G","fSituacao","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})   
aAdd(aRegs,{"Categoria       ?","¨Categoria   ?","Categoria ?","mv_ch8","C",30,0,0,"G","fCategoria","mv_par8","","","","","","","","","","","","","","","","","","","","","","","","","",""})   

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
|| Programa  |RELM07R03  |Autor | VALDEMIR MIRANDA  | Data |   18/04/2023  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Processo de Geração da Relação de Funcionárioa              ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function RELM07R04()

// *** Definição de Variáveis *** //

Local ix1           :=0
Local wopx1         :=""
Local wxprimvxyz    :=0
Private dData       :=CTOD("")
Private csituacao1  :=""
Private cxcategoria :=""
Private XMES        :=MONTH(DDATABASE)
Private Meses       :={{"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}}
Private wxhorax     :=LEFT(TIME(),2)+"_"+SUBSTR(TIME(),4,2)+"_"+SUBSTR(TIME(),7,2) 
Private WDATAEXT    :=SUBSTR(DTOC(DDATABASE),1,2)+" DE "+MESES[1][XMES] +" DE "+SUBSTR(DTOS(DDATABASE),1,4)
Private cDescResc01 :=""

    
// *** Prepara Lista de Campos do Relatorio para montagem do Cabeçalho *** //'      
aadd(aCabecEx,"Filial")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Matricula")
aadd(aCabecEx,"Nome")
aadd(aCabecEx,"CPF")
aadd(aCabecEx,"R.G.")
aadd(aCabecEx,"UF do R.G.")
aadd(aCabecEx,"Org.Emissor do Docto")
aadd(aCabecEx,"Orgao Emissor do R.G.")
aadd(aCabecEx,"Cart.Prof.")
aadd(aCabecEx,"Serie da Cart.Prof.")
aadd(aCabecEx,"UF da Cart.Prof")
aadd(aCabecEx,"Dt.Admissao")
aadd(aCabecEx,"Centro de custo")
aadd(aCabecEx,"Descricao C.Custo")
aadd(aCabecEx,"Funcao")
aadd(aCabecEx,"Desc.Funcao")
aadd(aCabecEx,"Turno")
aadd(aCabecEx,"Descricao")
aadd(aCabecEx,"Endereco")
aadd(aCabecEx,"Numero")
aadd(aCabecEx,"Complemento")
aadd(aCabecEx,"Bairro")
aadd(aCabecEx,"Municipio")
aadd(aCabecEx,"Estado")
aadd(aCabecEx,"Cep")

// *** Prepara Variavel com Situação do Funcionário *** //
for ix1:=1 to len(mv_par07)
    if substr(mv_par07,ix1,1)<>"*" 
       if wxprimvxyz = 0
          wopx1:=wopx1+substr(mv_par07,ix1,1)+"/" 
          wxprimvxyz:=1
       else
          if substr(mv_par07,ix1,1) <> " " .and. substr(mv_par07,ix1,1) <> "*" 
             wopx1:=wopx1+substr(mv_par07,ix1,1)+"/" 
          endif
       endif
    endif
next ix1                                                                 
csituacao1:= wopx1   

// *** Prepara Variavel com Categoria do Funcionário *** //
wopx1:="" 
wxprimvxyz:=0
for ix1:=1 to len(mv_par08)
    if substr(mv_par08,ix1,1)<>"*" 
       if wxprimvxyz = 0
          wopx1:=wopx1+substr(mv_par08,ix1,1)+"/" 
          wxprimvxyz:=1
       else
          if substr(mv_par08,ix1,1) <> " " .and. substr(mv_par08,ix1,1) <> "*" 
             wopx1:=wopx1+substr(mv_par08,ix1,1)+"/" 
          endif
       endif
    endif
next ix1 
cxcategoria:=wopx1

// *** Acessa função de Captura de Informações da Tabela de Funcionários *** //
MQrySRAR04()

// *** Imprime Documento em Planilha Excel *** //
if len(aLinha) > 0
  
   cTabela:=cTabela+" de "+WDATAEXT
   cTipArq:="XML" // *** Tipo de Arquivo (XML, CSV ou TXT) *** //
   U_GERAEXCELN(cPlanilha,cTabela,aCabecEx,aLinha,cTipArq)

endif

Return(.T.)

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MtQrySRAD   |Autor |Valdemir Miranda                  | Data | 19/04/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Geracao de Query de Processamento da tabela SRA-Funcionários             ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MQrySRAR04()
Local cAtualiza:= "S"

// ***
cQuery := "SELECT *, SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_NOME,SRA.RA_ADMISSA,SRA.RA_CC,SRA.RA_SITFOLH,SRA.RA_CODFUNC,SRA.RA_TNOTRAB,SRA.RA_CATFUNC,SRA.RA_CIC,SRA.RA_RG, "
cQuery += "SRA.RA_RGUF,SRA.RA_RGORG,SRA.RA_RGEXP, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM, SRA.RA_BAIRRO,SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP, "
cQuery += " SRA.RA_NUMCP,SRA.RA_SERCP,SRA.RA_UFCP,SRA.RA_SALARIO,CTT.CTT_CUSTO, CTT.CTT_DESC01,SRJ.RJ_FUNCAO,SRJ.RJ_DESC,SR6.R6_TURNO,SR6.R6_DESC "
cQuery += " FROM " + RetSqlName("SRA") + " SRA "

cQuery += " INNER JOIN "+ RetSqlName("CTT") + " CTT "
cQuery += " ON CTT.D_E_L_E_T_ = ' ' "
cQuery += " AND CTT.CTT_CUSTO = SRA.RA_CC "

cQuery += " INNER JOIN "+ RetSqlName("SRJ") + " SRJ "
cQuery += " ON SRJ.D_E_L_E_T_ = ' ' "
cQuery += " AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "

cQuery += " INNER JOIN "+ RetSqlName("SR6") + " SR6 "
cQuery += " ON SR6.D_E_L_E_T_ = ' ' "
cQuery += " AND SR6.R6_TURNO = SRA.RA_TNOTRAB "

cQuery += " WHERE SRA.RA_FILIAL BETWEEN '"+left(mv_par01,2)+"' AND '"+left(MV_PAR02,2)+"' "
cQuery += " AND SRA.RA_MAT   BETWEEN '"+mv_par03+"' AND '"+MV_PAR04+"' "
cQuery += " AND SRA.RA_CC BETWEEN '"+mv_par05+"' AND '"+MV_PAR06+"' "

cQuery += " AND SRA.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_CC ASC "

// ***
cAliasSRA:= GetNextAlias() 
If Select(cAliasSRA) > 0
   dbSelectArea(cAliasSRA)
   dbCloseArea()
EndIf
 
// *** Abre Tabelas *** //
cQry3=ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry3), cAliasSRA, .F., .T.)

// *** Pega Quantidade de Registros para ProcRegua *** //
dbSelectArea(cAliasSRA) 
dbGotop()
do while .not. eof()
   nTotal:= Recno()
   dbskip()
enddo

// *** Captura Chave *** //
dbSelectArea(cAliasSRA) 
ProcRegua(nTotal)
dbGoTop()   
   
// *** Prepara Vetor com Informações do Relatório de Rescisão Contratual *** //
Do While .not. eof()
  
   // *** Prepara Dados do Vetor *** //
   dbSelectArea(cAliasSRA)
   cRANOME	 := (cAliasSRA)->RA_NOME
   cADemissax:= (cAliasSRA)->RA_ADMISSA
   cRACC     := (cAliasSRA)->RA_CC
   cDESCcc   := (cAliasSRA)->CTT_DESC01
   cADemissax:=DTOC(STOD(cADemissax))

    // *** Situação do Colaborador *** //
    cAtualiza:="S"
   if (cAliasSRA)->RA_SITFOLH $csituacao1
      cAtualiza:="S"
   else
      cAtualiza:="N"
   endif

   // *** Categoria do Colaborador *** //
   IF cAtualiza =="S"
        if (cAliasSRA)->RA_CATFUNC $cxcategoria 
            cAtualiza:="S"
        else
            cAtualiza:="N"
        endif
   Endif
   
   if cAtualiza == "S"
      cFilName := FWFilialName()
      IncProc("Documento: " + (cAliasSRA)->RA_FILIAL+"-"+ALLTRIM(cFilName)+" - "+(cAliasSRA)->RA_MAT+" - "+ALLTRIM(cRANOME) )

      // ***
      cCep:=Substr((cAliasSRA)->RA_CEP,1,5)+"-"+Substr((cAliasSRA)->RA_CEP,6,3)
      aadd(aLinha,{(cAliasSRA)->RA_FILIAL,cFilName,(cAliasSRA)->RA_MAT,ALLTRIM(cRANOME),(cAliasSRA)->RA_CIC,(cAliasSRA)->RA_RG,(cAliasSRA)->RA_RGUF,(cAliasSRA)->RA_RGORG,(cAliasSRA)->RA_RGEXP,;
                    (cAliasSRA)->RA_NUMCP,(cAliasSRA)->RA_SERCP,(cAliasSRA)->RA_UFCP ,cADemissax,cRACC,ALLTRIM(cDESCcc),(cAliasSRA)->RA_CODFUNC,ALLTRIM((cAliasSRA)->RJ_DESC),;
                    (cAliasSRA)->R6_TURNO,ALLTRIM((cAliasSRA)->R6_DESC), ALLTRIM((cAliasSRA)->RA_ENDEREC), ALLTRIM((cAliasSRA)->RA_NUMENDE),ALLTRIM((cAliasSRA)->RA_COMPLEM), ALLTRIM((cAliasSRA)->RA_BAIRRO),ALLTRIM((cAliasSRA)->RA_MUNICIP),(cAliasSRA)->RA_ESTADO, cCep })
   endif
    // ***
   dbSelectArea(cAliasSRA) 
   DBSKIP()
Enddo

// *** Fecha Query de Funcionários *** //
dbSelectArea(cAliasSRA) 
dbCloseArea()
return(.T.)

