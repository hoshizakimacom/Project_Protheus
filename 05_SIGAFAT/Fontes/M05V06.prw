#include "Totvs.ch"

/*/{Protheus.doc} M05V06
Validação de Campos do Pedido de Venda

@type function
@author	Jorge Heitor T. de Oliveira
@since 06/06/2023
@version P12
@database MSSQL

/*/
User Function M05V06(cField)
    Local cTipoVen
    Local lReturn

    cTipoVen := AllTrim(cValToChar(M->C5_XTPVEN))

    If cField == "C5_XTPVEN" .And. !Empty(cTipoVen)
        //Atualiza todos os itens do aCols com o armazem correto
        lReturn := atualizaDados(cTipoVen)

    EndIf

Return lReturn

/*
    Atualiza aCols com Armazem Padrão dos produtos, ou com Armazém fixo
*/
Static Function atualizaDados(cTipoVen)
    Local nItem         as numeric
    Local nPosLocal     as numeric
    Local nPosProduto   as numeric
    Local lCustom       as logical
    Local cLocPad       as character
    Local lReturn       as logical

    lReturn := .T. //Fixo por se tratar de uma atualização

    nPosLocal := aScan(aHeader,{|x,y|x[2] = 'C6_LOCAL'})
    nPosProduto := aScan(aHeader,{|x,y|x[2] = 'C6_PRODUTO'})

    lCustom := (cTipoVen $ "7/8") //Peças ou Suporte

    If lCustom
        cLocPad := GetNewPar("AM_ARMPAD","36") //Para carregar informações diferentes de "36", criar o parâmetro no Configurador.

    Else
        cLocPad := ""

    EndIf

    For nItem := 1 to Len(aCols)
        If ! aCols[nItem][Len(aHeader)+1] .And. !Empty(aCols[nItem][nPosProduto]) //Se a linha não estiver deletada e tiver produto preenchido
            If !lCustom
                cLocPad := Posicione("SB1", 1, FWxFilial("SB1") + aCols[nItem][nPosProduto], "B1_LOCPAD")

            EndIf

            aCols[nItem][nPosLocal] := cLocPad

        EndIf

    Next nItem

    GetDRefresh()

Return lReturn
