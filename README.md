# SGE — Sistema de Gestão de Estoque

Bem-vindo ao **SGE (Sistema de Gestão de Estoque)**! Este projeto foi desenvolvido para oferecer uma solução completa e moderna para controle de estoque, pedidos, fornecedores, usuários e fluxo operacional.

---

## 📦 Visão Geral

O SGE é um sistema baseado em **ASP.NET WebForms (VB)** integrado com **SQL Server**, oferecendo recursos completos para ambientes corporativos que precisam de organização, segurança e automação no processo logístico.

---

## 🚀 Funcionalidades Principais

* **Autenticação de usuários** (login e controle de sessão)
* **Cadastro de produtos** com categoria, fornecedor e status
* **Cadastro de fornecedores**
* **Cadastro de usuários** (com perfis)
* **Controle de estoque**
* **Pedidos em tempo real**
* **Painel do comprador**
* **Painel do conferente**
* **Dashboard com gráficos e métricas**
* **Bloqueio automático de edição para produtos conferidos**
* **Sistema responsivo e pronto para produção**

---

## 🏗 Arquitetura do Projeto

* **Frontend:** ASPX + JavaScript + CSS
* **Backend:** VB.NET (WebForms)
* **Banco:** Microsoft SQL Server
* **Padrão:** Code-behind + Data Access via ADO.NET

Estrutura principal:

```
/SGE
 ├── WebForms/
 │    ├── Login.aspx
 │    ├── Dashboard.aspx
 │    ├── CadastroProduto.aspx
 │    ├── CadastroFornecedor.aspx
 │    ├── PainelComprador.aspx
 │    ├── PainelConferente.aspx
 │    ├── Conferente.aspx
 │    ├── Estoque.aspx
 │    └── ...
 ├── imagens/
 ├── App_Data/
 ├── SGE.vbproj
 └── README.md
```

---

## 🗂 Diagrama Entidade-Relacionamento (ER)

Entidades principais:

* **Produtos**
* **Categorias**
* **Fornecedores**
* **Usuários**
* **Pedidos**
* **Itens do Pedido**
* **Status do Produto**

---

## 🧭 Fluxo Geral do Sistema

1. Usuário faz login.
2. É redirecionado para o dashboard.
3. Dependendo do perfil, acessa:

   * **Painel Comprador** (realiza pedidos)
   * **Painel Conferente** (confere e bloqueia produtos)
   * **Admin** (cadastros gerais)
4. Todas as telas estão integradas ao SQL Server.
5. Dashboard exibe métricas atualizadas.

---

## 💾 Banco de Dados

### Tabelas principais:

* `produtos`
* `fornecedores`
* `categorias`
* `usuarios`
* `pedidos`
* `pedido_itens`
* `status`

---

## 🛠 Como rodar o projeto

### 1. Clone o repositório

```bash
git clone https://github.com/Dhiekson/SGE.git
```

### 2. Abra no Visual Studio 2010 ou superior

Arquivo: `SGE.sln`

### 3. Configure a conexão SQL Server

No arquivo `Conexao.vb`:

```vb
cn.ConnectionString = "Data Source=SEU_SERVIDOR;Initial Catalog=SGE_Novo;Integrated Security=True"
```

### 4. Execute o script SQL

Importe todas as tabelas e dados iniciais.

### 5. Rode o projeto

Clique em **Start** ou pressione **F5**.

---

## 🧪 Testes

* Login
* Cadastro CRUD
* Pedidos em tempo real
* Edição bloqueada para produtos conferidos

---

## 📌 Requisitos

* Windows + IIS Express
* Visual Studio 2010 ou superior
* SQL Server 2014+

---

## 🤝 Contribuição

Contribuições são bem-vindas!
Abra um Pull Request ou Issue no repositório.

---

## 📄 Licença

Este projeto é privado e não possui licença aberta.

---

## 👨‍💻 Autor

**Dhiekson Nunes** — Desenvolvedor do SGE
