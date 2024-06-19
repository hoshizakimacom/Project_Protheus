#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER04 | Autor | Valdemir Miranda      | Data |21/05/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição |DECLARAÇÃO DE RENUNCIA DO VALE TRANSPORTE                   |||  
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

User Function  ABGPER04()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 
 
// ... Inicializa Parametros ...     
ABGPERPAR4()

// ...
If !Pergunte("ABGPER04",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||ABGPERENVT() }, "DECLARAÇÃO DE RENUNCIA DO VALE TRANSPORTE"+time() )  
Restarea(aAREA)

Return      


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |ABGPERPAR4()   | Autor | Valdemir Miranda | Data |15/04/2013|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato                    	        	  |||  
|||          | 					                                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | ABGPERPAR4()                                               |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERPAR4()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPER04",10)
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
|||Programa  |ABGPERENVT()      |Autor|Valdemir Miranda | Data |21/05/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | DECLARAÇÃO DE RENUNCIA DO VALE TRANSPORTE         	      |||  
|||          | 					                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERENVT()   
Local cQry 			:=""  
Local aAreaAlias	:=GETAREA() 
Private  cAliasA	:="" 
Private oFont08  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont11	   	:= TFont():New("Verdana",09,09,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont11N 	:= TFont():New("Verdana",09,09,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont12N 	:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont16N 	:= TFont():New("Verdana",16,16,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //

// ... Inicia uma nova pagina da TMSPRINTER ... //
oPrint:= TMSPrinter():New("DECLARAÇÃO DE RENÚNCIA DO VALE TRANSPORTE")
oPrint:Setup() 


//Private  oPrint:SetLandscape() 		// *** Seleciona tipo de Impressão no Formato  Paisagem	*** //
oPrint:SetPortrait()    			// *** Seleciona tipo de Impressão no Formato Retrato      *** //
oPrint:SETPAPERSIZE(9)  // *** Seleciona tipo do Papel:  1 - Papel Carta   -   9 - A4 *** // 
cAliasA:="SRA"              

// *** Inicia uma nova pagina *** //                                   
oPrint:StartPage() 	

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
          
   // *** Imprime Moldura e Inicia uma Nova Página *** //
   ImpBox(oPrint,60,200, 3400, 2400,6)   
   
   // *** Imprime Documento *** //
   nLin:=400
   cDTADM    := dtos(SRA->RA_ADMISSA)             
   cDataAdm   :=substr(cDTADM,7,2) +" de "+   MESEXTENSO(val(substr(cDTADM,5,2)))  +" de "+ substr(cDTADM,1,4)  
   oPrint:Say(nLin,600  , "DECLARAÇÃO DE RENUNCIA DO VALE TRANSPORTE" , oFont12N)
   nLin:=nLin+400 
   
   oPrint:Say(nLin,420  , "A", oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , ALLTRIM(SM0->M0_NOMECOM), oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , alltrim(SM0->M0_ENDCOB), oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , ALLTRIM(SM0->M0_BAIRCOB)+"-"+(CAPITAL(SM0->M0_CIDCOB))+"-"+ upper(SM0->M0_ESTCOB ), oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , +"Cep: "+left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3), oFont11N)  
   
   nLin:=nLin+500
   oPrint:Say(nLin,420  , "Eu, "+SRA->RA_NOME+", portador da CTPS Nº "+ALLTRIM(SRA->RA_NUMCP)+",  Série Nº "+ALLTRIM(SRA->RA_SERCP) , oFont11N)
   
   nLin:=nLin+60                 
   oPrint:Say(nLin,420  , "empregado de "+alltrim(SM0->M0_NOMECOM)+", admitido em "+cDataAdm+", Declaro" , oFont11N) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,420 ,  "que não vou utilizar o benefício do VALE DO TRANSPORTE,  desde  já  isentando esta" , oFont11N)  
   
   
   nLin:=nLin+60
   oPrint:Say(nLin,420 ,  "empresa do pagamento deste benefício." , oFont11N)    
   
   
   
   nLin:=nLin+400
   cDataBase    := dtos(dDatabase)             
   cDataExt1   :=substr( cDataBase,7,2) +" de "+   MESEXTENSO(val(substr( cDataBase,5,2)))  +" de "+ substr( cDataBase,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,1400  , cDataExtenso , oFont11N)
   
   
   nLin:=nLin+400
   oPrint:Say(nLin,700  , "_________________________________________________" , oFont11N)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(SRA->RA_NOME)),80), oFont11N)                   
     
   nLin:=nLin+60
   cCPF := SUBSTR(SRA->RA_CIC,1,3)+"."+SUBSTR(SRA->RA_CIC,4,3)+"."+SUBSTR(SRA->RA_CIC,7,3)+"-"+SUBSTR(SRA->RA_CIC,10,2) 
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(cCPF)),80), oFont11N) 
   nLin:=nLin+60
   
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(SRA->RA_ENDEREC))+"-"+ALLTRIM(CAPITAL(SRA->RA_BAIRRO)),80), oFont11N) 
   nLin:=nLin+60
   
   cCep:=substr(SRA->RA_CEP,1,5)+"-"+substr(SRA->RA_CEP,6,3)
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(SRA->RA_MUNICIP))+"-"+ALLTRIM(SRA->RA_ESTADO)+"-"+cCep,80), oFont11N) 
   nLin:=nLin+60                                             
   
                                                  
   // *** 
   dbSelectArea("SRA") 
   SRA->(dbskip())     
Enddo        


DBSELECTAREA("SRA")
set filter to
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
oPrint:SayBitmap(100,1100,cFig,300,200)   

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

