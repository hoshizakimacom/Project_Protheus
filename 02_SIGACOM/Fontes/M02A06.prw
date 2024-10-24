#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------
//| Fun��o que inclui anexo no or�amento de vendas
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
    Local _lArvore      := .F. /*.T. = apresenta o �rvore do servidor || .F. = n�o apresenta*/
    
    Local _lOk          := .F.
    Private _aArquivo := {}

    If Empty(_cDirDes)
        Aviso('Aten��o','� obrigat�rio informar o diret�rio de armazenamento no par�metro AM_05A25_A.',{'OK'},3)
    Else
        _cDirDes    += AllTrim(SC7->(C7_FILIAL + C7_NUM)) + '\'
        _cDirOri    := cGetFile( _cMascara, _cTitulo, _nMascpad, _cDirOri, _lSalvar, _nOpcoes, _lArvore)

        If !Empty(_cDirOri)
            _aFiles := Directory(_cDirOri, "D")

            MakeDir(_cDirDes)

            If !(_lOk := !File(_cDirDes + _aFiles[1][1]))
                If MsgYesNo('Arquivo j� anexado ao Or�amento.' + CRLF + 'Deseja atualizar o arquivo?',"Aten��o")
                    If !(_lOk := FErase(_cDirDes + _aFiles[1][1]) <> -1)
                        MsgAlert('Erro ao apagar arquivo: ' + STR(FERROR()),"Aten��o")
                    EndIf
                EndIf
            EndIf

            If _lOk
                __CopyFile(_cDirOri,_cDirDes + _aFiles[1][1])

                If File(_cDirDes + _aFiles[1][1])
                    RecLock('SC7',.F.)
                    SC7->C7_XANEXPC := I18N('Arquivo: #1    | Data: #2    | Usu�rio: #3 ',{Upper(_aFiles[1][1]),DToC(Date()) + ' ' + Time(),Upper(UsrRetName(RetCodUsr()))})
                    SC7->(MsUnLock())

                    MsgInfo('Arquivo anexado com sucesso!',"Aten��o")
                Else
                    Alert('Erro ao anexar arquivo.',"Aten��o")
                EndIf
            EndIf


        Else
            Alert('Arquivo n�o informado!')
        EndIf
    EndIf
Return

//+-------------------------------------------------------------------------------
//  Fonte respons�vel pela visualiza��o do anexo no or�amento
//  Chamado do ponto de entrada MA415MNU
//+-------------------------------------------------------------------------------
User Function M02A06_c()
    Local _cDir     := AllTrim(GetMv('AM_02A06_A',.T.,''))

    If Empty(_cDir)
        Aviso('Aten��o','� obrigat�rio informar o diret�rio de armazenamento no par�metro AM_02A06_A.',{'OK'},3)
    Else
        _cDir   += AllTrim(SC7->(C7_FILIAL + C7_NUM)) + '\'

        MakeDir(_cDir)
        WinExec('explorer.exe ' + _cDir)
    EndIf
Return
