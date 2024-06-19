#INCLUDE "PROTHEUS.CH" 
#Include "TOPCONN.CH" 
#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | ABGPER01 | Autor | Valdemir Miranda      | Data |15/04/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de Contrato de Trabalho                          |||  
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

User Function ABGPER01()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 
 
// ... Inicializa Parametros ...     
ABGPERPAR()

// ...
If !Pergunte("ABGPER01",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||ABGPECONTR() }, "Contrato de Trabalho  "+time() )  
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
|||Sintaxe   | ABGPERPAR()                                                |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function ABGPERPAR()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("ABGPER01",10)
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
|||Programa  |ABGPECONTR()      |Autor|Valdemir Miranda | Data |15/04/2013|||
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

Static Function ABGPECONTR()   
Local cQry 			:=""  
Local nhandle		:=0
Local cCepPJConv	:=""  
Local cEstaFornec  	:=""
Local aAreaAlias	:=GETAREA() 
Local cArquivo 		:=""   
Local cDataExt1   	:=""
Local cDataExt2   	:=""  
Private  cAliasA	:="" 
Private oFont08  	:= TFont():New("Verdana",08,08,,.F.,,,,.F.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08n  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont11	   	:= TFont():New("Verdana",09,09,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont11N 	:= TFont():New("Verdana",09,09,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //
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
   dbselectarea("SRJ")
   cxArea:=getarea()
   DBSETORDER(1)
   DBSEEK(xfilial("SRJ")+(cAliasA)->RA_CODFUNC)
   if .not. eof()
      cCargo_Funcao:=SRJ->RJ_DESC
   endif
   restarea(cxArea)   
     
   // ***
   dbSelectArea(cAliasA) 
  
   // *** Imprime Moldura e Inicia uma Nova Página *** //
   QebPagina()
   
   // *** Imprime Documento *** //
   nLin:=350
   oPrint:Say(nLin,600  , "C O N T R A T O   D E   E X P E R I Ê N C I A" , oFont16N)
   nLin:=nLin+100
   
   cCNPJ:=left(SM0->M0_CGC,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2)
   oPrint:Say(nLin,350  , "Pelo presente instrumento particular de Contrato de Experiência, a empresa "+ALLTRIM(SM0->M0_NOMECOM)+"  com sede" , oFont11) 
                  
   nLin:=nLin+60 
   oPrint:Say(nLin,350  , "na   "+((SM0->M0_ENDCOB)) +",  inscrita  no  CNPJ  sob  Nº ", oFont11)
   oPrint:Say(nLin,1870  , cCNPJ+",", oFont11)
   
   nLin:=nLin+60     
   cNome:=alltrim(SRA->RA_NOME)
   nNomen:=len(cNome)
   cNome:=iif(nNomen < 30,cNome+space(30-nNomen),cNome)
   oPrint:Say(nLin,350  , "denominada    a   seguir   EMPREGADORA,   e   o   Sr.(a)  "+cNome, oFont11)
   oPrint:Say(nLin,1920  , ",   domiciliado  na" , oFont11)
   
   nLin:=nLin+60    
   cTPS:=ALLTRIM((cAliasA)->RA_NUMCP)+" série "+ALLTRIM((cAliasA)->RA_SERCP)
   nCTPSn:=len(ALLTRIM((cAliasA)->RA_NUMCP)+" série "+ALLTRIM((cAliasA)->RA_SERCP))
   ctps:=iif(nCTPSn < 18, cTPS+space( 18 - nCTPSn),cTPS) 
   oPrint:Say(nLin,350  , (cAliasA)->RA_ENDEREC+" , portador do CTPS Nº "+ctps+", "+" doravante designado EMPREGADO," , oFont11)      
                         
   nLin:=nLin+60 
   oPrint:Say(nLin,350  , "celebram   o   presente   Contrato  Individual  de   Trabalho   para   fins   de   experiência,  conforme  legislação" , oFont11) 
   
   nLin:=nLin+60 
   oPrint:Say(nLin,350  , "trabalhista em vigor, regido pelas cláusulas abaixo e demais disposições legais vigentes:" , oFont11)
   
   nLin:=nLin+150
   oPrint:Say(nLin,350  , "1º. O EMPREGADO trabalhará para a EMPREGADORA na função de " , oFont11) 
   oPrint:Say(nLin,1480  , ALLTRIM(Capital(cCargo_Funcao)), oFont08) 
   oPrint:Say(nLin,1870  , ",  e  mais as funções" , oFont11) 
   
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "que  vierem a ser objeto de ordens  verbais, cartas,  ou  avisos,  segundo  as  necessidades da EMPREGADORA" , oFont11)   
     
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "desde que compatíveis com suas atribuições." , oFont11)   
    
   nLin:=nLin+100       
   cBairro:=Alltrim(CAPITAL(SM0->M0_BAIRCOB)) 
   cBairro:=iif(len(cBairro) < 9, space(9 -len(cBairro))+cBairro,cBairro)
   cComplemento:=iif(empty(ALLTRIM(Capital(SM0->M0_COMPCOB))),space(30),", "+ALLTRIM(Capital(SM0->M0_COMPCOB)))
   oPrint:Say(nLin,350  , "2º. O local de  trabalho  situa-se   na  "+left(SM0->M0_ENDCOB,35)+cComplemento+",    "+cBairro+"," , oFont11) 
    
   nLin:=nLin+60  
   cxMunicip:=(CAPITAL(SM0->M0_CIDCOB))+"-"+ upper(SM0->M0_ESTCOB ) 
   cMunicip:=iif(len(cxMunicip) < 12,cxMunicip+space(12 -len(cxMunicip)) ,cxMunicip )
   oPrint:Say(nLin,350  , cMunicip+", podendo a  EMPREGADORA,  a qualquer  tempo, transferir  o  EMPREGADO  a  título  temporário" , oFont11) 
    
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "ou definitivo, tanto no âmbito da unidade para o qual foi admitido, como para  outras,  em  qualquer localidade" , oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "deste estado ou de outro dentro do país." , oFont11)   
   
   // ***
   cArea2   :=Getarea()
   cEntrada1:=""
   cSaida1  :=""
   cEntrada2:=""
   cSaida2  :=""
   
   // ***
   Dbselectarea("SPJ")
   DBSETORDER(1)
   Set Filter to PJ_TURNO = (cAliasA)->RA_TNOTRAB
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
   
   nLin:=nLin+100
   oPrint:Say(nLin,350  , "3º. O horário de trabalho do EMPREGADO será o seguinte,Inicio do Expediente, as "+cEntrada1+", Saída  para Intervalo" , oFont11) 
    
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "das "+cSaida1+", Entrada Intervalo as "+cEntrada2+" e Final do Expediente as "+cSaida2+"." , oFont11)   
   
   nLin:=nLin+100 
   nSalario:=(cAliasA)->RA_SALARIO 
   cExtenso:=" ( "+	CAPITAL(Extenso( nSalario) )+" ) por mês."
   nTam    := len(cExtenso)
   
   cTexto1 := iif( nTam < 51,cExtenso,left(cExtenso,50)) 
   cTexto2 := iif( nTam > 50,substr(cExtenso,51, (nTam - 50))," ") 
   
   oPrint:Say(nLin,350  , "4º. O EMPREGADO  receberá a  remuneração de "+Transform( nSalario, "@E 9,999,999.99")+" "+ cTexto1 , oFont11) 
   
   if .not. empty(cTexto2) 
      nLin:=nLin+60
      oPrint:Say(nLin,350  , cTexto2 , oFont11)  
   endif
   
   nLin:=nLin+100
         
   dExp1   := (SRA->RA_ADMISSA)  
   dExp2   := ((dExp1+45) -1)
   cData1  :=CAPITAL(substr( DTOS(dExp1),7,2)+"/"+substr( DTOS(dExp1),5,2)+"/"+Substr(DTOS(dExp1),1,4))
   cData2  :=substr( DTOS(dExp2),7,2)+"/"+substr( DTOS(dExp2),5,2)+"/"+Substr(DTOS(dExp2),1,4) 
   
   cDiasV:= (CTOD(cData2) - CTOD(cData1))
   cxdias:=CAPITAL(Extenso( (cDiasV+1)))
   cxDias:=left(cxdias,(len(cxdias)-6)) 
   cQtdDias:=Transform( (cDiasV+1), "@E 999")+" ("+cxDias+") dias "  
   
   cTexto:="5º. O  prazo  deste  contrato é  de  "+cQtdDias +",  com   inicio  em  "+cData1+" e  término  em"
   oPrint:Say(nLin,350  , cTexto , oFont11) 
   
   nLin:=nLin+60
   cTexto:=cData2+"."
   oPrint:Say(nLin,350  , cTexto , oFont11) 
    
   nLin:=nLin+100
   oPrint:Say(nLin,350  , "6º. Além dos descontos previstos na Lei,  reserva-se a EMPREGADORA o direito de descontar  do EMPREGADO" , oFont11)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "às importâncias correspondentes aos danos causados por ele." , oFont11)
                              
   nLin:=nLin+100
   oPrint:Say(nLin,350  , "7º. O EMPREGADO  fica  ciente do Regulamento da EMPREGADORA  e das  Normas  de  Segurança  fornecido," , oFont11)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "sob pena de ser  punido  por falta grave, nos termos da  Legislação  vigente  e  demais disposições  inerentes" , oFont11)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "à segurança e medicina do trabalho." , oFont11)
   
   nLin:=nLin+100
   oPrint:Say(nLin,350  , "8º. Permanecendo o EMPREGADO a serviço após o término da experiência, continuarão em vigor as cláusulas" , oFont11)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "constantes deste contrato. " , oFont11) 
   
   nLin:=nLin+100
   oPrint:Say(nLin,350  , "9º. ______________________________________________________________________________________" , oFont11)
   
   nLin:=nLin+100 
   oPrint:Say(nLin,350  , "     ______________________________________________________________________________________" , oFont11) 
   
   
   nLin:=nLin+120
   oPrint:Say(nLin,350  , "Tendo assim contratado, assinam o presente instrumento,  em duas  vias,  na  presença  das  testemunhas" , oFont11)
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "abaixo. " , oFont11)
   
   nLin:=nLin+100              
   cDataExt1   :=substr( dtos((cAliasA)->RA_ADMISSA),7,2) +" de "+   MESEXTENSO(val(substr( dtos((cAliasA)->RA_ADMISSA),5,2)))  +" de "+ substr( dtos((cAliasA)->RA_ADMISSA),1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,350  , cDataExtenso , oFont11)
      
    
   nLin:=nLin+100
   oPrint:Say(nLin,1500  , "______________________________" , oFont11)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,1500  , PADC(ALLTRIM(CAPITAL((cAliasA)->RA_NOME)),35), oFont11) 
   
   nLin:=nLin+100
   oPrint:Say(nLin,350  , " ______________________________" , oFont11) 
   oPrint:Say(nLin,1500  , "______________________________" , oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC(ALLTRIM(SM0->M0_NOMECOM),35) , oFont11)
   oPrint:Say(nLin,1500  ,PADC("Responsável Legal(quando menor)",35), oFont11) 
   
   nLin:=nLin+100
   oPrint:Say(nLin,350  , " _____________________________" , oFont11) 
   oPrint:Say(nLin,1500  , "_____________________________" , oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC("TESTEMUNHA 1",35), oFont11) 
   oPrint:Say(nLin,1500  ,PADC("TESTEMUNHA 2",35), oFont11) 
   
   // *** Imprime Moldura e Inicia uma Nova Página *** //
   QebPagina() 
   
   // *** Imprime Documento *** //
   nLin:=400
   oPrint:Say(nLin,500  , "PRORROGAÇÃO DE CONTRATO DE EXPERIÊNCIA" , oFont16N)
   nLin:=nLin+180
   
   nLin:=nLin+60  
   dDatafim:= ((CTOD(cData2) + 45))
   dDatafim:=(dDatafim )
   oPrint:Say(nLin,600  , "O Contrato de Experiência firmado, que deveria terminar em "+cData2+" , fica prorrogado ", oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , "até "+dtoc(dDatafim)+".", oFont11)  
   
   nLin:=nLin+200   
   
   dDtfim:=CTOD(cData2)
   cDtfim    := dtos(dDtfim)             
   cDataExt1   :=substr( cDtfim,7,2) +" de "+   MESEXTENSO(val(substr( cDtfim,5,2)))  +" de "+ substr( cDtfim,1,4)  
   cDataExtenso:=Alltrim(CAPITAL(SM0->M0_CIDCOB))+", "+cDataExt1+"."
   oPrint:Say(nLin,350  , cDataExtenso , oFont11)
      
    
   nLin:=nLin+200
   oPrint:Say(nLin,1500  , "______________________________" , oFont11)  
   
   nLin:=nLin+60
   oPrint:Say(nLin,1500  , PADC(ALLTRIM(CAPITAL((cAliasA)->RA_NOME)),35), oFont11) 
   
   nLin:=nLin+150
   oPrint:Say(nLin,350  , " ______________________________" , oFont11) 
   oPrint:Say(nLin,1500  , "______________________________" , oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC(ALLTRIM(SM0->M0_NOMECOM),35) , oFont11)
   oPrint:Say(nLin,1500  ,PADC("Responsável Legal(quando menor)",35), oFont11) 
   
   nLin:=nLin+150
   oPrint:Say(nLin,350  , " _____________________________" , oFont11) 
   oPrint:Say(nLin,1500  , "_____________________________" , oFont11) 
   
   nLin:=nLin+60
   oPrint:Say(nLin,350  , PADC("TESTEMUNHA 1",35), oFont11) 
   oPrint:Say(nLin,1500  ,PADC("TESTEMUNHA 2",35), oFont11) 
   
                                                
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

