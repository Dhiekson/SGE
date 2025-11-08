<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PainelConferente.aspx.vb" Inherits="SGE.PainelConferente" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Conferente</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #007bff;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header .usuario-info {
            font-size: 16px;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            text-align: center;
        }

        .btn {
            display: inline-block;
            margin: 15px;
            padding: 15px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            color: #fff;
            background-color: #28a745;
            transition: 0.3s;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-logout {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="usuario-info">
                <asp:Label ID="lblNomeUsuario" runat="server" Text=""></asp:Label> - <asp:Label ID="lblPerfilUsuario" runat="server" Text=""></asp:Label>
            </div>
            <asp:Button ID="btnSair" runat="server" Text="Sair" CssClass="btn btn-logout" OnClick="btnSair_Click" />
        </div>

        <div class="container">
            <h2>Bem-vindo ao Painel do Conferente</h2>
            <asp:Button ID="btnConferirPedidos" runat="server" Text="Conferir Pedidos" CssClass="btn" OnClick="btnConferirPedidos_Click" />
        </div>
    </form>
</body>
</html>
