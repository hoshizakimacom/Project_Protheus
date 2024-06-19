#INCLUDE "PROTHEUS.CH" 
#Include "TOPCONN.CH" 
#Include "RwMake.CH"  
#include "Fileio.ch"  

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | IMFR029  | Autor | Valdemir Miranda      | Data |10/09/2012|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Sistema de criação de Varíaveis de Macro Substituição e    |||  
|||          | Emissão de Documentos do WORD                              |||
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

User Function  IMFR029()                  
Local aAREA    	:=GETAREA()                   
Local nLastKey 	:=0
Private oPrint 
 
// ... Inicializa Parametros ...     
R029_Parametro()

// ...
If !Pergunte("IMFR029",.T.)       
	Restarea(aAREA)
	Return
EndIf

If nLastKey == 27
	Set Filter to  
	Restarea(aAREA)
	Return
Endif   
             
Processa({||R029_DistratoGnova() }, "Distrato - Gnova  "+time() )  
Restarea(aAREA)

Return      


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |               |       |                  |      |          |||
|||Programa  |R029_Parametro | Autor | Valdemir Miranda | Data |10/09/2012|||
|||          |               |       |                  |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Parâmetros do Distrato                    		  |||  
|||          | 					                          |||
|||          | Grava e Captura Parâmetros da Tabela SX1                   |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R029_Parametro()                                           |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function R029_Parametro()       
Local _aAlias 	:= GETAREA()
Local cPerg 	:= PADR("IMFR029",10)
Local aRegs 	:={}                       
Local nX  

aAdd(aRegs,{"Filial De ?"		,"¨Forneced. De?","From Bank ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})  
aAdd(aRegs,{"Filial Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})   
aAdd(aRegs,{"C.Custo De ?"		,"¨Forneced. De?","From Bank ?","mv_ch3","C",9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})  
aAdd(aRegs,{"C.Custo Ate ?"		,"¨Forneced.Ate?","From Bank ?","mv_ch4","C",9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})   
aAdd(aRegs,{"Matricula De ?"	,"¨Forneced. De?","From Bank ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})  
aAdd(aRegs,{"Matricula Ate?"	,"¨Forneced.Ate?","From Bank ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})      
aAdd(aRegs,{"Docto a Imprimir ?","¨Tipo de Arq.  ?" ,"Tipo Arq.    ?","mv_ch7","N",1,0,0,"C","","mv_par07","Nenhum","Nenhum","Nenhum","","","Distrato Gnova","Distrato Gnova","Distrato Genova","","","EBCP Brasília","EBCP Brasília","EBCP Brasília","","","Ebcp Contrato","Ebcp Contrato","Ebcp Contrato","","","","","","","",""})
aAdd(aRegs,{"Docto a Imprimir ?","¨Tipo de Arq.  ?" ,"Tipo Arq.    ?","mv_ch8","N",1,0,0,"C","","mv_par08","Nenhum","Nenhum","Nenhum","","","Gnova Atual CPS","Gnova Atual CPS","Gnova Atual CPS","","","Gnova Contrato Service","Gnova Contrato Service","Gnova Contrato Service","","","","","","","","","","","","",""})
  
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
|||Programa  |R029_DistratoGnova|Autor|Valdemir Miranda | Data |10/09/2012|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descrição | Sistema de Emissão de Documentos no Padrão WORD   	  |||  
|||          | 					                          |||
|||          | 						                  |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Sintaxe   | R029_DistratoGnova()                                       |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
||| Uso      | Gestão Pessoal / Recussos Humanos                          |||
|||          |                                                            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function R029_DistratoGnova()   
Local cQry 			:=""  
Local nhandle		:=0
Local cCepPJConv	:=""  
Local cEstaFornec  	:=""
Local aAreaAlias	:=GETAREA() 
Local cArquivo 		:=""   
Local cDataExt1   	:=""
Local cDataExt2   	:=""  
Private  cAliasA	:=""  
 
// *** Monta Query de Processamento *** //  
cQry := " SELECT * "
cQry += " FROM  "+RetSqlName("SRA")+" SRA"

cQry += " WHERE SRA.D_E_L_E_T_='' " 
   
if .not. empty(mv_par01) 
   cQry += " AND SRA.RA_FILIAL >= '" + mv_par01 + "' "  
   cQry += " AND SRA.RA_FILIAL <= '" + mv_par02 + "' " 
endif 
   
if .not. empty(mv_par03) 
   cQry += " AND SRA.RA_CC     >= '" + mv_par03 + "' "  
   cQry += " SRA.RA_CC            <= '" + mv_par04 + "' " 
endif  
   
if .not. empty(mv_par05) 
   cQry += " AND SRA.RA_MAT     >= '" + mv_par05 + "' "  
   cQry += " AND SRA.RA_MAT     <= '" + mv_par06 + "' " 
endif
 
cQry += " ORDER BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC ASC "

cAliasA	:= GetNextAlias() 
If Select( cAliasA ) > 0
   dbSelectArea( cAliasA )
   (cAliasA)->(dbCloseArea())
EndIf
 
// *** Abre Tabelas *** //
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasA , .F., .T.)
  
 // *** Selecionar Caminho e Arquivo a Imprimir *** // 
 if  mv_par07 > 1
 	if mv_par07 == 2
       cArquivo := "\\clsap\modelo\Distrato GNOVA.DOT"  
	elseif  mv_par07 == 3
       cArquivo := "\\clsap\modelo\EBCP BRASILIA CONTRATO DE PRESTAÇÃO DE SERVIÇOS.DOT" 
	elseif  mv_par07 == 4
        cArquivo := "\\clsap\modelo\EBCP CONTRATO DE PRESTAÇÃO DE SERVIÇOS.DOT" 
	endif                                               
else
    
    if mv_par08 == 1  
       Alert("Arquivo à Imprimir não Selecionado - Acesse Novamento ") 
       restarea(aAreaAlias)
       return
	elseif mv_par08 == 2
       cArquivo := "\\clsap\modelo\GNOVA ATUAL CONTR_PREST_SERV.DOT"  
	elseif  mv_par08 == 3
       cArquivo := "\\clsap\modelo\GNOVA_CONTRATO_SERVICE.DOT" 
	endif  
endif
        
// *** Verifica se o arquivo do Word Existe *** //
IF File( cArquivo )  

    // *** Inicio do Processamento  *** //
    dbSelectArea(cAliasA) 
    ProcRegua((cAliasA)->(LastRec()))
    (cAliasA)->(dbGoTop())  

    Do While .not. ( (cAliasA)->(eof()) )    
                            
         // ***                           
     	 dbSelectArea("SA2")   
     	 SA2->(dbsetorder(1)) 
     	 cEstaFornec  	:="SP"
     	 if SA2->(dbseek(xfilial()+ (cAliasA)->RA_FORNEC))
        	cEstaFornec:=SA2->A2_EST
    	 endif
     
     	  // ***
          dbSelectArea(cAliasA) 
          IF (cAliasA)->( !Eof() ) 
             
                 // *** Faz conexao com o MS-Word *** //
                 nhandle := OLE_CreateLink()
                 OLE_NewFile( nhandle, cArquivo )

                 // *** Montagem das macro substituição do WORD *** //  
                 cCepPJConv :=strzero((cAliasA)->RA_CEPPJ,8)      
                 cDataExt1	:=substr( (cAliasA)->RA_ADMISSA,7,2) +" de "+   MESEXTENSO(val(substr( (cAliasA)->RA_ADMISSA,5,2)))  +" de "+ substr( (cAliasA)->RA_ADMISSA,1,4)    
                 cDataExt2	:=substr( (cAliasA)->RA_DEMISSA,7,2) +" de "+   MESEXTENSO(val(substr( (cAliasA)->RA_DEMISSA,5,2)))  +" de "+ substr( (cAliasA)->RA_DEMISSA,1,4)
                 
                 OLE_SetDocumentVar( nhandle, 'cNome',         		CAPITAL(AllTrim( (cAliasA)->RA_NOME )) )    		   			// Nome do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cEndeRes',           CAPITAL(	AllTrim( (cAliasA)->RA_ENDEREC )) )         		// Endereço
                 OLE_SetDocumentVar( nhandle, 'cBairroRes',     	CAPITAL(AllTrim( (cAliasA)->RA_BAIRRO )) )              		// Bairro
                 OLE_SetDocumentVar( nhandle, 'cCEPRes',        	AllTrim( (cAliasA)->RA_CEP ) )                 				   	// Cep do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cCidadeRes',     	CAPITAL(AllTrim( (cAliasA)->RA_MUNICIP )) )			   			// Municipio do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cUFRes',         	AllTrim( (cAliasA)->RA_ESTADO ) )			   					// Estado do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cSalario',       	Transform( (cAliasA)->RA_SALARIO, "@E 9,999,999.99") )  		// Salário
                 OLE_SetDocumentVar( nhandle, 'cExtenso',       	CAPITAL(Extenso( (cAliasA)->RA_SALARIO) ) )         			// Salário por Extenso
                 OLE_SetDocumentVar( nhandle, 'cIdentidade',    	AllTrim( (cAliasA)->RA_RG ) )                	   			    // RG do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cCPF',               AllTrim( (cAliasA)->RA_CIC ) )                    				// CPF do Funcionário
                 OLE_SetDocumentVar( nhandle, 'cNacionalidade', 	CAPITAL(AllTrim( fDesc( "SX5", "34" + (cAliasA)->RA_NACIONA, "X5_DESCRI" )) ) )		// Nacionalidade
                 OLE_SetDocumentVar( nhandle, 'cEstadoCivil',   	CAPITAL(AllTrim( Tabela( "33", (cAliasA)->RA_ESTCIVI, .F. ) )) )  		// Estado Civil     
                 OLE_SetDocumentVar( nhandle, 'cCargoFunc',         CAPITAL(AllTrim(  (cAliasA)->RA_CARGCNT )) ) 			   			   // Cargo, Função do Colaborador PJ  
                 OLE_SetDocumentVar( nhandle, 'cCargoDsCNAE',       CAPITAL(AllTrim(  (cAliasA)->RA_X_DSCNA )) ) 			   			   // Cargo, Função do CNAE PJ 
                 
                 OLE_SetDocumentVar( nhandle, 'cNomeEmp',       	Alltrim(Capital( (cAliasA)->RA_NOMEMPR)) )   		 				   // Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cCNPJ',          	AllTrim( (cAliasA)->RA_CICANT ) )                         					   // CNPJ da Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cEndEmp',      		AllTrim( Capital( (cAliasA)->RA_ENDERPJ) ) )   	   					   // Endereço da Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cBairroEmp',         AllTrim( Capital( (cAliasA)->RA_BAIRRPJ) ) )  							   // Bairro da Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cCepPJ',            	SUBSTR(cCepPJConv ,1,5)+"-"+SUBSTR(cCepPJConv ,6,3)    )   // Cep da Cidade da Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cCidEmpPJ',       	AllTrim(Capital( (cAliasA)->RA_MUNICPJ) ) )   		   				       // Cidade da Empresa do Colaborador
                 OLE_SetDocumentVar( nhandle, 'cUFPJ',            	UPPER(cEstaFornec) )   															   // Estado onde se Localiza a Emmpresa do Colaborador
                          
                 OLE_SetDocumentVar( nhandle, 'cEmpresa',       	Alltrim(Capital(SM0->M0_NOMECOM)) )   		 		  				   // Nossa Empresa 
                 OLE_SetDocumentVar( nhandle, 'cCnpjEmp',      		left(SM0->M0_CGC,2)+"."+substr(SM0->M0_CGC,3,3)+"."+substr(SM0->M0_CGC,6,3)+"/"+substr(SM0->M0_CGC,9,4)+"-"+substr(SM0->M0_CGC,13,2)   )  // CNPJ da Nossa  Empresa 
                 OLE_SetDocumentVar( nhandle, 'cEndNSemp',      	AllTrim( Capital(SM0->M0_ENDCOB) ) )   	   			   				   // Endereço da Nossa Empresa  
                 OLE_SetDocumentVar( nhandle, 'cComplNSemp',   		AllTrim( Capital(SM0->M0_COMPCOB) ) )   	   			   				   // Complemento do Endereço da Nossa Empresa  
                 OLE_SetDocumentVar( nhandle, 'cBairroNSEmp',   	Alltrim(CAPITAL(SM0->M0_BAIRCOB)))  		 							   // Bairro da Nossa Empresa
                 OLE_SetDocumentVar( nhandle, 'cCepPJ',            	left(SM0->M0_CEPCOB,5)+"-"+substr(SM0->M0_CEPCOB,6,3) ) // Cep da Cidade da Nossa Empresa
                 OLE_SetDocumentVar( nhandle, 'cCidEmpPJ',       	Alltrim(CAPITAL(SM0->M0_CIDCOB)) )   		   	   					       // Cidade da Nossa Empresa 
                 OLE_SetDocumentVar( nhandle, 'cUFPJ',              upper(SM0->M0_ESTCOB ))													   // Estado onde se Localiza a Nossa Empresa 
                                  
                 OLE_SetDocumentVar( nhandle, 'cAdmissao',      	CAPITAL( substr( (cAliasA)->RA_ADMISSA,7,2) + "/" + substr( (cAliasA)->RA_ADMISSA,5,2)+"/"+Substr( (cAliasA)->RA_ADMISSA,1,4) ) ) 	 // Dt. Admissão
                 OLE_SetDocumentVar( nhandle, 'cAdmissao',      	CAPITAL(substr( (cAliasA)->RA_DEMISSA,7,2)+"/"+substr( (cAliasA)->RA_DEMISSA,5,2)+"/"+Substr((cAliasA)->RA_DEMISSA,1,4)) )		  	 // Dt. Demissão     
                  
                 OLE_SetDocumentVar( nhandle, 'cVctoExp1',      	CAPITAL(substr( (cAliasA)->RA_VCTOEXP,7,2)+"/"+substr( (cAliasA)->RA_VCTOEXP,5,2)+"/"+Substr((cAliasA)->RA_VCTOEXP,1,4) ) )     		// Dt. do Inicio do Contrato de Experiência
                 OLE_SetDocumentVar( nhandle, 'cVctoExp2',      	CAPITAL(substr( (cAliasA)->RA_VCTEXP2,7,2)+"/"+substr( (cAliasA)->RA_VCTEXP2,5,2)+"/"+Substr((cAliasA)->RA_VCTEXP2,1,4) ) )     		// Dt. do Fim Vencimentodo Contrato de Experiência
                         
                 OLE_SetDocumentVar( nhandle, 'cDtAdmExt',        	LOWER(cDataExt1)	)	   // Dt. Admissão por Extenso  
                 OLE_SetDocumentVar( nhandle, 'cDtDemiExt',       	LOWER(cDataExt2 ) )     // Dt. Demissão por Extenso  
                 OLE_SetDocumentVar( nhandle, 'cdtDBasExt',       	LOWER(STRZERO(DAY((dDataBase)),2)+" de "+CAPITAL(MESEXTENSO((dDataBase)))+" de "+StrZero( Year((dDataBase)),4) ))   	 // Dt. Base (data do dia) por Extenso  
                 
                 // Atualizando as variaveis de Macro Substituição do documento do Word
                 OLE_UpdateFields( nhandle )
   
                 IF MsgYesNo( "Fechar o documento?" )
                    OLE_CloseFile( nhandle )
                    OLE_CloseLink( nhandle )                        
                 ENDIF
          ENDIF
          
          // *** 
          dbSelectArea(cAliasA) 
          (cAliasA)->(dbskip())
          
    Enddo 
else
     Aviso( "Erro", "Arquivo "+cArquivo+" nao encontrado!", { "OK" } )
Endif
(cAliasA)->( DbCloseArea() )
Restarea(aAreaAlias)
RETURN   