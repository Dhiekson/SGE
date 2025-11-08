<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroProduto.aspx.vb" Inherits="SGE.CadastroProduto" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Produtos</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7fb; margin:0; padding:0;}
        .container { width:80%; max-width:900px; margin:40px auto; background:#fff; border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.1); padding:30px;}
        .top-bar { display:flex; justify-content:space-between; align-items:center; margin-bottom:25px; }
        h2 { color:#333; margin:0; }
        table { width:100%; border-collapse:collapse; }
        td { padding:10px; vertical-align:middle; }
        input[type="text"] { width:95%; padding:8px; border:1px solid #ccc; border-radius:6px; transition:border-color 0.3s, background-color 0.3s;}
        .btn { border:none; border-radius:6px; padding:8px 16px; margin:6px 4px; cursor:pointer; transition: background-color 0.2s; font-weight:bold; color:white;}
        .btn:hover { opacity:0.9; }
        .btn-primary{ background:#4CAF50;}
        .btn-warning{ background:#ff9800;}
        .btn-danger{ background:#f44336;}
        .btn-voltar{ background:#607D8B;}
        .btn-voltar:hover{ background:#546E7A;}
        .btn-buscar{ background:#2196F3;}
        .btn-resetar{ background:#9C27B0;}
        .btn-container { text-align:right; }
        h3 { margin-top:40px; color:#333;}
        .grid-container { overflow-x:auto; margin-top:10px;}
        .grid-container table { width:100%; border:1px solid #ccc; }
        .grid-container th { background:#f0f0f0; padding:10px; }
        .grid-container td { padding:8px; border-bottom:1px solid #eee; }
        .mensagem { margin-top:10px; font-weight:bold; }
        .mensagem.erro { color:red; }
        .mensagem.sucesso { color:green; }
        .busca-container { display:flex; align-items:center; gap:10px; margin-bottom:15px;}
        .search-bar input[type="text"] { flex:1; padding:8px; border:1px solid #ccc; border-radius:6px;}
        .btn-search{ background:#2196F3;}
        .btn-search:hover{ background:#1976D2;}
        .btn-reset{ background:#9E9E9E;}
        .btn-reset:hover{ background:#757575;}
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
        <div class="container">
            <div class="top-bar">
                <h2>Cadastro de Produtos</h2>
                <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar" OnClick="btnVoltar_Click" />
            </div>

            <asp:HiddenField ID="txtID" runat="server" />

            <table>
                <tr>
                    <td>Nome do Produto:</td>
                    <td>
                        <asp:TextBox ID="txtNome" runat="server" ValidateRequestMode="Disabled" />
                    </td>
                </tr>
                <tr>
                    <td>Código de Barras:</td>
                    <td><asp:TextBox ID="txtCodBarra" runat="server" /></td>
                </tr>
                <tr>
                    <td>Preço Unitário:</td>
                    <td><asp:TextBox ID="txtPreco" runat="server" onkeyup="formatarMoeda(this)" /></td>
                </tr>
                <tr>
                    <td>Categoria:</td>
                    <td>
                        <asp:DropDownList ID="ddlCategoria" runat="server">
                            <asp:ListItem Text="Selecione uma categoria" Value="0" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="btn-container">
                        <asp:Button ID="btnAdicionar" runat="server" Text="Adicionar" CssClass="btn btn-primary" OnClick="btnAdicionar_Click" />
                        <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar" CssClass="btn btn-warning" OnClick="btnAtualizar_Click" />
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-voltar" OnClick="btnCancelar_Click" />
                    </td>
                </tr>
            </table>

            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <h3>Lista de Produtos</h3>
            <div class="busca-container">
                <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nome ou código..." />
                <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-buscar" OnClick="btnBuscar_Click" />
                <asp:Button ID="btnResetar" runat="server" Text="⟳ Resetar" CssClass="btn btn-resetar" OnClick="btnResetar_Click" />
            </div>

            <div class="grid-container">
                <asp:GridView ID="gvProdutos" runat="server" AutoGenerateColumns="False" DataKeyNames="idProduto"
                    OnSelectedIndexChanged="gvProdutos_SelectedIndexChanged"
                    OnRowDeleting="gvProdutos_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="idProduto" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="nomeProduto" HeaderText="Nome" />
                        <asp:BoundField DataField="codBarra" HeaderText="Código de Barras" />
                        <asp:BoundField DataField="precoUnitario" HeaderText="Preço Unitário" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="nomeCategoria" HeaderText="Categoria" ReadOnly="True" />
                        <asp:CommandField ShowSelectButton="True" SelectText="Editar" />
                        <asp:CommandField ShowDeleteButton="True" DeleteText="Apagar" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
