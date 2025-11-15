Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services

Partial Class Dashboard
    Inherits System.Web.UI.Page

    Private cn As New Conexao()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarCompradores()
        End If
    End Sub

    Private Sub CarregarCompradores()
        ' Busca apenas usuários com idFuncao = 1 (compradores)
        Dim sql As String = "SELECT idUsuario, nomeUsuario FROM usuarios WHERE idFuncao = 1 ORDER BY nomeUsuario"
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)

        ddlComprador.Items.Clear()
        ddlComprador.Items.Add(New ListItem("Todos", "0"))

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each r As DataRow In ds.Tables(0).Rows
                ddlComprador.Items.Add(New ListItem(r("nomeUsuario").ToString(), r("idUsuario").ToString()))
            Next
        End If
    End Sub

    <WebMethod()>
    Public Shared Function GetDashboardData(periodo As Integer, compradorId As Integer) As Object
        Dim cn As New Conexao()

        ' Filtro período
        Dim filtroPeriodo As String = "c.dataCompra >= DATEADD(DAY, -" & periodo & ", GETDATE())"

        ' Filtro comprador
        Dim filtroComprador As String = ""
        If compradorId > 0 Then
            filtroComprador = " AND c.idUsuario = " & compradorId
        Else
            filtroComprador = " AND c.idUsuario IN (SELECT idUsuario FROM usuarios WHERE idFuncao = 1)"
        End If

        ' KPIs
        Dim sqlKpi As String = "SELECT " &
            "COUNT(*) AS totalPedidos, " &
            "SUM(CASE WHEN c.idStatus = 1 THEN 1 ELSE 0 END) AS pendentes, " &
            "SUM(CASE WHEN c.idStatus = 2 THEN 1 ELSE 0 END) AS conferidos, " &
            "SUM(c.valorCompra) AS valorTotal, " &
            "MAX(c.valorCompra) AS maiorCompra " &
            "FROM compras c " &
            "WHERE " & filtroPeriodo & filtroComprador

        Dim dsKpi As DataSet = cn.ExecutaSqlRetorno(sqlKpi)
        Dim totalPedidos As Integer = 0
        Dim pendentes As Integer = 0
        Dim conferidos As Integer = 0
        Dim valorTotal As Decimal = 0
        Dim maiorCompra As Decimal = 0

        If dsKpi IsNot Nothing AndAlso dsKpi.Tables.Count > 0 AndAlso dsKpi.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = dsKpi.Tables(0).Rows(0)
            totalPedidos = If(row("totalPedidos") IsNot DBNull.Value, Convert.ToInt32(row("totalPedidos")), 0)
            pendentes = If(row("pendentes") IsNot DBNull.Value, Convert.ToInt32(row("pendentes")), 0)
            conferidos = If(row("conferidos") IsNot DBNull.Value, Convert.ToInt32(row("conferidos")), 0)
            valorTotal = If(row("valorTotal") IsNot DBNull.Value, Convert.ToDecimal(row("valorTotal")), 0D)
            maiorCompra = If(row("maiorCompra") IsNot DBNull.Value, Convert.ToDecimal(row("maiorCompra")), 0D)
        End If

        Dim kpi = New With {
            .totalPedidos = totalPedidos,
            .pendentes = pendentes,
            .conferidos = conferidos,
            .devolucao = 0,
            .valorTotalStr = "R$ " & valorTotal.ToString("N2"),
            .maiorCompraStr = "R$ " & maiorCompra.ToString("N2"),
            .atualizadoEm = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
        }
        ' Evolução por mês 
        Dim sqlEvol As String = "SELECT YEAR(c.dataCompra) AS ano, MONTH(c.dataCompra) AS mes, COUNT(*) AS qtd " &
                                "FROM compras c " &
                                "WHERE " & filtroPeriodo & filtroComprador & " " &
                                "GROUP BY YEAR(c.dataCompra), MONTH(c.dataCompra) " &
                                "ORDER BY ano, mes"

        Dim dsEvol As DataSet = cn.ExecutaSqlRetorno(sqlEvol)
        Dim evolLabels As New List(Of String)
        Dim evolData As New List(Of Integer)
        If dsEvol IsNot Nothing AndAlso dsEvol.Tables.Count > 0 Then
            For Each r As DataRow In dsEvol.Tables(0).Rows
                Dim label As String = r("mes").ToString.PadLeft(2, "0"c) & "/" & r("ano").ToString
                evolLabels.Add(label)
                evolData.Add(Convert.ToInt32(r("qtd")))
            Next
        End If


        ' Fornecedores
        Dim sqlFornecedores As String = "SELECT f.nomeFornecedor, SUM(c.valorCompra) AS totalValor FROM compras c " &
                                        "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                                        "WHERE " & filtroPeriodo & filtroComprador & " GROUP BY f.nomeFornecedor ORDER BY totalValor DESC"
        Dim dsFor As DataSet = cn.ExecutaSqlRetorno(sqlFornecedores)
        Dim forLabels As New List(Of String)
        Dim forData As New List(Of Decimal)
        If dsFor IsNot Nothing AndAlso dsFor.Tables.Count > 0 Then
            For Each r As DataRow In dsFor.Tables(0).Rows
                forLabels.Add(r("nomeFornecedor").ToString())
                forData.Add(Convert.ToDecimal(r("totalValor")))
            Next
        End If

        ' Categorias
        Dim sqlCat As String = "SELECT ISNULL(cat.nomeCategoria,'Sem Categoria') AS nomeCategoria, SUM(c.valorCompra) AS totalValor " &
                               "FROM compras c INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                               "LEFT JOIN categorias cat ON p.idCategoria = cat.idCategoria " &
                               "WHERE " & filtroPeriodo & filtroComprador & " GROUP BY ISNULL(cat.nomeCategoria,'Sem Categoria') ORDER BY totalValor DESC"
        Dim dsCat As DataSet = cn.ExecutaSqlRetorno(sqlCat)
        Dim catLabels As New List(Of String)
        Dim catData As New List(Of Decimal)
        If dsCat IsNot Nothing AndAlso dsCat.Tables.Count > 0 Then
            For Each r As DataRow In dsCat.Tables(0).Rows
                catLabels.Add(r("nomeCategoria").ToString())
                catData.Add(Convert.ToDecimal(r("totalValor")))
            Next
        End If

        ' Compradores (ranking)
        Dim sqlComp As String = "SELECT u.nomeUsuario, SUM(c.valorCompra) AS totalValor FROM compras c " &
                                "INNER JOIN usuarios u ON c.idUsuario = u.idUsuario " &
                                "WHERE " & filtroPeriodo & filtroComprador & " GROUP BY u.nomeUsuario ORDER BY totalValor DESC"
        Dim dsComp As DataSet = cn.ExecutaSqlRetorno(sqlComp)
        Dim compLabels As New List(Of String)
        Dim compData As New List(Of Decimal)
        If dsComp IsNot Nothing AndAlso dsComp.Tables.Count > 0 Then
            For Each r As DataRow In dsComp.Tables(0).Rows
                compLabels.Add(r("nomeUsuario").ToString())
                compData.Add(Convert.ToDecimal(r("totalValor")))
            Next
        End If

        ' Recebidos
        Dim sqlRec As String = "SELECT p.nomeProduto, p.codBarra, SUM(c.quantidadeComprada) AS quantidade " &
                               "FROM compras c INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                               "WHERE c.idStatus = 2 AND " & filtroPeriodo & filtroComprador & " GROUP BY p.nomeProduto, p.codBarra ORDER BY quantidade DESC"
        Dim dsRec As DataSet = cn.ExecutaSqlRetorno(sqlRec)
        Dim recebidos As New List(Of Object)
        If dsRec IsNot Nothing AndAlso dsRec.Tables.Count > 0 Then
            For Each r As DataRow In dsRec.Tables(0).Rows
                recebidos.Add(New With {
                    Key .nome = r("nomeProduto").ToString(),
                    Key .codBarra = r("codBarra").ToString(),
                    Key .quantidade = Convert.ToInt32(r("quantidade"))
                })
            Next
        End If

        Return New With {
            Key .kpi = kpi,
            Key .evolucao = New With {.labels = evolLabels, .data = evolData},
            Key .fornecedores = New With {.labels = forLabels, .data = forData},
            Key .categorias = New With {.labels = catLabels, .data = catData},
            Key .compradores = New With {.labels = compLabels, .data = compData},
            Key .recebidos = recebidos,
            Key .devolvidos = New List(Of Object)()
        }
    End Function

    <WebMethod()>
    Public Shared Function GetFornecedores() As Object
        Dim cn As New Conexao()
        Dim sql As String =
            "SELECT idFornecedor, nomeFornecedor, CNPJ, email " &
            "FROM fornecedores " &
            "ORDER BY nomeFornecedor"

        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        Dim lista As New List(Of Object)

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each r As DataRow In ds.Tables(0).Rows
                lista.Add(New With {
                    .idFornecedor = r("idFornecedor").ToString(),
                    .NomeFornecedor = r("nomeFornecedor").ToString(),
                    .CNPJ = r("CNPJ").ToString(),
                    .Email = r("email").ToString()
                })
            Next
        End If

        Return lista
    End Function

End Class
