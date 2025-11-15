Imports System.Data
Imports System.Data.SqlClient

Partial Public Class WebForms_RealizarPedido
    Inherits System.Web.UI.Page

    Private cn As New Conexao()
    Private Shared EmEdicao As Boolean = False

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CarregarFornecedores()
            CarregarCategorias()
            CarregarProdutos()
            CarregarPedidos()
        End If
    End Sub

    ' === DROPDOWNS ===
    Private Sub CarregarFornecedores()
        Dim sql As String = "SELECT idFornecedor, nomeFornecedor + ' - ' + CNPJ AS descricao FROM fornecedores ORDER BY nomeFornecedor"
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        ddlFornecedor.DataSource = ds
        ddlFornecedor.DataTextField = "descricao"
        ddlFornecedor.DataValueField = "idFornecedor"
        ddlFornecedor.DataBind()
        ddlFornecedor.Items.Insert(0, New ListItem("-- Selecione um Fornecedor --", "0"))
    End Sub

    Private Sub CarregarCategorias()
        Dim sql As String = "SELECT idCategoria, nomeCategoria FROM categorias ORDER BY nomeCategoria"
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        ddlCategoria.DataSource = ds
        ddlCategoria.DataTextField = "nomeCategoria"
        ddlCategoria.DataValueField = "idCategoria"
        ddlCategoria.DataBind()
        ddlCategoria.Items.Insert(0, New ListItem("-- Todas as Categorias --", "0"))
    End Sub

    Private Sub CarregarProdutos()
        Dim sql As String = "SELECT idProduto, nomeProduto FROM produtos WHERE 1=1"
        Dim parametros As New List(Of SqlParameter)

        If ddlFornecedor.SelectedValue <> "0" Then
            sql &= " AND idFornecedor=@idFornecedor"
            parametros.Add(New SqlParameter("@idFornecedor", ddlFornecedor.SelectedValue))
        End If

        If ddlCategoria.SelectedValue <> "0" Then
            sql &= " AND idCategoria=@idCategoria"
            parametros.Add(New SqlParameter("@idCategoria", ddlCategoria.SelectedValue))
        End If

        sql &= " ORDER BY nomeProduto"

        Dim ds As DataSet
        If parametros.Count > 0 Then
            ds = cn.ExecutaSqlRetornoParam(sql, parametros.ToArray())
        Else
            ds = cn.ExecutaSqlRetorno(sql)
        End If

        ddlProduto.DataSource = ds
        ddlProduto.DataTextField = "nomeProduto"
        ddlProduto.DataValueField = "idProduto"
        ddlProduto.DataBind()
        ddlProduto.Items.Insert(0, New ListItem("-- Selecione um Produto --", "0"))
    End Sub

    ' === FILTRO POR FORNECEDOR E CATEGORIA ===
    Protected Sub ddlFornecedor_SelectedIndexChanged(sender As Object, e As EventArgs)
        CarregarProdutosFiltrados()
    End Sub

    Protected Sub ddlCategoria_SelectedIndexChanged(sender As Object, e As EventArgs)
        CarregarProdutosFiltrados()
    End Sub


    ' === GRID ===
   Private Sub CarregarPedidos()
        Try
            Dim idUsuario As Integer = CInt(Session("idUsuario")) ' comprador logado

            Dim sql As String = "SELECT c.idCompra, f.nomeFornecedor, p.nomeProduto, " &
                                "c.quantidadeComprada, " &
                                "ISNULL(c.quantidadeRecebida, c.quantidadeComprada) AS quantidadeRecebida, " &
                                "CAST(c.valorCompra AS DECIMAL(18,2)) AS valorAtualizado, " &
                                "c.idStatus " &
                                "FROM compras c " &
                                "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                                "INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                                "WHERE c.idUsuario = @idUsuario " &
                                "ORDER BY c.idCompra DESC"

            Dim parametros As SqlParameter() = {
                New SqlParameter("@idUsuario", idUsuario)
            }

            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, parametros)
            gvPedidos.DataSource = ds
            gvPedidos.DataBind()

        Catch ex As Exception
            MostrarMensagem("Erro ao carregar pedidos: " & ex.Message, False)
        End Try
    End Sub


    Private Sub CarregarProdutosFiltrados()
        Dim sql As String = "SELECT idProduto, nomeProduto FROM produtos WHERE 1=1"

        ' Filtrar por categoria, se selecionada
        If ddlCategoria.SelectedValue <> "0" Then
            sql &= " AND idCategoria=@idCategoria"
        End If

        sql &= " ORDER BY nomeProduto"

        Dim parametros As New List(Of SqlParameter)
        If ddlCategoria.SelectedValue <> "0" Then
            parametros.Add(New SqlParameter("@idCategoria", ddlCategoria.SelectedValue))
        End If

        Dim ds As DataSet
        If parametros.Count > 0 Then
            ds = cn.ExecutaSqlRetornoParam(sql, parametros.ToArray())
        Else
            ds = cn.ExecutaSqlRetorno(sql)
        End If

        ddlProduto.DataSource = ds
        ddlProduto.DataTextField = "nomeProduto"
        ddlProduto.DataValueField = "idProduto"
        ddlProduto.DataBind()
        ddlProduto.Items.Insert(0, New ListItem("-- Selecione um Produto --", "0"))
    End Sub


    ' === SALVAR PEDIDO ===
    Protected Sub btnSalvarPedido_Click(sender As Object, e As EventArgs)
        If EmEdicao Then
            MostrarMensagem("Conclua a atualização antes de realizar outra ação.", False)
            Exit Sub
        End If

        lblMensagem.Text = ""

        If ddlFornecedor.SelectedValue = "0" Then
            MostrarMensagem("Selecione um fornecedor.", False)
            Exit Sub
        End If

        If ddlProduto.SelectedValue = "0" Then
            MostrarMensagem("Selecione um produto.", False)
            Exit Sub
        End If

        If txtQuantidade.Text = "" Then
            MostrarMensagem("Informe a quantidade.", False)
            Exit Sub
        End If

        Dim sqlValor As String = "SELECT precoUnitario FROM produtos WHERE idProduto=@id"
        Dim paramValor As SqlParameter() = {New SqlParameter("@id", ddlProduto.SelectedValue)}
        Dim dsValor As DataSet = cn.ExecutaSqlRetornoParam(sqlValor, paramValor)

        If dsValor.Tables(0).Rows.Count = 0 Then
            MostrarMensagem("Produto não encontrado.", False)
            Exit Sub
        End If

        Dim valorUnitario As Decimal = CDec(dsValor.Tables(0).Rows(0)("precoUnitario"))
        txtValorUnitario.Text = valorUnitario.ToString("0.00")
        Dim quantidade As Integer = CInt(txtQuantidade.Text)
        Dim valorTotal As Decimal = quantidade * valorUnitario
        lblValorTotal.Text = "Valor Total: R$ " & valorTotal.ToString("0.00")

        Dim idUsuario As Integer = CInt(Session("idUsuario")) ' comprador logado

        Dim sql As String = "INSERT INTO compras (dataCompra, idProduto, idFornecedor, quantidadeComprada, valorCompra, idStatus, idUsuario) " &
                            "VALUES (GETDATE(), @idProduto, @idFornecedor, @quantidade, @valor, 1, @idUsuario)"
        Dim param As SqlParameter() = {
            New SqlParameter("@idProduto", ddlProduto.SelectedValue),
            New SqlParameter("@idFornecedor", ddlFornecedor.SelectedValue),
            New SqlParameter("@quantidade", quantidade),
            New SqlParameter("@valor", valorTotal),
            New SqlParameter("@idUsuario", idUsuario)
        }

        cn.ExecutaSqlComandoParam(sql, param)
        MostrarMensagem("Pedido salvo com sucesso!", True)
        CarregarPedidos()
        LimparCampos()
    End Sub

    ' === ATUALIZAR PEDIDO ===
    Protected Sub btnAtualizar_Click(sender As Object, e As EventArgs)
        If gvPedidos.SelectedIndex = -1 Then
            MostrarMensagem("Selecione um pedido para atualizar.", False)
            Exit Sub
        End If

        Dim idCompra As Integer = CInt(gvPedidos.SelectedDataKey.Value)

        Dim sqlStatus As String = "SELECT idStatus FROM compras WHERE idCompra=@id"
        Dim paramStatus As SqlParameter() = {New SqlParameter("@id", idCompra)}
        Dim dsStatus As DataSet = cn.ExecutaSqlRetornoParam(sqlStatus, paramStatus)

        If dsStatus.Tables(0).Rows.Count > 0 Then
            Dim status As Integer = CInt(dsStatus.Tables(0).Rows(0)("idStatus"))
            If status = 2 Or status = 3 Then
                MostrarMensagem("Não é possível editar um pedido em andamento ou conferido.", False)
                Exit Sub
            End If
        End If

        Dim quantidade As Integer = CInt(txtQuantidade.Text)
        Dim valorUnitario As Decimal = CDec(txtValorUnitario.Text)
        Dim valorTotal As Decimal = quantidade * valorUnitario
        lblValorTotal.Text = "Valor Total: R$ " & valorTotal.ToString("0.00")

        Dim sql As String = "UPDATE compras SET quantidadeComprada=@qtd, valorCompra=@valor WHERE idCompra=@id"
        Dim param As SqlParameter() = {
            New SqlParameter("@qtd", quantidade),
            New SqlParameter("@valor", valorTotal),
            New SqlParameter("@id", idCompra)
        }

        cn.ExecutaSqlComandoParam(sql, param)
        MostrarMensagem("Pedido atualizado com sucesso!", True)
        CarregarPedidos()
        LimparCampos()
        EmEdicao = False
        AlterarEstadoBotoes(True)
    End Sub

    ' === SELECIONAR LINHA ===
    Protected Sub gvPedidos_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ' Obtém o ID da compra selecionada
            Dim idCompra As Integer = CInt(gvPedidos.SelectedDataKey.Value)

            ' Consulta completa para buscar os detalhes da compra
            Dim sql As String = "SELECT c.idCompra, c.quantidadeComprada, c.valorCompra, " &
                                "f.idFornecedor, p.idProduto, p.precoUnitario, p.idCategoria, c.idStatus " &
                                "FROM compras c " &
                                "INNER JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                                "INNER JOIN produtos p ON c.idProduto = p.idProduto " &
                                "WHERE c.idCompra = @id"

            Dim param As SqlParameter() = {New SqlParameter("@id", idCompra)}
            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, param)

            If ds.Tables(0).Rows.Count > 0 Then
                Dim row = ds.Tables(0).Rows(0)
                Dim idStatus As Integer = CInt(row("idStatus"))

                ' ⚠️ Verifica se o status é "Conferido" (idStatus = 2)
                If idStatus = 2 Then
                    MostrarMensagem("Este pedido já foi conferido e não pode ser editado.", False)
                    gvPedidos.SelectedIndex = -1
                    Exit Sub
                End If

                ' Preenche o fornecedor
                ddlFornecedor.SelectedValue = row("idFornecedor").ToString()

                ' Recarrega categorias e produtos
                CarregarCategorias()
                Dim idCategoria As String = row("idCategoria").ToString()
                If ddlCategoria.Items.FindByValue(idCategoria) IsNot Nothing Then
                    ddlCategoria.SelectedValue = idCategoria
                End If

                CarregarProdutos()
                Dim idProduto As String = row("idProduto").ToString()
                If ddlProduto.Items.FindByValue(idProduto) IsNot Nothing Then
                    ddlProduto.SelectedValue = idProduto
                End If

                ' Quantidade e valor
                txtQuantidade.Text = row("quantidadeComprada").ToString()
                txtValorUnitario.Text = CDec(row("precoUnitario")).ToString("0.00")

                ' Calcula valor total
                Dim total As Decimal = CDec(row("quantidadeComprada")) * CDec(row("precoUnitario"))
                lblValorTotal.Text = "Valor Total: R$ " & total.ToString("0.00")

                ' Ativa modo de edição
                EmEdicao = True
                AlterarEstadoBotoes(False)
            End If


        Catch ex As Exception
            MostrarMensagem("Erro ao carregar pedido selecionado: " & ex.Message, False)
        End Try
    End Sub



    ' === ALTERAÇÃO AUTOMÁTICA DE PRODUTO ===
    Protected Sub ddlProduto_SelectedIndexChanged(sender As Object, e As EventArgs)
        If ddlProduto.SelectedValue = "0" Then
            txtValorUnitario.Text = ""
            lblValorTotal.Text = "Valor Total: R$ 0,00"
            Exit Sub
        End If

        Try
            Dim sql As String = "SELECT precoUnitario FROM produtos WHERE idProduto=@id"
            Dim param As SqlParameter() = {New SqlParameter("@id", ddlProduto.SelectedValue)}
            Dim ds As DataSet = cn.ExecutaSqlRetornoParam(sql, param)

            If ds.Tables(0).Rows.Count > 0 Then
                Dim valorUnitario As Decimal = CDec(ds.Tables(0).Rows(0)("precoUnitario"))
                txtValorUnitario.Text = valorUnitario.ToString("0.00")

                If txtQuantidade.Text <> "" Then
                    Dim quantidade As Integer = CInt(txtQuantidade.Text)
                    Dim valorTotal As Decimal = quantidade * valorUnitario
                    lblValorTotal.Text = "Valor Total: R$ " & valorTotal.ToString("0.00")
                Else
                    lblValorTotal.Text = "Valor Total: R$ " & valorUnitario.ToString("0.00")
                End If
            End If
        Catch ex As Exception
            MostrarMensagem("Erro ao carregar o valor do produto.", False)
        End Try
    End Sub

    ' === EXCLUIR ===
    Protected Sub gvPedidos_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        If EmEdicao Then
            MostrarMensagem("Conclua a atualização antes de realizar outra ação.", False)
            e.Cancel = True
            Exit Sub
        End If

        Dim idCompra As Integer = CInt(gvPedidos.DataKeys(e.RowIndex).Value)
        Dim sql As String = "DELETE FROM compras WHERE idCompra=@id"
        Dim param As SqlParameter() = {New SqlParameter("@id", idCompra)}
        cn.ExecutaSqlComandoParam(sql, param)

        MostrarMensagem("Pedido excluído com sucesso!", True)
        CarregarPedidos()
    End Sub

    ' === CANCELAR ===
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        LimparCampos()
        EmEdicao = False
        AlterarEstadoBotoes(True)
    End Sub

    Private Sub LimparCampos()
        ddlFornecedor.SelectedIndex = 0
        ddlCategoria.SelectedIndex = 0
        ddlProduto.SelectedIndex = 0
        txtQuantidade.Text = ""
        txtValorUnitario.Text = ""
        lblValorTotal.Text = "Valor Total: R$ 0,00"
        gvPedidos.SelectedIndex = -1
    End Sub

    ' === BLOQUEAR/DESBLOQUEAR BOTÕES ===
    Private Sub AlterarEstadoBotoes(ativo As Boolean)
        btnSalvarPedido.Enabled = ativo
        gvPedidos.Enabled = ativo
        btnAtualizar.Enabled = Not ativo
    End Sub

    ' === MENSAGENS COM TEMPORIZADOR ===
    Private Sub MostrarMensagem(msg As String, sucesso As Boolean)
        lblMensagem.Text = msg
        lblMensagem.CssClass = If(sucesso, "mensagem sucesso", "mensagem erro")
        Dim script As String = "setTimeout(function(){document.getElementById('" & lblMensagem.ClientID & "').innerText='';},2000);"
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideMsg", script, True)
    End Sub

    Protected Sub btnVoltar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/WebForms/PainelComprador.aspx")
    End Sub

End Class
