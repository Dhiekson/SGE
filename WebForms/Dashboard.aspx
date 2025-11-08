<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="SGE.Dashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard - SGE (Tempo Real)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; background:#f4f7fb; margin:0; padding:18px; }
        .container { max-width:1200px; margin:0 auto; }
        .top { display:flex; justify-content:space-between; align-items:center; gap:8px; flex-wrap:wrap; margin-bottom:12px;}
        h1 { margin:0; font-size:20px; color:#222; }
        .controls { display:flex; gap:8px; align-items:center; }
        select, button { padding:6px 10px; border-radius:6px; border:1px solid #ccc; font-size:13px; }
        .cards { display:grid; grid-template-columns: repeat(auto-fit, minmax(160px,1fr)); gap:10px; margin-bottom:12px; }
        .card { background:#fff; padding:10px; border-radius:8px; box-shadow:0 3px 8px rgba(0,0,0,0.06); }
        .card .title { font-size:12px; color:#666; }
        .card .value { font-size:16px; font-weight:700; margin-top:6px; color:#111; }
        .grid { display:grid; grid-template-columns: 1fr 1fr; gap:10px; }
        .chart-card { background:#fff; padding:10px; border-radius:8px; box-shadow:0 3px 8px rgba(0,0,0,0.06); min-height:180px; }
        .small-table { width:100%; border-collapse:collapse; margin-top:8px; font-size:13px; }
        .small-table th, .small-table td { padding:6px 8px; border-bottom:1px solid #eee; text-align:left; }
        .right { text-align:right; }
        .muted { color:#666; font-size:12px; }
        @media(max-width:900px) { .grid { grid-template-columns: 1fr; } .cards { grid-template-columns: 1fr 1fr; } }
        .chart-container { width: 100%; max-width: 350px; height: 180px; margin: 0 auto; }
        .chart-card h4 { font-size: 14px; margin-bottom: 6px; color: #333; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
        <div class="container">
            <div class="top">
                <h1>Dashboard — SGE (Tempo Real)</h1>
                <div class="controls">
                    <select id="ddlPeriodo" onchange="fetchAndRender()">
                        <option value="30">Últimos 30 dias</option>
                        <option value="60">Últimos 60 dias</option>
                        <option value="90">Últimos 90 dias</option>
                    </select>
                    <asp:DropDownList ID="ddlComprador" runat="server" AutoPostBack="false"></asp:DropDownList>
                    <button type="button" onclick="abrirEstoque()">Ver Estoque</button>
                    <span class="muted" id="lblAtualizado">—</span>
                </div>
            </div>

            <!-- KPIs -->
            <div class="cards">
                <div class="card"><div class="title">Total de Pedidos</div><div class="value" id="kpiTotalPedidos">0</div></div>
                <div class="card"><div class="title">Pedidos Pendentes</div><div class="value" id="kpiPendentes">0</div></div>
                <div class="card"><div class="title">Pedidos Conferidos</div><div class="value" id="kpiConferidos">0</div></div>
                <div class="card"><div class="title">Valor Total (sem pendentes)</div><div class="value" id="kpiValorTotal">R$ 0,00</div></div>
                <div class="card"><div class="title">Maior Compra (sem pendentes)</div><div class="value" id="kpiMaiorCompra">R$ 0,00</div></div>
            </div>

            <!-- GRÁFICOS -->
            <div class="grid">
                <div class="chart-card">
                    <h4>📈 Volume de Compras (por dia)</h4>
                    <div class="chart-container"><canvas id="chartEvolucao"></canvas></div>
                </div>

                <div class="chart-card">
                    <h4>🏭 Desempenho de Fornecedores</h4>
                    <div class="chart-container"><canvas id="chartFornecedores"></canvas></div>
                </div>

                <div class="chart-card">
                    <h4>🗂️ Compras por Categoria</h4>
                    <div class="chart-container"><canvas id="chartCategorias"></canvas></div>
                </div>

                <div class="chart-card">
                    <h4>👥 Ranking de Compradores</h4>
                    <div class="chart-container"><canvas id="chartCompradores"></canvas></div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        var charts = {};
        var lastTotalPedidos = -1; // para atualizar apenas se mudou

        function initCharts() {
            function newChart(id, type, opts) {
                var ctx = document.getElementById(id).getContext('2d');
                return new Chart(ctx, Object.assign({
                    type: type,
                    data: { labels: [], datasets: [] },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom', labels: { boxWidth: 12}}} }
                }, opts || {}));
            }
            charts.evolucao = newChart('chartEvolucao', 'line', { options: { elements: { point: { radius: 2}}} });
            charts.fornecedores = newChart('chartFornecedores', 'bar', { options: { indexAxis: 'y'} });
            charts.categorias = newChart('chartCategorias', 'pie');
            charts.compradores = newChart('chartCompradores', 'bar', { options: { indexAxis: 'y'} });
        }

        function renderKPIs(kpi) {
            $('#kpiTotalPedidos').text(kpi.totalPedidos);
            $('#kpiPendentes').text(kpi.pendentes);
            $('#kpiConferidos').text(kpi.conferidos);
            $('#kpiValorTotal').text(kpi.valorTotalStr);
            $('#kpiMaiorCompra').text(kpi.maiorCompraStr);
            $('#lblAtualizado').text('Atualizado: ' + kpi.atualizadoEm);
        }

        function renderChart(chartObj, labels, datasets) {
            chartObj.data.labels = labels;
            chartObj.data.datasets = datasets;
            chartObj.update();
        }

        function fetchAndRender() {
            var periodo = parseInt($('#ddlPeriodo').val());
            var comprador = $('#<%= ddlComprador.ClientID %>').val() || 0;
            PageMethods.GetDashboardData(periodo, parseInt(comprador), function (result) {
                if (result.kpi.totalPedidos !== lastTotalPedidos) {
                    lastTotalPedidos = result.kpi.totalPedidos;
                    renderKPIs(result.kpi);
                    renderChart(charts.evolucao, result.evolucao.labels, [{ label: 'Pedidos', data: result.evolucao.data, fill: true, borderColor: '#2e7d32', backgroundColor: 'rgba(46,125,50,0.08)'}]);
                    renderChart(charts.fornecedores, result.fornecedores.labels, [{ label: 'Valor (R$)', data: result.fornecedores.data}]);
                    renderChart(charts.categorias, result.categorias.labels, [{ label: 'Valor', data: result.categorias.data}]);
                    renderChart(charts.compradores, result.compradores.labels, [{ label: 'Valor (R$)', data: result.compradores.data}]);
                }
            }, function (err) { console.error(err); });
        }

        function abrirEstoque() { window.location.href = 'Estoque.aspx'; }

        $(function () {
            initCharts();
            fetchAndRender();
            setInterval(fetchAndRender, 1000);
        });

    </script>
</body>
</html>
