//+---------------------------------------------------
//| Gatilho para preenchimento de codificação de componentes
//| da Engenharia
//+---------------------------------------------------
//| Disparador : B1_XENGOPC
//| Preenche   : B1_COD
//+---------------------------------------------------
User Function M04G01()

    Local _cRet := ""

          _cRet := FWFLDGET("B1_XENGFAM")+FWFLDGET("B1_XENGTIP")+FWFLDGET("B1_XENGSEQ")+FWFLDGET("B1_XENGMAT")+FWFLDGET("B1_XENGOPC")

Return _cRet
