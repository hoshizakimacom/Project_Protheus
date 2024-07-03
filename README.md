1.	OBJETIVO
Para que os processos fluam de forma automática e visual a todos os profissionais do setor de TI, evitando retrabalhos ou perca de informações, se faz necessário o uso da ferramenta Git Hub.
Basicamente, é uma plataforma de desenvolvimento colaborativo que aloja projetos na nuvem utilizando o sistema de controle de versões chamado Git. A plataforma ajuda os desenvolvedores a armazenarem e administrar o código e faz o registro de mudanças. 
Como premissa de sua utilização, o programa Visual Studio (padrão para manutenção com códigos fontes do Sistema Totvs ERP Protheus - Linguagem ADVPL) necessita estar instalado na estação de trabalho.

2.	CAMPO DE APLICAÇÃO
Sistema Totvs ERP Protheus

3.	DOCUMENTOS RELACIONADOS
Link para consulta:
Sobre o Git - GitHub Docs

4.	DIRETRIZES GERAIS 
4.1 Instalando o GitHub
01 - Baixar o GitHub em https://git-scm.com/downloads;
02 - Escolher a versão do sistema operacional do computador;
03 - No processo de instalação, selecionar a opção "use visual studio code as git´s default edit";
04 - Na sequência, opção "let git decide";
05 - Selecionar "git from command line and also from 3rd-party software”;
06 - Use bundled OpenSSH;
07 - Checkout Windows-style, commit Unix-style line endings;
08 - Use MinTTY (the defalt terminar of MSYS2);
09 - Fast-forward or merge;
10 - Git Credentian Manager;
11 - Enable file system caching e Enable symbolic links;
12 - Após as seleções destacadas acima, nenhuma outra é necessária, basta seguir a instalação normalmente até seu final.

4.2 Instalando o GitHub Desktop
01 - Baixar o Git Hub Desktop em https://desktop.github.com/; 
02 - Com uma conta pré-cadastrada, realizar login através da conta:
03 - Mesmo que o Windows não peça, reiniciar computador;
04 - Após instalação, abrir o GitHub Desktop e criar um repositório local, se houver necessidade. ( + Create a New Repository on your local driver...);
05 - Preencher conforme figura abaixo, no diretório desejado;
 
*Obs.: Após a criação do diretório, haverá uma pasta oculta chamada ".git". Nela estarão todas as configurações do programa. Para uma posterior recuperação de backup, esta será a pasta a ser utilizada.

06 - Publicar repositório;
07 - Verificar em https://github.com/hoshizakimacom?tab=repositories se o repositório foi publicado corretamente (necessário acesso a conta configurada no GitHub);
08 - No GitHub Desktop selecionar "Open in Visual Studio Code". É exibido o projeto dentro do visual studio; 
09 - Dentro da pasta local do repositório, colocar os arquivos que necessita, observe que todos são exibidos no Visual Studio; 
10 - Ainda no Visual Studio (figura acima), o ícone de "pendências" alertará o usuário de que aquelas alterações realizadas ainda não foram sincronizadas com a nuvem do GitHub;
11 - No GitHub Desktop selecione os arquivos ou pastas que deseja realizar o sincronismo, marque e vá na opção "commit to main" e na sequência "Push origin"; 
12 - Volte ao https://github.com/hoshizakimacom?tab=repositories, são exibidos todos os arquivos sincronizados;
13 - Por fim, sempre que realizar alguma manutenção em qualquer fonte, abra o GitHub Desktop e faça uma sincronização através da opção "Fetch origin";

4.3 Criando Branches (Outros Ambientes/Ramificações)
01 - No site https://github.com/hoshizakimacom/Project_Protheus, vá até a opção <>Code;
02 - Em seguida, opção branches;
03 - Para criação, utilize o botão "New branch";

Obs.: Crie preferencialmente um branch em seu nome, para que desta forma todo o seu trabalho fique em um determinado “ambiente”.

04 - Voltando ao passo 1, observe que agora existem duas branches, ou seja, dois ambientes separados para trabalho;
05 - Para visualizar os arquivos pertencentes ao ambiente que deseja, basta alterá-lo na opção destacada;
06 - Por fim, realize a sincronização através da opção "Fetch origin" dentro do GitHub Desktop;
07 - No GitHub Desktop, para alteração de branch, vá até a opção "Current Branch";

4.4 Alteração de Branches no Visual Code
01 - Abra o GitHub Desktop e vá em "Open in Visual Studio Code". É exibido o projeto dentro do Visual Studio;
02 - Troque o branch conforme sinalizado na figura abaixo;
03 - Assim que terminada a homologação de algum fonte, quando este for para produção, troque no GitHub Desktop o branch para Produção, marque o fonte que sofreu alteração, vá em "commit to main" e na sequência "Push origin".

4.5 Adicionando usuários ao projeto
01 - Visite o endereço https://github.com/hoshizakimacom e faça o login como administrador.
02 - Selecione a opção abaixo:
03 - Em seguida, “settings -> collaborators -> add people”:
 
5. ATRIBUIÇÕES DE RESPONSABILIDADES 
Equipe especializada em manutenções do ERP Totvs Protheus
