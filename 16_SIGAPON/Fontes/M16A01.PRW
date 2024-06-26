/*
����������������������������������������������������������������������Ŀ  
� Fun��o   �   M16A01  � Autor � Cleber Maldonado    � Data �20/01/2020�          
����������������������������������������������������������������������Ĵ  
� Descri��o� Insere hora no campo PY_XRECEB 	                       �  
����������������������������������������������������������������������Ĵ  
� Uso      � Ponto de Entrada P340ROTI                                 �  
������������������������������������������������������������������������  
*/                   
User Function M16A01(_nOpc)

Local _lErro     := .F.
Local _nRecebe   := 0.00
Local _nCarreg   := 0.00
Local _nEntrada  := 0.00
Local _aArea     := GetArea()

dbSelectArea("SPY")
dbSetOrder(1)

_nEntrada := SPY->PY_ENTRADA

If _nEntrada == 0
	MSGSTOP("Registro de entrada na portaria n�o efetuado !","ATEN��O")
	_lErro := .T.
Endif
//+--------------------------------------------------------------------
//|
//| Tratamento para opera��es de Recebimento - ( Almoxarifado )
//|
//+--------------------------------------------------------------------
If !_lErro .And. _nOpc == "R"
	_nRecebe:= VAL(StrTran(Substr(time(),1,5),":","."))
	
    Reclock("SPY",.F.)
       SPY->PY_XRECEB := _nRecebe
    MsUnlock()
    
    MSGINFO("Registrado hora de inicio de recebimento : " + Time(),"SUCESSO!")
Endif

//+--------------------------------------------------------------------
//|
//| Tratamento para opera��es de Cerregamento - ( Expedi��o )
//|
//+--------------------------------------------------------------------
If !_lErro .And. _nOpc == "C"
	_nCarreg:= VAL(StrTran(Substr(time(),1,5),":","."))
	
    Reclock("SPY",.F.)
       SPY->PY_XCARREG := _nCarreg
    MsUnlock()
    
    MSGINFO("Registrado hora de inicio de carregamento : " + Time(),"SUCESSO!")
Endif

RestArea(_aArea)

Return 
