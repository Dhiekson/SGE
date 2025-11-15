Imports System.Data.SqlClient

Public Class PainelComprador
    Inherits System.Web.UI.Page

    Private cn As New Conexao()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarDadosUsuario()
            CarregarPedidos()
        End If
    End Sub

    Private Sub CarregarDadosUsuario()
        Try
            If Session("nomeUsuario") IsNot Nothing Then
                lblUsuario.Text = "Usuário: " & Session("nomeUsuario").ToString()
                lblFuncao.Text = "Função: " & Session("descricaoFuncao").ToString()
            Else
                Response.Redirect("Login.aspx")
            End If
        Catch ex As Exception
            lblErro.Text = "Erro ao carregar informações do usuário: " & ex.Message
        End Try
    End Sub

    Private Sub CarregarPedidos()
        Try
            Dim idUsuario As Integer = CInt(Session("idUsuario"))

            ' === Ajuste principal aqui ===
            ' Se a quantidadeRecebida for diferente de NULL, exibir ela.
            ' Caso contrário, mostrar quantidadeComprada normalmente.
            ' ValorCompra já vem atualizado após conferência.
            Dim sql As String =
                "SELECT c.idCompra, c.dataCompra, p.nomeProduto, f.nomeFornecedor, " &
                "ISNULL(c.quantidadeRecebida, c.quantidadeComprada) AS quantidadeComprada, s.idStatus, s.descricaoStatus, " &
                "CAST(c.valorCompra AS DECIMAL(18,2)) AS valorCompra, " &
                "u.nomeUsuario AS nomeConferente, c.observacoes, s.descricaoStatus " &
                "FROM compras c " &
                "INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                "INNER JOIN status s ON c.idStatus = s.idStatus " &
                "LEFT JOIN usuarios u ON c.idConferente = u.idUsuario " &
                "WHERE c.idUsuario = @idUsuario " &
                "ORDER BY c.dataCompra DESC"

            Dim parametros() As SqlParameter = {
                New SqlParameter("@idUsuario", idUsuario)
            }

            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)

            GridViewPedidos.DataSource = ds
            GridViewPedidos.DataBind()

        Catch ex As Exception
            lblErro.Text = "Erro ao carregar pedidos: " & ex.Message
        End Try
    End Sub

    Protected Sub btnSair_Click(sender As Object, e As EventArgs)
        Session.Abandon()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub GridViewPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            ' Pega o idStatus do DataItem
            Dim drv As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim idStatus As Integer = CInt(drv("idStatus"))

            ' Encontra o botão na linha
            Dim btnDevolver As Button = CType(e.Row.FindControl("btnDevolver"), Button)

            ' Botão visível apenas se o status for Devolução (idStatus = 3)
            If btnDevolver IsNot Nothing Then
                btnDevolver.Visible = (idStatus = 3)
            End If
        End If
    End Sub

    Protected Sub btnDevolver_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim idCompra As Integer = CInt(btn.CommandArgument)

        Try
            Dim cn As New Conexao()
            Dim sql As String = "DELETE FROM compras WHERE idCompra = @id"
            Dim parametros() As SqlParameter = {
                New SqlParameter("@id", idCompra)
            }

            cn.ExecutaSqlComandoParam(sql, parametros)

            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Pedido excluído com sucesso!"

            ' Atualiza a Grid
            CarregarPedidos()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao excluir pedido: " & ex.Message
        End Try
    End Sub


    Protected Sub gvPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idStatus As Integer = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "idStatus"))
            Dim btnDesfazer As Button = CType(e.Row.FindControl("btnDesfazer"), Button)

            If btnDesfazer IsNot Nothing Then
                btnDesfazer.Visible = (idStatus <> 3) ' 3 = Devolução
            End If
        End If
    End Sub

End Class
