#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER03 | Autor | Valdemir Miranda      | Data |15/04/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de DECLARAÇÃO DE DESLOCAMENTO PARA O VALE        |||  
|||          | TRANSPORTE                                                 |||
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

User Function  ABGPER03()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 
 
// ... Inicializa Parametros ...     
ABGPERPAR3()

// ...
If !Pergunte("ABGPER03",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||ABGPEAUTVT() }, "DECLARAÇÃO DE DESLOCAMENTO PARA O VALE TRANSPORTE"+time() )  
Restarea(aAREA)

Return      


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |ABGPERPAR3()   | Autor | Valdemir Miranda | Data |15/04/2013|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato                    	        	  |||  
|||          | 					                                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | ABGPERPAR3()                                               |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERPAR3()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPER03",10)
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
|||Programa  |ABGPEAUTVT()      |Autor|Valdemir Miranda | Data |15/04/2013|||
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

Static Function ABGPEAUTVT()   
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
oPrint:= TMSPrinter():New("DECLARAÇÃO DE DESLOCAMENTO PARA O VALE TRANSPORTE")
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
          
   // *** Imprime Moldura e Inicia uma Nova Página *** //
   ImpBox(oPrint,60,200, 3400, 2400,6) 
   
    // *** Imprime Documento *** //
   nLin:=200
   oPrint:Say(nLin,600  , "DECLARAÇÃO DE DESLOCAMENTO PARA O VALE TRANSPORTE" , oFont12N)
   nLin:=nLin+80 
   
   oPrint:Line(nLin,200,nLin,2400)
   nLin:=nLin+120
   
   oPrint:Say(nLin,420  , ALLTRIM(SM0->M0_NOMECOM), oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , SM0->M0_ENDCOB+", "+ALLTRIM(Capital(SM0->M0_COMPCOB)), oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , SM0->M0_BAIRCOB, oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , (CAPITAL(SM0->M0_CIDCOB))+"-"+ upper(SM0->M0_ESTCOB )+" Cep: "+left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3), oFont11N)  
   
   nLin:=nLin+200
   oPrint:Say(nLin,420  , "           De conformidade com o Decreto nº 95.247, que regulamenta  a  lei  nº 7.418,  de 16 de" , oFont11N)
   
   nLin:=nLin+60                 
   oPrint:Say(nLin,420  , "dezembro de 1985, com a alteração dada pela lei nº 7.619, de 30 de setembro de 1987, declaro" , oFont11N) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,420 ,  "meu endereço atual:" , oFont11N)   
     
   nLin:=nLin+150
   oPrint:Say(nLin,420  , SRA->RA_ENDEREC, oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , SRA->RA_BAIRRO, oFont11N)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , (UPPER(SRA->RA_MUNICIP))+"-"+ upper(SRA->RA_ESTADO )+" Cep: "+left(SRA->RA_CEP,5)+"-"+substr(SRA->RA_CEP,6,3), oFont11N)  
   
   nLin:=nLin+200
   oPrint:Say(nLin,420  , "           Declaro que uso os meios de transportes abaixo para o deslocamento Residência/Tra-" , oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "balho/Residência" , oFont11N)
  
   nLin:=nLin+300
   nLinAnt:=nLin
   oPrint:Line(nLin,400,nLin,2300)
   nLin:=nLin+60
   oPrint:Say(nLin,420   ,"Linha Utilizada" , oFont11N)
   oPrint:Say(nLin,700   ,"Valor do Passe" , oFont11N) 
   oPrint:Say(nLin,1200  ,"Quantidade de Passes" ,oFont11N)
   oPrint:Say(nLin,2000  ,"Valor Diário" , oFont11N)  
  
   nLin:=nLin+60
   oPrint:Line(nLin,400,nLin,2300)
   nLin:=nLin+60
  
   // *** Impressão dos Meios de Transporte ***  //
   nValdia  :=0.00         
   nValTotal:=0.00
   DbSelectarea("SR0")
   DBSETORDER(1)
   DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT)
   if .not. eof()
      do while .not. eof()
      
         cAreax:=getarea()
         DBSELECTAREA("SRN")
         DBSETORDER(1)
         cDescriMeio:=""
         nValMeio   :=0.00 
         SRN->(dbseek(xfilial("SRN")+SR0->R0_MEIO))
         if .not. eof()
            cDescriMeio:=RN_DESC     
            nValMeio:= RN_VUNIATU
         endif
         restarea(cAreax)
         
         DbSelectarea("SR0")
         if SR0->R0_MAT == SRA->RA_MAT
           
            nValdia:= (nValMeio * SR0->R0_QDIAINF)
            oPrint:Say(nLin,420  , cDescriMeio, oFont11)
   			oPrint:Say(nLin,700  , Transform(nValMeio,"@E 99,999.99") , oFont11N) 
   			oPrint:Say(nLin,1200  , Transform(SR0->R0_QDIAINF,"@E 9999999") , oFont11N)
   			oPrint:Say(nLin,2000  , Transform(nValdia,"@E 99,999.99") , oFont11N) 
            nValTotal:=nValTotal+nValdia
            nLin:=nLin+60 
            nLin2:=nLin
         endif
         
         DbSelectarea("SR0")
         dbskip()
         if eof() .or. SR0->R0_MAT <> SRA->RA_MAT  
             
            if nValTotal > 0.00  
               oPrint:Line(nLin,400,nLin,2300)
               
		       oPrint:Line(nLinAnt,690,nLin,690)
		       oPrint:Line(nLinAnt,1190,nLin,1190)
		       oPrint:Line(nLinAnt,1990,nLin,1990)
		       nLin:=nLin+60
               
               oPrint:Say(nLin,420  , "Valor Total dos Vales ========> ", oFont11N)
               oPrint:Say(nLin,2000  , Transform(nValTotal,"@E 99,999.99") , oFont11N) 
               nValTotal:=0.00  
                
               nLin:=nLin+60
               ImpBox(oPrint,nLinAnt,400, nLin, 2300,6)
               nLin:=nLin+60
            else 
            
               // ... Desenha Quadro Principal ... //
               nLin:=nLin+60
               
               nLin:=nLin+60
   			   ImpBox(oPrint,nLinAnt,400, nLin, 2300,6)
		       oPrint:Line(nLinAnt,690,nLin,690)
		       oPrint:Line(nLinAnt,1190,nLin,1190)
		       oPrint:Line(nLinAnt,1990,nLin,1990)
		       nLin:=nLin+60
            endif 
            exit
         endif
      enddo
   endif 
   
   ImpBox(oPrint,60,200, 3400, 2400,6)  
   
   nLin:=nLin+400 
   cDatafim    := dtos(SRA->RA_ADMISSA)             
   cDataExt1   :=substr( cDatafim,7,2) +" de "+   MESEXTENSO(val(substr( cDatafim,5,2)))  +" de "+ substr( cDatafim,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,420  , cDataExtenso , oFont11N) 
   
   
   nLin:=nLin+200
   oPrint:Say(nLin,700  , "____________________________________________" , oFont11N)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(SRA->RA_NOME)),80), oFont11N)                   // 203.970.888-09
     
   nLin:=nLin+60
   cCPF := SUBSTR(SRA->RA_CIC,1,3)+"."+SUBSTR(SRA->RA_CIC,4,3)+"."+SUBSTR(SRA->RA_CIC,7,3)+"-"+SUBSTR(SRA->RA_CIC,10,2) 
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(cCPF)),80), oFont11N) 
   nLin:=nLin+60   
   
   // *** Autorização *** //
   set Century On

   // ***  Prepara uma nova página *** //
   oPrint:EndPage() 
   oPrint:StartPage() 		// Inicia uma nova pagina
	  	     
   // ... Desenha Quadro Principal ... //
   ImpBox(oPrint,60,200, 3400, 2400,6) 
   
   nLin:=500
   oPrint:Say(nLin,600  , "A U T O R I Z A Ç Ã O   D E   D E S C O N T O" , oFont16N)
  
   nLin:=nLin+400
   oPrint:Say(nLin,420  , "       Autorizo o desconto até o limite de 6% (seis por cento) do meu salário para participar como" , oFont11N)
   
   nLin:=nLin+60                 
   oPrint:Say(nLin,420  , "beneficiário de Programa Vale Transporte, comprometendo-me ainda a utilização desse benefício" , oFont11N) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,420 ,  "exclusivamente ao efeito  deslocamento  Residência - Trabalho e  Vice-Versa,  sujeitando-me  às" , oFont11N) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,420 ,  "penalidades previstas na lei." , oFont11N) 
   
   
   nLin:=nLin+300 
   cDatafim    := dtos(SRA->RA_ADMISSA)             
   cDataExt1   :=substr( cDatafim,7,2) +" de "+   MESEXTENSO(val(substr( cDatafim,5,2)))  +" de "+ substr( cDatafim,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,420  , cDataExtenso , oFont11N)   
   
   nLin:=nLin+400
   oPrint:Say(nLin,700  , "____________________________________________" , oFont11N)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(SRA->RA_NOME)),80), oFont11N) 
    
   nLin:=nLin+60
   oPrint:Say(nLin,700  , PADC(ALLTRIM(CAPITAL(cCPF)),80), oFont11N) 
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

