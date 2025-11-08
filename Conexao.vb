Imports System.Data.SqlClient

Public Class Conexao

    'Variável de conexão
    Private StringConexao As String = My.Settings.BANCO

    Public Function AbreConexao()

        Dim Con As SqlConnection = New SqlConnection()

        Try

            Con.ConnectionString = StringConexao
            If Con.State = ConnectionState.Closed Then
                Con.Open()
            End If

        Catch ex As Exception
            Throw New Exception("ERRO AcessoDados.AbreConexao(): " & ex.Message)
        End Try

        Return Con

    End Function

    Public Sub FechaConexao(ByVal ConParam As SqlConnection)
        Try
            ConParam.Close()
        Catch ex As Exception
            Throw New Exception("ERRO AcessoDados.FechaConexao(): " & ex.Message)
        End Try
    End Sub

    Public Function ExecutaSql(ByVal Sql As String) As Integer

        Dim Transacao As SqlTransaction

        Dim Conexao As SqlConnection = AbreConexao()

        Transacao = Conexao.BeginTransaction()

        Dim N As Integer = -1
        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql
            Comando.Transaction = Transacao
            N = Comando.ExecuteNonQuery()

            Transacao.Commit()

        Catch ex As Exception
            Transacao.Rollback()
            ' Throw New Exception("ERRO AcessoDados.ExecutaSql(Sql): " & ex.Message)
        Finally
            FechaConexao(Conexao)
            Transacao.Dispose()
        End Try

        Return N

    End Function

    Public Function ExecutaSqlNew(ByVal Sql As String) As String

        Dim Transacao As SqlTransaction

        Dim Conexao As SqlConnection = AbreConexao()

        Transacao = Conexao.BeginTransaction()

        Dim Retorno As String = "OK"
        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql
            Comando.Transaction = Transacao
            Comando.ExecuteNonQuery()

            Transacao.Commit()

        Catch ex As Exception
            Transacao.Rollback()
            Retorno = ex.Message
        Finally
            FechaConexao(Conexao)
            Transacao.Dispose()
        End Try

        Return Retorno
    End Function

    Public Function ExecutaSqlRetorno(ByVal Sql As String) As DataSet
        Dim Conexao As SqlConnection = AbreConexao()
        Dim DadosRet As DataSet = New DataSet()
        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql

            Dim Adaptador As SqlDataAdapter = New SqlDataAdapter()
            Adaptador.SelectCommand = Comando
            Adaptador.Fill(DadosRet)

        Catch ex As Exception
            Throw New Exception("ERRO AcessoDados.ExecutaSqlRetorno(Sql): " & ex.Message)
        Finally
            FechaConexao(Conexao)
        End Try

        Return DadosRet
    End Function

    Public Function ExecutaSqlScalar(ByVal Sql As String) As Double
        Dim Transacao As SqlTransaction
        Dim Conexao As SqlConnection = AbreConexao()
        Transacao = Conexao.BeginTransaction()
        Dim N As Double = -1
        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql
            Comando.Transaction = Transacao
            N = Comando.ExecuteScalar()
            Transacao.Commit()
        Catch ex As Exception
            Transacao.Rollback()
        Finally
            FechaConexao(Conexao)
            Transacao.Dispose()
        End Try
        Return N
    End Function

    Public Function ExecutaSqlRetornoParam(ByVal Sql As String, ByVal parametros() As SqlParameter) As DataSet
        Dim Conexao As SqlConnection = AbreConexao()
        Dim DadosRet As DataSet = New DataSet()
        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql

            ' Adiciona os parâmetros, se houver
            If parametros IsNot Nothing Then
                Comando.Parameters.AddRange(parametros)
            End If

            Dim Adaptador As SqlDataAdapter = New SqlDataAdapter()
            Adaptador.SelectCommand = Comando
            Adaptador.Fill(DadosRet)

        Catch ex As Exception
            Throw New Exception("ERRO AcessoDados.ExecutaSqlRetornoParam(Sql): " & ex.Message)
        Finally
            FechaConexao(Conexao)
        End Try

        Return DadosRet
    End Function

    Public Sub ExecutaSqlComandoParam(ByVal Sql As String, ByVal parametros() As SqlParameter)
        Dim Transacao As SqlTransaction
        Dim Conexao As SqlConnection = AbreConexao()
        Transacao = Conexao.BeginTransaction()

        Try
            Dim Comando As SqlCommand = New SqlCommand()
            Comando.Connection = Conexao
            Comando.CommandType = CommandType.Text
            Comando.CommandText = Sql
            Comando.Transaction = Transacao

            ' Adiciona os parâmetros, se houver
            If parametros IsNot Nothing Then
                Comando.Parameters.AddRange(parametros)
            End If

            Comando.ExecuteNonQuery()
            Transacao.Commit()

        Catch ex As SqlException
            Transacao.Rollback()
            Throw ' <-- lança o SqlException original
        Finally
            FechaConexao(Conexao)
            Transacao.Dispose()
        End Try
    End Sub

    Public Function ExecutaSqlRetornoScalar(ByVal Sql As String) As Double
        Return ExecutaSqlScalar(Sql)
    End Function

    Public Function ExecutaSqlRetornoScalarDecimal(ByVal Sql As String) As Decimal
        Dim Conexao As SqlConnection = AbreConexao()
        Dim Resultado As Decimal = 0

        Try
            Dim Comando As SqlCommand = New SqlCommand(Sql, Conexao)
            Dim Retorno = Comando.ExecuteScalar()
            If Not IsDBNull(Retorno) AndAlso Retorno IsNot Nothing Then
                Resultado = Convert.ToDecimal(Retorno)
            End If
        Catch ex As Exception
            Throw New Exception("ERRO AcessoDados.ExecutaSqlRetornoScalarDecimal(): " & ex.Message)
        Finally
            FechaConexao(Conexao)
        End Try

        Return Resultado
    End Function

End Class

