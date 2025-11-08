Imports System.Data
Imports System.Data.SqlClient

Public Class PainelComprador
    Inherits System.Web.UI.Page

    Private cn As New Conexao()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verifica se o usuário está logado e é comprador
        If Session("perfilUsuario") Is Nothing OrElse Session("perfilUsuario").ToString() <> "Comprador" Then
            Response.Redirect("~/WebForms/Login.aspx")
        End If

        If Not IsPostBack Then
            CarregarUsuarioNaTela()
            CarregarPedidos()
        End If
    End Sub

    ' Exibe nome e função do usuário logado
    Private Sub CarregarUsuarioNaTela()
        Dim nome As String = If(TryCast(Session("nomeUsuario"), String), "Desconhecido")
        Dim funcao As String = If(TryCast(Session("perfilUsuario"), String), "Sem Função")

        lblUsuario.Text = "Usuário: " & nome
        lblFuncao.Text = "Função: " & funcao
    End Sub


    ' Carrega pedidos do comprador
    Protected Sub CarregarPedidos()
        Try
            Dim idUsuario As Long = CLng(Session("idUsuario"))

            Dim sql As String =
                "SELECT c.idCompra, c.dataCompra, p.nomeProduto, f.nomeFornecedor, " &
                "c.quantidadeComprada, c.valorCompra, c.observacoes, " &
                "ISNULL(s.descricaoStatus, 'Pendente') AS descricaoStatus, " &
                "ISNULL(u.nomeUsuario, 'Não conferido') AS nomeConferente " &
                "FROM compras c " &
                "INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                "LEFT JOIN status s ON c.idStatus = s.idStatus " &
                "LEFT JOIN usuarios u ON c.idConferente = u.idUsuario " &
                "WHERE c.idUsuario = @idUsuario " &
                "ORDER BY c.idCompra DESC"

            Dim parametros As SqlParameter() = {
                New SqlParameter("@idUsuario", SqlDbType.BigInt) With {.Value = idUsuario}
            }

            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)
            GridViewPedidos.DataSource = ds
            GridViewPedidos.DataBind()

        Catch ex As Exception
            lblErro.Text = "Erro ao carregar pedidos: " & ex.Message
        End Try
    End Sub


    ' Mostra o botão "Devolver" apenas se o status for "Devolução"
    Protected Sub GridViewPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim status As String = DataBinder.Eval(e.Row.DataItem, "descricaoStatus").ToString()
            Dim btnDevolver As Button = CType(e.Row.FindControl("btnDevolver"), Button)

            If btnDevolver IsNot Nothing Then
                btnDevolver.Visible = (status = "Devolução")
            End If
        End If
    End Sub

    ' Exclui o pedido quando clicado em "Devolver"
    Protected Sub btnDevolver_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim idCompra As Long = CLng(btn.CommandArgument)

        Try
            Dim sql As String = "DELETE FROM compras WHERE idCompra = @idCompra"
            Dim parametros As SqlParameter() = {
                New SqlParameter("@idCompra", SqlDbType.BigInt) With {.Value = idCompra}
            }

            cn.ExecutaSqlComandoParam(sql, parametros)

            CarregarPedidos()
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Pedido devolvido e removido com sucesso!');", True)

        Catch ex As Exception
            lblErro.Text = "Erro ao devolver pedido: " & ex.Message
        End Try
    End Sub

    ' Botão de sair
    Protected Sub btnSair_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/WebForms/Login.aspx")
    End Sub
End Class
