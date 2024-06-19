//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
 
//Posi��es do Array
Static nPosProdut := 1 //Coluna A no Excel
Static nPosCompon := 2 //Coluna B no Excel
Static nPosPerda  := 3 //Coluna C no Excel
 
/*/{Protheus.doc} M10I01
Fun��o para atualizar perdas de componentes
@author Graziella Bianchin
@since 16/08/2022
@version 1.0
@type function
/*/
 
User Function M10I01()
    Local aArea     := GetArea()
    Private cArqOri := ""
 
    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Sele��o de Arquivos', , , .F., )
     
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
         
        //Somente se existir o arquivo e for com a extens�o CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extens�o inv�lida!", "Aten��o")
        EndIf
    EndIf
     
    RestArea(aArea)
Return
 
/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Fun��o que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
 
Static Function fImporta()
    Local aArea      := GetArea()
    Local cArqLog    := "M10I01_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cProduto   := ""
    Local cCompone   := ""
    Local nPerda     := ""
    Local cQuery     := ""
    
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
     
    //Se a pasta de log n�o existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
 
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
     
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
 
        //Se n�o for fim do arquivo
        If ! (oArquivo:EoF())
 
            //Definindo o tamanho da r�gua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
             
            //M�todo GoTop n�o funciona (dependendo da vers�o da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
 
            //Begin Transaction
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
                Begin Transaction
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                 
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                 
 
                //Zera as variaveis
                cProduto    := Alltrim(aLinha[nPosProdut])
                cCompone    := Alltrim(aLinha[nPosCompon])
                nPerda      := Val(Alltrim(aLinha[nPosPerda]))
 
                If substring(cProduto,1,4) <> 'Prod'
                    //Verifico se tenho registros para alterar
                    cQuery := "SELECT GG_COD, GG_COMP FROM " + RetSqlName("SGG") + " "
                    cQuery += "WHERE GG_FILIAL = '" + xFilial("SGG") + "' "
                    cQuery += "AND GG_COD      = '" + cProduto + "' "
                    cQuery += "AND GG_COMP     = '" + cCompone + "' "
                    cQuery += "AND D_E_L_E_T_  = '' "
                    
                    TcQuery cQuery New Alias "QRYSGG"
                    DbSelectArea("QRYSGG")

                    //Caso tenha fa�o os updates das tabelas SB1 E SYD
                    iF !QRYSGG->(EOF()) //Enquando n�o for fim de arquivo

                        cQuery := "UPDATE " + RetSqlName("SGG") + " "
                        cQuery += "SET GG_PERDA    =  " + Str(nPerda) + " "
                        cQuery += "WHERE GG_FILIAL = '" + xFilial("SGG") + "' "
                        cQuery += "AND GG_COD      = '" + cProduto + "' "
                        cQuery += "AND GG_COMP     = '" + cCompone + "' "
                        cQuery += "AND D_E_L_E_T_  = '' "

                        //Tenta executar o update
                        nErro := TcSqlExec(cQuery)

                        If nErro !=0
                            cLog += "- Lin" + cValToChar(nLinhaAtu) + ", PRE-ESTRUTURA -> Produto e componente [" + cProduto + " - " + cCompone + "] n�o encontrados no Protheus;" + CRLF
                            MsgStop("Erro na execu��o da query: "+TcSqlError(), "Aten��o")
                            DisarmTransaction()
                        Else
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", PRE-ESTRUTURA -> Produto - Componente  [" + cProduto + " - " + cCompone  + "] " + ;
                                    "a perda foi alterada, antes: [" + strzero(SGG->GG_PERDA,5) + "], agora: [" + Strzero(nPerda,5) + "];" + CRLF
                        Endif

                    else
                        //Caso contr�rio gravo no log que n�o encontrei o NCM em quest�o
                        cLog += "- Lin " + cValToChar(nLinhaAtu) + ", PRE-ESTRUTURA -> Produto e componente [" + cProduto + " - " + cCompone + "] n�o encontrados no Protheus;" + CRLF
                    Endif
                    ("QRYSGG")->(DBCLOSEAREA())

                    //Verifico se tenho registros para alterar
                    cQuery := "SELECT G1_COD, G1_COMP FROM " + RetSqlName("SG1") + " "
                    cQuery += "WHERE G1_FILIAL = '" + xFilial("SG1") + "' "
                    cQuery += "AND G1_COD      = '" + cProduto + "' "
                    cQuery += "AND G1_COMP     = '" + cCompone + "' "
                    cQuery += "AND D_E_L_E_T_  = '' "
                    
                    TcQuery cQuery New Alias "QRYSG1"
                    DbSelectArea("QRYSG1")

                    //Caso tenha fa�o os updates das tabelas SB1 E SYD
                    iF !QRYSG1->(EOF()) //Enquando n�o for fim de arquivo

                        cQuery := "UPDATE " + RetSqlName("SG1") + " "
                        cQuery += "SET G1_PERDA    =  " + Str(nPerda) + " "
                        cQuery += "WHERE G1_FILIAL = '" + xFilial("SG1") + "' "
                        cQuery += "AND G1_COD      = '" + cProduto + "' "
                        cQuery += "AND G1_COMP     = '" + cCompone + "' "
                        cQuery += "AND D_E_L_E_T_  = '' "

                        //Tenta executar o update
                        nErro := TcSqlExec(cQuery)

                        If nErro !=0
                            cLog += "- Lin" + cValToChar(nLinhaAtu) + ", ESTRUTURA -> Produto e componente [" + cProduto + " - " + cCompone + "] n�o encontrados no Protheus;" + CRLF
                            MsgStop("Erro na execu��o da query: "+TcSqlError(), "Aten��o")
                            DisarmTransaction()
                        Else
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", ESTRUTURA -> Produto - Componente  [" + cProduto + " - " + cCompone  + "] " + ;
                                    "a perda foi alterada, antes: [" + strzero(SGG->GG_PERDA,5) + "], agora: [" + Strzero(nPerda,5) + "];" + CRLF
                        Endif
                    else
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", ESTRUTURA -> Produto e componente [" + cProduto + " - " + cCompone + "] n�o encontrados no Protheus;" + CRLF
                    endif
                    ("QRYSG1")->(DBCLOSEAREA())
                    
                Endif
                End Transaction    
            EndDo
            //End Transaction
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
 
        Else
            MsgStop("Arquivo n�o tem conte�do!", "Aten��o")
        EndIf
 
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo n�o pode ser aberto!", "Aten��o")
    EndIf
 
    RestArea(aArea)
Return
