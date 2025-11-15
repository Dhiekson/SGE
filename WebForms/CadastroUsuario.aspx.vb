Imports System.Data.SqlClient

Public Class CadastroUsuario
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim funcDao As New FuncaoDAO()
            ddlFuncao.DataSource = funcDao.preencherCombo()
            ddlFuncao.DataTextField = "nomeFuncao"
            ddlFuncao.DataValueField = "idFuncao"
            ddlFuncao.DataBind()

        End If
    End Sub

    Protected Sub btnSalvar_Click(sender As Object, e As EventArgs)
        Dim nome As String = txtNomeUsuario.Text.Trim()
        Dim senha As String = txtSenha.Text.Trim()
        Dim confirmarSenha As String = txtConfirmarSenha.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim idFuncao As Integer = CInt(ddlFuncao.SelectedValue)

        ' 🧩 Validações básicas
        If nome = "" Or senha = "" Or confirmarSenha = "" Or idFuncao = -1 Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Preencha todos os campos obrigatórios."
            Return
        End If

        If senha <> confirmarSenha Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "As senhas não coincidem."
            Return
        End If

        Dim cn As New Conexao()

        Try
            ' 🔍 Verifica se já existe um usuário com o mesmo nome
            Dim verificaSql As String = "SELECT COUNT(*) FROM usuarios WHERE nomeUsuario = @nome"
            Dim parametrosVerifica() As SqlParameter = {
                New SqlParameter("@nome", nome)
            }

            Dim dsVerifica = cn.ExecutaSqlRetornoParam(verificaSql, parametrosVerifica)
            Dim jaExiste As Integer = CInt(dsVerifica.Tables(0).Rows(0)(0))

            If jaExiste > 0 Then
                lblMensagem.CssClass = "mensagem erro"
                lblMensagem.Text = "Já existe um usuário com esse nome. Escolha outro."
                Return
            End If

            ' 💾 Insere novo usuário
            Dim sql As String = "INSERT INTO usuarios (nomeUsuario, senhaUsuario, perfilUsuario, email, idFuncao) " &
                                "VALUES (@nome, @senha, @perfil, @email, @idFuncao)"

            Dim perfil As String = ddlFuncao.SelectedItem.Text
            Dim parametros() As SqlParameter = {
                New SqlParameter("@nome", nome),
                New SqlParameter("@senha", senha),
                New SqlParameter("@perfil", perfil),
                New SqlParameter("@email", email),
                New SqlParameter("@idFuncao", idFuncao)
            }

            cn.ExecutaSqlComandoParam(sql, parametros)

            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Usuário cadastrado com sucesso! Você será redirecionado para o login."

            ' ⏳ Redireciona
            Response.Redirect("~/WebForms/Login.aspx")


        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao cadastrar: " & ex.Message
        End Try
    End Sub

    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("Login.aspx")

    End Sub
End Class
