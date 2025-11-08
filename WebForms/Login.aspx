<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="SGE.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login</title>
    <style>
        body { font-family:'Segoe UI', Arial, sans-serif; background:#f4f7fb; display:flex; align-items:center; justify-content:center; height:100vh; }
        .box { background:#fff; padding:30px; border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.06); width:350px; }
        h2 { text-align:center; color:#333; margin-bottom:20px; }
        .form-row { margin-bottom:15px; }
        label { display:block; font-weight:600; margin-bottom:5px; }
        input[type=text], input[type=password] { width:100%; padding:8px 10px; border-radius:6px; border:1px solid #ccc; font-size:14px; }
        .btn-login, .btn-cadastro { width:100%; padding:10px; border:none; border-radius:8px; font-weight:600; cursor:pointer; margin-top:10px; }
        .btn-login { background:#007bff; color:#fff; }
        .btn-login:hover { opacity:0.9; }
        .btn-cadastro { background:#28a745; color:#fff; }
        .btn-cadastro:hover { opacity:0.9; }
        .mensagem { color:red; text-align:center; margin-bottom:10px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <h2>Login</h2>
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <div class="form-row">
                <label>Usuário:</label>
                <asp:TextBox ID="txtUsuario" runat="server"></asp:TextBox>
            </div>
            <div class="form-row">
                <label>Senha:</label>
                <asp:TextBox ID="txtSenha" runat="server" TextMode="Password"></asp:TextBox>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Entrar" CssClass="btn-login" OnClick="btnLogin_Click" />

            <!-- Botão para ir à tela de cadastro -->
            <asp:Button ID="btnCadastro" runat="server" Text="Cadastrar Usuário" CssClass="btn-cadastro" OnClick="btnCadastro_Click" />
        </div>
    </form>
</body>
</html>
