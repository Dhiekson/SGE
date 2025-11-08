<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Estoque.aspx.vb" Inherits="SGE.Estoque" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Estoque - SGE</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f7fb; padding:20px; }
        h1 { color:#1976d2; margin:0; }
        .top { display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; gap:8px; flex-wrap:wrap; }
        .top input[type=text] { padding:6px 10px; border-radius:6px; border:1px solid #ccc; font-size:13px; }
        .top button { padding:6px 12px; border-radius:6px; border:none; background:#1976d2; color:#fff; cursor:pointer; }
        .top button:hover { background:#0f5cae; }

        .cards { display:grid; grid-template-columns: repeat(auto-fit, minmax(180px,1fr)); gap:12px; margin-bottom:20px; }
        .card { background:#fff; padding:15px; border-radius:8px; box-shadow:0 3px 8px rgba(0,0,0,0.1); text-align:center; cursor:pointer; }
        .card:hover { box-shadow:0 5px 12px rgba(0,0,0,0.2); }
        .card .title { font-size:13px; color:#666; margin-bottom:6px; }
        .card .value { font-size:18px; font-weight:700; color:#222; }

        table { width:100%; border-collapse:collapse; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 3px 6px rgba(0,0,0,0.1); margin-bottom:20px; }
        th, td { padding:10px; text-align:left; border-bottom:1px solid #eee; }
        th { background:#1976d2; color:#fff; }
        .right { text-align:right; }
        .low-stock td { font-weight:700; color:#856404; background:#fff3cd; }

        #panelLowStock { display:none; margin-top:10px; }

        @media(max-width:700px){ .top{flex-direction:column; align-items:flex-start;} }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top">
            <h1>Estoque Atual</h1>
            <div>
                <input type="text" id="txtBusca" placeholder="Buscar por nome ou código" onkeyup="filtrar()" />
                <button type="button" onclick="window.location.href='Dashboard.aspx'">
                    <i class="fa fa-arrow-left"></i> Voltar
                </button>
            </div>
        </div>

        <!-- Cards de resumo -->
        <div class="cards">
            <div class="card">
                <div class="title">Quantidade Total</div>
                <div class="value">
                    <asp:Literal ID="litTotalQuantidade" runat="server"></asp:Literal>
                </div>
            </div>
            <div class="card">
                <div class="title">Valor Total do Estoque</div>
                <div class="value">
                    <asp:Literal ID="litTotalValor" runat="server"></asp:Literal>
                </div>
            </div>
            <div class="card" onclick="toggleLowStock()">
                <div class="title">Produtos com Estoque Baixo (&lt;=5)</div>
                <div class="value">
                    <asp:Literal ID="litLowStockCount" runat="server"></asp:Literal>
                </div>
            </div>
        </div>

        <!-- Estoque completo -->
        <h2>Estoque Completo</h2>
        <asp:GridView ID="gvEstoque" runat="server" AutoGenerateColumns="False" EmptyDataText="Nenhum produto encontrado">
            <Columns>
                <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                <asp:BoundField DataField="codBarra" HeaderText="Código de Barras" />
                <asp:BoundField DataField="quantidadeRecebida" HeaderText="Quantidade Recebida" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="precoUnitario" HeaderText="Preço Unitário" DataFormatString="R$ {0:N2}" />
                <asp:BoundField DataField="valorTotal" HeaderText="Valor Total" DataFormatString="R$ {0:N2}" />
            </Columns>
        </asp:GridView>

        <!-- Painel produtos com estoque baixo -->
        <div id="panelLowStock">
            <h2>Produtos com Estoque Baixo</h2>
            <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="False" EmptyDataText="Nenhum produto com estoque baixo" CssClass="low-stock">
                <Columns>
                    <asp:BoundField DataField="nomeProduto" HeaderText="Produto" />
                    <asp:BoundField DataField="codBarra" HeaderText="Código de Barras" />
                    <asp:BoundField DataField="quantidadeRecebida" HeaderText="Quantidade" DataFormatString="{0:N0}" />
                </Columns>
            </asp:GridView>
        </div>
    </form>

    <script type="text/javascript">
        function filtrar() {
            var filtro = document.getElementById('txtBusca').value.toLowerCase();
            var table = document.getElementById('<%= gvEstoque.ClientID %>');
            for (var i = 1; i < table.rows.length; i++) {
                var nome = table.rows[i].cells[0].innerText.toLowerCase();
                var codigo = table.rows[i].cells[1].innerText.toLowerCase();
                table.rows[i].style.display = (nome.includes(filtro) || codigo.includes(filtro)) ? '' : 'none';
            }
        }

        function toggleLowStock() {
            var panel = document.getElementById('panelLowStock');
            panel.style.display = (panel.style.display === 'none' || panel.style.display === '') ? 'block' : 'none';
        }
    </script>
</body>
</html>
