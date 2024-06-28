#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//+------------------------------------------------------------------------------------------------
//| Cadastro de Valores de Rateio de Chapas por mês
//| Utilizado para ratear os valores de consumo de chamas nas Ordens de Producao
//+------------------------------------------------------------------------------------------------
User Function M04A01()
    Local _oBrowse  := FwMBrowse():New()

    _oBrowse:SetAlias('ZAH')
    _oBrowse:SetDescription('Valores de Rateio de MOD/e MOD.Chapas')

    _oBrowse:Activate()
Return

//+------------------------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.M04A01' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.M04A01' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.M04A01' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.M04A01' OPERATION 5 ACCESS 0
Return aRotina


//+------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oStruZA1 := FWFormStruct( 1, 'ZAH', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    oModel := MPFormModel():New('M05A36M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields( 'ZAHMASTER', /*cOwner*/, oStruZA1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
    oModel:SetDescription( 'Rateio de Chapas' )

    oModel:GetModel( 'ZAHMASTER' ):SetDescription( 'Dados dos Produtos' )

Return oModel

//+------------------------------------------------------------------------------------------------
Static Function ViewDef()
    Local oModel   := FWLoadModel( 'M04A01' )
    Local oStruZA1 := FWFormStruct( 2, 'ZAH' )
    Local oView

    oView := FWFormView():New()

    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZAH', oStruZA1, 'ZAHMASTER' )

    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_ZAH', 'TELA' )
Return oView
