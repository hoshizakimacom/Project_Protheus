User Function fImgDown()
	Processa({|| download()} , "Aguarde...copiando repositório")
Return

Static function download()
	IncProc("Copiando...")
	cDir:=cGetFile("Pastas|*","Salvar",,,.F.,176)
    if !Empty(cDir)
		aEval(GetResArray('*.*'),{|x|Resource2File(x,cDir+x), IncProc(x)})
	   //	MsgInfo "sucesso"
	endif
Return