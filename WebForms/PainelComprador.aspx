<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="PainelComprador.aspx.vb" Inherits="SGE.PainelComprador" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Comprador</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0; }
        .painel { background-color: #ffffff; padding: 30px; border-radius: 12px; width: 95%; max-width: 1300px; margin: 40px auto; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h2, h3 { text-align: center; color: #333; }
        .topo { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .info-usuario { font-size: 16px; }
        .erro { color: red; font-weight: bold; margin-bottom: 10px; display: block; }
        .btn-sair { background-color: #d9534f; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; }
        .btn-sair:hover { background-color: #c9302c; }
        .btn-action { background-color: #0275d8; color: white; border: none; border-radius: 6px; padding: 8px 16px; margin: 0 5px 10px 0; cursor: pointer; font-size: 14px; }
        .btn-action:hover { background-color: #025aa5; }
        .btn-warning { background-color: #f0ad4e; color: white; border: none; border-radius: 6px; padding: 6px 12px; cursor: pointer; }
        .btn-warning:hover { background-color: #ec971f; }
        .grid { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid th, .grid td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        .grid th { background-color: #333; color: white; }
        .grid tr:nth-child(even) { background-color: #f9f9f9; }
        .status-Pendente { color: #d9534f; font-weight: bold; }
        .status-Conferido { color: #5bc0de; font-weight: bold; }
        .status-Finalizado { color: #5cb85c; font-weight: bold; }
        .status-Devolução { color: #f0ad4e; font-weight: bold; }
        .actions { text-align: center; margin-bottom: 20px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="painel">
            <!-- TOPO -->
            <div class="topo">
                <div class="info-usuario">
                    <asp:Label ID="lblUsuario" runat="server" Text="Usuário: "></asp:Label> |
                    <asp:Label ID="lblFuncao" runat="server" Text="Função: "></asp:Label>
                </div>
                <asp:Button ID="btnSair" runat="server" Text="Sair" CssClass="btn-sair" OnClick="btnSair_Click" />
            </div>

            <h3>Funções do Comprador</h3>
            <div class="actions">
                <a href="RealizarPedido.aspx"><button type="button" class="btn-action">Registrar Compra</button></a>
                <a href="CadastroProduto.aspx"><button type="button" class="btn-action">Produtos</button></a>
                <a href="CadastroFornecedor.aspx"><button type="button" class="btn-action">Fornecedores</button></a>
            </div>

            <hr />
            <h2>Meus Pedidos</h2>
            <asp:Label ID="lblErro" runat="server" CssClass="erro"></asp:Label>

            <!-- GRID DE PEDIDOS -->
            <asp:GridView ID="GridViewPedidos" runat="server" AutoGenerateColumns="False" CssClass="grid"
                OnRowDataBound="GridViewPedidos_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="idCompra" HeaderText="ID" />
                    <asp:BoundField DataField="dataCompra" HeaderText="Data" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                    <asp:BoundField DataField="nomeFornecedor" HeaderText="Fornecedor" />
                    <asp:BoundField DataField="quantidadeComprada" HeaderText="Quantidade" />
                    <asp:BoundField DataField="valorCompra" HeaderText="Valor (R$)" DataFormatString="{0:N2}" />

                    <asp:TemplateField HeaderText="Conferente">
                        <ItemTemplate>
                            <%# If(Eval("nomeConferente") IsNot Nothing AndAlso Eval("nomeConferente").ToString() <> "", Eval("nomeConferente"), "Não conferido") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="observacoes" HeaderText="Observações" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# "status-" & Eval("descricaoStatus").ToString().Replace(" ", "") %>'>
                                <%# Eval("descricaoStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button ID="btnDevolver" runat="server" Text="Devolver Pedido"
                                CommandArgument='<%# Eval("idCompra") %>'
                                OnClick="btnDevolver_Click"
                                CssClass="btn-warning"
                                Visible="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
