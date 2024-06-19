#Include "Protheus.ch"
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA120G2                                                                                              |
 | Desc:  Ponto de Entrada para gravar informa��es no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MTA120G2()

Local aArea := GetArea()
//Atualiza a descri��o, com a vari�vel p�blica criada no ponto de entrada MT120TEL
SC7->C7_OBS      := cXObsAux
SC7->C7_DT_EMB   := cXDtEmbarq
RestArea(aArea)

Return
