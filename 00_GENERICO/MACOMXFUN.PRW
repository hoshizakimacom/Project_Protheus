#Include "Totvs.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"

#Define Enter chr(13) + chr(10)

//#DEFINE cSpecialCharacters (('";<;>;&;};{;�;`;*;%;$;#;@;!;/;*;|') + (";';+;�;�"))
#DEFINE cSpecialCharacters (('";<;>;&;};{;*;%;$;#;@;!;*;|') + (";';+;�;�")) // #4711 - Retirado / � `

/*/{Protheus.doc} MACOMXFUN
Fun��o gen�rica 

@type function
@author	Jorge Heitor T. de Oliveira
@since 20/06/2023
@version P12
@database MSSQL

@history Fonte para contemplar fun��es gen�ricas utilizadas em diversos prop�sitos

/*/
User Function MACOMXFUN()

Return Nil

/*
    Fun��o para remover caracteres especiais de uma string de Campos em MVC (Utilizar na valida��o do campo)
*/
User Function ClearText()
    Local cVariable     as character
    Local cField        as character
    Local bBlock        as block
    Local aCharacters   as array
    Local lNoMVC        as logical
    Local lReturn       as logical
    Local cString       := ""
    
    lNoMVC := (FWModelActive() == Nil)
    cVariable := ReadVar()
    cField := SubString(cVariable,At(">",cVariable)+1,Len(cVariable))
    If lNoMVC
        cString := &(cVariable)

    Else
        cString := FWFldGet(cField)
    EndIf
    
    // Tratamento - 29/08/23 #4358
    If cString == Nil
        Return .T.
    Else
        cString := AllTrim(cString)
    EndIf

    bBlock := {|char| cString := StrTran(cString,char,"")}
    aCharacters := Separa(cSpecialCharacters, ";")
    lReturn := .T.

    //Processa substitui��es
    aEval(aCharacters, bBlock)

    //Atualiza campo lido no "Valid"
    If lNoMVC
        &(cVariable) := FwNoAccent(cString)
    
    Else
        FWFldPut(cField,FwNoAccent(cString))

    EndIf

Return lReturn

/*
    Fun��o para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN
    exemplo: 1=Projeto;2=V.Unit.;3=Dealer;4=E-Commerce;5=P.Entrega;6=Proj.Dealer;7=Vnda Pecas;8=Sup.Tec.;9=ARE;10=Serv;11=Itens Falta;12=SAC 
*/

//U_BusTpVen(cTpVen)

User Function BusTpVen(cTpVen,cCampo)

Local aArea      := GetArea()
Local aAreaSX3   := SX3->(GetArea())
Local cDescTpVen := Space(10)

dbSelectArea("SX3")
dbSetOrder(2)
If SX3->(MsSeek(cCampo))
	cCombo := SX3->( X3CBox() )
	aCombo := StrTokArr ( cCombo , ';' )

    //1=Venda;2=Entrega
    nPos := Ascan(aCombo,{|X| Left(X[1],2) == cTpVen })
    If nPosArr <> 0
        cDescTpVen := aCombo[nPosArr]
    EndIf
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return(cDescTpVen)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    ?SendMail ?Autor ?                           ?Data ?4.11.2001 ��?
��������������������������������������������������������������������������Ĵ��
��?         �Envio de E-mail                                              ��?
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Servido de E-mail                                     ��?
��?         �ExpC2: Conta de E-mail                                       ��?
��?         �ExpC3: Senha Conta E-mail                                    ��?
��?         �ExpC4: String Contas E-mail destino                          ��?
��?         �ExpC5: Assunto                                               ��?
��?         �ExpC6: Corpo de Texto                                        ��?
��?         �ExpC7: Arquivos Anexos                                       ��?
��������������������������������������������������������������������������Ĵ��
���Retorno   �Logico - .T. - Operacao realizada                            ��?
��?         ?      - .F. - Operacao NAO realizada                        ��?
��������������������������������������������������������������������������Ĵ��
���Uso       ?Generico                                                    ��?
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function Send2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro,cTpEnvio)

	//��������������������������?
	//?Define Valores padroes. ?
	//��������������������������?
    Local lReturn
    Local cTpEnvio := If(ValType(cTpEnvio) != "U" , cTpEnvio,  "D" )
    Private cMailDestino := If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
    Private lMensagem    := If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

    If cTpEnvio == "D"  // Envia Direto
        If lMensagem
            lReturn := Processa({||U_SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)})
        Else
            lReturn := U_SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)
        EndIf

    EndIf

Return(lReturn)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �SendMail2 ?Autor ?TI1369-ALEX FONSECA   ?Data ?4.11.2001 ��?
��������������������������������������������������������������������������Ĵ��
��?         ?Envio de E-mail                                             ��?
��������������������������������������������������������������������������Ĵ��
���Uso       ?Generico                                                    ��?
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem,cMensQdoErro)

	Local cTitAdic	:= AllTrim(GetMv("ES_WFTITAD",, ""))

    Private cMailConta   := GetMv("MV_RELACNT")
    Private cMailSenha   := GetMv("MV_RELPSW")
    Private cMailServer  := GetMv("MV_RElSERV")

    cAssunto 		  := If( Type(cAssunto) != "U" , cAssunto , "" )
    cTexto 			  := If( ValType(cTexto)   != "U" , cTexto   , "" )
    cAnexos			  := If( ValType(cAnexos)  != "U" , cAnexos  , "" )
    lConexao		     := .F.
    Lenvio   		  := .F.
    lDesconexao		  := .F.
    cErro_Conexao 	  := ""
    cErro_Envio		  := ""
    cErro_Desconexao := ""
    cMensQdoErro     := If( ValType(cMensQdoErro)   != "U" , cMensQdoErro   , "" )

    If lMensagem
        ProcRegua(3)
    EndIf

	//������������������?
	//?Avalia conteudo ?
	//������������������?
    If Empty( cMailDestino )
        If lMensagem
            MsgStop( "Conta(s) de Email Destino nao Informada "+cMensQdoErro)
        EndIf
        Return(.F.)
    EndIf

    If Empty( cAssunto )
        If lMensagem
            MsgStop( "Assunto do E-mail nao Informado"+cMensQdoErro)
        EndIf
        Return(.F.)
    EndIf

    If Empty( cTexto )
        If lMensagem
            MsgStop( "Texto do E-mail nao Informado"+cMensQdoErro)
        EndIf
        Return(.F.)
    EndIf

    If lMensagem
        IncProc("Conectando ao servidor de Email !!!")
    EndIf

	//������������������������������������������������������Ŀ
	//?Executa conexao ao servidor mencionado no parametro. ?
	//��������������������������������������������������������
    For nProc := 1 To 10

        Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

        If !lConexao .And. nProc == 10
            GET MAIL ERROR cErro_Conexao
            MsgStop("Nao foi possivel estabelecer a CONEXAO com o servidor - " + cErro_Conexao + " - "+cMensQdoErro)
            Return( .F. )
        EndIf
    Next

	//��������������������������������������������������������������������?
	//?Verifica se o parametro de requerer autenticacao est?habilitado. ?
	//��������������������������������������������������������������������?
    If GetMv("MV_RELAUTH")
        MailAuth(cMailConta,cMailSenha)
    EndIf

    If lMensagem
        IncProc("Enviando Email !!!")
    EndIf

	//����������������������������Ŀ
	//?Executa envio da mensagem. ?
	//������������������������������
    If !Empty( cANEXOS )
        Send Mail From cMAILCONTA to cMAILDESTINO SubJect cTitAdic + cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO

    Else
        Send Mail From cMAILCONTA to cMAILDESTINO SubJect cTitAdic + cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO

    EndIf

    If !Lenvio
        Get Mail Error cErro_Envio
        If lMensagem
            MsgStop("Nao foi possivel ENVIAR a mensagem - " + cErro_Envio + " - "+cMensQdoErro)
        EndIf
        Return(.F.)
    EndIf

    If lMensagem
        IncProc("Desconectando do servidor de Email !!!")
    EndIf

	//��������������������������������������Ŀ
	//?Executa disconexao ao servidor SMTP. ?
	//����������������������������������������
    DisConnect Smtp Server Result lDesconexao

    If !lDesconexao
        Get Mail Error cErro_Desconexao
        If lMensagem
            MsgStop("Nao foi possivel desconectar do servidor - " + cErro_Desconexao )
        EndIf
        Return( .F. )
    EndIf

Return(.T.)
