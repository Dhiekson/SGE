Imports System.Data.SqlClient

Public Class MeusPedidos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarPedidos()
        End If
    End Sub

    ' Carrega os pedidos do comprador logado
    Private Sub CarregarPedidos()
        Try
            Dim idUsuario As Integer = CInt(Session("idUsuario"))
            Dim cn As New Conexao()

            ' SELECT: retorna quantidadeRecebida como fallback para quantidadeComprada,
            ' e valorAtualizado como o valor atual presente na tabela (conferente já pode ter alterado).
            Dim sql As String = "SELECT c.idCompra, p.nomeProduto, f.nomeFornecedor, " &
                                "c.quantidadeComprada, " &
                                "ISNULL(c.quantidadeRecebida, c.quantidadeComprada) AS quantidadeRecebida, " &
                                "CAST(c.valorCompra AS DECIMAL(18,2)) AS valorAtualizado, " &
                                "s.descricaoStatus, u.nomeUsuario AS nomeConferente " &
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
            gvPedidos.DataSource = ds
            gvPedidos.DataBind()

        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao carregar pedidos: " & ex.Message
        End Try
    End Sub

    ' Botão voltar para painel do comprador
    Protected Sub btnVoltarComprador_Click(sender As Object, e As EventArgs)
        Response.Redirect("PainelComprador.aspx")
    End Sub

    ' Força atualização quando clicar em Atualizar
    Protected Sub btnRefresh_Click(sender As Object, e As EventArgs)
        CarregarPedidos()
    End Sub

    ' Evento do botão Desfazer (apaga compra)
    Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Desfazer" Then
            Dim idCompra As Integer = CInt(e.CommandArgument)
            Try
                Dim cn As New Conexao()
                Dim sql As String = "DELETE FROM compras WHERE idCompra = @id"
                Dim parametros() As SqlParameter = {
                    New SqlParameter("@id", idCompra)
                }

                cn.ExecutaSqlComandoParam(sql, parametros)

                lblMensagem.CssClass = "mensagem sucesso"
                lblMensagem.Text = "Pedido desfazido com sucesso!"

                ' Atualiza a GridView
                CarregarPedidos()

            Catch ex As Exception
                lblMensagem.CssClass = "mensagem erro"
                lblMensagem.Text = "Erro ao desfazer pedido: " & ex.Message
            End Try
        End If
    End Sub
End Class
