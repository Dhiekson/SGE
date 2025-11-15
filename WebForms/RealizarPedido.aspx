<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RealizarPedido.aspx.vb" Inherits="SGE.WebForms_RealizarPedido" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Realizar Pedido — SGE</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js"></script>

    <style>
        /* === BASE PADRÃO DOS PAINÉIS === */
        body {
            font-family: 'Segoe UI', 'Inter', sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* === HEADER === */
        .header {
            background-color: #1a237e;
            color: #fff;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .header h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }

        /* === CONTAINER === */
        .container {
            max-width: 950px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 18px rgba(0,0,0,0.12);
            padding: 35px 45px;
        }

        h2, h3 {
            text-align: center;
            color: #111827;
            margin-bottom: 20px;
        }

        /* === CAMPOS DO FORM === */
        .form-table {
            width: 100%;
            border-spacing: 0 10px;
        }
        .form-table td {
            padding: 8px;
            vertical-align: middle;
        }
        select, input[type="text"] {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        select:focus, input[type="text"]:focus {
            border-color: #1a237e;
            outline: none;
            box-shadow: 0 0 6px rgba(26,35,126,0.3);
        }

        #lblValorTotal {
            display: block;
            margin-top: 6px;
            font-weight: 600;
            color: #1a237e;
        }

        /* === BOTÕES === */
        .btn-container {
            text-align: center;
            margin-top: 25px;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.2s;
            font-size: 14px;
            color: #fff;
        }
        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .btn-primary { background: linear-gradient(90deg, #4CAF50, #2E7D32); }
        .btn-warning { background: linear-gradient(90deg, #ff9800, #e68900); color: #fff; }
        .btn-danger { background: linear-gradient(90deg, #f44336, #d32f2f); }
        .btn-voltar { background: linear-gradient(90deg, #607D8B, #455A64); }

        /* === GRIDVIEW === */
        .grid-container {
            margin-top: 30px;
            overflow-x: auto;
        }

        .grid-container table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .grid-container th, .grid-container td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .grid-container th {
            background-color: #1a237e;
            color: white;
            font-weight: 600;
        }

        .btn-grid {
            padding: 6px 12px;
            border-radius: 6px;
            color: white;
            font-weight: 600;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .btn-editar {
            background: linear-gradient(90deg, #ffb300, #f57c00);
        }

        .btn-excluir {
            background: linear-gradient(90deg, #e53935, #b71c1c);
        }

        /* === MENSAGEM === */
        .mensagem {
            text-align: center;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .sucesso { color: #4CAF50; }
        .erro { color: #f44336; }

        /* === FOOTER === */
        footer {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin: 40px 0 15px;
        }
    </style>

    <script>
        $(document).ready(function () {
            $(".chosen-select").chosen({ no_results_text: "Nenhum resultado encontrado:", width: "100%" });

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
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>🛒 Realizar Pedido</h1>
            <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar ao Painel" CssClass="btn btn-voltar" OnClick="btnVoltar_Click" />
        </div>

        <div class="container">
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <table class="form-table">
                <tr>
                    <td>Fornecedor:</td>
                    <td colspan="2"><asp:DropDownList ID="ddlFornecedor" runat="server" CssClass="form-control chosen-select"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlFornecedor_SelectedIndexChanged"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Categoria:</td>
                    <td colspan="2"><asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control chosen-select"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlCategoria_SelectedIndexChanged"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Produto:</td>
                    <td colspan="2"><asp:DropDownList ID="ddlProduto" runat="server" CssClass="form-control chosen-select"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlProduto_SelectedIndexChanged"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Quantidade:</td>
                    <td colspan="2"><asp:TextBox ID="txtQuantidade" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Valor Unitário:</td>
                    <td colspan="2">
                        <asp:TextBox ID="txtValorUnitario" runat="server" ReadOnly="True"></asp:TextBox>
                        <asp:Label ID="lblValorTotal" runat="server" Text="Valor Total: R$ 0,00"></asp:Label>
                    </td>
                </tr>
            </table>

            <div class="btn-container">
                <asp:Button ID="btnSalvarPedido" runat="server" Text="Salvar Pedido" CssClass="btn btn-primary" OnClick="btnSalvarPedido_Click" />
                <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar Pedido" CssClass="btn btn-warning" OnClick="btnAtualizar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-danger" OnClick="btnCancelar_Click" />
            </div>

            <h3>📋 Lista de Pedidos</h3>
            <div class="grid-container">
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" DataKeyNames="idCompra, idStatus"
                    OnSelectedIndexChanged="gvPedidos_SelectedIndexChanged" OnRowDeleting="gvPedidos_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="idCompra" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="nomeFornecedor" HeaderText="Fornecedor" />
                        <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                        <asp:BoundField DataField="quantidadeComprada" HeaderText="Qtd Solicitada" />
                        <asp:BoundField DataField="quantidadeRecebida" HeaderText="Qtd Recebida" />
                        <asp:BoundField DataField="valorAtualizado" HeaderText="Valor Atualizado" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Ações">
                            <ItemTemplate>
                                <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="btn-grid btn-editar" CommandName="Select" />
                                <asp:Button ID="btnExcluir" runat="server" Text="Excluir" CssClass="btn-grid btn-excluir" CommandName="Delete"
                                    OnClientClick="return confirm('Tem certeza que deseja excluir este pedido?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <footer>
            © <%: DateTime.Now.Year %> SGE — Sistema de Gestão de Estoque.
        </footer>
    </form>
</body>
</html>
