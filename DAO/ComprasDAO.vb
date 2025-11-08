Public Class ComprasDAO
    Implements iDAO(Of Compra)

    Public Function insere(Obj As Compra) As String Implements iDAO(Of Compra).insere
        Dim sql As String = "INSERT INTO compras (dataCompra, idProduto, idFornecedor, quantidadeComprada, valorCompra, idConferente, idStatus, quantidadeRecebida, observacoes, idUsuario) " &
                            "VALUES ('" & Obj.dataCompra & "', " & Obj.idProduto & ", " & Obj.idFornecedor & ", " & Obj.quantidadeComprada & ", " & Obj.valorCompra.ToString().Replace(",", ".") & ", " &
                            If(Obj.idConferente.HasValue, Obj.idConferente.ToString(), "NULL") & ", " & Obj.idStatus & ", " &
                            If(Obj.quantidadeRecebida.HasValue, Obj.quantidadeRecebida.ToString(), "NULL") & ", '" & Obj.observacoes & "', " & Obj.idUsuario & ")"
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function altera(Obj As Compra) As String Implements iDAO(Of Compra).altera
        Dim sql As String = "UPDATE compras SET " &
                            "dataCompra = '" & Obj.dataCompra & "', " &
                            "idProduto = " & Obj.idProduto & ", " &
                            "idFornecedor = " & Obj.idFornecedor & ", " &
                            "quantidadeComprada = " & Obj.quantidadeComprada & ", " &
                            "valorCompra = " & Obj.valorCompra.ToString().Replace(",", ".") & ", " &
                            "idConferente = " & If(Obj.idConferente.HasValue, Obj.idConferente.ToString(), "NULL") & ", " &
                            "idStatus = " & Obj.idStatus & ", " &
                            "quantidadeRecebida = " & If(Obj.quantidadeRecebida.HasValue, Obj.quantidadeRecebida.ToString(), "NULL") & ", " &
                            "observacoes = '" & Obj.observacoes & "', " &
                            "idUsuario = " & Obj.idUsuario & " " &
                            "WHERE idCompra = " & Obj.idCompra
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function deleta(Obj As Compra) As String Implements iDAO(Of Compra).deleta
        Dim sql As String = "DELETE FROM compras WHERE idCompra = " & Obj.idCompra
        Dim cn As New Conexao
        Return cn.ExecutaSql(sql)
    End Function

    Public Function lista(filtro As String) As DataSet Implements iDAO(Of Compra).lista
        Dim sql As String = "SELECT " &
                            "c.idCompra, " &
                            "c.dataCompra, " &
                            "p.nomeProduto, " &
                            "p.codBarra, " &
                            "f.nomeFornecedor, " &
                            "uc.nomeUsuario AS Comprador, " &
                            "uconf.nomeUsuario AS Conferente, " &
                            "c.quantidadeComprada, " &
                            "c.quantidadeRecebida, " &
                            "c.valorCompra, " &
                            "s.descricaoStatus, " &
                            "c.observacoes " &
                            "FROM compras c " &
                            "LEFT JOIN produtos p ON c.idProduto = p.idProduto " &
                            "LEFT JOIN fornecedores f ON c.idFornecedor = f.idFornecedor " &
                            "LEFT JOIN usuarios uc ON c.idUsuario = uc.idUsuario " &
                            "LEFT JOIN usuarios uconf ON c.idConferente = uconf.idUsuario " &
                            "LEFT JOIN status s ON c.idStatus = s.idStatus "

        If filtro <> "" Then
            sql &= "WHERE f.nomeFornecedor LIKE '%" & filtro & "%' OR p.nomeProduto LIKE '%" & filtro & "%' "
        End If

        sql &= "ORDER BY c.dataCompra DESC"

        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function


    Public Sub preencherObjeto(ByRef Obj As Compra, id As Long) Implements iDAO(Of Compra).preencherObjeto
        Dim sql As String = "SELECT * FROM compras WHERE idCompra = " & id
        Dim cn As New Conexao
        Dim ds As DataSet = cn.ExecutaSqlRetorno(sql)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)
            Obj.idCompra = row("idCompra")
            Obj.dataCompra = row("dataCompra").ToString()
            Obj.idProduto = row("idProduto")
            Obj.idFornecedor = row("idFornecedor")
            Obj.quantidadeComprada = CInt(row("quantidadeComprada"))
            Obj.valorCompra = CDbl(row("valorCompra"))
            Obj.idConferente = If(IsDBNull(row("idConferente")), Nothing, CLng(row("idConferente")))
            Obj.idStatus = row("idStatus")
            Obj.quantidadeRecebida = If(IsDBNull(row("quantidadeRecebida")), Nothing, CInt(row("quantidadeRecebida")))
            Obj.observacoes = row("observacoes").ToString()
            Obj.idUsuario = row("idUsuario")
        End If
    End Sub

    Public Function preencherCombo() As DataSet Implements iDAO(Of Compra).preencherCombo
        Dim sql As String = "SELECT -1 idCompra, '-- Selecione a Compra --' dataCompra " &
                            "UNION ALL SELECT idCompra, CONVERT(VARCHAR, dataCompra, 103) AS dataCompra FROM compras ORDER BY idCompra DESC"
        Dim cn As New Conexao
        Return cn.ExecutaSqlRetorno(sql)
    End Function
End Class