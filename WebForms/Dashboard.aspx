<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="SGE.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard - SGE</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        /* Mantém o mesmo layout e cores */
        body
        {
            font-family: 'Inter' , 'Segoe UI' ,Arial,sans-serif;
            background: linear-gradient(135deg,#f5f7fa,#e6eefb);
            margin: 0;
            padding: 0;
            color: #333;
        }
        
        .header
        {
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
        
        .header h1
        {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }
        .header .controls
        {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .header select, .header button, .header .aspNetDropDown
        {
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: #fff;
            color: #111;
            font-size: 13px;
        }
        
        .header button
        {
            background: linear-gradient(135deg,#2563eb,#1d4ed8);
            color: #fff;
            border: none;
            font-weight: 600;
            cursor: pointer;
            border-radius: 8px;
        }
        
        .header button:hover
        {
            opacity: 0.95;
        }
        
        .container
        {
            max-width: 1200px;
            margin: 28px auto;
            padding: 0 20px 40px 20px;
        }
        
        .cards
        {
            display: grid;
            grid-template-columns: repeat(auto-fit,minmax(200px,1fr));
            gap: 18px;
            margin-bottom: 24px;
        }
        
        .card
        {
            background: #fff;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 6px 18px rgba(17,24,39,0.06);
            text-align: center;
        }
        
        .card .title
        {
            color: #6b7280;
            font-size: 13px;
        }
        .card .value
        {
            font-size: 20px;
            font-weight: 700;
            margin-top: 8px;
            color: #111827;
        }
        
        .grid
        {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }
        
        .chart-card
        {
            background: #fff;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 6px 18px rgba(17,24,39,0.06);
            min-height: 260px;
            display: flex;
            flex-direction: column;
        }
        
        .chart-card h4
        {
            font-size: 15px;
            margin: 0 0 12px 0;
            color: #111827;
            font-weight: 600;
        }
        
        .chart-container
        {
            width: 100%;
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 180px;
        }
        
        .chart-container canvas
        {
            max-width: 360px;
            max-height: 360px;
            width: 100% !important;
            height: auto !important;
        }
        
        @media (max-width: 900px)
        {
            .grid
            {
                grid-template-columns: 1fr;
            }
        }
        
        footer
        {
            text-align: center;
            color: #383838;
            font-size: 14px;
            padding: 15px 0;
        }
        
        /* BACKDROP */
        #modalFornecedoresBackdrop
        {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(6px);
            background: rgba(0, 0, 0, 0.45);
            z-index: 2000;
            opacity: 0;
            transition: opacity 0.25s ease-in-out;
        }
        
        /* CARD */
        #modalFornecedoresCard
        {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 900px;
            max-width: 95%;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.25);
            padding: 24px;
            transform: translate(-50%, -50%) scale(0.8);
            opacity: 0;
            transition: transform 0.25s ease, opacity 0.25s ease;
        }
        
        /* HEADER */
        .modal-header
        {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 10px;
            margin-bottom: 16px;
        }
        
        .modal-header h2
        {
            font-size: 20px;
            margin: 0;
            font-weight: 600;
            color: #1f2937;
        }
        
        .btn-fechar
        {
            background: #dc2626;
            color: #fff;
            border: none;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
        }
        
        .btn-fechar:hover
        {
            opacity: .9;
        }
        
        /* FILTROS */
        .filtros-container
        {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
        }
        
        .filtros-container input
        {
            width: 100%;
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: #f9fafb;
            font-size: 14px;
        }
        
        .btn-limpar
        {
            background: #6b7280;
            color: #fff;
            border: none;
            padding: 8px 14px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        
        .btn-limpar:hover
        {
            opacity: .9;
        }
        
        /* TABELA */
        .tabela-fornecedores
        {
            width: 100%;
            border-collapse: collapse;
        }
        
        .tabela-fornecedores th
        {
            text-align: left;
            padding: 10px;
            background: #f3f4f6;
            font-size: 14px;
            color: #374151;
        }
        
        .tabela-fornecedores td
        {
            padding: 10px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
        }
        
        .tabela-fornecedores tr:hover
        {
            background: #f9fafb;
        }
    </style>
</head>
<body>
    <!-- BACKDROP -->
    <div id="modalFornecedoresBackdrop">
        <div id="modalFornecedoresCard">
            <!-- HEADER DO MODAL -->
            <div class="modal-header">
                <h2>
                    Lista de Fornecedores</h2>
                <button class="btn-fechar" onclick="fecharModalFornecedores()">
                    Fechar</button>
            </div>
            <!-- FILTROS -->
            <div class="filtros-container">
                <input type="text" id="filtroNome" placeholder="Filtrar por Nome" onkeyup="filtrarFornecedores()" />
                <input type="text" id="filtroEmail" placeholder="Filtrar por Email" onkeyup="filtrarFornecedores()" />
                <input type="text" id="filtroCNPJ" placeholder="Filtrar por CNPJ" onkeyup="filtrarFornecedores()" />
                <button class="btn-limpar" onclick="limparFiltros()">
                    Limpar</button>
            </div>
            <!-- TABELA -->
            <table class="tabela-fornecedores">
                <thead>
                    <tr>
                        <th>
                            Nome
                        </th>
                        <th>
                            Email
                        </th>
                        <th>
                            CNPJ
                        </th>
                    </tr>
                </thead>
                <tbody id="listaFornecedores">
                    <!-- Linhas preenchidas via JavaScript -->
                </tbody>
            </table>
        </div>
    </div>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
    <div class="header">
        <h1>
            📊 Dashboard — SGE</h1>
        <div class="controls">
            <select id="ddlPeriodo" onchange="fetchAndRender()">
                <option value="6">Últimos 6 meses</option>
                <option value="12">Últimos 12 meses</option>
                <option value="24">Últimos 24 meses</option>
            </select>
            <asp:DropDownList ID="ddlComprador" runat="server" AutoPostBack="false" CssClass="aspNetDropDown">
            </asp:DropDownList>
            <button type="button" onclick="abrirModalFornecedores()">
                Fornecedores</button>
            <button type="button" onclick="abrirEstoque()">
                Ver Estoque</button>
            <span class="muted" id="lblAtualizado">—</span>
        </div>
    </div>
    <div class="container">
        <div class="cards">
            <div class="card">
                <div class="title">
                    Total de Pedidos</div>
                <div class="value" id="kpiTotalPedidos">
                    0</div>
            </div>
            <div class="card">
                <div class="title">
                    Pedidos Pendentes</div>
                <div class="value" id="kpiPendentes">
                    0</div>
            </div>
            <div class="card">
                <div class="title">
                    Pedidos Conferidos</div>
                <div class="value" id="kpiConferidos">
                    0</div>
            </div>
            <div class="card">
                <div class="title">
                    Valor Total de Compras</div>
                <div class="value" id="kpiValorTotal">
                    R$ 0,00</div>
            </div>
            <div class="card">
                <div class="title">
                    Maior Compra</div>
                <div class="value" id="kpiMaiorCompra">
                    R$ 0,00</div>
            </div>
        </div>
        <div class="grid">
            <div class="chart-card">
                <h4>
                    📈 Volume de Compras</h4>
                <div class="chart-container">
                    <canvas id="chartEvolucao"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h4>
                    🏭 Desempenho de Fornecedores</h4>
                <div class="chart-container">
                    <canvas id="chartFornecedores"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h4>
                    🗂️ Compras por Categoria</h4>
                <div class="chart-container">
                    <canvas id="chartCategorias"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h4>
                    👥 Ranking de Compradores</h4>
                <div class="chart-container">
                    <canvas id="chartCompradores"></canvas>
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
var charts = {};
var lastTotalPedidos = -1;

function newChart(id, type, opts) {
    var ctx = document.getElementById(id).getContext('2d');
    return new Chart(ctx, Object.assign({
        type: type,
        data: { labels: [], datasets: [] },
        plugins: [ChartDataLabels],
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { boxWidth: 12, padding: 8, font: { size: 12 } } },
                tooltip: { enabled: true },
                datalabels: {
                    color: '#000',
                    font: { weight: 'bold', size: 11 },
                    formatter: function(value, context) {
                        var data = context.chart.data.datasets[0].data;
                        var total = data.reduce((a,b)=>a+b,0);
                        var pct = (value / total * 100).toFixed(1) + '%';
                        return pct;
                    }
                }
            }
        }
    }, opts || {}));
}

function initCharts() {
    charts.evolucao = newChart('chartEvolucao','line',{data:{datasets:[{fill:true,borderColor:'#1976d2',backgroundColor:'rgba(25,118,210,0.12)',pointRadius:4}]},options:{scales:{y:{beginAtZero:true}},plugins:{datalabels:{display:false}}}});
charts.fornecedores = newChart('chartFornecedores', 'pie', {
    options: {
        radius: '80%', // reduz o tamanho da pizza
        plugins: {
            legend: { position: 'bottom', align: 'center', labels: { boxWidth: 12, padding: 6, usePointStyle: true, pointStyle: 'circle', font: { size: 12 } } },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        var dataset = context.dataset;
                        var total = dataset.data.reduce((a, b) => a + b, 0);
                        var percent = ((context.raw / total) * 100).toFixed(1);
                        return context.label + ': R$ ' + context.raw.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) + ' (' + percent + '%)';
                    }
                }
            },
            datalabels: {
                color: '#fff',
                font: { weight: 'bold', size: 11 },
                formatter: function(value, context) {
                    var total = context.chart.data.datasets[0].data.reduce((a,b)=>a+b,0);
                    return ((value / total) * 100).toFixed(1) + '%';
                },
                anchor: function(context) {
                    var value = context.dataset.data[context.dataIndex];
                    var total = context.dataset.data.reduce((a,b)=>a+b,0);
                    return (value/total < 0.05) ? 'end' : 'center';
                },
                align: function(context) {
                    var value = context.dataset.data[context.dataIndex];
                    var total = context.dataset.data.reduce((a,b)=>a+b,0);
                    return (value/total < 0.05) ? 'end' : 'center';
                },
                offset: 10, // aumenta a distância externa das fatias pequenas
                clamp: true,
                display: true,
                backgroundColor: 'rgba(0,0,0,0.5)',
                borderRadius: 4,
                padding: 2
            }
        }
    }
});


    charts.categorias = newChart('chartCategorias','bar',{options:{scales:{y:{beginAtZero:true}}}});
    charts.compradores = newChart('chartCompradores','bar',{options:{scales:{y:{beginAtZero:true}}}}); 
}

function renderKPIs(kpi){
    $('#kpiTotalPedidos').text(kpi.totalPedidos);
    $('#kpiPendentes').text(kpi.pendentes);
    $('#kpiConferidos').text(kpi.conferidos);
    $('#kpiValorTotal').text(kpi.valorTotalStr);
    $('#kpiMaiorCompra').text(kpi.maiorCompraStr);
    $('#lblAtualizado').text('Atualizado: ' + kpi.atualizadoEm);
}

function renderChart(chartObj, labels, datasets){
    chartObj.data.labels = labels;
    chartObj.data.datasets = datasets;
    chartObj.update();
}

function fetchAndRender(){
    var periodo = parseInt($('#ddlPeriodo').val());
    var comprador = $('#<%= ddlComprador.ClientID %>').val() || 0;
    PageMethods.GetDashboardData(periodo, parseInt(comprador), function(result){
        if(result.kpi.totalPedidos !== lastTotalPedidos){
            lastTotalPedidos = result.kpi.totalPedidos;
            renderKPIs(result.kpi);

            renderChart(charts.evolucao, result.evolucao.labels, [{label:'Pedidos',data:result.evolucao.data,fill:true,borderColor:'#1976d2',backgroundColor:'rgba(25,118,210,0.12)',pointBackgroundColor:'#1976d2',pointHoverRadius:6}]);
            var fL=result.fornecedores.labels.slice(0,5), fD=result.fornecedores.data.slice(0,5), sL=fL.map(l=>l.length>28?l.slice(0,25)+'...':l), cF=['#007bff','#28a745','#ffc107','#dc3545','#6f42c1'];
            charts.fornecedores.data.labels=sL; charts.fornecedores.data.datasets=[{data:fD,backgroundColor:cF.slice(0,fD.length)}]; charts.fornecedores.update();

            var cores=['#f44336','#2196f3','#4caf50','#ffeb3b','#9c27b0','#00bcd4','#ff9800','#795548'];
            renderChart(charts.categorias,result.categorias.labels,[{label:'Valor',data:result.categorias.data,backgroundColor:cores.slice(0,result.categorias.labels.length)}]);
            renderChart(charts.compradores,result.compradores.labels.slice(0,5),[{label:'Valor (R$)',data:result.compradores.data.slice(0,5),backgroundColor:'rgba(76,175,80,0.7)',borderColor:'#4caf50',borderWidth:1}]);
        }
    },function(err){console.error(err);});
}

function abrirEstoque(){window.location.href='Estoque.aspx';}
$(function(){initCharts();fetchAndRender();setInterval(fetchAndRender,1000);});

 // ================================
        // ABRIR MODAL
        // ================================
        function abrirModalFornecedores() {
            document.getElementById("modalFornecedoresBackdrop").style.display = "block";

            setTimeout(function () {
                document.getElementById("modalFornecedoresBackdrop").style.opacity = "1";
                const card = document.getElementById("modalFornecedoresCard");
                card.style.transform = "translate(-50%, -50%) scale(1)";
                card.style.opacity = "1";
            }, 10);

            carregarFornecedores();
        }

        // ================================
        // FECHAR MODAL
        // ================================
        function fecharModalFornecedores() {
            document.getElementById("modalFornecedoresBackdrop").style.opacity = "0";
            const card = document.getElementById("modalFornecedoresCard");
            card.style.transform = "translate(-50%, -50%) scale(0.8)";
            card.style.opacity = "0";

            setTimeout(function () {
                document.getElementById("modalFornecedoresBackdrop").style.display = "none";
            }, 250);
        }

        // ================================
        // CARREGAR FORNECEDORES (AJAX)
        // ================================
        function carregarFornecedores() {

            PageMethods.GetFornecedores(onSuccess, onError);

            function onSuccess(response) {
                let tbody = document.getElementById("listaFornecedores");
                tbody.innerHTML = "";

                response.forEach(function (f) {
                    let row = `
                        <tr>
                            <td>${f.NomeFornecedor}</td>
                            <td>${f.Email}</td>
                            <td>${f.CNPJ}</td>                           
                        </tr>
                    `;
                    tbody.innerHTML += row;
                });
            }

            function onError(err) {
                alert("Erro ao carregar fornecedores.");
                console.error(err);
            }
        }

        // ================================
        // FILTRO NOME / EMAIL / CNPJ
        // ================================
        function filtrarFornecedores() {
            let nome = document.getElementById("filtroNome").value.toLowerCase();
            let email = document.getElementById("filtroEmail").value.toLowerCase();
            let cnpj = document.getElementById("filtroCNPJ").value.toLowerCase();

            let linhas = document.querySelectorAll("#listaFornecedores tr");

            linhas.forEach(function (tr) {
                let colNome = tr.children[0].textContent.toLowerCase();
                let colEmail = tr.children[1].textContent.toLowerCase();
                let colCNPJ = tr.children[2].textContent.toLowerCase();

                if (colNome.includes(nome) &&
                    colEmail.includes(email) &&
                    colCNPJ.includes(cnpj)) {
                        tr.style.display = "";
                } else {
                        tr.style.display = "none";
                }
            });
        }

        // ================================
        // LIMPAR FILTROS
        // ================================
        function limparFiltros() {
            document.getElementById("filtroNome").value = "";
            document.getElementById("filtroEmail").value = "";
            document.getElementById("filtroCNPJ").value = "";

            filtrarFornecedores();
        }

        // ABRIR ESTOQUE (SEU CÓDIGO ORIGINAL)
     
      

    $(function () {
        initCharts();
        fetchAndRender();
        setInterval(fetchAndRender, 1000);
    });
    </script>
    <footer style="text-align: center; margin-top: 20px; padding: 10px; color: #555;">
    &copy; <%: DateTime.Now.Year %> Sistema de Gestão de Estoque — Todos os direitos reservados.
</footer>
</body>
</html>
