#INCLUDE "PROTHEUS.CH" 
#Include "TOPCONN.CH" 
#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER05 | Autor | Valdemir Miranda      | Data |21/05/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão da Ficha de Registro do Empregado                |||  
|||          |                                                            |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   |                                                            |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||                                                                       |||
|||           ATUALIZAÇÕES SOFRIDAS DESDE A CONSTRUÇÃO INICIAL            |||
|||                                                                       |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Programador | Data   | BOPS |  Motivo da Alteracao                     |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

User Function  ABGPER05()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 

Private cObs1:=SPACE(50) 
Private cObs2:=SPACE(50) 
Private cObs3:=SPACE(50)  
Private cObs4:=SPACE(50) 
Private cObs5:=SPACE(50) 
Private cObs6:=SPACE(50) 
Private cObs7:=SPACE(50)  
Private cObs8:=SPACE(50)
Private oObs1
Private oObs2
Private oObs3
Private oObs4
Private oObs5
Private oObs6
Private oObs7
Private oObs8
 
// ... Inicializa Parametros ...     
ABGPERPAR5()

// ...
If !Pergunte("ABGPER05",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||ABGPR05A() }, "Ficha de Registro"+time() )  
Restarea(aAREA)

Return  
       

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPR05A | Autor | Valdemir Miranda      | Data |07/08/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Função para geração de Observação                          |||  
|||          |                                                            |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function  ABGPR05A()                             

Local cTitulo:= "Inclusão de Observação"     //Ver  Horizontal 
Private _oDlg 

cObs1:=SPACE(50) 
cObs2:=SPACE(50) 
cObs3:=SPACE(50)  
cObs4:=SPACE(50) 
cObs5:=SPACE(50) 
cObs6:=SPACE(50) 
cObs7:=SPACE(50)  
cObs8:=SPACE(50)


DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 000,000 TO 400,800 PIXEL                                                                        
   
   @  10, 10 SAY "Observações :" SIZE 500, 10 OF _oDlg COLORS 5 PIXEL
   @  10, 50 MSGET oObs1 VAR cObs1 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T. 
   @  30, 50 MSGET oObs2 VAR cObs2 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @  50, 50 MSGET oObs3 VAR cObs3 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @  70, 50 MSGET oObs4 VAR cObs4 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T. 
   @  90, 50 MSGET oObs5 VAR cObs5 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T. 
   @  110, 50 MSGET oObs6 VAR cObs6 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @  130, 50 MSGET oObs7 VAR cObs7 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @  150, 50 MSGET oObs8 VAR cObs8 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T. 
   
   @  170, 50 Button "Gerar Relatório" Size 100, 012 PIXEL OF _oDlg Action(ABGPEFIREG())

ACTIVATE MSDIALOG _oDlg CENTERED


Return     


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |ABGPERPAR()    | Autor | Valdemir Miranda | Data |15/04/2013|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato                    	        	  |||  
|||          | 					                                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | ABGPERPAR()                                                |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERPAR5()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPER05",10)
Local aRegs 	:={}                       
Local nX  

aAdd(aRegs,{"Filial De ?"		,"¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"C.Custo De ?"		,"¨Forneced. De?","From Bank ?","mv_ch3","C",9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.Custo Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch4","C",9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Matricula De ?"	,"¨Forneced. De?","From Bank ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula Ate?"	,"¨Forneced.Ate?","From Bank ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})      
dbSelectArea("SX1")
SX1->(dbSetOrder(1)) 
 
BEGIN TRANSACTION
 For nX:=1 to Len(aRegs)
	If !(SX1->(dbSeek(cPerg+StrZero(nx,2))))
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
		Replace x1_f3     		with aRegs[nx][36]
		Replace x1_grpsxg 	with aRegs[nx][37]
	    SX1->(MsUnlock())
	Endif
Next nX
END TRANSACTION
RESTAREA(_aAlias)
Return  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |ABGPEFIREG()      |Autor|Valdemir Miranda | Data |29/05/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Sistema de Emissão da Ficha de Registro          	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPEFIREG()   
Local cQry 			:=""  
Local nhandle		:=0
Local cCepPJConv	:=""  
Local cEstaFornec  	:=""
Local aAreaAlias	:=GETAREA() 
Local cArquivo 		:=""   
Local cDataExt1   	:=""
Local cDataExt2   	:="" 
Private  cEntrada1	:=""
Private  cSaida1  	:=""
Private  cEntrada2	:=""
Private  cSaida2  	:=""  
Private  cAliasA	:="" 
Private  cCBO		:=""

// *** Fontes de Letras *** // 
Private oFont04n  	:= TFont():New("Verdana",04,4,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** // 
Private oFont05n  	:= TFont():New("Verdana",05,5,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont06n  	:= TFont():New("Verdana",06,06,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont07n  	:= TFont():New("Verdana",07,07,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08  	:= TFont():New("Verdana",08,08,,.F.,,,,.F.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08n  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //

Private oFont04C    := TFont():New("Courier New",04,04,,.T.,,,,.T.,.F.) 
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont09	   	:= TFont():New("Verdana",09,09,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont09N 	:= TFont():New("Verdana",09,09,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont10N 	:= TFont():New("Verdana",10,10,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont12N  	:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont14N 	:= TFont():New("Arial Black",14,14,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont16N 	:= TFont():New("Arial Black",16,16,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //

// ... Inicia uma nova pagina da TMSPRINTER ... //
oPrint:= TMSPrinter():New("Emissão da Ficha de Registro ")
oPrint:Setup()

//Private  oPrint:SetLandscape() 		// *** Seleciona tipo de Impressão no Formato  Paisagem	*** //
oPrint:SetPortrait()    			// *** Seleciona tipo de Impressão no Formato Retrato      *** //
oPrint:SETPAPERSIZE(9)  // *** Seleciona tipo do Papel:  1 - Papel Carta   -   9 - A4 *** // 
cAliasA:="SRA"

// *** Inicio do Processamento  *** //
dbSelectArea("SRA") 
dbsetorder(1)
ProcRegua(SRA->(LastRec()))  
 
if .not. empty(mv_par01) 
   SET FILTER TO RA_FILIAL>=mv_par01 .AND. RA_FILIAL<=mv_par01 .and.  RA_MAT >= mv_par05 .AND. RA_MAT <= mv_par05 
else
   SET FILTER TO RA_MAT >= mv_par05 .AND. RA_MAT <= mv_par05 
endif
SRA->(dbGoTop())       

Do While .not. ( SRA->(eof()) )  

   // ***
   dbSelectArea("SRA")  
   if .not. empty(mv_par01) 
      if SRA->RA_FILIAL < mv_par01 
         loop
      endif 
      
      if SRA->RA_FILIAL > mv_par02 
         loop
      endif
   endif
   
   if .not. empty(mv_par03) 
      if SRA->RA_CC  < mv_par03 
         loop
      endif 
      
      if SRA->RA_CC  > mv_par04 
         loop
      endif
   endif      
   
   if .not. empty(mv_par05) 
      if SRA->RA_MAT  < mv_par05 
         loop
      endif 
      
      if SRA->RA_MAT  > mv_par06 
         loop
      endif
   endif
       
   // ***
   dbSelectArea("SRA") 
  
   // *** Imprime Moldura e Inicia uma Nova Página *** //      
   nLin:=200 
   QebPagina2()
   
   // *** Prepara Variáveis de Memória *** //
   cEmpresa	:=ALLTRIM(SM0->M0_NOMECOM)
   cCNPJ	:=left(SM0->M0_CGC,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2) 
   cEndereco:=((SM0->M0_ENDCOB))+iif(empty(SM0->M0_COMPCOB)," "," - "+ALLTRIM(Capital(SM0->M0_COMPCOB)))
   cBairro	:=Alltrim(CAPITAL(SM0->M0_BAIRCOB))   
   cMunicip:=(CAPITAL(SM0->M0_CIDCOB))+"-"+SM0->M0_ESTCOB 
   cNome	:=alltrim(SRA->RA_NOME)   
   cTPS		:=ALLTRIM(SRA->RA_NUMCP)
   cSerie	:=ALLTRIM(SRA->RA_SERCP)
   cCPF := SUBSTR(SRA->RA_CIC,1,3)+"."+SUBSTR(SRA->RA_CIC,4,3)+"."+SUBSTR(SRA->RA_CIC,7,3)+"-"+SUBSTR(SRA->RA_CIC,10,2) 
   cEndfunc	:=ALLTRIM(CAPITAL(SRA->RA_ENDEREC))
   cBairFunc:=ALLTRIM(CAPITAL(SRA->RA_BAIRRO))   
   cCep		:=substr(SRA->RA_CEP,1,5)+"-"+substr(SRA->RA_CEP,6,3)
   cMuniFunc:=ALLTRIM(CAPITAL(SRA->RA_MUNICIP))+"-"+ALLTRIM(SRA->RA_ESTADO)+"- Cep: "+cCep 
   cEndResid:=cEndfunc+"-"+cBairFunc+"-"+cMuniFunc
   
   // *** Pega Descrição da Função *** // 
   dbselectarea("SRJ")
   cxArea:=getarea()
   DBSETORDER(1)
   DBSEEK(xfilial("SRJ")+(cAliasA)->RA_CODFUNC)
   if .not. eof()
      cCargo_Funcao:=SRJ->RJ_DESC 
      cCBO		   :=SRJ->RJ_CBO
   endif
   restarea(cxArea) 
   
   // ***
   dbSelectArea("SRA") 
   
   // *** Captura Horário de Trabalho 
   cArea2   :=Getarea()
   cEntrada1:=""
   cSaida1  :=""
   cEntrada2:=""
   cSaida2  :=""
   
   // ***
   PgaHrTrab() 
   
   // *** Impressão de Linha detalhe *** // 
   nLin:=nLin+150    
   nLinAnt:=nLin
   ImpBox(oPrint,nLin,120, (nLin+250), 2380,2) 
   
   nlin:=nlin+30
   oPrint:Say(nLin,150 , "Empregador", oFont06n)
   oPrint:Say(nLin,2000  , "CNPJ", oFont06n)
    
   nlin:=nlin+40
   oPrint:Say(nLin,150 , cEmpresa, oFont07n)
   oPrint:Say(nLin,2000  , cCNPJ, oFont07n) 
   
   nlin:=nlin+60
   ImpBox(oPrint,nlin,120, nlin, 2380,2)
   ImpBox(oPrint,nLinAnt,1990, nLin, 1990,2)  
   
   nlin:=nlin+30         
   nLinAnt:=nLin
   oPrint:Say(nLin,150 , "Endereço", oFont06n)
   
   nlin:=nlin+40
   oPrint:Say(nLin,150 , ALLTRIM(cEndereco)+"-"+cBairro+"-"+cMunicip , oFont06n)
   
    nlin:=nlin+100 
    nLinAnt:=nLin
    ImpBox(oPrint,nlin,120, (nlin+300) , 1300,2)
    ImpBox(oPrint,nlin,1330, (nlin+300) , 2380,2) 
    ImpBox(oPrint,nlin,1990, (nlin+300) , 1990,2)    
    
    nlin:=nlin+20
    nLinBenefic:=nLin+50
    oPrint:Say(nLin,150 , "Funcionário", oFont06n) 
    oPrint:Say(nLin,1350 , "Beneficiários", oFont06n) 
    oPrint:Say(nLin,2000 , "Tipo de Beneficio", oFont06n) 
    
    ImpBox(oPrint,(nlin+40),1330, (nLin+40) , 2380,2)     
    
    //*** Imprime Beneficiários *** //
    AbGpeImpBenef()
     
    nlin:=nlin+30 
    nLinBenefic:=nlin
    oPrint:Say(nLin,150 , cNome , oFont07n)
                
    nlin:=nlin+60
    ImpBox(oPrint,nLinAnt,120, nLin, 1300,2) 
    
    nlin:=nlin+30
    oPrint:Say(nLin,150 , "Endereço Residencial", oFont07n) 
    nlin:=nlin+40
    oPrint:Say(nLin,150 , cEndResid, oFont07n)         
     
    nlin:=nlin+150
    nLinAnt:=nlin
    ImpBox(oPrint,nLin,120, (nLin+600), 500,2)
    ImpBox(oPrint,nLin,530, (nLin+600), 2380,2)  
   
    // *** Coloca Foto no Formulario *** //
    cOldDir := curdir()
    cNewDir := '\FOTOS'
    curdir(cNewDir) // Troca o path
    If cNewDir <> '\'+curdir() // E verifica se trocou mesmo
       conout('Falha ao Trocar de Path de '+cOldDir + ' para '+cNewDir)
    Else
       conout('Path de '+cOldDir + ' trocado para '+cNewDir+' com sucesso.')
    Endif

    cFig :=ALLTRIM(SRA->RA_MAT)+".BMP" 
    cFig2 :=ALLTRIM(SRA->RA_MAT)+".JPG" 
           
    if file(cFig)  
       cFig2:=cFig       
       oPrint:SayBitmap((nLin+10),115,cFig,380,590)
    elseif file(cFig2)  
       cFig:=cFig2       
       oPrint:SayBitmap((nLin+10),115,cFig,380,590)
    endif  
     
    // ***
    nLin:=nLin+20       
    cLocalNascto  :=""
    cEstadCivil   :="" 
    cNacionalidade:="" 
    cGrauInstru   :=""   
    cFormPagto    :=""
    
    // ***
    oPrint:Say(nLin,540  , "Data de Nascimento" , oFont06n) 
    oPrint:Say(nLin,1000  , "Local de Nascimento" , oFont06n) 
    oPrint:Say(nLin,1500  , "Nacionalidade" , oFont06n)
    oPrint:Say(nLin,2000  , "Estado Civil" , oFont06n) 
    
    // *** Pega Local de Nascimento *** //
    DbSelectarea("SX5")
    cAreaSX5:=GetArea()
    Dbsetorder(1)     
    Set Filter to val(SX5->X5_TABELA) >= 12 .and. val(SX5->X5_TABELA) <= 34
    dbgotop()
    do while .not. eof()
    
       if ALLTRIM(SX5->X5_TABELA)+ALLTRIM(SX5->X5_CHAVE) = "12"+ALLTRIM(SRA->RA_NATURAL)
          cLocalNascto:=SX5->X5_DESCRI
       endif 
       
       
       if ALLTRIM(SX5->X5_TABELA)+ALLTRIM(SX5->X5_CHAVE) = "26"+ALLTRIM(SRA->RA_GRINRAI)
          cGrauInstru  :=SX5->X5_DESCRI
       endif          
       
       if ALLTRIM(SX5->X5_TABELA)+ALLTRIM(SX5->X5_CHAVE) = "28"+ALLTRIM(SRA->RA_CATFUNC)
          cFormPagto :=SX5->X5_DESCRI
       endif
       
       if ALLTRIM(SX5->X5_TABELA)+ALLTRIM(SX5->X5_CHAVE) = "33"+ALLTRIM(SRA->RA_ESTCIVI)
          cEstadCivil :=SX5->X5_DESCRI
       endif 
       
       if ALLTRIM(SX5->X5_TABELA)+ALLTRIM(SX5->X5_CHAVE) = "34"+ALLTRIM(SRA->RA_NACIONA)
          cNacionalidade :=SX5->X5_DESCRI
       endif
       
       DBSKIP()
    Enddo    
    Set Filter to
    
    nLin:=nLin+40 
    oPrint:Say(nLin,540  , LEFT(dtoc(SRA->RA_NASC),6)+LEFT(DTOS(SRA->RA_NASC),4) , oFont07n) 
    oPrint:Say(nLin,1000  , cLocalNascto, oFont07n) 
    oPrint:Say(nLin,1500  , cNacionalidade , oFont06n)
    oPrint:Say(nLin,2000  , cEstadCivil , oFont07n)  
    
    nLin:=nLin+40 
    ImpBox(oPrint,nLin,530,(nLin+200), 2380,2) 
    ImpBox(oPrint,nLin,530,(nLin+200), 700,2)
     
    ImpBox(oPrint,nLinAnt,990, nLin, 990,2)
    ImpBox(oPrint,nLinAnt,1490, nLin, 1490,2)
    ImpBox(oPrint,nLinAnt,1990, nLin, 1990,2)
    
    nLin:=nLin+20 
    oPrint:Say((nLin+50),550 , "FILIAÇÃO" , oFont06n) 
    oPrint:Say(nLin,710 , "Pai" , oFont06n)  
    
    nLin:=nLin+30
    oPrint:Say(nLin,710 , SRA->RA_PAI , oFont07n)
       
    nLin:=nLin+40
    ImpBox(oPrint,nLin,700,nLin, 2380,2) 
    
    nLin:=nLin+20
    oPrint:Say(nLin,710 , "Mãe" , oFont06n)  
    
    nLin:=nLin+30
    oPrint:Say(nLin,710 , SRA->RA_MAE , oFont07n)  
    
    nLin    :=nLin+60   
    nlinAnt :=nLin
    nLinAnt4:=(nLin+200)
    ImpBox(oPrint,nLin,530,(nLin+200), 2380,2) 
    
    nLin:=nLin+20
    oPrint:Say(nLin,550 , "Cédula de Identidade" , oFont06n) 
    oPrint:Say(nLin,900, "Dt. de Emissão" , oFont06n) 
    oPrint:Say(nLin,1100, "Órgão/UF Emissor" , oFont06n)
    oPrint:Say(nLin,1330, "Título de Eleitor" , oFont06n) 
    oPrint:Say(nLin,1600, "Zona" , oFont06n)   
    oPrint:Say(nLin,1800, "Seção" , oFont06n)
    oPrint:Say(nLin,2000, "Inscrição Órgão de Classe" , oFont06n)
    
    nLin:=nLin+30
    oPrint:Say(nLin,550 , SRA->RA_RG , oFont06n) 
    oPrint:Say(nLin,900, LEFT(dtoc(SRA->RA_DTRGEXP),6)+LEFT(dtoS(SRA->RA_DTRGEXP),4) , oFont06n) 
    oPrint:Say(nLin,1100, SRA->RA_RGEXP+"/"+SRA->RA_RGUF , oFont06n)
    oPrint:Say(nLin,1330, SRA->RA_TITULOE , oFont06n) 
    oPrint:Say(nLin,1600,SRA->RA_ZONASEC, oFont06n)   
    oPrint:Say(nLin,1800, SRA->RA_SECAO, oFont06n)
    oPrint:Say(nLin,2000, "" , oFont06n) 
    
    nLin:=nLin+40 
    ImpBox(oPrint,nLin,530,nlin, 2380,2)   
    
    ImpBox(oPrint,nLinAnt,890,nLin, 890,2) 
    ImpBox(oPrint,nLinAnt,1090,nLin, 1090,2)
    ImpBox(oPrint,nLinAnt,1320,nLin, 1320,2) 
    ImpBox(oPrint,nLinAnt,1590,nLin, 1590,2) 
    ImpBox(oPrint,nLinAnt,1790,nLin, 1790,2)  
    ImpBox(oPrint,nLinAnt,1990,nLin, 1990,2)
     
    nLinAnt:=nLin
    nLin:=nLin+20
    oPrint:Say(nLin,550 , "Cart.Prof." , oFont06n) 
    oPrint:Say(nLin,900, "Série" , oFont06n) 
    oPrint:Say(nLin,1100, "Dt.de Expedição" , oFont06n)
    oPrint:Say(nLin,1330, "UF da CTPS" , oFont06n) 
    oPrint:Say(nLin,1600, "CPF" , oFont06n)   
    oPrint:Say(nLin,1900, "Cart.Nac.Habilitação" , oFont06n)
    oPrint:Say(nLin,2200, "Categoria" , oFont06n) 
    
    nLin:=nLin+30  
    cCPF := SUBSTR(SRA->RA_CIC,1,3)+"."+SUBSTR(SRA->RA_CIC,4,3)+"."+SUBSTR(SRA->RA_CIC,7,3)+"-"+SUBSTR(SRA->RA_CIC,10,2) 
    oPrint:Say(nLin,550 , SRA->RA_NUMCP, oFont07n) 
    oPrint:Say(nLin,900, SRA->RA_SERCP, oFont07n) 
    oPrint:Say(nLin,1100, LEFT(DTOC(SRA->RA_DTCPEXP),6)+LEFT(DTOS(SRA->RA_DTCPEXP),4) , oFont07n)
    oPrint:Say(nLin,1330, SRA->RA_UFCP , oFont07n) 
    oPrint:Say(nLin,1600, cCPF , oFont07n)   
    oPrint:Say(nLin,1900, SRA->RA_HABILIT, oFont07n)
    oPrint:Say(nLin,2200, "" , oFont07n)
    
    ImpBox(oPrint,(nLin-50),890,(nLin+60), 890,2) 
    ImpBox(oPrint,(nLin-50),1090,(nLin+60), 1090,2)
    ImpBox(oPrint,(nLin-50),1320,(nLin+60), 1320,2) 
    ImpBox(oPrint,(nLin-50),1590,(nLin+60), 1590,2) 
    ImpBox(oPrint,(nLin-50),1890,(nLin+60), 1890,2)  
    ImpBox(oPrint,(nLin-50),2190,(nLin+60), 2190,2) 
    
    nLin:=nLin+60 
    nLinAnt:=nLin
    nLin:=nLin+20 
    oPrint:Say(nLin,550 , "Doc.Militar" , oFont06n) 
    oPrint:Say(nLin,1100, "Categoria" , oFont06n)
    oPrint:Say(nLin,1330, "Côr" , oFont06n) 
    oPrint:Say(nLin,1600, "Sexo" , oFont06n)   
    oPrint:Say(nLin,1900, "Grau de Instrução" , oFont06n) 
    
    nLin:=nLin+30 
    aRacaCor:={}  
    nCor:=iif(val(SRA->RA_RACACOR) > 1,val(SRA->RA_RACACOR),9)
    
    if nCor =4
       nCor:=3
    elseif nCor =6
        nCor:=4
    elseif nCor =8
        nCor:=5
    elseif nCor =9
        nCor:=6
    endif  
        
    // ***
    if empty(SRA->RA_RACACOR)
       nCor:=6
    endif
         
    // ***    
    aAdd(aRacaCor,{"INDIGENA","BRANCA","NEGRA","AMARELA","PARDA","NÃO INFORMADA"})  
    oPrint:Say(nLin,550 , SRA->RA_RESERVI, oFont06n) 
    oPrint:Say(nLin,1100, "" , oFont06n)
    oPrint:Say(nLin,1330, aRacaCor[1][nCor] , oFont06n) 
    oPrint:Say(nLin,1600, iif(SRA->RA_SEXO = "M","MASCULINO","FEMININO") , oFont06n)   
    oPrint:Say(nLin,1900, LEFT(cGrauInstru,32) , oFont06n)
     
    nLinAnt:=nLin+50 
    nLinant2:=nLinAnt  
    nLinAnt:=nLinAnt-100
    ImpBox(oPrint,nLinAnt,1090,(nLin+50), 1090,2)
    ImpBox(oPrint,nLinAnt,1320,(nLin+50), 1320,2) 
    ImpBox(oPrint,nLinAnt,1590,(nLin+50), 1590,2) 
    ImpBox(oPrint,nLinAnt,1890,(nLin+50), 1890,2) 
    nLinAnt:=nLinAnt
    
    nLin:=nLin+50      
    nLinAdm:=nLin-10
    oPrint:Say(nLin,550 , "Função" , oFont06n) 
    oPrint:Say(nLin,900, "CBO" , oFont06n) 
    oPrint:Say(nLin,1050, "   Salário" , oFont06n)
    oPrint:Say(nLin,1200, "Forma Pagto" , oFont06n) 
    oPrint:Say(nLin,1500, "Hs. Entrada" , oFont06n)   
    oPrint:Say(nLin,1700, "Saida Reifeição" , oFont06n)
    oPrint:Say(nLin,1900, "Retorno Refeição" , oFont06n)
    oPrint:Say(nLin,2150, "Saída do Trabalho" , oFont06n) 
     
    nLin:=nLin+30
    oPrint:Say(nLin,550 , cCargo_Funcao , oFont06n) 
    oPrint:Say(nLin,900, cCBO , oFont06n) 
    oPrint:Say(nLin,1000, transform(SRA->RA_SALARIO,"@e 999,999,999.99"), oFont06n)
    oPrint:Say(nLin,1220, cFormPagto , oFont06n) 
    oPrint:Say(nLin,1520, cEntrada1, oFont06n)   
    oPrint:Say(nLin,1720, cSaida1 , oFont06n)
    oPrint:Say(nLin,1920, cEntrada2 , oFont06n)
    oPrint:Say(nLin,2200, cSaida2 , oFont06n)
     
    nLin:=nLin+40 
    nLinAnt3:=(nLin+110)
    ImpBox(oPrint,nLinAnt2,530,(nLin+110), 2380,2)         
    ImpBox(oPrint,nLin,530,nlin, 2380,2) 
    nLinAnt:=nLin
      
    ImpBox(oPrint,nLinAnt2,890,nLin, 890,2)
    ImpBox(oPrint,nLinAnt2,990,nLin, 990,2) 
    ImpBox(oPrint,nLinAnt2,1190,nLin, 1190,2) 
    ImpBox(oPrint,nLinAnt2,1490,nLin, 1490,2) 
    ImpBox(oPrint,nLinAnt2,1690,nLin, 1690,2) 
    ImpBox(oPrint,nLinAnt2,1890,nLin, 1890,2) 
    ImpBox(oPrint,nLinAnt2,2140,nLin, 2140,2) 
    nLinAnt:=nLin
    
    nLin:=nLin+20
    oPrint:Say((nLin+30),550 , "FGTS" , oFont06n) 
    oPrint:Say(nLin,670, "Dt.de Opção" , oFont06n) 
    oPrint:Say(nLin,900, "Conta Vinculada no Banco" , oFont06n)
    oPrint:Say(nLin,2000, "Data de Retificação" , oFont06n)  
    
    nLin:=nLin+30
    oPrint:Say(nLin,670,  LEFT(DTOC(SRA->RA_OPCAO),6)+LEFT(DTOS(SRA->RA_OPCAO),4) , oFont07n) 
             
    ImpBox(oPrint,nLinAnt,650,nLinAnt3, 650,2)
    ImpBox(oPrint,nLinAnt,890,nLinAnt3, 890,2) 
    ImpBox(oPrint,nLinAnt,1990,nLinAnt3, 1990,2) 
          
    // *** Data de Admissão *** //
    ImpBox(oPrint,(nLinAdm+20),120,nLinAnt3, 500,2) 
    oPrint:Say((nLin-70),200 , "Dt.Admissão" , oFont06n) 
    oPrint:Say((nLin-30),200 ,  LEFT(DTOC(SRA->RA_ADMISSA),6)+LEFT(DTOS(SRA->RA_ADMISSA),4) , oFont07n) 
    
    nLin:=nLinAnt3+30
    nLinAnt3:=nLin+300
    ImpBox(oPrint,nLin,120,(nlin+300), 2380,2) 
    
    nLin:=nLin+30
    oPrint:Say(nLin,700  , "PROGRAMA DE INTEGRAÇÃO SOCIAL - PIS",oFont12N) 
    
    nLin:=nLin+60 
    nLinAnt:=nLin
    ImpBox(oPrint,nLin,120,nLin, 2380,2) 
    
    nLin:=nLin+20
    oPrint:Say(nLin,150 , "Cadastrado em" , oFont06n)
    oPrint:Say(nLin,350 , "Sob Número" , oFont06n) 
    oPrint:Say(nLin,600 , "Domicilio Bancário" , oFont06n) 
    
    nLin:=nLin+30 
    oPrint:Say(nLin,150 , "" , oFont06n)
    oPrint:Say(nLin,350 , SRA->RA_PIS, oFont06n) 
    oPrint:Say(nLin,600 , "" , oFont06n)
    
    nLin:=nLin+40 
    ImpBox(oPrint,nLin,120,nLin, 2380,2)
    
    ImpBox(oPrint,nLinAnt,340,nLin,340,2)
    ImpBox(oPrint,nLinAnt,590,nLin, 590,2) 
    
    
    nLin:=nLin+20
    oPrint:Say(nLin,150 , "Núm.do Banco" , oFont06n)
    oPrint:Say(nLin,350 , "Código da Agência" , oFont06n) 
    oPrint:Say(nLin,600 , "Endereço da Agência" , oFont06n) 
    
    nLin:=nLin+30 
    oPrint:Say(nLin,150 , "" , oFont06n)
    oPrint:Say(nLin,350 , "", oFont06n) 
    oPrint:Say(nLin,600 , "" , oFont06n) 
    
    ImpBox(oPrint,nLinAnt,340,nLinAnt3,340,2)
    ImpBox(oPrint,nLinAnt,590,nLinAnt3, 590,2)         
    
    // ***
    nLin:=nLinAnt3+30
    nLinAnt3:=nLin+600
    ImpBox(oPrint,nLin,120,(nlin+600), 2380,2)
    ImpBox(oPrint,nLin,760,nLinAnt3, 760,2) 
    ImpBox(oPrint,nLin,1540,nLinAnt3, 1540,2)
    ImpBox(oPrint,nLin,1790,nLinAnt3, 1790,2)
    
    nLin:=nLin+30
    oPrint:Say(nLin,150  , "ALTERAÇÃO DE SALÁRIOS E/OU FUNÇÃO",oFont06N)
    oPrint:Say(nLin,800  , "FÉRIAS",oFont06N)
    oPrint:Say(nLin,1550  , "Contribuição Sindical",oFont05N) 
    oPrint:Say(nLin,1800  , "Acidente de Trabalho ou Doenças Profissionais",oFont06N) 
    
    nLin:=nLin+60 
    nLinAnt:=nLin
    ImpBox(oPrint,nLin,120,nLin, 2380,2)
    nLin:=nLin+20
    
    // *** Histórico Salarial *** //
    DbSelectarea("SR7")
    cAreaSR7:=GETAREA()
    DBSETORDER(1)
    SR7->(dbseek(SRA->RA_FILIAL+SRA->RA_MAT))
    do While .not. eof()
       
       if SR7->R7_FILIAL+SR7->R7_MAT = SRA->RA_FILIAL+SRA->RA_MAT
       
          cTexto:=LEFT(DTOC(SR7->R7_DATA),6)+LEFT(DTOS(SR7->R7_DATA),4) 
          
          // *** Pega Descrição da Alteração Salarial *** //
    	  DbSelectarea("SX5")
	      cAreaSX5:=GETAREA()
	      DBSETORDER(1)
	      SX5->(dbseek(xfilial("SX5")+"41"+SR7->R7_TIPO))
	      if .not. eof() 
	         cTexto:=cTexto+"-"+alltrim(left(SX5->X5_DESCRI,20))
	      endif
	      Restarea(cAreaSX5) 
	      
	      DbSelectarea("SR3")
	      cAreaSR3:=GETAREA()
	      DBSETORDER(1)
	      SR3->(dbseek(SR7->R7_FILIAL+SR7->R7_MAT+DTOS(SR7->R7_DATA)+SR7->R7_TIPO))
	      if .not. eof() 
	         nValor__:=SR3->R3_VALOR
	      endif
	      Restarea(cAreaSR3) 
	      
	      cTexto:=alltrim(cTexto)+"-"+alltrim(SR7->R7_DESCFUN)
	      oPrint:Say(nLin,130 , cTexto , oFont04n)
	      oPrint:Say(nLin,640 , TRANSFORM(nValor__,"@E 999,999,999.99"), oFont04C)
	      nLin:=nLin+20
	   endif  
	      
	   DbSelectarea("SR7")
	   dbskip()
	   if .not. eof() .and. SR7->R7_FILIAL+SR7->R7_MAT = SRA->RA_FILIAL+SRA->RA_MAT
	      loop
	   endif
	   exit
	enddo 
	RESTAREA(cAreaSR7)   
          
    
    // *** Período de Férias *** //  
    nLin:=nLinAnt+20 
    oPrint:Say(nLin,800 , "Período Aquiditivo" , oFont04n)
    oPrint:Say(nLin,1100 , "Período de Gozo" , oFont04n) 
    oPrint:Say(nLin,1400 , "Dias Férias" , oFont04n) 
    
    nLin:=nLinAnt+40 
    ImpBox(oPrint,nLin,760,nLin, 1540,2)   
    ImpBox(oPrint,nLin,1090,nLinAnt3, 1090,2) 
    ImpBox(oPrint,nLin,1390,nLinAnt3, 1390,2) 
    nLin:=nLinAnt+40  
    
                      
    // *** Períodos de Férias *** //
    DbSelectarea("SRH")
    cAreaSRH:=GETAREA()
    DBSETORDER(1)
    SRH->(dbseek(SRA->RA_FILIAL+SRA->RA_MAT))
    do While .not. eof()
       
       if SRH->RH_FILIAL+SRH->RH_MAT = SRA->RA_FILIAL+SRA->RA_MAT 
          
          // ** Período Aquisitivo *** // 
          cData1:=LEFT(DTOC(SRH->RH_DATABAS),6)+LEFT(DTOS(SRH->RH_DATABAS),4)
          cData1:=cData1+" À "+LEFT(DTOC(SRH->RH_DBASEAT),6)+LEFT(DTOS(SRH->RH_DBASEAT),4) 
          
          // ** Período de Gozo de Férias *** //
          cData2:=LEFT(DTOC(SRH->RH_DATAINI),6)+LEFT(DTOS(SRH->RH_DATAINI),4)
          cData2:=cData2+" À "+LEFT(DTOC(SRH->RH_DATAFIM),6)+LEFT(DTOS(SRH->RH_DATAFIM),4)
          
          oPrint:Say(nLin,800 , cData1 , oFont04n)
          oPrint:Say(nLin,1100 , cData2 , oFont04n) 
          oPrint:Say(nLin,1400 , TRANSFORM(SRH->RH_DFERIAS,"@E 999.99") , oFont04n)
          nLin:=nLin+20
       Endif
       
       // ***
       DbSelectarea("SRH")
	   dbskip()
	   if .not. eof() .and. SRH->RH_FILIAL+SRH->RH_MAT = SRA->RA_FILIAL+SRA->RA_MAT
	      loop
	   endif
	   exit
	enddo 
    Restarea(cAreaSRH)
    
    
    // *** Contribuição Sindical *** // 
    nLin:=nLinAnt+20 
    DbSelectarea("SRD")
    cAreaSRD:=GETAREA()
    DBSETORDER(1)
    SRD->(dbseek(SRA->RA_FILIAL+SRA->RA_MAT))
    do While .not. eof()
       
       if SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_PD = SRA->RA_FILIAL+SRA->RA_MAT+"460" 
          
          // ** Valor da Contribuição *** // 
          cData1:=SUBSTR(SRD->RD_DATARQ,5,2)+"/"+SUBSTR(SRD->RD_DATARQ,1,4)
          oPrint:Say(nLin,1590 , cData1+"  -  "+TRANSFORM(SRD->RD_VALOR,"@E 999,999.99") , oFont04n)
          nLin:=nLin+20
          
       Endif
       
       // ***
       DbSelectarea("SRD")
	   dbskip()
	   if .not. eof() .and. SRD->RD_FILIAL+SRD->RD_MAT = SRA->RA_FILIAL+SRA->RA_MAT
	      loop
	   endif
	   exit
	enddo 
    Restarea(cAreaSRD)
              
             
    // *** Acidente de Trabalho *** //     
    nLin:=nLinAnt+20
    DbSelectarea("SR8")
    cAreaSR8:=GETAREA()
    DBSETORDER(1)   
    SR8->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
    do While .not. eof()
       
       if SR8->R8_FILIAL+SR8->R8_MAT = SRA->RA_FILIAL+SRA->RA_MAT
                                    
          cTexto:=""
          if SR8->R8_TIPO $"9/O/P/S/Q"   
          
             // *** Pega Descrição da Alteração Salarial *** //
    	     DbSelectarea("SX5")
	         cAreaSX5:=GETAREA()
	         DBSETORDER(1)
	         SX5->(dbseek(xfilial("SX5")+"30"+SR8->R8_TIPO))
	         if .not. eof() 
	            cTexto:=alltrim(left(SX5->X5_DESCRI,20))
	         endif
	         Restarea(cAreaSX5)
                             
             cData1:=SUBSTR(DTOS(SR8->R8_DATAINI),5,2)+"/"+SUBSTR(DTOS(SR8->R8_DATAINI),1,4) 
             cData1:=cData1+"  À  "+SUBSTR(DTOS(SR8->R8_DATAFIM),5,2)+"/"+SUBSTR(DTOS(SR8->R8_DATAFIM),1,4)
                            
             cTexto:=SR8->R8_TIPO+"-"+cTexto+"  -  Período de  "+cData1
             oPrint:Say(nLin,1800 , cTexto , oFont04n)
             nLin:=nLin+20
          endif
           
       endif
    
       // ***
       DbSelectarea("SR8")
	   dbskip()
	   if .not. eof() .and.  SR8->R8_FILIAL+SR8->R8_MAT = SRA->RA_FILIAL+SRA->RA_MAT
	      loop
	   endif
	   exit
	enddo 
    Restarea(cAreaSR8)
    
    
    nLin:=nLinAnt3+30
    nLinAnt3:=nLin+550
    ImpBox(oPrint,nLin,120,nLinAnt3, 1600,2)
    ImpBox(oPrint,nLin,850,nLinAnt3, 850,2) 
    ImpBox(oPrint,(nLinAnt3-275),120,(nLinAnt3-275), 850,2)
    nLin:=nLin+40
    oPrint:Say(nLin,150 , "Rescisão de Contrato de Trabalho" , oFont08n)
    oPrint:Say(nLin,900 , "Anotar Advertências, Suspensões, etc." , oFont08n)
    
    nLin:=nLin+40 
    ImpBox(oPrint,nLin,120,nLin, 1600,2)
    nLin:=nLin+40 
    nLinInicial:=nLin 
    
    
    // *** Pega Dados de Rescisão Contratual *** //
    DbSelectarea("SRG")
	cAreaSRG:=GETAREA()
	DBSETORDER(1)
	SRG->(dbseek(SRA->RA_FILIAL+SRA->RA_MAT))
	if .not. eof() 
	
       nLin:=nLin+40 
       cTexto:=""
       cData1:=SUBSTR(DTOS(SRG->RG_DATADEM),5,2)+"/"+SUBSTR(DTOS(SRG->RG_DATADEM),1,4) 
       oPrint:Say(nLin,170 , "Data de Saída:   "+cData1 , oFont04n)
                  
    
       // *** Pega Descrição da Alteração Salarial *** //
       DbSelectarea("SRX")
	   cAreaSRX:=GETAREA()
	   DBSETORDER(1)
	   SRX->(dbseek(xfilial("SRX")+"32"+SRG->RG_TIPORES))
	   if .not. eof() 
	      cTexto:=SRG->RG_TIPORES+"-"+alltrim(left(SRX->RX_TXT,27))
	   endif
	   Restarea(cAreaSRX)
	   
	   nLin:=nLin+200
	   oPrint:Say(nLin,170 , "Tipo de Desligamento:   "+cTexto , oFont04n)
    endif
    RestArea(cAreaSRG)
    
    // *** Linha de Observações *** //
    nLin:=nLinInicial
    oPrint:Say(nLin,860, cObs1, oFont06n)
      
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs2, oFont06n) 
      
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs3, oFont06n)
      
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs4, oFont06n) 
    
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs5, oFont06n)
    
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs6, oFont06n)
    
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs7, oFont06n) 
    
    nLin:=nLin+50
    oPrint:Say(nLin,860, cObs8, oFont06n)
    nLin:=nLin+50
        
    // ***
    nLin:=nLinInicial+200
    oPrint:Say(nLin,1700  , "_______________________________" , oFont09)  
   
    nLin:=nLin+60
    oPrint:Say(nLin,1700  , PADC(ALLTRIM(CAPITAL((cAliasA)->RA_NOME)),40), oFont09) 
   
   
                                                
    // *** 
    dbSelectArea("SRA") 
    SRA->(dbskip())     
Enddo 
Restarea(aAreaAlias)

// ---
oPrint:EndPage()
oPrint:Preview()
Return 
   
/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |QebPagina()       |Autor|Valdemir Miranda | Data |15/04/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Quebra de Página                                 	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/ 
Static Function QebPagina2()
Set Century On

// ***
oPrint:EndPage() 
cFig := GetSrvProfString("StartPath","")
cfig2:= GetSrvProfString("StartPath","") 
cFig :=cFig+"logoabix.JPG" 
cFig2:=cfig2+"logoabix.JPG"       
oPrint:StartPage() 		// Inicia uma nova pagina
	  	     
// ... Desenha Quadro Principal ... //
ImpBox(oPrint,60,100, 3400, 2400,6) 

// ... Imprime Logotipo ... //  
oPrint:SayBitmap(100,170,cFig,300,200)  

// *** Imprime Documento *** //
nLin:=200 
ImpBox(oPrint,80,120, (nLin+150), 500,6)
ImpBox(oPrint,80,120, (nLin+150), 2380,6)
ImpBox(oPrint,80,2100, (nLin+150), 2100,6)
oPrint:Say((nLin-50),2150  , "No." , oFont14N) 
oPrint:Say(nLin,900  , "F I C H A   D E   R E G I S T R O" , oFont16N) 
oPrint:Say(nLin,2150  , SRA->RA_MAT , oFont14N)
nLin:=nLin+40

Return
   

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |ImpBox ()         |Autor|Valdemir Miranda | Data |15/04/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Imprime um box simulando o negrito               	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function ImpBox(oObj,nLin,nCol,nLinF,nColF,nPixel)
Local nwnk 
For nwnk := 1 to nPixel
	oObj:Box(nLin,nCol,nLinF,nColF)
	nLin++
	nCol++
	nLinF--
	nColF--
Next

Return    


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |PgaHrTrab()       |Autor|Valdemir Miranda | Data |22/05/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Captura Horário de Trabalho                      	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/ 
Static Function PgaHrTrab()
   Dbselectarea("SPJ")
   DBSETORDER(1)
   Set Filter to PJ_TURNO = SRA->RA_TNOTRAB
   DBGOTOP() 
   if .not. eof()
      do while .not. eof()
         if SPJ->PJ_DIA $"2/3/4/5/6" 
            cEntrada1:=STR(SPJ->PJ_ENTRA1,5,2)
            cSaida1  :=STR(SPJ->PJ_SAIDA1,5,2)
            cEntrada2:=STR(SPJ->PJ_ENTRA2,5,2)
            cSaida2  :=STR(SPJ->PJ_SAIDA2,5,2)
         endif
         
         // *** 
         if val(STR(SPJ->PJ_SAIDA2,5,2)) > val(cSaida2) 
            cSaida2  :=STR(SPJ->PJ_SAIDA2,5,2)
         endif 
         
         dbskip()
         if .not. eof()
            if SPJ->PJ_TURNO = (cAliasA)->RA_TNOTRAB
               LOOP
            endif
         endif
         exit
      enddo
   endif
   restarea(cArea2)                  
Return     

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |AbGpeImpBenef()   |Autor|Valdemir Miranda | Data |27/05/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Imprime Beneficiários                            	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/                                                                           
Static Function AbGpeImpBenef()

// ***
aTpBeneficio:={} 
wPesqSRB    :=""
dbselectarea("RHL")
cAreaRHL:=getarea()
dbsetorder(1)
DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT)
Do while .not. eof()
    
    wPesqSRB:=RHL->RHL_FILIAL+RHL->RHL_MAT  
    aAdd(aTpBeneficio,{iif(RHL->RHL_TPFORN = "1","ASSISTÊNCIA MÉDICA","ASSISTÊNCIA ODONTOLÓGICA")})
    
    dbskip()
    if .not. eof() .or. RHL->RHL_FILIAL+RHL->RHL_MAT = SRA->RA_FILIAL+SRA->RA_MAT  
       LOOP
    endif
    exit
Enddo
RestArea(cAreaRHL)

// ***
ky1:=1
wPesqSRB:=SRA->RA_FILIAL+SRA->RA_MAT  
DBSELECTAREA("SRB")
cAreaSRB:=GetArea()
DBSETORDER(1)
dbseek(wPesqSRB)
Do while .not. eof() 
           
   if SRB->RB_FILIAL+SRB->RB_MAT = wPesqSRB
      wTpBenef:=iif(len(aTpBeneficio) > 0, aTpBeneficio[ky1][1],"")
      oPrint:Say(nLinBenefic,1350 , SRB->RB_NOME, oFont07n) 
      oPrint:Say(nLinBenefic,2000 , wTpBenef, oFont07n) 
      nLinBenefic:=nLinBenefic+40
   endif
   
   DBSKIP()
   if .not. eof() .or. SRB->RB_FILIAL+SRB->RB_MAT = wPesqSRB
     ky1:=ky1+1
     loop
   endif
Enddo
RestArea(cAreaSRB)
  
// ***
wPesqSRQ:=SRA->RA_FILIAL+SRA->RA_MAT
DBSELECTAREA("SRQ")
cAreaSRQ:=GetArea()
DBSETORDER(1)
dbseek(wPesqSRQ)
Do while .not. eof()

   oPrint:Say(nLinBenefic,1350 , SRQ->RQ_NOME, oFont07n) 
   oPrint:Say(nLinBenefic,2000 , "PENSÃO ALIMENTÍCIA", oFont07n) 
   nLinBenefic:=nLinBenefic+40
   
   DBSKIP()
   if .not. eof() .or. SRQ->RQ_FILIAL+SRQ->RQ_MAT = wPesqSRQ
     ky1:=ky1+1
     loop
   endif
Enddo
RestArea(cAreaSRQ)
Return
   
   
       