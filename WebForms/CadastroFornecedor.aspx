<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroFornecedor.aspx.vb"
    Inherits="SGE.CadastroFornecedor" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Fornecedores</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
        }

        /* ====== TOPO ====== */
        .header {
            background-color: #1a237e;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .header h1 {
            margin: 0;
            font-size: 22px;
        }

        /* ====== CONTAINER ====== */
        .container {
            width: 90%;
            max-width: 950px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            padding: 30px 40px;
        }

        h2, h3 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* ====== FORM ====== */
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
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
        }

        input[type="text"]:focus, input[type="email"]:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 6px rgba(0,123,255,0.3);
        }

        /* ====== BOTÕES ====== */
        .btn {
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            margin: 6px 4px;
            cursor: pointer;
            font-weight: 600;
            color: #fff;
            transition: background 0.3s, transform 0.1s;
        }

        .btn:hover {
            transform: scale(1.03);
        }

        .btn-primary {
            background: linear-gradient(90deg, #4CAF50, #2E7D32);
        }

        .btn-warning {
            background: linear-gradient(90deg, #ff9800, #e68900);
        }

        .btn-danger {
            background: linear-gradient(90deg, #f44336, #d32f2f);
        }

        .btn-voltar {
            background: linear-gradient(90deg, #607D8B, #455A64);
        }

        .btn-search {
            background: linear-gradient(90deg, #2196F3, #1976D2);
        }

        .btn-reset {
            background: linear-gradient(90deg, #9C27B0, #7B1FA2);
        }

        .btn-container {
            text-align: right;
            padding-top: 10px;
        }

        /* ====== GRID ====== */
        .tabela-fornecedores {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            background-color: #fff;
        }

        .tabela-fornecedores th {
            background-color: #1a237e;
            color: white;
            padding: 10px;
            text-align: left;
        }

        .tabela-fornecedores td {
            border: 1px solid #ddd;
            padding: 8px;
        }

        .tabela-fornecedores tr:nth-child(even) {
            background-color: #f7f9fc;
        }

        /* ====== CENTRALIZAÇÃO DOS BOTÕES DE AÇÃO ====== */
        .tabela-fornecedores td:last-child {
            text-align: center;
        }

        .btn-grid {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            border: none;
            border-radius: 6px;
            padding: 8px 14px;
            margin: 4px 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            color: #fff;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .btn-grid:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 10px rgba(0,0,0,0.25);
        }

        .btn-edit {
            background: linear-gradient(90deg, #ffb300, #ff8f00);
        }

        .btn-delete {
            background: linear-gradient(90deg, #e53935, #c62828);
        }

        /* ====== BUSCA ====== */
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

        /* ====== MENSAGEM ====== */
        .mensagem {
            text-align: center;
            font-weight: bold;
            margin: 15px 0;
        }

        .mensagem.sucesso {
            color: #4CAF50;
        }

        .mensagem.erro {
            color: #f44336;
        }

        /* ====== FOOTER ====== */
        footer {
            text-align: center;
            margin: 30px 0 15px;
            color: #666;
            font-size: 14px;
        }
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
    <div class="header">
        <h1>
            SGE - Cadastro de Fornecedores</h1>
        <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar"
            OnClick="btnVoltar_Click" />
    </div>
    <div class="container">
        <asp:TextBox ID="txtID" runat="server" Style="display: none;"></asp:TextBox>
        <h2>
            Gerenciar Fornecedores</h2>
        <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
        <table>
            <tr>
                <td>
                    Nome do Fornecedor:
                </td>
                <td>
                    <asp:TextBox ID="txtNomeFornecedor" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    CNPJ:
                </td>
                <td>
                    <asp:TextBox ID="txtCNPJ" runat="server" MaxLength="18" onkeyup="mascaraCNPJ(this)" />
                </td>
            </tr>
            <tr>
                <td>
                    Email:
                </td>
                <td>
                    <asp:TextBox ID="txtEmail" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2" class="btn-container">
                    <asp:Button ID="btnAdicionar" runat="server" Text="Adicionar" CssClass="btn btn-primary"
                        OnClick="btnAdicionar_Click" />
                    <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar" CssClass="btn btn-warning"
                        OnClick="btnAtualizar_Click" />
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-voltar"
                        OnClick="btnCancelar_Click" />
                </td>
            </tr>
        </table>
        <h3>
            Lista de Fornecedores</h3>
        <div class="search-bar">
            <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nome ou CNPJ..." />
            <asp:Button ID="btnBuscar" runat="server" Text="🔍 Pesquisar" CssClass="btn btn-search"
                OnClick="btnBuscar_Click" />
            <asp:Button ID="btnResetar" runat="server" Text="🔄 Limpar Filtro" CssClass="btn btn-reset"
                OnClick="btnResetar_Click" />
        </div>
        <div class="grid-container">
            <asp:GridView ID="gvFornecedores" runat="server" AutoGenerateColumns="False" DataKeyNames="idFornecedor"
                CssClass="tabela-fornecedores" OnSelectedIndexChanged="gvFornecedores_SelectedIndexChanged"
                OnRowDeleting="gvFornecedores_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="idFornecedor" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="nomeFornecedor" HeaderText="Nome" />
                    <asp:BoundField DataField="CNPJ" HeaderText="CNPJ" />
                    <asp:BoundField DataField="email" HeaderText="Email" />
                    <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="btn-grid btn-edit"
                                CommandName="Select" />
                            <asp:Button ID="btnExcluir" runat="server" Text="Excluir" CssClass="btn-grid btn-delete"
                                CommandName="Delete" OnClientClick="return confirm('Tem certeza que deseja excluir este fornecedor?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    <footer>
            © 2025 SGE - Sistema de Gestão de Estoque.
        </footer>
    </form>
</body>
</html>
