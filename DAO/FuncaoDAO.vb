Public Class FuncaoDAO
    Implements iDAO(Of Funcao)

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Funcao).lista
        Dim sql As String = "SELECT idFuncao, nomeFuncao FROM funcoes"
        If filtro <> "" Then sql &= " WHERE nomeFuncao LIKE '%" & filtro & "%'"
        sql &= " ORDER BY nomeFuncao"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    Public Sub preencherObjeto(ByRef Obj As Funcao, id As Long) Implements iDAO(Of Funcao).preencherObjeto
        Dim sql As String = "SELECT idFuncao, nomeFuncao FROM funcoes WHERE idFuncao = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idFuncao = row("idFuncao")
            Obj.nomeFuncao = row("nomeFuncao").ToString()
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Funcao).preencherCombo
        Dim sql As String = "SELECT -1 idFuncao, '-- Selecione a Função --' nomeFuncao " &
                            "UNION ALL SELECT idFuncao, nomeFuncao FROM funcoes ORDER BY nomeFuncao"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    ' Métodos não utilizados
    Public Function insere(Obj As Funcao) As String Implements iDAO(Of Funcao).insere
        Return ""
    End Function
    Public Function altera(Obj As Funcao) As String Implements iDAO(Of Funcao).altera
        Return ""
    End Function
    Public Function deleta(Obj As Funcao) As String Implements iDAO(Of Funcao).deleta
        Return ""
    End Function
End Class