Imports System.Data.SqlClient
Imports System.Text.RegularExpressions

Public Class CadastroFornecedor
    Inherits System.Web.UI.Page

    Private cn As New Conexao()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarFornecedores()
        End If
    End Sub

    ' ===== BOTÃO ADICIONAR / SALVAR =====
    Protected Sub btnAdicionar_Click(sender As Object, e As EventArgs)
        Dim nome As String = txtNomeFornecedor.Text.Trim()
        Dim cnpj As String = txtCNPJ.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()

        If nome = "" OrElse Not IsCNPJValido(cnpj) OrElse Not IsEmailValido(email) Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Preencha os campos corretamente."
            Return
        End If

        Dim sql As String = "INSERT INTO fornecedores (nomeFornecedor, CNPJ, email) VALUES (@nome, @cnpj, @email)"
        Dim parametros() As SqlParameter = {
            New SqlParameter("@nome", nome),
            New SqlParameter("@cnpj", cnpj),
            New SqlParameter("@email", email)
        }

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Fornecedor cadastrado com sucesso!"
            LimparCampos()
            CarregarFornecedores()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao salvar: " & ex.Message
        End Try
    End Sub

    ' ===== BOTÃO ATUALIZAR =====
    Protected Sub btnAtualizar_Click(sender As Object, e As EventArgs)
        If txtID.Text = "" Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Selecione um fornecedor para atualizar."
            Return
        End If

        Dim nome As String = txtNomeFornecedor.Text.Trim()
        Dim cnpj As String = txtCNPJ.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()

        ' 🔒 Validação igual à do botão Adicionar
        If nome = "" OrElse Not IsCNPJValido(cnpj) OrElse Not IsEmailValido(email) Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Preencha os campos corretamente."
            Return
        End If

        Dim sql As String = "UPDATE fornecedores SET nomeFornecedor=@nome, CNPJ=@cnpj, email=@email WHERE idFornecedor=@id"
        Dim parametros() As SqlParameter = {
            New SqlParameter("@nome", nome),
            New SqlParameter("@cnpj", cnpj),
            New SqlParameter("@email", email),
            New SqlParameter("@id", txtID.Text)
        }

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Fornecedor atualizado com sucesso!"
            LimparCampos()
            CarregarFornecedores()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao atualizar: " & ex.Message
        End Try
    End Sub

    ' ===== BOTÃO CANCELAR =====
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        LimparCampos()
    End Sub

    ' ===== VOLTAR =====
    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("PainelComprador.aspx")
    End Sub

    ' ====== CARREGAR FORNECEDORES NA GRID ======
    Private Sub CarregarFornecedores()
        Dim sql As String = "SELECT idFornecedor, nomeFornecedor, CNPJ, email FROM fornecedores ORDER BY nomeFornecedor"
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        gvFornecedores.DataSource = ds
        gvFornecedores.DataBind()
    End Sub

    ' ====== EVENTO EDITAR (SELECT) ======
    Protected Sub gvFornecedores_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim row As GridViewRow = gvFornecedores.SelectedRow
        txtID.Text = gvFornecedores.DataKeys(row.RowIndex).Value.ToString()
        txtNomeFornecedor.Text = row.Cells(1).Text
        txtCNPJ.Text = row.Cells(2).Text
        txtEmail.Text = row.Cells(3).Text

        lblMensagem.Text = "Modo de edição ativado."
        lblMensagem.CssClass = "mensagem sucesso"
        btnAdicionar.Enabled = False
        btnAtualizar.Enabled = True
    End Sub


    ' ====== EVENTO DELETAR (ROW DELETING) ======
    Protected Sub gvFornecedores_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim idFornecedor As String = gvFornecedores.DataKeys(e.RowIndex).Value.ToString()
        Dim sql As String = "DELETE FROM fornecedores WHERE idFornecedor=@id"
        Dim parametros() As SqlParameter = {New SqlParameter("@id", idFornecedor)}

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            lblMensagem.CssClass = "mensagem sucesso"
            lblMensagem.Text = "Fornecedor excluído com sucesso!"
            CarregarFornecedores()
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao excluir: " & ex.Message
        End Try
    End Sub

    ' ====== FUNÇÕES AUXILIARES ======
    Private Sub LimparCampos()
        txtID.Text = ""
        txtNomeFornecedor.Text = ""
        txtCNPJ.Text = ""
        txtEmail.Text = ""
        lblMensagem.Text = ""
        btnAdicionar.Enabled = True
        btnAtualizar.Enabled = False
    End Sub

    Private Function IsCNPJValido(cnpj As String) As Boolean
        cnpj = Regex.Replace(cnpj, "[^0-9]", "")
        If cnpj.Length <> 14 Then Return False
        Return True ' (pode colocar a verificação completa se quiser)
    End Function

    Private Function IsEmailValido(email As String) As Boolean
        Dim pattern As String = "^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$"
        Return Regex.IsMatch(email, pattern)
    End Function

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        Dim termo As String = txtBuscar.Text.Trim()

        ' Se o campo estiver vazio
        If termo = "" Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Digite um nome ou CNPJ para buscar."
            gvFornecedores.Visible = False
            Exit Sub
        End If

        Try
            Dim sql As String = "SELECT * FROM fornecedores WHERE nomeFornecedor LIKE @termo OR CNPJ LIKE @termo"
            Dim parametros() As SqlClient.SqlParameter = {
                New SqlClient.SqlParameter("@termo", "%" & termo & "%")
            }

            Dim cn As New Conexao()
            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                gvFornecedores.Visible = True
                gvFornecedores.DataSource = ds
                gvFornecedores.DataBind()
                lblMensagem.Text = "" ' limpa mensagem
            Else
                gvFornecedores.Visible = False
                lblMensagem.CssClass = "mensagem erro"
                lblMensagem.Text = "Nenhum fornecedor encontrado com o nome ou CNPJ informado."
            End If

        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao buscar fornecedores: " & ex.Message
            gvFornecedores.Visible = False
        End Try
    End Sub


    Protected Sub btnResetar_Click(sender As Object, e As EventArgs)
        txtBuscar.Text = ""
        lblMensagem.Text = ""
        gvFornecedores.Visible = True
        CarregarFornecedores() ' Método que recarrega todos os fornecedores
    End Sub



End Class
