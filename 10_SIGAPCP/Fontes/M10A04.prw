#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M10A04()

LOCAL CFILTRO := ""

PRIVATE CALIAS := "ZAB"

PRIVATE CCADASTRO := "TABELA DE NÚMEROS DE SÉRIE"

PRIVATE AROTINA := {{"PESQUISAR","AXPESQUI",0,1,, .F. },{"VISUALIZAR","AXVISUAL",0,2},{"ETQ. LOGISTICA","U_M04E01",0,6},{"ETQ. INTERNA","U_M10E03",0,6},{"ETQ. CKECK LIST","U_M10E04",0,6}}

DBSELECTAREA("ZAB")
DBSETORDER(1)

MBROWSE(,,,,"ZAB",,,,,,,,,,,,,,CFILTRO)

RETURN NIL

