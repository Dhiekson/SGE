<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MeusPedidos.aspx.vb" Inherits="SGE.MeusPedidos" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Meus Pedidos</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background:#f5f7fa; margin:0; padding:20px;}
        .container { max-width:1200px; margin:0 auto; }
        h2 { text-align:center; color:#333; margin-bottom:20px; font-size:28px;}
        .mensagem { text-align:center; margin-bottom:16px; font-weight:600; }
        .mensagem.erro { color:#c0392b; }
        .mensagem.sucesso { color:#27ae60; }
        .btn-voltar, .btn-refresh { background:#1976d2; color:#fff; border:0; padding:8px 12px; border-radius:6px; cursor:pointer; margin-right:8px;}
        .btn-refresh { background:#28a745; }
        .gridview { width:100%; border-collapse:collapse; margin-top:12px; box-shadow:0 2px 6px rgba(0,0,0,0.06); background:#fff; }
        .gridview th { background:#1976d2; color:#fff; padding:10px; text-align:left; }
        .gridview td { padding:10px; border-bottom:1px solid #eee; }
        .status-Pendente { color:#856404; background:#fff3cd; padding:4px 8px; border-radius:6px; font-weight:700; }
        .status-Conferido { color:#155724; background:#d4edda; padding:4px 8px; border-radius:6px; font-weight:700; }
        .status-Devolução { color:#721c24; background:#f8d7da; padding:4px 8px; border-radius:6px; font-weight:700; }
        .btn-desfazer { background:#dc3545; color:#fff; border:0; padding:6px 10px; border-radius:6px; cursor:pointer; }
        .meta { font-size:13px; color:#666; margin-top:8px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Meus Pedidos</h2>

            <div style="text-align:center; margin-bottom:12px;">
                <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
            </div>

            <div style="text-align:right; margin-bottom:8px;">
                <asp:Button ID="btnVoltarComprador" runat="server" Text="Voltar ao Painel do Comprador" CssClass="btn-voltar" OnClick="btnVoltarComprador_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Atualizar" CssClass="btn-refresh" OnClick="btnRefresh_Click" />
            </div>

            <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" CssClass="gridview" OnRowCommand="gvPedidos_RowCommand">
                <Columns>
                    <asp:BoundField DataField="idCompra" HeaderText="ID Pedido" />
                    <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                    <asp:BoundField DataField="nomeFornecedor" HeaderText="Fornecedor" />
                    <asp:BoundField DataField="quantidadeComprada" HeaderText="Qtd Solicitada" DataFormatString="{0:N0}" />
                    <asp:BoundField DataField="quantidadeRecebida" HeaderText="Qtd Recebida" DataFormatString="{0:N0}" />
                    <asp:BoundField DataField="valorAtualizado" HeaderText="Valor Atualizado" DataFormatString="{0:C}" />
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

            <div class="meta">
                Obs: A "Qtd Recebida" mostra a quantidade atual — se o conferente registrou menos/mais, esse valor aparece aqui. O "Valor Atualizado" reflete o valor recalculado.
            </div>
        </div>
    </form>
</body>
</html>
