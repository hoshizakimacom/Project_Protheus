#Include "Protheus.ch"
#Include "MSMGADD.CH"
#Include "TOPCONN.CH"
#Include "FWMVCDEF.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M06A10  บAutor  ณ                     บ Data ณ 16/04/24    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Controle de Cobran็a							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Acos Macom                                  	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function M06A10()

//Variaveis Locais
Local aTRB := {}
Local aHeadMBrow := {}

//Variaveis Private
Private cCadastro	:= "Titulos Financeiro - Receber"
Private c_Perg	:= "M06A10"
Private aCores    := {}


//Private aRotina 	:= MenuDef()

//Menudef()
//CriaSX1()

aAdd(aCores,{"TRB->SALDO >  0", "BLACK",  "Cobranca"  })
aAdd(aCores,{"TRB->SALDO == 0", "RED",    "Encerrado" })


If !Pergunte('M06A10',.T.)
	Return nil
EndIf

MsgRun("Criando estrutura e carregando dados no arquivo temporแrio...",,{|| aTRB := FileTRB() } )

MsgRun("Criando coluna para MBrowse...",,{|| aHeadMBrow := HeadBrow() } )

dbSelectArea("TRB")
dbSetOrder(1)

MBrowse(6,1,22,75,"TRB",aHeadMBrow,,,,,aCores)

//Fecha a แrea
TRB->(dbCloseArea())
//Apaga o arquivo e indices fisicamente
//FErase( aTRB[ nTRB ] + GetDbExtension())
//FErase( aTRB[ nIND1 ] + OrdBagExt())
//FErase( aTRB[ nIND2 ] + OrdBagExt())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MENUDEF  บAutor                       บ Data ณ 26/03/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para visulaiza็ใo dos Tํtulos a Receber indexados   บฑฑ
ฑฑบ          ณ conforme solita็ใo de usuแrio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MenuDef()

Local aRotina 	:= {}
//----------------------------------------------------------
// Adiciona bot๕es do browse
//----------------------------------------------------------
ADD OPTION aRotina TITLE 'Visualiza'	ACTION 'U_M06V10()'	 OPERATION 2 ACCESS 0 // 'Visual'
//ADD OPTION aRotina TITLE 'Follow-up'	ACTION 'U_M06F10(TRB->FILIAL,TRB->CLIENTE,TRB->LOJA,TRB->PREFIXO,TRB->NUMERO,TRB->PARCELA)'  	 OPERATION 2 ACCESS 0 // 'Consulta Cli'
ADD OPTION aRotina TITLE 'Follow-up'	ACTION 'U_M06F10(TRB->FILIAL,TRB->CLIENTE,TRB->LOJA,TRB->PREFIXO,TRB->NUMERO,TRB->PARCELA,TRB->EMISSAO,TRB->VENCTO,TRB->VALOR,TRB->SALDO)'  	 OPERATION 2 ACCESS 0 // 'Consulta Cli'

Return aRotina



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HEADBROW  บAutor                      บ Data ณ 26/03/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para visulaiza็ใo dos Tํtulos a Receber indexados   บฑฑ
ฑฑบ          ณ conforme solita็ใo de usuแrio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function HeadBrow()

Local aHead := {}
//Campos que aparecerใo na MBrowse, como nใo ้ baseado no SX3 deve ser criado.
//Sequ๊ncia do vetor: Tํtulo, Campo, Tipo, Tamanho, Decimal, Picture

AADD( aHead , { "FILIAL"		,{|| TRB->FILIAL		}, "C", Len(TRB->FILIAL	 )  , 0, "" })
AADD( aHead , { "NUMERO"		,{|| TRB->NUMERO		}, "C", Len(TRB->NUMERO	 )  , 0, "" })
AADD( aHead , { "PREFIXO"	 	,{|| TRB->PREFIXO		}, "C", Len(TRB->PREFIXO )  , 0, "" })
AADD( aHead , { "PARCELA" 	 	,{|| TRB->PARCELA		}, "C", Len(TRB->PARCELA )  , 0, "" })
AADD( aHead , { "TIPO"		 	,{|| TRB->TIPO			}, "C", Len(TRB->TIPO	 )  , 0, "" })
AADD( aHead , { "CLIENTE"	 	,{|| TRB->CLIENTE		}, "C", Len(TRB->CLIENTE )  , 0, "" })
AADD( aHead , { "LOJA"		 	,{|| TRB->LOJA			}, "C", Len(TRB->LOJA	 )  , 0, "" })
AADD( aHead , { "NOME" 			,{|| TRB->NOME			}, "C", Len(TRB->NOME	 )  , 0, "" })
AADD( aHead , { "CNPJ	"		,{|| TRB->CNPJ			}, "C", Len(TRB->CNPJ	 )  , 0, "" })
AADD( aHead , { "EMISSAO"	 	,{|| TRB->EMISSAO		}, "D", 10					, 0, "" })
AADD( aHead , { "VENCTO"		,{|| TRB->VENCTO 		}, "D", 10                  , 0, "" })
AADD( aHead , { "VALOR"		 	,{|| TRB->VALOR			}, "N", 19					, 2, "@E 999,999,999.99" })
AADD( aHead , { "VALORPED"		,{|| TRB->VALORPED		}, "N", 19					, 2, "@E 999,999,999.99" })
AADD( aHead , { "SALDO"		 	,{|| TRB->SALDO			}, "N", 19					, 2, "@E 999,999,999.99" })
AADD( aHead , { "CONDPAG"		,{|| TRB->CONDPAG		}, "C", Len(TRB->CONDPAG )  , 0, "" })
AADD( aHead , { "PEDIDO"		,{|| TRB->PEDIDO		}, "C", Len(TRB->PEDIDO	 )  , 0, "" })
AADD( aHead , { "GERENCIA"		,{|| TRB->GERENCIA		}, "C", Len(TRB->GERENCIA )  , 0, "" })
AADD( aHead , { "REPRESEN"	 	,{|| TRB->REPRESEN		}, "C", Len(TRB->REPRESEN )  , 0, "" })
AADD( aHead , { "CONTATO"	 	,{|| TRB->CONTATO		}, "C", Len(TRB->CONTATO )   , 0, "" })
//AADD( aHead , { "NOMECONT"	 	,{|| TRB->NOMECONT		}, "C", Len(TRB->NOMECONT )  , 0, "" })
AADD( aHead , { "EMAIL"			,{|| TRB->EMAIL			}, "C", Len(TRB->EMAIL )  	 , 0, "" })
//AADD( aHead , { "ENCERRADO"	 	,{|| TRB->ENCERRADO		}, "C", Len(TRB->ENCERRADO )   , 0, "" })


Return( aHead )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HEADBROW  บAutor  ณ                   บ Data ณ 26/03/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para visulaiza็ใo dos Tํtulos a Receber indexados   บฑฑ
ฑฑบ          ณ conforme solita็ใo de usuแrio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FileTRB()
Local aStruct := {}
Local cQuery := ' '

Local cArqTRB := ""
Local cInd1 := ""
Local cInd2 := ""

Local nI := 0

Local nVez := 0
//Crio a estrutura do arquivo
AADD( aStruct , { "FILIAL"   	, "C" , 04 , 0 } )
AADD( aStruct , { "NUMERO" 	 	, "C" , 09 , 2 } )
AADD( aStruct , { "PREFIXO"    	, "C" , 03 , 0 } )
AADD( aStruct , { "PARCELA"	 	, "C" , 01 , 0 } )
AADD( aStruct , { "TIPO"     	, "C" , 03 , 0 } )
AADD( aStruct , { "CLIENTE" 	, "C" , 06 , 0 } )
AADD( aStruct , { "LOJA" 		, "C" , 02 , 0 } )
AADD( aStruct , { "NOME" 		, "C" , 20 , 0 } )
AADD( aStruct , { "CNPJ" 		, "C" , 16 , 0 } )
AADD( aStruct , { "EMISSAO" 	, "D" , 08 , 0 } )
AADD( aStruct , { "VENCTO" 	 	, "D" , 08 , 0 } )
AADD( aStruct , { "VALOR" 		, "N" , 20 , 2 } )
AADD( aStruct , { "VALORPED"	, "N" , 20 , 2 } )
AADD( aStruct , { "SALDO" 		, "N" , 20 , 2 } )
AADD( aStruct , { "CONDPAG" 	, "C" , 03 , 0 } )
AADD( aStruct , { "PEDIDO" 	 	, "C" , 06 , 0 } )
AADD( aStruct , { "REPRESEN" 	, "C" , 06 , 0 } )
AADD( aStruct , { "GERENCIA" 	, "C" , 06 , 0 } )
AADD( aStruct , { "CONTATO" 	, "C" , 06 , 0 } )
//AADD( aStruct , { "NOMECONT"	, "C" , 20 , 0 } )
//AADD( aStruct , { "ENCERRADO" 	, "C" , 01 , 0 } )
AADD( aStruct , { "EMAIL" 	 	, "C" , 200 , 0 } )

AADD( aStruct , { "RECNO" 		 , "N" , 20 , 0 } )
AADD( aStruct , { "RECSA1" 		 , "N" , 20 , 0 } )

// Crio fisicamente o arquivo.
cArqTRB := CriaTrab( aStruct, .T. )
cInd1 := Left( cArqTRB, 7 ) + "1"
cInd2 := Left( cArqTRB, 7 ) + "2"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )

// Criar os ํndices.
IndRegua( "TRB", cInd1, "CLIENTE+DTOS(VENCTO)+NUMERO+PARCELA"			,,,"Criando ํndices (CLIENTE+DTOS(VENCTO)+NUMERO+PARCELA)...",.T.)
IndRegua( "TRB", cInd2, "FILIAL+CLIENTE+DTOS(VENCTO)+NUMERO+PARCELA", , ,  "Criando ํndices (FILIAL+CLIENTE+DTOS(VENCTO)+NUMERO+PARCELA)...",.T.)

// Libera os ํndices.
dbClearIndex()

// Agrega a lista dos ํndices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetIndex( cInd2 + OrdBagExt() )

// Carregar os dados  em TRB.
If MV_PAR01 == 1
	
	cQuery += " SELECT E1_FILIAL FILIAL, E1_PREFIXO PREFIXO, E1_NUM NUMERO, E1_PARCELA PARCELA, E1_PEDIDO PEDIDO, " 										+CRLF
	cQuery += " E1_TIPO TIPO, E1_CLIENTE CLIENTE, E1_LOJA LOJA, A1_NOME NOME, E1_NOMCLI CLI_FANT, A1_CGC CNPJ, C5_CONDPAG CONDPAG, " 						+CRLF
	cQuery += " C5_VEND1 REPRESEN, C5_VEND1 GERENCIA, C5_XEMAILC EMAIL, C5_XCONT CONTATO, " +CRLF // C5_XNCONT NOMECONT,"  										+CRLF
	cQuery += " E1_EMISSAO EMISSAO, E1_VENCREA VENCTO, E1_VALOR VALOR, E1_VLCRUZ VALORPED, E1_SALDO SALDO, SE1.R_E_C_N_O_ RECNO, SA1.R_E_C_N_O_ RECSA1 " 	+CRLF
	cQuery += " FROM  "+RetSqlName('SE1')+"  SE1 
	cQuery += "  INNER JOIN "+RetSqlName('SA1')+" SA1 ON   A1_FILIAL = '"+xFilial('SA1')+"' AND E1_CLIENTE = A1_COD     AND E1_LOJA  = A1_LOJA AND SA1.D_E_L_E_T_ <> '*' "	+CRLF
	//cQuery += "  INNER JOIN "+RetSqlName('SF2')+" SF2 ON   F2_FILIAL = '"+xFilial('SF2')+"' AND E1_CLIENTE = F2_CLIENTE AND E1_LOJA  = F2_LOJA AND E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE  AND SF2.D_E_L_E_T_ <> '*' "	+CRLF

//	cQuery += "  INNER JOIN "+RetSqlName('SC5')+" SC5 ON   C5_FILIAL = '"+xFilial('SC5')+"' AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA  = C5_LOJACLI AND E1_NUM = C5_NOTA AND E1_PREFIXO = C5_SERIE  AND SC5.D_E_L_E_T_ <> '*' "	+CRLF
	cQuery += "  INNER JOIN "+RetSqlName('SC5')+" SC5 ON   C5_FILIAL = '"+xFilial('SC5')+"' AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA  = C5_LOJACLI AND E1_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ <> '*' "	+CRLF

	cQuery += " WHERE E1_VENCREA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"															+CRLF
	cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"	+CRLF
	
	If mv_par06 == 1	// Exibe Titulos Encerrados com Hist."
		cQuery += " AND (E1_SALDO > 0 OR ( SELECT COUNT(*) FROM "+RetSqlName('ZAI')+" ZAI WHERE ZAI_FILIAL = '"+xFilial("ZAI")+"' AND ZAI_PREFIX = E1_PREFIXO AND ZAI_NUM = E1_NUM AND ZAI_PARCEL = E1_PARCELA AND ZAI_TIPO = E1_TIPO AND ZAI.D_E_L_E_T_ <> '*' ) > 0)
	Else
		cQuery += " AND E1_SALDO > 0
	EndIf
	cQuery += " AND E1_TIPO IN ('NF ','BOL') "
	cQuery += " AND SE1.D_E_L_E_T_<>'*'"																										+CRLF
	

Elseif MV_PAR01 == 2

	cQuery +=" SELECT DISTINCT E1_FILIAL FILIAL, E1_PREFIXO PREFIXO, E1_NUM NUMERO, E1_PARCELA PARCELA, E1_PEDIDO PEDIDO, " 									+CRLF
	cQuery +=" E1_TIPO TIPO, E1_CLIENTE CLIENTE, E1_LOJA LOJA, A1_NOME NOME, E1_NOMCLI CLI_FANT, A1_CGC CNPJ,  C5_CONDPAG CONDPAG, " 							+CRLF
	cQuery +=" C5_VEND1 REPRESEN, C5_VEND1 GERENCIA, C5_XEMAILC EMAIL,  C5_XCONT CONTATO, " +CRLF // C5_XNCONT NOMECONT,"  											
	cQuery +=" E1_EMISSAO EMISSAO, E1_VENCREA VENCTO, E1_VALOR VALOR, E1_VLCRUZ VALORPED, E1_SALDO SALDO, SE1.R_E_C_N_O_ RECNO, SA1.R_E_C_N_O_ RECSA1 " 		+CRLF
	cQuery +=" FROM  "+RetSqlName('ZAI')+"  ZAI 
	cQuery +=" 	INNER JOIN "+RetSqlName('SE1')+" SE1 ON   E1_FILIAL = ZAI_FILIAL AND E1_CLIENTE = ZAI_CLIENT AND E1_LOJA = ZAI_LOJA	AND E1_PREFIXO = ZAI_PREFIX	AND E1_NUM = ZAI_NUM AND E1_PARCELA = ZAI_PARCEL AND ZAI_TIPO = E1_TIPO AND SE1.D_E_L_E_T_ <> '*'"		+CRLF
	cQuery +=" 	INNER JOIN "+RetSqlName('SA1')+" SA1 ON   A1_FILIAL = '"+xFilial('SA1')+"' AND E1_CLIENTE = A1_COD AND E1_LOJA  = A1_LOJA AND SA1.D_E_L_E_T_ <> '*'"																			+CRLF
	//cQuery +=" 	INNER JOIN "+RetSqlName('SF2')+" SF2 ON   F2_FILIAL = ZAI_FILIAL AND F2_CLIENTE = ZAI_CLIENT AND F2_LOJA = ZAI_LOJA	AND F2_SERIE = ZAI_PREFIX	AND F2_DOC = ZAI_NUM AND SF2.D_E_L_E_T_ <> '*'"									+CRLF
	cQuery += " INNER JOIN "+RetSqlName('SC5')+" SC5 ON   C5_FILIAL = '"+xFilial('SC5')+"' AND ZAI_CLIENT = C5_CLIENTE AND ZA1_LOJA = C5_LOJACLI AND ZAI_NUM = C5_NOTA AND ZAI_PREFIX = C5_SERIE  AND SC5.D_E_L_E_T_ <> '*' "					+CRLF
	cQuery +=" WHERE ZAI_AGEN BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"																	+CRLF
	cQuery +=" AND ZAI_CLIENT BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"																				+CRLF
	cQuery +=" AND E1_SALDO > 0 "																														+CRLF
	cQuery +=" AND ZAI.D_E_L_E_T_<>'*'"																													+CRLF
	
Endif
        
cQuery:= ChangeQuery(cQuery)
//MemoWrite("QUERIES\RFINA06.SQL",cQuery)

//ณ Verifica se a area ja' se encontra aberta.                   ณ
If Select("QRY") > 0
	dbSelectArea("QRY")
	QRY->(dbCloseArea())
EndIf

//Processo a query e trato os campos que sใo data
TcQuery cQuery New Alias 'QRY'
TCSetField('QRY','EMISSAO'	,'D')
TCSetField('QRY','VENCTO'	,'D')

QRY->( dbGoTop() )

nVez := Len(aStruct)
While ! QRY->( EOF() )
	RecLock("TRB",.T.)
	
	For nI := 1 To nVez
		TRB->( FieldPut( nI, QRY->(FieldGet( QRY->(FieldPos(aStruct[nI][1]))))))
	Next nI
	
	TRB->(MsUnLock())
	QRY->( dbSkip() )
End

Return({cArqTRB,cInd1,cInd2})

/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M06V10  บAutor  ณ                   บ Data ณ 26/03/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para visulaiza็ใo dos Tํtulos a Receber indexados   บฑฑ
ฑฑบ          ณ conforme solita็ใo de usuแrio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function M06V10()

Local aArea:= GetArea()

/*Posiciono no no cliente e chamo a fun็ใo padrใo
de consulta*/
dbSelectArea('SE1')
dbGoTo(TRB->RECNO)

AxVisual("SE1", TRB->RECNO,2,,,,,,)

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณValidPerg บ Autor ณ 				     บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

//Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
aAdd(aRegs,{c_Perg,"01"	,"Tipo Data?"			,''		,''			,"mv_ch1"	,"N"	,1			,0			,2			,"C"	,""		,""		,""			,""		,"mv_par01"	,"Vencimento"	,"Si"		,"Yes"		,""		,"Agendamento"	,"No"		,"No"		,""		,""			,""			,""		,""			,""			,""		,""			,""			,""		,""		,""})
aAdd(aRegs,{c_Perg,"02","Vencto/Agend. de ?"	,'','',"mv_ch2","D",8,0, ,"G","","","","","mv_par02","","","","","","","",""	,"","","","","","","","",""   })
aAdd(aRegs,{c_Perg,"03","Vencto/Agend. at้?"	,'','',"mv_ch3","D",8,0, ,"G","","","","","mv_par03","","","","","","","",""	,"","","","","","","","",""  })
aAdd(aRegs,{c_Perg,"04","Cliente de?"			,'','',"mv_ch4","C",TamSx3("A1_COD")[1],0, ,"G","","SA1","","","mv_par04","","","","","","","",""	,"","","","","","","","",""  })
aAdd(aRegs,{c_Perg,"05","Cliente At้?"			,'','',"mv_ch5","C",TamSx3("A1_COD")[1],0, ,"G","","SA1","","","mv_par05","","","","","","","",""	,"","","","","","","","","" })
aAdd(aRegs,{c_Perg,"06","Follow Up Ja Encerrado?","","","mv_ch06"	,"N", 01,0,0,"C","","mv_par06","Sim            "	,"Sim            "	,"Sim            "	,""				,"               "	,"Nao            "	,"Nao            "	,"Nao            "	,"","","               "	,"               "	,"               "	,"","","","","","","","","","","",""  		,"","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf	
Next

dbSelectArea(_sAlias)

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM06F10   บAutor  ณ             	     บ Data ณ  03/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada para inserir botใo no aRotina              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M06F10(cFil,cCLi,cLoj,cPref,cNum,cParc,cPedido)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cFiltro   	:= ""

Private aCores 		:= {}
Private cAlias		:= "ZAI"

Private cCpo     	:= "ZAI_FILIAL/ZAI_CLIENT/ZAI_LOJA/ZAI_PREFIX/ZAI_NUM/ZAI_PARCEL,ZAI_PEDIDO"
Private cCadastro  	:= "Inclusใo de Follow Up"
Private aRotina 	:= MenuDef1()
Public _cFili		:= cFil
Public _cClien		:= cCli
Public _cLojaC		:= cLoj
Public _cNume		:= cNum
Public _cPrefi		:= cPref
Public _cParcel		:= cParc
Public _nSaldoA 	:= Posicione("SE1",2,cFil+cCli+cLoj+cPref+cNum+cParc,"E1_SALDO")
Public _nValorA		:= SE1->E1_VALOR
Public _cVencA		:= SE1->E1_VENCREA
Public _cEmisA		:= SE1->E1_EMISSAO
Public _cPedido		:= SE1->E1_PEDIDO

cFiltro := "ZAI_FILIAL = '"+cFil+"' AND ZAI_CLIENT = '"+cCli+"' AND ZAI_LOJA = '"+cLoj+"' AND ZAI_NUM = '"+cNum+"' AND ZAI_PREFIX = '"+cPref+"' AND ZAI_PARCEL = '"+cParc+"' "

dbSelectArea("ZAI")
dbSetOrder(1)
mBrowse(,,,,"ZAI",,,,,,aCores,,,,,,,,cFiltro)
//mBrowse(,,,,"ZAI",,,,,,,,,,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMA01   บAutor  ณ                    บ Data ณ  08/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef1()

Local aRet  :=  {{"Pesquisar" , "AxPesqui"    , 0, 1},;
{"Consultar" , "AxVisual"   , 0, 2},;
{"Incluir"  , "AxInclui"   , 0, 3},;
{"Altera"  , "AxAltera"   , 0, 4}}

Return(aRet)
