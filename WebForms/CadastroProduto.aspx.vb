Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization

Public Class CadastroProduto
    Inherits System.Web.UI.Page

    Private cn As New Conexao()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarCategorias()
            CarregarProdutos()
            btnAdicionar.Enabled = True
            btnAtualizar.Enabled = False
        End If
    End Sub

    Private Sub CarregarCategorias()
        Dim sql As String = "SELECT idCategoria, nomeCategoria FROM categorias ORDER BY nomeCategoria"
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        ddlCategoria.Items.Clear()
        ddlCategoria.Items.Add(New ListItem("Selecione uma categoria", "0"))

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each r As DataRow In ds.Tables(0).Rows
                ddlCategoria.Items.Add(New ListItem(r("nomeCategoria").ToString(), r("idCategoria").ToString()))
            Next
        End If
    End Sub

    Protected Sub btnAdicionar_Click(sender As Object, e As EventArgs)
        If Not ValidarCampos() Then Exit Sub

        Dim precoDecimal As Decimal
        Try
            precoDecimal = ConverterParaDecimal(txtPreco.Text)
        Catch ex As Exception
            ExibirErro("Preço inválido. Use o formato 0,00.")
            Exit Sub
        End Try

        Dim categoriaId As Integer = Convert.ToInt32(ddlCategoria.SelectedValue)
        If categoriaId = 0 Then
            ExibirErro("Selecione uma categoria para o produto.")
            Exit Sub
        End If

        Dim sql As String = "INSERT INTO produtos (nomeProduto, codBarra, precoUnitario, idCategoria) VALUES (@nome, @cod, @preco, @idCat)"
        Dim parametros() As SqlParameter = {
            New SqlParameter("@nome", txtNome.Text.Trim()),
            New SqlParameter("@cod", txtCodBarra.Text.Trim()),
            New SqlParameter("@preco", precoDecimal),
            New SqlParameter("@idCat", categoriaId)
        }

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            CarregarProdutos()
            LimparCampos()
        Catch ex As Exception
            ExibirErro("Erro ao adicionar produto: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnAtualizar_Click(sender As Object, e As EventArgs)
        If gvProdutos.SelectedDataKey Is Nothing Then
            ExibirErro("Selecione um produto para atualizar.")
            Exit Sub
        End If

        If Not ValidarCampos() Then Exit Sub

        Dim precoDecimal As Decimal
        Try
            precoDecimal = ConverterParaDecimal(txtPreco.Text)
        Catch ex As Exception
            ExibirErro("Preço inválido. Use o formato 0,00.")
            Exit Sub
        End Try

        Dim categoriaId As Integer = Convert.ToInt32(ddlCategoria.SelectedValue)
        If categoriaId = 0 Then
            ExibirErro("Selecione uma categoria para o produto.")
            Exit Sub
        End If

        Dim id As Integer = gvProdutos.SelectedDataKey.Value
        Dim sql As String = "UPDATE produtos SET nomeProduto=@nome, codBarra=@cod, precoUnitario=@preco, idCategoria=@idCat WHERE idProduto=@id"
        Dim parametros() As SqlParameter = {
            New SqlParameter("@nome", txtNome.Text.Trim()),
            New SqlParameter("@cod", txtCodBarra.Text.Trim()),
            New SqlParameter("@preco", precoDecimal),
            New SqlParameter("@idCat", categoriaId),
            New SqlParameter("@id", id)
        }

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            CarregarProdutos()
            LimparCampos()
        Catch ex As Exception
            ExibirErro("Erro ao atualizar produto: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvProdutos_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim id As Integer = Convert.ToInt32(gvProdutos.DataKeys(e.RowIndex).Value)
        Dim sql As String = "DELETE FROM produtos WHERE idProduto=@id"
        Dim parametros() As SqlParameter = {New SqlParameter("@id", id)}

        Try
            cn.ExecutaSqlComandoParam(sql, parametros)
            CarregarProdutos()
        Catch ex As Exception
            ExibirErro("Erro ao excluir produto: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvProdutos_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim row As GridViewRow = gvProdutos.SelectedRow
        txtNome.Text = row.Cells(1).Text
        txtCodBarra.Text = row.Cells(2).Text
        txtPreco.Text = row.Cells(3).Text.Replace("R$", "").Trim()

        Dim nomeCategoria As String = row.Cells(4).Text
        Dim item As ListItem = ddlCategoria.Items.FindByText(nomeCategoria)
        If item IsNot Nothing Then ddlCategoria.SelectedValue = item.Value

        btnAdicionar.Enabled = False
        btnAtualizar.Enabled = True
    End Sub

    Private Sub LimparCampos()
        txtNome.Text = ""
        txtCodBarra.Text = ""
        txtPreco.Text = ""
        ddlCategoria.SelectedIndex = 0
        gvProdutos.SelectedIndex = -1
        btnAdicionar.Enabled = True
        btnAtualizar.Enabled = False
    End Sub

    Private Sub CarregarProdutos()
        Dim sql As String = "SELECT p.idProduto, p.nomeProduto, p.codBarra, p.precoUnitario, c.nomeCategoria " &
                            "FROM produtos p LEFT JOIN categorias c ON p.idCategoria=c.idCategoria " &
                            "ORDER BY p.nomeProduto"
        Try
            Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
            gvProdutos.DataSource = ds
            gvProdutos.DataBind()
        Catch ex As Exception
            ExibirErro("Erro ao carregar produtos: " & ex.Message)
        End Try
    End Sub

    Private Function ValidarCampos() As Boolean
        Dim valido As Boolean = True
        Dim controles = New TextBox() {txtNome, txtCodBarra, txtPreco}

        For Each ctrl As TextBox In controles
            If String.IsNullOrWhiteSpace(ctrl.Text) Then
                ctrl.BorderColor = Drawing.Color.Red
                valido = False
            Else
                ctrl.BorderColor = Drawing.Color.LightGray
            End If
        Next

        If ddlCategoria.SelectedValue = "0" Then
            valido = False
        End If

        If Not valido Then
            ExibirErro("Preencha todos os campos obrigatórios e selecione uma categoria.")
        End If

        Return valido
    End Function

    Private Function ConverterParaDecimal(valor As String) As Decimal
        valor = valor.Replace("R$", "").Trim()
        valor = valor.Replace(".", "").Replace(",", ".")
        Return Decimal.Parse(valor, CultureInfo.InvariantCulture)
    End Function

    Private Sub ExibirErro(msg As String)
        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('" & msg & "');", True)
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        Dim termo As String = txtBuscar.Text.Trim()

        If termo = "" Then
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Digite um nome ou código para buscar."
            gvProdutos.Visible = False
            Exit Sub
        End If

        Try
            Dim sql As String = "SELECT p.idProduto, p.nomeProduto, p.codBarra, p.precoUnitario, c.nomeCategoria " &
                                "FROM produtos p LEFT JOIN categorias c ON p.idCategoria=c.idCategoria " &
                                "WHERE p.nomeProduto LIKE @termo OR p.codBarra LIKE @termo"

            Dim parametros() As SqlParameter = {New SqlParameter("@termo", "%" & termo & "%")}
            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)

            If ds IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
                gvProdutos.Visible = True
                gvProdutos.DataSource = ds
                gvProdutos.DataBind()
                lblMensagem.Text = ""
            Else
                gvProdutos.Visible = False
                lblMensagem.CssClass = "mensagem erro"
                lblMensagem.Text = "Nenhum produto encontrado."
            End If
        Catch ex As Exception
            lblMensagem.CssClass = "mensagem erro"
            lblMensagem.Text = "Erro ao buscar produtos: " & ex.Message
        End Try
    End Sub

    Protected Sub btnResetar_Click(sender As Object, e As EventArgs)
        txtBuscar.Text = ""
        lblMensagem.Text = ""
        gvProdutos.Visible = True
        CarregarProdutos()
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        LimparCampos()
    End Sub

    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/WebForms/PainelComprador.aspx")
    End Sub
End Class
