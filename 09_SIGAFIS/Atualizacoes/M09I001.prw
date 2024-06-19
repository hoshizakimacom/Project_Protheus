//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
 
//Posições do Array
Static nPosNcm    := 1 //Coluna A no Excel
Static nPosEx     := 2
Static nPosIPI    := 3 //Coluna C no Excel
 
/*/{Protheus.doc} M09I001
Função para alualizar aliquota de IPI no cadastro de produtos
@author Graziella Bianchin
@since 16/08/2022
@version 1.0
@type function
/*/
 
User Function M09I001()
    Local aArea     := GetArea()
    Private cArqOri := ""
 
    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
     
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
         
        //Somente se existir o arquivo e for com a extensão CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
     
    RestArea(aArea)
Return
 
/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
 
Static Function fImporta()
    Local aArea      := GetArea()
    Local cArqLog    := "M09I01_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cCodNcm    := ""
    Local cAliquo    := ""
    Local cEx        := ""
    Local cQuery     := ""
    Local cIpiSB1    := ""
    Local cIpiSYD    := ""
    
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
     
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
 
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
     
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
 
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
 
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
             
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
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
                cCodNcm    := Alltrim(aLinha[nPosNcm])
                cAliquo    := Val(Alltrim(aLinha[nPosIPI]))
                cEx        := Alltrim(aLinha[nPosEx])

                If substring(cCodNcm,1,3) <> 'NCM'
                    //Verifico se tenho registros para alterar
                    cQuery := "SELECT B1_COD, B1_POSIPI, B1_IPI FROM " + RetSqlName("SB1") + " "
                    cQuery += "WHERE B1_POSIPI = '" + cCodNcm + "' "

                    If cEx = "0"
                        cQuery += "AND B1_EX_NCM   = '' "
                    else
                        cQuery += "AND B1_EX_NCM   = '" + strzero(Val(cEx),2) + "' "
                    Endif
                    
                    TcQuery cQuery New Alias "QRYNCM"
                    DbSelectArea("QRYNCM")

                    cIpiSB1 := ("QRYNCM")->B1_IPI

                    //Caso tenha faço os updates das tabelas SB1 
                    iF !QRYNCM->(EOF()) //Enquando não for fim de arquivo
                        
                        cQuery := "UPDATE " + RetSqlName("SB1") + " "
                        cQuery += "SET B1_IPI      =  " + Alltrim(Str(cAliquo)) + " "
                        cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                        cQuery += "AND B1_POSIPI   = '" + cCodNcm + "' "

                        If cEx = "0"
                            cQuery += "AND B1_EX_NCM   = '' "
                        else
                            cQuery += "AND B1_EX_NCM   = '" + strzero(Val(cEx),2) + "' "
                        Endif

                        //Tenta executar o update
                        nErro := TcSqlExec(cQuery)

                        If nErro !=0
                            cLog += "- Lin" + cValToChar(nLinhaAtu) + ", SB1-> NCM/EX ["+ cCodNcm + "/"+iif(cEx = "0","",strzero(Val(cEx),2))+"] NÃO ENCONTRADO. ;" + CRLF
                            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
                            DisarmTransaction()
                        Else     
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", SB1-> NCM/EX ["+ cCodNcm + "/"+iif(cEx = "0","",strzero(Val(cEx),2))+"] aliquota de IPI alterada. Antes: [" +  Alltrim(Str(cIpiSB1)) + "], agora: [" + Alltrim(Str(cAliquo)) + "];" + CRLF
                        Endif
                        
                    else
                         //Caso contrário gravo no log que não encontrei o NCM em questão
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", SB1-> NCM ["+ cCodNcm + "] e EX ["+iif(cEx = "0","",strzero(Val(cEx),2))+"] NÃO ENCONTRADO. ;" + CRLF
                    Endif
                    ("QRYNCM")->(DBCLOSEAREA())
                    
                    //Verifico se tenho registros para alterar
                    cQuery := "SELECT YD_TEC, YD_EX_NCM, YD_PER_IPI FROM " + RetSqlName("SYD") + " "
                    cQuery += "WHERE YD_TEC = '" + cCodNcm + "' "

                    If cEx = "0"
                        cQuery += "AND YD_EX_NCM   = '' "
                    else
                        cQuery += "AND YD_EX_NCM   = '" + strzero(Val(cEx),2) + "' "
                    Endif
                    
                    TcQuery cQuery New Alias "QRYNCM1"
                    DbSelectArea("QRYNCM1")

                    cIpiSYD := ("QRYNCM1")->YD_PER_IPI

                    //Caso tenha faço os updates das tabelas SYD 
                    iF !QRYNCM1->(EOF()) //Enquando não for fim de arquivo

                        cQuery := "UPDATE " + RetSqlName("SYD") + " "
                        cQuery += "SET YD_PER_IPI  =  " + Alltrim(Str(cAliquo)) + " "
                        cQuery += "WHERE YD_FILIAL = '" + xFilial("SYD") + "' "
                        cQuery += "AND YD_TEC      = '" + cCodNcm + "' "

                        If cEx = "0"
                            cQuery += "AND YD_EX_NCM   = '' "
                        else
                            cQuery += "AND YD_EX_NCM   = '" + strzero(Val(cEx),2) + "' "
                        Endif

                        //Tenta executar o update
                        nErro := TcSqlExec(cQuery)

                        If nErro !=0
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", SYD-> NCM/EX ["+ cCodNcm + "/"+iif(cEx = "0","",strzero(Val(cEx),2))+"] NÃO ENCONTRADO. ;" + CRLF
                            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
                            DisarmTransaction()
                        Else
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", SYD-> NCM/EX ["+ cCodNcm + "/"+iif(cEx = "0","",strzero(Val(cEx),2))+"] aliquota de IPI alterada. Antes: [" + Alltrim(Str(cIpiSYD)) + "], agora: [" + Alltrim(Str(cAliquo)) + "];" + CRLF
                        Endif

                    else
                        //Caso contrário gravo no log que não encontrei o NCM em questão
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", SYD-> NCM/EX ["+ cCodNcm + "/"+iif(cEx = "0","",strzero(Val(cEx),2))+"] NÃO ENCONTRADO. ;"+ CRLF
                    Endif
                    ("QRYNCM1")->(DBCLOSEAREA())
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
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
 
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
 
    RestArea(aArea)
Return
