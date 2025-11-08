Public Class UsuarioDAO
    Implements iDAO(Of Usuario)

    Public Function insere(Obj As Usuario) As String Implements iDAO(Of Usuario).insere
        Dim sql As String = "INSERT INTO usuarios (nomeUsuario, senhaUsuario, perfilUsuario, email, idFuncao) " &
                            "VALUES ('" & Obj.nomeUsuario & "', '" & Obj.senhaUsuario & "', '" & Obj.perfilUsuario & "', '" & Obj.email & "', " & Obj.idFuncao & ")"
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function altera(Obj As Usuario) As String Implements iDAO(Of Usuario).altera
        Dim sql As String = "UPDATE usuarios SET nomeUsuario = '" & Obj.nomeUsuario & "', senhaUsuario = '" & Obj.senhaUsuario & "', " &
                            "perfilUsuario = '" & Obj.perfilUsuario & "', email = '" & Obj.email & "', idFuncao = " & Obj.idFuncao &
                            " WHERE idUsuario = " & Obj.idUsuario
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function deleta(Obj As Usuario) As String Implements iDAO(Of Usuario).deleta
        Dim sql As String = "DELETE FROM usuarios WHERE idUsuario = " & Obj.idUsuario
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Usuario).lista
        Dim sql As String = "SELECT u.idUsuario, u.nomeUsuario, u.email, u.perfilUsuario, u.idFuncao, f.nomeFuncao " &
                            "FROM usuarios u LEFT JOIN funcoes f ON u.idFuncao = f.idFuncao"
        If filtro <> "" Then sql &= " WHERE u.nomeUsuario LIKE '%" & filtro & "%'"
        sql &= " ORDER BY u.nomeUsuario"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function

    Public Sub preencherObjeto(ByRef Obj As Usuario, id As Long) Implements iDAO(Of Usuario).preencherObjeto
        Dim sql As String = "SELECT idUsuario, nomeUsuario, senhaUsuario, perfilUsuario, email, idFuncao FROM usuarios WHERE idUsuario = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idUsuario = row("idUsuario")
            Obj.nomeUsuario = row("nomeUsuario").ToString()
            Obj.senhaUsuario = row("senhaUsuario").ToString()
            Obj.perfilUsuario = row("perfilUsuario").ToString()
            Obj.email = row("email").ToString()
            Obj.idFuncao = row("idFuncao")
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Usuario).preencherCombo
        Dim sql As String = "SELECT -1 idUsuario, '-- Selecione o Usuário --' nomeUsuario " &
                            "UNION ALL SELECT idUsuario, nomeUsuario FROM usuarios ORDER BY nomeUsuario"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function
End Class