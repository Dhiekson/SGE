<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CadastroUsuario.aspx.vb"
    Inherits="SGE.CadastroUsuario" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cadastro de Usuário</title>
    <style>
        /* --- Configuração geral --- */
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* remove a barra de rolagem */
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('../imagens/Fundo_Login.jpg') no-repeat center center fixed;
            background-size: cover; /* ajusta a imagem ao tamanho da tela */
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* --- Container do formulário --- */
        .box {
            background: rgba(255, 255, 255, 0.85);
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            width: 360px;
            text-align: center;
            backdrop-filter: blur(6px);
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
            font-size: 22px;
            font-weight: 600;
        }

        /* --- Campos de formulário --- */
        input[type=text],
        input[type=password],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            outline: none;
            transition: 0.3s ease;
        }

        input[type=text]:focus,
        input[type=password]:focus,
        select:focus {
            border-color: #007bff;
            box-shadow: 0 0 6px rgba(0, 123, 255, 0.4);
        }

        /* --- Botões --- */
        .aspNetButton, .btn-voltar {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #btnSalvar {
            background: #28a745;
            color: #fff;
            margin-top: 5px;
        }

        #btnSalvar:hover {
            background: #218838;
        }

        #btnVoltar {
            background: #007bff;
            color: #fff;
            margin-top: 8px;
        }

        #btnVoltar:hover {
            background: #0056b3;
        }

        /* --- Mensagens --- */
        .mensagem {
            margin-bottom: 10px;
        }

        .mensagem.erro {
            color: #d9534f;
            font-weight: bold;
        }

        .mensagem.sucesso {
            color: #28a745;
            font-weight: bold;
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
        <div class="box">
            <h2>Cadastro de Usuário</h2>

            <asp:Label ID="lblMensagem" runat="server" CssClass="mensagem"></asp:Label>

            <asp:TextBox ID="txtNomeUsuario" runat="server" placeholder="Nome"></asp:TextBox>
            <asp:TextBox ID="txtSenha" runat="server" TextMode="Password" placeholder="Senha"></asp:TextBox>
            <asp:TextBox ID="txtConfirmarSenha" runat="server" TextMode="Password" placeholder="Confirmar Senha"></asp:TextBox>
            <asp:TextBox ID="txtEmail" runat="server" placeholder="Email"></asp:TextBox>

            <asp:DropDownList ID="ddlFuncao" runat="server"></asp:DropDownList>

            <asp:Button ID="btnSalvar" runat="server" Text="💾 Salvar" CssClass="aspNetButton" OnClick="btnSalvar_Click" />
            <asp:Button ID="btnVoltar" runat="server" Text="⮐ Voltar à Tela de Login" CssClass="btn-voltar" OnClick="btnVoltar_Click" />
        </div>

        <footer>
            &copy; 2025 Sistema de Gestão Estoque - Todos os direitos reservados.
        </footer>
    </form>
</body>
</html>
