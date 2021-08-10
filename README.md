
# Financial Terraform

O projeto consiste em uma implementação de IaC utilizando a linguagem HCL.
O objetivo da implementação é que não seja necessário efetuar o download do código para consumir o que ele oferece.

## Utilização

O repositório é composto por duas actions, uma para efetuar o deploy de uma infraestrutura e outra para destruir alguma infraestrutura já existente.

Para utilização local é necessário ter instaldo as seguintes ferramentas:<br>

- <a href='https://aws.amazon.com/pt/cli/'>AWS CLI</a><br>
- <a href='https://www.terraform.io/'>Terraform</a><br>

E efetuar as seguintes configurações, lembrando que apenas uma delas é necessária.

##### Hardcoded - (Não recomendado)

No diretório setup, arquivo main, na configuração do provider **aws**, adicionar as seguintes propriedades:

>access_key = "my-access-key" 
>secret_key = "my-secret-key"

##### CLI - (Recomendado)

Após instalar a AWS CLI, é necessário executar um comando para configurar as credenciais. Após executar o comando, a própria CLI vai começar a solicitar as chaves de acesso. Para mais informações sobre a configuração, acesse a <a href='https://docs.aws.amazon.com/cli/latest/reference/configure/'>documentação</a>

~~~shell
$ aws configure
AWS Access Key ID [None]: accesskey
AWS Secret Access Key [None]: secretkey
Default region name [None]: sa-west-1
Default output format [None]:
~~~

***As chaves precisam estar configuradas com acessos de deploy para a conta***


## Sobre o projeto

Está estruturado em 3 pastas

- client
- setup
- modules

As variáveis environment e alias são referentes as configurações de nome e tags. As variáveis podem expandir conforme a necessidade e evolução do projeto. As configurações de rede se encontram no arquivo variables da pasta setup, e precisam ser alteradas caso o projeto vá ser executado localmente.

Diagrama da infraestrutra que será provisionada:


![Infra](https://user-images.githubusercontent.com/69153761/128944938-d12953c3-2d26-4768-bc5d-5893baea3128.png)

## Executando

Após ter instalado a CLI do terraform, acessar a pasta setup e alterar as configurações de rede (network) no arquivo variables. Com a configuração de rede efetuada, acessar a pasta client, e alterar as configurações de alias e environment conforme necessidade.

Com as configurações de variáveis efetuadas, você pode rodar o seguinte comando na pasta client:

~~~sh
$ terraform init
$ terraform plan
$ terraform apply
~~~

Na etapa do terraform plan, as informações sobre a infraestrutura que serão exibidas. Na etapa do terraform apply será necessário digitar *yes* na solicitação de confirmação. Com isso a infraestrutura será provisionada na conta das chaves configuradas.

É possível parametrizar os comandos do terraform.

- Para não precisar alterar as variáveis na mão.
~~~sh
terraform apply -var='common={"environment"="valor", "alias"="valor"}'
~~~

- Para não precisar confirmar na etapa de apply
~~~sh
terraform apply -auto-approve 
~~~

- Para receber algumas informações úteis sobre a infraestrutura que está deployada
~~~sh
terraform output
~~~

Após utilizar a infraestrutra, para não precisar deletar tudo que foi provisionado manualmente, apenas execute o comando. Toda a infraestrutra provisionada será destruída.
~~~sh
terraform destroy
~~~

## Extras

Como foi citado anteriormente, o repositorio está configurado com *Github Actions* que executam os comandos necessários para provisionar a infraestrutura necessária, podendo ser parametrizada via interface. Para utilizar as actions é simples.

- Acesse a aba actions na tela do repositório.
- Selecione o workflow que deseja rodar, no caso de deploy *Deploy Infra* e no caso de destroy *Destroy Infra*.
- Na action de deploy, inserir o valor do alias e do environment, e toda a infraestrutura será provisionada. É possível verificar o endpoint gerado na etapa de *Outputs useful variables*, na chave lb_address.
- Na action de destroy, inserir o mesmo valor de alias e environment que foi enviado no momento de deploy e toda a infraestrutura será destruída. É *importante* executar essa action sempre que terminar de utilizar o ambiente, minha AWS não é mais gratuita.

Um ponto importante no provisionamento do load balancer é o pequeno delay para o mapeamento do target. Os arquivos de estado estão sendo mantidos em uma S3, toda vez que uma ação de deploy é executada o upload é realizado e quando a ação de destroy é acionada o arquivo é resgatado, permitindo assim o controle dos múltiplos ambientes. 
