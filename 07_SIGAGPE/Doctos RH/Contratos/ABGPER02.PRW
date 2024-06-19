#INCLUDE "PROTHEUS.CH" 
#Include "TOPCONN.CH" 
#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER02 | Autor | Valdemir Miranda      | Data |16/04/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de RECIBO DE ENTREGA DA CARTEIRA DE TRABALHO E   |||  
|||          | PREVIDENCIA SOCIAL                                         |||
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

User Function  ABGPER02()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 
 
// ... Inicializa Parametros ...     
ABGPERPAR2()

// ...
If !Pergunte("ABGPER02",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||ABGPECONT2() }, "RECIBO DE ENTREGA DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL"+time() )  
Restarea(aAREA)

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
|||Sintaxe   | ABGPERPAR2()                                               |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERPAR2()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPER02",10)
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
|||Programa  |ABGPECONT2()      |Autor|Valdemir Miranda | Data |15/04/2013|||
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

Static Function ABGPECONT2()   
Local cQry 			:=""  
Local nhandle		:=0
Local cCepPJConv	:=""  
Local cEstaFornec  	:=""
Local aAreaAlias	:=GETAREA() 
Local cArquivo 		:=""   
Local cDataExt1   	:=""
Local cDataExt2   	:=""  
Private  cAliasA	:="" 
Private oFont08  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont11	   	:= TFont():New("Verdana",09,09,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont11N 	:= TFont():New("Verdana",09,09,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont16N 	:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //

// ... Inicia uma nova pagina da TMSPRINTER ... //
oPrint:= TMSPrinter():New("RECIBO DE ENTREGA DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL")
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
   dbselectarea("SRJ")
   cxArea:=getarea()
   DBSETORDER(1)
   DBSEEK(xfilial("SRJ")+SRA->RA_CODFUNC)
   if .not. eof()
      cCargo_Funcao:=SRJ->RJ_DESC
   endif
   restarea(cxArea)   
     
   // ***
   dbSelectArea(cAliasA) 
     
   // *** Imprime Documento *** //
   nLin:=350
   oPrint:Say(nLin,400  , "RECIBO DE ENTREGA DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL" , oFont16N)
   nLin:=nLin+80 
   
   oPrint:Say(nLin,420  , "ART.29 DA LEI 5452, ALTERADO PELO DECRETO-LEI 229 DE 28/02/67" , oFont16N)
   nLin:=nLin+120
   
   oPrint:Line(nLin,200,nLin,2400)
   nLin:=nLin+60
   
   oPrint:Say(nLin,420  , "Empregadora" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , ALLTRIM(SM0->M0_NOMECOM), oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "Endereço" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , SM0->M0_ENDCOB+", "+ALLTRIM(Capital(SM0->M0_COMPCOB)), oFont11N)
   
   nLin:=nLin+60           
   cBairro:=Alltrim(CAPITAL(SM0->M0_BAIRCOB))
   oPrint:Say(nLin,420  , "Bairro" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , cBairro, oFont11N)
   
   nLin:=nLin+60           
   cBairro:=Alltrim(CAPITAL(SM0->M0_BAIRCOB))
   oPrint:Say(nLin,420  , "Cidade" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , (CAPITAL(SM0->M0_CIDCOB))+"-"+ upper(SM0->M0_ESTCOB )+" Cep: "+left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3), oFont11N)  
   
   nLin:=nLin+40
   oPrint:Line(nLin,200,nLin,2400)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , "Funcionário" , oFont11N)
   oPrint:Say(nLin,750 , ":" , oFont11N)
   oPrint:Say(nLin,800  , SRA->RA_MAT+"-"+ upper(SRA->RA_NOME) , oFont11N) 
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , "Número da CTPs" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , ALLTRIM(SRA->RA_NUMCP)+"    Série: "+ALLTRIM(SRA->RA_SERCP) , oFont11N)  
   
   nLin:=nLin+40
   oPrint:Line(nLin,200,nLin,2400)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "Recebi(emos) a Carteira de Trabalho e Previdência Social acima para as anotações necessárias e que" , oFont11N) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "será devolvida dentro de 48 horas." , oFont11N) 
   
   nLin:=nLin+100  
   cData:=dtos(SRA->RA_ADMISSA)            
   cDataExt1   :=substr( cData,7,2) +" de "+   MESEXTENSO(val(substr( cData,5,2)))  +" de "+ substr( cData,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,420  , cDataExtenso , oFont11N)

   nLin:=nLin+200
   oPrint:Say(nLin,1000  , "__________________________________" , oFont11N)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,1000  , PADC(ALLTRIM(SM0->M0_NOMECOM),40) , oFont11N) 
   
   // ... Desenha Quadro Principal ... //
   nLin:=nLin+100
   ImpBox(oPrint,300,200, nLin, 2400,6)
    
   nLin:=nLin + 100
   oPrint:Line(nLin,200,nLin,2400)
   nLin:=nLin + 100
   
   nLinAnt:=nLin
   // ********
   // *** Imprime Documento *** //
   nLin:=nLin + 100
   oPrint:Say(nLin,500  , "COMPROVANTE DE DEVOLUÇÃO DA CARTEIRA DE TRABALHO" , oFont16N)
   nLin:=nLin+80 
   
   oPrint:Say(nLin,420  , "ART.29 DA LEI 5452, ALTERADO PELO DECRETO-LEI 229 DE 28/02/67" , oFont16N)
   nLin:=nLin+120
   
   oPrint:Line(nLin,200,nLin,2400)
   nLin:=nLin+60                                         
   
   oPrint:Say(nLin,420  , "Empregadora" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , ALLTRIM(SM0->M0_NOMECOM), oFont11N)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "Endereço" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , SM0->M0_ENDCOB+", "+ALLTRIM(Capital(SM0->M0_COMPCOB)), oFont11N)
   
   nLin:=nLin+60           
   cBairro:=Alltrim(CAPITAL(SM0->M0_BAIRCOB))
   oPrint:Say(nLin,420  , "Bairro" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , cBairro, oFont11N)
   
   nLin:=nLin+60           
   cBairro:=Alltrim(CAPITAL(SM0->M0_BAIRCOB))
   oPrint:Say(nLin,420  , "Cidade" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , (CAPITAL(SM0->M0_CIDCOB))+"-"+ upper(SM0->M0_ESTCOB )+" Cep: "+left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3), oFont11N)  
   
   nLin:=nLin+40
   oPrint:Line(nLin,200,nLin,2400)
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , "Funcionário" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , SRA->RA_MAT+"-"+ upper(SRA->RA_NOME) , oFont11N) 
   
   nLin:=nLin+60           
   oPrint:Say(nLin,420  , "Número da CTPs" , oFont11N)
   oPrint:Say(nLin,750  , ":" , oFont11N)
   oPrint:Say(nLin,800  , ALLTRIM(SRA->RA_NUMCP)+"    Série: "+ALLTRIM(SRA->RA_SERCP) , oFont11N)  
   
   nLin:=nLin+40
   oPrint:Line(nLin,200,nLin,2400)
   
   nLin:=nLin+60
   oPrint:Say(nLin,420  , "Recebi, em devolução a Carteira de Trabalho e Previdência Social acima, com as respectivas anotações." , oFont11N) 
      
   nLin:=nLin+100  
   dDatad:=SRA->RA_ADMISSA + 2
   cData:=dtos(dDatad)            
   cDataExt1   :=substr( cData,7,2) +" de "+   MESEXTENSO(val(substr( cData,5,2)))  +" de "+ substr( cData,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,420  , cDataExtenso , oFont11N)

   nLin:=nLin+200
   oPrint:Say(nLin,1000  , "________________________________________" , oFont11N)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,1000  , PADC(ALLTRIM(upper(SRA->RA_NOME)),40) , oFont11N) 
   
   // ... Desenha Quadro Principal ... //
   nLin:=nLin+100
   ImpBox(oPrint,nLinAnt,200, 3400, 2400,6)   
                                                
   // *** 
   dbSelectArea(cAliasA) 
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
|||Programa  |ImpBox ()         |Autor|Valdemir Miranda | Data |15/04/2013|||             Admin	
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

