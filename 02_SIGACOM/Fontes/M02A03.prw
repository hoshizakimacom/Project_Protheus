#Include 'Protheus.ch'
#Include 'Matr620.ch'

//+------------------------------------------------------------------------------------------
//  Chamada do PE para completar a numeração da NE de Entrada
//+------------------------------------------------------------------------------------------
User Function M02A03()
    Local lRet      := .T.
    Local lNfiscal  := IIF(Type("cNfiscal") == "U",.F.,.T.)

    If !lNfiscal
        cNfiscal := PadL(AllTrim(c920Nota),TamSX3("F1_DOC")[01],"0")
    Else
        If Len(AllTrim(cNfiscal)) < 9
            cNfiscal:= PadL(AllTrim(cNfiscal),TamSX3("F1_DOC")[01],"0")
        EndIf
    EndIf
Return lRet

