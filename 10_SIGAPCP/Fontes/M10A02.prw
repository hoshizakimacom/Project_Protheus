#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------
//	Fonte responsável pelo anexo de arquivos na OP
//	Chamado pelo PE MA650BUT
//+-------------------------------------------------------------------------------
User Function M10A02A()
	Local _cMascara  	:= 'Todos os arquivos|*.*'
	Local _cTitulo   	:= 'Escolha o arquivo'
	Local _nMascpad  	:= 0
	Local _cDirOri   	:= 'C:\'
	Local _cDirDes	:= AllTrim(GetMv('AM_10A02_A',.T.,''))
	Local _lSalvar   	:= .F. /*.F. = Salva || .T. = Abre*/
	Local _nOpcoes   	:= GETF_LOCALHARD
	Local _lArvore   	:= .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
	Local _lOk			:= .F.
	Private _aArquivo	:= {}

	If Empty(_cDirDes)
		Aviso('Atenção','É obrigatório informar o diretório de armazenamento no parâmetro AM_10A02_A.',{'OK'},3)
	Else
		_cDirDes	+= AllTrim(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + '\'
		_cDirOri 	:= cGetFile( _cMascara, _cTitulo, _nMascpad, _cDirOri, _lSalvar, _nOpcoes, _lArvore)

		If !Empty(_cDirOri)
			_aFiles := Directory(_cDirOri, "D")

			MakeDir(_cDirDes)

			If !(_lOk := !File(_cDirDes + _aFiles[1][1]))
				If MsgYesNo('Arquivo já anexado a esta OP.' + CRLF + 'Deseja atualizar o arquivo?')
					If !(_lOk := FErase(_cDirDes + _aFiles[1][1]) <> -1)
						MsgAlert('Erro ao apagar arquivo: ' + STR(FERROR()))
					EndIf
				EndIf
			EndIf

			If _lOk
				__CopyFile(_cDirOri,_cDirDes + _aFiles[1][1])

				If File(_cDirDes + _aFiles[1][1])
					MsgInfo('Arquivo anexado com sucesso!')
				Else
					Alert('Erro ao anexar arquivo.')
				EndIf
			EndIf
		Else
			Alert('Arquivo não informado!')
		EndIf
	EndIf
Return

//+-------------------------------------------------------------------------------
//	Fonte responsável pela visualização dos anexos da OP
//	Chamado pelo PE MA650BUT
//+-------------------------------------------------------------------------------
User Function M10A02B()
	Local _cDir		:= AllTrim(GetMv('AM_10A02_A',.T.,''))

	If Empty(_cDir)
		Aviso('Atenção','É obrigatório informar o diretório de armazenamento no parâmetro AM_10A02_A.',{'OK'},3)
	Else
		_cDir	+= AllTrim(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + '\'

		MakeDir(_cDir)
		WinExec('explorer.exe ' + _cDir)
	EndIf
Return

/*
User Function M10A001B()
	Local _cDir		:= AllTrim(GetMv('AM_10A02_A',.T.,''))
	Local _bBaixar	:= {|| alert(oBrowse:nAt) }
	Local _oDlg		:= Nil
	Local _oBrowse	:= Nil
	Local _aFiles		:= {}

	If Empty(_cDir)
		Aviso('Atenção','É obrigatório informar o diretório de armazenamento no parâmetro AM_10A02_A.',{'OK'},3)
	Else

		DEFINE DIALOG _oDlg TITLE _cTitle FROM 180,180 TO 550,700 PIXEL
			_cDir	+= AllTrim(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + '\'

			MakeDir(_cDir)

			_aFiles 	:= Directory(_cDir, "D")

			_oBrowse 	:= FWMBrowse():New(001,001,400,400,,{'Arquivo','Tamanho','Data'},{100,50,50},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			_oBrowse:SetDataArray()
			_oBrowse:SetArray(_aFiles)

			_oBrowse:AddColumn( TCColumn():New('Arquivo'	,{ || _aFiles[_oBrowse:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			_oBrowse:AddColumn( TCColumn():New('Tamanho' 	,{ || _aFiles[_oBrowse:nAt,2] },,,,"RIGHT",,.F.,.T.,,,,.F.,) )
			_oBrowse:AddColumn( TCColumn():New('Data' 	,{ || _aFiles[_oBrowse:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

			TButton():New( 172, 002, "Baixar", _oDlg,_bBaixar,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE DIALOG _oDlg CENTERED
	EndIf
Return
*/
