#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de Linha de produtos
//+------------------------------------------------------------------------------------------------
User Function M05A36()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZAF')
    _oBrowse:SetDescription('Linha de Produtos')

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M05A36' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M05A36' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M05A36' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M05A36' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZA1 := FWFormStruct( 1, 'ZAF', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M05A36M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZAFMASTER', /*cOwner*/, oStruZA1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Linha de Produtos' )

    oModel:GetModel( 'ZAFMASTER' ):SetDescription( 'Dados de Linha de Produtos' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M05A36' )
    Local oStruZA1 := FWFormStruct( 2, 'ZAF' )
    Local oView

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZAF', oStruZA1, 'ZAFMASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZAF', 'TELA' )
Return oView
