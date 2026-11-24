#Include "Totvs.ch"

User Function M05A44()
    Local lRet      := .T.
    Local dDataDig  := M->C5_FECENT

    // Verifica se a data preenchida é diferente da próxima data válida
    If !Empty(dDataDig) .And. dDataDig <> DataValida(dDataDig, .T.)
        Help(,, "DATAINV",, "A data de entrega informada cai em um final de semana ou feriado.", 1, 0,,,,,, {"Informe um dia útil válido."})
        lRet := .F.
    EndIf

Return lRet
