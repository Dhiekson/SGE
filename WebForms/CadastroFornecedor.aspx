<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroFornecedor.aspx.vb"
    Inherits="SGE.CadastroFornecedor" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Fornecedores</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fb;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            max-width: 900px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        h2 {
            color: #333;
            margin: 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 10px;
            vertical-align: middle;
        }
        input[type="text"], input[type="email"] {
            width: 95%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn {
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            margin: 6px 4px;
            cursor: pointer;
            transition: background-color 0.2s;
            font-weight: bold;
            color: white;
        }
        .btn:hover { opacity: 0.9; }
        .btn-primary { background-color: #4CAF50; }
        .btn-warning { background-color: #ff9800; }
        .btn-danger { background-color: #f44336; }
        .btn-voltar { background-color: #607D8B; }
        .btn-voltar:hover { background-color: #546E7A; }
        .btn-container { text-align: right; }
        h3 { margin-top: 40px; color: #333; }
        .grid-container { overflow-x: auto; margin-top: 10px; }
        .mensagem {
            text-align: center;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .mensagem.erro { color: red; }
        .mensagem.sucesso { color: green; }

        /* Campo de busca */
        .search-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        .search-bar input[type="text"] {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn-search { background-color: #2196F3; }
        .btn-search:hover { background-color: #1976D2; }
        .btn-reset { background-color: #9E9E9E; }
        .btn-reset:hover { background-color: #757575; }

        /* Tabela de fornecedores */
        .tabela-fornecedores {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            background-color: #fff;
        }
        .tabela-fornecedores th {
            background-color: #e8f5e9;
            color: #333;
            text-align: left;
            padding: 10px;
            font-weight: bold;
            border-bottom: 1px solid #ccc;
        }
        .tabela-fornecedores td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 13px;
        }
        .btn-warning { background-color: #ffb300; }
        .btn-warning:hover { background-color: #ffa000; }
        .btn-danger { background-color: #e53935; }
        .btn-danger:hover { background-color: #c62828; }
    </style>

    <script type="text/javascript">
        function mascaraCNPJ(campo) {
            let v = campo.value.replace(/\D/g, '');
            v = v.replace(/^(\d{2})(\d)/, '$1.$2');
            v = v.replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3');
            v = v.replace(/\.(\d{3})(\d)/, '.$1/$2');
            v = v.replace(/(\d{4})(\d)/, '$1-$2');
            campo.value = v;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">

        <!-- ID oculto -->
        <asp:TextBox ID="txtID" runat="server" style="display:none;"></asp:TextBox>

        <!-- Barra superior -->
        <div class="top-bar">
            <h2>Cadastro de Fornecedores</h2>
            <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar"
                OnClick="btnVoltar_Click" />
        </div>

        <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

        <!-- Formulário -->
        <table>
            <tr>
                <td>Nome do Fornecedor:</td>
                <td><asp:TextBox ID="txtNomeFornecedor" runat="server" /></td>
            </tr>
            <tr>
                <td>CNPJ:</td>
                <td><asp:TextBox ID="txtCNPJ" runat="server" MaxLength="18" onkeyup="mascaraCNPJ(this)" /></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><asp:TextBox ID="txtEmail" runat="server" /></td>
            </tr>
            <tr>
                <td colspan="2" class="btn-container">
                    <asp:Button ID="btnAdicionar" runat="server" Text="Adicionar" CssClass="btn btn-primary"
                        OnClick="btnAdicionar_Click" BackColor="#009933" />
                    <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar" CssClass="btn btn-warning"
                        OnClick="btnAtualizar_Click" />
                     <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-voltar"
                        OnClick="btnCancelar_Click" BackColor="#CC0000" />
                </td>
            </tr>
        </table>

        <!-- 🔍 Campo de Busca -->
        <h3>Lista de Fornecedores</h3>
        <div class="search-bar">
            <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nome ou CNPJ..." />
            <asp:Button ID="btnBuscar" runat="server" Text="🔍 Pesquisar" CssClass="btn btn-search"
                OnClick="btnBuscar_Click" />
            <asp:Button ID="btnResetar" runat="server" Text="🔄 Limpar Filtro" CssClass="btn btn-reset"
                OnClick="btnResetar_Click" />
        </div>

        <!-- 🧾 Grid de Fornecedores -->
        <div class="grid-container">
            <asp:GridView ID="gvFornecedores" runat="server" AutoGenerateColumns="False"
                DataKeyNames="idFornecedor" CssClass="tabela-fornecedores"
                OnSelectedIndexChanged="gvFornecedores_SelectedIndexChanged"
                OnRowDeleting="gvFornecedores_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="idFornecedor" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="nomeFornecedor" HeaderText="Nome" />
                    <asp:BoundField DataField="CNPJ" HeaderText="CNPJ" />
                    <asp:BoundField DataField="email" HeaderText="Email" />

                    <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button ID="btnEditar" runat="server" Text="Editar"
                                CssClass="btn btn-warning btn-sm"
                                CommandName="Select" />
                            <asp:Button ID="btnExcluir" runat="server" Text="Excluir"
                                CssClass="btn btn-danger btn-sm"
                                CommandName="Delete"
                                OnClientClick="return confirm('Tem certeza que deseja excluir este fornecedor?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    </form>
</body>
</html>
