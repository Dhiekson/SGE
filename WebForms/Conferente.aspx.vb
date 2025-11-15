Imports System.Data.SqlClient

Public Class Conferente
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarPedidos()
        End If
    End Sub

    Private Sub CarregarPedidos()
        Try
            Dim cn As New Conexao()
            Dim sql As String =
                "SELECT c.idCompra, p.nomeProduto, f.nomeFornecedor, u.nomeUsuario AS Comprador, " &
                "c.quantidadeComprada, c.quantidadeRecebida, c.valorCompra, c.observacoes, s.descricaoStatus " &
                "FROM compras c " &
                "INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                "INNER JOIN usuarios u ON c.idUsuario = u.idUsuario " &
                "INNER JOIN status s ON c.idStatus = s.idStatus " &
                "WHERE c.idStatus = 1 " &
                "ORDER BY c.dataCompra DESC"

            gvPedidos.DataSource = cn.ExecutaSqlRetorno(sql)
            gvPedidos.DataBind()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao carregar pedidos: " & ex.Message
        End Try
    End Sub

    Protected Sub TimerPedidos_Tick(sender As Object, e As EventArgs)
        CarregarPedidos()
    End Sub

    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("PainelConferente.aspx")
    End Sub

    Protected Sub btnSalvarConferencia_Click(sender As Object, e As EventArgs)
        Dim idCompra As Integer = CInt(hfIdPedido.Value)
        Dim quantidadeRecebida As Integer
        Dim obs As String = txtObservacoes.Text.Trim()
        Dim idStatus As Integer = CInt(ddlStatusConferencia.SelectedValue)
        Dim idConferente As Integer = CInt(Session("idUsuario"))

        If Not Integer.TryParse(txtQuantidadeRecebida.Text.Trim(), quantidadeRecebida) Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Informe uma quantidade válida."
            Exit Sub
        End If

        Try
            Dim cn As New Conexao()

            ' Buscar quantidade comprada e valor original
            Dim ds = cn.ExecutaSqlRetorno("SELECT quantidadeComprada, valorCompra FROM compras WHERE idCompra=" & idCompra)
            Dim quantidadeComprada As Integer = CInt(ds.Tables(0).Rows(0)("quantidadeComprada"))
            Dim valorCompraOriginal As Decimal = CDec(ds.Tables(0).Rows(0)("valorCompra"))

            ' ✅ Se recebeu quantidade diferente, precisa justificar
            If quantidadeRecebida <> quantidadeComprada AndAlso String.IsNullOrWhiteSpace(obs) Then
                lblMensagem.CssClass = "mensagem erro"
                lblMensagem.Text = "Informe o motivo da diferença de quantidade."
                Exit Sub
            End If

            ' Ajustar valor proporcional
            Dim valorUnitario As Decimal = valorCompraOriginal / quantidadeComprada
            Dim novoValor As Decimal = valorUnitario * quantidadeRecebida

            Dim sql As String =
                "UPDATE compras SET quantidadeRecebida=@qtd, observacoes=@obs, idStatus=@status, idConferente=@conferente, valorCompra=@valor WHERE idCompra=@id"

            Dim parametros() As SqlParameter = {
                New SqlParameter("@qtd", quantidadeRecebida),
                New SqlParameter("@obs", obs),
                New SqlParameter("@status", idStatus),
                New SqlParameter("@conferente", idConferente),
                New SqlParameter("@valor", novoValor),
                New SqlParameter("@id", idCompra)
            }

            cn.ExecutaSqlComandoParam(sql, parametros)

            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Conferência salva com sucesso!"

            txtQuantidadeRecebida.Text = ""
            txtObservacoes.Text = ""
            ddlStatusConferencia.SelectedIndex = 0
            hfIdPedido.Value = ""

            CarregarPedidos()

        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao salvar conferência: " & ex.Message
        End Try
    End Sub

End Class
