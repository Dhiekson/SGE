Public Class StatusDAO
    Implements iDAO(Of Status)

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Status).lista
        Dim sql As String = "SELECT idStatus, descricaoStatus FROM status"
        If filtro <> "" Then sql &= " WHERE descricaoStatus LIKE '%" & filtro & "%'"
        sql &= " ORDER BY descricaoStatus"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    Public Sub preencherObjeto(ByRef Obj As Status, id As Long) Implements iDAO(Of Status).preencherObjeto
        Dim sql As String = "SELECT idStatus, descricaoStatus FROM status WHERE idStatus = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idStatus = row("idStatus")
            Obj.descricaoStatus = row("descricaoStatus").ToString()
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Status).preencherCombo
        Dim sql As String = "SELECT -1 idStatus, '-- Selecione o Status --' descricaoStatus " &
                            "UNION ALL SELECT idStatus, descricaoStatus FROM status ORDER BY descricaoStatus"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    ' Métodos não utilizados
    Public Function insere(Obj As Status) As String Implements iDAO(Of Status).insere
        Return ""
    End Function
    Public Function altera(Obj As Status) As String Implements iDAO(Of Status).altera
        Return ""
    End Function
    Public Function deleta(Obj As Status) As String Implements iDAO(Of Status).deleta
        Return ""
    End Function
End Class