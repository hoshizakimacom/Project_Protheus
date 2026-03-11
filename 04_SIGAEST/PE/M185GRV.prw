#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M185GRV()

LOCAL AAREA := GETAREA()

RECLOCK("SD3", .F. )
SD3->D3_DOC := "SA"+SCP->CP_NUM
SD3->(MSUNLOCK())

RESTAREA(AAREA)

RETURN 

