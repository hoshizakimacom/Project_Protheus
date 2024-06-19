#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "RwMake.CH"
#include "Fileio.ch"

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | IMFR027  | Autor | Valdemir Miranda      | Data |10/09/2012|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Emissão do Distrato - Termo de Rescisão Contratual         |||  
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
User Function  IMFR027()

Local aAREA    	:=GETAREA()
Local nLastKey 	:=0

Private cDataExt:=SUBSTR(DTOC(DDATABASE),1,2)+" de "+MesExtenso(dDataBase) +" de "+SUBSTR(DTOS(DDATABASE),1,4)  
Private oPrint

// ... Inicializa Parametros ...
R027_Parametro()

// ...
If !Pergunte("IMFR027",.T.)
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to
	Restarea(aAREA)
	Return
Endif

Processa({||R027Distrato()}, "Distrato - Termo de Rescisão Contratual "+time() )
Restarea(aAREA)

Return


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |R027_Parametro | Autor | Valdemir Miranda | Data |10/09/2012|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato PJ                   		  |||  
|||          | 					                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R027_Parametro()                                           |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function R027_Parametro()
Local aArea := GetArea()
Local cPerg := PADR("IMFR027",10)
Local aRegs :={}
Local nX

aAdd(aRegs,{"Filial De ? "		,"¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{"Filial Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{"C.Custo De  ?"		,"¨Forneced. De?","From Bank ?","mv_ch3","C",9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{"C.Custo Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch4","C",9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{"Matricula De ?"	,"¨Forneced. De?","From Bank ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{"Matricula Ate?"	,"¨Forneced.Ate?","From Bank ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{"Dt.Demissao De?"	,"¨Demissao De?","From Bank ?","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"Dt.Demissao Ate?"	,"¨Demissao De?","From Bank ?","mv_ch8","D",8,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"Docto de ?"		,"¨Docto de?" 	,"Docto de?"  ,"mv_ch9","N",1,0,0,"C","","mv_par09","São Paulo","São Paulo","São Paulo","","","Brasília","Brasília","Brasília","","","","","","","","","","","","","","","","","",""})

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
		Replace x1_f3     	with aRegs[nx][36]
		Replace x1_grpsxg 	with aRegs[nx][37]
		SX1->(MsUnlock())
	Endif
Next nX
END TRANSACTION
RestArea(aArea)
Return


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |R027Distrato      |Autor|Valdemir Miranda | Data |10/09/2012|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Processamento e Emissão do Distrato PJ           	  |||  
|||          | 					                          |||
|||          | 						                  |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R027Distrato()                                             |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function R027Distrato()
Local cAliasA		:=""
Local cTexto		:=""
Local cCep			:=""
Local cCepEmp  		:=""
Local cCnpjEmp   	:=""
Local aAREA_Qry 	:=GETAREA()
Private aLanctoDist :={}   
Private cData   	:=""
Private cQry 		:=""
Private cAliasA 	:=""
Private cQuebra		:=""
Private nValliq		:= 0.00
Private nValorNF		:= 0.00
Private nLin    	:= 9000
Private nTam		:= 0
Private oFont08  	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)   		  // *** Definicao dos Fonte  tipo Verdana com negrito *** //
Private oFont08C    := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)      // *** Definicao dos Fonte  tipo Courier Newnegrito para campos númericos *** //
Private oFont11	   	:= TFont():New("Verdana",11,11,,.F.,,,,.F.,.F.)  		 // *** Definicao dos Fonte tipo Verdana sem negrito   *** //
Private oFont11N 	:= TFont():New("Verdana",11,11,,.T.,,,,.T.,.F.)  		 // *** Definicao dos Fonte  tipo Verdana com negrito *** //

// ... Inicia uma nova pagina da TMSPRINTER ... //
oPrint:= TMSPrinter():New("Emissão do Distrato - Termo de Rescisão Contratual ")
oPrint:Setup()

//oPrint:SetLandscape() 		// *** Seleciona tipo de Impressão no Formato  Paisagem	*** //
oPrint:SetPortrait()    			// *** Seleciona tipo de Impressão no Formato Retrato      *** //
oPrint:SETPAPERSIZE(9)  // *** Seleciona tipo do Papel:  1 - Papel Carta   -   9 - A4 *** //

// *** Monta Query de Processamento *** //
cQry := " SELECT SRR.RR_FILIAL,SRR.RR_DATA,SRR.RR_CC,SRR.RR_MAT,SRR.RR_TIPO3,SRR.RR_PD,SRR.RR_HORAS,SRR.RR_VALOR "
cQry += " FROM  "+RetSqlName("SRR")+" SRR"

cQry += " WHERE SRR.D_E_L_E_T_='' "

if .not. empty(mv_par01)
	cQry += " AND SRR.RR_FILIAL >= '" + mv_par01 + "' "
	cQry += " AND SRR.RR_FILIAL <= '" + mv_par02 + "' "
endif

if .not. empty(mv_par03)
	cQry += " AND SRR.RR_CC     >= '" + mv_par03 + "' "
	cQry += " AND SRR.RR_CC     <= '" + mv_par04 + "' "
endif

if .not. empty(mv_par05)
	cQry += " AND SRR.RR_MAT     >= '" + mv_par05 + "' "
	cQry += " AND SRR.RR_MAT     <= '" + mv_par06 + "' "
endif

if .not. empty(mv_par07)
	cQry += " AND SRR.RR_DATA     >= '" + DTOS(mv_par07) + "' "
	cQry += " AND SRR.RR_DATA     <= '" + DTOS(mv_par08) + "' "
endif

cQry += " AND SRR.RR_TIPO3 = 'R' "

cQry += " ORDER BY SRR.RR_FILIAL,SRR.RR_DATA,SRR.RR_MAT,SRR.RR_PD ASC "

cAliasA	:= GetNextAlias()
If Select( cAliasA ) > 0
	dbSelectArea( cAliasA )
	(cAliasA)->(dbCloseArea)
EndIf

// *** Abre Tabelas *** //
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasA , .F., .T.)


// *** Inicio do Processamento  *** //
dbSelectArea(cAliasA)
ProcRegua((cAliasA)->(LastRec()))
(cAliasA)->(dbGoTop())

Do While .not. ( (cAliasA)->(eof()) )
	
	dbselectarea("SRA")
	SRA->(dbsetorder(1))
	If SRA->(dbseek( (cAliasA)->RR_FILIAL+ (cAliasA)->RR_MAT))
		cQuebra:=(cAliasA)->RR_FILIAL+ (cAliasA)->RR_MAT+ (cAliasA)->RR_TIPO3+ (cAliasA)->RR_DATA
		cData:=substr((cAliasA)->RR_DATA,7,2)+"/"+substr((cAliasA)->RR_DATA,5,2)+"/"+substr((cAliasA)->RR_DATA,1,4)
		
		IncProc("Colaborador: " + SRA->RA_MAT+" - "+SRA->RA_NOME)
		
		dbSelectArea(cAliasA)
		while !( (cAliasA)->(eof()) ) .and. (cAliasA)->RR_FILIAL+ (cAliasA)->RR_MAT+ (cAliasA)->RR_TIPO3+ (cAliasA)->RR_DATA == cQuebra
			
			// *** Monta Vetor com Itens de Rescisão *** //
			dbselectarea("SRV")
			SRV->(dbsetorder(1))
			SRV->(dbseek( (cAliasA)->RR_FILIAL+ (cAliasA)->RR_PD))
			if .not. SRV->(eof())
				
				// *** Itens do Vetor ==>  01- Tipo  -  02-Codigo da Verba  -  03-Descrição da Verba -  04-Referencia/Horas - 05-Valor *** //
				if SRV->RV_TIPOCOD <> "3" .and.  (cAliasA)->RR_PD <> "490"
					aAdd(aLanctoDist,{SRV->RV_TIPOCOD, (cAliasA)->RR_PD,Left(SRV->RV_DESC,20), (cAliasA)->RR_HORAS,(cAliasA)->RR_VALOR})
				endif
			endif
			
			if  (cAliasA)->RR_PD == "490"
				nValliq:=(cAliasA)->RR_VALOR
			endif
			
			if  (cAliasA)->RR_PD == "980"
				nValorNF:=(cAliasA)->RR_VALOR
			endif
			dbSelectArea(cAliasA)
			(cAliasA)->(dbskip())
		enddo
		                                
		// *** Imprime Documento *** //
		nLin:=300
		oPrint:Say(nLin,600  , "T E R M O  D E  R E S C I S Ã O  C O N T R A T U A L" , oFont11N)
		nLin:=nLin+180
				    
		cTexto:="Pelo presente instrumento, de um lado,"+alltrim(Capital(SRA->RA_NOMEMPR))+", inscrita no  CNPJ   nº   "
        nTam  :=(len(cTexto) - 70)
        oPrint:Say(nLin,455  , alltrim(substr(cTexto,1,72)) , oFont11)
     
        nLin:=nLin+60
        cTexto:=alltrim(substr(cTexto,75,(nTam+1))+alltrim(SRA->RA_CICANT)+",    estabelecida     a    "+trim(Capital(SRA->RA_ENDERPJ))+"  - "+alltrim(Capital(SRA->RA_BAIRRPJ))) 
        nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
        oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,92)) , oFont11)    
     
        nLin:=nLin+60       
        cCep:=left(strzero(SRA->RA_CEPPJ,8),5)+" - "+substr(strzero(SRA->RA_CEPPJ,8),6,3)
        cTexto:=substr(cTexto,93,nTam)+" - Cep "+cCep+" - "+alltrim(Capital(SRA->RA_MUNICIPJ)) +" -  "+SRA->RA_ESTADO+ ",   representada    neste   ato   por   seu(ua) "  
        nTam  :=iif( len(cTexto) > 89,  ( len(cTexto) - 89), len(cTexto))
        oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11) 
     
        nLin:=nLin+60
        cTexto:=substr(cTexto,92,nTam)+" representante   legal  o(a) Sr(a).  "+alltrim(CAPITAL(SRA->RA_NOME))+",   doravante  denominado  de "
        nTam  :=iif( len(cTexto) > 92,  ( len(cTexto) - 92), len(cTexto))
        oPrint:Say(nLin,200  ,alltrim(substr(cTexto,2,92)) , oFont11) 
		
		nLin:=nLin+60   
		if mv_par09 = 1
	       cCepEmp:=left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3)
		   cTexto:=substr(cTexto,90,nTam)+" na "+alltrim(CAPITAL(SM0->M0_ENDCOB))+"  -  "+alltrim(CAPITAL(SM0->M0_BAIRCOB))+"  -  Cep:  "+cCepEmp+"  -  "+alltrim(CAPITAL(SM0->M0_CIDCOB))+"  -  "+SM0->M0_ESTCOB+", "
		   nTam  :=iif( len(cTexto) > 91,  ( len(cTexto) - 87), len(cTexto))
	       oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,91)) , oFont11)
		
	       nLin:=nLin+60
	       cCnpjEmp:=left(SM0->M0_CGC,2)+"."+substr(SM0->M0_CGC,3,3)+"."+substr(SM0->M0_CGC,6,3)+"/"+substr(SM0->M0_CGC,9,4)+"-"+substr(SM0->M0_CGC,13,2)
	       cTexto:=substr(cTexto,90,nTam)+"inscrita no CNPJ sob o nº "+cCnpjEmp+", doravante denominada de "+ CAPITAL("CONTRATANTE")+", por    seu "
		   nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		   oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11)
		else
	       cCepEmp:="70390-025"
		   cTexto:=substr(cTexto,92,nTam)+" na SEPS 702/902 - Lote B - Bloco A - 2º Andar - Edifício General Alencastro - Asa Sul  - Cep:  70390-025  -  Brasília/DF, "
		   nTam  :=iif( len(cTexto) > 92,  ( len(cTexto) - 87), len(cTexto))
	       oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11)
		
	       nLin:=nLin+60
	       cTexto:=substr(cTexto,90,nTam)+"inscrita  no  CNPJ  sob   o   nº  04.405.242/0002-05, doravante denominada de "+ CAPITAL("CONTRATANTE")+", por seu "
		   nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		   oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11)
		endif
		
		nLin:=nLin+60
		cTexto:=substr(cTexto,91,nTam)+"representante "
		nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11)
		
		nLin:=nLin+60
		cTexto:=substr(cTexto,91,nTam)+" legal, tem entresi justo e avençado o seguinte:"
		nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,90)) , oFont11)
		
		nLin:=nLin+100
		cTexto:="1.	Através  de  correspondência  datada   de  "+cData+",   a    "+ CAPITAL("CONTRATANTE")+"  comunicou   à "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	 "+ CAPITAL("CONTRATADA")+" a sua  decisão  de  rescindir  o  "+ CAPITAL("CONTRATO  DE  PRESTAÇÃO  DE  SERVIÇOS") +" firmado "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="    entre as partes. "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+100
		cTexto:="2.	A  "+ CAPITAL("CONTRATANTE")+"   paga,  neste  ato,  à  "+ CAPITAL("CONTRATADA")+"  a  quantia  bruta  de  R$ "+transform((nValorNF),"@E 999,999,999.99")+"  "
		oPrint:Say(nLin,200  ,cTexto , oFont11)
		
		nLin:=nLin+60
		cTexto:="      "+"("+CAPITAL(extenso(nValorNF))+")" +" a título de pagamento proporcional do  bônus previsto no parágrafo  2 º da Cláusula  V  do "
		nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		oPrint:Say(nLin,200  ,substr(cTexto,1,92) , oFont11)
		
		nLin:=nLin+60
		cTexto:=substr(cTexto,93,nTam)+"  "+ CAPITAL("CONTRATO DE PRESTAÇÃO DE SERVIÇOS")+" celebrado entre as partes.  "
		nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		oPrint:Say(nLin,200  ,"      "+substr(cTexto,1,80) , oFont11)
		
		nLin:=nLin+60
		cTexto:=substr(cTexto,81,(nTam+8))
		nTam  :=iif( len(cTexto) > 90,  ( len(cTexto) - 90), len(cTexto))
		oPrint:Say(nLin,200  ,"      "+substr(cTexto,1,90) , oFont11)
		
		nLin:=nLin+100
		cTexto:="  	2.1. Sobre o valor descrito  na  cláusula 2  serão  retidos  os   impostos  e   contribuições "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="     determinados pela legislação tributária vigente. "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+100
		cTexto:="3.	A "+CAPITAL("CONTRATADA")+"  recebe  a  quantia  mencionada  no  item  anterior,  dando   à  "+ CAPITAL("CONTRATANTE ")+" "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	quitação  plena,  geral,  rasa   e   irrevogável  no  tocante  a  todos  e  quaisquer  direitos "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	decorrentes da relação contratual que entre si mantiveram, nada  mais  tendo  a  receber,  "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	 seja a que título for, sejam referentes à  comissões,  bônus  ou  participações,  dando-se "
		
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	assim por  bem paga e satisfeita. "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+100
		cTexto:="4.	E por estarem justas e acertadas, as partes firmam o presente termo,  em  duas  vias  de  "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+60
		cTexto:="  	 igual teor, na presença das testemunhas abaixo, para que produza seus devidos efeitos. "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+180
		cTexto:=iif(mv_par09 == 1,"São Paulo, "+cDATAEXT+".","Brasília, "+cDATAEXT+".")
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		nLin:=nLin+180
		cTexto:=alltrim(Capital(SRA->RA_NOMEMPR))
		oPrint:Say(nLin,200  , cTexto, oFont11N)
		
		nLin:=nLin+180
		cTexto:=CAPITAL(SM0->M0_NOMECOM)
		oPrint:Say(nLin,200  , cTexto, oFont11N)
		
		nLin:=nLin+120
		cTexto:="TESTEMUNHAS:"
		oPrint:Say(nLin,200  , cTexto, oFont11N)
		
		nLin:=nLin+180
		cTexto:="  	1.  ________________________________         	2.  ________________________________   "
		oPrint:Say(nLin,200  , cTexto, oFont11)
		
		// *** Pula para próxima página *** //
		oPrint:EndPage()
		
		// *** Impressão dos Valores Rescisórios *** //
		R027_TerRescisório()
	endif
Enddo

// ---
oPrint:EndPage()
oPrint:Preview()

// *** Desabilita o Alias da Query e Fecha a mesma *** //
DBSELECTAREA(cAliasA)
(cAliasA)->(dbCloseArea())

// *** Restaura Areas Abertas ***
Restarea(aAREA_Qry)
Return


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |R027_TerRescisório|Autor|Valdemir Miranda | Data |10/09/2012|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Impressão de Itens da Rescisão                   	  |||  
|||          | 					                          |||
|||          | 						                  |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R027_TerRescisório()                                       |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function  R027_TerRescisório()
            
Local nLantoD		:=0
Local cDATAEXTDEMI	:=""
Local nlininic		:=0
Local nLinDsc		:=0
Local nTotDesc		:=0.00
Local aAREA_Resc	:=GETAREA()
Private nTotVal		:=0

nLin:=300
oPrint:Say(nLin,600  , "T E R M O  D E  R E S C I S Ã O  C O N T R A T U A L" , oFont11N)
nLin:=nLin+180
nlininic:=(nLin-40)

// ***
oPrint:Say(nLin,200  ,"Proventos", oFont11N)
oPrint:Say(nLin,650  ,"Ref.", oFont11N)
oPrint:Say(nLin,900  ,"Valor", oFont11N)

oPrint:Say(nLin,1200  ,"Descontos", oFont11N)
oPrint:Say(nLin,1650  ,"Ref.", oFont11N)
oPrint:Say(nLin,2000  ,"Valor", oFont11N)

// ***
nLin:=nLin+60
oPrint:Line(nLin,190,nLin,2200)
nLin:=nLin+40
nLinDsc:= nLin

// *** Impressão das Verbas Rescisórias *** //
if len(aLanctoDist)  > 0
	for nLantoD:=1 to len(aLanctoDist)
		if aLanctoDist[nLantoD][1] == "1"
			oPrint:Say(nLin,200  ,aLanctoDist[nLantoD][3], oFont08)
			oPrint:Say(nLin,650,transform(aLanctoDist[nLantoD][4],"@E 999.99") , oFont08C)
			oPrint:Say(nLin,900,transform(aLanctoDist[nLantoD][5],"@E 999,999,999.99") , oFont08C)
			nTotVal:= nTotVal+aLanctoDist[nLantoD][5]
			nLin:=nLin+60
		elseif aLanctoDist[nLantoD][1] == "2"
			oPrint:Say(nLinDsc,1200  ,aLanctoDist[nLantoD][3], oFont08)
			oPrint:Say(nLinDsc,1650,transform(aLanctoDist[nLantoD][4],"@E 999.99") , oFont08C)
			oPrint:Say(nLinDsc,1900,transform(aLanctoDist[nLantoD][5],"@E 999,999,999.99") ,oFont08C)
			nLinDsc:=nLinDsc+60
		endif
	next nLantoD
endif

// *** Imprime Quadro do Item Acima *** //
nLin:=nLin+80
R027_ImpBox(oPrint,nlininic,190, nLin,2200,6)
oPrint:Line(nlininic,640,nLin,640)
oPrint:Line(nlininic,890,nLin,890)
oPrint:Line(nlininic,1190,nLin,1190)
oPrint:Line(nlininic,1640,nLin,1640)
oPrint:Line(nlininic,1890,nLin,1890)
nLin:=nLin+40

// *** Calcula Total de Desconto *** //
nTotDesc:=nTotVal - nValliq

oPrint:Say(nLin,200  ,"TOTAL BRUTO ", oFont11N)
oPrint:Say(nLin,900,transform(nTotVal,"@E 999,999,999.99") , oFont08C)

oPrint:Say(nLin,1200  ,"TOTAL DE DESCONTO", oFont11N)
oPrint:Say(nLin,1900,transform(nTotDesc,"@E 999,999,999.99") ,oFont08C)

nLin:=nLin+60
R027_ImpBox(oPrint,nlininic,190, nLin,2200,6)

nLin:=nLin+60
oPrint:Say(nLin,200  ,"VALOR DA NF:       "+transform(nValorNF,"@E 999,999,999.99"), oFont11N)

nLin:=nLin+80
R027_ImpBox(oPrint,nlininic,190, nLin,2200,6)

nLin:=nLin+80
cTexto:="Pelo   presente  instrumento, de  um  lado, "+alltrim(Capital(SRA->RA_NOMEMPR))+", aqui  "
nTam  :=(len(cTexto) - 79)
oPrint:Say(nLin,560  , substr(cTexto,1,79) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,96,(nTam+2))+"denominada de "+CAPITAL("CONTRATADA")+", neste ato representada por seu(ua) titular o(a) Sr(a). "+alltrim(CAPITAL(SRA->RA_NOME))
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,95)) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,95,(nTam+2))+", declara haver recebido, da "+CAPITAL(SM0->M0_NOMECOM)  +", por   mera  liberalidade, a quantia bruta "
nTam  :=iif( len(cTexto) > 95,  ( len(cTexto) - 95), len(cTexto))
oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,96)) , oFont11)


nLin:=nLin+60
cTexto:=substr(cTexto,97,(nTam+2))+" de R$ "+transform((nValorNF),"@E 999,999,999.99")+" ("+CAPITAL(extenso(nValorNF))+")"+", referente  ao  pagamento dos "
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,99)) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,99,nTam)+" títulos  acima  discriminados, devidos   pelo "+CAPITAL("CONTRATO DE PRESTAÇÃO DE SERVIÇOS")+"  mantido com a mesma, no período de "+LEFT(DTOC(SRA->RA_ADMISSA),6)+LEFT(DTOS(SRA->RA_ADMISSA),4)+" A "+ LEFT(DTOC(SRA->RA_DEMISSA),6)+LEFT(DTOS(SRA->RA_DEMISSA),4)
nTam  :=iif( len(cTexto) > 94,  ( len(cTexto) - 94), len(cTexto))
oPrint:Say(nLin,200  ,substr(alltrim(cTexto),2,93) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,95,nTam)+"."
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,98)) , oFont11)

nLin:=nLin+100
cTexto:="Sobre o valor descrito acima, serão retidos os impostos e  contribuições determinados pela legislação tributária vigente.
nTam  :=(len(cTexto) - 80)
oPrint:Say(nLin,560  , substr(cTexto,1,80) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,81,nTam)
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,alltrim(substr(cTexto,1,98)) , oFont11)

nLin:=nLin+100
cTexto:="A "+CAPITAL("CONTRATADA")+"   outorga,  assim,  à "+CAPITAL("EMPRESA BRASILEIRA DE COMUNICAÇÃO PRODUÇÃO LTDA")
nTam  :=(len(cTexto) - 78)
oPrint:Say(nLin,560  , substr(cTexto,1,78) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,79,nTam)+". a mais ampla, geral, rasa e irrevogável quitação de todos os direitos decorrentes da relação contratual"
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,substr(alltrim(cTexto),1,98) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,96,nTam)+" que entre si mantiveram, para nada mais receber, seja que título  for,  perante qualquer "
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,substr(alltrim(cTexto),1,98) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,98,nTam)+" Instância, Juízo ou Tribunal."
nTam  :=iif( len(cTexto) > 96,  ( len(cTexto) - 96), len(cTexto))
oPrint:Say(nLin,200  ,substr(alltrim(cTexto),1,96) , oFont11)

nLin:=nLin+100
cTexto:="A CONTRATANTE declara, ainda,  que  foi  sua, exclusivamente, a  iniciativa  de  dar  por "
nTam  :=(len(cTexto) - 79)
oPrint:Say(nLin,560  , substr(cTexto,1,79) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,80,nTam)+"rescindido    o   referido   "+CAPITAL("CONTRATO DE PRESTAÇÃO DE SERVIÇOS")+"    que    manteve   com    a "
oPrint:Say(nLin,200  ,alltrim(cTexto) , oFont11)

nLin:=nLin+60
cTexto:=substr(cTexto,81,nTam)
oPrint:Say(nLin,200  ,alltrim(Capital(SRA->RA_NOMEMPR))+"."  , oFont11)

nLin:=nLin+180
cDATAEXTDEMI:=SUBSTR(DTOC(SRA->RA_DEMISSA),1,2)+" de "+MesExtenso(SRA->RA_DEMISSA)+" de "+SUBSTR(DTOS(SRA->RA_DEMISSA),1,4)
cTexto:=iif(mv_par09 == 1,"São Paulo, "+cDATAEXTDEMI+".","Brasília, "+cDATAEXTDEMI+".")
oPrint:Say(nLin,200  ,cTexto, oFont11)

nLin:=nLin+180
oPrint:Say(nLin,200 , alltrim(Capital(SRA->RA_NOMEMPR)) , oFont11N)

nLin:=nLin+180
oPrint:Say(nLin,200 , CAPITAL(SM0->M0_NOMECOM)  , oFont11N)

Restarea(aAREA_Resc)
Return 


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |R027_ImpBox       |Autor|Valdemir Miranda | Data |10/09/2012|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Imprime um box simulando o negrito                  	  |||  
|||          | Geral / Qualquer módulo		                          |||
|||          | 						                  |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R027_ImpBox(oObj,nLin,nCol,nLinF,nColF,nPixel)             |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function R027_ImpBox(oObj,nLin,nCol,nLinF,nColF,nPixel)
Local aArea		:=GetArea()
Local nContPixel:=0
For nContPixel:= 1 to nPixel
	oObj:Box(nLin,nCol,nLinF,nColF)
	nLin++
	nCol++
	nLinF--
	nColF--
Next
RestArea(aArea)
Return  