#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de Sugrupos de produtos
//+------------------------------------------------------------------------------------------------
User Function M05A14()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZA2')
    _oBrowse:SetDescription('Subgrupo de Produtos')

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M05A14' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M05A14' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M05A14' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M05A14' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZA2 := FWFormStruct( 1, 'ZA2', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M05A12M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZA2MASTER', /*cOwner*/, oStruZA2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Subgrupo de Produtos' )

    oModel:GetModel( 'ZA2MASTER' ):SetDescription( 'Dados de Subgrupos de Produtos' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M05A14' )
    Local oStruZA2 := FWFormStruct( 2, 'ZA2' )
    Local oView
    Private cCampos := {}

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZA2', oStruZA2, 'ZA2MASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZA2', 'TELA' )
Return oView
