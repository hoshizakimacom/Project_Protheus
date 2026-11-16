#include "protheus.ch"
#include "parmtype.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MyCRMA980

Ponto de Entrada do Cadastro de Clientes (MVC)
@param      Nao ha
@return     Varios. Dependera de qual PE esta sendo executado.
@author     Faturamento
@version    12.1.2410 / Superior
@since      27/11/2025
/*/

User Function CRMA980() 
    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local lIsGrid       := .F.
//  Local nLinha        := 0
//  Local nQtdLinhas    := 0
//  Local cRotMVC       := "CRMA980"
    Local cIDPonto      := ''
    Local cIDModel      := ''
//  Local cIDForm       := ''
//  Local cEvento       := ''
//  Local cCampo        := ''
//  Local cConteudo     := ''
//  Local cMsg          := ''
    Local oObj          := NIL
    Local nF

    If aParam <> NIL
        oObj        := aParam[1]
        cIDPonto    := aParam[2]
        cIDModel    := aParam[3]
        lIsGrid     := (Len(aParam) > 3)
        nOperation := oObj:GetOperation()

        If cIDPonto == 'MODELCOMMITTTS'
            //ApMsgInfo("Chamada após a gravação total do modelo e fora da transação.")

            If nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE 

                    /*
                    CTB - CONSUMIDOR FINAL CONTRIBUIENTE
                                A1_GRPTRIB = CTB
                                A1_INSCR = <Preenchido> e A1_CONTRIB = 1
                            A1_TIPO = F
                        
                    NCB - CONSUMIDOR FINAL NÃO CONTRIBUIENTE
                        A1_GRPTRIB = NCB
                        A1_INSCR = <Não Preenchido>
                        A1_TIPO = F
                        
                    CTBC = CONTRIBUINTE CONSUMIDOR FINAL
                                A1_GRPTRIB = CTB
                                A1_INSCR = <Preenchido> e A1_CONTRIB = 1
                            A1_TIPO = F

                    CTBR - CONTRIBUINTE REVENDEDOR
                                A1_GRPTRIB = CTB
                                A1_INSCR = <Preenchido> e A1_CONTRIB = 1
                            A1_TIPO = R ou S

                    CTBZF
                            A1_GRPTRIB = CTB
                            A1_SUFRAMA = <Preenchido>  ou A1_CALCSUF <> 'N'
                            A1_MUN = ????

                    NCBZF
                        A1_GRPTRIB = CTB
                        A1_SUFRAMA = <Preenchido> ou A1_CALCSUF <> 'N'
                        A1_MUN = ????
                    */

                    aPerfil := {}
                    If SA1->A1_GRPTRIB = "CTB" //!EMPTY(SA1->A1_INSCR) .And. SA1->A1_CONTRIB = '1' 
                        If !EMPTY(SA1->A1_SUFRAMA) //.And. SA1->A1_CALCSUF <> 'N'
                            AADD(aPerfil, 'CTBZF')
                        Else
                            If SA1->A1_TIPO $ 'R/S'
                                AADD(aPerfil, 'CTBR')
                            Else
                                AADD(aPerfil, 'CTB')
                                AADD(aPerfil, 'CTBC')
                            EndIf
                        EndIf
                    Elseif SA1->A1_GRPTRIB = "NCB"
                        If !EMPTY(SA1->A1_SUFRAMA) //.And. SA1->A1_CALCSUF <> 'N'
                            AADD(aPerfil, 'NCBZF')
                        Else
                            AADD(aPerfil, 'NCB')
                        EndIf
                    EndIf
                    AADD(aPerfil, 'TODOS')

                    For nF := 1 To Len(aPerfil)
                        IncPerfil( SA1->A1_COD, SA1->A1_LOJA, aPerfil[nF] )
                    Next 

            EndIf

        EndIf
    EndIf
Return xRet

/*/{Protheus.doc} User Function IncPerfil
    (Função que inicializa o processamento.)
    @type  Function
    @author Montes
    @since 27/11/2025
    @version 12.1.2410
    @return Nil, Nil, sem retorno
/*/
Static Function IncPerfil(cCodCli,cLojaCli,cCodPerfil)
    local lMVFACAUTO := .F.
    local nOp := 4 // Alteração
    local cTipoPart := "2" // Cliente
    local cTipoPerf := "02" // PERFIL DE PARTICIPANTE
    local lOk := .F.
    
    lMVFACAUTO := GetNewPar("MV_FACAUTO", lMVFACAUTO)

    cCodPerfil := PADR(cCodPerfil,TamSx3("F24_CODIGO")[1])

    ConOut(Repl("-",80))
    ConOut(PadC("Mensagem : Inicío do processamento " + Time(), 80))
 
    // Inclusão de novo produto em um perfil de cliente já existente
    If .T. //lMVFACAUTO // se o facilitador estiver ativado

        dbSelectArea("F22")
        F22->(dbSetOrder(1))

        dbSelectArea("F20")
        F20->(dbSetOrder(1))

        // posiciono no perfil ao qual quero incluir o novo cliente/loja
        if F20->(MsSeek(xFilial("F20") + cCodPerfil + cTipoPerf))


            if !F22->(MsSeek(xFilial("F22") + cCodPerfil + cTipoPerf + cTipoPart + cCodCli + cLojaCli))

                // chamo a função para gravar novo clliente/loja (F22)
                lOk := GravaF22(nOp, cCodPerfil, cTipoPerf, cTipoPart, cCodCli, cLojaCli)
                If !lOk
                        ConOut("Mensagem : Não foi possível a inserção de novo participante no perfil. Verificar Log.")
                Else
                        ConOut("Mensagem : Incluído cliente " + cCodCli+"/"+cLojaCli + " ao perfil " + cCodPerfil+".")
                EndIf

            EndIf
        Else
            ConOut("Mensagem : Perfil de Produto inexistente!")
        EndIf
    EndIf
    ConOut("Mensagem : Fim da Execução em - "+Time())
  
Return
 
 
/*/{Protheus.doc} User Function GravaF22
    (Grava Cliente/Loja em perfil de participante já existente)
    @type  Function
    @author Montes
    @since 25/11/2025
    @version version
    @param nOp, numeric, Opção a ser aplicada
    @param cCodPerfil, character, Código do Perfil a ser vinculado o participante
    @param cTipoPerf, character, Tipo do Perfil de participante: 1-Origem Destino; 2-Participante; 3-Operação. No nosso caso será sempre 2
    @param cTipoPart, character, Tipo do Participante - Fornecedor (1) Cliente (2)
    @param cCodCli, character, Código do cliente/fornecedor
    @param cLojCli, character, Loja do cliente/fornecedor
    @return lOk, logical, flag que identifica se a inserção ocorreu
/*/
Static Function GravaF22(nOp, cCodPerfil, cTipoPerf, cTipoPart, cCodCli, cLojCli)
    local oModel as object
    local lOk := .F.
 
    oModel := FwLoadModel("FISA164") // carrego o modelo da rotina
 
    If nOp == MODEL_OPERATION_UPDATE // verifico se é alteração
 
        // Através da operação de update no modelo, consigo adicionar uma nova
        // linha na GRID (F24).
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
        oModel:Activate() // ativo o modelo
 
        //Adiciona uma nova linha no grid de participantes
        oModel:GetModel("FISA164PARTICIPANTE"):AddLine()
        oModel:SetValue("FISA164PARTICIPANTE", "F22_CODIGO", cCodPerfil)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_TPPART", cTipoPart)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_CLIFOR", cCodCli)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_LOJA", cLojCli)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_TIPOPF", cTipoPerf)

        If oModel:VldData()
            oModel:CommitData()
            lOk := .T.
        Else
            VarInfo("",oModel:GetErrorMessage())
        EndIf
 
        oModel:DeActivate()
    Else
        ConOut("Mensagem : Opção de operação diferente da esperada: ")
        ConOut("Mensagem : Operação esperada: 4")
        ConOut("Mensagem : Operação recebida: " + str(nOp))
    EndIf
Return lOk
