#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de Codigo de instalação
//+------------------------------------------------------------------------------------------------
User Function M05A17()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZA5')
    _oBrowse:SetDescription('Instalação Macom')

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M05A17' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M05A17' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M05A17' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M05A17' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZA5 := FWFormStruct( 1, 'ZA5', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M05A17M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZA5MASTER', /*cOwner*/, oStruZA5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Instalação Macom' )

    oModel:GetModel( 'ZA5MASTER' ):SetDescription( 'Dados da Instalação Macom' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M05A17' )
    Local oStruZA5 := FWFormStruct( 2, 'ZA5' )
    Local oView
    Private cCampos := {}

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZA5', oStruZA5, 'ZA5MASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZA5', 'TELA' )
Return oView
