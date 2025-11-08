<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RealizarPedido.aspx.vb" 
    Inherits="SGE.WebForms_RealizarPedido" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Realizar Pedido</title>

    <style>
        body {
            font-family: Arial;
            background-color: #f9f9f9;
        }
        .container {
            width: 80%;
            margin: 30px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 2px 5px #ccc;
        }
        h2 { text-align: center; color: #444; }
        .form-table td { padding: 8px; }
        .btn-container { text-align: center; margin-top: 20px; }
        .btn {
            padding: 10px 20px;
            border: none;
            background: #007bff;
            color: #fff;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-warning { background-color: #ff9800; }
        .btn-danger { background-color: #f44336; }
        .btn-voltar { background-color: #607D8B; }
        .mensagem { text-align: center; margin: 10px; font-weight: bold; }
        .sucesso { color: green; }
        .erro { color: red; }
        .grid-container { margin-top: 30px; }
        .grid-container table { width: 100%; border-collapse: collapse; }
        .grid-container th, .grid-container td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .grid-container th { background-color: #007bff; color: white; }
        select, input[type="text"] {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        #lblValorTotal {
            display: block;
            text-align: left;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js"></script>

    <script>
        $(document).ready(function () {
            $(".chosen-select").chosen({ no_results_text: "Nenhum resultado encontrado:", width: "100%" });

            // Cálculo em tempo real
            $("#<%= txtQuantidade.ClientID %>, #<%= txtValorUnitario.ClientID %>").on("input", function () {
                calcularValorTotal();
            });
        });

        function calcularValorTotal() {
            var qtd = parseFloat($("#<%= txtQuantidade.ClientID %>").val()) || 0;
            var valor = parseFloat($("#<%= txtValorUnitario.ClientID %>").val()) || 0;
            var total = qtd * valor;
            $("#<%= lblValorTotal.ClientID %>").text("Valor Total: R$ " + total.toFixed(2));
        }

        function mostrarMensagemTemp(msg, classe) {
            var label = $("#<%= lblMensagem.ClientID %>");
            label.removeClass().addClass("mensagem " + classe).text(msg);
            setTimeout(function () { label.text(""); }, 4000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Realizar Pedido</h2>
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <table class="form-table">
                <tr>
                    <td>Fornecedor:</td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlFornecedor" runat="server" CssClass="form-control chosen-select"
    AutoPostBack="True" OnSelectedIndexChanged="ddlFornecedor_SelectedIndexChanged">
</asp:DropDownList>
  </td>
                </tr>
                <tr>
                    <td>Categoria:</td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control chosen-select"
    AutoPostBack="True" OnSelectedIndexChanged="ddlCategoria_SelectedIndexChanged">
</asp:DropDownList>
 </td>
                </tr>
                <tr>
                    <td>Produto:</td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlProduto" runat="server" CssClass="form-control chosen-select" AutoPostBack="True" OnSelectedIndexChanged="ddlProduto_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Quantidade:</td>
                    <td colspan="2">
                        <asp:TextBox ID="txtQuantidade" runat="server" CssClass="form-control"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Valor Unitário:</td>
                    <td colspan="2">
                        <asp:TextBox ID="txtValorUnitario" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>
                        <asp:Label ID="lblValorTotal" runat="server" Text="Valor Total: R$ 0,00"></asp:Label>
                    </td>
                </tr>
            </table>

            <div class="btn-container">
                <asp:Button ID="btnSalvarPedido" runat="server" Text="Salvar Pedido" 
                    CssClass="btn" OnClick="btnSalvarPedido_Click" />
                <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar Pedido" CssClass="btn btn-warning" OnClick="btnAtualizar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" 
                    CssClass="btn btn-voltar" OnClick="btnCancelar_Click" />
                <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar" OnClick="btnVoltar_Click" />
            </div>

            <h3>Lista de Pedidos</h3>
            <div class="grid-container">
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" DataKeyNames="idCompra, idStatus"
                    OnSelectedIndexChanged="gvPedidos_SelectedIndexChanged" OnRowDeleting="gvPedidos_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="idCompra" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="nomeFornecedor" HeaderText="Fornecedor" />
                        <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                        <asp:BoundField DataField="quantidadeComprada" HeaderText="Quantidade" />
                        <asp:BoundField DataField="valorCompra" HeaderText="Valor Total" DataFormatString="{0:C}" />
                        <asp:CommandField ShowSelectButton="True" SelectText="Editar" />
                        <asp:CommandField ShowDeleteButton="True" DeleteText="Excluir" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
