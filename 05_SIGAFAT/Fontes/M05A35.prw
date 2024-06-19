#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de Sugrupos de produtos
//+------------------------------------------------------------------------------------------------
User Function M05A35()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZAB')
    _oBrowse:SetDescription('Especificações Técnicas')
    
	//Adicona legenda ao browse
	_oBrowse:AddLegend( "ZAB_STATUS == '1'", "GREEN"	, "Especificação Ativa"	)	
	_oBrowse:AddLegend( "ZAB_STATUS == '2'", "RED"		, "Especificação Inativa" )	    

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M05A35' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M05A35' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M05A35' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M05A35' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZAB := FWFormStruct( 1, 'ZAB', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M05A35M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZABMASTER', /*cOwner*/, oStruZAB, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Especificações Técnicas' )

    oModel:GetModel( 'ZABMASTER' ):SetDescription( 'Dados da Especificações Técnicas' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M05A35' )
    Local oStruZAB := FWFormStruct( 2, 'ZAB' )
    Local oView
    Private cCampos := {}

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZAB', oStruZAB, 'ZABMASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZAB', 'TELA' )
Return oView
