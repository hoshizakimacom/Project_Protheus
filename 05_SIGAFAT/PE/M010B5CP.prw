#Include 'Protheus.ch'
#include 'FWMVCDef.ch'
 
User Function M010B5CP()
Local lRet      := .T.
Local oModel    := Nil
Local nOpcx     := 0
Local lCopy     := .F.
Local lIsMvc    := ( Type( 'ParamIXB' ) == 'A' )
 
If lIsMvc
    oModel  := ParamIXB[ 1 ]
    nOpcx   := ParamIXB[ 2 ]
    lCopy   := ParamIXB[ 3 ]
     
    oModel:LoadValue( 'B5_XCLASCL', CriaVar( 'B5_XCLASCL', .F. ) )
    oModel:LoadValue( 'B5_XCONSUM', CriaVar( 'B5_XCONSUM', .F. ) )
    oModel:LoadValue( 'B5_XFLUIDO', CriaVar( 'B5_XFLUIDO', .F. ) )
    oModel:LoadValue( 'B5_XGAS', CriaVar( 'B5_XGAS', .F. ) )
    oModel:LoadValue( 'B5_XGPROT', CriaVar( 'B5_XGPROT', .F. ) )
    oModel:LoadValue( 'B5_XPOTENC', CriaVar( 'B5_XPOTENC', .F. ) )
    oModel:LoadValue( 'B5_XCORNT', CriaVar( 'B5_XCORNT', .F. ) )
    oModel:LoadValue( 'B5_XTENSAO', CriaVar( 'B5_XTENSAO', .F. ) )
    oModel:LoadValue( 'B5_XFLUID', CriaVar( 'B5_XFLUID', .F. ) )
    oModel:LoadValue( 'B5_XCATEGO', CriaVar( 'B5_XCATEGO', .F. ) )
 
EndIf
 
Return lRet
