User Function M06A07()

Local aArray 	:= {}
Local cNumero	:= SEU->EU_NUM

Private lMsErroAuto := .F.

aArray := { { "EU_NUM" , cNumero, NIL } }

MsExecAuto( { |x,y,z| FINA560(x,y,z)} ,0, aArray, 5) 

If lMsErroAuto
	MostraErro()
Else
	MsgInfo("Exclusao do movimento efetuada.","Mensagem")
Endif

Return
