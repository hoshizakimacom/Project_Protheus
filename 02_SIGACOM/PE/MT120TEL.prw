#Include "Protheus.ch"
   /*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT120TEL                                                                                              |
 | Desc:  Ponto de Entrada para adicionar campos no cabeçalho do pedido de compra                               |
 | Link:  http://tdn.totvs.com/display/public/mp/MT120TEL                                                       |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local lEdit     := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia
    Local oXObsAux
    Local oXDtEmbarq
    Public cXObsAux := ""
    Public cXDtEmbarq := ""

    //Define o conteúdo para os campos
    SC7->(DbGoTo(nRecPC))
    If nOpcx == 3
        cXObsAux   := CriaVar("C7_OBS",.F.)
        cXDtEmbarq := CriaVar("C7_DT_EMB",.F.)
    Else
        cXObsAux   := SC7->C7_OBS
        cXDtEmbarq := SC7->C7_DT_EMB
    EndIf
 
     //Criando na janela o campo Data Embarque  
    @ 051, aPosGet[1,12] + 010 SAY Alltrim(RetTitle("C7_DT_EMB")) OF oDlg PIXEL SIZE 080,006
    @ 049, aPosGet[1,12] + 047 MSGET oXDtEmbarq VAR cXDtEmbarq SIZE 40, 006 OF oDlg COLORS 0, 16777215  PIXEL
    oXDtEmbarq:bHelp := {|| ShowHelpCpo( "C7_DT_EMB", {GetHlpSoluc("C7_DT_EMB")[1]}, 5  )}

    //Criando na janela o campo OBS
    @ 062, aPosGet[1,08] - 012 SAY Alltrim(RetTitle("C7_OBS")) OF oDlg PIXEL SIZE 050,006
    @ 061, aPosGet[1,09] - 006 MSGET oXObsAux VAR cXObsAux SIZE 100, 006 OF oDlg COLORS 0, 16777215  PIXEL
    oXObsAux:bHelp := {|| ShowHelpCpo( "C7_OBS", {GetHlpSoluc("C7_OBS")[1]}, 5  )}
     
    //Se não houver edição, desabilita os gets
    If !lEdit
        oXObsAux   :lActive := .F.
        oXDtEmbarq :lActive := .F.

    EndIf
 
    RestArea(aArea)
Return
