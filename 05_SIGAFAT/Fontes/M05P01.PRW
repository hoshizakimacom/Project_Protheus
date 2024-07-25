#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} M05P01
Ponto de Entrada antes da gravação do Pedido de Venda. 

@type function
@author	Jorge Heitor T. de Oliveira
@since 21/06/2023
@version P12
@database MSSQL

@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784142
@see M05P01.PRW

/*/
User Function M05P01(nOpcao)
    
    Begin Sequence
        If !podeExecutar(nOpcao)
            Break

        EndIf

        FWMsgRun(, {|| processaDados(nOpcao) },,"Processando dados...")

    End Sequence

Return

/*
    Valida se a personalização pode ser executada
*/
Static Function podeExecutar(nOpcao)
    Local lReturn       as logical

    lReturn := .F.

    Begin Sequence

        If ! GetNewPar("AM_M05P01",.T.)
            Break

        EndIf
        
        If nOpcao == 1 //Inclusão de Pedido não monitora
            Break

        EndIf

        If nOpcao == 3 //Exclusão de Pedido não monitora
            Break

        EndIf

        lReturn := .T.

    End Sequence    

Return lReturn

/*
    Processa avaliação dos dados e possível geração de Log
*/
Static Function processaDados(nOpcao)
    Local aSC5CamposLog         as array
    Local aSC6CamposLog         as array
    Local nCampo                as numeric
    Local nItem                 as numeric
    Local aHistorico            as array
    Local lChange               as logical
    Local dData                 as date
    Local cHora                 as character
    Local cIDUsuario            as character

    Local cNomeUser             as character //NICOLAS

    Local cIDHistorico          as character
    Local cStatusModificacao    as character
    Local lExcluiuItem          as logical
    Local nItemPosicao          as numeric
    Local nProdutoPosicao       as numeric
    Local lIncluiuItem          as logical
    Local cNovoProduto          as character

    aSC5CamposLog := Separa(GetNewPar("AM_LOGPVCP","C5_FECENT,C5_XTPVEN"),",") //{}
    aSC6CamposLog := Separa(GetNewPar("AM_LOGPVCI","C6_ENTREG,C6_PRODUTO,C6_QTDVEN,C6_OPER"),",") //{}
    nCampo := 0
    aHistorico := {}
    lChange := .F.
    dData := Date()
    cHora := Time()
    cIDUsuario := RetCodUsr()

    
    cNomeUser := UsrFullName(cIDUsuario) //NICOLAS

    cIDHistorico := ""
    cStatusModificacao := ""
    lExcluiuItem := .F.
    lIncluiuItem := .F.
    nItemPosicao := aScan(aHeader,{|x,y|x[2] = 'C6_ITEM'})
    nProdutoPosicao := aScan(aHeader,{|x,y|x[2] = 'C6_PRODUTO'})

    /*
    ---------------------------
    Formato do array aHistorico
    ---------------------------

    aHistorico[x][1] -> Alias
    aHistorico[x][2] -> Filial
    aHistorico[x][3] -> Pedido
    aHistorico[x][4] -> Item (caso exista)
    aHistorico[x][5] -> Campo
    aHistorico[x][6] -> Novo Valor
    aHistorico[x][7] -> Valor Historico (Antigo)
    aHistorico[x][8] -> Data
    aHistorico[x][9] -> Hora
    aHistorico[x][10] -> ID de Usuário
    aHistorico[x][11] -> Status Modificação
    aHistorico[x][12] -> Código do Produto
    */

    //Verificação de campos do cabeçalho
    If Len(aSC5CamposLog) > 0
        For nCampo := 1 To Len(aSC5CamposLog)
            //Faz comparações para avaliar modificações
            cCampo := aSC5CamposLog[nCampo]
            cAliasCampo := "SC5"
            cFilialRegistro := M->C5_FILIAL
            cPedido := M->C5_NUM
            cItemPedido := ""
            cNovoValor := cValToChar(M->&(cCampo))
            cAntigoValor := cValToChar(IIf(INCLUI,"",SC5->&(cCampo)))
            If nOpcao == 1
                cStatusModificacao := "INC"

            Else
                cStatusModificacao := "ALT"

            EndIf

            If AllTrim(cNovoValor) <> AllTrim(cAntigoValor) //Houve modificação
                aAdd(aHistorico,{;
                                    cAliasCampo,;
                                    cFilialRegistro,;
                                    cPedido,;
                                    cItemPedido,;
                                    cCampo,;
                                    cNovoValor,;
                                    cAntigoValor,;
                                    dData,;
                                    cHora,; //cIDUsuario,;
                                    cNomeUser,;
                                    cStatusModificacao;
                                })


            EndIf

        Next nCampo

    EndIf

    //Verificação de campos dos itens
    If Len(aSC6CamposLog) > 0
        For nItem := 1 To Len(aCols)
            cNovoProduto := ""
            lExcluiuItem := .F.
            lIncluiuItem := .F.

            If nOpcao == 1
                cStatusModificacao := "INC" //Inclusão do Pedido

            Else
                If aCols[nItem][Len(aHeader)+1] //Valida pela exclusão da linha do grid
                        cStatusModificacao := "EXC" //Item excluído do Pedido de Venda
                        lExcluiuItem := .T.

                Else
                    If ! Empty(Posicione("SC6",1,FWxFilial("SC6") + M->C5_NUM + aCols[nItem][nItemPosicao],"C6_PRODUTO"))
                        cStatusModificacao := "ALT"
                    
                    Else
                        cStatusModificacao := "INC"
                        cNovoProduto := aCols[nItem][nProdutoPosicao]
                        lIncluiuItem := .T.

                    EndIf

                EndIf

            EndIf

            For nCampo := 1 To Len(aSC6CamposLog)
                //Faz comparações para avaliar modificações
                cCampo := aSC6CamposLog[nCampo]
                cAliasCampo := "SC6"
                cFilialRegistro := M->C5_FILIAL
                cPedido := M->C5_NUM
                cItemPedido := GDFieldGet("C6_ITEM",nItem,/*lReadvar*/,/*aHeaderpastpar*/,/*aColspastpar*/)
                cNovoValor := cValToChar(GDFieldGet(cCampo,nItem,/*lReadvar*/,/*aHeaderpastpar*/,/*aColspastpar*/))
                cAntigoValor := cValToChar(IIf(INCLUI,"",cValToChar(Posicione("SC6",1, cFilialRegistro + cPedido + cItemPedido,cCampo))))

                If AllTrim(cNovoValor) <> AllTrim(cAntigoValor) .Or. lExcluiuItem .Or. lIncluiuItem//Houve modificação, ou a linha foi excluída
                    aAdd(aHistorico,{;
                                        cAliasCampo,;
                                        cFilialRegistro,;
                                        cPedido,;
                                        cItemPedido,;
                                        Iif(lExcluiuItem .Or. lIncluiuItem,"",cCampo),;
                                        Iif(lExcluiuItem .Or. lIncluiuItem,"",cNovoValor),;
                                        Iif(lExcluiuItem .Or. lIncluiuItem,"",cAntigoValor),;
                                        dData,;
                                        cHora,;//cIDUsuario,;  
                                        cNomeUser,;
                                        cStatusModificacao,;                          
                                        cNovoProduto;
                                    })

                    //Grava apenas uma vez o log (nao percorre todos os campos) quando for inclusão ou exclusão de itens
                    If lExcluiuItem .Or. lIncluiuItem
                        Exit
                    
                    EndIf

                EndIf

            Next nCampo

        Next nItem

    EndIf

    If Len(aHistorico) > 0
        If (cIDHistorico := gravaHistorico(aHistorico)) <> ""
            emailHistorico(cIDHistorico,aHistorico)

        EndIf

    EndIf

Return 

/*
    Efetua gravação do Histórico na tabela SZ0
*/
Static Function gravaHistorico(aHistorico)
    Local nItemHistorico        as numeric
    Local cIDHistorico          as character

    nItemHistorico := 0
    cIDHistorico := FWUUIDV4() //ID Unico

    For nItemHistorico := 1 To Len(aHistorico)
        RecLock("SZ0",.T.)
            Z0_FILIAL := aHistorico[nItemHistorico][2]
            Z0_ID := cIDHistorico
            Z0_PEDIDO := aHistorico[nItemHistorico][3]
            Z0_ITEM := aHistorico[nItemHistorico][4]
            Z0_CAMPO := aHistorico[nItemHistorico][5]
            Z0_VALNOVO := aHistorico[nItemHistorico][6]
            Z0_VALHIST := aHistorico[nItemHistorico][7]
            Z0_DATA := aHistorico[nItemHistorico][8]
            Z0_HORA := aHistorico[nItemHistorico][9]
            Z0_USER := aHistorico[nItemHistorico][10]
            Z0_ALIAS := aHistorico[nItemHistorico][1]
            Z0_STATUS := aHistorico[nItemHistorico][11]
        SZ0->(MsUnlock())

    Next nItemHistorico

Return cIDHistorico

/*
    Envia e-mail com Log de Modificações do Pedido
*/
Static Function emailHistorico(cIDHistorico,aConsultaHistorico)
    Local aHistorico            as array
    Local aDadosCabecalho       as array
    Local aDadosItens           as array
    Local cBody                 as character
    Local cDestinatarios        as character
    Local cFilialPedido         as character
    Local cPedido               as character
    Local cNomeCliente          as character
    Local cAssunto              as character
    Local cArquivoHTML          as character
    Local oProcess              as object
    Local oHTML                 as object
    Local nItem                 as numeric
    Local nRegistro             as numeric
    Local cHTMLItens            as character
    Local oSendMail             as object
    Local cUsuarioModificacao   as character
    Local cDataModificacao      as character
    Local cHoraModificacao      as character
    Local cItemDescricao        as character

       
    aHistorico := carregaHistorico(cIDHistorico,@cFilialPedido,@cPedido,@cNomeCliente,@cUsuarioModificacao,@cDataModificacao,@cHoraModificacao)
    aDadosCabecalho := {}
    aDadosItens := {}
    cBody := ""
    cDestinatarios := "wmanzini@hoshizakimacom.com.br; kmarin@hoshizakimacom.com.br; bribeiro@hoshizakimacom.com.br; lcordeiro@hoshizakimacom.com.br; jcarlos@hoshizakimacom.com.br; tmorais@hoshizakimacom.com.br" //#6825
    //cDestinatarios := GetNewPar("AM_LOGPVEM") //E-mails que receberão o Log. 
    cAssunto := "MACOM - Sales Order Modification"
    cArquivoHTML := GetNewPar("AM_LOGPVHT","\html\m05p01.html")
    cItemDescricao := ""
    
    /*
        Separa informações do LOG por Alias
    */
    For nItem := 1 To Len(aHistorico)
        If aHistorico[nItem][1] == "SC5"
            aAdd(aDadosCabecalho,aHistorico[nItem])

        ElseIf aHistorico[nItem][1] == "SC6"
            If (nPosItem := aScan(aDadosItens, {|aItens| aItens[1] == aHistorico[nItem][4]})) > 0
                aAdd(aDadosItens[nPosItem][2],aHistorico[nItem])

            Else
                aAdd(aDadosItens,{aHistorico[nItem][4],{}})
                nPosItem := aScan(aDadosItens, {|aItens| aItens[1] == aHistorico[nItem][4]})
                aAdd(aDadosItens[nPosItem][2],aHistorico[nItem])

            EndIf

        EndIf

    Next nItem

    /*
        Carrega o HTML em memória para edição
    */
    oProcess := TWFProcess():New("ALTPV",cAssunto)
    oProcess:NewTask("Log PV por Email",cArquivoHTML)
    oHTML := oProcess:oHTML

    oHTML:ValByName("CPEDIDO" , cPedido)
    oHTML:ValByName("CCLIENTE" , cNomeCliente)
    oHTML:ValByName("CUSER" , cUsuarioModificacao)
    oHTML:ValByName("CDATA" , cDataModificacao)
    oHTML:ValByName("CHORA" , cHoraModificacao)
    oHTML:ValByName("FRASE1" , "You can see more details bellow:")

    /*
        Atribui dados do cabeçalho ao modelo html
    */
    If Len(aDadosCabecalho) > 0
        For nItem := 1 to Len(aDadosCabecalho)
            aAdd((oHTML:ValByName("cab.Z0_CAMPO")), GetSX3Cache(aDadosCabecalho[nItem][5],"X3_TITULO"))
            aAdd((oHTML:ValByName("cab.Z0_VALHIST")), aDadosCabecalho[nItem][7])
            aAdd((oHTML:ValByName("cab.Z0_VALNOVO")), aDadosCabecalho[nItem][6])
            aAdd((oHTML:ValByName("cab.Z0_STATUS")), Iif(aDadosCabecalho[nItem][11] == "ALT","Data Modified",""))

        Next nItem

    Else
        //Caso não existam campos do cabeçalho modificados gera em branco.
        aAdd((oHTML:ValByName("cab.Z0_CAMPO")), "")
        aAdd((oHTML:ValByName("cab.Z0_VALHIST")), "")
        aAdd((oHTML:ValByName("cab.Z0_VALNOVO")), "")
        aAdd((oHTML:ValByName("cab.Z0_STATUS")), "")

    EndIf

    /*
        Atribui dados dos itens ao modelo HTML
    */
    cHTMLItens := ""

    If Len(aDadosItens) > 0
        For nItem := 1 to Len(aDadosItens)
            cItem := PadR(aDadosItens[nItem][1],TamSX3("C6_ITEM")[1])
            cItemDescricao := cItem  + " - " + pegaProduto(cFilialPedido,cPedido,cItem,aConsultaHistorico)

            cHTMLItens += "<tr>"
            cHTMLItens += '    <td colspan="11" style="background-color:#A9A9A9;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff; font-size: 15px;font-weight:bold;padding:2px;padding-left:5px" align="center">Item: ' + cItemDescricao + '</td>'
            cHTMLItens += "</tr>"
            
            cHTMLItens += '<tr>'
            cHTMLItens += '    <td style="background-color:#123970;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff; font-size: 15px;font-weight:bold;padding:2px;padding-left:5px" align="center">Field</td>'
            cHTMLItens += '    <td style="background-color:#123970;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff; font-size: 15px;font-weight:bold;padding:2px;padding-left:5px" align="center">Previous Data</td>'
            cHTMLItens += '    <td style="background-color:#123970;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff; font-size: 15px;font-weight:bold;padding:2px;padding-left:5px" align="center">New Data</td>'
            cHTMLItens += '    <td style="background-color:#123970;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px" align="center">Status</td>'
            cHTMLItens += '</tr>'

            For nRegistro := 1 to Len(aDadosItens[nItem][2])
                    cOperacao := aDadosItens[nItem][2][nRegistro][11]
                    cHTMLItens += '<tr>'
                    cHTMLItens += '    <td style="background-color:#F9F8F6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" align="center">' + IIf(! cOperacao $ "INC/EXC", GetSX3Cache(aDadosItens[nItem][2][nRegistro][5],"X3_TITULO"),"") + '</td>'
                    cHTMLItens += '    <td style="background-color:#F9F8F6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" align="center">' + AllTrim(aDadosItens[nItem][2][nRegistro][7]) + '</td>'
                    cHTMLItens += '    <td style="background-color:#F9F8F6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" align="center">' + AllTrim(aDadosItens[nItem][2][nRegistro][6]) + '</td>'
                    cHTMLItens += '    <td style="background-color:#' + Iif(cOperacao == "ALT","F0E68C",IIf(cOperacao == "EXC","FF6347","00FA9A")) + ';font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" align="center">' + Iif(cOperacao == "ALT","Data Modified",IIf(cOperacao == "EXC","Item Deleted","New Item")) + '</td>'
                    cHTMLItens += '</tr>'

            Next nRegistro

        Next nItem

    Else
        cHTMLItens := ""

    EndIf

    oHTML:ValByName("TABITENS",cHTMLItens)

    cBody := oHTML:HtmlCode()

    oSendMail := uSendMail():New()
    oSendMail:Load()
    oSendMail:cSubJect := cAssunto
    oSendMail:cTo := cDestinatarios
    oSendMail:cBody := cBody
    
    If ! oSendMail:Send()
        MsgStop("Falha no envio do e-mail de Log.","M05P01")

    EndIf

Return

/*
    Retorna Produto do Item do Pedido de Venda
*/
Static Function pegaProduto(cFilialPedido,cPedido,cItem,aConsultaHistorico)
    Local cProduto          as character
    Local cDescricao        as character
    Local nPosicaoItem      as numeric
    Local cRetorno          as character

    nPosicaoItem := aScan(aConsultaHistorico,{|x| x[4] == cItem })

    If aConsultaHistorico[nPosicaoItem][11] == "INC"
        cProduto := aConsultaHistorico[nPosicaoItem][12]

    Else
        cProduto := AllTrim(Posicione("SC6",1,cFilialPedido + cPedido + cItem, "C6_PRODUTO"))

    EndIf

    cDescricao := AllTrim(Posicione("SB1",1,FWxFilial("SB1") + cProduto, "B1_DESC"))
    cRetorno := AllTrim(cProduto) + " - " + cDescricao

Return cRetorno

/*
    Carrega dados do histórico para o array 
*/
Static Function carregaHistorico(cIDHistorico,cFilialPedido,cPedido,cNomeCliente,cUsuarioModificacao,cDataModificacao,cHoraModificacao)
    Local aArea             as array
    Local cAliasHistorico   as character
    Local aRetorno          as array

    aArea := GetArea()
    cAliasHistorico := GetNextAlias()
    aRetorno := {}

    BeginSQL Alias cAliasHistorico
        SELECT
            Z0_ALIAS
            ,Z0_FILIAL
            ,Z0_PEDIDO
            ,Z0_ITEM
            ,Z0_CAMPO
            ,Z0_VALNOVO
            ,Z0_VALHIST
            ,Z0_DATA
            ,Z0_HORA
            ,Z0_USER
            ,Z0_STATUS         
        FROM
            %Table:SZ0% SZ0
        WHERE
            SZ0.%NotDel%
            AND Z0_ID = %Exp:cIDHistorico%
        ORDER BY Z0_ID,Z0_ALIAS,Z0_PEDIDO,Z0_ITEM

    EndSQL

    dbSelectArea(cAliasHistorico)
    While ! (cAliasHistorico)->(Eof())
        aAdd(aRetorno,{;
                            (cAliasHistorico)->Z0_ALIAS,;
                            (cAliasHistorico)->Z0_FILIAL,;
                            (cAliasHistorico)->Z0_PEDIDO,;
                            (cAliasHistorico)->Z0_ITEM,;
                            (cAliasHistorico)->Z0_CAMPO,;
                            (cAliasHistorico)->Z0_VALNOVO,;
                            (cAliasHistorico)->Z0_VALHIST,;
                            StoD((cAliasHistorico)->Z0_DATA),;
                            (cAliasHistorico)->Z0_HORA,;
                            UsrFullName((cAliasHistorico)->Z0_USER),;
                            (cAliasHistorico)->Z0_STATUS;                          
                        })

        (cAliasHistorico)->(dbSkip())

    End

    If Len(aRetorno) > 0
        cFilialPedido := aRetorno[1][2]
        cPedido := aRetorno[1][3]
        cNomeCliente := pegaNomeCliente(cFilialPedido,cPedido)
        cUsuarioModificacao := ALLTRIM(USRFULLNAME(__CUSERID)) //#6825
        cDataModificacao := DtoC(aRetorno[1][8])
        cHoraModificacao := aRetorno[1][9]

    EndIf

    RestArea(aArea)

Return aRetorno

/*
    Retorna Nome do Cliente
*/
Static Function pegaNomeCliente(cFilialPedido,cPedido)
    Local aArea                 as array
    Local cAliasCliente         as character
    Local cNomeCliente          as character

    aArea := GetArea()
    cAliasCliente := GetNextAlias()
    cNomeCliente := ""

    BeginSQL Alias cAliasCliente
        SELECT 
            A1_NOME
        FROM
            %Table:SC5% SC5
            INNER JOIN %Table:SA1% SA1 ON
                                        1=1
                                        AND SA1.%NotDel%
                                        AND SA1.A1_FILIAL = %xFilial:SA1%
                                        AND SA1.A1_COD = C5_CLIENTE
                                        AND SA1.A1_LOJA = C5_LOJACLI
        WHERE
            SC5.%NotDel%
            AND SC5.C5_FILIAL = %Exp:cFilialPedido%
            AND SC5.C5_NUM = %Exp:cPedido%

    EndSQL

    dbSelectArea(cAliasCliente)
    If !Eof()
        cNomeCliente := AllTrim((cAliasCliente)->A1_NOME)

    EndIf

    (cAliasCliente)->(dbCloseArea())                               

    RestArea(aArea)

Return cNomeCliente
