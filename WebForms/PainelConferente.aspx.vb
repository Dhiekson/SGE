Imports System.Data.SqlClient

Public Class PainelConferente
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Verifica se o usuário está logado e é conferente
            If Session("nomeUsuario") Is Nothing OrElse Session("perfilUsuario") Is Nothing Then
                Response.Redirect("Login.aspx")
            End If

            lblNomeUsuario.Text = Session("nomeUsuario").ToString()
            lblPerfilUsuario.Text = Session("perfilUsuario").ToString()
        End If
    End Sub

    Protected Sub btnConferirPedidos_Click(sender As Object, e As EventArgs)
        Response.Redirect("Conferente.aspx")
    End Sub

    Protected Sub btnSair_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("Login.aspx")
    End Sub
End Class
