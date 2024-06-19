//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
 
//Posi��es do Array
Static nPosCod    := 1 //Coluna A no Excel
Static nPosIPIA   := 2 //Coluna B no Excel
Static nPosIPIN   := 3 //Coluna C no Excel
 
/*/{Protheus.doc} M09I002
Fun��o para alualizar o numero do NCM no cadastro de produtos
@author Graziella Bianchin
@since 27/09/2022
@version 1.0
@type function
/*/
 
User Function M09I002()
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
    Local cArqLog    := "M09I02_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas

    Local cCodPro    := ""
    Local cCodIPIA   := ""
    Local cCodIPIN   := ""

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
 
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
                //Begin Transaction
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                 
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
 
                //Zera as variaveis
                cCodPro    := Alltrim(aLinha[nPosCod])

                If Alltrim(aLinha[nPosIPIA]) = '0'
                    cCodIPIA   := "00000000"
                Else
                    cCodIPIA   := Alltrim(aLinha[nPosIPIA])
                Endif


                If Alltrim(aLinha[nPosIPIN]) = '0'
                    cCodIPIN   := "00000000"
                Else
                    cCodIPIN   := Alltrim(aLinha[nPosIPIN])
                Endif

                If substring(cCodPro,1,3) <> 'B1_'
                    //Verifico se tenho registros para alterar
                    cQuery := "SELECT B1_COD, B1_POSIPI FROM " + RetSqlName("SB1") + " "
                    cQuery += "WHERE B1_POSIPI = '" + cCodIPIA + "' AND B1_COD = '"+ cCodPro + "' AND D_E_L_E_T_ = '' "
                    
                    TcQuery cQuery New Alias "QRYNCM"
                    DbSelectArea("QRYNCM")

                    //Caso tenha fa�o os updates das tabelas SB1 
                    iF !QRYNCM->(EOF()) .And. (cCodIPIA<>cCodIPIN)//Enquando n�o for fim de arquivo
                        
                        cQuery := "UPDATE " + RetSqlName("SB1") + " "
                        cQuery += "SET B1_POSIPI   = '" + cCodIPIN + "' "
                        cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                        cQuery += "AND B1_POSIPI   = '" + cCodIPIA + "' "
                        cQuery += "AND B1_COD      = '" + cCodPro  + "' " 

                        //Tenta executar o update
                        nErro := TcSqlExec(cQuery)

                        If nErro !=0
                            cLog += "- Lin" + cValToChar(nLinhaAtu) + ", SB1->NCM ["+ cCodIPIA + "] N�O ENCONTRADO. ;" + CRLF
                            MsgStop("Erro na execu��o da query: "+TcSqlError(), "Aten��o")
                            DisarmTransaction()
                        Else     
                            cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", SB1->NCM alterado. Antes: [" +  Alltrim(cCodIPIA) + "], agora: [" + Alltrim(cCodIPIN) + "];" + CRLF
                        Endif
                        
                    else
                         //Caso contr�rio gravo no log que n�o encontrei o NCM em quest�o
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", SB1-> NCM ["+ cCodIPIA + "] N�O ENCONTRADO. ;" + CRLF
                    Endif

                    ("QRYNCM")->(DBCLOSEAREA())

                Endif
                //End Transaction
            EndDo

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
