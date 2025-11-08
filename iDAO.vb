Public Interface iDAO(Of TableObject)
    Function insere(Obj As TableObject) As String
    Function altera(Obj As TableObject) As String
    Function deleta(Obj As TableObject) As String
    Function lista(filtro As String) As DataSet
    Sub preencherObjeto(ByRef Obj As TableObject, id As Long)
    Function preencherCombo() As DataSet

End Interface
