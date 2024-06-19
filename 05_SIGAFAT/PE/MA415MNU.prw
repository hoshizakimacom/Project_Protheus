#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------
//| PE para inclusao de itens no menu do orçamento de vendas
//+-------------------------------------------------------------------------------------------------------------
User Function MA415MNU()
    Local _cGrpApr      := GetMv('AM_05A0902',,'')
    Local _cGrpBlq      := GetMv('AM_05A0903',,'')
    Local _cGrpRep      := GetMv('AM_MA415_A',,'')
    Local _lAprov       := U_M00A01(_cGrpApr)
    Local _lBloq        := U_M00A01(_cGrpBlq)
    Local _lRep         := U_M00A01(_cGrpRep)
    Local aRotBkp       := AClone(aRotina)
    Local nX            := 0
    If _lRep
        aRotina := {}

        For nX := 1 To Len(aRotBkp)

            If Upper(AllTrim(aRotBkp[nX][1])) $ 'EXCLUIR-CANCELAR-CONHECIMENTO'
                Loop
            EndIf

            AAdd(aRotina,AClone(aRotBkp[nX]))
        Next

    EndIf

    If !_lRep
        AAdd(aRotina,{'Anexo - Incluir'       ,'U_M05A25_A' , 0 , 1,0,NIL})
        AAdd(aRotina,{'Anexo - Visualizar'    ,'U_M05A25_B' , 0 , 1,0,NIL})
    EndIf


    If _lBloq
        AAdd(aRotina,{'Crédito - Bloquear'    ,'U_M05A09_A(1)' , 0 , 2,0,NIL})
    EndIf

    If _lAprov
        AAdd(aRotina,{'Crédito - Desbloquear' ,'U_M05A09_B(1)' , 0 , 2,0,NIL})
    EndIf
    
    AAdd(aRotina,{'Exportar Itens'			      ,'U_M05R04()'  , 0 , 2,0,NIL})
Return
