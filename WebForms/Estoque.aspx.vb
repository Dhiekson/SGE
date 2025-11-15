Imports System.Data
Imports System.Data.SqlClient

Partial Class Estoque
    Inherits System.Web.UI.Page

    Private cn As New Conexao()
    Private Const LIMITE_ESTOQUE_BAIXO As Integer = 5

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarEstoque()
            CarregarEstoqueBaixo()
        End If
    End Sub

    Private Sub CarregarEstoque()
        Dim totalQuantidade As Integer = 0
        Dim totalValor As Decimal = 0D

        Dim sql As String = "SELECT p.nomeProduto, p.codBarra, p.precoUnitario, SUM(c.quantidadeRecebida) AS quantidadeRecebida, SUM(c.valorCompra) AS valorTotal " &
                            "FROM compras c INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                            "WHERE c.idStatus = 2 " &
                            "GROUP BY p.nomeProduto, p.codBarra, p.precoUnitario " &
                            "ORDER BY p.nomeProduto"

        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each r As DataRow In ds.Tables(0).Rows
                totalQuantidade += If(r("quantidadeRecebida") IsNot DBNull.Value, Convert.ToInt32(r("quantidadeRecebida")), 0)
                totalValor += If(r("valorTotal") IsNot DBNull.Value, Convert.ToDecimal(r("valorTotal")), 0D)
            Next
        End If

        gvEstoque.DataSource = ds
        gvEstoque.DataBind()

        litTotalQuantidade.Text = totalQuantidade.ToString()
        litTotalValor.Text = "R$ " & totalValor.ToString("N2")
    End Sub

    Private Sub CarregarEstoqueBaixo()
        Dim sql As String = "SELECT p.nomeProduto, p.codBarra, SUM(c.quantidadeRecebida) AS quantidadeRecebida " &
                            "FROM compras c INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                            "WHERE c.idStatus = 2 " &
                            "GROUP BY p.nomeProduto, p.codBarra " &
                            "HAVING SUM(c.quantidadeRecebida) <= " & LIMITE_ESTOQUE_BAIXO & " " &
                            "ORDER BY quantidadeRecebida ASC"

        Dim dsLow As DataSet = cn.ExecutaSqlRetorno(sql)
        gvLowStock.DataSource = dsLow
        gvLowStock.DataBind()

        litLowStockCount.Text = If(dsLow IsNot Nothing AndAlso dsLow.Tables.Count > 0, dsLow.Tables(0).Rows.Count.ToString(), "0")
    End Sub

End Class
