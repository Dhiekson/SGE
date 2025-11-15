Imports System.Data.SqlClient

Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim usuario As String = txtUsuario.Text.Trim()
        Dim senha As String = txtSenha.Text.Trim()

        If usuario = "" Or senha = "" Then
            lblMensagem.Text = "Preencha usuário e senha."
            Return
        End If

        Dim cn As New Conexao()
        Dim sql As String = "SELECT * FROM usuarios WHERE nomeUsuario=@usuario AND senhaUsuario=@senha"
        Dim parametros() As SqlParameter = {
            New SqlParameter("@usuario", usuario),
            New SqlParameter("@senha", senha)
        }

        Try
            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)

            If ds.Tables(0).Rows.Count > 0 Then
                ' Armazena informações do usuário na sessão
                Session("descricaoFuncao") = ds.Tables(0).Rows(0)("perfilUsuario")

                Session("idUsuario") = ds.Tables(0).Rows(0)("idUsuario")
                Session("nomeUsuario") = ds.Tables(0).Rows(0)("nomeUsuario")
                Session("perfilUsuario") = ds.Tables(0).Rows(0)("perfilUsuario")

                ' Redireciona conforme perfil
                Select Case ds.Tables(0).Rows(0)("perfilUsuario").ToString()
                    Case "Comprador"
                        Response.Redirect("PainelComprador.aspx")
                    Case "Conferente"
                        Response.Redirect("PainelConferente.aspx")
                    Case Else
                        Response.Redirect("Painel.aspx")
                End Select
            Else
                lblMensagem.Text = "Usuário ou senha inválidos."
            End If
        Catch ex As Exception
            lblMensagem.Text = "Erro: " & ex.Message
        End Try
    End Sub

    Protected Sub btnCadastro_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/WebForms/CadastroUsuario.aspx")
    End Sub

End Class
