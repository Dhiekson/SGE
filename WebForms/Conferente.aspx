<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Conferente.aspx.vb"
    Inherits="SGE.Conferente" EnableEventValidation="false" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Conferente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6fb;
            margin: 0; padding: 20px;
        }
        h2 {
            color: #1f4e79;
            text-align: center;
            margin-bottom: 15px;
        }

        /* Botões */
        .btn {
            border: none;
            border-radius: 6px;
            padding: 8px 14px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.2s;
        }
        .btn:hover { opacity: 0.9; }
        .btn-conferir { background: #28a745; color: #fff; }
        .btn-voltar { background: #007bff; color: #fff; margin-bottom: 15px; }

        /* Mensagens */
        .mensagem { text-align: center; margin: 10px 0; font-weight: 600; }
        .erro { color: #d9534f; }
        .sucesso { color: #28a745; }

        /* Grid */
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background: #1f4e79;
            color: #fff;
        }
        tr:nth-child(even) { background: #f8f9fc; }

        /* Modal */
        #painelConferencia {
            display: none;
            position: fixed;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            width: 400px;
            z-index: 1000;
        }
        #painelConferencia label {
            font-weight: 600;
            color: #444;
        }
        #painelConferencia input, #painelConferencia select, #painelConferencia textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        #overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
    </style>

    <script type="text/javascript">
        function abrirPainel(idPedido) {
            document.getElementById('hfIdPedido').value = idPedido;
            document.getElementById('painelConferencia').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }
        function fecharPainel() {
            document.getElementById('painelConferencia').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }

        function validarConferencia() {
            var status = document.getElementById('<%= ddlStatusConferencia.ClientID %>').value;
            var obs = document.getElementById('<%= txtObservacoes.ClientID %>').value.trim();

            if (status == "3" && obs === "") {
                alert("Para o status 'Devolução', é obrigatório informar uma observação.");
                return false;
            }
            return true;
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>
        <asp:Button ID="btnVoltar" runat="server" Text="← Voltar ao Painel" CssClass="btn btn-voltar" OnClick="btnVoltar_Click" />

        <h2>📦 Pedidos para Conferência</h2>

        <asp:UpdatePanel ID="UpdatePanelPedidos" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="idCompra" />
                        <asp:BoundField HeaderText="Produto" DataField="nomeProduto" />
                        <asp:BoundField HeaderText="Fornecedor" DataField="nomeFornecedor" />
                        <asp:BoundField HeaderText="Comprador" DataField="Comprador" />
                        <asp:BoundField HeaderText="Qtd Solicitada" DataField="quantidadeComprada" />
                        <asp:BoundField HeaderText="Qtd Recebida" DataField="quantidadeRecebida" />
                        <asp:BoundField HeaderText="Valor" DataField="valorCompra" DataFormatString="R$ {0:N2}" />
                        <asp:BoundField HeaderText="Status" DataField="descricaoStatus" />
                        <asp:TemplateField HeaderText="Ação">
                            <ItemTemplate>
                                <asp:Button ID="btnConferir" runat="server" Text="Conferir"
                                    CssClass="btn btn-conferir"
                                    OnClientClick='<%# "abrirPainel(" & Eval("idCompra") & "); return false;" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Timer ID="TimerPedidos" runat="server" Interval="10000" OnTick="TimerPedidos_Tick" />
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Overlay escuro -->
        <div id="overlay" onclick="fecharPainel()"></div>

        <!-- Modal de Conferência -->
        <div id="painelConferencia">
            <h3 style="text-align:center;">Conferir Pedido</h3>
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

            <div style="text-align:center;">
                <asp:Button ID="btnSalvarConferencia" runat="server"
                    Text="Salvar" CssClass="btn btn-conferir"
                    OnClientClick="return validarConferencia();"
                    OnClick="btnSalvarConferencia_Click" />
                <input type="button" value="Cancelar" class="btn btn-voltar" onclick="fecharPainel();" />
            </div>
        </div>
    </form>
</body>
</html>
