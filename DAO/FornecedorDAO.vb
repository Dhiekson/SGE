Public Class FornecedorDAO
    Implements iDAO(Of Fornecedor)

    Public Function insere(Obj As Fornecedor) As String Implements iDAO(Of Fornecedor).insere
        Dim sql As String = "INSERT INTO fornecedores (nomeFornecedor, CNPJ, email) " &
                            "VALUES ('" & Obj.nomeFornecedor & "', '" & Obj.CNPJ & "', '" & Obj.email & "')"
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function altera(Obj As Fornecedor) As String Implements iDAO(Of Fornecedor).altera
        Dim sql As String = "UPDATE fornecedores SET nomeFornecedor = '" & Obj.nomeFornecedor & "', " &
                            "CNPJ = '" & Obj.CNPJ & "', email = '" & Obj.email & "' WHERE idFornecedor = " & Obj.idFornecedor
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function deleta(Obj As Fornecedor) As String Implements iDAO(Of Fornecedor).deleta
        Dim sql As String = "DELETE FROM fornecedores WHERE idFornecedor = " & Obj.idFornecedor
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Fornecedor).lista
        Dim sql As String = "SELECT idFornecedor, nomeFornecedor, CNPJ, email FROM fornecedores"
        If filtro <> "" Then sql &= " WHERE nomeFornecedor LIKE '%" & filtro & "%'"
        sql &= " ORDER BY nomeFornecedor"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    Public Sub preencherObjeto(ByRef Obj As Fornecedor, id As Long) Implements iDAO(Of Fornecedor).preencherObjeto
        Dim sql As String = "SELECT idFornecedor, nomeFornecedor, CNPJ, email FROM fornecedores WHERE idFornecedor = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idFornecedor = row("idFornecedor")
            Obj.nomeFornecedor = row("nomeFornecedor").ToString()
            Obj.CNPJ = row("CNPJ").ToString()
            Obj.email = row("email").ToString()
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Fornecedor).preencherCombo
        Dim sql As String = "SELECT -1 idFornecedor, '-- Selecione o Fornecedor --' nomeFornecedor " &
                            "UNION ALL SELECT idFornecedor, nomeFornecedor FROM fornecedores ORDER BY nomeFornecedor"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function
End Class
