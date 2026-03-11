#Include 'Protheus.ch'

User Function M28G01(_cCampo,_nOpc)
Local _aArea    :={}
Local _xRet     :=""
Local _cNumSer  := ""
Private _lSeek    :=.F.

If _nOpc == 1
    _cNumSer    := FWFLDGET("ZAC_NUMSER")
Else
    _cNumSer    := ZAC->ZAC_NUMSER
Endif

_aArea := GetArea()

If !Empty(_cNumSer)
    DBSelectArea("ZAB")
    DBSetOrder(1)
    ZAB->(MSSeek(xFilial("ZAB")+_cNumSer))
EndIf


Do Case
    Case _cCampo == "ZAC_CNPJ"
        _cCodCli    := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_CLIENTE")
        _cCLojCli   := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_LOJA")
        _xRet       := Posicione("SA1",1,xFilial("SA1")+_cCodCli+_cCLojCli,"A1_CGC")

    Case _cCampo == "ZAC_RAZAO"
        _cCodCli    := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_CLIENTE")
        _cCLojCli   := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_LOJA")
        _xRet       := Posicione("SA1",1,xFilial("SA1")+_cCodCli+_cCLojCli,"A1_NOME")
    
    Case _cCampo == "ZAC_REDE"
        _cCodCli    := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_CLIENTE")
        _cCLojCli   := Posicione("SF2",1,xFilial("SF2")+ZAB->ZAB_NOTA,"F2_LOJA")
        _cCodRede   := Posicione("SA1",1,xFilial("SA1")+_cCodCli+_cCLojCli,"A1_XREDE")
        _xRet       := Posicione("ZA6",1,xFilial("ZA6")+_cCodRede,"ZA6_DESC")
            
    Case _cCampo == "ZAC_NOTA"
         _xRet       := ZAB->ZAB_NOTA
EndCase

RestArea(_aArea)
Return _xRet




