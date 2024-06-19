USER FUNCTION M10A04()

LOCAL cFiltro   := ""

//LOCAL aCores  := {{ 'ZAB->PA1_STATUS=="1"' , 'ENABLE'  },;   // Ativo   - Verde    - Numero Disponível
//                  { 'ZAB->PA1_STATUS=="2"' , 'DISABLE' }}    // Inativo - Vermelho - Numero Indisponível

PRIVATE cAlias   := 'ZAB'

//PRIVATE _cCpo  := "PA1_FILIAL/PA1_PRODUT/PA1_DESC"

PRIVATE cCadastro := "Tabela de Números de Série"

PRIVATE aRotina     := {{"Pesquisar" , "AxPesqui"    	 , 0, 1 , , .F.} ,;
                                       {"Visualizar"	 , "AxVisual"	, 0, 2 },;		
                                       {"Etq. Logistica" , "U_M04E01"   , 0, 6 },;
                                       {"Etq. Interna" 	 , "U_M10E03"   , 0, 6 },;
                                       {"Etq. Ckeck List", "U_M10E04"   , 0, 6 }}
//                                     {"Excluir"    	 , "U_CTJA010B"   , 0, 5 },;
//                                     {"Consultar"  	 , "U_CTJA010C"   , 0, 6 },;
//                                     {"Legenda"    	 , "U_CTJA10LEG"  , 0, 7, 0, .F. }}       //"Legenda"

dbSelectArea("ZAB")
dbSetOrder(1)

mBrowse( ,,,,"ZAB",,,,,,/*aCores*/,,,,,,,,cFiltro) 

RETURN NIL
