<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroUsuario.aspx.vb" Inherits="SGE.CadastroUsuario" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Usuário</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; display:flex; justify-content:center; align-items:center; height:100vh; }
        .box { background:#fff; padding:30px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.1); width:350px; }
        .mensagem { text-align:center; margin-bottom:10px; }
        .mensagem.erro { color:red; }
        .mensagem.sucesso { color:green; }
        input[type=text], input[type=password], select { width:100%; padding:8px; margin-bottom:10px; border-radius:5px; border:1px solid #ccc; }
        input[type=submit] { width:100%; padding:10px; background:#28a745; color:#fff; border:none; border-radius:5px; cursor:pointer; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <asp:TextBox ID="txtNomeUsuario" runat="server" placeholder="Nome"></asp:TextBox>
            <asp:TextBox ID="txtSenha" runat="server" TextMode="Password" placeholder="Senha"></asp:TextBox>
            <asp:TextBox ID="txtConfirmarSenha" runat="server" TextMode="Password" placeholder="Confirmar Senha"></asp:TextBox>
            <asp:TextBox ID="txtEmail" runat="server" placeholder="Email"></asp:TextBox>
            <asp:DropDownList ID="ddlFuncao" runat="server"></asp:DropDownList>

            <asp:Button ID="btnSalvar" runat="server" Text="Salvar" OnClick="btnSalvar_Click" />
        </div>
    </form>
</body>
</html>
