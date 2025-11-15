<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="PainelComprador.aspx.vb" Inherits="SGE.PainelComprador" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Comprador</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ====== TOPO ====== */
        .header {
            background-color: #1a237e;
            color: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .header .usuario-info {
            font-size: 16px;
            font-weight: 500;
        }

        .btn-logout {
            background: linear-gradient(90deg, #f44336, #d32f2f);
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 3px 8px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            transform: scale(1.05);
        }

        /* ====== CONTAINER ====== */
        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            padding: 30px 40px;
            text-align: center;
        }

        h2, h3 {
            color: #333;
            margin-bottom: 20px;
        }

        h2 {
            font-size: 24px;
            font-weight: 600;
        }

        h3 {
            font-size: 20px;
            color: #444;
        }

        /* ====== BOTÕES ====== */
        .actions {
            margin-bottom: 25px;
        }

        .btn {
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            margin: 8px;
            cursor: pointer;
            font-weight: 600;
            color: #fff;
            transition: transform 0.2s ease-in-out;
            box-shadow: 0 3px 8px rgba(0,0,0,0.15);
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .btn-primary {
            background: linear-gradient(90deg, #2196F3, #1976D2);
        }

        .btn-warning {
            background: linear-gradient(90deg, #ff9800, #e68900);
        }

        .btn-success {
            background: linear-gradient(90deg, #4CAF50, #2E7D32);
        }

        /* ====== GRID ====== */
        .grid {
            width: 100%;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-top: 15px;
        }

        .grid th {
            background-color: #1a237e;
            color: white;
            padding: 10px;
            text-transform: uppercase;
        }

        .grid td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .grid tr:nth-child(even) {
            background-color: #f7f9fc;
        }

        .grid tr:hover {
            background-color: #eef2ff;
        }

        /* ====== STATUS ====== */
        .status-Pendente { color: #e53935; font-weight: bold; }
        .status-Conferido { color: #2196F3; font-weight: bold; }
        .status-Devolução { color: #ff9800; font-weight: bold; }

        .erro {
            color: #f44336;
            font-weight: bold;
        }

        /* ====== FOOTER ====== */
        footer {
            text-align: center;
            margin: 30px 0 15px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- HEADER -->
        <div class="header">
            <div class="usuario-info">
                <asp:Label ID="lblUsuario" runat="server"></asp:Label> — 
                <asp:Label ID="lblFuncao" runat="server"></asp:Label>
                <asp:Label ID="lblMensagem" runat="server" CssClass="erro"></asp:Label>
            </div>
            <asp:Button ID="btnSair" runat="server" Text="Sair" CssClass="btn-logout" OnClick="btnSair_Click" />
        </div>

        <!-- CONTEÚDO -->
        <div class="container">
            <h2>Bem-vindo ao Painel do Comprador</h2>
            <h3>Funções do Comprador</h3>

            <div class="actions">
                <a href="RealizarPedido.aspx"><button type="button" class="btn btn-success">Registrar Compra</button></a>
                <a href="CadastroProduto.aspx"><button type="button" class="btn btn-primary">Produtos</button></a>
                <a href="CadastroFornecedor.aspx"><button type="button" class="btn btn-warning">Fornecedores</button></a>
            </div>

            <hr />

            <h2>Meus Pedidos</h2>
            <asp:Label ID="lblErro" runat="server" CssClass="erro"></asp:Label>

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
                                CssClass="btn btn-warning"
                                Visible="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <footer>
            © <%: DateTime.Now.Year %> SGE - Sistema de Gestão de Estoque — Comprador
        </footer>
    </form>
</body>
</html>
