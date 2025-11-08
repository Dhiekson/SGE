<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MeusPedidos.aspx.vb" Inherits="SGE.MeusPedidos" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Meus Pedidos</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 32px;
        }

        .mensagem {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .mensagem.erro { color: #dc3545; }
        .mensagem.sucesso { color: #28a745; }

        .btn-voltar {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin-bottom: 30px;
        }
        .btn-voltar:hover { opacity: 0.9; }

        .gridview {
            width: 100%;
            border-collapse: collapse;
        }
        .gridview th, .gridview td {
            padding: 12px 10px;
            border-bottom: 1px solid #dee2e6;
            text-align: left;
        }
        .gridview th {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
        }
        .status-Pendente { color: #856404; background-color: #fff3cd; padding: 4px 8px; border-radius: 5px; font-weight: 600; display:inline-block; }
        .status-Conferido { color: #155724; background-color: #d4edda; padding: 4px 8px; border-radius: 5px; font-weight: 600; display:inline-block; }
        .status-Devolução { color: #721c24; background-color: #f8d7da; padding: 4px 8px; border-radius: 5px; font-weight: 600; display:inline-block; }
        .btn-desfazer {
            background-color: #dc3545;
            color: #fff;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-desfazer:hover { opacity: 0.85; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Meus Pedidos</h2>
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
            <asp:Button ID="btnVoltarComprador" runat="server" Text="Voltar ao Painel do Comprador" CssClass="btn-voltar" OnClick="btnVoltarComprador_Click" />

            <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" CssClass="gridview" OnRowCommand="gvPedidos_RowCommand">
                <Columns>
                    <asp:BoundField DataField="idCompra" HeaderText="ID Pedido" />
                    <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                    <asp:BoundField DataField="nomeFornecedor" HeaderText="Fornecedor" />
                    <asp:BoundField DataField="quantidadeComprada" HeaderText="Qtd" />
                    <asp:BoundField DataField="valorCompra" HeaderText="Valor Total" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="nomeConferente" HeaderText="Conferente" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# "status-" & Eval("descricaoStatus").ToString() %>'>
                                <%# Eval("descricaoStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ação">
                        <ItemTemplate>
                            <asp:Button ID="btnDesfazer" runat="server" Text="Desfazer" CommandName="Desfazer" CommandArgument='<%# Eval("idCompra") %>'
                                Visible='<%# Eval("descricaoStatus").ToString() = "Devolução" %>' CssClass="btn-desfazer" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
