#INCLUDE "PROTHEUS.CH" 
#Include "TOPCONN.CH" 
#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER06 | Autor | Valdemir Miranda      | Data |25/07/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de Relatórios de Aviso Prévio                    |||  
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
User Function  ABGPER06()                             

Local cTitulo:= "Relatórios de Aviso Prévio"     //Ver  Horizontal 
Private oDlg
Private _oDlg 
Private cObs1:=SPACE(50) 
Private cObs2:=SPACE(50) 
Private cObs3:=SPACE(50)  
Private cObs4:=SPACE(50)  
Private oObs1
Private oObs2
Private oObs3
Private oObs4
 
Private cCargo_Funcao:=""

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 200,800 PIXEL                                                                         //  ,16777215
   
   @ 10, 10 SAY "01-Aviso Prévio Trabalhado com Reddução de 2 horas com Dados do Comparecimento Sem justa Causa" SIZE 500, 10 OF oDlg COLORS 5 PIXEL
   @ 10, 370 BMPBUTTON TYPE 09 ACTION ABGPR06A("01") 
   
   @ 30, 10 SAY "02-Aviso Previo Trabalhado com Redução de 7 Dias, sem dados de Comparecimento e sem Justa Causa" SIZE 500, 10 OF oDlg COLORS 5 PIXEL
   @ 30, 370 BMPBUTTON TYPE 09 ACTION ABGPR06A("02")
   
   @ 50, 10 SAY "03-Aviso Prévio Trabalhado sem Opção de Dados do Comparecimento com opção de Reddução de 2 horas ou 7 dias Corridos Sem justa Causa" SIZE 500, 10 OF oDlg COLORS 5 PIXEL
   @ 50, 370 BMPBUTTON TYPE 09 ACTION ABGPR06A("03")
   
   @ 70, 10 SAY "04-Aviso Prévio Indenizado com Dados de Comparecimento e Sem justa Causa" SIZE 500, 10 OF oDlg COLORS 5 PIXEL
   @ 70, 370 BMPBUTTON TYPE 09 ACTION ABGPR06A("04") 
   
   @ 90, 10 SAY "05-Aviso Prévio Indenizado sem Dados de Comparecimento e Sem justa Causa" SIZE 500, 10 OF oDlg COLORS 5 PIXEL
   @ 90, 370 BMPBUTTON TYPE 09 ACTION  ABGPR06C()  
   

ACTIVATE MSDIALOG oDlg CENTERED


Return


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPR006 | Autor | Valdemir Miranda      | Data |25/07/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de Relatórios de Aviso Prévio                    |||  
|||          |                                                            |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
         
Static Function ABGPR06A(cOpc01)

Local aAREA    		:=GETAREA()                   
Local nLastKey 		:=0  
Local cMSG	   		:=""
Private	          oPrint 
Private cOpcao01	:=cOpc01  
Private cMSGTITULO	:=""
 
// ... Inicializa Parametros ...     
ABGPEGPAR()

// ...
If !Pergunte("ABGPR006",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif 

// *** Tipos de Relatórios *** //
if cOpcao01 = "01"
   cMSG:="Aviso Prévio Trabalhado com Reddução de 2 horas com Dados do Comparecimento Sem justa Causa" 
   cMSGTITULO:="AVISO PRÉVIO DO EMPREGADOR PARA DISPENSA DO EMPREGADO"
elseif cOpcao01 = "02"
   cMSG:="Aviso Previo Trabalhado com Redução de 7 Dias, sem dados de Comparecimento e sem Justa Causa"  
   cMSGTITULO:="AVISO PRÉVIO DO EMPREGADOR PARA DISPENSA DO EMPREGADO"
elseif cOpcao01 = "03" 
   cMSG:="Aviso Prévio Trabalhado sem Opção de Dados do Comparecimento com opção de Reddução de 2 horas ou 7 dias Corridos Sem justa Causa"
   cMSGTITULO:="AVISO PRÉVIO DO EMPREGADOR PARA DISPENSA DO EMPREGADO"
elseif cOpcao01 = "04"
   cMSG:="Aviso Prévio Trabalhado com Reddução de 2 horas sem Dados de Comparecimento e Sem justa Causa"
   cMSGTITULO:="AVISO PRÉVIO DO EMPREGADOR INDENIZADO"
elseif cOpcao01 = "05"
   cMSG:="Aviso Prévio Indenizado com Dados de Comparecimento e Sem justa Causa" 
   cMSGTITULO:="AVISO PRÉVIO DO EMPREGADOR INDENIZADO"
elseif cOpcao01 = "06"
   cMSG:="Aviso Prévio Indenizado sem Dados de Comparecimento e Sem justa Causa"
endif   
             
Processa({||ABGPR06B() },cMSG+time() )  
Restarea(aAREA)

RETURN  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |ABGPERPAR()    | Autor | Valdemir Miranda | Data |25/07/2013|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato                    	        	  |||  
|||          | 					                                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | ABGPEGPAR()                                                |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPEGPAR()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPR006",10)
Local aRegs 	:={}                       
Local nX  

aAdd(aRegs,{"Filial De ?"		,"¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"C.Custo De ?"		,"¨Forneced. De?","From Bank ?","mv_ch3","C",9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.Custo Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch4","C",9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Matricula De ?"	,"¨Forneced. De?","From Bank ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula Ate?"	,"¨Forneced.Ate?","From Bank ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})      
aAdd(aRegs,{"Data do Aviso"  	,"¨Forneced.Ate?","From Bank ?","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})      

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
|||Programa  |ABGPR06B()        |Autor|Valdemir Miranda | Data |25/07/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Sistema de Emissão de Contrato de Experiência     	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPR06B() 
  
Local cQry 			:=""  
Local nhandle		:=0
Local cCepPJConv	:=""  
Local cEstaFornec  	:=""
Local aAreaAlias	:=GETAREA() 
Local cArquivo 		:=""   
Local cDataExt1   	:=""
Local cDataExt2   	:=""  
Private  cAliasA	:="" 
Private oFont08  	:= TFont():New("Verdana",08,08,,.F.,,,,.F.,.F.)   		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08n  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont11	   	:= TFont():New("Verdana",09,09,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont11N 	:= TFont():New("Verdana",09,09,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont12N 	:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont16N 	:= TFont():New("Verdana",16,16,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //

// ... Inicia uma nova pagina da TMSPRINTER ... //
oPrint:= TMSPrinter():New("Emissão do Distrato - Termo de Rescisão Contratual ")
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
   
   // *** Pega Descrição da Função *** // 
   dbselectarea("RCE")
   cxArea:=getarea()
   cSindicato:="" 
   cEndereco :=""   
   cPesqRCE	 :=SRA->RA_FILIAL+SRA->RA_SINDICA
   DBSETORDER(1)
   DBSEEK(cPesqRCE)
   DBGOTOP()
   if .not. eof()         
     cSindicato:=left(RCE->RCE_DESCRI,23)
     cEndereco:=SUBSTR(RCE->RCE_DESCRI,24,7)+", "+RCE->RCE_ENDER+", "+RCE->RCE_NUMER+", "+RCE->RCE_COMPLE+", "+RCE->RCE_MUNIC+"-"+RCE->RCE_UF  
   endif
   restarea(cxArea)   
     
   // ***
   dbSelectArea(cAliasA) 
  
   // *** Imprime Moldura e Inicia uma Nova Página *** //
   QebPagina()
   
   // *** Imprime Documento *** //
   nLin:=600    
   oPrint:Say(nLin,600  , cMSGTITULO , oFont12N)
   nLin:=nLin+300 
   
   cCNPJ:=left(SM0->M0_CGC,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2)
   oPrint:Say(nLin,350  ,ALLTRIM(SM0->M0_NOMECOM) , oFont08) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350,cCNPJ, oFont08) 
   
   nLin:=nLin+200 
   if SRA->RA_SEXO = "F"
      oPrint:Say(nLin,350,"Á", oFont08)
   else
      oPrint:Say(nLin,350,"Ao", oFont08)
   endif
   
   nLin:=nLin+60
   if SRA->RA_SEXO = "F"
      oPrint:Say(nLin,350,"Sra. "+SRA->RA_NOME, oFont08)
   else
      oPrint:Say(nLin,350,"Sr. "+SRA->RA_NOME, oFont08)
   endif
   nLin:=nLin+60
   oPrint:Say(nLin,350,"C.T.P.S.", oFont08)
   oPrint:Say(nLin,500,": "+SRA->RA_NUMCP+"  Série: "+SRA->RA_SERCP, oFont08)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350,"PIS", oFont08)  
   oPrint:Say(nLin,500,": "+TRANSFORM(SRA->RA_PIS,"@R 999.99999.99-99"), oFont08) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350,"Admissão", oFont11)
   oPrint:Say(nLin,500,": "+substr(dtoc(SRA->RA_ADMISSA),1,6)+LEFT(DTOS(SRA->RA_ADMISSA),4), oFont08)
   
   nLin:=nLin+200
   cdias:="33"  
   if cOpcao01 = "01" .or. cOpcao01 = "02" .or. cOpcao01 = "03"  
      oPrint:Say(nLin,350  , "Pelo presente notificação que a "+cdias+" dias contados após a data da entrega deste,  não mais serão utilizados os seus serviços pela" , oFont08) 
   
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "nossa empresa, e por isso vimos avisá-lo nos termos e para os efeitos do disposto no art. 487-itens - I e II -Cap.VI - Título IV," , oFont08)  
   
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "do Decreto Lei no. 5.452, de 01 de Maio de 1943 da  CONSOLIDAÇÃO DAS LEIS DO TRABALHO." , oFont08) 
       
   elseif cOpcao01 = "04" .or. cOpcao01 = "05"
     
      oPrint:Say(nLin,350  , "Por não mais convir a esta empresa mantê-lo em nosso quadro de empregados, vimos comunicar-lhe que decidimos  rescindir, a" , oFont08) 
   
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "partir desta data, seu contrato de trabalho em vigor desde "+left(dtoc(SRA->RA_ADMISSA),6)+SUBSTR(DTOS(SRA->RA_ADMISSA),1,4)+"." , oFont08)  
   
   endif
   
   if cOpcao01 = "01" .or. cOpcao01 = "03"                
      nLin:=nLin+100
      oPrint:Say(nLin,350  , "Até o término do Aviso Prévio,  por força do artigo 488 da CLT V.Sa. terá seu horário de trabalho  reduzido  de duas horas diárias" , oFont08)
    
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "sem prejuízo de seu salário, a fim de procurar outro emprego. Nessas condições, sua jornada  de  trabalho  terminará duas horas" , oFont08)
            
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "antes do horário normalmente previsto. Caso V.Sa.  resolva  optar pela faculdade do parágrafo único do art. 488 (jornada normal," , oFont08)
    
      nLin:=nLin+60
      oPrint:Say(nLin,350  , " com redução de 7 dias de trabalho no final  do  aviso),  solicitamos formalizar esta intenção." , oFont08)
   endif
   
   if cOpcao01 = "02"               
      nLin:=nLin+100
      oPrint:Say(nLin,350  , "Até o término do Aviso Prévio, V.Sa. terá uma redução no seu horário de trabalho, sem prejuízo de seu salário  integral, sendo-", oFont08)
    
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "lhe facultada, de acordo com a CONSOLIDAÇÃO DAS LEIS DO TRABALHO, artigo 488, parágrafo único,  a  opção  por  uma  das" , oFont08)
            
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "seguintes alternativas:" , oFont08)
    
   endif  
   
   if cOpcao01 = "02"
   
      nLin:=nLin+100
      oPrint:Say(nLin,350  , "( __ ) Redução de 02(duas) horas diaárias em seu horário normal de trabalho; ou" , oFont08)
   
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "( __ ) Redução de 7 (sete) dias corridos." , oFont08) 
      
      nLin:=nLin+100
      oPrint:Say(nLin,350  , "O empregado declara que exerceu e está ciente da opção acima realizada, situação em que comprirá o respectivo Aviso Prévio." , oFont08)
      
   endif  
   
   if cOpcao01 = "01" .or. cOpcao01 = "04"
      nLin:=nLin+100
      oPrint:Say(nLin,350  , "Solicitamos seu comparecimento, de posse da Carteira de  Trabalho  e  Previdencia  Social,  ao  sindicato "+left(cSindicato,19) , oFont08)  
      
      nLin:=nLin+60   
      cSind01:=SUBSTR(cSindicato,20,10)
      oPrint:Say(nLin,350  , cSind01+" "+cEndereco+", para  dar  cumprimento  ás   formali-" , oFont08)
      
      nLin:=nLin+60
      oPrint:Say(nLin,350  , "dades exigidas para a Rescisão de Contrato de Trabalho." , oFont08)
   endif
   
   if cOpcao01 = "02" .or. cOpcao01 = "03"     
      nLin:=nLin+150
      oPrint:Say(nLin,350  , "Solicitamos a devolução do presente com o seu CIENTE." , oFont08)
      
   endif 
   
   if cOpcao01 = "05"      
      nLin:=nLin+200
      oPrint:Say(nLin,350  , "Observação:" , oFont08)  
      oPrint:Say(nLin,500, cObs1, oFont08)
      
      nLin:=nLin+60
      oPrint:Say(nLin,500, cObs2, oFont08) 
      
      nLin:=nLin+60
      oPrint:Say(nLin,500, cObs3, oFont08)
      
      nLin:=nLin+60
      oPrint:Say(nLin,500, cObs4, oFont08)
   endif
   
   nLin:=nLin+250     
   Pergunte("ABGPR006",.F.)          
   cDataExt1   :=substr( dtos(mv_par07),7,2) +" de "+   MESEXTENSO(val(substr( dtos(mv_par07),5,2)))  +" de "+ substr( dtos(mv_par07),1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,350  , cDataExtenso , oFont11)
      
    
   nLin:=nLin+200
   oPrint:Say(nLin,350  , "______________________________" , oFont08)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC(ALLTRIM(CAPITAL((cAliasA)->RA_NOME)),35), oFont08) 
   
   nLin:=nLin+200
   oPrint:Say(nLin,350  , " ______________________________" , oFont08) 
   oPrint:Say(nLin,1500  , "______________________________" , oFont08) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC(ALLTRIM(SM0->M0_NOMECOM),35) , oFont08)
   oPrint:Say(nLin,1500  ,PADC("Responsável Legal(quando menor)",35), oFont08) 
   
                                                   
   // *** 
   dbSelectArea(cAliasA) 
   (cAliasA)->(dbskip())     
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
Static Function QebPagina()
Set Century On

// ***
oPrint:EndPage() 
cFig := GetSrvProfString("StartPath","")
cfig2:= GetSrvProfString("StartPath","") 
cFig :=cFig+"logoabix.JPG" 
cFig2:=cfig2+"logoabix.JPG"       
oPrint:StartPage() 		// Inicia uma nova pagina
	  	     
// ... Desenha Quadro Principal ... // 
ImpBox(oPrint,60,200, 3400, 2400,6) 

// ... Imprime Logotipo ... //
oPrint:SayBitmap(200,1100,cFig,300,200)   

Return
   


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPR06C | Autor | Valdemir Miranda      | Data |29/07/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Função para geração de Opservação                          |||  
|||          |                                                            |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function  ABGPR06C()                             

Local cTitulo:= "Inclusão de Observação"     //Ver  Horizontal 
Private _oDlg 
Private cCargo_Funcao:="" 

cObs1:=SPACE(50) 
cObs2:=SPACE(50) 
cObs3:=SPACE(50)  
cObs4:=SPACE(50) 

DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 000,000 TO 200,800 PIXEL                                                                        
   
   @ 10, 10 SAY "Observações :" SIZE 500, 10 OF _oDlg COLORS 5 PIXEL
   @ 10, 100 MSGET oObs1 VAR cObs1 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T. 
   @ 30, 100 MSGET oObs2 VAR cObs2 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @ 50, 100 MSGET oObs3 VAR cObs3 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @ 70, 100 MSGET oObs4 VAR cObs4 SIZE 300, 010 OF _oDlg COLORS 0, 16777215 PIXEL When .T.
   @ 90, 100 Button "Gerar Relatório" Size 100, 012 PIXEL OF _oDlg Action(ABGPR06A("05"))

ACTIVATE MSDIALOG _oDlg CENTERED


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
