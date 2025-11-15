<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Estoque.aspx.vb" Inherits="SGE.Estoque" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Estoque - SGE</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        
        body {
            font-family: 'Inter','Segoe UI',Arial,sans-serif;
            background: linear-gradient(135deg,#f5f7fa,#e6eefb);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* HEADER ESCURO FIXO */
        .header {
            background: #1f2937;
            color: #fff;
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header h1 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .header button {
            background: linear-gradient(135deg,#2563eb,#1d4ed8);
            color: #fff;
            border: none;
            padding: 8px 14px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .header button:hover {
            opacity: 0.95;
        }

        /* CONTAINER CENTRAL */
        .container {
            max-width: 1200px;
            margin: 28px auto;
            padding: 0 20px 40px 20px;
        }

        /* CAMPO DE BUSCA */
        .search-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 22px;
        }

        .search-bar input {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            width: 260px;
            transition: border 0.2s;
        }

        .search-bar input:focus {
            border-color: #2563eb;
            outline: none;
        }

        /* CARDS KPI */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 18px;
            margin-bottom: 28px;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 6px 18px rgba(17,24,39,0.06);
            text-align: center;
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card .title {
            color: #6b7280;
            font-size: 13px;
        }

        .card .value {
            font-size: 20px;
            font-weight: 700;
            margin-top: 6px;
            color: #111827;
        }

        /* TÍTULOS DE SEÇÃO */
        h2 {
            color: #111827;
            font-size: 18px;
            font-weight: 600;
            margin: 25px 0 14px;
        }

        /* TABELA */
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 6px 18px rgba(17,24,39,0.06);
            font-size: 14px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f1f1f1;
        }

        th {
            background: #2563eb;
            color: #fff;
            font-weight: 600;
            letter-spacing: 0.2px;
        }

        tr:hover td {
            background: #f9fbff;
        }

        .low-stock td {
            background: #fff3cd !important;
            color: #856404 !important;
            font-weight: 600;
        }

        #panelLowStock {
            display: none;
            margin-top: 28px;
        }

        footer {
            text-align: center;
            color: #383838;
            font-size: 14px;
            padding: 15px 0;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- HEADER -->
        <div class="header">
            <h1>📦 Estoque — SGE</h1>
            <button type="button" onclick="window.location.href='Dashboard.aspx'">
                <i class="fa fa-arrow-left"></i> Voltar
            </button>
        </div>

        <!-- CONTEÚDO -->
        <div class="container">
            <div class="search-bar">
                <input type="text" id="txtBusca" placeholder="Buscar por nome ou código..." onkeyup="filtrar()" />
            </div>

            <!-- CARDS -->
            <div class="cards">
                <div class="card">
                    <div class="title">Quantidade Total</div>
                    <div class="value"><asp:Literal ID="litTotalQuantidade" runat="server"></asp:Literal></div>
                </div>
                <div class="card">
                    <div class="title">Valor Total do Estoque</div>
                    <div class="value"><asp:Literal ID="litTotalValor" runat="server"></asp:Literal></div>
                </div>
                <div class="card" style="cursor:pointer;" onclick="toggleLowStock()">
                    <div class="title">Produtos com Estoque Baixo (≤ 5)</div>
                    <div class="value"><asp:Literal ID="litLowStockCount" runat="server"></asp:Literal></div>
                </div>
            </div>

            <!-- TABELA PRINCIPAL -->
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

            <!-- ESTOQUE BAIXO -->
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
        </div>

        <footer>© <%: DateTime.Now.Year %> Sistema de Gestão de Estoque — Todos os direitos reservados.</footer>
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
