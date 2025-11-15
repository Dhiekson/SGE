<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="SGE.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login - SGE</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* 🔹 impede qualquer barra de rolagem */
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: url('../imagens/Fundo_Login.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(6px);
            padding: 40px 35px;
            border-radius: 16px;
            width: 360px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
            text-align: center;
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-container h2 {
            margin-bottom: 25px;
            color: #0056b3;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .form-row {
            margin-bottom: 18px;
            text-align: left;
        }

        label {
            font-weight: 600;
            color: #333;
            display: block;
            margin-bottom: 6px;
        }

        input[type=text], input[type=password] {
            width: 100%;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
            outline: none;
            transition: all 0.3s ease;
        }

        input[type=text]:focus, input[type=password]:focus {
            border-color: #007bff;
            box-shadow: 0 0 6px rgba(0, 123, 255, 0.3);
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
            transition: 0.3s;
        }

        .btn-login {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: #fff;
            margin-top: 10px;
        }

        .btn-login:hover {
            opacity: 0.95;
        }

        .btn-cadastro {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: #fff;
            margin-top: 10px;
        }

        .btn-cadastro:hover {
            opacity: 0.95;
        }

        .mensagem {
            color: #dc3545;
            font-weight: bold;
            margin-bottom: 15px;
        }

        footer {
            position: fixed;
            bottom: 10px;
            width: 100%;
            text-align: center;
            color: #fff;
            font-size: 13px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
             <div style="text-align:center; margin-bottom:20px;">
                   <img src="/imagens/slogan.png" alt="Logo SGE" style="width:200px; height:auto;" />
              </div>


            <h2>Bem-vindo ao SGE</h2>
            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <div class="form-row">
                <label>Usuário:</label>
                <asp:TextBox ID="txtUsuario" runat="server"></asp:TextBox>
            </div>

            <div class="form-row">
                <label>Senha:</label>
                <asp:TextBox ID="txtSenha" runat="server" TextMode="Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Entrar" CssClass="btn btn-login" OnClick="btnLogin_Click" />
            <asp:Button ID="btnCadastro" runat="server" Text="Cadastrar Usuário" CssClass="btn btn-cadastro" OnClick="btnCadastro_Click" />
        </div>

        <footer>
            &copy; 2025 Sistema de Gestão Estoque - Todos os direitos reservados.
        </footer>
    </form>
</body>
</html>
