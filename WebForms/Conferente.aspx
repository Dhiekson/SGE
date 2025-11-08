<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Conferente.aspx.vb"
    Inherits="SGE.Conferente" EnableEventValidation="false" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Conferente</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #eef2f7;
            padding: 20px;
        }
        h2 { text-align: center; color: #333; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th { background: #007bff; color: #fff; }
        .btn {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: #fff;
        }
        .btn-conferir { background: #28a745; }
        .btn-voltar { background: #007bff; margin-bottom: 20px; }
        .mensagem { text-align: center; margin-bottom: 15px; }
        .mensagem.erro { color: red; }
        .mensagem.sucesso { color: green; }
        #painelConferencia { display: none; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); width: 400px; margin: 20px auto; }
        #painelConferencia input, #painelConferencia textarea, #painelConferencia select { width: 100%; padding: 8px; margin-bottom: 10px; }
        #painelConferencia .btn { width: 48%; margin-right: 2%; }
    </style>
    <script type="text/javascript">
        function abrirPainel(idPedido) {
            document.getElementById('hfIdPedido').value = idPedido;
            document.getElementById('painelConferencia').style.display = 'block';
        }
        function fecharPainel() {
            document.getElementById('painelConferencia').style.display = 'none';
        }
        function atualizarGridEAposSalvar() {
            document.getElementById('painelConferencia').style.display = 'none';
            __doPostBack('<%= gvPedidos.UniqueID %>', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
        <asp:Button ID="btnVoltar" runat="server" Text="Voltar ao Painel" CssClass="btn btn-voltar" OnClick="btnVoltar_Click" />

        <asp:UpdatePanel ID="UpdatePanelPedidos" runat="server">
            <ContentTemplate>
                <h2>Pedidos para Conferência</h2>
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="idCompra" />
                        <asp:BoundField HeaderText="Produto" DataField="nomeProduto" />
                        <asp:BoundField HeaderText="Fornecedor" DataField="nomeFornecedor" />
                        <asp:BoundField HeaderText="Comprador" DataField="Comprador" />
                        <asp:BoundField HeaderText="Quantidade" DataField="quantidadeComprada" />
                        <asp:BoundField HeaderText="Quantidade Recebida" DataField="quantidadeRecebida" />
                        <asp:BoundField HeaderText="Valor" DataField="valorCompra" DataFormatString="{0:C}" />
                        <asp:BoundField HeaderText="Status" DataField="descricaoStatus" />
                        <asp:TemplateField HeaderText="Ação">
                            <ItemTemplate>
                                <asp:Button ID="btnConferir" runat="server" Text="Conferir" CssClass="btn btn-conferir"
                                    OnClientClick='<%# "abrirPainel(" & Eval("idCompra") & "); return false;" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <!-- Atualização automática -->
                <asp:Timer ID="TimerPedidos" runat="server" Interval="5000" OnTick="TimerPedidos_Tick" />
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Painel de Conferência -->
        <div id="painelConferencia" runat="server">
            <h3>Conferir Pedido</h3>
            <asp:HiddenField ID="hfIdPedido" runat="server" />

            <label>Quantidade Recebida:</label>
            <asp:TextBox ID="txtQuantidadeRecebida" runat="server" />

            <label>Observações:</label>
            <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine" Rows="3" />

            <label>Status:</label>
            <asp:DropDownList ID="ddlStatusConferencia" runat="server">
                <asp:ListItem Text="Conferido" Value="2"></asp:ListItem>
                <asp:ListItem Text="Devolução" Value="3"></asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnSalvarConferencia" runat="server" Text="Salvar" CssClass="btn btn-conferir" OnClick="btnSalvarConferencia_Click" />
            <input type="button" value="Cancelar" class="btn btn-voltar" onclick="fecharPainel();" />
        </div>
    </form>
</body>
</html>
