#include "rwmake.ch"
/*/
嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈嗈
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
控矬闡闡闡闡鐃闡闡闡闡闡薩闡闡闡薩闡闡闡闡闡闡闡闡闡闡闡鐃闡闡闡薩闡闡闡闡醴控
控蚶uncao    � FA070TIT � Autor � Marcos Rocha           � Data � 18.10.24 陰�
控藥闡闡闡闡霰闡闡闡闡闡謐闡闡闡謐闡闡闡闡闡闡闡闡闡闡闡鐘闡闡闡謐闡闡闡闡譬控
控蛇escricao � Controle na Baixa do Desconto                               陰�
控藥闡闡闡闡霰闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡譬控
控袋so       � Especifico Macom                                            陰�
控斂闡闡闡闡鐘闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡闡囁控
控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控控
葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔葔
/*/

User Function Fa070tit()

Local cRet := .T.

If SE1->E1_PREFIXO == 'PVA' .And. SE1->E1_TIPO == 'BOL'  .And.  (NVALREC+NDESCONT) < SE1->E1_SALDO
   MsgBox ("Baixa parcial n緌 permitida ! Baixa não Realizada","Atencao!!!","ALERT")
   cRet := .F.
EndIf

Return(cRet)
