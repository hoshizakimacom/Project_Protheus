#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de ARE - Autorização de Retorno de Equipamentos
//+------------------------------------------------------------------------------------------------
User Function M28A02()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZAC')
    _oBrowse:SetDescription('Autorização de Retorno de Equipamento')

   _oBrowse:AddLegend( "ZAC->ZAC_STATUS == '1'", "GREEN", "Aberta" )
   _oBrowse:AddLegend( "ZAC->ZAC_STATUS == '2'", "RED", "Finalizada" )
   _oBrowse:AddLegend( "ZAC->ZAC_STATUS == '3'", "BLACK", "Cancelada" )

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M28A02' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M28A02' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M28A02' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M28A02' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZAC := FWFormStruct( 1, 'ZAC', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M28A02M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZACMASTER', /*cOwner*/, oStruZAC, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Redes' )

    oModel:GetModel( 'ZACMASTER' ):SetDescription( 'Dados da Are' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M28A02' )
    Local oStruZAC := FWFormStruct( 2, 'ZAC' )
    Local oView
    Private cCampos := {}

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZAC', oStruZAC, 'ZACMASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZAC', 'TELA' )
Return oView
