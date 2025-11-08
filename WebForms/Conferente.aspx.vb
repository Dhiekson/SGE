Imports System.Data.SqlClient

Public Class Conferente
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarPedidos()
        End If
    End Sub

    ' ==== CARREGAR PEDIDOS ====
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
                "WHERE c.idStatus IN (1) " &
                "ORDER BY c.dataCompra DESC"

            gvPedidos.DataSource = cn.ExecutaSqlRetorno(sql)
            gvPedidos.DataBind()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao carregar pedidos: " & ex.Message
        End Try
    End Sub

    ' ==== TIMER PARA AUTO-ATUALIZAÇÃO ====
    Protected Sub TimerPedidos_Tick(sender As Object, e As EventArgs)
        CarregarPedidos()
    End Sub

    ' ==== BOTÃO VOLTAR ====
    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("PainelConferente.aspx")
    End Sub

    ' ==== SALVAR CONFERÊNCIA ====
    Protected Sub btnSalvarConferencia_Click(sender As Object, e As EventArgs)
        Dim idCompra As Integer = CInt(hfIdPedido.Value)
        Dim quantidadeRecebida As Integer
        Dim obs As String = txtObservacoes.Text.Trim()
        Dim idStatus As Integer = CInt(ddlStatusConferencia.SelectedValue)
        Dim idConferente As Integer = CInt(Session("idUsuario"))

        If Not Integer.TryParse(txtQuantidadeRecebida.Text.Trim(), quantidadeRecebida) Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Quantidade inválida."
            Return
        End If

        Try
            Dim cn As New Conexao()
            Dim sql As String =
                "UPDATE compras SET quantidadeRecebida=@qtd, observacoes=@obs, idStatus=@status, idConferente=@conferente WHERE idCompra=@id"

            Dim parametros() As SqlParameter = {
                New SqlParameter("@qtd", quantidadeRecebida),
                New SqlParameter("@obs", obs),
                New SqlParameter("@status", idStatus),
                New SqlParameter("@conferente", idConferente),
                New SqlParameter("@id", idCompra)
            }

            cn.ExecutaSqlComandoParam(sql, parametros)

            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Pedido conferido com sucesso!"

            ' Limpar campos
            txtQuantidadeRecebida.Text = ""
            txtObservacoes.Text = ""
            ddlStatusConferencia.SelectedIndex = 0
            hfIdPedido.Value = ""

            ' Atualiza Grid e fecha painel
            CarregarPedidos()
            ClientScript.RegisterStartupScript(Me.GetType(), "FecharPainel", "atualizarGridEAposSalvar();", True)

        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao salvar conferência: " & ex.Message
        End Try
    End Sub
End Class
