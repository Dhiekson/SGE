<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroProduto.aspx.vb"
    Inherits="SGE.CadastroProduto" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Produtos</title>
    <style>
        body
        {
            font-family: 'Segoe UI' , Arial, sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
        }
        
        /* ====== TOPO ====== */
        .header
        {
            background-color: #1a237e;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .header h1
        {
            margin: 0;
            font-size: 22px;
        }
        
        /* ====== CONTAINER ====== */
        .container
        {
            width: 90%;
            max-width: 950px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            padding: 30px 40px;
        }
        
        h2, h3
        {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        
        /* ====== FORM ====== */
        table
        {
            width: 100%;
            border-collapse: collapse;
        }
        td
        {
            padding: 10px;
            vertical-align: middle;
        }
        input[type="text"], select
        {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
        }
        input[type="text"]:focus, select:focus
        {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 6px rgba(0,123,255,0.3);
        }
        
        /* ====== BOTÕES ====== */
        .btn
        {
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            margin: 6px 4px;
            cursor: pointer;
            font-weight: 600;
            color: #fff;
            transition: background 0.3s, transform 0.1s;
        }
        .btn:hover
        {
            transform: scale(1.03);
        }
        .btn-primary
        {
            background: linear-gradient(90deg, #007bff, #0056d2);
        }
        .btn-warning
        {
            background: linear-gradient(90deg, #ff9800, #e68900);
        }
        .btn-danger
        {
            background: linear-gradient(90deg, #f44336, #d32f2f);
        }
        .btn-voltar
        {
            background: linear-gradient(90deg, #607D8B, #455A64);
        }
        .btn-buscar
        {
            background: linear-gradient(90deg, #2196F3, #1976D2);
        }
        .btn-resetar
        {
            background: linear-gradient(90deg, #9C27B0, #7B1FA2);
        }
        
        .btn-container
        {
            text-align: right;
            padding-top: 10px;
        }
        
        /* ====== GRID ====== */
        .grid-container
        {
            margin-top: 25px;
            overflow-x: auto;
        }
        .grid-container table
        {
            width: 100%;
            border-collapse: collapse;
        }
        .grid-container th
        {
            background-color: #1a237e;
            color: white;
            padding: 10px;
            text-align: center;
        }
        .grid-container td
        {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .grid-container tr:nth-child(even)
        {
            background-color: #f7f9fc;
        }
        
        /* ====== MENSAGEM ====== */
        .mensagem
        {
            text-align: center;
            font-weight: bold;
            margin: 15px 0;
        }
        .mensagem.sucesso
        {
            color: #4CAF50;
        }
        .mensagem.erro
        {
            color: #f44336;
        }
        
        /* ====== BUSCA ====== */
        .busca-container
        {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
        }
        .busca-container input[type="text"]
        {
            flex: 1;
        }
        
        /* ====== FOOTER ====== */
        footer
        {
            text-align: center;
            margin: 30px 0 15px;
            color: #666;
            font-size: 14px;
        }
        /* ====== BOTÕES DO GRIDVIEW ====== */
        .btn-grid
        {
            border: none;
            border-radius: 6px;
            padding: 6px 12px;
            margin: 2px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            color: #fff;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .btn-grid:hover
        {
            transform: scale(1.05);
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }
        .btn-edit
        {
            background: linear-gradient(90deg, #ffb300, #ffa000);
        }
        .btn-delete
        {
            background: linear-gradient(90deg, #e53935, #c62828);
        }
    </style>
    <script type="text/javascript">
        function formatarMoeda(input) {
            var valor = input.value.replace(/\D/g, '');
            if (valor === "") { input.value = ""; return; }
            valor = (valor / 100).toFixed(2) + '';
            valor = valor.replace('.', ',');
            valor = valor.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            input.value = valor;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="header">
        <h1>
            SGE - Cadastro de Produtos</h1>
        <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar"
            OnClick="btnVoltar_Click" />
    </div>
    <div class="container">
        <h2>
            Gerenciar Produtos</h2>
        <asp:HiddenField ID="txtID" runat="server" />
        <table>
            <tr>
                <td>
                    Nome do Produto:
                </td>
                <td>
                    <asp:TextBox ID="txtNome" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    Código de Barras:
                </td>
                <td>
                    <asp:TextBox ID="txtCodBarra" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    Preço Unitário:
                </td>
                <td>
                    <asp:TextBox ID="txtPreco" runat="server" onkeyup="formatarMoeda(this)" />
                </td>
            </tr>
            <tr>
                <td>
                    Categoria:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCategoria" runat="server">
                        <asp:ListItem Text="Selecione uma categoria" Value="0" />
                    </asp:DropDownList>
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
        <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
        <h3>
            Lista de Produtos</h3>
        <div class="busca-container">
            <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nome ou código..." />
            <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-buscar"
                OnClick="btnBuscar_Click" />
            <asp:Button ID="btnResetar" runat="server" Text="⟳ Resetar" CssClass="btn btn-resetar"
                OnClick="btnResetar_Click" />
        </div>
        <div class="grid-container">
            <asp:GridView ID="gvProdutos" runat="server" AutoGenerateColumns="False" DataKeyNames="idProduto"
                OnSelectedIndexChanged="gvProdutos_SelectedIndexChanged" OnRowDeleting="gvProdutos_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="idProduto" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="nomeProduto" HeaderText="Nome" />
                    <asp:BoundField DataField="codBarra" HeaderText="Código de Barras" />
                    <asp:BoundField DataField="precoUnitario" HeaderText="Preço Unitário" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="nomeCategoria" HeaderText="Categoria" ReadOnly="True" />
                    <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="btn-grid btn-edit"
                                CommandName="Select" />
                            <asp:Button ID="btnApagar" runat="server" Text="Apagar" CssClass="btn-grid btn-delete"
                                CommandName="Delete" OnClientClick="return confirm('Tem certeza que deseja excluir este produto?');" />
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
