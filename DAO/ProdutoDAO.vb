Public Class ProdutoDAO
    Implements iDAO(Of Produto)

    Public Function insere(Obj As Produto) As String Implements iDAO(Of Produto).insere
        Dim sql As String = "INSERT INTO produtos (nomeProduto, codBarra, precoUnitario, estoque) " &
                            "VALUES ('" & Obj.nomeProduto & "', " & Obj.codBarra & ", " & Obj.precoUnitario.ToString().Replace(",", ".") & ", " & Obj.estoque & ")"
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function altera(Obj As Produto) As String Implements iDAO(Of Produto).altera
        Dim sql As String = "UPDATE produtos SET nomeProduto = '" & Obj.nomeProduto & "', " &
                            "codBarra = " & Obj.codBarra & ", precoUnitario = " & Obj.precoUnitario.ToString().Replace(",", ".") & ", " &
                            "estoque = " & Obj.estoque & " WHERE idProduto = " & Obj.idProduto
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function deleta(Obj As Produto) As String Implements iDAO(Of Produto).deleta
        Dim sql As String = "DELETE FROM produtos WHERE idProduto = " & Obj.idProduto
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Produto).lista
        Dim sql As String = "SELECT idProduto, nomeProduto, codBarra, precoUnitario, estoque FROM produtos"
        If filtro <> "" Then sql &= " WHERE nomeProduto LIKE '%" & filtro & "%'"
        sql &= " ORDER BY nomeProduto"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    Public Sub preencherObjeto(ByRef Obj As Produto, id As Long) Implements iDAO(Of Produto).preencherObjeto
        Dim sql As String = "SELECT idProduto, nomeProduto, codBarra, precoUnitario, estoque FROM produtos WHERE idProduto = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idProduto = row("idProduto")
            Obj.nomeProduto = row("nomeProduto").ToString()
            Obj.codBarra = CLng(row("codBarra"))
            Obj.precoUnitario = CDbl(row("precoUnitario"))
            Obj.estoque = CInt(row("estoque"))
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Produto).preencherCombo
        Dim sql As String = "SELECT -1 idProduto, '-- Selecione o Produto --' nomeProduto " &
                            "UNION ALL SELECT idProduto, nomeProduto FROM produtos ORDER BY nomeProduto"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function
End Class