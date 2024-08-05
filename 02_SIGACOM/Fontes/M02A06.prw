#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------
//| Função que inclui anexo no orçamento de vendas
//  Chamado do ponto de entrada MA415MNU
//+--------------------------------------------------------------------------------------------------
User Function M02A06_A()

    Local _cMascara     := 'Todos os arquivos|*.*'
    Local _cTitulo      := 'Escolha o arquivo'
    Local _nMascpad     := 0
    Local _cDirOri      := 'C:\'
    Local _cDirDes      := AllTrim(GetMv('AM_02A06_A',.T.,''))
    Local _lSalvar      := .F. /*.F. = Salva || .T. = Abre*/
    Local _nOpcoes      := GETF_LOCALHARD
    Local _lArvore      := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
    
    Local _lOk          := .F.
    Private _aArquivo := {}

    If Empty(_cDirDes)
        Aviso('Atenção','É obrigatório informar o diretório de armazenamento no parâmetro AM_05A25_A.',{'OK'},3)
    Else
        _cDirDes    += AllTrim(SC7->(C7_FILIAL + C7_NUM)) + '\'
        _cDirOri    := cGetFile( _cMascara, _cTitulo, _nMascpad, _cDirOri, _lSalvar, _nOpcoes, _lArvore)

        If !Empty(_cDirOri)
            _aFiles := Directory(_cDirOri, "D")

            MakeDir(_cDirDes)

            If !(_lOk := !File(_cDirDes + _aFiles[1][1]))
                If MsgYesNo('Arquivo já anexado ao Orçamento.' + CRLF + 'Deseja atualizar o arquivo?',"Atenção")
                    If !(_lOk := FErase(_cDirDes + _aFiles[1][1]) <> -1)
                        MsgAlert('Erro ao apagar arquivo: ' + STR(FERROR()),"Atenção")
                    EndIf
                EndIf
            EndIf

            If _lOk
                __CopyFile(_cDirOri,_cDirDes + _aFiles[1][1])

                If File(_cDirDes + _aFiles[1][1])
                    RecLock('SC7',.F.)
                    SC7->C7_XANEXPC := I18N('Arquivo: #1    | Data: #2    | Usuário: #3 ',{Upper(_aFiles[1][1]),DToC(Date()) + ' ' + Time(),Upper(UsrRetName(RetCodUsr()))})
                    SC7->(MsUnLock())

                    MsgInfo('Arquivo anexado com sucesso!',"Atenção")
                Else
                    Alert('Erro ao anexar arquivo.',"Atenção")
                EndIf
            EndIf


        Else
            Alert('Arquivo não informado!')
        EndIf
    EndIf
Return

//+-------------------------------------------------------------------------------
//  Fonte responsável pela visualização do anexo no orçamento
//  Chamado do ponto de entrada MA415MNU
//+-------------------------------------------------------------------------------
User Function M02A06_c()
    Local _cDir     := AllTrim(GetMv('AM_02A06_A',.T.,''))

    If Empty(_cDir)
        Aviso('Atenção','É obrigatório informar o diretório de armazenamento no parâmetro AM_02A06_A.',{'OK'},3)
    Else
        _cDir   += AllTrim(SC7->(C7_FILIAL + C7_NUM)) + '\'

        MakeDir(_cDir)
        WinExec('explorer.exe ' + _cDir)
    EndIf
Return
